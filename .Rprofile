r <- getOption("repos")             # hard code the csiro repo for CRAN
r["CRAN"] <- 'http://cran.csiro.au/'
options(repos = r)
rm(r)

## from the AER book by Zeileis and Kleiber
options(prompt="R> ", digits=4, show.signif.stars=FALSE)

options("pdfviewer"="zathura")

options("formatR.indent"=2)
options("formatR.arrow"=TRUE)

if(interactive()){
   library(devtools)
  .Last <- function() try(savehistory("~/.Rhistory"))
}
