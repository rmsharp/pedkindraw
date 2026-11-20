## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S61, plan
## Phase G14, gap B5 (sizes) of docs/research/pedkindraw-gaps-2026-11-18.md;
## ruling R140). kinship2's and Pedixplorer's plot() take cex, a multiple of
## their text's size; pedkindraw wrote every id and name at vis.js's own 14
## pixels. R140 (S60): the text size is the second of four settings, an
## argument of makePedigreeMatingLayout(), a multiple of today's (1 = as
## before), one positive number with no upper limit. Mark's picks (S61): with
## text larger than today's, invisible points at the outermost labels' ends
## keep them inside the drawing, and the marks' own words ("P", "ECT") and
## the twins' labels keep their sizes. Measured first in headless Chrome at
## 500 pixels on 7 pedigrees in both edge styles with all seven marks on:
## without the points the 10-character ids at the edges were cut 8-10 pixels
## at 1.4 and 27-29 at 2 (16-17 pixels inside with them); the marks' words,
## kept at their sizes, lay on other ink in 1 drawing of 14 per size, and in
## 7-9 of 14 when they followed the text; the layout's places and lines are
## the same at every text size (rhesus375, both edge styles); vis.js puts a
## label's top half its font size and 4 pixels below the shape, each line
## its font size tall, so an infertile animal's and a miscarriage's moved id
## needs 4 + 1.5 times the text size below its symbol (25 at 14: kept at 25,
## the moved id in the bottom row of a deep pedigree had 3-11 pixels to the
## drawing's edge at 2, against today's 17). Every expected value here
## computed on a prototype of the change first (Learning 18). nprcgenekeepr
## has no such argument; DIVERGENCE.md records it "at the switch" (R98).
library(testthat)

## A sibship: A (a male) and B (a female) are the parents of C, D, E and F.
## Each named argument adds a column.
.textPed <- function(...) {
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

## The sibship with 10-character ids at both ends of its offspring's row,
## as measured before the picker.
.textLongPed <- function(...) {
  ped <- .textPed(...)
  long <- c(C = "CQ01234567", F = "FQ01234567")
  for (column in c("id", "sire", "dam")) {
    at <- ped[[column]] %in% names(long)
    ped[[column]][at] <- long[ped[[column]][at]]
  }
  ped
}

## The loop pedigree of G2's and G13's tests: 8LKBV9 is drawn more than once.
.textLoopPed <- function() {
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
.textMarkedPed <- function() {
  .textPed(affected = c(TRUE, FALSE, NA, TRUE, FALSE, FALSE),
           genotyped = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE),
           carrier = c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE),
           proband = c(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE),
           consultand = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),
           evaluated = c(TRUE, FALSE, TRUE, FALSE, FALSE, TRUE),
           fertility = c("infertile", NA, "infertile", NA,
                         "infertile_choice_na", NA),
           miscarriage = c(NA, NA, NA, "ECT", NA, "SAB"))
}

## One line of descent over five generations, each a son of the last mated
## with an outside dam (a founder, generation 0, as findGeneration() gives),
## the last animal (K5, a female) infertile: a deep, narrow drawing, so its
## bottom row sets the zoom.
.textDeepPed <- function() {
  data.frame(
    id = c("S1", "D1", "K2", "D2", "K3", "D3", "K4", "D4", "K5"),
    sire = c(NA, NA, "S1", NA, "K2", NA, "K3", NA, "K4"),
    dam = c(NA, NA, "D1", NA, "D2", NA, "D3", NA, "D4"),
    sex = c("M", "F", "M", "F", "M", "F", "M", "F", "F"),
    gen = c(0L, 0L, 1L, 0L, 2L, 0L, 3L, 0L, 4L),
    fertility = c(rep(NA, 8L), "infertile"),
    stringsAsFactors = FALSE
  )
}

test_that(".fullTextSize is 14 pixels, vis.js's own, every label's before
           Phase G14", {
  expect_identical(.fullTextSize, 14L)
})

test_that(
  "makePedigreeMatingLayout's textSize defaults to 1, and giving 1, or a size
   that rounds to 14 pixels, changes no layout or drawing", {
  expect_identical(formals(makePedigreeMatingLayout)$textSize, 1.0)
  ped <- smallPed
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  for (p in list(.textMarkedPed(), .textLoopPed(), ped)) {
    for (edgeStyle in c("rectilinear", "direct")) {
      base <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle)
      expect_false("font.size" %in% names(base$nodes))
      for (t in c(1, 1.02)) {
        given <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle,
                                          textSize = t)
        expect_identical(given, base, info = paste(edgeStyle, t))
        expect_identical(drawPedigreeDiagram(given, edgeStyle = edgeStyle),
                         drawPedigreeDiagram(base, edgeStyle = edgeStyle),
                         info = paste(edgeStyle, t))
      }
    }
  }
})

test_that(
  "textSize gives every node 14 times it in font.size, rounded to a whole
   pixel and at least 1, and leaves the layout's places and lines as at 1", {
  ped <- .textLoopPed()
  given <- c(0.7, 1.4, 2, 0.5, 1.04, 0.01, 3)
  expected <- c(10L, 20L, 28L, 7L, 15L, 1L, 42L)
  for (edgeStyle in c("rectilinear", "direct")) {
    base <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    for (i in seq_along(given)) {
      expect_no_warning(
        result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle,
                                           textSize = given[[i]])
      )
      info <- paste(edgeStyle, given[[i]])
      expect_gte(length(result$duplicateToReal), 1L)
      expect_identical(result$nodes$font.size,
                       rep(expected[[i]], nrow(result$nodes)), info = info)
      expect_identical(result$nodes[names(base$nodes)], base$nodes,
                       info = info)
      expect_identical(result[names(result) != "nodes"],
                       base[names(base) != "nodes"], info = info)
    }
  }
})

test_that(
  "a textSize that is not one positive number stops, naming the argument", {
  ped <- .textPed()
  for (bad in list("1", c(1, 2), NA, NA_real_, NaN, 0, -1, Inf, -Inf, TRUE,
                   NULL, list(1), numeric(0L))) {
    expect_error(
      makePedigreeMatingLayout(ped, textSize = bad),
      paste("makePedigreeMatingLayout() requires 'textSize' to be one",
            "positive number."),
      fixed = TRUE
    )
  }
})

test_that(
  ".labelWidths gives each label's widest line from Helvetica's character
   widths, which are Arial's, as vis.js measures them", {
  ## 95 printable ASCII characters, in ems.
  expect_identical(names(.labelCharWidths),
                   intToUtf8(32:126, multiple = TRUE))
  expect_identical(unname(.labelCharWidths[c("A", "W", "i", "0", " ")]),
                   c(0.667, 0.944, 0.222, 0.556, 0.278))
  labels <- c("AQ01234567", "WWWWWWWWWW", "iiiiiiiiii", "1234567890")
  expect_equal(.labelWidths(labels, 14), c(82.502, 132.16, 31.08, 77.84))
  ## vis.js's own label widths, read in headless Chrome (S61), within 0.05
  ## pixels.
  measured <- c(82.52, 132.14, 31.10, 77.86)
  expect_lt(max(abs(.labelWidths(labels, 14) - measured)), 0.05)
  expect_lt(abs(.labelWidths("AQ01234567", 20) - 117.88), 0.05)
  ## a name under the id: the wider line; a character not in the table,
  ## one em; an empty label, 0; a size per label.
  expect_equal(.labelWidths("A\nName one", 14), 4.613 * 14)
  expect_equal(.labelWidths("\u00e91", 14), 1.556 * 14)
  expect_identical(.labelWidths("", 14), 0.0)
  expect_equal(.labelWidths(c("A", "A"), c(10, 20)), c(6.67, 13.34))
})

test_that(
  ".textSizeRoom gives text larger than 14 pixels three invisible points: at
   the leftmost and the rightmost label's ends and 2 units under the lowest
   label", {
  for (edgeStyle in c("rectilinear", "direct")) {
    for (t in c(1.4, 2)) {
      info <- paste(edgeStyle, t)
      px <- .textPixels(t)
      nodes <- makePedigreeMatingLayout(.textLongPed(), edgeStyle = edgeStyle,
                                        textSize = t)$nodes
      out <- .textSizeRoom(nodes)
      first <- seq_len(nrow(nodes))
      expect_equal(out[first, names(nodes)], nodes, info = info)
      room <- out[-first, ]
      expect_identical(room$id, c("__text_l_CQ01234567", "__text_r_FQ01234567",
                                  "__text_b_CQ01234567"), info = info)
      owner <- nodes[match(sub("^__text_[lrb]_", "", room$id), nodes$id), ]
      half <- .labelWidths(owner$label, px) / 2
      expect_equal(room$x, owner$x + c(-half[[1L]], half[[2L]], 0),
                   info = info)
      expect_equal(room$y, owner$y + owner$size + 4 + 1.5 * px + 2,
                   info = info)
      expect_identical(unique(room$size), 0L)
      expect_identical(unique(room$label), "")
      expect_identical(unique(room$shape), "dot")
      expect_identical(unique(room$color.background), "rgba(0,0,0,0)")
      expect_identical(unique(room$color.border), "rgba(0,0,0,0)")
      expect_identical(unique(room$deceased), FALSE)
    }
    ## A name under E's id: its two lines make it the lowest label, one text
    ## size lower than one line.
    named <- .textLongPed(name = c(NA, NA, NA, NA, "Edward", NA))
    nodes <- makePedigreeMatingLayout(named, edgeStyle = edgeStyle,
                                      textSize = 2)$nodes
    room <- .textSizeRoom(nodes)[-seq_len(nrow(nodes)), ]
    expect_identical(room$id[[3L]], "__text_b_E", info = edgeStyle)
    owner <- nodes[nodes$id == "E", ]
    expect_equal(room$y[[3L]], owner$y + owner$size + 4 + 2.5 * 28 + 2,
                 info = edgeStyle)
    ## None at 14 pixels or smaller.
    for (t in c(0.5, 0.7, 1)) {
      nodes <- makePedigreeMatingLayout(.textLongPed(), edgeStyle = edgeStyle,
                                        textSize = t)$nodes
      expect_identical(.textSizeRoom(nodes), nodes, info = paste(edgeStyle, t))
    }
  }
})

test_that(
  "an infertile animal's and a miscarriage's points sit 2 units below the
   moved id's label, which reaches 4 + 1.5 times the text size below the
   symbol: 25 units at 14 pixels", {
  depth <- c("0.7" = 19, "1" = 25, "1.4" = 34, "2" = 46)
  infertile <- .textPed(fertility = c(NA, NA, "infertile", NA,
                                      "infertile_choice_na", NA))
  miscarriage <- .textPed(miscarriage = c(NA, NA, NA, "TOP", NA, "SAB"))
  for (t in c(0.7, 1, 1.4, 2)) {
    d <- depth[[as.character(t)]]
    expect_identical(.idLabelDepth(.textPixels(t)), d)
    for (s in c(1, 1.6)) {
      info <- paste(t, s)
      size <- .symbolUnits(s)
      nodes <- makePedigreeMatingLayout(infertile, symbolSize = s,
                                        textSize = t)$nodes
      room <- .infertileRoom(nodes)
      room <- room[startsWith(room$id, "__fert_"), ]
      owner <- nodes[match(sub("^__fert_", "", room$id), nodes$id), ]
      idDown <- c("1" = 14L, "1.6" = 22L)[[as.character(s)]]
      expect_identical(room$id, c("__fert_C", "__fert_E"), info = info)
      expect_equal(room$y, owner$y + size + d + 2 + idDown, info = info)
      nodes <- makePedigreeMatingLayout(miscarriage, symbolSize = s,
                                        textSize = t)$nodes
      room <- .miscarriageRoom(nodes)
      room <- room[startsWith(room$id, "__misc_"), ]
      owner <- nodes[match(sub("^__misc_[lr]_", "", room$id), nodes$id), ]
      idDown <- c("1" = 12L, "1.6" = 19L)[[as.character(s)]]
      expect_identical(nrow(room), 4L, info = info)
      expect_equal(room$y, owner$y + 0.6 * size + d + 2 + idDown,
                   info = info)
    }
  }
})

test_that(
  "with larger text the drawing has the size points, then the text points,
   then each mark's; the marks' words, the twins' labels and the legend keep
   their sizes", {
  for (t in c(1.4, 2)) {
    for (s in c(0.6, 1.6)) {
      for (edgeStyle in c("rectilinear", "direct")) {
        info <- paste(t, s, edgeStyle)
        layout <- makePedigreeMatingLayout(.textMarkedPed(),
                                           edgeStyle = edgeStyle,
                                           symbolSize = s, textSize = t)
        drawn <- drawPedigreeDiagram(layout, edgeStyle = edgeStyle)
        expect_identical(drawn$x$nodes, .miscarriageRoom(.infertileRoom(
          .evaluatedStarRoom(.probandArrowRoom(.textSizeRoom(
            .symbolSizeRoom(layout$nodes)
          )))
        )), info = info)
        expect_identical(sum(startsWith(drawn$x$nodes$id, "__text_")), 3L,
                         info = info)
        expect_setequal(unlist(drawn$x$idselection$values),
                        .textMarkedPed()$id)
        ## the proband's "P" at 12 pixels and "ECT" at 10, as at 1
        script <- drawn$x$events$afterDrawing
        expect_true(grepl("ctx.font = '12px arial'", script, fixed = TRUE),
                    info = info)
        expect_true(grepl("ctx.font = '10px arial'", script, fixed = TRUE),
                    info = info)
        expect_false("font.size" %in% names(drawn$x$legend$nodes))
      }
    }
  }
  ## The twins' "MZ" and "DZ" edges are as at 1.
  ped <- .textPed()
  twins <- data.frame(id1 = c("C", "E"), id2 = c("D", "F"),
                      code = c("MZ twin", "DZ twin"))
  base <- makePedigreeMatingLayout(ped, twinRelations = twins)
  given <- makePedigreeMatingLayout(ped, twinRelations = twins, textSize = 2)
  expect_identical(given$edges, base$edges)
  expect_identical(sort(given$edges$label), c("DZ", "MZ"))
  ## No text points at 14 pixels or smaller.
  small <- makePedigreeMatingLayout(.textMarkedPed(), textSize = 0.7)
  expect_false(any(startsWith(drawPedigreeDiagram(small)$x$nodes$id,
                              "__text_")))
})

test_that(
  "a real id starting __text_, the prefix of the drawing's text points, stops
   as the other reserved prefixes do", {
  ped <- .textPed()
  for (column in c("id", "sire", "dam")) {
    ped[[column]][ped[[column]] %in% "A"] <- "__text_l_A"
  }
  expect_error(makePedigreeMatingLayout(ped), "'__size_'/'__text_' prefix",
               fixed = TRUE)
  expect_identical(.reservedIdPrefixes[[length(.reservedIdPrefixes)]],
                   "__text_")
})

test_that(
  "in a browser, vis.js writes the ids at the text size, keeps the long ids
   at both edges inside the drawing, and keeps a moved id in a deep drawing's
   bottom row inside it", {
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

  ## The sibship with CQ01234567 and FQ01234567 at the edges: each id's
  ## font size and one line's height, in units, and the room, in CSS
  ## pixels, from the canvas's left edge to the left of CQ01234567's label
  ## and from the right of FQ01234567's to the right edge (measured on the
  ## prototype: 16.7 and 16.1 at 1.4, 16.8 and 15.9 at 2; cut by 11.2 and
  ## 10.4, 30.3 and 29.0 without the text points, and 3.1 and 3.7 with the
  ## ids left at 14 pixels).
  edges <- paste0(
    "const cv = net.canvas.frame.canvas; ",
    "const n = id => net.body.nodes[id]; ",
    "const a = n('CQ01234567').labelModule.size, ",
    "b = n('FQ01234567').labelModule.size; ",
    "const left = net.canvasToDOM({x: a.left, y: 0}).x; ",
    "const right = cv.clientWidth - ",
    "net.canvasToDOM({x: b.left + b.width, y: 0}).x; ",
    "return [n('A').options.font.size, n('A').labelModule.size.height, ",
    "n('FQ01234567').options.font.size, left, right].join(' ');"
  )
  for (t in c(1.4, 2)) {
    load(makePedigreeMatingLayout(.textLongPed(), textSize = t))
    got <- read(edges)
    px <- .textPixels(t)
    expect_equal(got[1:3], rep(px, 3L), label = paste("sizes", t))
    expect_gt(got[[4L]], 8, label = paste("left room", t))
    expect_gt(got[[5L]], 8, label = paste("right room", t))
  }

  ## The deep drawing, K5 infertile in its bottom row, its id green: the
  ## room, in CSS pixels, from the lowest green pixel to the widget's bottom
  ## (the canvas reaches past it, gaps plan dragon 52; measured on the
  ## prototype: 23 at symbolSize 1 and 1.6; 14 and 9 with the moved id's room
  ## kept at 25 units).
  bottom <- paste0(
    "const cv = net.canvas.frame.canvas; const r = cv.width / cv.clientWidth; ",
    "const d = cv.getContext('2d').getImageData(0, 0, cv.width, cv.height)",
    ".data; let low = -1; ",
    "for (let y = 0; y < cv.height; y++) for (let x = 0; x < cv.width; x++) {",
    " const i = 4 * (y * cv.width + x); ",
    " if (d[i + 3] > 128 && d[i + 1] - Math.max(d[i], d[i + 2]) > 60) ",
    "low = y; } ",
    "const wb = cv.closest('.visNetwork').getBoundingClientRect(), ",
    "cb = cv.getBoundingClientRect(); ",
    "return [low / r, (wb.bottom - cb.top) - low / r].join(' ');"
  )
  for (s in c(1, 1.6)) {
    layout <- makePedigreeMatingLayout(.textDeepPed(), symbolSize = s,
                                       textSize = 2)
    layout$nodes$font.color <- ifelse(layout$nodes$id == "K5", "#00FF00",
                                      "#343434")
    load(layout)
    got <- read(bottom)
    expect_gt(got[[1L]], 0, label = paste("K5's id drawn", s))
    expect_gt(got[[2L]], 18, label = paste("bottom room", s))
  }
})
