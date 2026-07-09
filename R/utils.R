BASE_URL <- "https://api.stats.gov.wales/v2"

# Internal GET. Returns parsed list (simplify=FALSE) or data frame (simplify=TRUE).
.sw_get <- function(path, query = list(), simplify = FALSE) {
  url <- if (nchar(path) == 0) BASE_URL else paste0(BASE_URL, "/", path)

  req <- httr2::request(url) |>
    httr2::req_user_agent("statswalesr (https://github.com/jamie-ralph/statswalesr)") |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_error(is_error = \(resp) FALSE)

  if (length(query) > 0) {
    req <- do.call(httr2::req_url_query, c(list(.req = req), query))
  }

  resp <- tryCatch(
    httr2::req_perform(req),
    httr2_failure = function(e) {
      message("Could not connect to the StatsWales API: ", conditionMessage(e))
      NULL
    },
    error = function(e) {
      message("Request error: ", conditionMessage(e))
      NULL
    }
  )

  if (is.null(resp)) return(NULL)

  status <- httr2::resp_status(resp)
  if (status >= 400) {
    message("API returned HTTP ", status, " for: ", url)
    return(NULL)
  }

  if (simplify) {
    jsonlite::fromJSON(httr2::resp_body_string(resp), simplifyVector = TRUE)
  } else {
    httr2::resp_body_json(resp)
  }
}

# Internal POST. Returns parsed JSON list or NULL on failure.
.sw_post <- function(path, body = list()) {
  url <- paste0(BASE_URL, "/", path)

  req <- httr2::request(url) |>
    httr2::req_method("POST") |>
    httr2::req_body_json(body, auto_unbox = TRUE) |>
    httr2::req_user_agent("statswalesr (https://github.com/jamie-ralph/statswalesr)") |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_error(is_error = \(resp) FALSE)

  resp <- tryCatch(
    httr2::req_perform(req),
    httr2_failure = function(e) {
      message("Could not connect to the StatsWales API: ", conditionMessage(e))
      NULL
    },
    error = function(e) {
      message("Request error: ", conditionMessage(e))
      NULL
    }
  )

  if (is.null(resp)) return(NULL)

  status <- httr2::resp_status(resp)
  if (status >= 400) {
    message("API returned HTTP ", status, " for: ", url)
    return(NULL)
  }

  httr2::resp_body_json(resp)
}

# Validate lang parameter.
.sw_validate_lang <- function(lang) {
  valid <- c("en", "en-gb", "cy", "cy-gb")
  if (!lang %in% valid) {
    stop("`lang` must be one of: ", paste(valid, collapse = ", "), call. = FALSE)
  }
}

# Convert NULL to NA_character_; otherwise coerce to character.
.null_chr <- function(x) if (is.null(x)) NA_character_ else as.character(x)

`%||%` <- function(x, y) if (is.null(x)) y else x

# Format a sort_by argument into the API's "col:dir,col2:dir2" string.
# Accepts NULL, a ready-made string (e.g. "Year:asc"), or a named character
# vector like c(Year = "asc", Area = "desc").
.sw_format_sort <- function(sort_by) {
  if (is.null(sort_by)) return(NULL)
  if (is.null(names(sort_by))) {
    return(paste(as.character(sort_by), collapse = ","))
  }
  dirs <- tolower(as.character(sort_by))
  if (!all(dirs %in% c("asc", "desc"))) {
    stop("sort_by directions must be 'asc' or 'desc'", call. = FALSE)
  }
  paste(paste0(names(sort_by), ":", dirs), collapse = ",")
}

# Recursively flatten hierarchical filter values into a single data frame.
# Adds `parent` (parent reference, NA at top level) and `level` (1-based depth).
.sw_flatten_filter_values <- function(values, parent = NA_character_, level = 1L) {
  empty <- data.frame(
    reference = character(0), description = character(0),
    parent = character(0), level = integer(0), stringsAsFactors = FALSE
  )
  if (length(values) == 0) return(empty)

  rows <- list()
  for (v in values) {
    rows[[length(rows) + 1L]] <- data.frame(
      reference   = .null_chr(v$reference),
      description = .null_chr(v$description),
      parent      = parent,
      level       = level,
      stringsAsFactors = FALSE
    )
    if (!is.null(v$children) && length(v$children) > 0) {
      rows[[length(rows) + 1L]] <- .sw_flatten_filter_values(
        v$children, parent = .null_chr(v$reference), level = level + 1L
      )
    }
  }
  do.call(rbind, rows)
}

# Tidy a data frame returned by the data endpoint: drop the API's internal
# *_sort columns, strip whitespace padding, and convert numeric-looking
# columns (including comma-separated thousands) to numeric.
.sw_tidy_data <- function(df) {
  if (!is.data.frame(df) || ncol(df) == 0) return(df)
  df <- df[, !grepl("_sort$", names(df)), drop = FALSE]
  for (col in names(df)) {
    if (!is.character(df[[col]])) next
    x <- trimws(df[[col]])
    x[x == ""] <- NA_character_
    no_comma <- gsub(",", "", x, fixed = TRUE)
    ok <- !is.na(no_comma)
    if (any(ok) && all(grepl("^-?[0-9]+(\\.[0-9]+)?$", no_comma[ok]))) {
      df[[col]] <- as.numeric(no_comma)
    } else {
      df[[col]] <- x
    }
  }
  df
}

# Parse ISO 8601 timestamps (e.g. "2026-07-07T08:30:00.000Z") to POSIXct (UTC).
.sw_parse_time <- function(x) {
  as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%OS", tz = "UTC")
}

# Build a DataOptions body for POST /data or POST /pivot.
# Ensures filter values are always JSON arrays (not unboxed scalars).
.sw_build_body <- function(filter, options) {
  filters <- if (is.null(filter) || length(filter) == 0) {
    list()
  } else {
    lapply(filter, function(f) lapply(f, as.list))
  }
  list(filters = filters, options = options)
}

# Fetch all pages of a data endpoint and combine into one data frame.
.sw_fetch_all_pages <- function(path, query, page_size) {
  pages <- list()
  p <- as.integer(query$page_number %||% 1L)
  repeat {
    query$page_number <- p
    result <- .sw_get(path, query, simplify = TRUE)
    if (is.null(result) || (is.data.frame(result) && nrow(result) == 0)) break
    pages[[length(pages) + 1L]] <- result
    if (!is.data.frame(result) || nrow(result) < page_size) break
    p <- p + 1L
  }
  if (length(pages) == 0) return(data.frame())
  do.call(rbind, pages)
}
