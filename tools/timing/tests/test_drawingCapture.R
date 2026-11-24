## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## The tests of tools/timing/drawingCapture.R, the four Pedixplorer helpers
## copied from nprcgenekeepr tools/pedigreeComparison/drawingCapture.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h3; R157). nprcgenekeepr's
## tests/test_drawingCapture.R tests the capture functions, which pedkindraw
## does not copy, so its tests are not copied either but for one, "Pedixplorer
## hands back ids that contain an underscore", which becomes
## pedixplorerKey()'s first test; the others are new. The drawing cases that
## call these helpers are tested in test_drawingTiming.R. Run from the project
## root:
##   Rscript -e 'testthat::test_file(
##     "tools/timing/tests/test_drawingCapture.R")'

library(testthat) # nolint: undesirable_function_linter.

sourceComparisonScript("comparisonFormats.R")
sourceComparisonScript("generateColonyPedigree.R")
sourceComparisonScript("drawingCapture.R")

## The helpers come from the files sourced above, which lintr cannot see.
# nolint start: object_usage_linter.

## Three animals whose ids hold underscores.
underscored <- function() {
  data.frame(
    id = c("A_1", "B", "C_2"), sire = c(NA, NA, "A_1"),
    dam = c(NA, NA, "B"), sex = c("M", "F", "F"), stringsAsFactors = FALSE
  )
}

## ---- the keys and the input ------------------------------------------------

test_that("pedixplorerKey() writes '.' for each '_', in the pedigree's order", {
  expect_identical(pedixplorerKey(underscored()), c("A.1", "B", "C.2"))
})

test_that("pedixplorerKey() stops when two ids become one key", {
  ped <- data.frame(id = c("A_1", "A.1"), stringsAsFactors = FALSE)
  expect_error(pedixplorerKey(ped), "ids clash once '_' becomes '.'",
    fixed = TRUE
  )
})

test_that("pedixplorerFrame() gives Pedixplorer's columns, every id and
  parent on its key", {
  ped <- underscored()
  x <- pedixplorerFrame(ped)
  expect_named(x, names(toPedixplorer(ped)))
  expect_identical(x$id, c("A.1", "B", "C.2"))
  expect_identical(x$dadid, c(NA, NA, "A.1"))
  expect_identical(x$momid, c(NA, NA, "B"))
  expect_identical(x$sex, toPedixplorer(ped)$sex)
})

test_that("pedixplorerFrame() takes the keys it is given", {
  x <- pedixplorerFrame(underscored(), key = c("a", "b", "c"))
  expect_identical(x$id, c("a", "b", "c"))
  expect_identical(x$dadid, c(NA, NA, "a"))
  expect_identical(x$momid, c(NA, NA, "b"))
})

## ---- the plot data, on a device of a given size -----------------------------

## pedixplorerPlotData() of `ped` on an open PNG device of width x height.
plotDataOn <- function(ped, width, height) {
  grDevices::png(tempfile(fileext = ".png"), width, height)
  on.exit(grDevices::dev.off())
  pp <- suppressWarnings(Pedixplorer::Pedigree(
    pedixplorerFrame(completeParentage(ped))
  ))
  pedixplorerPlotData(pp)
}
## The sample and the colony as the harness reads them (timingPedigree(),
## helper-caseValues.R).
samplePedigree <- function() timingPedigree("sample")

test_that("the sample's plot data on the canvas is at Pedixplorer's
  defaults", {
  d <- plotDataOn(samplePedigree(), 3600L, 1500L)
  expect_named(d, c("d", "cex", "force"))
  expect_identical(d$cex, 1.0)
  expect_false(d$force)
  expect_s3_class(d$d$df, "data.frame")
  expect_gt(nrow(d$d$df), 0L)
})

test_that("smaller labels are taken only when Pedixplorer asks for them", {
  d <- plotDataOn(samplePedigree(), 600L, 400L)
  expect_identical(d$cex, 0.25)
  expect_false(d$force)
})

test_that("it stops when even the smallest labels leave no room", {
  expect_error(plotDataOn(samplePedigree(), 300L, 200L), "reduce cex",
    fixed = TRUE
  )
})

test_that("it stops on any other refusal: the 300-animal colony", {
  expect_error(
    plotDataOn(timingPedigree("colony"), 3600L, 1500L),
    "subscript out of bounds",
    fixed = TRUE
  )
})

test_that("it turns force on only when the alignment refuses with
  'kindepth', as Pedixplorer's message suggests", {
  calls <- list()
  local_mocked_bindings(
    ped_to_plotdf = function(pp, cex, force) {
      calls[[length(calls) + 1L]] <<- c(cex = cex, force = force)
      if (!force) stop("the alignment failed; see kindepth(), or force")
      list(df = data.frame(), par_usr = list())
    },
    .package = "Pedixplorer"
  )
  d <- pedixplorerPlotData("a pedigree object")
  expect_true(d$force)
  expect_identical(d$cex, 1.0)
  expect_identical(calls, list(
    c(cex = 1.0, force = 0.0), c(cex = 1.0, force = 1.0)
  ))
})

## ---- drawing the plot data -------------------------------------------------

## A PNG file of 1200 x 800 pixels holding what `draw()` puts on its device.
pngOf <- function(draw) {
  file <- tempfile(fileext = ".png")
  grDevices::png(file, 1200L, 800L)
  on.exit(grDevices::dev.off())
  draw()
  file
}

test_that("plotPedixplorerData() draws the plot data on the open device", {
  blank <- pngOf(graphics::plot.new)
  drawn <- pngOf(function() {
    pp <- suppressWarnings(Pedixplorer::Pedigree(
      pedixplorerFrame(completeParentage(samplePedigree()))
    ))
    plotPedixplorerData(pedixplorerPlotData(pp)$d)
  })
  expect_true(isPng(drawn))
  expect_gt(file.size(drawn), 4.0 * file.size(blank))
})
# nolint end
