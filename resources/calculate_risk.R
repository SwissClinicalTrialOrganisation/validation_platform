#
# SCRIPT TO CALCULATE THE PACKAGE RISK
# runs via a github action triggered from issue creation or edit.
#

# path to json with info on the triggering issue
issuenum <- Sys.getenv("NUMBER")

library(validation)

issue <- validation:::get_issue(issuenum)

if(validation:::is_package(list(issue))){
  cat("Package issue\n")
  score <- validation:::calculate_pkg_score(list(issue))

  val <- validation:::validate_pkg_issue(score)

  if(val$score_ok){
    cat("  input validation - OK\n")
    gh_message <- paste0("Package ", score$package, " has a score of ",
                         round(score$final_score, 3), " which makes it a **",
                         as.character(score$final_score_cat),
                         "** risk package.", "\n\n",
                         ":sparkles: Thank you for your contribution! :sparkles:")
    can_close <- TRUE

    cat("  Github labels\n")
    validation:::add_label(issuenum, paste(as.character(score$final_score_cat), "risk")) |>
      try() |>
      print()
    validation:::add_label(issuenum, ":sparkles: approved :sparkles:") |>
      try() |>
      print()
    validation:::remove_label(issuenum, ":alarm_clock: triage :alarm_clock:") |>
      try() |>
      print()
    # validation:::close_issue(issuenum)

    cat("  Posting comment\n")
    validation:::post_comment(issuenum, gh_message)

    if(can_close){
      cat("  Closing issue\n")
      validation:::close_issue(issuenum)
    }

    cat("  Updating table\n")
    Sys.sleep(10)
	  pkgs <- validation::update_pkg_table()

    cat("  Writing table\n")
	  readr::write_csv(pkgs, "tables/validated_packages.csv", na = "")

  } else {
    cat("  input validation - FAILED\n")
    gh_message <- val$message
    cat(gh_message)
    validation:::post_comment(issuenum, gh_message)
  }
}

if(validation:::is_test(list(issue))){
  cat("Test issue\n")
  tmp <- issue |>
    list() |>
    validation:::issues_to_df(validation:::extract_elements_test)

  val <- validation:::validate_test_issue(tmp)

  if(val$ok){
    cat("  input validation - OK\n")
    if(tmp$test_result == "PASS"){
      cat("  Test - PASS\n")
      gh_message <- "Tests have passed!\n\n:sparkles: Thank you for your contribution! :sparkles:"

      cat("  Github labels\n")
      if(is_(list(issue), "FAIL") & tmp$test_result == "PASS"){
        cat("  Remove older FAIL label\n")
        validation:::remove_label(issuenum, "FAIL") |>
          try() |>
          print()
      }
      validation:::remove_label(issuenum, ":alarm_clock: triage :alarm_clock:") |>
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

    validation:::add_label(issuenum, tmp$test_result) |>
      try() |>
      print()

    validation:::post_comment(issuenum, gh_message)

    if(can_close){
      cat("Closing issue\n")
      validation:::close_issue(issuenum)
    }

    cat("Updating table\n")
    tests <- validation::update_tests_table(tests = list(issue))
    cat("Writing table\n")
    readr::write_csv(tests, "tables/package_tests.csv", na = "")


  } else {
    cat("  input validation - FAILED\n")
    gh_message <- val$message
    validation:::post_comment(issuenum, gh_message)
  }
}



print(gh_message)
print(can_close)




