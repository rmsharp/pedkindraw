## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S77, plan
## Phase G17d, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R152, docs/planning/pedigree-app-plan.md sections 5, 7 and 14).
## Saving from the app: the drawing as an SVG, a PDF or a PNG file through
## savePedigreeDiagram() at its own page (F16), and the animals chosen as a
## CSV file, the rows the Animals tab shows with every column of the file
## (F17). Without the chromote package or Chrome, the picture buttons are
## greyed and the page says what is missing; the CSV button works (R152).
##
## Every value stated below was computed first (plan section 14; Learning 18):
## a download's content runs only when a server test reads output$<id>, which
## gives the file's path (14.1); the app's SVG is identical() to
## savePedigreeDiagram() called directly on the same layout, for the four
## animals and for the sample (545 id texts, 375 distinct; 14.2); a download
## button the server does not define stays greyed in the page (14.2); the CSV
## of the Animals tab's rows opens again in the app to the identical() layout
## (14.4). The server tests run shiny::testServer() with no browser, so they
## run on CRAN; a test that reads a picture download starts Chrome and skips
## on CRAN and where none is found. An assignment inside testServer()'s code
## lands in the server's environment (plan dragon 14), so the tests' own names
## there (saved, savedSvg, kept) are none of the server's.

## The sentences the page says when a picture cannot be saved (R152).
.appNoChromote <- paste0("Saving the drawing as a picture needs the chromote ",
                         "package: install.packages(\"chromote\").")
.appNoChrome <- paste0("Saving the drawing as a picture needs Google Chrome ",
                       "or Chromium on this computer; set CHROMOTE_CHROME to ",
                       "its path if it is not found.")

## A spreadsheet-like file of ten animals (plan section 14.4): its own column
## names, sex as words and letters, a condition written 1/0, a column of
## numbers for a cut-off, the genotyped mark as Avail Y/N, Deceased
## TRUE/FALSE, a date; the sire x9 of m1 has no row of its own.
.appSaveTyped <- function() {
  data.frame(
    ID = c("s1", "d1", "o1", "o2", "m1", "g1", "g2", "f1", "f2", "f3"),
    Father = c(NA, NA, "s1", "s1", "x9", "m1", "m1", NA, NA, "f1"),
    Mother = c(NA, NA, "d1", "d1", NA, "o1", "o1", NA, NA, "f2"),
    Gender = c("male", "female", "female", "male", "male", "female", "male",
               "M", "F", "F"),
    Affected = c(0, 0, 1, 0, 0, 1, 0, 0, 1, 0),
    glucose = c(90, 130, 150, 88, 101, 127, 95, 140, 99, 126),
    Avail = c("Y", "N", "Y", "Y", "N", "Y", "N", "N", "Y", "Y"),
    Deceased = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE,
                 FALSE),
    birth = c("2001-01-01", "2002-02-02", "2005-05-05", "2006-06-06",
              "2004-04-04", "2010-10-10", "2011-11-11", "2000-01-01",
              "2000-02-02", "2008-08-08")
  )
}

## A saved CSV file read as the app reads a file: every column as text,
## empty cells NA.
.appSaveRead <- function(path) {
  utils::read.csv(path, colClasses = "character", na.strings = c("", "NA"),
                  check.names = FALSE)
}

test_that(".appPictureProblem() says nothing when chromote and Chrome are
           found, and names what is missing otherwise (R152)", {
  skip_if_not_installed("mockery")
  skip_if_not_installed("chromote")
  chrome <- withr::local_tempfile(fileext = ".exe")
  writeLines("", chrome)
  found <- .appPictureProblem
  mockery::stub(found, "chromote::find_chrome", chrome)
  expect_identical(found(), "")

  noChromote <- .appPictureProblem
  mockery::stub(noChromote, "requireNamespace", FALSE)
  expect_identical(noChromote(), .appNoChromote)

  notFound <- .appPictureProblem
  mockery::stub(notFound, "chromote::find_chrome", NULL)
  expect_identical(notFound(), .appNoChrome)

  ## chromote::find_chrome() returns CHROMOTE_CHROME as it is, file or not
  ## (plan section 14.3).
  noFile <- .appPictureProblem
  mockery::stub(noFile, "chromote::find_chrome",
                file.path(withr::local_tempdir(), "no-such-chrome"))
  expect_identical(noFile(), .appNoChrome)
})

test_that("the page has a place for the picture buttons above the drawing and
           one for the CSV button above the Animals tab's table (R152)", {
  skip_if_not_installed("shiny")
  html <- as.character(.pedigreeAppUi())
  at <- function(pattern) regexpr(pattern, html, perl = TRUE)[[1L]]
  saves <- at("id=\"saves\"")
  saveRows <- at("id=\"saveRows\"")
  expect_gt(saves, at("class=\"tab-pane[^\"]*\" data-value=\"Diagram\""))
  expect_lt(saves, at("id=\"diagram\""))
  expect_gt(saveRows, at("class=\"tab-pane[^\"]*\" data-value=\"Animals\""))
  expect_lt(saveRows, at("id=\"table\""))
})

test_that("before a pedigree is open the page offers nothing to save (R152)", {
  skip_if_not_installed("shiny")
  .appTestServer(.pedigreeAppServer(pictureProblem = ""), {
    expect_null(output$saves)
    expect_null(output$saveRows)
  })
})

test_that("a drawing brings the SVG, PDF and PNG buttons, and the animals the
           CSV button (R152)", {
  skip_if_not_installed("shiny")
  .appTestServer(.pedigreeAppServer(.appFour(), pictureProblem = ""), {
    .setAppColumns(session)
    expect_identical(output$drawn, "4 animals drawn")
    expect_match(output$saves$html, "Save the drawing:", fixed = TRUE)
    for (id in c("saveSvg", "savePdf", "savePng")) {
      expect_match(output$saves$html, sprintf("id=\"%s\"", id), fixed = TRUE)
    }
    expect_no_match(output$saves$html, "Saving the drawing as a picture",
                    fixed = TRUE)
    expect_match(output$saveRows$html, "id=\"saveCsv\"", fixed = TRUE)
    expect_match(output$saveRows$html, "Save these animals as a CSV file",
                 fixed = TRUE)
  })
})

test_that("without Chrome the picture buttons are shown with the reason and
           no download behind them, and the CSV file is still saved (R152)", {
  skip_if_not_installed("shiny")
  .appTestServer(.pedigreeAppServer(.appFour(), pictureProblem = .appNoChrome),
                 {
    .setAppColumns(session)
    for (id in c("saveSvg", "savePdf", "savePng")) {
      expect_match(output$saves$html, sprintf("id=\"%s\"", id), fixed = TRUE)
    }
    expect_match(output$saves$html, .appNoChrome, fixed = TRUE)
    expect_error(output$saveSvg, "hasn't been defined yet", fixed = TRUE)
    expect_error(output$savePdf, "hasn't been defined yet", fixed = TRUE)
    expect_error(output$savePng, "hasn't been defined yet", fixed = TRUE)
    saved <- output$saveCsv
    expect_identical(.appSaveRead(saved)$id, c("s1", "d1", "o1", "o2"))
  })
})

test_that("the CSV file holds the rows the Animals tab shows, with every
           column of the file, and opens again in the app to the same
           drawing (R152)", {
  skip_if_not_installed("shiny")
  file <- .appCsv(.appSaveTyped())
  kept <- new.env()
  .appTestServer(.pedigreeAppServer(pictureProblem = ""), {
    session$setInputs(file = file)
    .setAppColumns(session, "ID", "Father", "Mother", "Gender")
    session$setInputs(conditions = c("Affected", "glucose"))
    session$setInputs(cutOp6 = ">=", cutValue6 = 126)
    session$setInputs(view = "lineal", focal = "o1")
    saved <- output$saveCsv
    expect_identical(basename(saved), "pedigree.csv")
    rows <- .appSaveRead(saved)
    expect_identical(names(rows),
                     c("id", "sire", "dam", "sex", "Affected", "glucose",
                       "Avail", "Deceased", "birth", "recordStatus"))
    expect_identical(rows$id, c("s1", "d1", "o1", "m1", "g1", "g2"))
    expect_identical(rows$sire[rows$id == "m1"], NA_character_)
    expect_identical(rows$sex, c("M", "F", "F", "M", "F", "M"))
    shownRows <- shown()
    rownames(shownRows) <- NULL
    expect_identical(rows, shownRows)
    kept$lines <- readLines(saved)
    kept$layout <- drawing()$layout
  })
  again <- .appCsv(lines = kept$lines)
  .appTestServer(.pedigreeAppServer(pictureProblem = ""), {
    session$setInputs(file = again)
    .setAppColumns(session)
    session$setInputs(conditions = c("Affected", "glucose"))
    session$setInputs(cutOp6 = ">=", cutValue6 = 126)
    expect_identical(output$added, "")
    expect_identical(drawing()$layout, kept$layout)
  })
})

test_that("while a large view waits for 'Draw anyway' there is no drawing to
           save, and its animals can be saved as a CSV file (R152)", {
  skip_if_not_installed("shiny")
  .appTestServer(.pedigreeAppServer(.appViewsPed(), drawLimit = 12L,
                                    pictureProblem = ""), {
    .setAppColumns(session)
    expect_identical(output$drawn, "")
    expect_null(output$saves)
    expect_match(output$saveRows$html, "id=\"saveCsv\"", fixed = TRUE)
    saved <- output$saveCsv
    expect_identical(.appSaveRead(saved)$id, .appViewsPed()$id)
  })
})

test_that("with Chrome, the SVG file the app saves is the one
           savePedigreeDiagram() writes of the same drawing (R152)", {
  skip_on_cran()
  skip_if_not_installed("shiny")
  skip_if_no_chrome()
  ped <- .appFour()
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  direct <- withr::local_tempfile(fileext = ".svg")
  savePedigreeDiagram(drawPedigreeDiagram(makePedigreeMatingLayout(ped)),
                      direct)
  expectedSvg <- readLines(direct)
  .appTestServer(.pedigreeAppServer(.appFour(), pictureProblem = ""), {
    .setAppColumns(session)
    savedSvg <- output$saveSvg
    expect_identical(basename(savedSvg), "pedigree.svg")
    expect_identical(readLines(savedSvg), expectedSvg)
  })
})

## ---- In Chrome -------------------------------------------------------------

.appSaveSkips <- function() {
  skip_on_cran()
  skip_if_not_installed("shiny")
  skip_if_not_installed("callr")
  skip_if_not_installed("jsonlite")
  skip_if_no_chrome()
}

## Fetch a download as the page asks for it when its button is clicked (plan
## section 14.2): the status, the Content-Disposition header, and the body as
## text, or as raw bytes for a picture.
.appFetch <- function(page, id, binary = FALSE) {
  answer <- .appJs(page, sprintf(paste0(
    "(async function() { const r = await fetch(document.getElementById('%s')",
    ".href); const d = r.headers.get('content-disposition') || ''; ",
    "const b = new Uint8Array(await r.arrayBuffer()); let body = ''; ",
    "if (%s) { let s = ''; for (let i = 0; i < b.length; i += 8192) ",
    "{ s += String.fromCharCode.apply(null, b.subarray(i, i + 8192)); } ",
    "body = btoa(s); } else { body = new TextDecoder().decode(b); } ",
    "return [String(r.status), d, body]; })()"),
    id, if (binary) "true" else "false"))
  body <- answer[[3L]]
  if (binary) body <- jsonlite::base64_dec(body)
  list(status = answer[[1L]], disposition = answer[[2L]], body = body)
}

## Wait until a download button is bound to its download: shiny gives it an
## address then.
.appWaitForDownload <- function(page, id) {
  .appWaitFor(page, sprintf(paste0(
    "!!document.getElementById('%1$s') && ",
    "!!document.getElementById('%1$s').getAttribute('href')"), id))
}

test_that("in Chrome, the sample's drawing is saved from the page as an SVG, a
           PDF and a PNG file, and its animals as a CSV file (R152)", {
  .appSaveSkips()
  ids <- utils::read.csv(.appSamplePath(), colClasses = "character")$id
  app <- .startPedigreeApp()
  page <- .appPage(app$url)
  .appJs(page, "document.getElementById('sample').click(); true")
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'375 animals drawn'"))
  .appWaitForDownload(page, "saveSvg")

  svg <- .appFetch(page, "saveSvg")
  expect_identical(svg$status, "200")
  expect_match(svg$disposition, "filename=\"pedigree.svg\"", fixed = TRUE)
  texts <- .saveTexts(svg$body)
  expect_identical(sum(texts %in% ids), 545L)
  expect_identical(length(unique(texts[texts %in% ids])), 375L)

  pdf <- .appFetch(page, "savePdf", binary = TRUE)
  expect_identical(pdf$status, "200")
  expect_match(pdf$disposition, "filename=\"pedigree.pdf\"", fixed = TRUE)
  expect_identical(rawToChar(pdf$body[1:5]), "%PDF-")

  png <- .appFetch(page, "savePng", binary = TRUE)
  expect_identical(png$status, "200")
  expect_match(png$disposition, "filename=\"pedigree.png\"", fixed = TRUE)
  pngFile <- withr::local_tempfile(fileext = ".png")
  writeBin(png$body, pngFile)
  expect_equal(.savePngSize(pngFile)[["width"]], 3000)

  .appJs(page, "document.querySelector('a[data-value=Animals]').click(); true")
  .appWaitForDownload(page, "saveCsv")
  csv <- .appFetch(page, "saveCsv")
  expect_identical(csv$status, "200")
  expect_match(csv$disposition, "filename=\"pedigree.csv\"", fixed = TRUE)
  rows <- utils::read.csv(text = csv$body, colClasses = "character")
  expect_identical(rows$id, ids)
  expect_identical(names(rows), c("id", "sire", "dam", "sex", "gen", "birth",
                                  "exit", "age"))
})

test_that("in Chrome, an app that cannot find Chrome shows its picture buttons
           greyed with the reason, and saves the CSV file (R152)", {
  .appSaveSkips()
  app <- .startPedigreeApp(
    .appFour(),
    childEnv = c(CHROMOTE_CHROME = file.path(withr::local_tempdir(),
                                             "no-such-chrome"))
  )
  page <- .appPage(app$url)
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'4 animals drawn'"))
  .appWaitFor(page, "!!document.getElementById('savePng')")
  ## The CSV button, rendered after the picture buttons, bound: the page has
  ## bound every download the server defines.
  .appJs(page, "document.querySelector('a[data-value=Animals]').click(); true")
  .appWaitForDownload(page, "saveCsv")
  for (id in c("saveSvg", "savePdf", "savePng")) {
    expect_identical(
      .appJs(page, sprintf(paste0(
        "(function() { const b = document.getElementById('%s'); ",
        "return [b.classList.contains('disabled'), ",
        "b.getAttribute('aria-disabled'), b.getAttribute('href') || ''",
        "].join(); })()"), id)),
      "true,true,", label = id)
  }
  expect_match(.appJs(page, "document.getElementById('saves').innerText"),
               .appNoChrome, fixed = TRUE)
  csv <- .appFetch(page, "saveCsv")
  expect_identical(csv$status, "200")
  rows <- utils::read.csv(text = csv$body, colClasses = "character")
  expect_identical(rows$id, c("s1", "d1", "o1", "o2"))
})
