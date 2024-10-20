#' Retrieves a dataset from StatsWales
#'
#' \code{statswales_get_dataset} returns a dataframe from
#' \href{https://statswales.gov.wales}{StatsWales} using a dataset id. The
#' \code{print_progress} argument can be set to \code{TRUE} to keep track of
#' progress when extracting a large dataset.
#'
#' @param id A dataset id. Must be a single string.
#' @return If the dataset id is valid, the function will return the requested
#' dataset in a dataframe. If the id is not valid, the function will return
#' NULL.
#' @examples
#' data <- statswales_get_dataset("LGFS0021")
#'
#'
#' @importFrom rlang .data
#' @export

statswales_get_dataset <- function(id) {

  # Check for a valid id string
  stopifnot('Dataset id must be a string'       = is.character(id),
            'Dataset id should be a single value' = length(id) == 1
  )

  # Check for internet connection --------------------------------------------

  if (!curl::has_internet()) {
    message("No internet connection found.")
    return(NULL)
  }

  # Define dataset URL --------------------------------------------------------

  url <- paste0(
    "https://statswales.gov.wales/Download/File?fileName=",
    toupper(id),
    ".zip"
  )

  # Check that dataset resource is available ------------------------------
  request <- tryCatch(
    {
      ua <- httr::user_agent("https://github.com/jamie-ralph/statswalesr")
      temp_file <- tempfile(fileext = ".zip")
      utils::download.file(
        url,
        destfile = temp_file,
        mode = "wb",
        headers = ua
      )
      temp_dir <- tempdir()
      utils::unzip(temp_file, exdir = temp_dir)
      readr::read_csv(sprintf("%s/%s.csv", temp_dir, id))
    },
    error = function(cnd) {
      return(NULL)
    }
  )

  # Exit function if API didn't respond ------------------------------
  if(is.null(request)) {
    message(
      "There was a problem downloading data from StatsWales. ",
      "Please check if your dataset ID is correct."
    )
    return(NULL)
  }

  message("Dataset extracted successfully with ", nrow(request), " rows and ",
          ncol(request), " columns.")

  # Return the dataframe ----
  request

}
