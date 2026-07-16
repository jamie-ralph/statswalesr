#' Get the contents of a topic
#'
#' Returns sub-topics or datasets tagged directly to a given topic. Use
#' [statswales_list_topics()] to discover topic IDs.
#'
#' The returned list has four fields:
#' \describe{
#'   \item{`selectedTopic`}{Details of the requested topic.}
#'   \item{`children`}{Sub-topics under this topic. Empty for leaf topics.}
#'   \item{`parents`}{Ancestor topics from root to the selected topic.}
#'   \item{`datasets`}{A list with `data` (dataset list items) and `count`.
#'     Only populated for leaf topics (those with no `children`).}
#' }
#'
#' @param topic_id A numeric topic ID. Use [statswales_list_topics()] to find IDs.
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#' @param page_number Page number to return. Default `1`.
#' @param page_size Number of results per page. Default `100`.
#' @param sort_by Optional sort order for datasets under a leaf topic. Either a
#'   string in `"column:direction"` format (e.g. `"title:asc"`) or a named
#'   character vector such as `c(title = "asc", last_updated_at = "desc")`.
#'
#' @return A list with fields `selectedTopic`, `children`, `parents`, and
#'   `datasets`. Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' topics <- statswales_list_topics()
#' topic <- statswales_get_topic(topics$id[1])
#'
#' # Sub-topics (non-leaf)
#' topic$children
#'
#' # Datasets at a leaf topic
#' topic$datasets$data
#' topic$datasets$count
#' }
#'
#' @export
statswales_get_topic <- function(topic_id, lang = "en-gb", page_number = 1,
                                 page_size = 100, sort_by = NULL) {
  stopifnot(
    "topic_id must be numeric"        = is.numeric(topic_id),
    "topic_id must be a single value" = length(topic_id) == 1
  )
  .sw_validate_lang(lang)

  query    <- list(lang = lang, page_number = page_number, page_size = page_size)
  sort_str <- .sw_format_sort(sort_by)
  if (!is.null(sort_str)) query$sort_by <- sort_str

  .sw_get(paste0("topic/", topic_id), query)
}
