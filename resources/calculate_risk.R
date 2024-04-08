#
# SCRIPT TO CALCULATE THE PACKAGE RISK
# runs via a github action triggered from issue creation or edit.
#

# path to json with info on the triggering issue
issuenum <- Sys.getenv("NUMBER")

library(validation)

issue <- validation:::get_issue(issuenum)

if(validation:::is_package(list(issue))){
  score <- validation:::calculate_pkg_score(list(issue))

  val <- validation:::validate_pkg_issue(score)

  if(val$score_ok){
    gh_message <- paste0("Package ", score$package, " has a score of ",
                         round(score$final_score, 3), " which makes it a **",
                         as.character(score$final_score_cat),
                         "** risk package.", "\n\n",
                         ":sparkles: Thank you for your contribution! :sparkles:")
    can_close <- TRUE

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


    issue <- validation:::get_issue(issuenum)
	  pkgs <- validation::update_pkg_table(pkg = list(issue))
	  readr::write_csv(pkgs, "tables/validated_packages.csv")

  } else {
    gh_message <- val$message
    can_close <- FALSE
  }
}

if(validation:::is_test(list(issue))){

  tmp <- issue |>
    list() |>
    validation:::issues_to_df(validation:::extract_elements_test)

  val <- validation:::validate_test_issue(tmp)

  if(val$ok){

    if(tmp$test_result == "PASS"){
      gh_message <- "Tests have passed!\n\n:sparkles: Thank you for your contribution! :sparkles:"

      if(is_(list(issue), "FAIL") & tmp$test_result == "PASS"){
        validation:::remove_label(issuenum, "FAIL") |>
          try() |>
          print()
      }
      validation:::remove_label(issuenum, ":alarm_clock: triage :alarm_clock:") |>
        try() |>
        print()

      can_close <- TRUE


    } else {
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

    }

    validation:::add_label(issuenum, tmp$test_result) |>
      try() |>
      print()



    tests <- validation::update_tests_table(tests = list(issue))
    readr::write_csv(tests, "tables/package_tests.csv")


  } else {
    gh_message <- val$message
    can_close <- FALSE
  }
}

if(can_close) validation:::close_issue(issuenum)

print(gh_message)
print(can_close)

validation:::post_comment(issuenum, gh_message)


