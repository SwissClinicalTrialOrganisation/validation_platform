# Write relevent tests for the function in here
# Consider the type of function:
#   - is it deterministic or statistic?
#   - is it worth checking for errors/warnings under particular conditions?

test_that("monocentric as expected", {
  tmp <- summary(mono, header = FALSE)
  expect_equal(nrow(tmp), 1)
  expect_equal(ncol(tmp), 4)
  expect_equal(tmp$n, "250")
  expect_equal(tmp$rate, "81.52")
  expect_equal(tmp$time, "3")

})
test_that("multicentric as expected", {
  tmp <- summary(multi, header = FALSE)
  expect_equal(nrow(tmp), 4)
  expect_equal(ncol(tmp), 5)
  expect_equal(tmp$n, c("141", "88", "21", "250"))
  expect_equal(tmp$rate, c("45.98", "32.59", "18.00", "81.52"))
  expect_equal(tmp$time, c("3","3","1","3"))

})
