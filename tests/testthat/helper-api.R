skip_if_api_unavailable <- function() {
  skip_on_cran()
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
# The catalogue can contain broken entries (e.g. datasets whose data endpoint
# returns HTTP 500), so probe candidates until one responds to a data query
# and is small enough to paginate over in a test.
test_dataset_id <- local({
  id <- NULL
  function() {
    if (is.null(id)) {
      datasets <- suppressMessages(statswales_list_datasets())
      if (is.null(datasets) || nrow(datasets) == 0) {
        skip("Could not retrieve a dataset ID from the API")
      }
      for (candidate in utils::head(datasets$id, 10)) {
        fid <- suppressMessages(statswales_create_query(candidate))
        if (is.null(fid)) next
        total <- suppressMessages(statswales_get_query(candidate, fid))$totalLines
        if (!is.null(total) && total >= 10 && total <= 30000) {
          id <<- candidate
          break
        }
      }
      if (is.null(id)) {
        skip("No working test dataset found in the first 10 catalogue entries")
      }
    }
    id
  }
})

# Fetch the filter dimensions for the test dataset, hitting the API only once.
test_filters <- local({
  filters <- NULL
  function() {
    if (is.null(filters)) {
      result <- statswales_get_filters(test_dataset_id())
      if (is.null(result) || length(result) == 0) {
        skip("Could not retrieve filters from the API")
      }
      filters <<- result
    }
    filters
  }
})

# First filter dimension of the test dataset with more than one value, for
# tests that need to filter or sort by a real column.
test_filter_dim <- function() {
  dim <- Find(
    function(f) is.data.frame(f$values) && nrow(f$values) > 1,
    test_filters()
  )
  if (is.null(dim)) {
    skip("Test dataset has no filter dimension with multiple values")
  }
  dim
}
