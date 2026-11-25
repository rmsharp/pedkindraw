library(testthat)
library(pedkindraw)

## A CRAN check leaves out the test files named in testthat/slowTestFiles.txt
## (CRAN's 10-minute check limit; plan R165); with NOT_CRAN "true", as on CI
## and in local runs, every file runs (testthat/helper-slowTestFiles.R).
source(file.path("testthat", "helper-slowTestFiles.R"))
test_check("pedkindraw", filter = cranTestFilter("testthat"), invert = TRUE)
