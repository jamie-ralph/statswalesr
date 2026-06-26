#' Download a dataset file
#'
#' Downloads a published dataset in a specified file format and saves it to
#' disk. Useful for large datasets where you want to work with the raw file
#' rather than loading the data directly into R.
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param format File format. One of `"csv"` (default), `"json"`, or `"xlsx"`.
#' @param lang Language for the downloaded file. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#' @param path File path to save the download. If `NULL` (default), a
#'   temporary file is created automatically.
#' @param filter A list of filter criteria to apply before downloading. Use
#'   [statswales_get_filters()] to discover available filter options.
#'
#' @return The path to the downloaded file, invisibly. Returns `NULL` if the
#'   download fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' id <- datasets$id[1]
#'
#' # Download as CSV to a temporary file
#' path <- statswales_download_dataset(id)
#' df <- read.csv(path)
#'
#' # Download as Excel to a specific location
#' statswales_download_dataset(id, format = "xlsx", path = "data/my_dataset.xlsx")
#' }
#'
#' @export
statswales_download_dataset <- function(dataset_id,
                                        format = "csv",
                                        lang   = "en-gb",
                                        path   = NULL,
                                        filter = NULL) {
  stopifnot(
    "dataset_id must be a string"       = is.character(dataset_id),
    "dataset_id must be a single value" = length(dataset_id) == 1
  )
  .sw_validate_lang(lang)
  format <- match.arg(format, c("csv", "json", "xlsx"))

  if (is.null(path)) {
    path <- tempfile(fileext = paste0(".", format))
  }

  query <- list(lang = lang)
  if (!is.null(filter)) {
    query$filter <- jsonlite::toJSON(filter, auto_unbox = TRUE)
  }

  url <- paste0(BASE_URL, "/", dataset_id, "/download/", format)
  req <- httr2::request(url) |>
    httr2::req_user_agent("statswalesr (https://github.com/jamie-ralph/statswalesr)") |>
    httr2::req_error(is_error = \(resp) FALSE)

  if (length(query) > 0) {
    req <- do.call(httr2::req_url_query, c(list(.req = req), query))
  }

  resp <- tryCatch(
    httr2::req_perform(req, path = path),
    httr2_failure = function(e) {
      message("Download failed: ", conditionMessage(e))
      NULL
    },
    error = function(e) {
      message("Download error: ", conditionMessage(e))
      NULL
    }
  )

  if (is.null(resp)) return(NULL)

  status <- httr2::resp_status(resp)
  if (status >= 400) {
    message("API returned HTTP ", status, " for dataset: ", dataset_id)
    return(NULL)
  }

  message("Downloaded to: ", path)
  invisible(path)
}
