## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S60, plan
## Phase G14, gap B5 (sizes) of docs/research/pedkindraw-gaps-2026-11-18.md;
## ruling R140). kinship2's and Pedixplorer's plot() take symbolsize, a
## multiple of their symbol's size; pedkindraw drew every animal 25 units
## across, fixed. Mark's picks (S60): symbol size, text size, column and row
## spacing and line width as arguments of makePedigreeMatingLayout(), each a
## multiple of today's (1 = as before), one positive number with no upper
## limit, as in both packages; symbol size first. The layout must know the
## size, since in the rectilinear style its detours around symbols are worked
## out from it (measured S60: 66-129 of rhesus375's arcs bend differently
## when the size is changed only after the layout); an infertile animal's and
## a miscarriage's moved id moves in proportion (kept at its fixed shift it
## ran into the marks at 1.6, 8-85 pixels on 7 pedigrees); and below full
## size the drawing keeps a full-size symbol's room, so long ids at its edges
## are not cut off (4-5 pixels at 0.6 without it). Measured in headless Chrome
## at 500 pixels on 7 pedigrees in both edge styles with all seven marks on,
## and every expected value here computed on a prototype of the change first
## (Learning 18). nprcgenekeepr has no such argument; DIVERGENCE.md records it
## "at the switch" (R98).
library(testthat)

## A sibship: A (a male) and B (a female) are the parents of C, D, E and F.
## Each named argument adds a column.
.sizePed <- function(...) {
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

## The loop pedigree of G2's and G13's tests: 8LKBV9 is drawn more than once.
.sizeLoopPed <- function() {
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
.sizeMarkedPed <- function() {
  .sizePed(affected = c(TRUE, FALSE, NA, TRUE, FALSE, FALSE),
           genotyped = c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE),
           carrier = c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE),
           proband = c(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE),
           consultand = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),
           evaluated = c(TRUE, FALSE, TRUE, FALSE, FALSE, TRUE),
           fertility = c("infertile", NA, "infertile", NA,
                         "infertile_choice_na", NA),
           miscarriage = c(NA, NA, NA, "TOP", NA, "SAB"))
}

## The size of each of `ids`' own nodes in a layout.
.sizeOf <- function(result, ids) {
  result$nodes$size[match(ids, result$nodes$id)]
}

## The real animals' and repeat appearances' node ids in a layout.
.animalIds <- function(result) {
  c(result$nodes$id[!grepl(.reservedIdPattern, result$nodes$id)],
    names(result$duplicateToReal))
}

test_that(".fullSymbolSize is 25 units, every animal's size before Phase G14", {
  expect_identical(.fullSymbolSize, 25L)
})

test_that(
  "makePedigreeMatingLayout's symbolSize defaults to 1, and giving 1 changes
   no layout or drawing", {
  expect_identical(formals(makePedigreeMatingLayout)$symbolSize, 1.0)
  ped <- smallPed
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  for (p in list(.sizeMarkedPed(), .sizeLoopPed(), ped)) {
    for (edgeStyle in c("rectilinear", "direct")) {
      base <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle)
      given <- makePedigreeMatingLayout(p, edgeStyle = edgeStyle,
                                        symbolSize = 1)
      expect_identical(given, base, info = edgeStyle)
      expect_identical(drawPedigreeDiagram(given, edgeStyle = edgeStyle),
                       drawPedigreeDiagram(base, edgeStyle = edgeStyle),
                       info = edgeStyle)
      expect_identical(unique(.sizeOf(base, .animalIds(base))), 25L)
    }
  }
})

test_that(
  "symbolSize gives every animal's node and repeat appearance 25 times it,
   rounded to a whole unit and at least 1; mating points keep 6 and routing
   points 0", {
  ped <- .sizeLoopPed()
  given <- c(0.6, 1.6, 2, 0.5, 1.02, 0.01, 3)
  expected <- c(15L, 40L, 50L, 12L, 26L, 1L, 75L)
  for (edgeStyle in c("rectilinear", "direct")) {
    for (i in seq_along(given)) {
      ## At 3 the rectilinear layout's detours cannot clear every symbol, and
      ## it says so, as for any crowded drawing.
      make <- function() {
        makePedigreeMatingLayout(ped, edgeStyle = edgeStyle,
                                 symbolSize = given[[i]])
      }
      if (given[[i]] == 3 && edgeStyle == "rectilinear") {
        expect_warning(result <- make(), "could not be fully resolved")
      } else {
        expect_no_warning(result <- make())
      }
      dupIds <- names(result$duplicateToReal)
      expect_gte(length(dupIds), 1L)
      expect_identical(.sizeOf(result, c(ped$id, dupIds)),
                       rep(expected[[i]], nrow(ped) + length(dupIds)),
                       info = paste(edgeStyle, given[[i]]))
      unions <- startsWith(result$nodes$id, "__union_")
      expect_true(any(unions))
      expect_identical(unique(result$nodes$size[unions]), 6L)
      others <- !(result$nodes$id %in% c(ped$id, dupIds)) & !unions
      if (any(others)) {
        expect_identical(unique(result$nodes$size[others]), 0L)
      }
    }
  }
})

test_that(
  "a symbolSize that is not one positive number stops, naming the
   argument", {
  ped <- .sizePed()
  for (bad in list("1", c(1, 2), NA, NA_real_, NaN, 0, -1, Inf, -Inf, TRUE,
                   NULL, list(1), numeric(0L))) {
    expect_error(
      makePedigreeMatingLayout(ped, symbolSize = bad),
      paste("makePedigreeMatingLayout() requires 'symbolSize' to be one",
            "positive number."),
      fixed = TRUE
    )
  }
})

test_that(
  "in the rectilinear style the layout works its detours out from the
   symbol's size: smallPed's step around an animal runs 1 unit below the
   symbols at every size", {
  ped <- smallPed
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  for (s in c(0.6, 1, 1.6, 2)) {
    result <- makePedigreeMatingLayout(ped, symbolSize = s)
    jogs <- result$nodes[startsWith(result$nodes$id, "__jog_"), ]
    expect_identical(nrow(jogs), 2L)
    expect_equal(jogs$y, rep(150 + .symbolUnits(s) + 1, 2L), info = s)
  }
})

test_that(
  "an infertile animal's id moves down 14 units at full size and in
   proportion otherwise, its point 2 units below the moved id's box", {
  ped <- .sizePed(fertility = c(NA, NA, "infertile", NA,
                                "infertile_choice_na", NA))
  for (s in c(0.6, 1, 1.6)) {
    nodes <- makePedigreeMatingLayout(ped, symbolSize = s)$nodes
    size <- .symbolUnits(s)
    idDown <- c("0.6" = 8L, "1" = 14L, "1.6" = 22L)[[as.character(s)]]
    out <- .infertileRoom(nodes)
    marked <- c("C", "E")
    expect_identical(out$font.vadjust[match(marked, out$id)],
                     rep(idDown, 2L), info = s)
    first <- seq_len(nrow(nodes))
    expect_identical(unique(out$font.vadjust[first][!nodes$id %in% marked]),
                     0L, info = s)
    room <- out[startsWith(out$id, "__fert_"), ]
    owner <- nodes[match(sub("^__fert_", "", room$id), nodes$id), ]
    expect_identical(room$id, c("__fert_C", "__fert_E"), info = s)
    expect_equal(room$y, owner$y + size + 25 + idDown + 2, info = s)
    expect_equal(room$x, owner$x, info = s)
  }
})

test_that(
  "a miscarriage's id moves down 12 units at full size and in proportion
   otherwise, its triangle 0.6 of its size and its points at a full-size
   triangle's lower corners", {
  ped <- .sizePed(miscarriage = c(NA, NA, NA, "TOP", NA, "SAB"))
  for (s in c(0.6, 1, 1.6)) {
    nodes <- makePedigreeMatingLayout(ped, symbolSize = s)$nodes
    size <- .symbolUnits(s)
    idDown <- c("0.6" = 7L, "1" = 12L, "1.6" = 19L)[[as.character(s)]]
    small <- c("0.6" = 9L, "1" = 15L, "1.6" = 24L)[[as.character(s)]]
    out <- .miscarriageRoom(nodes)
    marked <- c("D", "F")
    expect_identical(out$font.vadjust[match(marked, out$id)],
                     rep(idDown, 2L), info = s)
    expect_identical(out$size[match(marked, out$id)], rep(small, 2L),
                     info = s)
    room <- out[startsWith(out$id, "__misc_"), ]
    expect_identical(room$id, c("__misc_l_D", "__misc_l_F", "__misc_r_D",
                                "__misc_r_F"), info = s)
    owner <- nodes[match(sub("^__misc_[lr]_", "", room$id), nodes$id), ]
    expect_equal(room$x, owner$x + c(-1, -1, 1, 1) * 1.15 * size, info = s)
    expect_equal(room$y, owner$y + 0.6 * size + 25 + idDown + 2, info = s)
  }
})

test_that(
  ".symbolSizeRoom gives each animal and repeat appearance smaller than full
   size two invisible points where a full-size triangle's lower corners are,
   and nothing else a point", {
  ped <- .sizeLoopPed()
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle,
                                       symbolSize = 0.6)
    nodes <- result$nodes
    animals <- .animalIds(result)
    out <- .symbolSizeRoom(nodes)
    first <- seq_len(nrow(nodes))
    expect_equal(out[first, names(nodes)], nodes, info = edgeStyle)
    room <- out[-seq_len(nrow(nodes)), ]
    inOrder <- nodes$id[nodes$id %in% animals]
    expect_identical(room$id, c(paste0("__size_l_", inOrder),
                                paste0("__size_r_", inOrder)),
                     info = edgeStyle)
    owner <- nodes[match(sub("^__size_[lr]_", "", room$id), nodes$id), ]
    n <- length(inOrder)
    expect_equal(room$x, owner$x + rep(c(-28.75, 28.75), each = n),
                 info = edgeStyle)
    expect_equal(room$y, owner$y + 25, info = edgeStyle)
    expect_identical(unique(room$size), 0L)
    expect_identical(unique(room$label), "")
    expect_identical(unique(room$shape), "dot")
    expect_identical(unique(room$color.background), "rgba(0,0,0,0)")
    expect_identical(unique(room$color.border), "rgba(0,0,0,0)")
    expect_identical(unique(room$deceased), FALSE)
    for (s in c(1, 1.6)) {
      full <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle,
                                       symbolSize = s)$nodes
      expect_identical(.symbolSizeRoom(full), full, info = edgeStyle)
    }
  }
})

test_that(
  "with symbols smaller than full size the drawing has the size points first,
   then each mark's, and leaves them out of the Select by id list", {
  for (s in c(0.6, 1.6)) {
    for (edgeStyle in c("rectilinear", "direct")) {
      layout <- makePedigreeMatingLayout(.sizeMarkedPed(),
                                         edgeStyle = edgeStyle,
                                         symbolSize = s)
      drawn <- drawPedigreeDiagram(layout, edgeStyle = edgeStyle)
      expect_identical(drawn$x$nodes, .miscarriageRoom(.infertileRoom(
        .evaluatedStarRoom(.probandArrowRoom(.symbolSizeRoom(layout$nodes)))
      )), info = paste(s, edgeStyle))
      expect_identical(any(startsWith(drawn$x$nodes$id, "__size_")), s < 1,
                       info = paste(s, edgeStyle))
      listed <- unlist(drawn$x$idselection$values)
      expect_setequal(listed, .sizeMarkedPed()$id)
    }
  }
  plain <- makePedigreeMatingLayout(.sizePed(), symbolSize = 0.6)
  drawn <- drawPedigreeDiagram(plain)
  expect_identical(sum(startsWith(drawn$x$nodes$id, "__size_")), 12L)
})

test_that(
  "a real id starting __size_, the prefix of the drawing's size points, stops
   as the other reserved prefixes do", {
  ped <- .sizePed()
  for (column in c("id", "sire", "dam")) {
    ped[[column]][ped[[column]] %in% "A"] <- "__size_l_A"
  }
  ## S61: __text_ (the drawing's text points) follows __size_ in the list.
  expect_error(makePedigreeMatingLayout(ped), "'__misc_'/'__size_'",
               fixed = TRUE)
  expect_true("__size_" %in% .reservedIdPrefixes)
})

test_that(
  "in a browser, vis.js draws each symbol at its size, keeps the long ids at
   both edges inside the drawing below full size, and draws an infertile
   animal's moved id below its bar", {
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

  ## A sibship, as measured before the picker: CQ01234567 (left) and
  ## FQ01234567 (right), 10-character ids at the edges, cut by 4-5 pixels at
  ## symbolSize 0.6 without the size points; D, with no offspring by choice
  ## (a line and one bar), its id drawn green so its ink is told from the
  ## bar's.
  ids <- c("A", "B", "CQ01234567", "D", "E", "FQ01234567")
  ped <- data.frame(
    id = ids, sire = c(NA, NA, "A", "A", "A", "A"),
    dam = c(NA, NA, "B", "B", "B", "B"),
    sex = c("M", "F", "M", "F", "M", "F"), gen = c(0L, 0L, 1L, 1L, 1L, 1L),
    fertility = c(NA, NA, NA, "infertile_choice_na", NA, NA),
    stringsAsFactors = FALSE
  )
  ## For each size: the zoom; the width, in units, of C's and E's symbol
  ## (the drawn pixels in the row through its centre, either side of it);
  ## the room, in CSS pixels, from the canvas's left edge to the left of
  ## CQ01234567's label box and from the right of FQ01234567's to the right
  ## edge; and, under D, the lowest black pixel of its bar and the highest
  ## green pixel of its id, in units below its centre.
  js <- .pixelReaderJs(paste0(
    "const cv = net.canvas.frame.canvas; const r = cv.width / cv.clientWidth; ",
    "const ctx = cv.getContext('2d'); const z = net.getScale(); ",
    "const px = (x, y) => { const p = net.canvasToDOM({x: x, y: y}); ",
    "return ctx.getImageData(Math.round(p.x * r), Math.round(p.y * r), 1, 1).data; }; ",
    "const width = id => { const p = net.getPosition(id); const s = net.body.nodes[id].options.size; ",
    "let left = 0, right = 0; const step = 0.25 / z; ",
    "while (left < 3 * s && px(p.x - left - step, p.y)[3] > 60) left += step; ",
    "while (right < 3 * s && px(p.x + right + step, p.y)[3] > 60) right += step; ",
    "return left + right; }; ",
    "const box = id => net.body.nodes[id].labelModule.size; ",
    "const a = box('CQ01234567'), b = box('FQ01234567'); ",
    "const leftRoom = net.canvasToDOM({x: a.left, y: a.top}).x; ",
    "const rightRoom = cv.clientWidth - net.canvasToDOM({x: b.left + b.width, y: b.top}).x; ",
    "const p = net.getPosition('D'); const s = net.body.nodes['D'].options.size; ",
    "let bar = -1, id = -1; for (let dy = s + 2; dy < 3 * s + 60; dy += 0.25 / z) { ",
    "for (let dx = -8; dx <= 8; dx += 0.25 / z) { const d = px(p.x + dx, p.y + dy); ",
    "if (d[3] < 128) continue; ",
    "if (d[0] < 80 && d[1] < 80 && d[2] < 80) bar = dy; ",
    "if (d[1] - Math.max(d[0], d[2]) > 60 && id < 0) id = dy; } } ",
    "return [z, width('CQ01234567'), width('E'), leftRoom, rightRoom, bar, id].join(' ');"
  ))
  for (s in c(0.6, 1.6)) {
    layout <- makePedigreeMatingLayout(ped, symbolSize = s)
    layout$nodes$font.color <- ifelse(layout$nodes$id == "D", "#00FF00",
                                      "#343434")
    widget <- drawPedigreeDiagram(layout)
    widget$width <- "500px"
    html <- withr::local_tempfile(fileext = ".html")
    htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    expect_true(.waitForLegendPictures(session))
    got <- as.numeric(strsplit(session$Runtime$evaluate(js)$result$value,
                               " ", fixed = TRUE)[[1L]])
    size <- .symbolUnits(s)
    zoomed <- 2.0 / got[[1L]]
    ## each symbol 2 * size across, within 2 CSS pixels
    expect_lte(abs(got[[2L]] - 2 * size), zoomed, label = paste("C", s))
    expect_lte(abs(got[[3L]] - 2 * size), zoomed, label = paste("E", s))
    ## the long ids inside both edges
    expect_gt(got[[4L]], 0, label = paste("left room", s))
    expect_gt(got[[5L]], 0, label = paste("right room", s))
    ## D's bar drawn, and its green id at least 4 units below the bar's
    ## lowest pixel (measured on the prototype: 9.2 at 0.6 and 8.4 at 1.6;
    ## 0.3 at 1.6 with the id moved its full-size 14 units)
    expect_gt(got[[6L]], 0, label = paste("bar", s))
    expect_gt(got[[7L]] - got[[6L]], 4, label = paste("id below bar", s))
  }
})
