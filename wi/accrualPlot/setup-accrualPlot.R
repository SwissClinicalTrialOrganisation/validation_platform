if(!require(accrualPlot)) install.packages('accrualPlot')
library(accrualPlot)
library(testthat)

data(accrualdemo)

mono <- accrual_create_df(accrualdemo$date)
multi <- accrual_create_df(accrualdemo$date, by = accrualdemo$site)

withr::defer({
  rm(accrualdemo)
  detach(package:accrualPlot)
}, teardown_env())
