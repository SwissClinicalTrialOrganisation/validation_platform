# update tests table on GHA

library(SCTORvalidation)

cat("Updating table\n")
tests <- SCTORvalidation::update_tests_table()

cat("Writing table\n")
readr::write_csv(tests, "tables/package_tests.csv", na = "")
