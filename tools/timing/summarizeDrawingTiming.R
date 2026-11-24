## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/summarizeDrawingTiming.R
## at nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.6, Phase 17h3). Changes: the paths, and --out=<dir> to
## read a folder other than results/ (a trial's), as summarizeTiming.R's; the
## drawings are section 5.1's 11 cases (pedkindraw's six for nprcgenekeepr's
## one, the kinship2 and Pedixplorer cases renamed, ggpedigree's two dropped).
## The drawing timing tables, printed as Markdown from
## results/drawingTiming.csv (runDrawingTiming.R) and
## results/drawingTimingRuns.csv. Run from the project root:
##   Rscript tools/timing/summarizeDrawingTiming.R [--out=<dir>]
## --out names the folder runDrawingTiming.R wrote (results/ beside this
## script by default).
# nolint start: undesirable_function_linter.
source(file.path("tools", "timing", "timingHarness.R"))
# nolint end
## capacityOf() and scriptOption() come from timingHarness.R, which lintr
## cannot see.
# nolint start: object_usage_linter.
here <- scriptOption(commandArgs(trailingOnly = TRUE), "out",
  file.path("tools", "timing", "results")
)
cells <- utils::read.csv(file.path(here, "drawingTiming.csv"),
  stringsAsFactors = FALSE
)
runs <- utils::read.csv(file.path(here, "drawingTimingRuns.csv"),
  stringsAsFactors = FALSE
)
cells$message[is.na(cells$message)] <- ""
drawings <- c(
  pkd_page = "pedkindraw | vis.js page, `drawPedigreeDiagram()`",
  pkd_page_direct =
    "pedkindraw | vis.js page, `drawPedigreeDiagram()`, direct lines",
  pkd_svg = "pedkindraw | SVG file, `savePedigreeDiagram()`",
  pkd_pdf = "pedkindraw | PDF file, `savePedigreeDiagram()`",
  pkd_png = "pedkindraw | PNG file, `savePedigreeDiagram()`",
  pkd_data = "pedkindraw | diagram data, `makePedigreeDiagramData()`",
  k2_picture = "kinship2 | picture, `plot.pedigree()`",
  pdx_picture = "Pedixplorer | picture, `plot()`",
  pdx_picture_unaligned = "Pedixplorer | picture, `plot()`, alignment off",
  pdx_plotly = "Pedixplorer | plotly page, its app's call",
  pdx_plotly_unaligned =
    "Pedixplorer | plotly page, its app's call, alignment off"
)
drawings <- drawings[names(drawings) %in% cells$case]
columns <- c(
  sprintf("synthetic_%d", c(300L, 1000L, 2000L, 3000L)), "rhesus375"
)
heads <- c("300", "1,000", "2,000", "3,000", "rhesus375 (375)")

## A package's own refusal is "refused"; the limits are "time" and "memory".
failWord <- function(status) {
  if (identical(status, "error")) "refused" else status
}
secondsText <- function(s) format(signif(s, 3L), big.mark = ",")
cellText <- function(case, ped, show) {
  r <- cells[cells$case == case & cells$pedigree == ped, ]
  if (nrow(r) == 0L) {
    return("")
  }
  if (r$status == "ok") show(r) else failWord(r$status)
}
table <- function(title, ids, show) {
  cat("\n", title, "\n\n", sep = "")
  cat("| Package | Drawing |", paste(heads, collapse = " | "), "|\n")
  cat("|---|---|", strrep("---:|", length(heads)), "\n", sep = "")
  for (id in ids) {
    shown <- vapply(columns, function(ped) cellText(id, ped, show), "")
    cat("|", drawings[[id]], "|", paste(shown, collapse = " | "), "|\n")
  }
}

table(
  "Seconds to a drawing (R and browser together), median of 3 measured runs",
  names(drawings), function(r) secondsText(r$totalSeconds)
)
pages <- names(drawings)[cells$form[match(names(drawings), cells$case)] ==
  "browser"]
table(
  "The pages' two parts: R seconds + browser seconds", pages,
  function(r) {
    paste(secondsText(r$rSeconds), "+", secondsText(r$browserSeconds))
  }
)

cat("\nCapacity on the synthetic colonies (largest drawn within 120 s) and",
  "memory there\n\n")
cat(paste(
  "| Package | Drawing | Capacity | Next size failed on |",
  "Process peak (GiB) | R heap peak (MiB) | JavaScript heap (MiB) |\n"
))
cat("|---|---|---:|---|---:|---:|---:|\n")
for (id in names(drawings)) {
  k <- cells[cells$case == id & cells$pedigree != "rhesus375", ]
  cap <- capacityOf(k)
  at <- k[!is.na(cap$capacity) & k$size == cap$capacity, ]
  failed <- if (is.na(cap$failedAt)) {
    "none up to 3,000"
  } else {
    paste(failWord(cap$failure), "at", format(cap$failedAt, big.mark = ","))
  }
  capacity <- if (is.na(cap$capacity)) {
    "below 300"
  } else {
    format(cap$capacity, big.mark = ",")
  }
  cat("|", drawings[[id]], "|", capacity, "|", failed, "|",
    if (nrow(at)) sprintf("%.2f", at$maxRssMb / 1024.0) else "", "|",
    if (nrow(at)) sprintf("%.0f", at$heapPeakMb) else "", "|",
    if (nrow(at) && !is.na(at$jsHeapMb)) sprintf("%.1f", at$jsHeapMb) else "",
    "|\n")
}

cat("\nHow each failure read (first failing run's message):\n\n")
bad <- cells[cells$status != "ok", ]
for (i in seq_len(nrow(bad))) {
  cat("-", bad$case[i], bad$pedigree[i], bad$status[i], ":",
    substr(gsub("\\s+", " ", bad$message[i]), 1L, 160L), "\n")
}

ok <- runs[runs$kind == "measured" & runs$status == "ok", ]
cat(sprintf(paste(
  "\n%d runs (%d measured), %s to %s; idle CPU at each run's start %.1f-%.1f%%",
  "(median %.1f%%); 1-minute load %.1f-%.1f (median %.1f)\n"
), nrow(runs), sum(runs$kind == "measured"), min(runs$started),
max(runs$started), min(runs$idle), max(runs$idle), stats::median(runs$idle),
min(runs$load), max(runs$load), stats::median(runs$load)))
spread <- stats::aggregate(totalSeconds ~ case + pedigree, ok, function(x) {
  (max(x) - min(x)) / max(stats::median(x), 1e-9)
})
slow <- merge(spread, cells[, c("case", "pedigree", "totalSeconds")],
  by = c("case", "pedigree"), suffixes = c(".spread", "")
)
slow <- slow[slow$totalSeconds >= 0.5, ]
cat(sprintf(
  paste(
    "cells of 0.5 s or more: %d; largest (max - min) / median of their",
    "3 runs: %.1f%% (%s %s)\n"
  ),
  nrow(slow), 100.0 * max(slow$totalSeconds.spread),
  slow$case[which.max(slow$totalSeconds.spread)],
  slow$pedigree[which.max(slow$totalSeconds.spread)]
))
# nolint end
