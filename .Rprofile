r <- getOption("repos")             # hard code the US repo for CRAN
r["CRAN"] <- 'http://cran.r-project.org'
options(repos = r)
rm(r)

## from the AER book by Zeileis and Kleiber
options(prompt="R> ", digits=4, show.signif.stars=FALSE)

options("pdfviewer"="zathura")

if(interactive()){
   library(colorout)
   # setOutputColors256(202, 214, 209, 184, 172, 179)
   setOutputColors(normal = 0, negnum = 4, zero = 3, number = 2,
                   date = 4, string = 5, const = 6, false = 5,
                   true = 5, infinite = 1, stderror = 6,
                   warn = c(1, 0, 1), error = c(1, 7),
                   verbose = FALSE, zero.limit = NA)
   library(setwidth)
   options(vimcom.verbose = 1) # optional
   library(vimcom)
}
