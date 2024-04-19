# test packages on GHA

library(validation)
# tests <- load_tests_table()

# issuenum <- Sys.getenv("NUMBER")
# issue <- get_issue(issuenum)
# issue_body <- issue$body
# package <-

issuenum <- Sys.getenv("NUMBER")
issue <- get_issue(issuenum)
title <- issue$title
pkg <- gsub("[Run test]", "", title, fixed = TRUE) |> trimws()

to_test <- pkg

xx <- test(to_test, testthat_colours = FALSE)

texts <- test_to_text(xx)

cat("Texts prepared\n")

issue <- post_comment(issuenum, texts$issue_body)

cat("issue updated\n")

# lapply(texts$issue_tags, function(x) add_label(issue = issue$number, label = x))
#
# cat("labels set")


