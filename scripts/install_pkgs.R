
pkgs <- c("terra","dplyr","data.table","readr","sf","sp","gdistance","classInt")
to_inst <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_inst)) install.packages(to_inst, repos = "https://cloud.r-project.org")
message("Ready.")
