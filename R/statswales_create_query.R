#' Create a stored query and return its filter ID
#'
#' Submits a set of filters and display options to the API and returns the
#' resulting filter ID. The same inputs always produce the same ID, so this
#' is useful for building shareable, reproducible data requests.
#'
#' Pass the returned `filter_id` to [statswales_get_query()] to inspect the
#' query configuration, or use it directly in [statswales_get_dataset()] /
#' [statswales_download_dataset()] workflows.
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param filter Filter criteria in the same format as [statswales_get_dataset()].
#' @param options Display options in the same format as [statswales_get_dataset()].
#'
#' @return A character string containing the 12-character filter ID, or `NULL`
#'   if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' id <- datasets$id[1]
#'
#' fid <- statswales_create_query(id)
#' statswales_get_query(id, fid)
#' }
#'
#' @export
statswales_create_query <- function(dataset_id,
                                    filter  = NULL,
                                    options = list(
                                      use_raw_column_names = FALSE,
                                      use_reference_values = FALSE,
                                      data_value_type      = "formatted"
                                    )) {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1
  )

  body   <- .sw_build_body(filter, options)
  result <- .sw_post(paste0(dataset_id, "/data"), body)
  if (is.null(result)) return(NULL)
  result$filterId
}
