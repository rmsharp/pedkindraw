## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S63, plan
## Phase G14, gap B5 (line width) of
## docs/research/pedkindraw-gaps-2026-11-18.md; ruling R140). pedkindraw
## drew every line 1 unit wide (vis.js's default), the half-siblings' mating
## line 4, each outline 1 pixel and a genotyped
## animal's 4, and the marks' strokes 2 or 3 units; kinship2's plot() passes
## lwd to par(), so every line and outline it draws follows it, and
## Pedixplorer's lwd multiplies 158 of the 262 rows of its drawing table and
## its legend's lines (measured S62-S63). R140 (S60): the line width is the
## last of four settings, a multiple of today's (1 = as before), one positive
## number with no upper limit. Mark's picks (S63): every line, outline and
## mark follows it; the dashes grow with the line; a genotyped outline is the
## line width plus 3 (4 at 1, as before); the legend is kept as it is.
## Measured first (headless Chrome at 500 pixels, 8 pedigrees, both edge
## styles, all seven marks on): the zoom to fit is the same at every width;
## vis.js draws each dash with round ends, so kept dashes close up (the DZ
## twins' line solid at 5, like an MZ line); vis.js draws an outline in
## screen pixels at any zoom, so four times the line width left a genotyped
## circle 12-58% of its fill at 3, where the line width plus 3 leaves 45-77%;
## the width is not rounded (0.5 and 1.5 draw 0.85-0.92 and 1.06-1.15 of
## today's ink). Every expected value here computed on a prototype of the
## change first (Learning 18). nprcgenekeepr has no such argument;
## DIVERGENCE.md records it "at the switch" (R98).
library(testthat)

## A half-sibling mating with every kind of line: S mates D1 and D2, and
## their offspring A and B mate (the consanguinity line, and S drawn twice:
## the dashed repeat link); C1 and C2 are DZ twins; two conditions (the
## section lines) and the marks: S deceased (the slash), D1 a proband (the
## arrow), A evaluated (the star), C3 infertile (the bars), C4 a termination
## (the miscarriage line); S, A and C1 genotyped. Each named argument
## replaces a column; a NULL drops it.
.linePed <- function(...) {
  ped <- data.frame(
    id = c("S", "D1", "D2", "A", "B", "C1", "C2", "C3", "C4"),
    sire = c(NA, NA, NA, "S", "S", "A", "A", "A", "A"),
    dam = c(NA, NA, NA, "D1", "D2", "B", "B", "B", "B"),
    sex = c("M", "F", "F", "M", "F", "M", "F", "M", "F"),
    gen = c(0L, 0L, 0L, 1L, 1L, 2L, 2L, 2L, 2L),
    status = c("DECEASED", rep("ALIVE", 8L)),
    affectedX = c(TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE),
    affectedY = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE),
    genotyped = c(TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, FALSE),
    proband = c(FALSE, TRUE, rep(FALSE, 7L)),
    evaluated = c(FALSE, FALSE, FALSE, TRUE, rep(FALSE, 5L)),
    fertility = c(rep(NA, 7L), "infertile", NA),
    miscarriage = c(rep(NA, 8L), "TOP"),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

## C1 and C2 are DZ twins, C3 and C4 twins of unknown kind.
.lineTwins <- data.frame(id1 = c("C1", "C3"), id2 = c("C2", "C4"),
                         code = c("DZ twin", "UZ twin"))

## Each dash pattern as text, FALSE for a solid line.
.dashText <- function(dashes) {
  vapply(dashes, function(d) paste(d, collapse = ","), character(1L))
}

test_that(
  "makePedigreeMatingLayout's lineWidth defaults to 1, and giving 1 changes
   no layout or drawing", {
  expect_identical(formals(makePedigreeMatingLayout)$lineWidth, 1.0)
  for (p in list(.linePed(), .linePed(genotyped = NULL))) {
    for (edgeStyle in c("rectilinear", "direct")) {
      base <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle,
                                       twinRelations = .lineTwins[1L, ])
      given <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle,
                                        twinRelations = .lineTwins[1L, ],
                                        lineWidth = 1)
      expect_identical(given, base, info = edgeStyle)
      expect_false("lineWidth" %in% names(given$nodes))
      expect_identical(drawPedigreeDiagram(given, edgeStyle = edgeStyle),
                       drawPedigreeDiagram(base, edgeStyle = edgeStyle),
                       info = edgeStyle)
    }
  }
})

test_that(
  "every line between animals is the line width wide and the half-siblings'
   mating line 4 times it, not rounded, and nothing else about the lines or
   the places changes", {
  for (edgeStyle in c("rectilinear", "direct")) {
    base <- makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                                     twinRelations = .lineTwins[1L, ])
    consanguinity <- base$edges$width %in% 4
    expect_identical(sum(consanguinity), 2L)
    expect_true(all(is.na(base$edges$width[!consanguinity])))
    for (w in c(0.5, 1.5, 2, 3)) {
      result <- makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                                         twinRelations = .lineTwins[1L, ],
                                         lineWidth = w)
      info <- paste(edgeStyle, w)
      expect_identical(result$edges$width,
                       ifelse(consanguinity, 4 * w, w), info = info)
      others <- setdiff(names(base$edges), c("width", "dashes"))
      expect_identical(result$edges[others], base$edges[others], info = info)
      expect_identical(result$nodes[c("id", "x", "y", "size")],
                       base$nodes[c("id", "x", "y", "size")], info = info)
      expect_identical(result[!names(result) %in% c("nodes", "edges")],
                       base[!names(base) %in% c("nodes", "edges")],
                       info = info)
    }
  }
})

test_that(
  "the dashes and gaps grow with the line width: the repeat link's (vis.js's
   own 5 and 5), the DZ twins' 4 and 4 and the unknown twins' 14 and 8,
   while a solid line stays solid", {
  for (edgeStyle in c("rectilinear", "direct")) {
    base <- makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                                     twinRelations = .lineTwins)
    before <- .dashText(base$edges$dashes)
    expect_identical(sum(before == "TRUE"), 2L)
    expect_identical(sum(before == "4,4"), 1L)
    expect_identical(sum(before == "14,8"), 1L)
    for (w in c(0.5, 3)) {
      result <- makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                                         twinRelations = .lineTwins,
                                         lineWidth = w)
      after <- .dashText(result$edges$dashes)
      info <- paste(edgeStyle, w)
      expect_identical(after[before == "FALSE"],
                       before[before == "FALSE"], info = info)
      expect_identical(unique(after[before == "TRUE"]),
                       paste(c(5, 5) * w, collapse = ","), info = info)
      expect_identical(after[before == "4,4"],
                       paste(c(4, 4) * w, collapse = ","), info = info)
      expect_identical(after[before == "14,8"],
                       paste(c(14, 8) * w, collapse = ","), info = info)
      expect_true(all(vapply(result$edges$dashes[before != "FALSE"],
                             is.numeric, logical(1L))), info = info)
    }
  }
})

test_that(
  "each outline is the line width wide and a genotyped animal's, its
   repeat appearance's too, the line width plus 3, 4 at 1 as before", {
  for (edgeStyle in c("rectilinear", "direct")) {
    base <- makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle)
    genotyped <- base$nodes$borderWidth == 4L
    expect_identical(sort(base$nodes$id[genotyped]),
                     sort(c("S", "A", "C1",
                            grep("^__dup_S", base$nodes$id, value = TRUE))))
    for (w in c(0.5, 2, 3)) {
      result <- makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                                         lineWidth = w)
      info <- paste(edgeStyle, w)
      expect_identical(result$nodes$borderWidth,
                       ifelse(genotyped, w + 3, w), info = info)
      untyped <- makePedigreeMatingLayout(.linePed(genotyped = NULL),
                                          edgeStyle = edgeStyle,
                                          lineWidth = w)
      expect_identical(untyped$nodes$borderWidth,
                       rep(w, nrow(untyped$nodes)), info = info)
    }
  }
})

test_that(
  "every node carries the line width in lineWidth, and each mark's handler
   strokes its lines that many times today's width, written as a number, so
   at 1 its script is today's", {
  for (w in c(0.5, 3)) {
    result <- makePedigreeMatingLayout(.linePed(), lineWidth = w)
    expect_identical(result$nodes$lineWidth, rep(w, nrow(result$nodes)))
  }
  handlers <- list(
    slash = list(.deceasedSlashHandler, 3),
    arrow = list(.probandArrowHandler, 2),
    star = list(.evaluatedStarHandler, 2),
    bars = list(.infertileBarsHandler, 2),
    miscarriage = list(.miscarriageHandler, 2),
    sections = list(.conditionSectionsHandler, 1)
  )
  for (name in names(handlers)) {
    handler <- handlers[[name]][[1L]]
    k <- handlers[[name]][[2L]]
    today <- paste0("ctx.lineWidth = ", k, ";")
    expect_identical(handler(lineWidth = 1), handler(), info = name)
    expect_match(handler(), today, fixed = TRUE, info = name)
    for (w in c(0.5, 3)) {
      text <- handler(lineWidth = w)
      at <- paste0("ctx.lineWidth = ", k * w, ";")
      expect_match(text, at, fixed = TRUE, info = paste(name, w))
      expect_identical(sub(at, today, text, fixed = TRUE), handler(),
                       info = paste(name, w))
      expect_false(grepl("\"", text, fixed = TRUE))
    }
  }
  ## The drawing gives every handler the layout's line width: the slash 3
  ## times it, the arrow, star, bars and miscarriage line 2 times, the
  ## section lines once.
  count <- function(text, width) {
    hits <- gregexpr(paste0("ctx.lineWidth = ", width, ";"), text,
                     fixed = TRUE)[[1L]]
    sum(hits > 0L)
  }
  for (w in c(0.5, 3)) {
    drawn <- drawPedigreeDiagram(
      makePedigreeMatingLayout(.linePed(), lineWidth = w)
    )$x$events$afterDrawing
    expect_identical(count(drawn, 3 * w), 1L)
    expect_identical(count(drawn, 2 * w), 4L)
    expect_identical(count(drawn, w), 1L)
    expect_identical(lengths(regmatches(drawn, gregexpr("ctx.lineWidth",
                                                        drawn,
                                                        fixed = TRUE))), 6L)
  }
})

test_that(
  "the legend and the drawing's height are the same at every line width,
   the Genotyped row kept with its outline 4 wide", {
  for (edgeStyle in c("rectilinear", "direct")) {
    base <- drawPedigreeDiagram(
      makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                               twinRelations = .lineTwins),
      edgeStyle = edgeStyle
    )
    expect_true("Genotyped" %in% base$x$legend$nodes$label)
    for (w in c(0.5, 3)) {
      result <- drawPedigreeDiagram(
        makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                                 twinRelations = .lineTwins, lineWidth = w),
        edgeStyle = edgeStyle
      )
      info <- paste(edgeStyle, w)
      expect_identical(result$x$legend, base$x$legend, info = info)
      expect_identical(result$height, base$height, info = info)
    }
  }
})

test_that(
  "a lineWidth that is not one positive number stops, naming the argument", {
  ped <- .linePed()
  for (bad in list("1", c(1, 2), NA, NA_real_, NaN, 0, -1, Inf, -Inf, TRUE,
                   NULL, list(1), numeric(0L))) {
    expect_error(
      do.call(makePedigreeMatingLayout, list(ped, lineWidth = bad)),
      paste0("makePedigreeMatingLayout() requires 'lineWidth' to be one ",
             "positive number."),
      fixed = TRUE
    )
  }
})

test_that(
  "in a browser, every line, outline and mark is drawn at the line width:
   at 3 the canvas strokes each line, mark and dash 3 times as wide or long
   as at 1, each outline 3 pixels and a genotyped one 6, at the same zoom", {
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

  ## Every stroke of one redraw: its colour, its width in units and its dash
  ## pattern; and the zoom. An outline's width in units is its pixels over
  ## the zoom (vis.js draws it in screen pixels at any zoom). Returned as
  ## text, the zoom first and then one "colour;width;dash;" per stroke, each
  ## after a "|" (S63 GREEN: read without jsonlite, as the other browser
  ## tests read theirs; the trailing ";" keeps an empty dash).
  body <- paste0(
    "const rec = []; const P = CanvasRenderingContext2D.prototype; ",
    "const s0 = P.stroke; P.stroke = function() { ",
    "rec.push(String(this.strokeStyle).toLowerCase() + ';' + ",
    "this.lineWidth + ';' + this.getLineDash().join(',') + ';'); ",
    "return s0.apply(this, arguments); }; ",
    "try { net.redraw(); } finally { P.stroke = s0; } ",
    "return [net.getScale()].concat(rec).join('|');"
  )
  strokes <- function(edgeStyle, w) {
    layout <- makePedigreeMatingLayout(.linePed(), edgeStyle = edgeStyle,
                                       twinRelations = .lineTwins[1L, ],
                                       lineWidth = w)
    widget <- drawPedigreeDiagram(layout, edgeStyle = edgeStyle)
    widget$width <- "500px"
    html <- withr::local_tempfile(fileext = ".html")
    htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    expect_true(.waitForLegendPictures(session))
    got <- strsplit(
      session$Runtime$evaluate(.pixelReaderJs(body))$result$value,
      "|", fixed = TRUE
    )[[1L]]
    parts <- do.call(rbind, strsplit(got[-1L], ";", fixed = TRUE))
    list(scale = as.numeric(got[[1L]]),
         strokes = data.frame(color = parts[, 1L],
                              width = as.numeric(parts[, 2L]),
                              dash = parts[, 3L], stringsAsFactors = FALSE))
  }
  for (edgeStyle in c("rectilinear", "direct")) {
    one <- strokes(edgeStyle, 1)
    three <- strokes(edgeStyle, 3)
    expect_equal(three$scale, one$scale, tolerance = 1e-9)
    s1 <- one$strokes
    s3 <- three$strokes
    expect_identical(nrow(s3), nrow(s1), info = edgeStyle)
    expect_identical(s3$color, s1$color, info = edgeStyle)
    ## The outlines: vis.js's node strokes, 1 and 4 pixels at 1.
    px1 <- round(s1$width * one$scale, 6)
    outline <- s1$color %in% c("#2b7ce9", "rgba(0, 0, 0, 0)") &
      s1$dash == "" & px1 %in% c(1, 4)
    expect_identical(sum(outline & px1 == 4), 4L, info = edgeStyle)
    expect_gte(sum(outline & px1 == 1), 10L)
    expect_equal(round(s3$width[outline] * three$scale, 6),
                 ifelse(px1[outline] == 4, 6, 3), info = edgeStyle)
    ## Every other stroke: the lines, the marks and the dashes, 3 times.
    expect_equal(s3$width[!outline], 3 * s1$width[!outline],
                 info = edgeStyle)
    expect_identical(sort(unique(s1$width[s1$color == "#000000"])), c(2, 3))
    expect_identical(sum(s1$color == "#d55e00" & s1$width == 4), 2L)
    dash1 <- s1$dash[s1$dash != ""]
    expect_identical(sort(dash1), c("4,4", "5,5", "5,5"))
    expect_identical(
      s3$dash[s1$dash != ""],
      vapply(strsplit(dash1, ",", fixed = TRUE), function(d) {
        paste(3 * as.numeric(d), collapse = ",")
      }, character(1L)),
      info = edgeStyle
    )
  }
})
