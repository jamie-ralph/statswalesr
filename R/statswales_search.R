#' Search StatsWales datasets
#'
#' \code{statswales_search} returns a dataframe of dataset titles and IDs from
#' \href{https://statswales.gov.wales}{StatsWales}, based on the user's
#' text input.
#'
#' @param search_text A vector of search terms.
#' @param language A string. Returns the metadata in either English ('english') or Welsh ('welsh').
#' The default is English.
#' @return A dataframe of StatsWales dataset titles and IDs.
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function was deprecated because StatsWales ended its OData
#' service in August 2024.
#'
#' @keywords internal
#' @importFrom rlang .data
#' @export
statswales_search <- function(search_text, language = 'english') {
  lifecycle::deprecate_warn("0.3.0", "statswales_search()")
  return(NULL)
}
