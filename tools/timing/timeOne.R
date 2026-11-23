## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/timeOne.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.5, Phase 17h1). Changes: PKD_LIB for NPG_LIB and
## CMP_LIB; the paths; measure.R for tools/perf/harness.R; a case's `loads`
## loaded with its package; a pedkindraw case stops unless pedkindraw comes
## from PKD_LIB; the watched packages are pedkindraw, kinship2 and Pedixplorer.
## One timing measurement in a fresh process (Phase 1 step 4): load only the
## case's package (and those it loads), build its inputs, then time the one
## call. Run from the project root (renv active), normally by runLimited() in
## timingHarness.R:
##   PKD_LIB=<scratch>/pkdlib \
##   Rscript tools/timing/timeOne.R <case id> <pedigree name>
## PKD_LIB holds pedkindraw installed from the commit timed (byte-compiled, as
## CRAN installs it); kinship2 and Pedixplorer come from renv's library. A
## pedkindraw case stops, naming PKD_LIB, when PKD_LIB holds no pedkindraw or
## pedkindraw was loaded from another folder. Prints "CALL START" just before
## the call and then one line:
##   TIMING seconds=<s> heapPeakMb=<Mb> preRssMb=<Mb> loaded=<packages>
##     pkdLib=<folder>
## seconds and heapPeakMb come from measure() in measure.R (R's heap
## high-water mark above the starting point, a lower bound); preRssMb is the
## process's resident memory just before the call.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2L) stop("usage: timeOne.R <case id> <pedigree name>")
here <- file.path("tools", "timing")
# nolint start: undesirable_function_linter.
source(file.path(here, "comparisonFormats.R"))
source(file.path(here, "timingHarness.R"))
source(file.path(here, "measure.R"))
source(file.path(here, "timingCases.R"))
# nolint end
## The helpers come from the files sourced above, which lintr cannot see.
# nolint start: object_usage_linter.
useTimingLibraries()
case <- Find(function(k) identical(k$id, args[[1L]]), timingCases())
if (is.null(case)) stop("no timing case '", args[[1L]], "'")
p <- readComparisonPedigree(file.path(here, "data", paste0(args[[2L]], ".csv")))
## kinship2 and Pedixplorer load Matrix with their own namespace; pedkindraw
## loads it on first use. Load it here for every case, so that no timed call
## includes loading a package.
loadNamespace("Matrix")
packages <- c(case$loads, case$package)
pkdLib <- Sys.getenv("PKD_LIB")
if ("pedkindraw" %in% packages &&
  !(nzchar(pkdLib) && dir.exists(file.path(pkdLib, "pedkindraw")))) {
  stop("PKD_LIB (", pkdLib, ") holds no pedkindraw: install the commit to ",
    "time there",
    call. = FALSE
  )
}
for (package in packages) loadNamespace(package)
if ("pedkindraw" %in% packages) {
  checkPedkindrawFolder(dirname(getNamespaceInfo("pedkindraw", "path")), pkdLib)
}
x <- case$prepare(p)
set.seed(1L)
reportTimedCall(case$call(x), c("pedkindraw", "kinship2", "Pedixplorer"))
# nolint end
