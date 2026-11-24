## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/drawOne.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.5, Phase 17h3). Changes, as timeOne.R's in Phase 17h1:
## PKD_LIB for NPG_LIB and CMP_LIB; the paths; measure.R for
## tools/perf/harness.R; Matrix loaded for every case; a pedkindraw case
## stops unless pedkindraw comes from PKD_LIB; the watched packages are
## pedkindraw, kinship2 and Pedixplorer.
## One drawing measurement in a fresh process: load only the case's packages,
## build its input, then time the one drawing. Run from the project root
## (renv active), normally by runLimited() in timingHarness.R:
##   PKD_LIB=<scratch>/pkdlib Rscript tools/timing/drawOne.R <case id> \
##     <pedigree name> <out dir> [<width> <height>]
## Writes <out dir>/<case id>_<pedigree name>.png, .svg, .pdf or .html
## (canvas 3,600 x 1,500 pixels unless given; pkd_data writes none). Prints
## "CALL START" just before the drawing and then one line, as timeOne.R:
##   TIMING seconds=<s> heapPeakMb=<Mb> preRssMb=<Mb> loaded=<packages>
##     pkdLib=<folder>
args <- commandArgs(trailingOnly = TRUE)
if (!length(args) %in% c(3L, 5L)) {
  stop("usage: drawOne.R <case id> <pedigree name> <out dir> [width height]")
}
here <- file.path("tools", "timing")
# nolint start: undesirable_function_linter.
source(file.path(here, "comparisonFormats.R"))
source(file.path(here, "timingHarness.R"))
source(file.path(here, "measure.R"))
source(file.path(here, "drawingCapture.R"))
source(file.path(here, "drawingTiming.R"))
source(file.path(here, "drawingTimingCases.R"))
# nolint end
## The helpers come from the files sourced above, which lintr cannot see.
# nolint start: object_usage_linter.
useTimingLibraries()
case <- Find(function(k) identical(k$id, args[[1L]]), drawingCases())
if (is.null(case)) stop("no drawing case '", args[[1L]], "'")
width <- if (length(args) == 5L) as.integer(args[[4L]]) else 3600L
height <- if (length(args) == 5L) as.integer(args[[5L]]) else 1500L
p <- readComparisonPedigree(file.path(here, "data", paste0(args[[2L]], ".csv")))
## As timeOne.R: Matrix for every case, so that no timed call loads it.
loadNamespace("Matrix")
packages <- c(case$package, case$loads)
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
x <- case$prepare(p, width, height)
stem <- file.path(args[[3L]], paste0(case$id, "_", args[[2L]]))
reportTimedCall(case$call(x, stem, width, height),
  c("pedkindraw", "kinship2", "Pedixplorer")
)
# nolint end
