context("Returns dataframe")

test_df <- get_dataset("hlth0515")

test_that("get_dataset returns a dataframe", {
          expect_true(is.data.frame(test_df))
          })
