# test packages on GHA

library(validation)
# tests <- load_tests_table()

# issuenum <- Sys.getenv("NUMBER")
# issue <- get_issue(issuenum)
# issue_body <- issue$body
# package <-

to_test <- "accrualPlot"

xx <- test(to_test, testthat_colours = FALSE)

texts <- test_to_text(xx)

cat("Texts prepared\n")

issue <- post_issue(texts$issue_body, texts$issue_title)

cat("issue posted\n")

lapply(texts$issue_tags, ~ add_label(issue$number, .x))

cat("labels set")

cat("Updating table\n")
Sys.sleep(10)
pkgs <- validation::update_pkg_table()

cat("Writing table\n")
readr::write_csv(pkgs, "tables/validated_packages.csv", na = "")
