#' Retrieves a dataset from the StatsWales OData API
#'
#' \code{statswales_get_dataset} returns a dataframe from
#' \href{https://statswales.gov.wales}{StatsWales} using a dataset id. The
#' \code{print_progress} argument can be set to \code{TRUE} to keep track of
#' progress when extracting a large dataset.
#'
#' @param id A dataset id. Must be a single string.
#' @param print_progress logical. Should progress be printed in the console?
#' @return If the dataset id is valid, the function will return the requested
#' dataset in a dataframe. If the id is not valid, the function will return
#' an error.
#' @examples
#' \dontrun{
#' data <- statswales_get_dataset("hlth0515")
#'}
#'
#' @importFrom rlang .data
#' @export

statswales_get_dataset <- function(id, print_progress = FALSE) {

  stopifnot('Dataset id must be a string'       = is.character(id),
            'Dataset id should be a single value' = length(id) == 1
  )

  # Check for internet connection --------------------------------------------

  if (!curl::has_internet()) {
    message("No internet connection found.")
    return(NULL)
  }

  # Define dataset URL --------------------------------------------------------

  url <- paste0("http://open.statswales.gov.wales/en-gb/dataset/", tolower(id))

  # Define user agent ----------------------------------------------------

  ua <- httr::user_agent("https://github.com/jamie-ralph/statswalesr")

  # Check that dataset resource is available ------------------------------
  request <- httr::GET(url, ua)

  if (httr::http_error(request)) {

    message("Dataset was not found. Check your dataset id for typos. If your dataset id is correct, the API might be unavailable.")

    return(NULL)

  }
  else {
    message("Downloading StatsWales dataset...")
  }

  # Extract first page of data and add to a list object --------------------

  json_data <- jsonlite::fromJSON(httr::content(request, "text"))

  json_list = list(json_data$value)



  # Loop through odata links to get all data --------------------------------
  i = 0

  while ("odata.nextLink" %in% names(json_data)) {

    # Print progress

    if(print_progress == TRUE) {

      i = i + nrow(json_data$value)

      message("Extracting data: ", i, " rows extracted")

    }

    # Request data from next page

    next_page_request <- httr::GET(json_data$odata.nextLink, ua)

    # If next page cannot be accessed, exit function

    if (httr::http_error(next_page_request)) {

      message("Could not download this dataset. The API might be unavailable.")

      return(NULL)

    }

    # Extract data and append to main list object

    json_data <- jsonlite::fromJSON(httr::content(next_page_request, "text"))

    json_list <- c(json_list, list(json_data$value))

  }

  # rbind dataframes together and tell user the data is extracted

  df <- do.call(rbind, json_list)

  if("RowKey" %in% colnames(df)) {

    df <- unique(
      dplyr::select(df, -.data$RowKey)
    )
  }


  message("Dataset extracted successfully with ", nrow(df), " rows and ",
          ncol(df), " columns.")

  # Return the dataframe

  df

}
