## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/runDrawingTiming.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1, 4.2, 5.4 and 5.6, Phase 17h3; R157). Changes, as
## runTiming.R's in Phases 17h1-17h1c: PKD_LIB for NPG_LIB and CMP_LIB; the
## paths, and the pictures in tools/timing/pictures/ (git-ignored); the
## record's row in <out>/record.csv before the first run (recordRow(), R155,
## which stops the record unless PKD_LIB holds the commit checked out); each
## run's row built by drawingRunRow() (drawingTiming.R), with the free memory
## read just before the run (R155), the folder pedkindraw was loaded from,
## and the time runLimited() launched the R part as its started (R156; the
## copy wrote the time the row was made); a run that failed over PKD_LIB
## stops the record (stopsRecord()); pedigreeSize() for sizeOf(); the zoom-1
## picture is pedkindraw's page's (pkd_page).
## The drawing timing (Mark's rulings S1125 for the study: synthetic sizes
## 300, 1,000, 2,000 and 3,000 plus rhesus375; a drawing counts only when R
## and the browser together finish within 120 s; the plotly versions are
## timed in Chrome). For each case in drawingTimingCases.R and each
## synthetic size, smallest first: one warm-up run, which is also the
## capacity test, then three measured runs; a case stops at its first
## failing size; then rhesus375, the same way. A run is one fresh process
## for the R part (drawOne.R under runLimited(), 32 GB) and, for a web page,
## one fresh Chrome tab for the browser part (timeBrowserDraw(), given what
## is left of the 120 s). Before each run the script waits until at least
## half the CPU is idle (waitForQuiet(), Mark's ruling S1123). Run from the
## project root, with PKD_LIB naming the scratch library pedkindraw was
## installed into from the commit timed (the plan's section 5.5):
##   PKD_LIB=<scratch>/pkdlib Rscript tools/timing/runDrawingTiming.R \
##     [--sizes=300,1000] [--out=<dir>] [--pictures=<dir>] [--append] \
##     [case id ...]
## --append keeps the other cases' rows in the two tables and adds these.
## Writes, before the first run, one row in <out>/record.csv (the record:
## the commit, versions and machine); after every run,
## <out>/drawingTimingRuns.csv (every run) and <out>/drawingTiming.csv (one
## row per case and pedigree: the median of the measured runs, or how it
## failed), and <out>/drawingTimingMachine.txt (the busiest processes at the
## start and the end); <out> defaults to results/ beside this script. The
## warm-up's picture, file or page, a Chrome picture of each page and a
## picture of pedkindraw's page at zoom 1 go to <pictures>
## (tools/timing/pictures/, git-ignored).
# nolint start: undesirable_function_linter.
source(file.path("tools", "timing", "timingHarness.R"))
source(file.path("tools", "timing", "drawingTiming.R"))
source(file.path("tools", "timing", "drawingTimingCases.R"))
# nolint end
## The helpers come from the files sourced above, which lintr cannot see.
# nolint start: object_usage_linter.
here <- file.path("tools", "timing")
args <- commandArgs(trailingOnly = TRUE)
sizes <- as.integer(strsplit(
  scriptOption(args, "sizes", "300,1000,2000,3000"), ",",
  fixed = TRUE
)[[1L]])
outDir <- scriptOption(args, "out", file.path(here, "results"))
imgDir <- scriptOption(args, "pictures", file.path(here, "pictures"))
wanted <- grep("^--", args, value = TRUE, invert = TRUE)
timeLimit <- 120.0
memLimit <- 32.0e9
idleFloor <- 50.0
measuredRuns <- 3L
width <- 3600L
height <- 1500L

cases <- drawingCases()
if (length(wanted) > 0L) {
  unknown <- setdiff(wanted, vapply(cases, `[[`, "", "id"))
  if (length(unknown) > 0L) stop("no drawing case: ", toString(unknown))
  cases <- Filter(function(k) k$id %in% wanted, cases)
}
script <- normalizePath(file.path(here, "drawOne.R"))
## The record's row (R155), made before anything is written: it stops the
## record when the commit it names is not the code PKD_LIB holds.
record <- recordRow("drawing", Sys.getenv("PKD_LIB"))
dir.create(outDir, showWarnings = FALSE)
appendRecordRow(record, file.path(outDir, "record.csv"))
dir.create(imgDir, showWarnings = FALSE, recursive = TRUE)
runDir <- tempfile("drawingRuns")
dir.create(runDir)
machineFile <- file.path(outDir, "drawingTimingMachine.txt")

rows <- new.env()
rows$runs <- list()
rows$cells <- list()
if ("--append" %in% args) {
  others <- function(name) {
    path <- file.path(outDir, name)
    if (!file.exists(path)) {
      return(list())
    }
    d <- utils::read.csv(path, stringsAsFactors = FALSE)
    list(d[!d$case %in% vapply(cases, `[[`, "", "id"), , drop = FALSE])
  }
  rows$runs <- others("drawingTimingRuns.csv")
  rows$cells <- others("drawingTiming.csv")
}
save <- function() {
  if (length(rows$runs) > 0L) {
    utils::write.csv(do.call(rbind, rows$runs),
      file.path(outDir, "drawingTimingRuns.csv"),
      row.names = FALSE
    )
  }
  if (length(rows$cells) > 0L) {
    utils::write.csv(do.call(rbind, rows$cells),
      file.path(outDir, "drawingTiming.csv"),
      row.names = FALSE
    )
  }
}

## One run: the R part, then for a page the browser part. The warm-up keeps
## its picture, file or page, and photographs a page.
runOnce <- function(k, ped, kind) {
  quiet <- waitForQuiet(idleFloor)
  memFree <- currentMemoryFree()
  warm <- identical(kind, "warm-up")
  dir <- if (warm) imgDir else runDir
  r <- runLimited(script,
    c(k$id, ped, normalizePath(dir), as.character(c(width, height))),
    timeLimit = timeLimit, memLimit = memLimit
  )
  b <- NULL
  page <- file.path(dir, sprintf("%s_%s.html", k$id, ped))
  if (identical(k$kind, "browser") && identical(r$status, "ok")) {
    shot <- if (warm) sub("[.]html$", ".png", page) else NULL
    b <- timeBrowserDraw(page, width, height,
      timeLimit = max(timeLimit - r$seconds, 1.0), screenshot = shot
    )
  }
  d <- combineDrawRun(r, b, timeLimit)
  if (warm && identical(k$id, "pkd_page") && identical(d$status, "ok")) {
    zoomedVisScreenshot(page, sub("[.]html$", "_zoom1.png", page),
      width, height,
      scale = 1.0
    )
  }
  rows$runs[[length(rows$runs) + 1L]] <- drawingRunRow(
    k, ped, kind, quiet, memFree, r, d
  )
  save()
  if (stopsRecord(r)) stop("the record stops: ", r$message, call. = FALSE)
  d
}

## One cell: the warm-up, then the measured runs; TRUE when it drew.
cellFor <- function(k, ped) {
  warm <- runOnce(k, ped, "warm-up")
  s <- if (identical(warm$status, "ok")) {
    summarizeDrawingRuns(lapply(seq_len(measuredRuns), function(i) {
      runOnce(k, ped, "measured")
    }))
  } else {
    summarizeDrawingRuns(list(warm))
  }
  rows$cells[[length(rows$cells) + 1L]] <- data.frame(
    case = k$id, package = k$package, form = k$kind, pedigree = ped,
    size = pedigreeSize(ped), status = s$status, message = s$message,
    rSeconds = s$rSeconds, browserSeconds = s$browserSeconds,
    totalSeconds = s$totalSeconds, heapPeakMb = s$heapPeakMb,
    preRssMb = s$preRssMb, maxRssMb = s$maxRssBytes / 1048576.0,
    jsHeapMb = s$jsHeapMb, warmupTotalSeconds = warm$totalSeconds,
    runs = s$runs
  )
  save()
  cat(k$id, ped, s$status, if (identical(s$status, "ok")) s$totalSeconds,
    "\n")
  identical(s$status, "ok")
}

machineNote(if ("--append" %in% args) "start, appending" else "start",
  machineFile)
cat("start", format(Sys.time()), "idle", currentIdle(), "\n")
for (k in cases) {
  for (n in sizes) {
    if (!cellFor(k, sprintf("synthetic_%d", n))) break
  }
  cellFor(k, "rhesus375")
}
machineNote("end", machineFile)
cat("end", format(Sys.time()), "idle", currentIdle(), "\n")
# nolint end
