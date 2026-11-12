## Saves the test fixtures that nprcgenekeepr's own code builds, for copied
## tests whose fixture comes from a function pedkindraw does not have (plan
## Phases 6-10: such fixtures are replaced by saved files). The datasets are
## saved by tools/makeTestFixtures.R instead.
##
## Usage, from the pedkindraw root:
##   Rscript tools/makeComputedTestFixtures.R <nprcgenekeepr clone> <commit>
## For example:
##   Rscript tools/makeComputedTestFixtures.R ../nprcgenekeepr baef1e12c
##
## The commit's DESCRIPTION, NAMESPACE, R/, data/ and inst/ are unpacked with
## git archive into a temporary folder and loaded with pkgload::load_all() in
## an R process started in the clone, so it uses the clone's renv library
## (nprcgenekeepr's imports) and runs the commit's code whatever the clone
## has checked out. Writes to tests/testthat/fixtures/:
## - qcdRhesusPed.rds: runQcStudbook()'s cleaned pedigree of
##   inst/extdata/examples/obfuscated_rhesus_mhc_ped.csv, as nprcgenekeepr's
##   tests/testthat/helper-qcdRhesusPed.R makes it (Phase 8).
## Until Phase 10 it also wrote trackBShrunk.rds, nprcgenekeepr's
## shrinkPedigree() result for a stand-in; Phase 10 copied the function and
## deleted both (plan R39).

## The fixtures: run inside the child process, where nprcgenekeepr is
## loaded and `src` is the unpacked commit. Its functions are called through
## its namespace, `ns`.
buildFixtures <- function(src) {
  ns <- asNamespace("nprcgenekeepr")
  raw <- utils::read.csv(
    file.path(src, "inst", "extdata", "examples",
              "obfuscated_rhesus_mhc_ped.csv"),
    stringsAsFactors = FALSE
  )
  qcdRhesusPed <- suppressWarnings(suppressMessages(
    ns$runQcStudbook(raw, minSireAge = NULL, minDamAge = NULL,
                     reportChanges = TRUE)
  ))$cleaned
  list(qcdRhesusPed = qcdRhesusPed)
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) >= 1L && identical(args[[1L]], "--child")) {
  ## Child mode: --child <unpacked commit> <output folder>
  pkgload::load_all(args[[2L]], quiet = TRUE, export_all = TRUE)
  fixtures <- buildFixtures(args[[2L]])
  for (name in names(fixtures)) {
    outFile <- file.path(args[[3L]], paste0(name, ".rds"))
    saveRDS(fixtures[[name]], outFile, version = 3L)
    cat("wrote", outFile, "\n")
  }
  quit(status = 0L)
}

if (length(args) != 2L) {
  stop(
    "usage: Rscript tools/makeComputedTestFixtures.R <nprcgenekeepr clone> ",
    "<commit>",
    call. = FALSE
  )
}
clone <- normalizePath(args[[1L]])
commit <- args[[2L]]
script <- normalizePath(file.path("tools", "makeComputedTestFixtures.R"))
outDir <- normalizePath(file.path("tests", "testthat", "fixtures"))

src <- tempfile("nprcgenekeepr-")
dir.create(src)
status <- system2("sh", c("-c", shQuote(paste(
  "git -C", shQuote(clone), "archive", shQuote(commit),
  "DESCRIPTION NAMESPACE R data inst | tar -x -C", shQuote(src)
))))
if (!identical(status, 0L)) {
  stop("git archive could not unpack ", commit, call. = FALSE)
}

## renvFreeEnv(): the arguments for env that undo this process's renv
## settings, so the child starts in the clone's own renv
## (tools/renvFreeEnv.R).
helperFile <- file.path("tools", "renvFreeEnv.R")
source(helperFile) # nolint: undesirable_function_linter.

## One change of folder for one child process; withr is only a test
## dependency (Suggests).
old <- setwd(clone) # nolint: undesirable_function_linter.
status <- system2("env", c(
  renvFreeEnv(), "Rscript", shQuote(script), "--child", shQuote(src),
  shQuote(outDir)
))
setwd(old) # nolint: undesirable_function_linter.
unlink(src, recursive = TRUE)
if (!identical(status, 0L)) {
  stop("the run in ", clone, " failed", call. = FALSE)
}
