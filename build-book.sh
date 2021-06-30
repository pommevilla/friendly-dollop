#! /usr/bin/env Rscript


# ensure that rmarkdown is installed
if (!require("rmarkdown"))
  install.packages("rmarkdown", repos = "https://cran.rstudio.com")

# remove existing _book
unlink('_site', recursive = TRUE)

# render all formats
system2("quarto", c("render", "--to", "all"))

# build zipfile for transfer
oldwd <- setwd('_site')
on.exit(setwd(oldwd), add = TRUE)
book_files <- list.files(recursive = TRUE)
zip('../rstudio-server-pro-23.12.5-17-admin-guide.zip', book_files)



