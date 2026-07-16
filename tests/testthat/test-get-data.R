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

# --- statswales_list_topics() / statswales_get_topic() -------------------------

test_that("list_topics returns topics with expected columns", {
  skip_if_api_unavailable()
  result <- statswales_list_topics()
  expect_true(is.data.frame(result))
  expect_true(all(c("id", "path", "name", "name_en", "name_cy") %in% names(result)))
  expect_gt(nrow(result), 0)
  expect_true(is.integer(result$id))
})

test_that("get_topic returns the expected structure", {
  skip_if_api_unavailable()
  topics <- statswales_list_topics()
  skip_if(is.null(topics) || nrow(topics) == 0, "No topics available")
  result <- statswales_get_topic(topics$id[1])
  expect_true(is.list(result))
  expect_true(all(c("selectedTopic", "parents") %in% names(result)))
  expect_true(any(c("children", "datasets") %in% names(result)))
})

test_that("get_topic errors on non-numeric input", {
  expect_error(statswales_get_topic("health"), "topic_id must be numeric")
})

test_that("get_topic errors on vector input", {
  expect_error(statswales_get_topic(c(1, 2)), "topic_id must be a single value")
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
  result <- statswales_get_dataset(test_dataset_id(), all_pages = FALSE)
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
  result <- statswales_get_dataset(test_dataset_id(), tidy = FALSE,
                                   all_pages = FALSE, page_size = 5)
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

test_that("get_dataset filter restricts results to the requested value", {
  skip_if_api_unavailable()
  dim <- test_filter_dim()
  flt <- list(stats::setNames(list(dim$values$reference[1]), dim$columnName))
  result <- suppressMessages(
    statswales_get_dataset(test_dataset_id(), filter = flt, all_pages = FALSE)
  )
  expect_true(is.data.frame(result))
  expect_gt(nrow(result), 0)
  expect_true(dim$columnName %in% names(result))
  expect_true(all(result[[dim$columnName]] == trimws(dim$values$description[1])))
})

test_that("get_dataset sort_by is honoured by the API", {
  skip_if_api_unavailable()
  col  <- test_filter_dim()$columnName
  asc  <- suppressMessages(statswales_get_dataset(
    test_dataset_id(), sort_by = stats::setNames("asc", col), all_pages = FALSE
  ))
  desc <- suppressMessages(statswales_get_dataset(
    test_dataset_id(), sort_by = stats::setNames("desc", col), all_pages = FALSE
  ))
  expect_true(is.data.frame(asc))
  expect_true(is.data.frame(desc))
  expect_false(identical(asc[[col]][1], desc[[col]][1]))
})

test_that("get_dataset data_value_type option changes value formatting", {
  skip_if_api_unavailable()
  raw <- suppressMessages(statswales_get_dataset(
    test_dataset_id(),
    options = list(data_value_type = "raw"),
    all_pages = FALSE, tidy = FALSE
  ))
  expect_true(is.data.frame(raw))
  skip_if(!"Data values" %in% names(raw), "Dataset has no 'Data values' column")
  expect_true(is.numeric(raw[["Data values"]]))

  formatted <- suppressMessages(statswales_get_dataset(
    test_dataset_id(), all_pages = FALSE, tidy = FALSE
  ))
  expect_true(is.character(formatted[["Data values"]]))
})

test_that("get_dataset accepts all display options without error", {
  # The API currently ignores use_raw_column_names and use_reference_values
  # in its output (verified July 2026), so only request success is asserted.
  skip_if_api_unavailable()
  result <- suppressMessages(statswales_get_dataset(
    test_dataset_id(),
    options = list(
      use_raw_column_names = TRUE,
      use_reference_values = TRUE,
      data_value_type      = "raw"
    ),
    all_pages = FALSE
  ))
  expect_true(is.data.frame(result))
})

test_that("get_dataset all_pages combines pages into the full dataset", {
  skip_if_api_unavailable()
  id  <- test_dataset_id()
  fid <- statswales_create_query(id)
  skip_if(is.null(fid), "Could not create a query")
  total <- statswales_get_query(id, fid)$totalLines
  skip_if(is.null(total) || total < 3, "Dataset too small to paginate")
  skip_if(total > 30000, "Dataset too large for a pagination test")

  result <- suppressMessages(statswales_get_dataset(
    id, all_pages = TRUE, page_size = ceiling(total / 3)
  ))
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), total)
})

test_that("get_dataset page_number returns distinct pages", {
  skip_if_api_unavailable()
  p1 <- statswales_get_dataset(test_dataset_id(), all_pages = FALSE,
                               page_size = 5, page_number = 1, tidy = FALSE)
  p2 <- statswales_get_dataset(test_dataset_id(), all_pages = FALSE,
                               page_size = 5, page_number = 2, tidy = FALSE)
  skip_if(!is.data.frame(p1) || !is.data.frame(p2), "Paged requests failed")
  expect_false(identical(p1, p2))
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

test_that("create_query is deterministic for identical inputs", {
  skip_if_api_unavailable()
  dim <- test_filter_dim()
  flt <- list(stats::setNames(list(dim$values$reference[1]), dim$columnName))
  fid1 <- statswales_create_query(test_dataset_id(), filter = flt)
  fid2 <- statswales_create_query(test_dataset_id(), filter = flt)
  skip_if(is.null(fid1), "Could not create a query")
  expect_identical(fid1, fid2)
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

# --- statswales_get_pivot() ---------------------------------------------------

test_that("get_pivot returns a pivot structure for two dimensions", {
  skip_if_api_unavailable()
  filters <- test_filters()
  skip_if(length(filters) < 2, "Dataset has fewer than two dimensions")
  result <- statswales_get_pivot(
    test_dataset_id(),
    x = filters[[1]]$columnName,
    y = filters[[2]]$columnName
  )
  expect_true(is.list(result) || is.null(result))
  if (is.list(result)) {
    expect_true("pivot" %in% names(result))
  }
})

test_that("get_pivot errors on non-string dataset_id", {
  expect_error(statswales_get_pivot(1, x = "a", y = "b"),
               "dataset_id must be a string")
})

test_that("get_pivot errors on non-string axes", {
  expect_error(statswales_get_pivot("some-id", x = 1, y = "b"),
               "x must be a single string")
  expect_error(statswales_get_pivot("some-id", x = "a", y = c("b", "c")),
               "y must be a single string")
})

test_that("get_pivot errors on invalid lang", {
  expect_error(statswales_get_pivot("some-id", x = "a", y = "b", lang = "xx"),
               "`lang` must be one of")
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

test_that("download_dataset writes xlsx to a user-supplied path", {
  skip_if_api_unavailable()
  path <- file.path(tempdir(), "statswalesr-test.xlsx")
  on.exit(unlink(path), add = TRUE)
  result <- suppressMessages(
    statswales_download_dataset(test_dataset_id(), format = "xlsx", path = path)
  )
  skip_if(is.null(result), "Download failed")
  expect_identical(result, path)
  expect_true(file.exists(path))
  expect_gt(file.size(path), 0)
  con <- file(path, "rb")
  magic <- readBin(con, "raw", 2)
  close(con)
  expect_identical(rawToChar(magic), "PK")
})

test_that("download_dataset filter reduces the rows downloaded", {
  skip_if_api_unavailable()
  dim <- test_filter_dim()
  flt <- list(stats::setNames(list(dim$values$reference[1]), dim$columnName))

  full_path <- suppressMessages(
    statswales_download_dataset(test_dataset_id(), format = "csv")
  )
  filtered_path <- suppressMessages(
    statswales_download_dataset(test_dataset_id(), format = "csv", filter = flt)
  )
  skip_if(is.null(full_path) || is.null(filtered_path), "Download failed")
  on.exit(unlink(c(full_path, filtered_path)), add = TRUE)

  full     <- read.csv(full_path)
  filtered <- read.csv(filtered_path)
  expect_gt(nrow(filtered), 0)
  expect_lt(nrow(filtered), nrow(full))
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
