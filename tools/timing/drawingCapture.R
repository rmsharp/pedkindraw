## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/drawingCapture.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h3; R157). Changes: only the four Pedixplorer helpers
## the drawing cases call (drawingTimingCases.R) are copied:
## pedixplorerPlotData(), pedixplorerKey(), pedixplorerFrame() and
## plotPedixplorerData(), with their comments. The capture functions
## (drawKinship2(), drawPedixplorer(), drawGgpedigree(), drawNprcgenekeepr())
## and the table helpers only they use (conditionColumns(), symbolTable(),
## segmentTable(), isDashed(), isBlank(), displayListLines(),
## ggpedigreeFrame()) serve the study's parent-line comparison
## (runDrawing.R), which pedkindraw does not copy; so do the file's opening
## comment and its kinship2, ggpedigree and nprcgenekeepr sections.
## Pedixplorer's drawing helpers for the drawing-timing cases. Needs
## comparisonFormats.R sourced (toPedixplorer()) and Pedixplorer on the
## library path. Tests: tests/test_drawingCapture.R.

## ---- Pedixplorer ----------------------------------------------------------

## Pedixplorer's plot data for `pp` on the open device, at its default
## settings where it accepts them: force = TRUE only when its alignment
## refuses (its message suggests it), smaller labels only when it says
## "reduce cex". Returns list(d, cex, force); stops on any other refusal.
pedixplorerPlotData <- function(pp) {
  attempt <- function(cex, force) {
    tryCatch(Pedixplorer::ped_to_plotdf(pp, cex = cex, force = force),
      error = function(e) e
    )
  }
  force <- FALSE
  for (cex in c(1.0, 0.5, 0.25, 0.125)) {
    d <- attempt(cex, force)
    if (!force && inherits(d, "error") &&
          grepl("kindepth", conditionMessage(d), fixed = TRUE)) {
      force <- TRUE
      d <- attempt(cex, force)
    }
    if (!inherits(d, "error") ||
          !grepl("reduce cex", conditionMessage(d), fixed = TRUE)) {
      break
    }
  }
  if (inherits(d, "error")) stop(d)
  list(d = d, cex = cex, force = force)
}

## Pedixplorer::Pedigree() refuses an id with an underscore, so ids are
## drawn with "." in its place: each animal's key, in `ped`'s order.
pedixplorerKey <- function(ped) {
  key <- gsub("_", ".", ped$id, fixed = TRUE)
  if (anyDuplicated(key) > 0L) stop("ids clash once '_' becomes '.'")
  key
}

## Pedixplorer's input for `ped`, on those keys.
pedixplorerFrame <- function(ped, key = pedixplorerKey(ped)) {
  x <- toPedixplorer(ped) # nolint: object_usage_linter.
  x$id <- key
  x$dadid <- key[match(ped$sire, ped$id)]
  x$momid <- key[match(ped$dam, ped$id)]
  x
}

## Draw Pedixplorer's plot data `d` (from ped_to_plotdf()) on the open device.
plotPedixplorerData <- function(d) {
  Pedixplorer::plot_fromdf(d$df,
    usr = d$par_usr$usr, boxw = d$par_usr$boxw, boxh = d$par_usr$boxh
  )
}
