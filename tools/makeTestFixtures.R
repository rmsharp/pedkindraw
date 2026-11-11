## Saves the sample pedigrees the copied tests read: exact copies of
## nprcgenekeepr's datasets at one commit. pedkindraw cannot use
## nprcgenekeepr, so its tests read these files instead (plan Phases 6-10;
## Mark's pick in S3: test files, not package datasets).
##
## Usage, from the pedkindraw root:
##   Rscript tools/makeTestFixtures.R <nprcgenekeepr clone> <commit> <name>...
## For example:
##   Rscript tools/makeTestFixtures.R ../nprcgenekeepr baef1e12c \
##     lacy1989Ped smallPed
##
## Each dataset is read from the commit's data/<name>.RData with git show, so
## nprcgenekeepr need not be installed or checked out at that commit. It is
## written to tests/testthat/fixtures/<name>.rds.

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3L) {
  stop(
    "usage: Rscript tools/makeTestFixtures.R <nprcgenekeepr clone> ",
    "<commit> <name>...",
    call. = FALSE
  )
}
clone <- args[[1L]]
commit <- args[[2L]]
datasets <- args[-(1L:2L)]
outDir <- file.path("tests", "testthat", "fixtures")
dir.create(outDir, showWarnings = FALSE, recursive = TRUE)

for (name in datasets) {
  rdata <- tempfile(fileext = ".RData")
  status <- system2(
    "git",
    c("-C", shQuote(clone), "show", paste0(commit, ":data/", name, ".RData")),
    stdout = rdata
  )
  if (!identical(status, 0L)) {
    stop("git show found no data/", name, ".RData at ", commit, call. = FALSE)
  }
  env <- new.env()
  loaded <- load(rdata, envir = env)
  unlink(rdata)
  if (!identical(loaded, name)) {
    stop(
      "data/", name, ".RData holds ", toString(loaded), ", not ", name,
      call. = FALSE
    )
  }
  outFile <- file.path(outDir, paste0(name, ".rds"))
  saveRDS(env[[name]], outFile, version = 3L)
  cat("wrote", outFile, "\n")
}
