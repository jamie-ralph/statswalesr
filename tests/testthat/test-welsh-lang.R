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
  result <- statswales_get_dataset(test_dataset_id(), lang = "cy-gb")
  expect_true(is.data.frame(result) || is.null(result))
})

test_that("get_metadata returns metadata in Welsh", {
  skip_if_api_unavailable()
  result <- statswales_get_metadata(test_dataset_id(), lang = "cy-gb")
  expect_true(is.list(result) || is.null(result))
})

test_that("search returns Welsh results", {
  skip_if_api_unavailable()
  result <- statswales_search("ysbyty", lang = "cy-gb")
  expect_true(is.data.frame(result) || is.null(result))
})
