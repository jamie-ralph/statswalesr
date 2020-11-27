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
#' data <- statswales_get_dataset("hlth0515")
#'
#' @importFrom rlang .data
#' @export

statswales_get_dataset <- function(id, print_progress = FALSE) {

  stopifnot('id should be a string'       = is.character(id),
            'id should be a single value' = length(id) == 1
  )

  # Check for internet connection --------------------------------------------

  if (!curl::has_internet()) {
    message("No internet connection found.")
    return(NULL)
  }

  # Define dataset URL --------------------------------------------------------

  url <- paste0("http://open.statswales.gov.wales/en-gb/dataset/", tolower(id))

  # Check that dataset resource is available ------------------------------

  if (httr::http_error(httr::GET(url))) {

    message("Dataset was not found. Check your dataset id for typos. If your dataset id is correct, the API might be unavailable.")

    return(NULL)

  }
  else {
    message("Downloading StatsWales dataset...")
  }

  # Extract first page of data and add to a list object --------------------

  json_data <- jsonlite::fromJSON(txt = url)

  json_list = list(json_data$value)



  # Loop through odata links to get all data --------------------------------
  i = 0

  while ("odata.nextLink" %in% names(json_data)) {

    if(print_progress == TRUE) {

      i = i + nrow(json_data$value)

      message("Extracting data: ", i, " rows extracted")

    }

    json_data <- jsonlite::fromJSON(txt = json_data$odata.nextLink)

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
