# --- .sw_format_sort() --------------------------------------------------------

test_that("format_sort returns NULL for NULL", {
  expect_null(.sw_format_sort(NULL))
})

test_that("format_sort passes through a plain string", {
  expect_equal(.sw_format_sort("Year:desc"), "Year:desc")
})

test_that("format_sort collapses an unnamed vector", {
  expect_equal(.sw_format_sort(c("Year:asc", "Area:desc")), "Year:asc,Area:desc")
})

test_that("format_sort builds from a named vector", {
  expect_equal(
    .sw_format_sort(c(Year = "desc", Area = "asc")),
    "Year:desc,Area:asc"
  )
})

test_that("format_sort is case-insensitive on direction", {
  expect_equal(.sw_format_sort(c(Year = "DESC")), "Year:desc")
})

test_that("format_sort errors on invalid direction", {
  expect_error(.sw_format_sort(c(Year = "up")), "must be 'asc' or 'desc'")
})

# --- .sw_flatten_filter_values() ----------------------------------------------

test_that("flatten handles an empty list", {
  result <- .sw_flatten_filter_values(list())
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 0)
  expect_equal(names(result), c("reference", "description", "parent", "level"))
})

test_that("flatten returns flat values with NA parent and level 1", {
  values <- list(
    list(reference = "2020", description = "2020"),
    list(reference = "2021", description = "2021")
  )
  result <- .sw_flatten_filter_values(values)
  expect_equal(nrow(result), 2)
  expect_true(all(is.na(result$parent)))
  expect_true(all(result$level == 1L))
})

test_that("flatten expands hierarchical children with parent and level", {
  values <- list(
    list(
      reference = "W92000004",
      description = "Wales",
      children = list(
        list(reference = "W06000001", description = "Isle of Anglesey"),
        list(reference = "W06000002", description = "Gwynedd")
      )
    )
  )
  result <- .sw_flatten_filter_values(values)
  expect_equal(nrow(result), 3)
  expect_equal(result$reference, c("W92000004", "W06000001", "W06000002"))
  expect_equal(result$parent, c(NA, "W92000004", "W92000004"))
  expect_equal(result$level, c(1L, 2L, 2L))
})

# --- .sw_tidy_data() ----------------------------------------------------------

test_that("tidy_data drops *_sort columns", {
  df <- data.frame(
    Area = "Wales", Area_sort = "1", Period_sort = "347068800000",
    stringsAsFactors = FALSE, check.names = FALSE
  )
  result <- .sw_tidy_data(df)
  expect_equal(names(result), "Area")
})

test_that("tidy_data trims padding and converts numeric strings", {
  df <- data.frame(
    `Data values` = c("         271", "           4"),
    Area = c("  Wales", "Cardiff  "),
    stringsAsFactors = FALSE, check.names = FALSE
  )
  result <- .sw_tidy_data(df)
  expect_identical(result[["Data values"]], c(271, 4))
  expect_identical(result$Area, c("Wales", "Cardiff"))
})

test_that("tidy_data handles thousands separators", {
  df <- data.frame(x = c("1,234", "56,789.5"), stringsAsFactors = FALSE)
  expect_identical(.sw_tidy_data(df)$x, c(1234, 56789.5))
})

test_that("tidy_data leaves mixed text columns as character", {
  df <- data.frame(
    x = c("271", ".."),
    y = c("Cardiff, Newport", "Swansea"),
    stringsAsFactors = FALSE
  )
  result <- .sw_tidy_data(df)
  expect_identical(result$x, c("271", ".."))
  expect_identical(result$y, c("Cardiff, Newport", "Swansea"))
})

test_that("tidy_data converts empty strings to NA and still converts numerics", {
  df <- data.frame(x = c("42", ""), stringsAsFactors = FALSE)
  expect_identical(.sw_tidy_data(df)$x, c(42, NA))
})

test_that("tidy_data passes through non-data-frame input", {
  expect_null(.sw_tidy_data(NULL))
})

test_that("tidy_data tolerates zero-row data frames", {
  df <- data.frame(x = character(0), x_sort = character(0), stringsAsFactors = FALSE)
  result <- .sw_tidy_data(df)
  expect_equal(names(result), "x")
  expect_equal(nrow(result), 0)
})

# --- .sw_parse_time() ---------------------------------------------------------

test_that("parse_time parses ISO 8601 timestamps as UTC", {
  result <- .sw_parse_time("2026-07-07T08:30:00.000Z")
  expect_s3_class(result, "POSIXct")
  expect_equal(attr(result, "tzone"), "UTC")
  expect_equal(format(result, "%Y-%m-%d %H:%M"), "2026-07-07 08:30")
})

test_that("parse_time returns NA for NA input", {
  expect_true(is.na(.sw_parse_time(NA_character_)))
})

# --- .sw_build_body() ---------------------------------------------------------

test_that("build_body wraps an empty filter as an empty list", {
  body <- .sw_build_body(NULL, list())
  expect_equal(body$filters, list())
})

test_that("build_body preserves filter values as lists", {
  body <- .sw_build_body(list(list(Year = c("2020", "2021"))), list())
  expect_length(body$filters, 1)
  expect_equal(body$filters[[1]]$Year, list("2020", "2021"))
})
