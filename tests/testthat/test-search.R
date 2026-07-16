test_that("search returns a data frame with expected columns", {
  skip_if_api_unavailable()
  result <- statswales_search("hospital")
  expect_true(is.data.frame(result) || is.null(result))
  if (is.data.frame(result)) {
    expect_true(all(c("id", "title", "summary") %in% names(result)))
  }
})

test_that("search with fts mode returns rank and highlight columns", {
  skip_if_api_unavailable()
  result <- statswales_search("health", mode = "fts")
  if (is.data.frame(result) && nrow(result) > 0) {
    expect_true(all(c("rank", "match_title", "match_summary") %in% names(result)))
  }
})

test_that("search with fuzzy mode returns results", {
  skip_if_api_unavailable()
  result <- statswales_search("hospitl", mode = "fuzzy")
  expect_true(is.data.frame(result) || is.null(result))
})

test_that("search in Welsh returns results", {
  skip_if_api_unavailable()
  result <- statswales_search("ysbyty", lang = "cy-gb")
  expect_true(is.data.frame(result) || is.null(result))
})

test_that("search page_size limits results returned", {
  skip_if_api_unavailable()
  result <- statswales_search("transport", page_size = 3)
  if (is.data.frame(result)) expect_lte(nrow(result), 3)
})

test_that("search errors on non-string keywords", {
  expect_error(statswales_search(123), "keywords must be a string")
})

test_that("search errors on vector keywords", {
  expect_error(statswales_search(c("a", "b")), "keywords must be a single value")
})

test_that("search errors on invalid lang", {
  expect_error(statswales_search("test", lang = "de"), "`lang` must be one of")
})

test_that("search errors on invalid mode", {
  expect_error(statswales_search("test", mode = "neural"), "'arg' should be one of")
})
