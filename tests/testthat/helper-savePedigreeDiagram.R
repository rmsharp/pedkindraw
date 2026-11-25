## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (pedkindraw S69,
## plan Phase G16a, gaps A1 and A2 of
## docs/research/pedkindraw-gaps-2026-11-18.md; rulings R142 and R143). It
## serves test_savePedigreeDiagram.R: the pedigrees the tests draw (the help
## example's four animals, an 18-animal pedigree with all seven marks, the 12
## typed shapes, the 375 rhesus animals), readers of the SVG text the function
## writes and (G16b, S71) of a PDF's pages and words and a PNG's size, and the
## photograph-and-compare of the live widget with the file (an SVG or a PNG), run
## in headless Chrome as docs/planning/picture-files-plan.md section 11's
## measures ran it.
##
## The comparison (section 11, "Method"): the live widget is photographed over
## the box of its two canvases, its select box, button and labels hidden; the
## SVG is loaded in Chrome and photographed at its own size; "ink" is a pixel
## whose channels sum to under 740 in either picture; one "differs" when a
## colour channel differs by more than 100; the legend is the part right of the
## legend canvas's left edge.

## A folder for a test's files, removed when the test ends.
.saveTmp <- function(envir = parent.frame()) {
  withr::local_tempdir(.local_envir = envir)
}

## A test of the whole path, in Chrome, is skipped without one (and on CRAN);
## one that reads a PDF's words says so and is skipped too where pdftotext is
## absent or cannot read a PDF.
.skipUnlessBrowser <- function(pdftotext = FALSE) {
  skip_on_cran()
  skip_if_not_installed("htmlwidgets")
  skip_if_not_installed("withr")
  skip_if_not_installed("jsonlite")
  skip_if_no_chrome()
  if (pdftotext) .skipUnlessPdftotext()
}

.saveMuffled <- function(expr) {
  withCallingHandlers(
    expr,
    warning = function(w) invokeRestart("muffleWarning"),
    message = function(m) invokeRestart("muffleMessage")
  )
}

## The help example of drawPedigreeDiagram(): four animals, the sire deceased,
## one daughter affected. The widget is 960 px wide, its picture 960 x 491 px.
.saveFourLayout <- function() {
  ped <- data.frame(
    id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
    dam = c(NA, NA, "B", "B"), sex = c("M", "F", "F", "M"),
    status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
    affected = c(FALSE, FALSE, TRUE, FALSE), stringsAsFactors = FALSE
  )
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  makePedigreeMatingLayout(ped)
}

.saveFourWidget <- function() drawPedigreeDiagram(.saveFourLayout())

## What a test stubs in for .recordDiagramSvg(): a white page of 10 by 5 inches
## holding `inside`, recorded as `w` by `h` pixels (pedkindraw S87, written for
## the stuck page's test and the refused page's).
.saveStubRecording <- function(inside = "", w = 960, h = 480) {
  svg <- paste0(
    '<svg xmlns="http://www.w3.org/2000/svg" width="10in" height="5in" ',
    'viewBox="0 0 960 480"><rect width="100%" height="100%" fill="#ffffff"/>',
    inside, "</svg>"
  )
  list(svg = svg, x = 0, y = 0, w = w, h = h)
}

## A pedigree with every feature the drawing has: both sexes, a hermaphrodite,
## two conditions with an unknown status, deceased, genotyped, carrier,
## proband, consultand, evaluated, infertile, a miscarriage of three kinds, an
## MZ twin pair and a repeat animal. 19 rows, 18 drawn.
.saveFeaturePed <- function() {
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "N",
           "O", "P", "Q", "R", "S"),
    sire = c(NA, NA, "A", "A", "A", NA, "D", "D", "D", "F", "F", "F", NA, "F",
             "D", "D", "D", NA),
    dam = c(NA, NA, "B", "B", "B", NA, "H0", "H0", "H0", "C", "C", "C", NA,
            "N", "H0", "H0", "H0", NA),
    sex = c("M", "F", "F", "M", "F", "M", "F", "M", "F", "M", "F", "M", "F",
            "M", "F", "F", "M", "H"),
    stringsAsFactors = FALSE
  )
  ped$dam[ped$dam == "H0"] <- "M"
  ped <- rbind(ped, data.frame(id = "M", sire = NA, dam = NA, sex = "F"))
  ped$status <- ifelse(ped$id %in% c("A", "J"), "DECEASED", "ALIVE")
  ped$affected <- ped$id %in% c("C", "G", "K")
  ped$affected[ped$id == "L"] <- NA
  ped$affected_b <- ped$id %in% c("B", "C", "H")
  ped$genotyped <- ped$id %in% c("B", "C", "D")
  ped$carrier <- ped$id %in% "J"
  ped$proband <- ped$id %in% "K"
  ped$consultand <- ped$id %in% "L"
  ped$evaluated <- ped$id %in% "I"
  ped$fertility <- ifelse(ped$id == "E", "infertile",
                          ifelse(ped$id == "S", "infertile_choice_na",
                                 "fertile"))
  ped$miscarriage <- ifelse(ped$id == "P", "SAB",
                            ifelse(ped$id == "Q", "TOP",
                                   ifelse(ped$id == "R", "ECT", "no")))
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

.saveFeatureLayout <- function() {
  twins <- data.frame(id1 = "C", id2 = "E", code = "MZ twin")
  .saveMuffled(makePedigreeMatingLayout(.saveFeaturePed(),
                                        twinRelations = twins))
}

## The 375 rhesus animals with their 3 twin pairs (the fixtures are the
## package's inst/extdata files, byte for byte).
.saveRhesusPed <- function() {
  ped <- utils::read.csv(
    test_path("fixtures", "obfuscated_rhesus_mhc_ped.csv"),
    stringsAsFactors = FALSE
  )
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

.saveRhesusLayout <- function() {
  twins <- utils::read.csv(
    test_path("fixtures", "obfuscated_rhesus_mhc_twin_relations.csv"),
    stringsAsFactors = FALSE
  )
  .saveMuffled(makePedigreeMatingLayout(.saveRhesusPed(),
                                        twinRelations = twins))
}

## The 12 typed shapes of helper-matesNoOffspring.R, each as a layout.
.saveShapeLayouts <- function() {
  shapes <- .matesShapes()
  lapply(shapes, function(s) {
    .saveMuffled(makePedigreeMatingLayout(s$ped, matings = s$matings))
  })
}

## ---- reading the file ----------------------------------------------------

.saveSvgText <- function(file) {
  paste(readLines(file, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
}

## The contents of every <text> element, in file order.
.saveTexts <- function(svg) {
  found <- regmatches(svg, gregexpr("<text [^>]*>[^<]*</text>", svg))[[1L]]
  texts <- sub("^<text [^>]*>([^<]*)</text>$", "\\1", found)
  texts <- gsub("&lt;", "<", texts, fixed = TRUE)
  texts <- gsub("&gt;", ">", texts, fixed = TRUE)
  gsub("&amp;", "&", texts, fixed = TRUE)
}

## The font size of the first <text> whose contents are `label`.
.saveFontSize <- function(svg, label) {
  found <- regmatches(svg, gregexpr("<text [^>]*>[^<]*</text>", svg))[[1L]]
  hit <- found[grepl(paste0(">", label, "</text>$"), found, fixed = FALSE)][1L]
  as.numeric(sub('.* font-size="([0-9.]+)".*', "\\1", hit))
}

## The kind of each <image>: "data:image/svg+xml" for a vector picture,
## "data:image/png" for a raster.
.saveImageKinds <- function(svg) {
  pattern <- '<image href="data:image/[a-z+]+'
  found <- regmatches(svg, gregexpr(pattern, svg))[[1L]]
  sub('<image href="', "", found, fixed = TRUE)
}

## The root element's page in inches and its viewBox in pixels.
.saveRoot <- function(svg) {
  root <- regmatches(svg, regexpr("<svg [^>]*>", svg))
  attribute <- function(name) {
    sub(sprintf('.* %s="([^"]*)".*', name), "\\1", root)
  }
  inches <- function(text) as.numeric(sub("in$", "", text))
  list(
    widthIn = inches(attribute("width")),
    heightIn = inches(attribute("height")),
    viewBox = as.numeric(strsplit(attribute("viewBox"), " ")[[1L]])
  )
}

## ---- reading a PDF and a PNG (G16b) ------------------------------------------

## The text of a PDF with its zero bytes dropped, for reading the plain-text
## parts of the file: Chrome writes the page tree and each page's /MediaBox
## uncompressed. Not a PDF reader: it reads files Chrome made.
.savePdfText <- function(file) {
  bytes <- readBin(file, "raw", file.size(file))
  rawToChar(bytes[bytes != as.raw(0L)])
}

## The pages of a PDF: how many, and each one's width and height in points.
.savePdfPages <- function(file) {
  text <- .savePdfText(file)
  found <- regmatches(text, gregexpr("/MediaBox *\\[[^]]*\\]", text,
                                     useBytes = TRUE))[[1L]]
  boxes <- lapply(strsplit(gsub("^/MediaBox *\\[|\\]$", "", found), " +"),
                  as.numeric)
  list(
    pages = length(regmatches(text, gregexpr("/Type */Page[^s]", text,
                                             useBytes = TRUE))[[1L]]),
    size = do.call(rbind, lapply(boxes, function(b) {
      c(width = b[[3L]] - b[[1L]], height = b[[4L]] - b[[2L]])
    })),
    bytes = file.size(file)
  )
}

## Where poppler's pdftotext is not installed, the tests that read a PDF's
## words skip: there is no PDF reader in R's own library (the plan's dragon 9).
## They skip too where it is installed and cannot read a PDF that R itself
## writes: GitHub's Windows runner has Git for Windows' own, which exits with
## status 99 (S71's push, run 45000649737). A tool that reads that PDF and then
## not ours is a fault of ours, and fails the word tests.
.skipUnlessPdftotext <- function() {
  if (!nzchar(Sys.which("pdftotext"))) skip("pdftotext is not installed")
  probe <- withr::local_tempfile(fileext = ".pdf")
  grDevices::pdf(probe)
  plot.new()
  text(0.5, 0.5, "probe")
  grDevices::dev.off()
  if (!is.null(attr(suppressWarnings(.pdftotextXml(probe)), "status"))) {
    skip("pdftotext cannot read a PDF here")
  }
  invisible(NULL)
}

## What pdftotext -bbox prints for a PDF's first page, one string per line;
## when the program exits with an error the "status" attribute holds its code.
.pdftotextXml <- function(file) {
  system2(Sys.which("pdftotext"), c("-bbox", shQuote(file), "-"),
          stdout = TRUE, stderr = FALSE)
}

## The words of a PDF's first page, in the order pdftotext -bbox gives them.
.savePdfWords <- function(file) .savePdfBoxes(file)$text

## A PNG's width and height in pixels, from its header (the signature, then
## the IHDR chunk, whose first eight bytes are the two sizes).
.savePngSize <- function(file) {
  bytes <- readBin(file, "raw", 24L)
  signature <- as.raw(c(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a))
  stopifnot(identical(bytes[1:8], signature))
  number <- function(b) sum(as.integer(b) * 256^(3:0))
  c(width = number(bytes[17:20]), height = number(bytes[21:24]))
}

## ---- Chrome ----------------------------------------------------------------

## The browser of these tests: its own, not the shared one, started with LCD
## text off. The pictures are photographs of the live widget (canvas text, grey)
## and of an SVG document (text that Chrome on Linux draws with coloured
## edges unless told not to), so both must come from a Chrome that draws grey
## text (plan section 13). The shared Chrome cannot be told: a flag set once it
## exists does not reach it, and other test files start it first.
.saveChrome <- new.env(parent = emptyenv())

## A tall window of that browser (a 60 s timeout before the first session, one
## graceful close after the suite), its session closed when the caller's test
## ends.
.saveChromeSession <- function(envir = parent.frame()) {
  if (is.null(.saveChrome$parent)) {
    parent <- chromote::Chromote$new(browser = chromote::Chrome$new(
      args = unique(c(chromote::default_chrome_args(), "--disable-lcd-text"))
    ))
    parent$default_timeout <- 60
    withr::defer(parent$close(), envir = testthat::teardown_env())
    .saveChrome$parent <- parent
  }
  session <- chromote::ChromoteSession$new(parent = .saveChrome$parent,
                                           width = 1200L, height = 1300L)
  withr::defer(session$close(), envir = envir)
  session
}

.saveEvaluate <- function(session, js, awaitPromise = FALSE) {
  result <- session$Runtime$evaluate(js, returnByValue = TRUE,
                                     awaitPromise = awaitPromise)
  if (!is.null(result$exceptionDetails)) {
    stop(result$exceptionDetails$exception$description)
  }
  result$result$value
}

## TRUE when Chrome loads `file` as an SVG document: its root element is
## <svg> and the page holds no parser error.
.saveLoadsAsSvg <- function(file) {
  session <- .saveChromeSession()
  session$go_to(paste0("file://", file), timeout_ = 30, delay = 0.3)
  list(
    root = .saveEvaluate(session, "document.documentElement.nodeName"),
    errors = .saveEvaluate(
      session, "document.getElementsByTagName('parsererror').length"
    )
  )
}

## The in-page JavaScript that turns a photograph (PNG, as base64 text) into
## its pixels: `pixels(await load(text))` is an ImageData. Put it after
## "(async () => { " in a script run with awaitPromise = TRUE.
.savePixelsJs <- paste0(
  "const load = s => new Promise((ok, no) => { const i = new Image(); ",
  "i.onload = () => ok(i); i.onerror = no; ",
  "i.src = 'data:image/png;base64,' + s; }); ",
  "const pixels = i => { const c = document.createElement('canvas'); ",
  "c.width = i.width; c.height = i.height; const x = c.getContext('2d'); ",
  "x.drawImage(i, 0, 0); return x.getImageData(0, 0, c.width, c.height); }; "
)

## The two pictures' difference: for the drawing and the legend, the number of
## ink pixels and of those that differ, and the box photographed.
.saveInkDiff <- function(diagram, file) {
  session <- .saveChromeSession()
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(diagram, html, selfcontained = FALSE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  stopifnot(.waitForLegendPictures(session))
  box <- .saveEvaluate(session, paste0(
    "(() => { ",
    "document.querySelectorAll('button, select, label').forEach(e => { ",
    "e.style.visibility = 'hidden'; }); ",
    "const b = [...document.querySelectorAll('.vis-network canvas')]",
    ".map(c => c.getBoundingClientRect())",
    ".filter(r => r.width > 0 && r.height > 0); ",
    "const x0 = Math.min(...b.map(r => r.left)); ",
    "const y0 = Math.min(...b.map(r => r.top)); ",
    "return {x: x0, y: y0, ",
    "w: Math.max(...b.map(r => r.right)) - x0, ",
    "h: Math.max(...b.map(r => r.bottom)) - y0, ",
    "split: Math.max(...b.map(r => r.left)) - x0}; })()"
  ))
  photograph <- function(clip) {
    session$Page$captureScreenshot(
      format = "png", clip = c(clip, list(scale = 1)),
      captureBeyondViewport = TRUE
    )$data
  }
  live <- photograph(list(x = box$x, y = box$y, width = box$w,
                          height = box$h))
  ## A PNG is shown through a page of its own, at its own size in the page's
  ## corner, so that its pixels are photographed as they are (G16b).
  target <- file
  if (grepl("\\.png$", file, ignore.case = TRUE)) {
    target <- withr::local_tempfile(fileext = ".html")
    writeLines(sprintf(paste0('<html><body style="margin:0"><img src="file://',
                              '%s" style="display:block"></body></html>'),
                       file), target)
  }
  session$go_to(paste0("file://", target), timeout_ = 30, delay = 0.3)
  drawn <- photograph(list(x = 0, y = 0, width = box$w, height = box$h))
  session$go_to("about:blank", timeout_ = 30)
  compared <- .saveEvaluate(session, paste0(
    "(async () => { ", .savePixelsJs,
    "const a = pixels(await load('", live, "')); ",
    "const b = pixels(await load('", drawn, "')); ",
    "const w = Math.min(a.width, b.width), h = Math.min(a.height, b.height); ",
    "const out = {main: [0, 0], legend: [0, 0]}; ",
    "for (let y = 0; y < h; y++) { for (let x = 0; x < w; x++) { ",
    "const i = (y * a.width + x) * 4, j = (y * b.width + x) * 4; ",
    "const sa = a.data[i] + a.data[i + 1] + a.data[i + 2]; ",
    "const sb = b.data[j] + b.data[j + 1] + b.data[j + 2]; ",
    "if (sa < 740 || sb < 740) { ",
    "const part = x < ", round(box$split), " ? out.main : out.legend; ",
    "part[0]++; ",
    "const d = Math.max(Math.abs(a.data[i] - b.data[j]), ",
    "Math.abs(a.data[i + 1] - b.data[j + 1]), ",
    "Math.abs(a.data[i + 2] - b.data[j + 2])); ",
    "if (d > 100) { part[1]++; } } } } ",
    "return {main: out.main, legend: out.legend, ",
    "a: [a.width, a.height], b: [b.width, b.height]}; })()"
  ), awaitPromise = TRUE)
  list(
    main = c(ink = compared$main[[1L]], differ = compared$main[[2L]]),
    legend = c(ink = compared$legend[[1L]], differ = compared$legend[[2L]]),
    liveSize = unlist(compared$a), fileSize = unlist(compared$b)
  )
}

## The pixel comparison (.saveInkDiff() above) photographs the live widget and
## the SVG file with one Chrome and expects their text to match. A Chrome that
## draws the SVG's text with coloured (LCD) edges, as it does on Linux unless
## told not to (and, the log of GitHub's Windows job shows, on Windows), makes
## every letter differ in the colour channels while the widget's canvas text
## stays grey: on GitHub's Ubuntu jobs 13 expectations of that test failed (the
## legend, 1.6% against a bound of 0.5%; pedkindraw S70, plan section 13). So
## the Chrome of these tests must photograph text in grey. Black text on white
## has no colour in its edges when it is grey: the widest spread among a
## pixel's three channels is 0.
.saveTextSpread <- function(session, dir) {
  file <- file.path(dir, "text.svg")
  writeLines(paste0(
    '<svg xmlns="http://www.w3.org/2000/svg" width="320" height="60" ',
    'viewBox="0 0 320 60"><rect width="100%" height="100%" fill="#ffffff"/>',
    '<text x="10" y="38" font-family="arial" font-size="22" fill="#000000">',
    "Hamburgefonstiv 0123</text></svg>"
  ), file)
  session$go_to(paste0("file://", file), timeout_ = 30, delay = 0.3)
  photograph <- session$Page$captureScreenshot(
    format = "png",
    clip = list(x = 0, y = 0, width = 320, height = 60, scale = 1)
  )$data
  session$go_to("about:blank", timeout_ = 30)
  .saveEvaluate(session, paste0(
    "(async () => { ", .savePixelsJs,
    "const d = pixels(await load('", photograph, "')).data; ",
    "let ink = 0, widest = 0; ",
    "for (let k = 0; k < d.length; k += 4) { ",
    "if (d[k] + d[k + 1] + d[k + 2] < 740) { ink++; ",
    "const s = Math.max(d[k], d[k + 1], d[k + 2]) - ",
    "Math.min(d[k], d[k + 1], d[k + 2]); ",
    "if (s > widest) { widest = s; } } } ",
    "return {ink: ink, widest: widest}; })()"
  ), awaitPromise = TRUE)
}

## ---- the ids of a large drawing (G16c, pedkindraw S72) -----------------------
## Readers for test_savePedigreeDiagramColony.R: where each id is written in an
## SVG (its box in Chrome) and in a PDF (its word box from pdftotext -bbox),
## how many boxes lie over another, and how many pixels of a PNG are its ids.
## The measures behind the numbers the tests state are
## docs/planning/picture-files-prototype/g16cMeasure1-3.R.

## One row per id text of an SVG file, drawn by Chrome: the text and its box in
## CSS pixels (x0, y0, x1, y1). The legend's labels have a white halo (a first
## <text> whose fill is "none"); an id has none, but the halo is left out all
## the same.
.saveSvgIdBoxes <- function(file, ids) {
  session <- .saveChromeSession()
  session$go_to(paste0("file://", file), timeout_ = 30, delay = 0.5)
  json <- .saveEvaluate(session, sprintf(paste0(
    "(() => { const ids = new Set(%s); const out = []; ",
    "document.querySelectorAll('text').forEach(t => { ",
    "if (t.getAttribute('fill') !== 'none' && ids.has(t.textContent)) { ",
    "const r = t.getBoundingClientRect(); ",
    "out.push({text: t.textContent, x0: r.left, y0: r.top, ",
    "x1: r.right, y1: r.bottom}); } }); ",
    "return JSON.stringify(out); })()"
  ), jsonlite::toJSON(as.character(ids))))
  session$go_to("about:blank", timeout_ = 30)
  boxes <- jsonlite::fromJSON(json)
  if (!is.data.frame(boxes)) {
    boxes <- data.frame(text = character(), x0 = numeric(), y0 = numeric(),
                        x1 = numeric(), y1 = numeric())
  }
  boxes
}

## One row per word of a PDF's first page, as pdftotext -bbox gives them: the
## word and its box in points (x0, y0, x1, y1).
.savePdfBoxes <- function(file) {
  xml <- .pdftotextXml(file)
  found <- regmatches(xml, regexpr("<word [^>]*>[^<]+</word>", xml))
  number <- function(name) {
    as.numeric(sub(paste0('.*', name, '="([-0-9.]+)".*'), "\\1", found))
  }
  text <- sub("^<word [^>]*>([^<]+)</word>$", "\\1", found)
  text <- gsub("&lt;", "<", text, fixed = TRUE)
  text <- gsub("&gt;", ">", text, fixed = TRUE)
  text <- gsub("&amp;", "&", text, fixed = TRUE)
  data.frame(text = text, x0 = number("xMin"), y0 = number("yMin"),
             x1 = number("xMax"), y1 = number("yMax"),
             stringsAsFactors = FALSE)
}

## How many of the boxes `of` (a logical vector over the rows) lie over another
## box of the set by a positive area; edges that only touch do not count.
.saveOverlapped <- function(boxes, of = rep(TRUE, nrow(boxes))) {
  over <- vapply(which(of), function(i) {
    width <- pmin(boxes$x1[i], boxes$x1[-i]) - pmax(boxes$x0[i], boxes$x0[-i])
    height <- pmin(boxes$y1[i], boxes$y1[-i]) - pmax(boxes$y0[i], boxes$y0[-i])
    any(width > 0 & height > 0)
  }, logical(1L))
  sum(over)
}

## What a PNG holds of its ids: the PNG against two photographs, in Chrome, of
## the SVG file of the same drawing at the PNG's scale (`dpi` / 96): the SVG as
## written (`withIds`) and the SVG with every <text> whose contents is one of
## `ids` taken out (`withoutIds`). Each is a list of `ink`, the pixels not white
## in either picture, and `differ`, those of them whose colour differs by more
## than 100 in a channel. `removed` is how many <text> elements were taken out (a
## guard: one for each id written, 545 for the 375 animals). A PNG that holds
## its ids differs little from the first and by about the ids from the second.
.savePngIdInk <- function(png, svg, ids, dpi = 300) {
  text <- .saveSvgText(svg)
  found <- regmatches(text, gregexpr("<text [^>]*>[^<]*</text>", text))[[1L]]
  contents <- gsub("&amp;", "&", sub("^<text [^>]*>([^<]*)</text>$", "\\1",
                                     found), fixed = TRUE)
  drop <- contents %in% ids
  regmatches(text, gregexpr("<text [^>]*>[^<]*</text>", text)) <-
    list(ifelse(drop, "", found))
  stripped <- withr::local_tempfile(fileext = ".svg")
  writeLines(text, stripped, useBytes = TRUE)
  size <- .savePngSize(png)
  scale <- dpi / 96
  session <- .saveChromeSession()
  photograph <- function(file) {
    session$go_to(paste0("file://", file), timeout_ = 30, delay = 0.5)
    ## The page is wider than this browser's window: beyond the window a
    ## photograph is blank unless it is taken past the viewport (the plan's
    ## dragon 2).
    session$Page$captureScreenshot(
      format = "png", clip = list(x = 0, y = 0, width = size[["width"]] / scale,
                                  height = size[["height"]] / scale,
                                  scale = scale),
      captureBeyondViewport = TRUE
    )$data
  }
  whole <- photograph(svg)
  without <- photograph(stripped)
  session$go_to("about:blank", timeout_ = 30)
  bytes <- readBin(png, "raw", file.size(png))
  file <- gsub("[\r\n ]", "", jsonlite::base64_enc(bytes))
  compared <- .saveEvaluate(session, paste0(
    "(async () => { ", .savePixelsJs,
    "const a = pixels(await load('", file, "')); ",
    "const compare = async s => { const b = pixels(await load(s)); ",
    "let ink = 0, differ = 0; ",
    "for (let k = 0; k < a.data.length; k += 4) { ",
    "const sa = a.data[k] + a.data[k + 1] + a.data[k + 2]; ",
    "const sb = b.data[k] + b.data[k + 1] + b.data[k + 2]; ",
    "if (sa < 740 || sb < 740) { ink++; ",
    "if (Math.abs(a.data[k] - b.data[k]) > 100 || ",
    "Math.abs(a.data[k + 1] - b.data[k + 1]) > 100 || ",
    "Math.abs(a.data[k + 2] - b.data[k + 2]) > 100) { differ++; } } } ",
    "return {ink: ink, differ: differ, size: [b.width, b.height]}; }; ",
    "return {png: [a.width, a.height], withIds: await compare('", whole, "'), ",
    "withoutIds: await compare('", without, "')}; })()"
  ), awaitPromise = TRUE)
  list(removed = sum(drop), pngSize = unlist(compared$png),
       withIds = list(ink = compared$withIds$ink,
                      differ = compared$withIds$differ,
                      size = unlist(compared$withIds$size)),
       withoutIds = list(ink = compared$withoutIds$ink,
                         differ = compared$withoutIds$differ,
                         size = unlist(compared$withoutIds$size)))
}

## Whether the result of .savePngIdInk() says the PNG holds its ids: some id was
## taken out of the picture it is compared with, and the PNG differs from the
## drawing without its ids in more pixels than from the drawing as written. The
## counts themselves are one machine's: the drawing without the ids differs
## from the PNG in 347 pixels on the Mac, 573 in the Linux box and 27 on
## GitHub's Windows (run 45038005488, S72), where Chrome draws the 2.8 pixel ids
## lighter, so a floor of 100 failed there. The order does not move.
.pngHoldsIds <- function(ink) {
  ink$removed > 0L && ink$withoutIds$differ > 0L &&
    ink$withoutIds$differ > ink$withIds$differ
}
