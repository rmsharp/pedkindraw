## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (pedkindraw S69,
## plan Phase G16a, gaps A1 and A2 of
## docs/research/pedkindraw-gaps-2026-11-18.md; rulings R142 and R143). It
## serves test_savePedigreeDiagram.R: the pedigrees the tests draw (the help
## example's four animals, an 18-animal pedigree with all seven marks, the 12
## typed shapes, the 375 rhesus animals), readers of the SVG text the function
## writes, and the photograph-and-compare of the live widget with the file, run
## in headless Chrome as docs/planning/picture-files-plan.md section 11's
## measures ran it.
##
## The comparison (section 11, "Method"): the live widget is photographed over
## the box of its two canvases, its select box, button and labels hidden; the
## SVG is loaded in Chrome and photographed at its own size; "ink" is a pixel
## whose channels sum to under 740 in either picture; one "differs" when a
## colour channel differs by more than 100; the legend is the part right of the
## legend canvas's left edge.

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

## ---- Chrome ----------------------------------------------------------------

## A tall window with the shared parent of the browser tests (a 60 s timeout
## before the first session, one graceful close after the suite), its session
## closed when the caller's test ends.
.saveChromeSession <- function(envir = parent.frame()) {
  chromeParent <- chromote::default_chromote_object()
  if (chromeParent$default_timeout < 60) {
    chromeParent$default_timeout <- 60
  }
  if (!isTRUE(.chromoteParentTeardownRegistered$done)) {
    withr::defer(chromeParent$close(), envir = testthat::teardown_env())
    .chromoteParentTeardownRegistered$done <- TRUE
  }
  session <- chromote::ChromoteSession$new(width = 1200L, height = 1300L)
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
  session$go_to(paste0("file://", file), timeout_ = 30, delay = 0.3)
  drawn <- photograph(list(x = 0, y = 0, width = box$w, height = box$h))
  session$go_to("about:blank", timeout_ = 30)
  compared <- .saveEvaluate(session, paste0(
    "(async () => { ",
    "const load = s => new Promise((ok, no) => { const i = new Image(); ",
    "i.onload = () => ok(i); i.onerror = no; ",
    "i.src = 'data:image/png;base64,' + s; }); ",
    "const pixels = i => { const c = document.createElement('canvas'); ",
    "c.width = i.width; c.height = i.height; const x = c.getContext('2d'); ",
    "x.drawImage(i, 0, 0); return x.getImageData(0, 0, c.width, c.height); }; ",
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
