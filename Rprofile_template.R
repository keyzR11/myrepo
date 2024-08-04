# Set a CRAN mirror
options(repos = c(CRAN = "https://cran.rstudio.com"))

# Set a default CRAN mirror (if repos is not set)
if (getOption("repos") == "@CRAN@") {
  options(repos = c(CRAN = "https://cran.rstudio.com"))
}

# Increase default number of rows printed in tibbles
options(tibble.print_max = 50)

# Automatically load commonly used packages
if (interactive()) {
  suppressMessages({
    library(dplyr)
    library(ggplot2)
    library(tidyr)
  })
}

# Set default working directory (project-specific)
setwd("~/path_to_project")

# Custom function example
hello <- function() {
  cat("Hello, R user!\n")
}

# Call the custom function on startup (optional)
hello()