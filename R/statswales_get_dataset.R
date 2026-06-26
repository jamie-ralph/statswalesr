#' Retrieve a dataset from StatsWales
#'
#' Returns a data frame containing data from a published dataset. By default
#' returns the first page of results; set `all_pages = TRUE` to retrieve the
#' complete dataset automatically.
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#' @param page_number Page number to return. Default `1`. Ignored when
#'   `all_pages = TRUE`.
#' @param page_size Number of rows per page. Default `100`.
#' @param filter A list of filter criteria to apply. Each element should be a
#'   named list with `factTableColumn` and `values`. Use
#'   [statswales_get_filters()] to discover available filter options.
#' @param all_pages If `TRUE`, automatically fetches and combines all pages of
#'   results. Default `FALSE`.
#'
#' @return A data frame of dataset rows. Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' id <- datasets$id[1]
#'
#' # First page only
#' df <- statswales_get_dataset(id)
#'
#' # All pages
#' df_full <- statswales_get_dataset(id, all_pages = TRUE)
#'
#' # With a filter
#' filters <- statswales_get_filters(id)
#' df_filtered <- statswales_get_dataset(
#'   id,
#'   filter = list(list(
#'     factTableColumn = filters[[1]]$factTableColumn,
#'     values = list(filters[[1]]$values$reference[1])
#'   ))
#' )
#' }
#'
#' @export
statswales_get_dataset <- function(dataset_id,
                                   lang        = "en-gb",
                                   page_number = 1,
                                   page_size   = 100,
                                   filter      = NULL,
                                   all_pages   = FALSE) {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1
  )
  .sw_validate_lang(lang)

  query <- list(lang = lang, page_number = page_number, page_size = page_size)
  if (!is.null(filter)) {
    query$filter <- jsonlite::toJSON(filter, auto_unbox = TRUE)
  }

  path   <- paste0(dataset_id, "/view")
  result <- .sw_get(path, query)
  if (is.null(result)) return(NULL)

  df          <- .sw_view_to_df(result)
  total_pages <- result$total_pages %||% 1L

  if (all_pages && total_pages > 1L) {
    message("Fetching all ", total_pages, " pages...")
    for (p in seq(2L, total_pages)) {
      query$page_number <- p
      page_result       <- .sw_get(path, query)
      if (!is.null(page_result)) {
        df <- rbind(df, .sw_view_to_df(page_result))
      }
    }
  } else if (!all_pages && total_pages > 1L) {
    total_records <- result$page_info$total_records %||% "unknown"
    message(
      "Page ", page_number, " of ", total_pages,
      " (", total_records, " total records). ",
      "Set all_pages = TRUE to retrieve the full dataset."
    )
  }

  df
}
