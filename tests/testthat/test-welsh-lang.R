context("Welsh language downloads work as expected")

test_that("A Welsh language download works for get_dataset", {

  welsh_df <- statswalesr::statswales_get_dataset("hlth0515", language = "welsh")

  expect_true(is.data.frame(welsh_df) | is.null(welsh_df))
})

test_that("A Welsh language download works for get_metadata", {

  welsh_meta <- statswalesr::statswales_get_metadata("hlth0515", language = "welsh")

  expect_true(is.data.frame(welsh_meta) | is.null(welsh_meta))

})

test_that("A Welsh language search returns a dataframe", {

  welsh_search <- statswales_search("ysbyty", language = "welsh")

  expect_true(is.data.frame(welsh_search) | is.null(welsh_search))

})

test_that("A Welsh language download returns the Welsh dataframe", {

  welsh_df <- statswalesr::statswales_get_dataset("tran0003", language = "welsh")

  if (!is.null(welsh_df)) {
    expect_true("Year_ItemName_WEL" %in% colnames(welsh_df))
  }

})
