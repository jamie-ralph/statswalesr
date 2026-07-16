#' List top-level topics
#'
#' Returns a data frame of all top-level topics that have at least one
#' published dataset tagged against them.
#'
#' @param lang Language for returned text. One of `"en-gb"` (default),
#'   `"en"`, `"cy-gb"`, or `"cy"`.
#'
#' @return A data frame with columns `id`, `path`, `name`, `name_en`, and
#'   `name_cy`. Returns `NULL` if the request fails.
#'
#' @examples
#' \dontrun{
#' topics <- statswales_list_topics()
#' }
#'
#' @export
statswales_list_topics <- function(lang = "en-gb") {
  .sw_validate_lang(lang)

  result <- .sw_get("topic", list(lang = lang))
  if (is.null(result)) return(NULL)

  topics <- result$children
  if (length(topics) == 0) return(data.frame())

  data.frame(
    id               = vapply(topics, function(x) as.integer(x$id), integer(1)),
    path             = vapply(topics, function(x) .null_chr(x$path), character(1)),
    name             = vapply(topics, function(x) .null_chr(x$name), character(1)),
    name_en          = vapply(topics, function(x) .null_chr(x$name_en), character(1)),
    name_cy          = vapply(topics, function(x) .null_chr(x$name_cy), character(1)),
    stringsAsFactors = FALSE
  )
}
