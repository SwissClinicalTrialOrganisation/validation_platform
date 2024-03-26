# 
# SCRIPT TO CALCULATE THE PACKAGE RISK
# runs via a github action triggered from issue creation or edit.
# 

# path to json with info on the triggering issue
issue <- GITHUB_EVENT_PATH
print(issue)
