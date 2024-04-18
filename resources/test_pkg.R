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

lapply(texts$issue_tags, function(x) add_label(issue = issue$number, label = x))

cat("labels set")


