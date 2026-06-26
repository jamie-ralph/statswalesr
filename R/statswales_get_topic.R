#' Get the contents of a topic
#'
#' Returns sub-topics or datasets tagged directly to a given topic. Use
#' [statswales_list_topics()] to discover topic IDs.
#'
#' @param topic_id A numeric topic ID.
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#' @param page_number Page number to return. Default `1`.
#' @param page_size Number of results per page. Default `100`.
#'
#' @return A list containing `selectedTopic`, `parents`, and `datasets`.
#'   Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' topics <- statswales_list_topics()
#' topic_content <- statswales_get_topic(topics$id[1])
#' }
#'
#' @export
statswales_get_topic <- function(topic_id, lang = "en-gb", page_number = 1, page_size = 100) {
  stopifnot(
    "topic_id must be numeric"         = is.numeric(topic_id),
    "topic_id must be a single value"  = length(topic_id) == 1
  )
  .sw_validate_lang(lang)

  .sw_get(
    paste0("topic/", topic_id),
    list(lang = lang, page_number = page_number, page_size = page_size)
  )
}
