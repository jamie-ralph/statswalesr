#' Search StatsWales datasets
#'
#' \code{statswales_search} returns a dataframe of dataset titles and IDs from
#' \href{https://statswales.gov.wales}{StatsWales}, based on the user's
#' text input.
#'
#' @param search_text A vector of search terms.
#' @return A dataframe of StatsWales dataset titles and IDs.
#'
#' @examples
#' crops_datasets <- statswales_search("*crops*")
#'
#' @importFrom rlang .data
#' @export
statswales_search <- function(search_text) {

  stopifnot("Search terms must be a string" = is.character(search_text))

  datasets <- jsonlite::fromJSON(
    "http://open.statswales.gov.wales/en-gb/discover/metadata?$filter=Tag_ENG%20eq%20%27Title%27")

  datasets_df <- datasets$value

  filtered_df <- datasets_df %>%

                     dplyr::filter(grepl(paste(search_text, collapse = "|"),
                     .data$Description_ENG, ignore.case = T)) %>%

                     dplyr::select(.data$Description_ENG, .data$Dataset)


  filtered_df


}
