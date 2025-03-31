if(!require('glmnet')) install.packages('glmnet')
library(glmnet)
library(testthat)
library(survival)
# add here the other packages
withr::defer({
  detach(package:glmnet)
}, teardown_env())
