#' List all published datasets
#'
#' Returns a data frame of all published datasets available from the
#' [StatsWales public API](https://api.stats.gov.wales/v2). All pages are
#' fetched automatically, so the full catalogue is returned.
#'
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#'
#' @return A data frame with columns `id`, `title`, `first_published_at`,
#'   `last_updated_at`, and `archived_at`. Timestamp columns are `POSIXct`
#'   (UTC). Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' datasets_cy <- statswales_list_datasets(lang = "cy-gb")
#' }
#'
#' @export
statswales_list_datasets <- function(lang = "en-gb") {
  .sw_validate_lang(lang)

  page_size <- 1000
  pages     <- list()
  p         <- 1L
  count     <- NULL

  repeat {
    result <- .sw_get("", list(lang = lang, page_number = p, page_size = page_size))
    if (is.null(result)) {
      if (length(pages) == 0) return(NULL)
      break
    }

    items <- result$data
    count <- result$count %||% count
    if (length(items) == 0) break

    pages[[length(pages) + 1L]] <- data.frame(
      id                 = vapply(items, function(x) .null_chr(x$id), character(1)),
      title              = vapply(items, function(x) .null_chr(x$title), character(1)),
      first_published_at = vapply(items, function(x) .null_chr(x$first_published_at), character(1)),
      last_updated_at    = vapply(items, function(x) .null_chr(x$last_updated_at), character(1)),
      archived_at        = vapply(items, function(x) .null_chr(x$archived_at), character(1)),
      stringsAsFactors   = FALSE
    )

    if (length(items) < page_size) break
    p <- p + 1L
  }

  if (length(pages) == 0) return(data.frame())

  df <- do.call(rbind, pages)
  df$first_published_at <- .sw_parse_time(df$first_published_at)
  df$last_updated_at    <- .sw_parse_time(df$last_updated_at)
  df$archived_at        <- .sw_parse_time(df$archived_at)

  message("Retrieved ", nrow(df), " datasets.")
  df
}
