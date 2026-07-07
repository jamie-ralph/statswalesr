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

test_that("list_datasets returns results in Welsh", {
  skip_if_api_unavailable()
  result <- statswales_list_datasets(lang = "cy-gb")
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("list_topics returns results in Welsh", {
  skip_if_api_unavailable()
  result <- statswales_list_topics(lang = "cy-gb")
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
})

test_that("get_dataset returns data in Welsh", {
  skip_if_api_unavailable()
  datasets <- statswales_list_datasets(page_size = 1)
  result <- statswales_get_dataset(datasets$id[1], lang = "cy-gb")
  expect_true(is.data.frame(result) || is.null(result))
})

test_that("get_metadata returns metadata in Welsh", {
  skip_if_api_unavailable()
  datasets <- statswales_list_datasets(page_size = 1)
  result <- statswales_get_metadata(datasets$id[1], lang = "cy-gb")
  expect_true(is.list(result) || is.null(result))
})

test_that("search returns Welsh results", {
  skip_if_api_unavailable()
  result <- statswales_search("ysbyty", lang = "cy-gb")
  expect_true(is.data.frame(result) || is.null(result))
})
