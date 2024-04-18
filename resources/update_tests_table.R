# update tests table on GHA

library(validation)

cat("Updating table\n")
tests <- validation::update_tests_table()

cat("Writing table\n")
readr::write_csv(tests, "tables/package_tests.csv", na = "")
