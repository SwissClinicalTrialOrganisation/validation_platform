# 
# SCRIPT TO CALCULATE THE PACKAGE RISK
# runs via a github action triggered from issue creation or edit.
# 

# path to json with info on the triggering issue
issuenum <- Sys.getenv("NUMBER")

library(validation)

issue <- get_issue(issuenum)

if(is_package(list(issue))){
  score <- calculate_pkg_score(list(issue))

  val <- validate_pkg_issue(score)

  if(val$score_ok){
    gh_message <- paste0("Package ", score$package, " has a score of ",
                         round(score$final_score, 3), " which makes it a **",
                         as.character(score$final_score_cat),
                         "** risk package.", "\n\n",
                         ":sparkles: Thank you for your contribution! :sparkles:")
    can_close <- TRUE
  } else {
    gh_message <- val$message
    can_close <- FALSE
  }
}

print(gh_message)
print(can_close)



