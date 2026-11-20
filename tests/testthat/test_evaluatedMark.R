## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S57, plan
## Phase G13, gap B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R133 and R137). Pedixplorer marks an animal with a documented evaluation
## with a "*" just outside the upper-right corner of its symbol; it reads NA
## as FALSE and has no legend row. pedkindraw ignored such a column. Mark's
## picks (S57): a "*" of three strokes to the right of the upper-right corner
## of the symbol's square, where it lies on no line, outline or deceased slash
## (Pedixplorer's place lies on the end of every deceased square's slash);
## invisible points so a "*" at the drawing's right edge is not cut off; an
## "Evaluated" legend row, the "*" alone, before "Deceased", 45 px. The column
## `evaluated` is read as R134 reads `genotyped`; NA is drawn unmarked, its
## hover text "Evaluated: Unknown". The looks were measured in headless
## Chrome at 500 px before the picker, and every expected value here was
## computed on a prototype of the change first (Learning 18). nprcgenekeepr
## has no such mark; DIVERGENCE.md records it "at the switch" (R98).
library(testthat)

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's markings case. Each named argument adds
## a column.
.evaluatedPed <- function(...) {
  ped <- data.frame(
    id = c("A", "B", "C", "D"),
    sire = c(NA, NA, "A", "A"),
    dam = c(NA, NA, "B", "B"),
    sex = c("M", "F", "M", "F"),
    gen = c(0L, 0L, 1L, 1L),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

## A field of each of `ids`' own nodes in a layout.
.evaluatedFieldOf <- function(result, field, ids) {
  result$nodes[[field]][match(ids, result$nodes$id)]
}

## The loop pedigree of G2's tests: 8LKBV9 is drawn more than once.
.evaluatedLoopPed <- function(...) {
  ped <- data.frame(
    id = c("5A6DFT", "8DKELJ", "G8EBU9", "8P17E3",
           "8LKBV9", "FJIB3R", "9VGCCV", "GA204Z"),
    sire = c(NA, NA, NA, NA, "5A6DFT", "8LKBV9", "8LKBV9", "8LKBV9"),
    dam = c(NA, NA, NA, NA, "8DKELJ", "G8EBU9", "8P17E3", "FJIB3R"),
    sex = c("M", "F", "F", "F", "M", "F", "F", "M"),
    gen = c(0L, 0L, 0L, 0L, 1L, 2L, 2L, 3L),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

test_that(
  ".evaluatedStar puts the star to the right of the upper-right corner of the
   symbol's square", {
  expect_identical(.evaluatedStar, list(x = 1.6, y = -0.8, r = 0.28))
})

test_that(
  "makePedigreeMatingLayout marks an evaluated animal's node TRUE and every
   other node FALSE, in both edge styles, only with the column", {
  ped <- .evaluatedPed(evaluated = c(TRUE, NA, FALSE, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    expect_identical(.evaluatedFieldOf(result, "evaluated", ped$id),
                     c(TRUE, FALSE, FALSE, TRUE), info = edgeStyle)
    others <- result$nodes[!result$nodes$id %in% ped$id, ]
    expect_gt(nrow(others), 0L)
    expect_identical(unique(others$evaluated), FALSE, info = edgeStyle)
    without <- makePedigreeMatingLayout(.evaluatedPed(), edgeStyle = edgeStyle)
    expect_false("evaluated" %in% names(without$nodes), info = edgeStyle)
  }
})

test_that(
  "every repeat appearance of an evaluated animal is marked and has its hover
   line, and the mating-union and routing nodes are not", {
  ped <- .evaluatedLoopPed(evaluated = c(FALSE, TRUE, FALSE, NA, TRUE, FALSE,
                                         FALSE, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    dupIds <- names(result$duplicateToReal)[result$duplicateToReal == "8LKBV9"]
    expect_gte(length(dupIds), 1L)
    expect_identical(.evaluatedFieldOf(result, "evaluated",
                                       c("8LKBV9", dupIds)),
                     rep(TRUE, 1L + length(dupIds)), info = edgeStyle)
    expect_true(all(grepl("<b>Evaluated:</b> Yes",
                          .evaluatedFieldOf(result, "title",
                                            c("8LKBV9", dupIds)),
                          fixed = TRUE)), info = edgeStyle)
    expect_identical(.evaluatedFieldOf(result, "evaluated", ped$id),
                     c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE),
                     info = edgeStyle)
    others <- result$nodes[!(result$nodes$id %in%
                               c(ped$id, names(result$duplicateToReal))), ]
    expect_true(any(startsWith(others$id, "__union_")), info = edgeStyle)
    expect_identical(unique(others$evaluated), FALSE, info = edgeStyle)
  }
})

test_that(
  "the hover text says Evaluated: Yes, No or Unknown, after the consultand
   line and before the name, and nothing without the column", {
  ped <- .evaluatedPed(affected = c(TRUE, FALSE, NA, FALSE),
                       carrier = c(FALSE, TRUE, NA, TRUE),
                       proband = c(FALSE, NA, TRUE, FALSE),
                       consultand = c(TRUE, FALSE, NA, FALSE),
                       evaluated = c(NA, TRUE, FALSE, TRUE),
                       name = c("Ace", "Bea", "Cy", "Di"))
  result <- makePedigreeMatingLayout(ped)
  titles <- .evaluatedFieldOf(result, "title", ped$id)
  shown <- c("Unknown", "Yes", "No", "Yes")
  for (i in seq_along(titles)) {
    evaluatedAt <- regexpr(paste0("<br><b>Evaluated:</b> ", shown[[i]]),
                           titles[[i]], fixed = TRUE)
    expect_gt(evaluatedAt, regexpr("<b>Consultand:</b>", titles[[i]],
                                   fixed = TRUE), label = ped$id[[i]])
    expect_lt(evaluatedAt, regexpr("<b>Name:</b>", titles[[i]],
                                   fixed = TRUE), label = ped$id[[i]])
  }
  ped$evaluated <- NULL
  without <- makePedigreeMatingLayout(ped)
  expect_false(any(grepl("Evaluated", without$nodes$title, fixed = TRUE)))
})

test_that(
  "the column reads TRUE and FALSE as logical values, as 1 and 0, and as text
   or a factor, NA and NaN as not recorded", {
  want <- c(TRUE, FALSE, FALSE, TRUE)
  forms <- list(
    logical = c(TRUE, FALSE, NA, TRUE),
    double = c(1.0, 0.0, NaN, 1.0),
    integer = c(1L, 0L, NA, 1L),
    text = c("TRUE", "false", NA, "T"),
    factor = factor(c("True", "F", NA, "TRUE"))
  )
  base <- makePedigreeMatingLayout(.evaluatedPed(evaluated = forms$logical))
  for (form in names(forms)) {
    result <- makePedigreeMatingLayout(
      .evaluatedPed(evaluated = forms[[form]])
    )
    expect_identical(.evaluatedFieldOf(result, "evaluated",
                                       c("A", "B", "C", "D")),
                     want, info = form)
    expect_identical(result$nodes$title, base$nodes$title, info = form)
  }
})

test_that(
  "an evaluated column holding anything else stops, naming the column and its
   values, before any animal is left out", {
  expect_error(
    makePedigreeMatingLayout(.evaluatedPed(evaluated = c(2.0, 1.0, 0.0, 0.5))),
    paste0("makePedigreeMatingLayout(): the column 'evaluated' holds ",
           "values other than TRUE, FALSE and NA (2, 0.5). Give TRUE or ",
           "FALSE (or 1 or 0) for each animal, NA where it is not ",
           "recorded."),
    fixed = TRUE
  )
  expect_error(
    makePedigreeMatingLayout(.evaluatedPed(evaluated = c("yes", "no", "TRUE",
                                                         ""))),
    paste0("the column 'evaluated' holds values other than TRUE, FALSE and ",
           "NA ('yes', 'no', '')"),
    fixed = TRUE
  )
  ## E has no parent, mate or offspring, so the layout leaves it out; its
  ## value still stops the layout.
  ped <- rbind(.evaluatedPed(evaluated = c(TRUE, FALSE, FALSE, FALSE)),
               data.frame(id = "E", sire = NA, dam = NA, sex = "M",
                          gen = 0L, evaluated = 3.0))
  expect_error(suppressMessages(makePedigreeMatingLayout(ped)),
               "the column 'evaluated' holds values other than TRUE, FALSE and NA (3)",
               fixed = TRUE)
})

test_that(
  "with every animal left out the layout's empty nodes gain an empty
   evaluated field only when the pedigree has the column", {
  ped <- data.frame(id = c("A", "B"), sire = NA, dam = NA, sex = c("M", "F"),
                    gen = 0L, stringsAsFactors = FALSE)
  without <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_false("evaluated" %in% names(without$nodes))
  ped$evaluated <- c(TRUE, FALSE)
  result <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(nrow(result$nodes), 0L)
  expect_identical(result$nodes$evaluated, logical())
})

test_that(
  "a real id starting __eval_, the prefix of the drawing's points, is
   refused, and the message names the prefix", {
  ped <- .evaluatedPed()
  for (column in c("id", "sire")) {
    ped[[column]][ped[[column]] %in% "A"] <- "__eval_A"
  }
  ## S58: __fert_ (the infertile mark's points) follows __eval_ in the list.
  expect_error(makePedigreeMatingLayout(ped), "'__mark_'/'__eval_'",
               fixed = TRUE)
  expect_true("__eval_" %in% .reservedIdPrefixes)
})

test_that(
  "on seeded random pedigrees the column adds the field and the hover line
   and changes nothing else", {
  skip_if_not_installed("withr")
  quietLayout <- function(ped) {
    withCallingHandlers(
      suppressMessages(makePedigreeMatingLayout(ped)),
      warning = function(w) {
        if (grepl("same-row edge-node collision", conditionMessage(w),
                  fixed = TRUE)) {
          invokeRestart("muffleWarning")
        }
      }
    )
  }
  compared <- 0L
  for (seed in 1:40) {
    case <- withr::with_seed(seed, {
      ped <- checkPedigreeClean(sample(6L:40L, 1L))
      evaluated <- sample(c(TRUE, FALSE, NA), nrow(ped), replace = TRUE)
      list(ped = ped, evaluated = evaluated)
    })
    ped <- case$ped
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    without <- quietLayout(ped)
    ped$evaluated <- case$evaluated
    with <- quietLayout(ped)
    label <- paste("seed", seed)
    drawn <- with$nodes$id %in% ped$id
    at <- match(with$nodes$id[drawn], ped$id)
    expect_identical(with$nodes$evaluated[drawn],
                     case$evaluated[at] %in% TRUE, label = label)
    keep <- setdiff(names(without$nodes), "title")
    expect_identical(with$nodes[keep], without$nodes[keep], label = label)
    expect_identical(sub("<br><b>Evaluated:</b> [A-Za-z]+", "",
                         with$nodes$title),
                     without$nodes$title, label = label)
    expect_identical(with[names(with) != "nodes"],
                     without[names(without) != "nodes"], label = label)
    compared <- compared + 1L
  }
  expect_identical(compared, 40L)
})

test_that(
  "the star is drawn by a handler run last, after the arrows, the carrier's
   dot and the deceased slash, only when some node is an evaluated
   animal's", {
  handler <- .evaluatedStarHandler()
  expect_match(handler, "return n.evaluated === true;", fixed = TRUE)
  expect_match(handler,
               "var cx = p.x + s * 1.6, cy = p.y + s * -0.8, r = s * 0.28;",
               fixed = TRUE)
  expect_match(handler, "var a = Math.PI / 2 + k * Math.PI / 3;",
               fixed = TRUE)
  expect_match(handler, "ctx.lineWidth = 2;", fixed = TRUE)
  expect_false(grepl("\"", handler, fixed = TRUE))
  for (sections in c(FALSE, TRUE)) {
    for (marks in c(FALSE, TRUE)) {
      label <- paste("sections", sections, "carrier and arrows", marks)
      chained <- .diagramAfterDrawing(sections, .conditionColors, marks,
                                      marks, TRUE)
      slashAt <- regexpr(.deceasedSlashHandler(), chained, fixed = TRUE)
      starAt <- regexpr(handler, chained, fixed = TRUE)
      expect_gt(slashAt, 0L, label = label)
      expect_gt(starAt, slashAt, label = label)
      if (marks) {
        expect_gt(starAt, regexpr(.carrierDotHandler(), chained,
                                  fixed = TRUE), label = label)
        expect_gt(starAt, regexpr(.probandArrowHandler(), chained,
                                  fixed = TRUE), label = label)
      }
      expect_identical(grepl("affectedSections", chained, fixed = TRUE),
                       sections, label = label)
    }
  }
  expect_identical(.diagramAfterDrawing(FALSE, evaluated = FALSE),
                   .deceasedSlashHandler())
  expect_false(grepl("n.evaluated",
                     .diagramAfterDrawing(TRUE, carrier = TRUE,
                                          arrows = TRUE),
                     fixed = TRUE))
})

test_that(
  ".evaluatedStarRoom adds one invisible point per evaluated node, 2 units
   beyond the upper-right corner of the square that holds its star", {
  ped <- .evaluatedPed(affected = c(TRUE, FALSE, FALSE, TRUE),
                       affected2 = c(FALSE, TRUE, FALSE, FALSE),
                       status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
                       genotyped = c(TRUE, FALSE, FALSE, FALSE),
                       carrier = c(TRUE, FALSE, FALSE, FALSE),
                       proband = c(FALSE, FALSE, TRUE, FALSE),
                       evaluated = c(TRUE, FALSE, TRUE, NA))
  for (edgeStyle in c("rectilinear", "direct")) {
    nodes <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)$nodes
    out <- .evaluatedStarRoom(nodes)
    expect_identical(nrow(out), nrow(nodes) + 2L, info = edgeStyle)
    expect_identical(out$id[seq_len(nrow(nodes))], nodes$id, info = edgeStyle)
    room <- out[-seq_len(nrow(nodes)), ]
    expect_identical(room$id, c("__eval_A", "__eval_C"), info = edgeStyle)
    owner <- nodes[match(c("A", "C"), nodes$id), ]
    expect_equal(room$x, owner$x + 25 * (1.6 + 0.28) + 2, info = edgeStyle)
    expect_equal(room$y, owner$y + 25 * (-0.8 - 0.28) - 2, info = edgeStyle)
    expect_identical(room$size, c(0L, 0L), info = edgeStyle)
    expect_identical(room$label, c("", ""), info = edgeStyle)
    expect_identical(room$shape, c("dot", "dot"), info = edgeStyle)
    expect_identical(room$title, c(NA_character_, NA_character_),
                     info = edgeStyle)
    expect_identical(unique(room$color.background), "rgba(0,0,0,0)",
                     info = edgeStyle)
    expect_identical(unique(room$color.border), "rgba(0,0,0,0)",
                     info = edgeStyle)
    expect_identical(unique(room$affectedSections), "", info = edgeStyle)
    expect_identical(unique(room$borderWidth), 1L, info = edgeStyle)
    for (field in c("deceased", "carrier", "proband", "evaluated")) {
      expect_identical(unique(room[[field]]), FALSE,
                       info = paste(edgeStyle, field))
    }
    ## The nodes are kept; rbind() makes the direct style's integer y double.
    kept <- out[seq_len(nrow(nodes)), names(nodes)]
    rownames(kept) <- NULL
    expect_equal(kept, nodes, info = edgeStyle)
    ## After the arrows' points: none for a point.
    both <- .evaluatedStarRoom(.probandArrowRoom(nodes))
    expect_identical(both$id[-seq_len(nrow(nodes))],
                     c("__mark_C", "__eval_A", "__eval_C"), info = edgeStyle)
  }
  plain <- makePedigreeMatingLayout(
    .evaluatedPed(evaluated = c(FALSE, NA, FALSE, FALSE)),
    edgeStyle = "direct"
  )$nodes
  expect_identical(.evaluatedStarRoom(plain), plain)
  expect_identical(.evaluatedStarRoom(makePedigreeMatingLayout(
    .evaluatedPed()
  )$nodes), makePedigreeMatingLayout(.evaluatedPed())$nodes)
})

test_that("the legend's picture is the star alone", {
  svg <- utils::URLdecode(sub("data:image/svg+xml;charset=utf-8,", "",
                              .evaluatedLegendImage(), fixed = TRUE))
  stroke <- "stroke='black' stroke-width='3' stroke-linecap='round'/>"
  expect_identical(svg, paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    "<line x1='25.0' y1='13.0' x2='25.0' y2='37.0' ", stroke,
    "<line x1='35.4' y1='19.0' x2='14.6' y2='31.0' ", stroke,
    "<line x1='35.4' y1='31.0' x2='14.6' y2='19.0' ", stroke,
    "</svg>"
  ))
})

test_that(
  "drawPedigreeDiagram adds an Evaluated row before Deceased, 45 px, the
   handler and the points, when an animal is evaluated", {
  skip_if_not_installed("visNetwork")
  rowsOf <- function(w) w$x$legend$nodes
  sexRows <- c("Female", "Male", "Hermaphrodite", "Unknown",
               "Other / Unrecorded")
  layout <- makePedigreeMatingLayout(
    .evaluatedPed(evaluated = c(FALSE, NA, TRUE, TRUE))
  )
  w <- drawPedigreeDiagram(layout)
  rows <- rowsOf(w)
  expect_identical(rows$label, c(sexRows, "Affected", "Evaluated",
                                 "Deceased"))
  expect_identical(rows$shape[rows$label == "Evaluated"], "image")
  expect_identical(rows$image[rows$label == "Evaluated"],
                   .evaluatedLegendImage())
  expect_identical(w$height, "545px")
  expect_identical(as.character(w$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE, evaluated = TRUE))
  expect_identical(w$x$nodes, .evaluatedStarRoom(layout$nodes))
  expect_identical(w$x$idselection$values, c("A", "B", "C", "D"))
  ## Every row: three conditions, an unknown status, a genotyped animal, a
  ## carrier, a proband and a consultand, the Evaluated row after
  ## Consultand; the arrows' points come before the stars'.
  every <- makePedigreeMatingLayout(
    .evaluatedPed(affected = c(TRUE, FALSE, NA, TRUE),
                  affected2 = c(FALSE, TRUE, TRUE, FALSE),
                  affected3 = c(TRUE, TRUE, FALSE, FALSE),
                  genotyped = c(FALSE, TRUE, FALSE, FALSE),
                  carrier = c(FALSE, FALSE, TRUE, FALSE),
                  proband = c(FALSE, FALSE, FALSE, TRUE),
                  consultand = c(TRUE, FALSE, FALSE, FALSE),
                  evaluated = c(TRUE, TRUE, FALSE, FALSE))
  )
  drawn <- drawPedigreeDiagram(every)
  rows <- rowsOf(drawn)
  expect_identical(rows$label,
                   c(sexRows, "Affected", "Affected 2", "Affected 3",
                     "Affected status unknown", "Genotyped", "Carrier",
                     "Proband", "Consultand", "Evaluated", "Deceased"))
  expect_identical(rows$borderWidth[rows$label == "Evaluated"], 1L)
  expect_identical(drawn$height, "860px")
  expect_identical(drawn$x$nodes,
                   .evaluatedStarRoom(.probandArrowRoom(every$nodes)))
  afterDrawing <- as.character(drawn$x$events$afterDrawing)
  expect_gt(regexpr("n.evaluated === true", afterDrawing, fixed = TRUE),
            regexpr("n.proband === true", afterDrawing, fixed = TRUE))
  expect_match(afterDrawing, "n.carrier === true", fixed = TRUE)
  expect_match(afterDrawing, "affectedSections", fixed = TRUE)
})

test_that(
  "with no evaluated animal the drawing has no row, handler, point or height
   for it; without the column the drawing is as before", {
  skip_if_not_installed("visNetwork")
  base <- drawPedigreeDiagram(makePedigreeMatingLayout(.evaluatedPed()))
  for (values in list(c(FALSE, FALSE, NA, FALSE), c(NA, NA, NA, NA))) {
    layout <- makePedigreeMatingLayout(.evaluatedPed(evaluated = values))
    w <- drawPedigreeDiagram(layout)
    expect_identical(w$x$legend, base$x$legend)
    expect_identical(w$height, "500px")
    expect_identical(w$x$events, base$x$events)
    expect_identical(w$x$nodes, layout$nodes)
    expect_identical(unique(w$x$nodes$evaluated), FALSE)
  }
  expect_false("Evaluated" %in% base$x$legend$nodes$label)
  expect_identical(as.character(base$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE))
})

test_that(
  "in a browser, vis.js draws each evaluated animal's star and the legend
   row's star, and a star at the right edge stays inside the canvas", {
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

  ## Six animals, as measured before the picker: A (a deceased sire) and B
  ## (an affected dam) are the parents of C (genotyped), D (deceased), E
  ## (unknown sex, a carrier) and F (a proband, the rightmost animal). A, C,
  ## D and F are evaluated.
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E", "F"),
    sire = c(NA, NA, "A", "A", "A", "A"),
    dam = c(NA, NA, "B", "B", "B", "B"),
    sex = c("M", "F", "M", "F", "U", "H"),
    gen = c(0L, 0L, 1L, 1L, 1L, 1L),
    status = c("DECEASED", "ALIVE", "ALIVE", "DECEASED", "ALIVE", "ALIVE"),
    affected = c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE),
    genotyped = c(FALSE, FALSE, TRUE, FALSE, FALSE, FALSE),
    carrier = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE),
    proband = c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
    evaluated = c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE),
    stringsAsFactors = FALSE
  )
  widget <- drawPedigreeDiagram(makePedigreeMatingLayout(ped))
  widget$width <- "500px"
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  expect_true(.waitForLegendPictures(session))
  ## For each animal: the number of near-black pixels (the alpha counted, as
  ## read() does not, dragon 45) in a 6-unit box at the star's centre, where
  ## its three strokes cross; and the room, in CSS pixels, between the
  ## star's right end and the canvas's right side. Then the legend row's
  ## picture's dark pixels and whether its label ends inside the canvas.
  star <- .evaluatedStar
  js <- .pixelReaderJs(sprintf(paste0(
    "const out = []; const cv = net.canvas.frame.canvas; ",
    "const r = cv.width / cv.clientWidth; const ctx = cv.getContext('2d'); ",
    "const dark = (x0, y0, x1, y1) => { const a = net.canvasToDOM({x: x0, y: y0}); ",
    "const b = net.canvasToDOM({x: x1, y: y1}); ",
    "const d = ctx.getImageData(Math.round(a.x * r), Math.round(a.y * r), ",
    "Math.max(1, Math.round((b.x - a.x) * r)), Math.max(1, Math.round((b.y - a.y) * r))).data; ",
    "let k = 0; for (let i = 0; i < d.length; i += 4) { const al = d[i + 3] / 255; ",
    "if ((0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2]) * al + 255 * (1 - al) < 60) k++; } ",
    "return k; }; ",
    "['A', 'B', 'C', 'D', 'E', 'F'].forEach(id => { ",
    "const p = net.getPosition(id); const s = net.body.nodes[id].options.size; ",
    "const cx = p.x + s * %s, cy = p.y + s * %s; ",
    "out.push(String(dark(cx - 3, cy - 3, cx + 3, cy + 3))); ",
    "out.push((cv.clientWidth - net.canvasToDOM({x: cx + s * %s + 1, y: cy}).x).toFixed(1)); }); ",
    "const id = L.body.nodeIndices.find(i => L.body.nodes[i].options.label === 'Evaluated'); ",
    "if (id === undefined) { out.push('none', 'none'); return out.join('|'); } ",
    "const n = L.body.nodes[id]; const s = n.options.size; ",
    "const a = L.canvasToDOM({x: n.x - s, y: n.y - s}), b = L.canvasToDOM({x: n.x + s, y: n.y + s}); ",
    "const lc = L.canvas.frame.canvas; const lr = lc.width / lc.clientWidth; ",
    "const d = lc.getContext('2d').getImageData(Math.round(a.x * lr), Math.round(a.y * lr), ",
    "Math.round((b.x - a.x) * lr), Math.round((b.y - a.y) * lr)).data; ",
    "let k = 0; for (let i = 0; i < d.length; i += 4) { const al = d[i + 3] / 255; ",
    "if ((0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2]) * al + 255 * (1 - al) < 128) k++; } ",
    "out.push(String(k)); const t = n.labelModule.size; ",
    "out.push(String(L.canvasToDOM({x: t.left + t.width, y: t.top}).x <= lc.clientWidth)); ",
    "return out.join('|');"
  ), star$x, star$y, star$r))
  got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                  fixed = TRUE)[[1L]]
  expect_length(got, 14L)
  ids <- c("A", "B", "C", "D", "E", "F")
  centre <- as.integer(got[seq(1L, 12L, by = 2L)])
  room <- as.numeric(got[seq(2L, 12L, by = 2L)])
  for (i in seq_along(ids)) {
    if (ped$evaluated[[i]]) {
      expect_gt(centre[[i]], 0L, label = paste(ids[[i]], "star"))
    } else {
      expect_identical(centre[[i]], 0L, label = paste(ids[[i]], "no star"))
    }
  }
  ## F is the rightmost animal: its star stays inside the canvas.
  expect_gte(room[[6L]], 0.0)
  expect_gt(as.integer(got[[13L]]), 0L)
  expect_identical(got[[14L]], "true")
})
