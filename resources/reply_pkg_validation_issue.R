#
# SCRIPT TO CALCULATE THE PACKAGE RISK
# runs via a github action triggered from issue creation or edit.
#

# path to json with info on the triggering issue
issuenum <- Sys.getenv("NUMBER")

library(SCTORvalidation)

issue <- SCTORvalidation:::get_issue(issuenum)

cat("Package issue\n")
score <- SCTORvalidation:::calculate_pkg_score(list(issue))

val <- SCTORvalidation:::validate_pkg_issue(score)

if(val$score_ok){
  cat("  input validation - OK\n")
  gh_message <- paste0("Package ", score$package, " has a score of ",
                       round(score$final_score, 3), " which makes it a **",
                       as.character(score$final_score_cat),
                       "** risk package.", "\n\n",
                       ":sparkles: Thank you for your contribution! :sparkles:")
  can_close <- TRUE

  cat("  Github labels\n")
  SCTORvalidation:::add_label(issuenum, paste(as.character(score$final_score_cat), "risk")) |>
    try() |>
    print()
  SCTORvalidation:::add_label(issuenum, ":sparkles: approved :sparkles:") |>
    try() |>
    print()
  SCTORvalidation:::remove_label(issuenum, ":alarm_clock: triage :alarm_clock:") |>
    try() |>
    print()
  # SCTORvalidation:::close_issue(issuenum)

  cat("  Posting comment\n")
  SCTORvalidation:::post_comment(issuenum, gh_message)

  if(can_close){
    cat("  Closing issue\n")
    SCTORvalidation:::close_issue(issuenum)
  }

  cat("  Updating table\n")
  Sys.sleep(10)
  pkgs <- SCTORvalidation::update_pkg_table()

  cat("  Writing table\n")
  readr::write_csv(pkgs, "tables/validated_packages.csv", na = "")

} else {

  cat("  input validation - FAILED\n")
  gh_message <- val$message
  cat(gh_message)
  SCTORvalidation:::post_comment(issuenum, gh_message)

}

print(gh_message)
print(can_close)




