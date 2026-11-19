## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S44, plan
## Phase G3, gap B6 of docs/research/pedkindraw-gaps-2026-11-18.md). The name
## column is written under each animal's id, cut after 15 characters with
## "..." (nprcgenekeepr issue #136, D10); kinship2 and Pedixplorer write any
## label text whole. Mark's picks (S44): an argument maxNameChars, default 15,
## in makePedigreeDiagramData() and makePedigreeMatingLayout(); Inf writes
## every name whole; the limit counts the whole name, line breaks included, as
## before. Anything but one whole number of 1 or more, or Inf, stops. Measured
## in headless Chrome before this file was written: animals on one row are at
## least 120 px apart, and a line of ordinary text is about 7 px a character,
## so a line of more than about 17 characters overlaps its neighbour's label.
## Every expected value was computed on a prototype of the change first
## (Learning 18). nprcgenekeepr has no such argument; DIVERGENCE.md records the
## difference "at the switch" (R98).
library(testthat)

.longName <- "Grand-Champion-Xerxes-Constantinopolous-The-Magnificent-III"
## tools/gapCases.R's labels case: 27 characters, the line break one of them.
.twoLineNote <- "age 7\nMHC A01/B02 long text"

## One founder, P1, named `name`.
.namedFounder <- function(name) {
  data.frame(
    id = "P1", sire = NA_character_, dam = NA_character_,
    sex = "F", gen = 0L, name = name, stringsAsFactors = FALSE
  )
}

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's labels case; A has the two-line note,
## B a short name, C none (NA) and D an empty one.
.noteFamily <- function() {
  data.frame(
    id = c("A", "B", "C", "D"),
    sire = c(NA, NA, "A", "A"),
    dam = c(NA, NA, "B", "B"),
    sex = c("M", "F", "M", "F"),
    gen = c(0L, 0L, 1L, 1L),
    name = c(.twoLineNote, "Willow", NA, ""),
    stringsAsFactors = FALSE
  )
}

## The loop pedigree of test_makePedigreeMatingLayout.R's D7 test: 8LKBV9 is
## drawn twice, once as a repeat node; here it has the long name.
.loopFamily <- function() {
  data.frame(
    id = c("5A6DFT", "8DKELJ", "G8EBU9", "8P17E3",
           "8LKBV9", "FJIB3R", "9VGCCV", "GA204Z"),
    sire = c(NA, NA, NA, NA, "5A6DFT", "8LKBV9", "8LKBV9", "8LKBV9"),
    dam = c(NA, NA, NA, NA, "8DKELJ", "G8EBU9", "8P17E3", "FJIB3R"),
    sex = c("M", "F", "F", "F", "M", "F", "F", "M"),
    gen = c(0L, 0L, 0L, 0L, 1L, 2L, 2L, 3L),
    name = c(NA, NA, NA, NA, .longName, NA, NA, "Comet"),
    stringsAsFactors = FALSE
  )
}

## Values that are not one whole number of 1 or more, or Inf.
.badMaxNameChars <- list(
  0, -1, 2.5, -Inf, NaN, NA, NA_real_, c(10, 20), numeric(0), "15", TRUE,
  NULL
)

.labelOf <- function(result, id) result$nodes$label[result$nodes$id == id]

test_that(
  "makePedigreeDiagramData's maxNameChars is 15 by default, and 15 cuts a
   name as before Phase G3", {
  expect_identical(formals(makePedigreeDiagramData)$maxNameChars, 15)
  ped <- .namedFounder(.longName)
  byDefault <- makePedigreeDiagramData(ped)
  expect_identical(.labelOf(byDefault, "P1"), "P1\nGrand-Champion-...")
  expect_identical(makePedigreeDiagramData(ped, maxNameChars = 15),
                   byDefault)
  expect_identical(makePedigreeDiagramData(ped, maxNameChars = 15L),
                   byDefault)
})

test_that(
  "makePedigreeDiagramData writes the first maxNameChars characters of a
   longer name and '...', and a name of maxNameChars characters whole", {
  long <- .namedFounder(.longName)
  expect_identical(
    .labelOf(makePedigreeDiagramData(long, maxNameChars = 20), "P1"),
    "P1\nGrand-Champion-Xerxe..."
  )
  expect_identical(
    .labelOf(makePedigreeDiagramData(long, maxNameChars = 1), "P1"),
    "P1\nG..."
  )
  six <- .namedFounder("Clover")
  expect_identical(
    .labelOf(makePedigreeDiagramData(six, maxNameChars = 6), "P1"),
    "P1\nClover"
  )
  expect_identical(
    .labelOf(makePedigreeDiagramData(six, maxNameChars = 5L), "P1"),
    "P1\nClove..."
  )
})

test_that(
  "makePedigreeDiagramData writes every name whole with maxNameChars = Inf,
   and counts a line break as one of the characters", {
  expect_identical(
    .labelOf(makePedigreeDiagramData(.namedFounder(.longName),
                                     maxNameChars = Inf), "P1"),
    paste0("P1\n", .longName)
  )
  ped <- .noteFamily()
  expect_identical(.labelOf(makePedigreeDiagramData(ped), "A"),
                   "A\nage 7\nMHC A01/B...")
  expect_identical(
    .labelOf(makePedigreeDiagramData(ped, maxNameChars = Inf), "A"),
    "A\nage 7\nMHC A01/B02 long text"
  )
  expect_identical(
    .labelOf(makePedigreeDiagramData(ped, maxNameChars = 27), "A"),
    "A\nage 7\nMHC A01/B02 long text"
  )
  expect_identical(
    .labelOf(makePedigreeDiagramData(ped, maxNameChars = 26), "A"),
    "A\nage 7\nMHC A01/B02 long tex..."
  )
})

test_that(
  "makePedigreeDiagramData's maxNameChars changes nothing but the labels:
   the hover text keeps the whole name, a missing or empty name gives the
   bare id, and without a name column every label is the id", {
  ped <- .noteFamily()
  byDefault <- makePedigreeDiagramData(ped)
  whole <- makePedigreeDiagramData(ped, maxNameChars = Inf)
  short <- makePedigreeDiagramData(ped, maxNameChars = 3)
  for (result in list(whole, short)) {
    expect_identical(result$edges, byDefault$edges)
    expect_identical(result$nodes[names(result$nodes) != "label"],
                     byDefault$nodes[names(byDefault$nodes) != "label"])
  }
  expect_true(grepl("Name:</b> age 7\nMHC A01/B02 long text",
                    short$nodes$title[short$nodes$id == "A"], fixed = TRUE))
  expect_identical(short$nodes$label, c("A\nage...", "B\nWil...", "C", "D"))
  noName <- ped[names(ped) != "name"]
  noNameShort <- makePedigreeDiagramData(noName, maxNameChars = 3)
  expect_identical(noNameShort, makePedigreeDiagramData(noName))
  expect_identical(noNameShort$nodes$label, ped$id)
})

test_that(
  "makePedigreeDiagramData stops on a maxNameChars that is not one whole
   number of 1 or more, or Inf, with or without a name column", {
  ped <- .noteFamily()
  for (bad in .badMaxNameChars) {
    expect_error(
      makePedigreeDiagramData(ped, maxNameChars = bad),
      paste0("makePedigreeDiagramData() requires 'maxNameChars' to be one ",
             "whole number of 1 or more, or Inf for no limit."),
      fixed = TRUE
    )
  }
  expect_error(
    makePedigreeDiagramData(ped[names(ped) != "name"], maxNameChars = 0),
    "'maxNameChars'", fixed = TRUE
  )
})

test_that(
  "makePedigreeMatingLayout's maxNameChars is 15 by default, and 15 cuts a
   name as before Phase G3, on an animal and on its repeat node alike", {
  expect_identical(formals(makePedigreeMatingLayout)$maxNameChars, 15)
  ped <- .loopFamily()
  byDefault <- makePedigreeMatingLayout(ped)
  repeats <- names(byDefault$duplicateToReal)[
    byDefault$duplicateToReal == "8LKBV9"]
  expect_length(repeats, 1L)
  expect_identical(.labelOf(byDefault, "8LKBV9"), "8LKBV9\nGrand-Champion-...")
  expect_identical(.labelOf(byDefault, repeats), "8LKBV9\nGrand-Champion-...")
  expect_identical(makePedigreeMatingLayout(ped, maxNameChars = 15),
                   byDefault)
  expect_identical(makePedigreeMatingLayout(ped, maxNameChars = 15L),
                   byDefault)
})

test_that(
  "makePedigreeMatingLayout writes an animal's name and its repeat node's
   cut at maxNameChars, or whole with Inf, and changes nothing but the
   labels", {
  ped <- .loopFamily()
  byDefault <- makePedigreeMatingLayout(ped)
  repeats <- names(byDefault$duplicateToReal)[
    byDefault$duplicateToReal == "8LKBV9"]
  at20 <- makePedigreeMatingLayout(ped, maxNameChars = 20)
  whole <- makePedigreeMatingLayout(ped, maxNameChars = Inf)
  for (id in c("8LKBV9", repeats)) {
    expect_identical(.labelOf(at20, id), "8LKBV9\nGrand-Champion-Xerxe...")
    expect_identical(.labelOf(whole, id), paste0("8LKBV9\n", .longName))
  }
  expect_identical(.labelOf(at20, "GA204Z"), "GA204Z\nComet")
  for (result in list(at20, whole)) {
    expect_identical(result[names(result) != "nodes"],
                     byDefault[names(byDefault) != "nodes"])
    expect_identical(result$nodes[names(result$nodes) != "label"],
                     byDefault$nodes[names(byDefault$nodes) != "label"])
  }
  expect_true(grepl(paste0("Name:</b> ", .longName),
                    at20$nodes$title[at20$nodes$id == "8LKBV9"],
                    fixed = TRUE))
})

test_that(
  "makePedigreeMatingLayout counts a line break as one of maxNameChars'
   characters, gives a missing or empty name the bare id, and without a
   name column gives every animal its id", {
  ped <- .noteFamily()
  labelsOf <- function(result) result$nodes$label[match(ped$id,
                                                         result$nodes$id)]
  expect_identical(labelsOf(makePedigreeMatingLayout(ped)),
                   c("A\nage 7\nMHC A01/B...", "B\nWillow", "C", "D"))
  expect_identical(labelsOf(makePedigreeMatingLayout(ped, maxNameChars = 26)),
                   c("A\nage 7\nMHC A01/B02 long tex...", "B\nWillow", "C",
                     "D"))
  expect_identical(labelsOf(makePedigreeMatingLayout(ped, maxNameChars = 27)),
                   c("A\nage 7\nMHC A01/B02 long text", "B\nWillow", "C",
                     "D"))
  expect_identical(labelsOf(makePedigreeMatingLayout(ped, maxNameChars = Inf)),
                   c("A\nage 7\nMHC A01/B02 long text", "B\nWillow", "C",
                     "D"))
  noName <- ped[names(ped) != "name"]
  expect_identical(makePedigreeMatingLayout(noName, maxNameChars = 3),
                   makePedigreeMatingLayout(noName))
  expect_identical(labelsOf(makePedigreeMatingLayout(noName,
                                                     maxNameChars = 3)),
                   ped$id)
})

test_that(
  "makePedigreeMatingLayout stops on a maxNameChars that is not one whole
   number of 1 or more, or Inf, with or without a name column", {
  ped <- .noteFamily()
  for (bad in .badMaxNameChars) {
    expect_error(
      makePedigreeMatingLayout(ped, maxNameChars = bad),
      paste0("makePedigreeMatingLayout() requires 'maxNameChars' to be one ",
             "whole number of 1 or more, or Inf for no limit."),
      fixed = TRUE
    )
  }
  expect_error(
    makePedigreeMatingLayout(ped[names(ped) != "name"], maxNameChars = 0),
    "'maxNameChars'", fixed = TRUE
  )
})

test_that(
  "in a browser, vis.js writes A's two-line note whole under its id with
   maxNameChars = Inf, and cut after 15 characters by default", {
  skip_on_cran()
  skip_if_not_installed("visNetwork")
  skip_if_not_installed("htmlwidgets")
  skip_if_not_installed("withr")
  skip_if_no_chrome()

  ## As getLiveRenderedPositions() (helper-live-render-positions.R): a 60 s
  ## timeout on chromote's shared parent before the first session, and one
  ## graceful close of it after the suite.
  chromeParent <- chromote::default_chromote_object()
  if (chromeParent$default_timeout < 60) {
    chromeParent$default_timeout <- 60
  }
  if (!isTRUE(.chromoteParentTeardownRegistered$done)) {
    withr::defer(chromeParent$close(), envir = testthat::teardown_env())
    .chromoteParentTeardownRegistered$done <- TRUE
  }
  session <- chromote::ChromoteSession$new()
  withr::defer(session$close())

  ## The lines vis.js draws under node A, joined with "|".
  linesJs <- paste0(
    "(() => { const el = document.querySelector('.visNetwork'); ",
    "const w = el && HTMLWidgets.find('#' + el.id); ",
    "if (!w || !w.network) { return 'none'; } w.network.redraw(); ",
    "const n = w.network.body.nodes['A']; ",
    "return n.labelModule.lines.map(l => ",
    "l.blocks.map(b => b.text).join('')).join('|'); })()"
  )
  ped <- .noteFamily()
  drawn <- list(
    byDefault = c("A", "age 7", "MHC A01/B..."),
    whole = c("A", "age 7", "MHC A01/B02 long text")
  )
  for (case in names(drawn)) {
    layout <- if (case == "whole") {
      makePedigreeMatingLayout(ped, maxNameChars = Inf)
    } else {
      makePedigreeMatingLayout(ped)
    }
    html <- withr::local_tempfile(fileext = ".html")
    htmlwidgets::saveWidget(drawPedigreeDiagram(layout), html,
                            selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    got <- session$Runtime$evaluate(linesJs)$result$value
    expect_identical(strsplit(got, "|", fixed = TRUE)[[1L]], drawn[[case]],
                     label = paste(case, ": the lines under A"))
  }
})
