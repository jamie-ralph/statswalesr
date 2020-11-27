#' Retrieve metadata of a dataset from StatsWales
#'
#' \code{statswales_get_metadata} returns a dataframe containing metadata from
#' \href{https://statswales.gov.wales}{StatsWales} using a dataset id.
#'
#' @param id A dataset id as a string
#' @return If the dataset id is valid, the output will be
#'     the requested metadata in a dataframe. If the id is not
#'     valid, the function will return an HTTP error.
#' @examples
#' metadata <- statswales_get_metadata("hlth0515")
#'
#' @export
statswales_get_metadata <- function(id) {

  stopifnot("Only one id should be passed to statswales_get_metadata" = length(id) == 1,
            "Dataset id must be a string"                             = is.character(id))

  # Check for internet connection --------------------------------------------

  if (!curl::has_internet()) {
    message("No internet connection found.")
    return(NULL)
  }

  # Define url containing metadata in JSON format --------------------------
  url <- paste0("http://open.statswales.gov.wales/en-gb/discover/metadata?$filter=Dataset%20eq%20%27",
                tolower(id), "%27")

  # Extract metadata list ----------------------------------------------------
  json_data <- jsonlite::fromJSON(url)

  # Check that metadata has been returned ---------------------------------
  if (nrow(json_data$value) < 1) {
    message("Metadata was not found. Check your dataset id for typos. If your dataset id is correct, the API might be unavailable.")

    return(NULL)
  }

  # Extract metadata dataframe --------------------------------------------
  metadata <- json_data$value

  # Return metadata ------------------------------------------------------
  metadata
}

