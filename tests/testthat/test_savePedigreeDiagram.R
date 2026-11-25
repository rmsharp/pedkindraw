## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S69, plan
## Phase G16a, gaps A1 and A2 of docs/research/pedkindraw-gaps-2026-11-18.md;
## rulings R142 and R143, docs/planning/picture-files-plan.md section 11).
## savePedigreeDiagram(diagram, file, width, height, dpi) records what the
## widget drawPedigreeDiagram() returns draws, in headless Chrome, and writes it
## as an SVG, a PDF or a PNG file by the file's ending. G16a (S69, R143) wrote
## the ".svg"; G16b (pedkindraw S71, R144, docs/planning/picture-files-plan.md
## section 12) adds ".pdf" and ".png" and the argument "dpi" (the PNG's pixels
## per inch of the page).
##
## Every number a test states was computed first with a scratch reference
## (the prototypes of docs/planning/picture-files-prototype/ run from a scratch
## copy of the package, S71), on macOS, Chrome 157, and is quoted beside its
## bound; they are one machine's (the plan's dragon 20), so read each CI job's
## result before trusting a bound. A PDF's page size and page count are read
## from the file's own bytes, with no PDF reader; its words need poppler's
## pdftotext, and the tests that read them skip where it is not installed.
##
## The tests that need no browser (the first eight) run everywhere, CRAN too.
## The ones that start Chrome skip on CRAN and where no browser is found; the
## function starts its own Chrome for each call, so these take a second or two
## each.

test_that("savePedigreeDiagram() stops unless 'diagram' is the widget
           drawPedigreeDiagram() returns", {
  file <- file.path(.saveTmp(), "x.svg")
  for (bad in list(NULL, list(), data.frame(a = 1), .saveFourLayout(),
                   "diagram", 1L)) {
    expect_error(
      savePedigreeDiagram(bad, file),
      "requires 'diagram' to be the widget drawPedigreeDiagram() returns",
      fixed = TRUE
    )
  }
  expect_false(file.exists(file))
})

test_that("savePedigreeDiagram() stops unless 'file' is one file name", {
  widget <- .saveFourWidget()
  for (bad in list(NULL, NA_character_, c("a.svg", "b.svg"), 1L,
                   character(0L))) {
    expect_error(
      savePedigreeDiagram(widget, bad),
      "requires 'file' to be one file name, as a character string",
      fixed = TRUE
    )
  }
})

test_that("savePedigreeDiagram() stops unless the file name ends in .svg,
           .pdf or .png", {
  widget <- .saveFourWidget()
  dir <- .saveTmp()
  for (name in c("x", "x.txt", "x.jpg", "x.svg.bak")) {
    expect_error(
      savePedigreeDiagram(widget, file.path(dir, name)),
      "requires 'file' to end in .svg, .pdf or .png",
      fixed = TRUE
    )
  }
  expect_length(list.files(dir), 0L)
})

test_that("savePedigreeDiagram() stops unless 'dpi' is one positive number of
           pixels per inch, whatever the kind of file", {
  widget <- .saveFourWidget()
  dir <- .saveTmp()
  for (name in c("x.svg", "x.pdf", "x.png")) {
    for (bad in list(0, -1, NA_real_, Inf, "300", c(96, 300), TRUE, NULL)) {
      expect_error(
        savePedigreeDiagram(widget, file.path(dir, name), dpi = bad),
        "requires 'dpi' to be one positive number of pixels per inch",
        fixed = TRUE
      )
    }
  }
  expect_length(list.files(dir), 0L)
})

test_that("savePedigreeDiagram() stops unless 'width' and 'height' are each
           NULL or one positive number of inches", {
  widget <- .saveFourWidget()
  file <- file.path(.saveTmp(), "x.svg")
  for (argument in c("width", "height")) {
    for (bad in list(0, -1, NA_real_, Inf, "7", c(1, 2), TRUE)) {
      args <- stats::setNames(list(bad), argument)
      expect_error(
        do.call(savePedigreeDiagram, c(list(widget, file), args)),
        sprintf("requires '%s' to be NULL or one positive number of inches",
                argument),
        fixed = TRUE
      )
    }
  }
})

test_that("savePedigreeDiagram() stops when the folder of 'file' does not
           exist", {
  widget <- .saveFourWidget()
  file <- file.path(.saveTmp(), "missing", "folder", "x.svg")
  expect_error(savePedigreeDiagram(widget, file),
               "the folder of 'file' does not exist", fixed = TRUE)
})

test_that("savePedigreeDiagram() stops, naming chromote, when chromote is not
           installed", {
  skip_if_not_installed("mockery")
  widget <- .saveFourWidget()
  file <- file.path(.saveTmp(), "x.svg")
  mockery::stub(savePedigreeDiagram, "requireNamespace", FALSE)
  expect_error(savePedigreeDiagram(widget, file),
               "needs the 'chromote' package", fixed = TRUE)
  expect_false(file.exists(file))
})

test_that("savePedigreeDiagram() stops when Chrome is not found", {
  skip_if_not_installed("mockery")
  skip_if_not_installed("chromote")
  widget <- .saveFourWidget()
  file <- file.path(.saveTmp(), "x.svg")
  mockery::stub(savePedigreeDiagram, "chromote::find_chrome", NULL)
  expect_error(savePedigreeDiagram(widget, file),
               "could not find Google Chrome", fixed = TRUE)
  expect_false(file.exists(file))
})

test_that("the four animals are written as an SVG document Chrome loads, 10
           inches wide, and the path comes back invisibly", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  file <- file.path(.saveTmp(), "four.svg")

  result <- withVisible(savePedigreeDiagram(widget, file))
  expect_false(result$visible)
  expect_identical(result$value, file)
  expect_true(file.exists(file))

  loaded <- .saveLoadsAsSvg(file)
  expect_identical(loaded$root, "svg")
  expect_identical(loaded$errors, 0L)

  ## The widget is 960 px wide: 10 in. Its picture was 960 x 491 px here
  ## (5.1146 in); the height is checked for agreeing with the viewBox and for
  ## being a four-animal drawing's, not for the machine's 491.
  root <- .saveRoot(.saveSvgText(file))
  expect_equal(root$widthIn, 10, tolerance = 1e-3)
  expect_equal(root$viewBox[1:2], c(0, 0))
  expect_equal(root$viewBox[[3L]], root$widthIn * 96, tolerance = 1e-3)
  expect_equal(root$viewBox[[4L]], root$heightIn * 96, tolerance = 1e-3)
  expect_gt(root$viewBox[[4L]], 300)
  expect_lt(root$viewBox[[4L]], 500)
})

test_that("a file name in capitals is taken", {
  .skipUnlessBrowser()
  file <- file.path(.saveTmp(), "FOUR.SVG")
  savePedigreeDiagram(.saveFourWidget(), file)
  expect_true(file.exists(file))
  expect_identical(.saveLoadsAsSvg(file)$root, "svg")
})

test_that("each file's picture is the live widget's: the four animals, the 12
           typed shapes and the feature pedigree", {
  .skipUnlessBrowser()
  layouts <- c(list(four = .saveFourLayout(), feature = .saveFeatureLayout()),
               .saveShapeLayouts())
  dir <- .saveTmp()
  compared <- 0L
  for (name in names(layouts)) {
    widget <- drawPedigreeDiagram(layouts[[name]])
    file <- file.path(dir, paste0(name, ".svg"))
    savePedigreeDiagram(widget, file)
    difference <- .saveInkDiff(widget, file)
    ## Measured, ink differing by more than 100 in a colour channel: 0.0% in
    ## the drawing and the legend for the four animals and each of the 12
    ## shapes (bound 0.5%); the feature pedigree 0.4% in the drawing (49 of
    ## 13,198 ink pixels) and 0.2% in the legend (13 of 7,371) (bound 1.0%).
    limit <- if (identical(name, "feature")) 1.0 else 0.5
    for (part in c("main", "legend")) {
      ink <- difference[[part]][["ink"]]
      expect_gt(ink, 0, label = paste(name, part, "ink pixels"))
      expect_lte(100 * difference[[part]][["differ"]] / ink, limit,
                 label = paste(name, part, "ink differing, percent"))
    }
    compared <- compared + 1L
  }
  expect_identical(compared, 14L)
})

test_that("the legend's pictures are vector pictures, and its title and
           labels text", {
  .skipUnlessBrowser()
  dir <- .saveTmp()
  feature <- file.path(dir, "feature.svg")
  savePedigreeDiagram(drawPedigreeDiagram(.saveFeatureLayout()), feature)
  svg <- .saveSvgText(feature)

  ## 11 pictures in the feature pedigree's legend (one in the four animals'),
  ## each the picture vis.js cuts its icon from, not a raster of it.
  kinds <- .saveImageKinds(svg)
  expect_length(kinds, 11L)
  expect_true(all(kinds == "data:image/svg+xml"))
  expect_false(grepl("data:image/png", svg, fixed = TRUE))

  texts <- .saveTexts(svg)
  expect_true(all(c("Sex", "Female", "Male", "Hermaphrodite", "Unknown",
                    "Other / Unrecorded", "Deceased", "Miscarriage",
                    "Termination", "Ectopic", "MZ", "DZ", "?") %in% texts))
  ## The 18 animals the drawing shows (S, with no mate or offspring, is left
  ## out) each have their id in the file.
  expect_true(all(setdiff(.saveFeaturePed()$id, "S") %in% texts))

  four <- file.path(dir, "four.svg")
  savePedigreeDiagram(.saveFourWidget(), four)
  expect_length(.saveImageKinds(.saveSvgText(four)), 1L)
  expect_true(all(c("A", "B", "C", "D", "Sex") %in%
                    .saveTexts(.saveSvgText(four))))
})

test_that("every id of the 375 animals is a text in the file, and none is
           written by the widget left as it is", {
  .skipUnlessBrowser()
  widget <- drawPedigreeDiagram(.saveRhesusLayout())
  ids <- .saveRhesusPed()$id
  file <- file.path(.saveTmp(), "rhesus.svg")
  savePedigreeDiagram(widget, file)

  ## Measured: 545 id texts, 375 distinct (the 375 animals and 170 repeat
  ## appearances), and 16 texts besides, the legend's.
  texts <- .saveTexts(.saveSvgText(file))
  expect_identical(sum(texts %in% ids), 545L)
  expect_identical(length(unique(texts[texts %in% ids])), 375L)

  ## vis.js draws a label only when it would be 4 px tall: at this size, none.
  recorded <- .recordDiagramSvg(widget)
  expect_type(recorded$svg, "character")
  expect_identical(sum(.saveTexts(recorded$svg) %in% ids), 0L)
  expect_length(.saveTexts(recorded$svg), 16L)
})

test_that("the page is given in inches, the drawing scaled to fit it", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  dir <- .saveTmp()

  ## 7 x 7 in is a widget of 672 x 672 px: a viewBox 672 px wide (measured).
  square <- file.path(dir, "square.svg")
  savePedigreeDiagram(widget, square, width = 7, height = 7)
  root <- .saveRoot(.saveSvgText(square))
  expect_equal(root$widthIn, 7, tolerance = 1e-3)
  expect_equal(root$heightIn, 7, tolerance = 1e-3)
  expect_equal(root$viewBox[[3L]], 672, tolerance = 1e-3)
  expect_identical(.saveLoadsAsSvg(square)$errors, 0L)

  ## Left out, a side is the drawing's own: 5 in is 480 px.
  narrow <- file.path(dir, "narrow.svg")
  savePedigreeDiagram(widget, narrow, width = 5)
  root <- .saveRoot(.saveSvgText(narrow))
  expect_equal(root$widthIn, 5, tolerance = 1e-3)
  expect_equal(root$viewBox[[3L]], 480, tolerance = 1e-3)
  expect_equal(root$heightIn * 96, root$viewBox[[4L]], tolerance = 1e-3)
})

test_that("a device scale factor of 2 gives the same drawing", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  once <- .recordDiagramSvg(widget, scaleFactor = 1)
  twice <- .recordDiagramSvg(widget, scaleFactor = 2)

  ## At 2 the canvases hold twice the pixels in the same box: measured, an
  ## unscaled recording drew everything twice as large (a font of 18.881
  ## against 9.441) inside the same box.
  expect_equal(twice$w, once$w, tolerance = 1e-3)
  expect_equal(twice$h, once$h, tolerance = 1e-3)
  file <- file.path(.saveTmp(), "twice.svg")
  writeLines(twice$svg, file, useBytes = TRUE)
  difference <- .saveInkDiff(widget, file)
  ## Measured, ink differing from the live widget's (at 1): the drawing 0.00%
  ## of 4,182 ink pixels for the four animals (0.54% for the feature
  ## pedigree), bound 1.0%. The legend is not compared: at 2 its labels round
  ## to a half CSS pixel, the canvas's own pixel there, and the file differs
  ## 9.8% from the picture at 1 (measured, cause: that rounding).
  expect_gt(difference$main[["ink"]], 0)
  expect_lte(100 * difference$main[["differ"]] / difference$main[["ink"]], 1.0)
})

test_that("the widget is as it was afterwards, and no folder of the
           function's is left", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  before <- widget
  savePedigreeDiagram(widget, file.path(.saveTmp(), "x.svg"),
                      width = 6, height = 4)
  expect_identical(widget, before)
  expect_length(list.files(tempdir(), pattern = "^pedkindraw-save-"), 0L)
})

test_that("a time limit stops with a message and leaves nothing behind", {
  .skipUnlessBrowser()
  withr::local_options(pedkindraw.saveTimeout = 0.01)
  file <- file.path(.saveTmp(), "x.svg")
  expect_error(savePedigreeDiagram(.saveFourWidget(), file),
               "did not finish drawing within", fixed = TRUE)
  expect_false(file.exists(file))
  expect_length(list.files(tempdir(), pattern = "^pedkindraw-save-"), 0L)
})

test_that("a page that never returns from its JavaScript stops within the
           limit", {
  .skipUnlessBrowser()
  ## Measured: chromote reports a command that gets no answer after the
  ## timeout it was given (3.01 s for 3), the session closes at once and so
  ## does the browser (0.13 s). The loop starts 50 ms after the widget is
  ## drawn, before the 300 ms of quiet the function waits for can pass: a
  ## later start (500 ms) races the first draw's end.
  stuck <- htmlwidgets::onRender(
    .saveFourWidget(),
    "function(el, x) { setTimeout(function() { for (;;) {} }, 50); }"
  )
  withr::local_options(pedkindraw.saveTimeout = 3)
  file <- file.path(.saveTmp(), "x.svg")
  elapsed <- system.time(
    expect_error(savePedigreeDiagram(stuck, file),
                 "did not finish drawing within", fixed = TRUE)
  )[["elapsed"]]
  expect_lt(elapsed, 20)
  expect_false(file.exists(file))
  expect_length(list.files(tempdir(), pattern = "^pedkindraw-save-"), 0L)
})

## ---- G16b: the PDF and the PNG ----------------------------------------------

test_that("the four animals are written as a one-page PDF of the page asked
           for, and the path comes back invisibly", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  dir <- .saveTmp()

  file <- file.path(dir, "four.pdf")
  result <- withVisible(savePedigreeDiagram(widget, file, width = 7, height = 5))
  expect_false(result$visible)
  expect_identical(result$value, file)
  expect_identical(rawToChar(readBin(file, "raw", 5L)), "%PDF-")

  ## Measured: one page of 504 x 360 pt for 7 x 5 in and 432 x 288 pt for 6 x 4
  ## in. Bound 1 pt: Chrome rounds a paper size (the plan's dragon 25: a page
  ## asked at 6.8 in came out 0.48 pt over).
  for (page in list(c(7, 5), c(6, 4))) {
    pdf <- file.path(dir, sprintf("page%dx%d.pdf", page[[1L]], page[[2L]]))
    savePedigreeDiagram(widget, pdf, width = page[[1L]], height = page[[2L]])
    pages <- .savePdfPages(pdf)
    expect_identical(pages$pages, 1L)
    expect_lte(max(abs(pages$size[1L, ] - page * 72)), 1)
  }

  ## Left out, the page is the picture's own size, as the SVG's: measured
  ## 720 x 369.12 pt against the SVG's 10 x 5.1146 in (368.25 pt: Chrome's
  ## rounding put 0.87 pt on the height; 0.21 pt for the 18-animal pedigree).
  ## Bound 1.5 pt.
  svg <- file.path(dir, "default.svg")
  savePedigreeDiagram(widget, svg)
  root <- .saveRoot(.saveSvgText(svg))
  default <- file.path(dir, "default.pdf")
  savePedigreeDiagram(widget, default)
  pages <- .savePdfPages(default)
  expect_identical(pages$pages, 1L)
  expect_lte(max(abs(pages$size[1L, ] - c(root$widthIn, root$heightIn) * 72)),
             1.5)
})

test_that("the PDF holds the animals' ids and the legend's words as text", {
  .skipUnlessBrowser()
  .skipUnlessPdftotext()
  file <- file.path(.saveTmp(), "four.pdf")
  savePedigreeDiagram(.saveFourWidget(), file, width = 7, height = 5)

  ## Measured: 26 words, each of A, B, C and D once, and the legend's (Sex,
  ## Female, Male, Hermaphrodite, Unknown, Other, /, Unrecorded, Affected,
  ## Deceased, Same animal again, MZ, DZ, ?). A print right after the page
  ## loads once came out without the animals' shapes and ids and 21 words in
  ## 489 KB (the plan's dragon 24), so a size cannot say a PDF is whole.
  words <- .savePdfWords(file)
  expect_true(all(c("A", "B", "C", "D", "Sex", "Female", "Male", "Affected",
                    "Deceased") %in% words))
  expect_identical(sum(words %in% c("A", "B", "C", "D")), 4L)
})

test_that("a PNG is the page times the dpi in pixels, 300 dpi unless told", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  dir <- .saveTmp()

  ## Measured, 7 x 5 in: 672 x 480 at 96 dpi, 1050 x 750 at 150, 2100 x 1500 at
  ## the default 300 (15,130, 26,410 and 60,761 bytes).
  sizes <- list(`96` = c(672, 480), `150` = c(1050, 750))
  for (dpi in names(sizes)) {
    file <- file.path(dir, paste0("dpi", dpi, ".png"))
    savePedigreeDiagram(widget, file, width = 7, height = 5, dpi = as.numeric(dpi))
    expect_equal(unname(.savePngSize(file)), sizes[[dpi]])
  }
  file <- file.path(dir, "dpi300.png")
  savePedigreeDiagram(widget, file, width = 7, height = 5)
  expect_equal(unname(.savePngSize(file)), c(2100, 1500))

  ## Left out, the page is the picture's own size: measured 3000 x 1534 pixels
  ## for an SVG of 960 x 491 px (1534.375 at 300 dpi). Bound 1 pixel.
  svg <- file.path(dir, "default.svg")
  savePedigreeDiagram(widget, svg)
  root <- .saveRoot(.saveSvgText(svg))
  default <- file.path(dir, "default.png")
  savePedigreeDiagram(widget, default)
  expect_lte(max(abs(.savePngSize(default) - root$viewBox[3:4] * 300 / 96)), 1)
})

test_that("a PNG at 96 dpi is the live widget's picture: the four animals and
           the feature pedigree", {
  .skipUnlessBrowser()
  layouts <- list(four = .saveFourLayout(), feature = .saveFeatureLayout())
  dir <- .saveTmp()
  compared <- 0L
  for (name in names(layouts)) {
    widget <- drawPedigreeDiagram(layouts[[name]])
    file <- file.path(dir, paste0(name, ".png"))
    savePedigreeDiagram(widget, file, dpi = 96)
    difference <- .saveInkDiff(widget, file)
    ## Measured, ink differing by more than 100 in a colour channel, as the
    ## SVG's: 0 of 4,184 ink pixels (0.00%) in the drawing and 1 of 3,926
    ## (0.03%) in the legend for the four animals (bound 0.5%); 0.26% (33 of
    ## 12,507) and 0.07% (5 of 7,261) for the feature pedigree (bound 1.0%).
    ## On Linux and Windows a Chrome that draws the text with coloured edges
    ## fails this (the plan's dragon 27): the function's own Chrome must not.
    limit <- if (identical(name, "feature")) 1.0 else 0.5
    for (part in c("main", "legend")) {
      ink <- difference[[part]][["ink"]]
      expect_gt(ink, 0, label = paste(name, part, "ink pixels"))
      expect_lte(100 * difference[[part]][["differ"]] / ink, limit,
                 label = paste(name, part, "ink differing, percent"))
    }
    compared <- compared + 1L
  }
  expect_identical(compared, 2L)
})

test_that("the 375 animals on a 14 x 7 in page: a one-page PDF of about a
           megabyte, a PNG of 4200 x 2100 pixels, and an SVG that keeps its
           dashed lines", {
  .skipUnlessBrowser()
  widget <- drawPedigreeDiagram(.saveRhesusLayout())
  dir <- .saveTmp()

  ## Measured 1,025,349 bytes, one page of 1008 x 504 pt. Chrome writes every
  ## dash of the 170 dashed repeat-animal edges as an outline, 5.77 MB, unless
  ## each dash is written as a short stroke (the plan's section 12.2); the
  ## bound is 1.5 MB.
  pdf <- file.path(dir, "rhesus.pdf")
  savePedigreeDiagram(widget, pdf, width = 14, height = 7)
  pages <- .savePdfPages(pdf)
  expect_identical(pages$pages, 1L)
  expect_lte(max(abs(pages$size[1L, ] - c(14, 7) * 72)), 1)
  expect_lt(pages$bytes, 1.5e6)

  png <- file.path(dir, "rhesus.png")
  savePedigreeDiagram(widget, png, width = 14, height = 7)
  expect_equal(unname(.savePngSize(png)), c(4200, 2100))

  ## The SVG is as G16a wrote it: its dashes stay dashes. Measured 179
  ## stroke-dasharray attributes (170 repeat-animal edges and the legend's).
  svg <- file.path(dir, "rhesus.svg")
  savePedigreeDiagram(widget, svg, width = 14, height = 7)
  dashes <- regmatches(.saveSvgText(svg),
                       gregexpr("stroke-dasharray", .saveSvgText(svg),
                                fixed = TRUE))[[1L]]
  expect_gte(length(dashes), 170L)
})

test_that("the 375 animals' PDF has every id as a word", {
  .skipUnlessBrowser()
  .skipUnlessPdftotext()
  widget <- drawPedigreeDiagram(.saveRhesusLayout())
  ids <- .saveRhesusPed()$id
  pdf <- file.path(.saveTmp(), "rhesus.pdf")
  savePedigreeDiagram(widget, pdf, width = 14, height = 7)

  ## Measured: 567 words, 545 of them ids and 375 distinct (the 375 animals and
  ## 170 repeat appearances), as the SVG's texts.
  words <- .savePdfWords(pdf)
  expect_identical(sum(words %in% ids), 545L)
  expect_identical(length(unique(words[words %in% ids])), 375L)
})

test_that("the word tests skip where pdftotext cannot read a PDF", {
  ## GitHub's Windows runner has a pdftotext (Git for Windows' own) that exits
  ## with status 99 on a PDF: the two word tests failed there with no words
  ## (S71's push, run 45000649737), as they would with this stand-in first on
  ## the path. A tool that cannot read a PDF R itself writes is skipped; one
  ## that reads it and then cannot read ours would still fail the word tests.
  skip_on_os("windows")
  bin <- .saveTmp()
  fake <- file.path(bin, "pdftotext")
  writeLines(c("#!/bin/sh", "exit 99"), fake)
  Sys.chmod(fake, "0755")
  withr::local_path(bin, action = "prefix")
  expect_condition(.skipUnlessPdftotext(), class = "skip")
})

test_that("dpi changes the PNG only: the SVG and the PDF are as they were", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  dir <- .saveTmp()
  svgs <- file.path(dir, c("one.svg", "two.svg"))
  savePedigreeDiagram(widget, svgs[[1L]])
  savePedigreeDiagram(widget, svgs[[2L]], dpi = 50)
  expect_identical(readLines(svgs[[1L]], warn = FALSE),
                   readLines(svgs[[2L]], warn = FALSE))

  ## Measured: two PDFs of 86,943 bytes each, the same page size and words.
  pdfs <- file.path(dir, c("one.pdf", "two.pdf"))
  savePedigreeDiagram(widget, pdfs[[1L]])
  savePedigreeDiagram(widget, pdfs[[2L]], dpi = 50)
  one <- .savePdfPages(pdfs[[1L]])
  two <- .savePdfPages(pdfs[[2L]])
  expect_identical(one$size, two$size)
  expect_equal(one$bytes, two$bytes, tolerance = 0.01)
})

test_that("a PDF or PNG file name in capitals is taken", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  dir <- .saveTmp()
  pdf <- file.path(dir, "FOUR.PDF")
  png <- file.path(dir, "FOUR.PNG")
  savePedigreeDiagram(widget, pdf)
  savePedigreeDiagram(widget, png)
  expect_identical(.savePdfPages(pdf)$pages, 1L)
  expect_gt(.savePngSize(png)[["width"]], 0)
})

test_that("the widget is as it was after a PDF or a PNG, and no folder of the
           function's is left", {
  .skipUnlessBrowser()
  widget <- .saveFourWidget()
  before <- widget
  for (name in c("x.pdf", "x.png")) {
    savePedigreeDiagram(widget, file.path(.saveTmp(), name),
                        width = 6, height = 4)
    expect_identical(widget, before)
  }
  expect_length(list.files(tempdir(), pattern = "^pedkindraw-save-"), 0L)
})

test_that("a time limit stops a PDF or a PNG with the same message and leaves
           nothing behind", {
  .skipUnlessBrowser()
  withr::local_options(pedkindraw.saveTimeout = 0.01)
  dir <- .saveTmp()
  for (name in c("x.pdf", "x.png")) {
    file <- file.path(dir, name)
    expect_error(savePedigreeDiagram(.saveFourWidget(), file),
                 "did not finish drawing within", fixed = TRUE)
    expect_false(file.exists(file))
  }
  expect_length(list.files(tempdir(), pattern = "^pedkindraw-save-"), 0L)
})

test_that("a page that never returns while it is printed or photographed
           stops within the limit", {
  .skipUnlessBrowser()
  skip_if_not_installed("mockery")
  ## The recording is stubbed to an SVG whose script never returns, so it is
  ## the printing and the photographing that wait. Measured: both stop after
  ## 3.1 s for a limit of 3, with the message, no file and no folder.
  mockery::stub(savePedigreeDiagram, ".recordDiagramSvg",
                .saveStubRecording("<script>for (;;) {}</script>"))
  withr::local_options(pedkindraw.saveTimeout = 3)
  widget <- .saveFourWidget()
  dir <- .saveTmp()
  for (name in c("x.pdf", "x.png")) {
    file <- file.path(dir, name)
    elapsed <- system.time(
      expect_error(savePedigreeDiagram(widget, file),
                   "did not finish drawing within", fixed = TRUE)
    )[["elapsed"]]
    expect_lt(elapsed, 20)
    expect_false(file.exists(file))
  }
  expect_length(list.files(tempdir(), pattern = "^pedkindraw-save-"), 0L)
})

## The pixel comparison above photographs the live widget and the SVG file
## with one Chrome and expects their text to match; this test is that Chrome's
## own: it must photograph text in grey (.saveTextSpread(), the helper's).
test_that("the browser that photographs the pictures draws text in grey, not
           with coloured edges", {
  .skipUnlessBrowser()
  ## Measured, a line of black 22 px text on white, 320 x 60 px: 1,785 ink
  ## pixels on macOS and 1,504 on Linux with LCD text off, all grey (widest
  ## spread 0); on Linux with LCD text on, 1,804 and a widest spread of 160
  ## (Ubuntu 26.04, Google Chrome 158). The bound separates the two.
  spread <- .saveTextSpread(.saveChromeSession(), .saveTmp())
  expect_gt(spread[["ink"]], 500)
  expect_lte(spread[["widest"]], 20)
})

test_that("a PDF or a PNG that headless Chrome refuses stops with Chrome's
           error, not the time limit's, and leaves nothing behind", {
  .skipUnlessBrowser()
  skip_if_not_installed("mockery")
  ## pedkindraw S87 (Phase 17j, R161): the recording is stubbed to a page of no
  ## size, which Chrome refuses to print or photograph at once, with time left;
  ## the function passes Chrome's own error on (R/savePedigreeDiagram.R, the
  ## last stop of .renderPicture()). Measured: "paper width is zero or negative"
  ## and "Cannot take screenshot with 0 width." (Chrome 157 on macOS), each in
  ## chromote's form for an error Chrome answers, "code: <n>\n  message: <text>"
  ## (chromote 0.5.1, Chromote$send_command()); the test reads that form, not
  ## Chrome's words, which change between versions. Without the stop, the
  ## function still stops, later, with jsonlite's "is.raw(input) is not TRUE".
  mockery::stub(savePedigreeDiagram, ".recordDiagramSvg",
                .saveStubRecording(w = 0, h = 0))
  widget <- .saveFourWidget()
  dir <- .saveTmp()
  for (name in c("x.pdf", "x.png")) {
    file <- file.path(dir, name)
    expect_error(savePedigreeDiagram(widget, file),
                 "^code: -32[0-9]+\n  message: ")
    expect_false(file.exists(file))
  }
  expect_length(list.files(tempdir(), pattern = "^pedkindraw-save-"), 0L)
})
