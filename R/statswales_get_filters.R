#' Get available filters for a dataset
#'
#' Returns a list of filter options that can be applied when retrieving a
#' dataset with [statswales_get_dataset()].
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#'
#' @return A list where each element corresponds to a filterable column and
#'   contains:
#'   \describe{
#'     \item{`factTableColumn`}{Internal column name used in filter queries.}
#'     \item{`columnName`}{Human-readable column name.}
#'     \item{`values`}{A data frame of available filter values with columns
#'       `reference` and `description`.}
#'   }
#'   Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' filters <- statswales_get_filters(datasets$id[1])
#'
#' # Inspect available values for the first filter
#' filters[[1]]$values
#' }
#'
#' @export
statswales_get_filters <- function(dataset_id, lang = "en-gb") {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1
  )
  .sw_validate_lang(lang)

  result <- .sw_get(paste0(dataset_id, "/view/filters"), list(lang = lang))
  if (is.null(result)) return(NULL)

  lapply(result, function(f) {
    values_df <- if (length(f$values) > 0) {
      data.frame(
        reference   = vapply(f$values, function(v) .null_chr(v$reference), character(1)),
        description = vapply(f$values, function(v) .null_chr(v$description), character(1)),
        stringsAsFactors = FALSE
      )
    } else {
      data.frame(reference = character(0), description = character(0))
    }

    list(
      factTableColumn = .null_chr(f$factTableColumn),
      columnName      = .null_chr(f$columnName),
      values          = values_df
    )
  })
}
