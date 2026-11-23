## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/summarizeTiming.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h1). Changes: the paths, and --out=<dir> to read a
## folder other than results/ (a trial's).
## Phase 1 steps 4-5: the timing and capacity tables of
## docs/research/pedigree-package-comparison-2026-11.md section 7, printed as
## Markdown from results/timing.csv (runTiming.R) and results/timingRuns.csv.
## Run from the project root:
##   Rscript tools/timing/summarizeTiming.R [--out=<dir>]
## --out names the folder runTiming.R wrote (results/ beside this script by
## default).
# nolint start: undesirable_function_linter.
source(file.path("tools", "timing", "timingHarness.R"))
# nolint end
## capacityOf() and scriptOption() come from timingHarness.R, which lintr
## cannot see.
# nolint start: object_usage_linter.
here <- scriptOption(commandArgs(trailingOnly = TRUE), "out",
  file.path("tools", "timing", "results")
)
cells <- utils::read.csv(file.path(here, "timing.csv"),
  stringsAsFactors = FALSE
)
runs <- utils::read.csv(file.path(here, "timingRuns.csv"),
  stringsAsFactors = FALSE
)
cells$message[is.na(cells$message)] <- ""
sizes <- sort(unique(cells$size))

## How a size failed, in a word: R's heap cap and the watchdog are "memory",
## a killed or crashed process is "crash".
failWord <- function(status, message) {
  if (identical(status, "error") && grepl("segfault|bus error", message)) {
    return("crash")
  }
  status
}
secondsText <- function(s) {
  if (s < 0.001) "<0.001" else format(signif(s, 3L), big.mark = ",")
}
sizeText <- function(n) format(n, big.mark = ",")
caseKey <- unique(cells[, c("computation", "package", "case")])

cat("Seconds, median of 3 measured runs; a failed size shows how it failed\n\n")
heads <- paste(sizeText(sizes), collapse = " | ")
cat("| Computation | Package |", heads, "|\n")
cat("|---|---|", strrep("---:|", length(sizes)), "\n", sep = "")
for (i in seq_len(nrow(caseKey))) {
  k <- cells[cells$case == caseKey$case[i], ]
  shown <- vapply(sizes, function(n) {
    r <- k[k$size == n, ]
    if (nrow(r) == 0L) {
      return("")
    }
    if (r$status == "ok") {
      secondsText(r$seconds)
    } else {
      failWord(r$status, r$message)
    }
  }, "")
  cat("|", caseKey$computation[i], "|", caseKey$package[i], "|",
    paste(shown, collapse = " | "), "|\n")
}

cat(paste(
  "\nCapacity (largest size within 120 s and 32 GB, which is 29.8 GiB)",
  "and memory there\n\n"
))
cat(paste(
  "| Computation | Package | Capacity | Next size failed on |",
  "Process peak (GiB) | R heap peak (GiB) | Before the call (GiB) |\n"
))
cat("|---|---|---:|---|---:|---:|---:|\n")
gib <- function(mb) sprintf("%.2f", mb / 1024.0)
for (i in seq_len(nrow(caseKey))) {
  k <- cells[cells$case == caseKey$case[i], ]
  cap <- capacityOf(k)
  at <- k[!is.na(cap$capacity) & k$size == cap$capacity, ]
  failed <- if (is.na(cap$failedAt)) {
    "none up to 100,000"
  } else {
    paste(failWord(cap$failure, cap$message), "at", sizeText(cap$failedAt))
  }
  cat("|", caseKey$computation[i], "|", caseKey$package[i], "|",
    if (is.na(cap$capacity)) "below 300" else sizeText(cap$capacity), "|",
    failed, "|", if (nrow(at)) gib(at$maxRssMb) else "", "|",
    if (nrow(at)) gib(at$heapPeakMb) else "", "|",
    if (nrow(at)) gib(at$preRssMb) else "", "|\n")
}

ok <- runs[runs$kind == "measured" & runs$status == "ok", ]
cat(sprintf(paste(
  "\n%d runs (%d measured), %s to %s; idle CPU at each run's start %.1f-%.1f%%",
  "(median %.1f%%); 1-minute load %.1f-%.1f (median %.1f)\n"
), nrow(runs), sum(runs$kind == "measured"), min(runs$started),
max(runs$started), min(runs$idle), max(runs$idle), stats::median(runs$idle),
min(runs$load), max(runs$load), stats::median(runs$load)))
spread <- stats::aggregate(seconds ~ case + size, ok, function(x) {
  (max(x) - min(x)) / max(stats::median(x), 1e-9)
})
slow <- merge(spread, cells[, c("case", "size", "seconds")],
  by = c("case", "size"), suffixes = c(".spread", "")
)
slow <- slow[slow$seconds >= 0.5, ]
cat(sprintf(
  paste(
    "cells of 0.5 s or more: %d; largest (max - min) / median of their",
    "3 runs: %.1f%%\n"
  ),
  nrow(slow), 100.0 * max(slow$seconds.spread)
))
# nolint end
