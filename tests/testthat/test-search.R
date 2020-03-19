context("Valid search term returns a dataframe")

test_search <- statswalesr::statswales_search("crop")

test_that("valid search terms return a dataset", {
          expect_true(is.data.frame(test_search))
          })

test_that("Non-character input throws an error", {
          expect_error(statswalesr::statswales_search(123))
          })
