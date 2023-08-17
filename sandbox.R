# Code to export issues and comments from github via the API
library(gh)
repo <- "aghaynes/pkg_validation"
issues <- gh(repo = repo, 
             endpoint = "/repos/:repo/issues",
             .limit = Inf, 
             .params = list(state = "all",
                            "X-GitHub-Api-Version" = "2022-11-28"))
comments <- gh(repo = repo,
               endpoint = "/repos/:repo/issues/comments",
               .limit = Inf, 
               .params = list("X-GitHub-Api-Version" = "2022-11-28"))
# The bodies of the messages then probably need taking apart...
