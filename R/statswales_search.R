#' Search published datasets
#'
#' Full-text search across dataset titles and summaries. Returns results
#' ranked by relevance.
#'
#' @param keywords Search query string.
#' @param lang Language for returned text. One of `"en-gb"` (default), `"en"`,
#'   `"cy-gb"`, or `"cy"`.
#' @param page_number Page number to return. Default `1`.
#' @param page_size Number of results per page. Default `100`.
#' @param mode Search algorithm. One of `"basic"` (default), `"basic_split"`,
#'   `"fts"`, `"fts_simple"`, or `"fuzzy"`. The `fts` and `fts_simple` modes
#'   return highlighted matches in `match_title` and `match_summary` columns.
#'
#' @return A data frame with columns `id`, `title`, `summary`,
#'   `first_published_at`, `last_updated_at`, and `archived_at`. Timestamp
#'   columns are `POSIXct` (UTC). The `fts` and `fts_simple` modes also return
#'   `rank`, `match_title`, and `match_summary`. Returns `NULL` if the request
#'   fails.
#'
#' @examples
#' \dontrun{
#' results <- statswales_search("hospital")
#' results_cy <- statswales_search("ysbyty", lang = "cy-gb")
#' results_fuzzy <- statswales_search("transprt", mode = "fuzzy")
#' }
#'
#' @export
statswales_search <- function(keywords,
                              lang        = "en-gb",
                              page_number = 1,
                              page_size   = 100,
                              mode        = "basic") {
  stopifnot(
    "keywords must be a string"       = is.character(keywords),
    "keywords must be a single value" = length(keywords) == 1
  )
  .sw_validate_lang(lang)
  mode <- match.arg(mode, c("basic", "basic_split", "fts", "fts_simple", "fuzzy"))

  result <- .sw_get(
    "search",
    list(keywords = keywords, lang = lang,
         page_number = page_number, page_size = page_size, mode = mode)
  )
  if (is.null(result)) return(NULL)

  items <- result$data
  if (length(items) == 0) return(data.frame())

  df <- data.frame(
    id                 = vapply(items, function(x) .null_chr(x$id), character(1)),
    title              = vapply(items, function(x) .null_chr(x$title), character(1)),
    summary            = vapply(items, function(x) .null_chr(x$summary), character(1)),
    first_published_at = vapply(items, function(x) .null_chr(x$first_published_at), character(1)),
    last_updated_at    = vapply(items, function(x) .null_chr(x$last_updated_at), character(1)),
    archived_at        = vapply(items, function(x) .null_chr(x$archived_at), character(1)),
    stringsAsFactors   = FALSE
  )
  df$first_published_at <- .sw_parse_time(df$first_published_at)
  df$last_updated_at    <- .sw_parse_time(df$last_updated_at)
  df$archived_at        <- .sw_parse_time(df$archived_at)

  if (mode %in% c("fts", "fts_simple")) {
    df$rank          <- vapply(items, function(x) x$rank %||% NA_real_, numeric(1))
    df$match_title   <- vapply(items, function(x) .null_chr(x$match_title), character(1))
    df$match_summary <- vapply(items, function(x) .null_chr(x$match_summary), character(1))
  }

  message("Found ", result$count, " matching datasets; returning ",
          nrow(df), " (page ", page_number, ").")
  df
}
