# Write relevent tests for the function in here
# Consider the type of function:
#   - is it deterministic or statistic?
#   - is it worth checking for errors/warnings under particular conditions?

test_that("monocentric", {
  expect_true(inherits(mono, "accrual_df"))
  expect_equal(nrow(mono), 79)
  expect_equal(ncol(mono), 3)
  expect_equal(max(mono$Cumulative), sum(mono$Freq))
})

test_that("multicentric", {
  expect_true(inherits(multi, "accrual_df"))
  expect_equal(nrow(multi[[1]]), 67)
  expect_equal(ncol(multi[[1]]), 3)
  expect_equal(max(multi[[1]]$Cumulative), sum(multi[[1]]$Freq))
})


