#' Retrieve a pivot table for a dataset
#'
#' Returns a cross-tabulated view of dataset data. Choose one dimension for
#' the columns (`x`) and one for the rows (`y`). The API stores the pivot
#' configuration as a reusable query.
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param x Column name for the horizontal axis (column headers).
#' @param y Column name for the vertical axis (row labels).
#' @param lang Language for returned text. One of `"en-gb"` (default), `"en"`,
#'   `"cy-gb"`, or `"cy"`.
#' @param page_number Page number to return. Default `1`.
#' @param page_size Rows per page. Default `100`.
#' @param filter Filter criteria in the same format as [statswales_get_dataset()].
#' @param options Display options in the same format as [statswales_get_dataset()].
#' @param sort_by Optional sort order, in the same format as
#'   [statswales_get_dataset()].
#'
#' @return A list containing the paginated pivot view returned by the API, or
#'   `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' id <- datasets$id[1]
#' filters <- statswales_get_filters(id)
#'
#' pivot <- statswales_get_pivot(
#'   id,
#'   x = filters[[1]]$columnName,
#'   y = filters[[2]]$columnName
#' )
#' }
#'
#' @export
statswales_get_pivot <- function(dataset_id,
                                 x,
                                 y,
                                 lang        = "en-gb",
                                 page_number = 1,
                                 page_size   = 100,
                                 filter      = NULL,
                                 options     = list(
                                   use_raw_column_names = FALSE,
                                   use_reference_values = FALSE,
                                   data_value_type      = "formatted"
                                 ),
                                 sort_by     = NULL) {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1,
    "x must be a single string"         = is.character(x) && length(x) == 1,
    "y must be a single string"         = is.character(y) && length(y) == 1
  )
  .sw_validate_lang(lang)

  base_body        <- .sw_build_body(filter, options)
  body             <- c(base_body, list(pivot = list(x = x, y = y)))
  post_result      <- .sw_post(paste0(dataset_id, "/pivot"), body)
  if (is.null(post_result)) return(NULL)

  filter_id <- post_result$filterId
  path      <- paste0(dataset_id, "/pivot/", filter_id)
  query     <- list(lang = lang, format = "json",
                    page_number = page_number, page_size = page_size)

  sort_str <- .sw_format_sort(sort_by)
  if (!is.null(sort_str)) query$sort_by <- sort_str

  .sw_get(path, query)
}
