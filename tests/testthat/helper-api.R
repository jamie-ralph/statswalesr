skip_if_api_unavailable <- function() {
  result <- tryCatch(
    httr2::req_perform(
      httr2::req_error(
        httr2::request("https://api.stats.gov.wales/v2"),
        is_error = \(r) FALSE
      )
    ),
    error = function(e) NULL
  )
  if (is.null(result) || httr2::resp_status(result) >= 400) {
    skip("StatsWales API v2 is not available")
  }
}

# Fetch one dataset ID for use across tests, hitting the API only once.
test_dataset_id <- local({
  id <- NULL
  function() {
    if (is.null(id)) {
      datasets <- suppressMessages(statswales_list_datasets())
      if (is.null(datasets) || nrow(datasets) == 0) {
        skip("Could not retrieve a dataset ID from the API")
      }
      id <<- datasets$id[1]
    }
    id
  }
})
