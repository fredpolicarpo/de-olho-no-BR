# Verify packages
libs.required = c(
  "purrr",
  "foreach",
  "doMC",
  "crayon",
  "httr",
  "dplyr",
  "stringr",
  "data.table",
  "purrr",
  "foreach",
  "doMC",
  "crayon",
  "dplyr",
  "lubridate",
  "glue")

libs.installed = installed.packages()[, 'Package']
libs.not.installed = sapply(libs.required, function (x) ! (x %in% libs.installed))

# Install dependencies
if (sum(libs.not.installed) >= 1) {
  install.packages(libs.required[as.vector(libs.not.installed)], repos = 'http://cran.us.r-project.org')
}

# Load libraries
lapply(libs.required, require, character.only = TRUE)
