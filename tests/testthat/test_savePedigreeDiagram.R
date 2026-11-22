## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S69, plan
## Phase G16a, gaps A1 and A2 of docs/research/pedkindraw-gaps-2026-11-18.md;
## rulings R142 and R143, docs/planning/picture-files-plan.md section 11).
## savePedigreeDiagram(diagram, file, width, height) records what the widget
## drawPedigreeDiagram() returns draws, in headless Chrome, and writes it as an
## SVG file: this phase writes ".svg" only (".pdf" and ".png" are G16b's).
##
## Every number a test states was computed first with a scratch recording layer
## (docs/planning/picture-files-prototype/recorder2.js), on macOS, Chrome 157,
## and is quoted beside its bound; they are one machine's (the plan's dragon
## 20), so read each CI job's result before trusting a bound.
##
## The tests that need no browser (the first eight) run everywhere, CRAN too.
## The ones that start Chrome skip on CRAN and where no browser is found; the
## function starts its own Chrome for each call, so these take a second or two
## each.

.saveTmp <- function(envir = parent.frame()) {
  withr::local_tempdir(.local_envir = envir)
}

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

test_that("savePedigreeDiagram() says that .pdf and .png files are not
           available yet (G16b)", {
  widget <- .saveFourWidget()
  dir <- .saveTmp()
  for (name in c("x.pdf", "x.png", "X.PDF", "X.Png")) {
    expect_error(
      savePedigreeDiagram(widget, file.path(dir, name)),
      "is not available yet; use a file name ending in .svg",
      fixed = TRUE
    )
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

## A test of the whole path, in Chrome, is skipped without one.
.skipUnlessBrowser <- function() {
  skip_on_cran()
  skip_if_not_installed("htmlwidgets")
  skip_if_not_installed("withr")
  skip_if_no_chrome()
}

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
