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
