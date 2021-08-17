#' Search StatsWales datasets
#'
#' \code{statswales_search} returns a dataframe of dataset titles and IDs from
#' \href{https://statswales.gov.wales}{StatsWales}, based on the user's
#' text input.
#'
#' @param search_text A vector of search terms.
#' @param language A string. Returns the metadata in either English ('english') or Welsh ('welsh')
#' @return A dataframe of StatsWales dataset titles and IDs.
#'
#' @examples
#' crops_datasets <- statswales_search("*crops*")
#'
#'
#'
#' @importFrom rlang .data
#' @export
statswales_search <- function(search_text, language = 'english') {

  # Check search terms are strings
  stopifnot("Search terms must be a string" = is.character(search_text))

  # Check for valid language setting
  stopifnot(
    'Please set the language parameter to "english" or "welsh"' = language %in% c("english", "welsh"),
    'Please choose one language per download.' = length(language) == 1
  )

  # Check for internet connection ---------------------------------------------
  if (!curl::has_internet()) {
    message("No internet connection found.")
    return(NULL)
  }

  # Define URL and user agent -----------------------------
  if (language == 'english') {
    url <- "http://open.statswales.gov.wales/en-gb/discover/metadata?$filter=Tag_ENG%20eq%20%27Title%27"
  } else if(language == 'welsh') {
   url <- "http://agored.statscymru.llyw.cymru/cy-gb/discover/metadata?filter=Tag_WEL%20eq%20%27Title%27"
  } else {
    message('Invalid language specified. Please set the language parameter to "english" or "welsh".')
    return(NULL)
  }

  ua <- httr::user_agent("https://github.com/jamie-ralph/statswalesr")

  # Make API request ----
  request <- tryCatch(
    {
      httr::GET(url, ua, httr::timeout(10))
    },
    error = function(cnd) {
      return(NULL)
    }
  )

  # Exit function if API did not respond ----
  if (is.null(request)) {
    message("The StatsWales API did not respond in time and might be unavailable.")
    return(NULL)
  }


  # Exit function if an HTTP error was returned ----
  if (httr::http_error(request)) {

    message("Could not access StatsWales API. The API might be unavailable.")

    return(NULL)

  }

  # Exit function if JSON data is not returned -----------------------------
  if (httr::http_type(request) != "application/json") {
    message("JSON data was not returned. Check your dataset id for typos. If your dataset id is correct, the API might be unavailable.")
    return(NULL)
  }

  # Extract information about available StatsWales datasets -------------------
  datasets <- jsonlite::fromJSON(httr::content(request, "text"))

  datasets_df <- datasets$value

  # Filter datasets based on user's search terms ----------------------------
  if (language == 'english') {

    filtered_df <-  dplyr::filter(datasets_df, grepl(paste(search_text, collapse = "|"),
                            .data$Description_ENG, ignore.case = T))

    filtered_df <- dplyr::select(filtered_df, .data$Description_ENG, .data$Dataset)

  } else {

    filtered_df <-  dplyr::filter(datasets_df, grepl(paste(search_text, collapse = "|"),
                                                     .data$Description_WEL, ignore.case = T))

    filtered_df <- dplyr::select(filtered_df, .data$Description_WEL, .data$Dataset)

  }


  stopifnot("Search terms returned no datasets." = nrow(filtered_df) > 0)

  filtered_df


}
