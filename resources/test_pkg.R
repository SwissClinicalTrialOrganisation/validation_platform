# test packages on GHA

library(validation)
# tests <- load_tests_table()

to_test <- "accrualPlot"


xx <- test(to_test, testthat_colours = FALSE)

texts <- test_to_text(xx)
issue <- post_issue(texts$issue_body, texts$issue_title)
map(texts$issue_tags, ~ add_label(issue$number, .x))
