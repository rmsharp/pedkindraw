## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S72, plan
## Phase G16c, gap A2 of docs/research/pedkindraw-gaps-2026-11-18.md;
## docs/planning/picture-files-plan.md section 7, G16c). The 375 rhesus animals
## of the package's example pedigree, with their 3 twin pairs, written by
## savePedigreeDiagram() as an SVG, a PDF and a PNG with every id: 545 id texts
## (the 375 animals and 170 repeat appearances), 375 distinct, none over
## another. (kinship2 and Pedixplorer, drawing the same pedigree at cex 0.5 on
## 7 inch pages, overlap nearly all of theirs, plan section 2; the counts of
## tools/gapCases.R's largeIds case are 520 and 473 labels, S72.)
##
## These tests lock what G16b built (S71): the function was written and these
## tests pass on it. Each is shown able to fail on a scratch copy of the
## package whose recording layer drops the ids, or makes them 30 times larger so
## that they overlap (S72's RED, SESSION_NOTES.md). Every number is one machine's
## (macOS, Chrome 157, poppler 26.08, plan dragon 12) and is stated as it was
## measured, with a bound where Chrome's or poppler's version can move it:
## docs/planning/picture-files-prototype/g16cMeasure1-3.R.
##
## An id's size: the SVG writes it at font-size 0.893 (user units; 1 unit is 1
## CSS pixel, 0.75 pt, on a 14 inch wide page of a 1344 wide viewBox), and
## pdftotext's word box is 0.75 pt high on the 14 by 7 inch page and 0.45 pt on
## letter paper. Under 1 pt, so a reader zooms in (vector files) or needs dpi:
## at the default 300 an id in the PNG is 2.8 pixels high.

.colonyWidget <- function() drawPedigreeDiagram(.saveRhesusLayout())

test_that("the 375 animals' SVG writes 545 ids, 375 distinct, and none lies over
           another", {
  .skipUnlessBrowser()
  ids <- .saveRhesusPed()$id
  svg <- file.path(.saveTmp(), "rhesus.svg")
  savePedigreeDiagram(.colonyWidget(), svg, width = 14, height = 7)

  ## Measured in Chrome: 545 texts, 375 distinct (the 375 animals and 170
  ## repeat appearances), boxes 3.4 by 1.0 pixels at the median, 0 over another.
  boxes <- .saveSvgIdBoxes(svg, ids)
  expect_identical(nrow(boxes), 545L)
  expect_identical(length(unique(boxes$text)), 375L)
  expect_identical(.saveOverlapped(boxes), 0L)
})

test_that("the 375 animals' PDF writes 545 ids, 375 distinct, and none lies over
           another word, on a 14 by 7 inch page and on letter paper", {
  .skipUnlessBrowser(pdftotext = TRUE)
  ids <- .saveRhesusPed()$id
  dir <- .saveTmp()
  widget <- .colonyWidget()

  ## Measured on both pages: 567 words (545 ids, 375 distinct; the legend's
  ## labels are the rest), none of the ids over another word; the median id box
  ## 0.75 pt high on 14 by 7 inches and 0.45 pt on letter paper (8.5 by 11).
  for (page in list(c(14, 7), c(8.5, 11))) {
    pdf <- file.path(dir, sprintf("rhesus-%gx%g.pdf", page[[1L]], page[[2L]]))
    savePedigreeDiagram(widget, pdf, width = page[[1L]], height = page[[2L]])
    expect_identical(.savePdfPages(pdf)$pages, 1L)

    boxes <- .savePdfBoxes(pdf)
    isId <- boxes$text %in% ids
    expect_identical(sum(isId), 545L)
    expect_identical(length(unique(boxes$text[isId])), 375L)
    expect_identical(.saveOverlapped(boxes, of = isId), 0L)

    height <- stats::median(boxes$y1[isId] - boxes$y0[isId])
    expect_lt(height, 1)
    expect_gt(height, 0.3)
  }
})

test_that("the 375 animals' PNG is 4200 by 2100 pixels at the default dpi and
           has its ids drawn", {
  .skipUnlessBrowser()
  ids <- .saveRhesusPed()$id
  dir <- .saveTmp()
  widget <- .colonyWidget()
  svg <- file.path(dir, "rhesus.svg")
  png <- file.path(dir, "rhesus.png")
  savePedigreeDiagram(widget, svg, width = 14, height = 7)
  savePedigreeDiagram(widget, png, width = 14, height = 7)
  expect_equal(.savePngSize(png), c(width = 4200, height = 2100))

  ## Chrome's photograph of the SVG as written, at the PNG's size, differs
  ## from the PNG in 0 of 271,931 ink pixels; its photograph of the same SVG
  ## with the 545 id texts taken out differs in 347 of 271,930: the ids, 2.8
  ## pixels high each. The 100 is a floor, since Chrome's text edges can move
  ## it; the guard says the ids were all taken out.
  ink <- .savePngIdInk(png, svg, ids)
  expect_identical(ink$removed, 545L)
  expect_identical(ink$withIds$size, ink$pngSize)
  expect_identical(ink$withoutIds$size, ink$pngSize)
  expect_gt(ink$withIds$ink, 100000)
  expect_lt(ink$withIds$differ, 100L)
  expect_gte(ink$withoutIds$differ, 100L)
})
