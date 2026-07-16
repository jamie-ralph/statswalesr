#' Get available filters for a dataset
#'
#' Returns a list of filterable dimensions and their allowed values. Use the
#' output to build the `filter` argument for [statswales_get_dataset()],
#' [statswales_download_dataset()], and [statswales_get_pivot()].
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param lang Language for returned text. One of `"en-gb"` (default), `"en"`,
#'   `"cy-gb"`, or `"cy"`.
#'
#' @return A list where each element corresponds to a filterable dimension and
#'   contains:
#'   \describe{
#'     \item{`factTableColumn`}{Internal column name used in data queries.}
#'     \item{`columnName`}{Human-readable dimension name — use this as the key
#'       in filter objects.}
#'     \item{`values`}{A data frame of available filter values with columns
#'       `reference`, `description`, `parent`, and `level`. Hierarchical
#'       dimensions (e.g. Wales → local authorities → wards) are flattened into
#'       this data frame: `parent` holds the reference of the parent value (`NA`
#'       at the top level) and `level` is the 1-based depth. Any value's
#'       `reference` can be used in a filter.}
#'   }
#'   Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' filters <- statswales_get_filters(datasets$id[1])
#'
#' # See available values for the first dimension
#' filters[[1]]$columnName
#' filters[[1]]$values
#'
#' # Use a filter value in a data query
#' df <- statswales_get_dataset(
#'   datasets$id[1],
#'   filter = list(list(
#'     Year = filters[[1]]$values$reference[1:2]
#'   ))
#' )
#' }
#'
#' @export
statswales_get_filters <- function(dataset_id, lang = "en-gb") {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1
  )
  .sw_validate_lang(lang)

  result <- .sw_get(paste0(dataset_id, "/filters"), list(lang = lang))
  if (is.null(result)) return(NULL)

  lapply(result, function(f) {
    list(
      factTableColumn = .null_chr(f$factTableColumn),
      columnName      = .null_chr(f$columnName),
      values          = .sw_flatten_filter_values(f$values)
    )
  })
}
