pkgs <- c("shiny", "shinyFiles", "bs4Dash", "shinyTree")

for (pkg in pkgs) {
  if (pkg %in% rownames(installed.packages())) {
    suppressPackageStartupMessages(
      library(pkg, character.only = TRUE)
    )
  }

}

rm(pkgs, pkg)


