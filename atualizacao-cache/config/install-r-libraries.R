# Verify packages
libs.required = c("readr", "data.table", "purrr", "stringr", "ggplot2")
libs.installed = installed.packages()[, 'Package']
libs.not.installed = sapply(libs.required, function (x) !(x %in% libs.installed))

# Install dependencies
if (sum(libs.not.installed) >= 1) {
  install.packages(libs.required[as.vector(libs.not.installed)], repos='http://cran.us.r-project.org')
}
