#' Retrieve dataset from StatsWales
#'
#' \code{get_dataset} returns a dataframe from
#' \href{https://statswales.gov.wales}{StatsWales} using a dataset id.
#'
#' @param id A dataset id as a string
#' @return If the dataset id is valid, the output will be
#'     the requested dataset in a dataframe. If the id is not
#'     valid, the function will return an HTTP error.
#' @examples
#' data <- get_dataset("hlth0515")
#'
#' @export

get_dataset <- function(id) {


  # Define dataset URL --------------------------------------------------------------

  url <- paste0("http://open.statswales.gov.wales/en-gb/dataset/", id)


  # Extract first page and add dataframe to list ------------------------------------------------------

  json_data <- try(jsonlite::fromJSON(txt = url))

  if (class(json_data) == "list") {

  json_list = list(json_data$value)

  } else {



    stop("The dataset requested was not retrieved. Check your dataset
    id for typos and that you have an internet connection. If your problem persists,
    check that the dataset is available in your browser.")

    }


  # Loop through odata links to get all data --------------------------------
  i = 0

  while ("odata.nextLink" %in% names(json_data)) {

    i = i + 1

    writeLines(paste0("Extracting data from next page (", i, ")"))

    json_data <- jsonlite::fromJSON(txt = json_data$odata.nextLink)

    json_list <- c(json_list, list(json_data$value))


  }

  # rbind dataframes together and tell user the data is extracted

  df <- do.call(rbind, json_list)

  writeLines("All data extracted")

  # Return the data

  df

}
