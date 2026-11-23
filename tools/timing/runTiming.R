## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/runTiming.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.5, Phase 17h1). Changes: PKD_LIB for NPG_LIB and
## CMP_LIB; the paths; each run's row names the folder pedkindraw was loaded
## from (pkdLib), and a run that failed over PKD_LIB stops the record. Phase
## 17h1b (R155): each run's row also holds the free memory read just before
## it (memFree, the row built by runRow()), and the record's row goes to
## <out>/record.csv before the first run (recordRow(), which stops the
## record when R/, DESCRIPTION or NAMESPACE has uncommitted changes or
## PKD_LIB's pedkindraw was packaged before their last commit). Phase 17h1c
## (R156): each run's started is the time runLimited() launched it, not the
## time its row was made after the run (runRow(), timingHarness.R).
## Phase 1 steps 4-5: timing, memory and capacity (docs/planning/
## standalone-pedigree-package-plan.md). For each case in timingCases.R and
## each synthetic size, smallest first: one warm-up run that is also the
## capacity test (120 s counted from the call's start, 32 GB), then three
## measured runs; every run is a fresh process (timeOne.R under runLimited()).
## A case stops at its first failing size. Before each run the script waits
## until at least half the CPU is idle (at most 10 minutes; Mark's ruling,
## S1123: macOS's own background work keeps the load average high with most
## cores free) and records the idle share and the 1-minute load average it
## started at, and the free memory. Run from the project root, with PKD_LIB
## naming the scratch library pedkindraw was installed into from the commit
## timed (docs/planning/pedkindraw-timing-plan.md section 5.5):
##   PKD_LIB=<scratch>/pkdlib \
##   Rscript tools/timing/runTiming.R [--sizes=300,1000] \
##     [--out=<dir>] [case id ...]
## The record stops when a run finds pedkindraw missing from PKD_LIB or loaded
## from another folder (stopsRecord()); each run's row names the folder.
## Writes, before the first run, one row in <out>/record.csv (the record:
## the commit, versions and machine); after every run, <out>/timingRuns.csv
## (every run) and
## <out>/timing.csv (one row per case and size: the median of the measured
## runs, or how the size failed), and <out>/timingMachine.txt (the busiest
## processes at the start and the end); <out> defaults to results/ beside this
## script.
# nolint start: undesirable_function_linter.
source(file.path("tools", "timing", "timingHarness.R"))
source(file.path("tools", "timing", "timingCases.R"))
# nolint end
## The helpers come from the files sourced above, which lintr cannot see.
# nolint start: object_usage_linter.
here <- file.path("tools", "timing")
args <- commandArgs(trailingOnly = TRUE)
sizes <- as.integer(strsplit(
  scriptOption(args, "sizes", "300,1000,3000,10000,30000,100000"), ",",
  fixed = TRUE
)[[1L]])
outDir <- scriptOption(args, "out", file.path(here, "results"))
wanted <- grep("^--", args, value = TRUE, invert = TRUE)
timeLimit <- 120.0
memLimit <- 32.0e9
idleFloor <- 50.0
measuredRuns <- 3L

cases <- timingCases()
if (length(wanted) > 0L) {
  unknown <- setdiff(wanted, vapply(cases, `[[`, "", "id"))
  if (length(unknown) > 0L) stop("no timing case: ", toString(unknown))
  cases <- Filter(function(k) k$id %in% wanted, cases)
}
script <- normalizePath(file.path(here, "timeOne.R"))
## The record's row (R155), made before anything is written: it stops the
## record when the commit it names is not the code PKD_LIB holds.
record <- recordRow("computation", Sys.getenv("PKD_LIB"))
dir.create(outDir, showWarnings = FALSE)
appendRecordRow(record, file.path(outDir, "record.csv"))

machineFile <- file.path(outDir, "timingMachine.txt")

rows <- new.env()
rows$runs <- list()
rows$cells <- list()
save <- function() {
  if (length(rows$runs) > 0L) {
    utils::write.csv(do.call(rbind, rows$runs),
      file.path(outDir, "timingRuns.csv"),
      row.names = FALSE
    )
  }
  if (length(rows$cells) > 0L) {
    utils::write.csv(do.call(rbind, rows$cells),
      file.path(outDir, "timing.csv"),
      row.names = FALSE
    )
  }
}
runOnce <- function(k, n, kind) {
  quiet <- waitForQuiet(idleFloor)
  memFree <- currentMemoryFree()
  r <- runLimited(script, c(k$id, sprintf("synthetic_%d", n)),
    timeLimit = timeLimit, memLimit = memLimit
  )
  rows$runs[[length(rows$runs) + 1L]] <- runRow(k, n, kind, quiet, memFree, r)
  save()
  if (stopsRecord(r)) stop("the record stops: ", r$message, call. = FALSE)
  r
}
cell <- function(k, n, s, warm) {
  rows$cells[[length(rows$cells) + 1L]] <- data.frame(
    case = k$id, computation = k$computation, package = k$package,
    size = n, status = s$status, message = s$message, seconds = s$seconds,
    heapPeakMb = s$heapPeakMb, preRssMb = s$preRssMb,
    maxRssMb = s$maxRssBytes / 1048576.0, warmupSeconds = warm$seconds,
    runs = s$runs
  )
  save()
}

machineNote("start", machineFile)
cat("start", format(Sys.time()), "idle", currentIdle(), "\n")
for (k in cases) {
  for (n in sizes) {
    warm <- runOnce(k, n, "warm-up")
    if (!identical(warm$status, "ok")) {
      cell(k, n, summarizeRuns(list(warm)), warm)
      cat(k$id, n, warm$status, "\n")
      break
    }
    measured <- lapply(seq_len(measuredRuns), function(i) {
      runOnce(k, n, "measured")
    })
    s <- summarizeRuns(measured)
    cell(k, n, s, warm)
    cat(k$id, n, s$status, if (identical(s$status, "ok")) s$seconds, "\n")
    if (!identical(s$status, "ok")) break
  }
}
machineNote("end", machineFile)
cat("end", format(Sys.time()), "idle", currentIdle(), "\n")
# nolint end
