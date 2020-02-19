context("Valid dataset id returns dataframe")

test_df <- rstatswales::get_dataset("hlth0515")

test_that("get_dataset with valid id returns a dataframe", {
          expect_true(is.data.frame(test_df))
          })

test_that("invalid id returns an error", {
          expect_error(rstatswales::get_dataset("XXXXX"))
          })
