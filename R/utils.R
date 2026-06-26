BASE_URL <- "https://api.stats.gov.wales/v1"

# Internal GET helper. Returns parsed JSON list or NULL on failure.
.sw_get <- function(path, query = list()) {
  url <- if (nchar(path) == 0) BASE_URL else paste0(BASE_URL, "/", path)

  req <- httr2::request(url) |>
    httr2::req_user_agent("statswalesr (https://github.com/jamie-ralph/statswalesr)") |>
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

  httr2::resp_body_json(resp)
}

# Validate lang parameter against accepted values.
.sw_validate_lang <- function(lang) {
  valid <- c("en", "en-gb", "cy", "cy-gb")
  if (!lang %in% valid) {
    stop("`lang` must be one of: ", paste(valid, collapse = ", "), call. = FALSE)
  }
}

# Convert NULL to NA_character_; otherwise coerce to character.
.null_chr <- function(x) if (is.null(x)) NA_character_ else as.character(x)

`%||%` <- function(x, y) if (is.null(x)) y else x

# Parse a DatasetView response into a data frame.
.sw_view_to_df <- function(view) {
  if (length(view$data) == 0) return(data.frame())
  headers <- vapply(view$headers, function(h) h$name, character(1))
  rows <- lapply(view$data, function(row) as.character(unlist(row)))
  df <- as.data.frame(do.call(rbind, rows), stringsAsFactors = FALSE)
  colnames(df) <- headers
  df
}
