## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S62, plan
## Phase G14, gap B5 (spacing) of docs/research/pedkindraw-gaps-2026-11-18.md;
## ruling R140). pedkindraw placed the animals of a row 120 units apart and
## the rows 150 apart, at every size; kinship2's column and row distances
## follow its page's width and height (measured S62: the rows 4.49 times the
## columns on a square page, 1.97 on a wide one, 10.92 on a tall one), so a
## drawing can be made wider or deeper. R140 (S60): the spacing is the third
## of four settings, a multiple of today's (1 = as before), one positive
## number with no upper limit. Mark's picks (S62): two settings,
## columnSpacing and rowSpacing; large text does not widen the columns by
## itself (the user widens them); the line width is a session of its own.
## Measured first: every place is today's times the spacing in both edge
## styles (7 pedigrees, smallPed and rhesus375), and the rectilinear style's
## steps around an animal and its curved links to a repeat appearance are
## worked out at the spacing given (rhesus375: 101-139 of its 170 links bent
## otherwise than in a layout scaled afterwards); in headless Chrome at 500
## pixels no spacing cut an id at the drawing's sides, columns at 0.5 laid
## long ids over each other and rows at 0.5 laid the sibship lines across
## the ids; at text size 2 the 10-character ids of neighbours overlapped and
## at column spacing 1.4 they did not. Every expected value here computed on
## a prototype of the change first (Learning 18). nprcgenekeepr has the same
## fixed 120 and 150 and no such argument; DIVERGENCE.md records it "at the
## switch" (R98).
library(testthat)

## A sibship: A (a male) and B (a female) are the parents of C, D, E and F.
## Each named argument adds a column.
.spacePed <- function(...) {
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E", "F"),
    sire = c(NA, NA, "A", "A", "A", "A"),
    dam = c(NA, NA, "B", "B", "B", "B"),
    sex = c("M", "F", "M", "F", "U", "H"),
    gen = c(0L, 0L, 1L, 1L, 1L, 1L),
    status = c("DECEASED", "ALIVE", "ALIVE", "DECEASED", "ALIVE", "ALIVE"),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

## The sibship with a 10-character id for each of the four offspring.
.spaceLongPed <- function() {
  ped <- .spacePed()
  long <- c(C = "CQ01234567", D = "DQ01234567", E = "EQ01234567",
            F = "FQ01234567")
  at <- ped$id %in% names(long)
  ped$id[at] <- long[ped$id[at]]
  ped
}

## The loop pedigree of G2's and G13's tests: 8LKBV9 is drawn more than once.
.spaceLoopPed <- function() {
  data.frame(
    id = c("5A6DFT", "8DKELJ", "G8EBU9", "8P17E3",
           "8LKBV9", "FJIB3R", "9VGCCV", "GA204Z"),
    sire = c(NA, NA, NA, NA, "5A6DFT", "8LKBV9", "8LKBV9", "8LKBV9"),
    dam = c(NA, NA, NA, NA, "8DKELJ", "G8EBU9", "8P17E3", "FJIB3R"),
    sex = c("M", "F", "F", "F", "M", "F", "F", "M"),
    gen = c(0L, 0L, 0L, 0L, 1L, 2L, 2L, 3L),
    stringsAsFactors = FALSE
  )
}

## The sibship with all seven of Phase G13's marks.
.spaceMarkedPed <- function() {
  .spacePed(affected = c(TRUE, FALSE, NA, TRUE, FALSE, FALSE),
            genotyped = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE),
            carrier = c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE),
            proband = c(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE),
            consultand = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),
            evaluated = c(TRUE, FALSE, TRUE, FALSE, FALSE, TRUE),
            fertility = c("infertile", NA, "infertile", NA,
                          "infertile_choice_na", NA),
            miscarriage = c(NA, NA, NA, "ECT", NA, "SAB"))
}

## smallPed with its generations from findGeneration() (gaps plan dragon 66).
.spaceSmallPed <- function() {
  ped <- smallPed
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

## The spacings given and the column and row distances, in units, they give:
## 120 and 150 times them, rounded to a whole unit and at least 1.
.spacings <- data.frame(
  columnSpacing = c(0.5, 1, 1.4, 2, 0.004, 1.02),
  rowSpacing = c(1, 0.5, 1.4, 0.75, 0.004, 3),
  columnUnits = c(60, 120, 168, 240, 1, 122),
  rowUnits = c(150, 75, 210, 112, 1, 450)
)

test_that(
  ".fullColumnUnits is 120 and .fullRowUnits 150 units, the distances
   between columns and rows before Phase G14", {
  expect_identical(.fullColumnUnits, 120L)
  expect_identical(.fullRowUnits, 150L)
})

test_that(
  "makePedigreeMatingLayout's columnSpacing and rowSpacing default to 1,
   and giving 1 changes no layout or drawing", {
  expect_identical(formals(makePedigreeMatingLayout)$columnSpacing, 1.0)
  expect_identical(formals(makePedigreeMatingLayout)$rowSpacing, 1.0)
  for (p in list(.spaceMarkedPed(), .spaceLoopPed(), .spaceSmallPed())) {
    for (edgeStyle in c("rectilinear", "direct")) {
      base <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle)
      given <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle,
                                        columnSpacing = 1, rowSpacing = 1)
      expect_identical(given, base, info = edgeStyle)
      expect_identical(drawPedigreeDiagram(given, edgeStyle = edgeStyle),
                       drawPedigreeDiagram(base, edgeStyle = edgeStyle),
                       info = edgeStyle)
    }
  }
})

test_that(
  "in the direct style the spacings put every node at today's place times
   the column and row distances they give, 120 and 150 times them rounded
   to a whole unit and at least 1, and change nothing else", {
  for (p in list(.spaceSmallPed(), .spaceLoopPed())) {
    base <- makePedigreeMatingLayout(p, edgeStyle = "direct")
    for (i in seq_len(nrow(.spacings))) {
      s <- .spacings[i, ]
      result <- makePedigreeMatingLayout(p, edgeStyle = "direct",
                                         columnSpacing = s$columnSpacing,
                                         rowSpacing = s$rowSpacing)
      info <- paste(s$columnSpacing, s$rowSpacing)
      expect_equal(result$nodes$x, base$nodes$x / 120 * s$columnUnits,
                   info = info)
      expect_equal(result$nodes$y, base$nodes$y / 150 * s$rowUnits,
                   info = info)
      others <- setdiff(names(base$nodes), c("x", "y"))
      expect_identical(result$nodes[others], base$nodes[others], info = info)
      expect_identical(result[names(result) != "nodes"],
                       base[names(base) != "nodes"], info = info)
    }
  }
})

test_that(
  "in the rectilinear style the spacings put the animals, the repeat
   appearances, the mating points and the lines' bend points at today's
   places times the distances, and add or drop no line", {
  for (p in list(.spaceSmallPed(), .spaceLoopPed(), .spaceMarkedPed())) {
    base <- makePedigreeMatingLayout(p)
    for (i in seq_len(nrow(.spacings))) {
      s <- .spacings[i, ]
      ## At 0.004 every animal is 1 unit from the next, and the loop
      ## pedigree's curved link to its repeat appearance cannot clear the
      ## symbols; the layout says so, as for any crowded drawing.
      make <- function() {
        makePedigreeMatingLayout(p, columnSpacing = s$columnSpacing,
                                 rowSpacing = s$rowSpacing)
      }
      if (s$columnSpacing == 0.004 && "GA204Z" %in% p$id) {
        expect_warning(result <- make(), "could not be fully resolved")
      } else {
        expect_no_warning(result <- make())
      }
      info <- paste(s$columnSpacing, s$rowSpacing)
      expect_identical(result$nodes$id, base$nodes$id, info = info)
      expect_identical(result$edges, base$edges, info = info)
      placed <- !startsWith(base$nodes$id, "__jog_")
      expect_gte(sum(startsWith(base$nodes$id, "__bar_")), 4L)
      expect_gte(sum(startsWith(base$nodes$id, "__union_")), 1L)
      expect_equal(result$nodes$x[placed],
                   base$nodes$x[placed] / 120 * s$columnUnits, info = info)
      expect_equal(result$nodes$y[placed],
                   base$nodes$y[placed] / 150 * s$rowUnits, info = info)
    }
  }
})

test_that(
  "a step around an animal is worked out at the spacing given: 1 unit below
   the symbols, or 0.15 of the gap to the nearest row of lines when that is
   more, so smallPed's two steps run 26 units below their row at row
   spacing 0.5 to 2 and 27 at 3, at today's x times the column spacing", {
  ped <- .spaceSmallPed()
  base <- makePedigreeMatingLayout(ped)
  jogsOf <- function(result) {
    result$nodes[startsWith(result$nodes$id, "__jog_"), ]
  }
  rows <- c(0.5, 0.75, 1, 1.4, 2, 3)
  rowUnits <- c(75, 112, 150, 210, 300, 450)
  depth <- c(26, 26, 26, 26, 26, 27)
  for (i in seq_along(rows)) {
    jogs <- jogsOf(makePedigreeMatingLayout(ped, rowSpacing = rows[[i]]))
    expect_identical(nrow(jogs), 2L)
    expect_equal(jogs$y, rep(rowUnits[[i]] + depth[[i]], 2L), info = rows[[i]])
  }
  for (columns in c(0.5, 1.4, 2)) {
    jogs <- jogsOf(makePedigreeMatingLayout(ped, columnSpacing = columns))
    expect_equal(jogs$x, jogsOf(base)$x * columns, info = columns)
    expect_identical(jogs$y, jogsOf(base)$y, info = columns)
  }
})

test_that(
  "a columnSpacing or a rowSpacing that is not one positive number stops,
   naming the argument", {
  ped <- .spacePed()
  for (name in c("columnSpacing", "rowSpacing")) {
    for (bad in list("1", c(1, 2), NA, NA_real_, NaN, 0, -1, Inf, -Inf, TRUE,
                     NULL, list(1), numeric(0L))) {
      args <- list(ped)
      args[name] <- list(bad)
      expect_error(
        do.call(makePedigreeMatingLayout, args),
        paste0("makePedigreeMatingLayout() requires '", name, "' to be one ",
               "positive number."),
        fixed = TRUE
      )
    }
  }
})

test_that(
  "at text size 2 the 10-character ids are wider than the distance between
   today's columns, and column spacing 1.4 makes room for them", {
  ped <- .spaceLongPed()
  offspring <- ped$id[3:6]
  widths <- .labelWidths(offspring, .textPixels(2))
  expect_equal(widths, c(166.544, 166.544, 165.004, 163.436))
  gapAt <- function(columns) {
    result <- makePedigreeMatingLayout(ped, textSize = 2,
                                       columnSpacing = columns)
    x <- sort(result$nodes$x[match(offspring, result$nodes$id)])
    min(diff(x)) - max(widths)
  }
  expect_equal(gapAt(1), 120 - 166.544)
  expect_equal(gapAt(1.4), 168 - 166.544)
})

test_that(
  "in a browser, vis.js draws the animals at the spacing's distances, and at
   text size 2 neighbours' long ids overlap at today's columns and are apart
   at column spacing 1.5", {
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
  load <- function(layout) {
    widget <- drawPedigreeDiagram(layout)
    widget$width <- "500px"
    html <- withr::local_tempfile(fileext = ".html",
                                  .local_envir = parent.frame())
    htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    expect_true(.waitForLegendPictures(session))
  }
  read <- function(body) {
    as.numeric(strsplit(session$Runtime$evaluate(.pixelReaderJs(body))$
                          result$value, " ", fixed = TRUE)[[1L]])
  }

  ## In units: the distance from C to D and from A to C as vis.js places
  ## them, and the least gap between two neighbours' labels, from vis.js's
  ## own label boxes (measured on the prototype: -46.5 at column spacing 1,
  ## 13.5 at 1.5; -46.5 at 1.5 with the column spacing left out).
  ped <- .spaceLongPed()
  body <- paste0(
    "const ids = ['", paste(ped$id[3:6], collapse = "', '"), "']; ",
    "const p = net.getPositions(['A', 'CQ01234567', 'DQ01234567']); ",
    "const b = ids.map(id => net.body.nodes[id].labelModule.size)",
    ".sort((u, v) => u.left - v.left); ",
    "let gap = Infinity; for (let i = 1; i < b.length; i++) ",
    "gap = Math.min(gap, b[i].left - (b[i - 1].left + b[i - 1].width)); ",
    "return [p['DQ01234567'].x - p['CQ01234567'].x, ",
    "p['CQ01234567'].y - p['A'].y, gap].join(' ');"
  )
  for (s in list(c(1, 1), c(1.5, 1.4))) {
    load(makePedigreeMatingLayout(ped, textSize = 2, columnSpacing = s[[1L]],
                                  rowSpacing = s[[2L]]))
    got <- read(body)
    info <- paste(s, collapse = " ")
    expect_equal(got[[1L]], 120 * s[[1L]], tolerance = 1e-6, label = info)
    expect_equal(got[[2L]], 150 * s[[2L]], tolerance = 1e-6, label = info)
    if (s[[1L]] == 1) {
      expect_lt(got[[3L]], -40, label = info)
    } else {
      expect_gt(got[[3L]], 8, label = info)
    }
  }
})
