# Write relevent tests for the function in here
# Consider the type of function:
#   - is it deterministic or statistic?
#   - is it worth checking for errors/warnings under particular conditions?

local_edition(3)


# ----------------- Generate some example data ----------------- #
set.seed(123)
##  Continuous response

x <- matrix(rnorm(100*50), 100, 50)  # 100 observations, 50 predictors
y <- rnorm(100)  # Continuous response

## Survival response
set.seed(234)
x2 <- matrix(rnorm(100 * 20), 100, 20)  # Predictor matrix
time <- rexp(100, rate = 0.1)         # Random survival times
status <- sample(0:1, 100, replace = TRUE)  # Random censoring status (0 = censored, 1 = event)
y2 <- Surv(time, status) # Survival response


## Binomial response
set.seed(345)
x3 <- matrix(rnorm(100 * 20), 100, 20)
y3 <- rbinom(100, size = 1, prob = 0.5)  # Binary outcome (0 or 1) with equal probabilities


# ----------------- Testing -------------------------------- #

## 1.

test_that("output structure is as expected", {
  # Run glmnet.cv
  cv_fit <- glmnet::cv.glmnet(x, y)

  # Check the output structure
  expect_true(is.list(cv_fit), "The output should be a list")
  expect_true("glmnet.fit" %in% names(cv_fit),
              "Result should contain the 'glmnet.fit' component")
  expect_true("lambda.min" %in% names(cv_fit),
              "Result should contain the 'lambda.min' value")
  expect_true("lambda.1se" %in% names(cv_fit),
              "Result should contain the 'lambda.1se' value")

  # Validate lambda.min
  expect_true(is.numeric(cv_fit$lambda.min), "lambda.min should be numeric")
})


## 2.

test_that("errors are produced for invalid inputs", {
  expect_error(cv.glmnet(NULL, NULL))      # Expect an error when inputs are NULL
  expect_error(cv.glmnet(matrix(1, 10, 10), 1:5))  # Expect an error when dimensions are mismatched
})


## 3.

test_that("Cox model requires a matrix with columns 'time' (>0) and 'status' (binary) or a Surv object as a response", {
expect_error(glmnet::cv.glmnet(x,y,
                  family = "cox"))

expect_error(glmnet::cv.glmnet(x3,y3,
                               family = "cox"))
expect_no_error(glmnet::cv.glmnet(x2,y2,
                                  family = "cox"))
})

## 4.
test_that("Binomial model requires a binomial response", {
expect_error(glmnet::cv.glmnet(x,y, family = "binomial"))
expect_error(glmnet::cv.glmnet(x2,y2, family = "binomial"))
expect_no_error(glmnet::cv.glmnet(x3, y3, family = "binomial"))
})


## 5.
# Making sure that output does not change.
# Assuming that current output is the correct one.

test_that("cv.glmnet returns expected results", {
set.seed(111)

# for family = "cox"
fit_cox <- cv.glmnet(x2, y2, family = "cox", alpha = 1)
true_min_cox <- 0.1056
true_1se_cox <- 0.2222
expect_equal(fit_cox$lambda.min, true_min_cox, tolerance = 1e-3)
expect_equal(fit_cox$lambda.1se, true_1se_cox, tolerance = 1e-3)

# for family = "binomial"
fit_bin <- cv.glmnet(x3, y3, family = "binomial", alpha = 1, type.measure = "class")
true_min_bin <- 0.06037
true_1se_bin <- 0.07271

expect_equal(fit_bin$lambda.min, true_min_bin, tolerance = 1e-3)
expect_equal(fit_bin$lambda.1se, true_1se_bin, tolerance = 1e-3)


# for family = "gaussian"
fit_gauss <- cv.glmnet(x, y, family = "gaussian", alpha = 1, type.measure = "mse")
true_min_gauss <-  0.1118
true_1se_gauss <- 0.2836
expect_equal(fit_gauss$lambda.min, true_min_gauss, tolerance = 1e-3)
expect_equal(fit_gauss$lambda.1se, true_1se_gauss, tolerance = 1e-3)

})



