#
# SCRIPT TO validate and respond to a package test issue.
# runs via a github action triggered from issue creation or edit.
#

# path to json with info on the triggering issue
issuenum <- Sys.getenv("NUMBER")

library(SCTORvalidation)

issue <- SCTORvalidation:::get_issue(issuenum)

cat("Test issue\n")
tmp <- issue |>
  SCTORvalidation:::extract_elements_test()

val <- SCTORvalidation:::validate_test_issue(tmp)

if(val$ok){

  cat("  input validation - OK\n")

  if(tmp$test_result == "PASS"){
    cat("  Test - PASS\n")
    gh_message <- "Tests have passed!\n\n:sparkles: Thank you for your contribution! :sparkles:"
    cat("  Github labels\n")

    if(is_(list(issue), "FAIL") & tmp$test_result == "PASS"){
      cat("  Remove older FAIL label\n")
      SCTORvalidation:::remove_label(issuenum, "FAIL") |>
        try() |>
        print()
    }

    SCTORvalidation:::remove_label(issuenum, ":alarm_clock: triage :alarm_clock:") |>
      try() |>
      print()
    can_close <- TRUE

  } else {

    cat("  Tests failed\n")
    gh_message <- paste0(
      "Tests have failed!",
      "\n\n",
      "Please investigate:",
      "\n\n",
      " - do the tests need correcting?",
      "\n\n",
      " - has the package changed such that the tests require updating?",
      "\n\n",
      " - is there a bug in the package? If so, consider making a bug report to the package developer. Post a link to the issue here.",
      collapse = "\n\n")
    can_close <- FALSE

  }

  SCTORvalidation:::add_label(issuenum, tmp$test_result) |>
    try() |>
    print()

  SCTORvalidation:::post_comment(issuenum, gh_message)

  if(can_close){
    cat("Closing issue\n")
    SCTORvalidation:::close_issue(issuenum)
  }

  cat("Updating table\n")
  tests <- SCTORvalidation::update_tests_table()

  cat("Writing table\n")
  readr::write_csv(tests, "tables/package_tests.csv", na = "")

} else {

  cat("  input validation - FAILED\n")
  gh_message <- val$message
  SCTORvalidation:::post_comment(issuenum, gh_message)

}



print(gh_message)
print(can_close)




