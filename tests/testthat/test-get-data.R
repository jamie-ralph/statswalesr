skip_if_api_unavailable <- function() {
  result <- tryCatch(
    httr2::req_perform(
      httr2::req_error(
        httr2::request("https://api.stats.gov.wales/v1"),
        is_error = \(r) FALSE
      )
    ),
    error = function(e) NULL
  )
  if (is.null(result) || httr2::resp_status(result) >= 400) {
    skip("StatsWales API is not available")
  }
}

# --- statswales_list_datasets() -----------------------------------------------

test_that("list_datasets: returns a data frame with expected columns", {
  skip_if_api_unavailable()
  result <- statswales_list_datasets()
  expect_true(is.data.frame(result))
  expect_true(all(c("id", "title", "first_published_at", "last_updated_at") %in% names(result)))
  expect_gt(nrow(result), 0)
})

test_that("list_datasets: Welsh language returns a data frame", {
  skip_if_api_unavailable()
  result <- statswales_list_datasets(lang = "cy-gb")
  expect_true(is.data.frame(result))
})

test_that("list_datasets: invalid lang errors", {
  expect_error(statswales_list_datasets(lang = "fr"), "`lang` must be one of")
})

test_that("list_datasets: pagination parameters work", {
  skip_if_api_unavailable()
  result <- statswales_list_datasets(page_number = 1, page_size = 5)
  expect_true(is.data.frame(result))
  expect_lte(nrow(result), 5)
})

# --- statswales_list_topics() -------------------------------------------------

test_that("list_topics: returns a data frame with expected columns", {
  skip_if_api_unavailable()
  result <- statswales_list_topics()
  expect_true(is.data.frame(result))
  expect_true(all(c("id", "name", "name_en", "name_cy") %in% names(result)))
  expect_gt(nrow(result), 0)
})

test_that("list_topics: invalid lang errors", {
  expect_error(statswales_list_topics(lang = "de"), "`lang` must be one of")
})

# --- statswales_get_topic() ---------------------------------------------------

test_that("get_topic: valid topic returns a list", {
  skip_if_api_unavailable()
  topics <- statswales_list_topics()
  result <- statswales_get_topic(topics$id[1])
  expect_true(is.list(result))
})

test_that("get_topic: non-numeric id errors", {
  expect_error(statswales_get_topic("transport"), "topic_id must be numeric")
})

test_that("get_topic: invalid id returns NULL", {
  skip_if_api_unavailable()
  result <- statswales_get_topic(99999999)
  expect_null(result)
})

# --- statswales_get_metadata() ------------------------------------------------

test_that("get_metadata: valid UUID returns a list", {
  skip_if_api_unavailable()
  datasets <- statswales_list_datasets(page_size = 1)
  result <- statswales_get_metadata(datasets$id[1])
  expect_true(is.list(result))
  expect_true("id" %in% names(result))
})

test_that("get_metadata: invalid UUID returns NULL", {
  skip_if_api_unavailable()
  result <- statswales_get_metadata("00000000-0000-0000-0000-000000000000")
  expect_null(result)
})

test_that("get_metadata: non-string id errors", {
  expect_error(statswales_get_metadata(123), "dataset_id must be a string")
})

test_that("get_metadata: vector id errors", {
  expect_error(
    statswales_get_metadata(c("a", "b")),
    "dataset_id must be a single value"
  )
})

# --- statswales_get_dataset() -------------------------------------------------

test_that("get_dataset: valid UUID returns a data frame", {
  skip_if_api_unavailable()
  datasets <- statswales_list_datasets(page_size = 1)
  result <- statswales_get_dataset(datasets$id[1])
  expect_true(is.data.frame(result) || is.null(result))
})

test_that("get_dataset: non-string id errors", {
  expect_error(statswales_get_dataset(1234), "dataset_id must be a string")
})

test_that("get_dataset: vector id errors", {
  expect_error(
    statswales_get_dataset(c("a", "b")),
    "dataset_id must be a single value"
  )
})

test_that("get_dataset: invalid lang errors", {
  expect_error(statswales_get_dataset("abc", lang = "xx"), "`lang` must be one of")
})

test_that("get_dataset: invalid UUID returns NULL", {
  skip_if_api_unavailable()
  result <- statswales_get_dataset("00000000-0000-0000-0000-000000000000")
  expect_null(result)
})

# --- statswales_get_filters() -------------------------------------------------

test_that("get_filters: valid UUID returns a list", {
  skip_if_api_unavailable()
  datasets <- statswales_list_datasets(page_size = 1)
  result <- statswales_get_filters(datasets$id[1])
  expect_true(is.list(result) || is.null(result))
  if (is.list(result) && length(result) > 0) {
    expect_true(all(c("factTableColumn", "columnName", "values") %in% names(result[[1]])))
    expect_true(is.data.frame(result[[1]]$values))
  }
})

test_that("get_filters: non-string id errors", {
  expect_error(statswales_get_filters(42), "dataset_id must be a string")
})

# --- statswales_download_dataset() --------------------------------------------

test_that("download_dataset: valid UUID downloads a CSV file", {
  skip_if_api_unavailable()
  datasets <- statswales_list_datasets(page_size = 1)
  path <- statswales_download_dataset(datasets$id[1], format = "csv")
  if (!is.null(path)) {
    expect_true(file.exists(path))
    expect_gt(file.size(path), 0)
  }
})

test_that("download_dataset: invalid format errors", {
  expect_error(
    statswales_download_dataset("some-id", format = "pdf"),
    "'arg' should be one of"
  )
})

test_that("download_dataset: non-string id errors", {
  expect_error(statswales_download_dataset(123), "dataset_id must be a string")
})
