# Verify packages
libs.required = c(
  "shiny",
  "ggplot2",
  "dplyr",
  "shinydashboard",
  "lubridate",
  "glue",
  "RPostgreSQL",
  "properties",
  "tidyr",
  "plotly",
  "XML",
  "RCurl",
  "maptools",
  "RColorBrewer",
  "rgdal"
  )
libs.installed = installed.packages()[, 'Package']
libs.not.installed = sapply(libs.required, function (x) !(x %in% libs.installed))

# Install dependencies
if (sum(libs.not.installed) >= 1) {
  install.packages(libs.required[as.vector(libs.not.installed)], repos='http://cran.us.r-project.org')
}

# Load libraries
lapply(libs.required, require, character.only = TRUE)