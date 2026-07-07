#' Inspect a stored query configuration
#'
#' Returns the full configuration of a stored query, including the applied
#' filters, total row count, column mappings, and the underlying SQL.
#' The `filter_id` is returned by any call to [statswales_get_dataset()] (via
#' the `POST /data` step) or [statswales_get_pivot()].
#'
#' To retrieve the `filter_id` directly, call [statswales_create_query()].
#'
#' @param dataset_id A dataset UUID string.
#' @param filter_id A 12-character query identifier returned by the API.
#'
#' @return A list containing the stored query details:
#'   \describe{
#'     \item{`id`}{The filter ID.}
#'     \item{`totalLines`}{Total number of rows matching the query.}
#'     \item{`requestObject`}{The filter and options that were submitted.}
#'     \item{`columnMapping`}{Mapping between internal column names and display
#'       names, per language.}
#'     \item{`query`}{A named list of SQL strings keyed by language code.}
#'   }
#'   Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' id <- datasets$id[1]
#'
#' fid <- statswales_create_query(id)
#' query_info <- statswales_get_query(id, fid)
#' query_info$totalLines
#' }
#'
#' @export
statswales_get_query <- function(dataset_id, filter_id) {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1,
    "filter_id must be a string"        = is.character(filter_id),
    "filter_id must be a single value"  = length(filter_id) == 1
  )

  .sw_get(paste0(dataset_id, "/query/", filter_id))
}
