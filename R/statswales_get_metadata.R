#' Retrieve metadata of a dataset from StatsWales
#'
#' \code{statswales_get_metadata} returns a dataframe containing metadata from
#' \href{https://statswales.gov.wales}{StatsWales} using a dataset id.
#'
#' @param id A dataset id as a string
#' @param language A string. Returns the metadata in either English ('english') or Welsh ('welsh')
#' @return If the dataset id is valid, the output will be
#'     the requested metadata in a dataframe. If the id is not
#'     valid, the function will return an HTTP error.
#' @examples
#' metadata <- statswales_get_metadata("hlth0515")
#'
#'
#' @export
statswales_get_metadata <- function(id, language = 'english') {

  # Check for a valid id string
  stopifnot("Dataset id should be a single value" = length(id) == 1,
            "Dataset id must be a string" = is.character(id))

  # Check for valid language setting
  stopifnot(
    'Please set the language parameter to "english" or "welsh"' = language %in% c("english", "welsh"),
    'Please choose one language per download.' = length(language) == 1
  )

  # Check for internet connection --------------------------------------------

  if (!curl::has_internet()) {
    message("No internet connection found.")
    return(NULL)
  }

  # Define url containing metadata in JSON format --------------------------
  if (language == 'english') {
    url <- paste0("http://open.statswales.gov.wales/en-gb/discover/metadata?$filter=Dataset%20eq%20%27",
                  tolower(id), "%27")
  } else if (language == 'welsh') {
    url <- paste0("http://agored.statscymru.llyw.cymru/cy-gb/discover/metadata?$filter=Dataset%20eq%20%27",
                  tolower(id), "%27")
  } else {
    message('Invalid language specified. Please set the language parameter to "english" or "welsh".')
    return(NULL)
  }

  # Extract metadata list ----------------------------------------------------
  ua <- httr::user_agent("https://github.com/jamie-ralph/statswalesr")

  # Check resource is available ----
  request <- tryCatch(
    {
      httr::GET(url, ua, httr::timeout(10))
    },
    error = function(cnd) {
      return(NULL)
    }
  )

  # Exit function if API didn't respond ----
  if (is.null(request)) {
    message("The StatsWales API did not respond in time and might be unavailable.")
    return(NULL)
  }

  # Exit function if an HTTP error was returned ----
  if (httr::http_error(request)) {

    message("Metadata was not found. The API might be unavailable.")

    return(NULL)

  }

  # Exit function if JSON data is not returned -----------------------------
  if (httr::http_type(request) != "application/json") {
    message("JSON data was not returned. Check your dataset id for typos. If your dataset id is correct, the API might be unavailable.")
    return(NULL)
  }

  # Extract data from request object
  json_data <- jsonlite::fromJSON(httr::content(request, "text"))

  # Check that metadata has been returned ---------------------------------
  if (length(json_data$value) < 1) {
    message("Metadata was not found. Check your dataset id for typos. If your dataset id is correct, the API might be unavailable.")

    return(NULL)
  }

  # Extract metadata dataframe --------------------------------------------
  metadata <- json_data$value

  # Return metadata ------------------------------------------------------
  metadata
}

