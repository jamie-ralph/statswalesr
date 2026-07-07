#' Retrieve data for a dataset
#'
#' Returns a data frame containing rows from a published dataset. Filters and
#' display options are submitted to the API as a stored query; the same inputs
#' always produce the same query ID so repeated calls are efficient.
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param lang Language for text values. One of `"en-gb"` (default), `"en"`,
#'   `"cy-gb"`, or `"cy"`.
#' @param page_number Page of results to return. Default `1`. Ignored when
#'   `all_pages = TRUE`.
#' @param page_size Rows per page. Default `100`; max `10000`.
#' @param filter A list of filter objects. Each element is a named list mapping
#'   a column name (from [statswales_get_filters()]) to a character vector of
#'   reference codes. Multiple list elements use AND logic; multiple codes
#'   within one element use OR logic. Example:
#'   `list(list(Year = c("2020", "2021")), list(Area = c("W92000004")))`.
#' @param options A named list of display options:
#'   \describe{
#'     \item{`use_raw_column_names`}{`FALSE` (default) returns human-readable
#'       column names; `TRUE` returns internal fact-table names.}
#'     \item{`use_reference_values`}{`FALSE` (default) returns human-readable
#'       values; `TRUE` returns reference codes.}
#'     \item{`data_value_type`}{One of `"raw"`, `"raw_extended"`,
#'       `"formatted"` (default), `"formatted_extended"`, or
#'       `"with_note_codes"`.}
#'   }
#' @param sort_by Optional sort order. Either a ready-made string in the API's
#'   `"column:direction"` format (e.g. `"Year:desc"`), or a named character
#'   vector such as `c(Year = "desc", Area = "asc")`. Directions are `"asc"` or
#'   `"desc"`.
#' @param all_pages If `TRUE`, automatically fetches and row-binds all pages.
#'   Default `FALSE`.
#'
#' @return A data frame of dataset rows, or `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' id <- datasets$id[1]
#'
#' # First page, human-readable (default)
#' df <- statswales_get_dataset(id)
#'
#' # All pages
#' df_full <- statswales_get_dataset(id, all_pages = TRUE)
#'
#' # Filtered to specific years
#' filters <- statswales_get_filters(id)
#' df_filtered <- statswales_get_dataset(
#'   id,
#'   filter = list(list(Year = c("2020", "2021")))
#' )
#' }
#'
#' @export
statswales_get_dataset <- function(dataset_id,
                                   lang        = "en-gb",
                                   page_number = 1,
                                   page_size   = 100,
                                   filter      = NULL,
                                   options     = list(
                                     use_raw_column_names = FALSE,
                                     use_reference_values = FALSE,
                                     data_value_type      = "formatted"
                                   ),
                                   sort_by     = NULL,
                                   all_pages   = FALSE) {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1
  )
  .sw_validate_lang(lang)

  body        <- .sw_build_body(filter, options)
  post_result <- .sw_post(paste0(dataset_id, "/data"), body)
  if (is.null(post_result)) return(NULL)

  path  <- paste0(dataset_id, "/data/", post_result$filterId)
  total <- post_result$totalLines %||% NULL
  query <- list(lang = lang, format = "json",
                page_number = page_number, page_size = page_size)

  sort_str <- .sw_format_sort(sort_by)
  if (!is.null(sort_str)) query$sort_by <- sort_str

  if (all_pages) {
    message("Fetching all pages...")
    .sw_fetch_all_pages(path, query, page_size)
  } else {
    result <- .sw_get(path, query, simplify = TRUE)
    if (!is.null(total) && is.data.frame(result) && nrow(result) < total) {
      message(nrow(result), " rows returned (", total, " total). ",
              "Set all_pages = TRUE to retrieve the full dataset.")
    }
    result
  }
}
