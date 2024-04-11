#
# SCRIPT TO CALCULATE THE PACKAGE RISK
# runs via a github action triggered from issue creation or edit.
#

# path to json with info on the triggering issue
issuenum <- Sys.getenv("NUMBER")

library(validation)

issue <- validation:::get_issue(issuenum)

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

print(gh_message)
print(can_close)




