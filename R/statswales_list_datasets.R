#' List all published datasets
#'
#' Returns a data frame of all published datasets available from the
#' [StatsWales public API](https://api.stats.gov.wales/v1).
#'
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#' @param page_number Page number to return. Default `1`.
#' @param page_size Number of datasets per page. Default `100`.
#'
#' @return A data frame with columns `id`, `title`, `first_published_at`,
#'   `last_updated_at`, and `archived_at`. Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' datasets_cy <- statswales_list_datasets(lang = "cy-gb")
#' }
#'
#' @export
statswales_list_datasets <- function(lang = "en-gb", page_number = 1, page_size = 100) {
  .sw_validate_lang(lang)
  stopifnot(
    "page_number must be a positive integer" = is.numeric(page_number) && page_number >= 1,
    "page_size must be a positive integer"   = is.numeric(page_size) && page_size >= 1
  )

  result <- .sw_get("", list(lang = lang, page_number = page_number, page_size = page_size))
  if (is.null(result)) return(NULL)

  items <- result$data
  if (length(items) == 0) return(data.frame())

  df <- data.frame(
    id                 = vapply(items, function(x) .null_chr(x$id), character(1)),
    title              = vapply(items, function(x) .null_chr(x$title), character(1)),
    first_published_at = vapply(items, function(x) .null_chr(x$first_published_at), character(1)),
    last_updated_at    = vapply(items, function(x) .null_chr(x$last_updated_at), character(1)),
    archived_at        = vapply(items, function(x) .null_chr(x$archived_at), character(1)),
    stringsAsFactors   = FALSE
  )

  message("Retrieved ", nrow(df), " of ", result$count, " datasets (page ", page_number, ").")
  df
}
