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
## - trackBShrunk.rds: shrinkPedigree() on the 16-animal "Track B" pedigree
##   that test_solveJointQP.R, test_orderRootSubtrees.R and
##   test_positionMatingUnitForest.R shrink (Phase 8; shrinkPedigree() is
##   copied in Phase 10). The first two pass it with its gen column, the third
##   without, so the file holds both calls: a list of two (withGen,
##   withoutGen), each a list of args, the arguments, and value, the result's
##   ped.

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

  pedB <- data.frame(
    id   = c("P1", "P2", "P3", "P4", "P5", "P6",
             "C1", "C2", "C3", "C4", "C4a",
             "G3", "M1", "L1", "L2", "L3"),
    sire = c(NA, NA, NA, NA, NA, NA,
             "P1", "P1", "P1", "P3", "C4",
             NA, "P1", "M1", "M1", "M1"),
    dam  = c(NA, NA, NA, NA, NA, NA,
             "P2", "P2", "P2", "P4", "P6",
             NA, "P2", "G3", "G3", "G3"),
    sex  = c("M", "F", "M", "F", "F", "F",
             "F", "M", "F", "M", "F",
             "F", "M", "F", "M", "M"),
    stringsAsFactors = FALSE
  )
  pedBNoGen <- pedB
  pedB$gen <- ns$findGeneration(pedB$id, pedB$sire, pedB$dam)
  genotypedB <- c(P1 = TRUE, P2 = TRUE, P3 = FALSE, P4 = FALSE, P5 = TRUE,
    P6 = TRUE, C1 = TRUE, C2 = FALSE, C3 = TRUE, C4 = TRUE, C4a = TRUE,
    G3 = FALSE, M1 = TRUE, L1 = TRUE, L2 = TRUE, L3 = TRUE)[pedB$id]
  affectedB <- c(P1 = NA, P2 = NA, P3 = NA, P4 = NA, P5 = NA, P6 = NA,
    C1 = FALSE, C2 = NA, C3 = TRUE, C4 = TRUE, C4a = TRUE, G3 = NA,
    M1 = TRUE, L1 = NA, L2 = FALSE, L3 = TRUE)[pedB$id]
  shrunk <- function(ped) {
    list(
      args = list(ped = ped, genotyped = genotypedB, affected = affectedB,
                  maxBits = 1L),
      value = ns$shrinkPedigree(ped, genotypedB, affected = affectedB,
                                maxBits = 1L)$ped
    )
  }
  trackBShrunk <- list(withGen = shrunk(pedB), withoutGen = shrunk(pedBNoGen))
  list(qcdRhesusPed = qcdRhesusPed, trackBShrunk = trackBShrunk)
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
