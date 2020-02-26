context("Only a single valid id returns a dataframe")

test_df <- statswalesr::statswales_get_dataset("hlth0515")

test_that("get_dataset with a valid id returns a dataframe", {
  expect_true(is.data.frame(test_df))
  })

test_that("invalid id returns an error", {
  expect_error(statswalesr::statswales_get_dataset("XXXXX"))
  })

test_that("numeric input returns an error", {
  expect_error(statswalesr::statswales_get_dataset(1234))
  })

test_that("vector of valid ids returns an error", {
  expect_error(statswalesr::statswales_get_dataset(c("Econ0072", "Hlth0019")))
  })
