# --- statswales_list_datasets() -----------------------------------------------

test_that("list_datasets returns the full catalogue with expected columns", {
  skip_if_api_unavailable()
  result <- statswales_list_datasets()
  expect_true(is.data.frame(result))
  expect_true(all(c("id", "title", "first_published_at", "last_updated_at") %in% names(result)))
  expect_gt(nrow(result), 100)
  expect_s3_class(result$first_published_at, "POSIXct")
})

test_that("list_datasets invalid lang errors", {
  expect_error(statswales_list_datasets(lang = "fr"), "`lang` must be one of")
})

# --- statswales_get_metadata() ------------------------------------------------

test_that("get_metadata returns a list for valid UUID", {
  skip_if_api_unavailable()
  result <- statswales_get_metadata(test_dataset_id())
  expect_true(is.list(result))
  expect_true("id" %in% names(result))
})

test_that("get_metadata returns NULL for unknown UUID", {
  skip_if_api_unavailable()
  expect_null(statswales_get_metadata("00000000-0000-0000-0000-000000000000"))
})

test_that("get_metadata errors on non-string input", {
  expect_error(statswales_get_metadata(123), "dataset_id must be a string")
})

test_that("get_metadata errors on vector input", {
  expect_error(statswales_get_metadata(c("a", "b")), "dataset_id must be a single value")
})

# --- statswales_get_filters() -------------------------------------------------

test_that("get_filters returns a list with expected structure", {
  skip_if_api_unavailable()
  result <- statswales_get_filters(test_dataset_id())
  expect_true(is.list(result) || is.null(result))
  if (is.list(result) && length(result) > 0) {
    expect_true(all(c("factTableColumn", "columnName", "values") %in% names(result[[1]])))
    expect_true(is.data.frame(result[[1]]$values))
    expect_true(all(c("reference", "description") %in% names(result[[1]]$values)))
  }
})

test_that("get_filters errors on non-string input", {
  expect_error(statswales_get_filters(42), "dataset_id must be a string")
})

# --- statswales_get_dataset() -------------------------------------------------

test_that("get_dataset returns a tidy data frame for valid UUID", {
  skip_if_api_unavailable()
  result <- statswales_get_dataset(test_dataset_id())
  expect_true(is.data.frame(result) || is.null(result))
  if (is.data.frame(result)) {
    expect_false(any(grepl("_sort$", names(result))))
    chr_cols <- Filter(is.character, result)
    for (col in chr_cols) {
      expect_false(any(grepl("^\\s|\\s$", col), na.rm = TRUE))
    }
  }
})

test_that("get_dataset tidy = FALSE returns the raw API response", {
  skip_if_api_unavailable()
  result <- statswales_get_dataset(test_dataset_id(), tidy = FALSE, page_size = 5)
  if (is.data.frame(result)) {
    expect_true(any(grepl("_sort$", names(result))))
  }
})

test_that("get_dataset returns NULL for unknown UUID", {
  skip_if_api_unavailable()
  expect_null(statswales_get_dataset("00000000-0000-0000-0000-000000000000"))
})

test_that("get_dataset errors on non-string input", {
  expect_error(statswales_get_dataset(1234), "dataset_id must be a string")
})

test_that("get_dataset errors on vector input", {
  expect_error(statswales_get_dataset(c("a", "b")), "dataset_id must be a single value")
})

test_that("get_dataset errors on invalid lang", {
  expect_error(statswales_get_dataset("abc", lang = "xx"), "`lang` must be one of")
})

# --- statswales_create_query() ------------------------------------------------

test_that("create_query returns a character filter ID", {
  skip_if_api_unavailable()
  fid <- statswales_create_query(test_dataset_id())
  expect_true(is.character(fid) || is.null(fid))
  if (!is.null(fid)) expect_equal(nchar(fid), 12L)
})

test_that("create_query errors on non-string input", {
  expect_error(statswales_create_query(123), "dataset_id must be a string")
})

# --- statswales_get_query() ---------------------------------------------------

test_that("get_query returns a list with expected fields", {
  skip_if_api_unavailable()
  fid <- statswales_create_query(test_dataset_id())
  if (!is.null(fid)) {
    result <- statswales_get_query(test_dataset_id(), fid)
    expect_true(is.list(result) || is.null(result))
    if (is.list(result)) expect_true("id" %in% names(result))
  }
})

test_that("get_query errors on non-string filter_id", {
  expect_error(statswales_get_query("some-id", 123), "filter_id must be a string")
})

# --- statswales_download_dataset() --------------------------------------------

test_that("download_dataset creates a non-empty CSV file", {
  skip_if_api_unavailable()
  path <- statswales_download_dataset(test_dataset_id(), format = "csv")
  if (!is.null(path)) {
    expect_true(file.exists(path))
    expect_gt(file.size(path), 0)
  }
})

test_that("download_dataset errors on invalid format", {
  expect_error(
    statswales_download_dataset("some-id", format = "pdf"),
    "'arg' should be one of"
  )
})

test_that("download_dataset errors on non-string input", {
  expect_error(statswales_download_dataset(123), "dataset_id must be a string")
})
