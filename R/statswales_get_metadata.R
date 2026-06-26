#' Get metadata for a dataset
#'
#' Returns full metadata for a published dataset including revision history,
#' publication dates, and dimension information.
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#'
#' @return A list containing dataset metadata. Returns `NULL` if the request
#'   fails or the dataset is not found.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' meta <- statswales_get_metadata(datasets$id[1])
#' }
#'
#' @export
statswales_get_metadata <- function(dataset_id, lang = "en-gb") {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1
  )
  .sw_validate_lang(lang)

  .sw_get(dataset_id, list(lang = lang))
}
