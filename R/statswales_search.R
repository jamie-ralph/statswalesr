#' Search StatsWales datasets
#'
#' \code{statswales_search} returns a dataframe of dataset titles and IDs from
#' \href{https://statswales.gov.wales}{StatsWales}, based on the user's
#' text input.
#'
#' @param search_text A vector of search terms. Must be character only.
#' @param lang.option Which language should the datasets
#' be returned in? Accepts either "english" or "welsh"
#' @return A dataframe of StatsWales dataset titles and IDs.
#'
#' @examples
#' crops_datasets <- statswales_search("*crops*")
#'
#' @export
statswales_search <- function(search_text, lang.option = "en-gb") {

  datasets <- jsonlite::fromJSON(
    paste0("http://open.statswales.gov.wales/",
           lang.option,
           "/discover/metadata?$filter=Tag_ENG%20eq%20%27Title%27")
  )

  datasets_df <- datasets$value

  filtered_df <- datasets_df[grepl(paste(search_text, collapse = "|"),
                     datasets_df$Description_ENG, ignore.case = T),
                     c("Description_ENG", "Dataset")]

  filtered_df


}
