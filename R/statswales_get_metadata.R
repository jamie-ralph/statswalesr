#' Retrieve metadata of a dataset from StatsWales
#'
#' \code{statswales_get_metadata} returns a dataframe containing metadata from
#' \href{https://statswales.gov.wales}{StatsWales} using a dataset id.
#'
#' @param id A dataset id as a string
#' @param language A string. Returns the metadata in either English ('english') or Welsh ('welsh').
#' The default is English.
#' @return If the dataset id is valid, the output will be
#'     the requested metadata in a dataframe. If the id is not
#'     valid, the function will return an HTTP error.
#' @examples
#' metadata <- statswales_get_metadata("hlth0515")
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function was deprecated because StatsWales ended its OData
#' service in August 2024.
#'
#' @keywords internal
#' @export
statswales_get_metadata <- function(id, language = 'english') {
  lifecycle::deprecate_warn("0.3.0", "statswales_get_metadata()")
  return(NULL)
}

