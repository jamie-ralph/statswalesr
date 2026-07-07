#' Download a dataset file
#'
#' Downloads a published dataset as a file. The `filter` and `options`
#' arguments work identically to [statswales_get_dataset()].
#'
#' @param dataset_id A dataset UUID string. Use [statswales_list_datasets()] to
#'   find dataset IDs.
#' @param format File format. One of `"csv"` (default) or `"xlsx"`.
#' @param lang Language for the downloaded file. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#' @param path File path for saving the download. If `NULL` (default), a
#'   temporary file is created automatically.
#' @param filter Filter criteria in the same format as [statswales_get_dataset()].
#' @param options Display options in the same format as [statswales_get_dataset()].
#'
#' @return The path to the downloaded file, invisibly. Returns `NULL` if the
#'   download fails.
#'
#' @examples
#' \dontrun{
#' datasets <- statswales_list_datasets()
#' id <- datasets$id[1]
#'
#' # Download full dataset as CSV
#' path <- statswales_download_dataset(id)
#' df <- read.csv(path)
#'
#' # Download filtered data as Excel
#' statswales_download_dataset(
#'   id,
#'   format = "xlsx",
#'   filter = list(list(Year = c("2022", "2023"))),
#'   path = "my_data.xlsx"
#' )
#' }
#'
#' @export
statswales_download_dataset <- function(dataset_id,
                                        format  = "csv",
                                        lang    = "en-gb",
                                        path    = NULL,
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
  .sw_validate_lang(lang)
  format <- match.arg(format, c("csv", "xlsx"))

  if (is.null(path)) {
    path <- tempfile(fileext = paste0(".", format))
  }

  body        <- .sw_build_body(filter, options)
  post_result <- .sw_post(paste0(dataset_id, "/data"), body)
  if (is.null(post_result)) return(NULL)

  url <- paste0(BASE_URL, "/", dataset_id, "/data/", post_result$filterId)

  req <- httr2::request(url) |>
    httr2::req_user_agent("statswalesr (https://github.com/jamie-ralph/statswalesr)") |>
    httr2::req_url_query(lang = lang, format = format) |>
    httr2::req_error(is_error = \(resp) FALSE)

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
    message("API returned HTTP ", status, " downloading dataset: ", dataset_id)
    return(NULL)
  }

  message("Downloaded to: ", path)
  invisible(path)
}
