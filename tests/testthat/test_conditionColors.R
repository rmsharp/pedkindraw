## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S45, plan
## Phase G4, gap B5 (colours) of docs/research/pedkindraw-gaps-2026-11-18.md).
## The four condition colours were fixed, and the drawing's section painter
## kept its own copy of them: colours edited in a layout reached the legend
## but not the sections, and with one condition the fills but not the legend.
## Mark's picks (S45): an argument conditionColors in makePedigreeDiagramData()
## and makePedigreeMatingLayout(), default the four colours as before; the
## layout writes them into its conditions table and its fills, and
## drawPedigreeDiagram() paints the sections and the legend from that table.
## Each colour is a name R knows or a code, written as its "#RRGGBB" code:
## measured in headless Chrome, a browser reads 516 of R's 657 colour names as
## no colour and 5 (gray, grey, green, maroon, purple) as other colours. A
## colour R does not know, a number, a transparent colour, white, the unknown
## grey, a colour given twice and fewer colours than the layout draws
## conditions each stop, naming the colours. Every expected value was computed
## on a prototype of the change first (Learning 18), and the browser test read
## each of its 40 colours exactly there. nprcgenekeepr has no such argument;
## DIVERGENCE.md records the difference "at the switch" (R98).
library(testthat)

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's style case. Each named argument adds a
## column.
.colourPed <- function(...) {
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

## The same four animals with k conditions (1 to 5), each column's animals
## affected in turn, and the column names the layout reads.
.kConditions <- function(k) {
  columns <- c("affected", paste0("affected", 2:5))[seq_len(k)]
  args <- lapply(seq_len(k), function(i) {
    c(TRUE, FALSE, TRUE, FALSE)[(seq_len(4L) + i - 2L) %% 4L + 1L]
  })
  names(args) <- columns
  do.call(.colourPed, args)
}

## The fill of each of `ids`' own nodes in a layout or diagram data.
.colourFill <- function(result, ids) {
  result$nodes[["color.background"]][match(ids, result$nodes$id)]
}

## The colours a drawing's section painter fills the sections with; none when
## the drawing has no section painter (fewer than two conditions).
.sectionColours <- function(drawing) {
  script <- as.character(drawing$x$events$afterDrawing)
  list <- regmatches(script, regexpr("var colors = \\[[^]]*\\]", script))
  as.character(unlist(regmatches(list, gregexpr("#[0-9A-F]{6}", list))))
}

## The fill of the filled section in each condition's legend picture.
.pictureFills <- function(drawing, labels) {
  nodes <- drawing$x$legend$nodes
  vapply(nodes$image[match(labels, nodes$label)], function(uri) {
    sub(".*<path[^>]*fill='([^']*)'.*", "\\1", utils::URLdecode(uri))
  }, character(1L), USE.NAMES = FALSE)
}

.defaultColours <- c("#CC79A7", "#E69F00", "#56B4E9", "#009E73")
.bothBuilders <- c("makePedigreeDiagramData", "makePedigreeMatingLayout")

test_that(
  "both builders' conditionColors default to the four colours drawn before
   Phase G4, and giving them changes no layout, data or drawing", {
  for (fn in .bothBuilders) {
    expect_identical(eval(formals(fn)$conditionColors), .defaultColours,
                     info = fn)
  }
  expect_identical(.conditionColors, .defaultColours)
  for (k in 0:5) {
    ped <- if (k == 0L) .colourPed() else .kConditions(k)
    info <- paste(k, "conditions")
    lay <- makePedigreeMatingLayout(ped)
    expect_identical(
      makePedigreeMatingLayout(ped, conditionColors = .defaultColours), lay,
      info = info
    )
    expect_identical(lay$conditions$color,
                     .defaultColours[seq_len(min(k, 4L))], info = info)
    expect_identical(.sectionColours(drawPedigreeDiagram(lay)),
                     if (k >= 2L) .defaultColours else character(0L),
                     info = info)
    expect_identical(
      makePedigreeDiagramData(ped, conditionColors = .defaultColours),
      makePedigreeDiagramData(ped), info = info
    )
  }
})

test_that(
  "makePedigreeDiagramData fills an affected animal with the first colour,
   written as its code, an unknown one grey and an unaffected one white; the
   other colours are not used, and without the column every fill is white", {
  ped <- .colourPed(affected = c(TRUE, NA, FALSE, TRUE))
  expect_identical(
    .colourFill(makePedigreeDiagramData(ped, conditionColors = "orange"),
                ped$id),
    c("#FFA500", "#BEBEBE", "#FFFFFF", "#FFA500")
  )
  expect_identical(
    .colourFill(makePedigreeDiagramData(
      ped, conditionColors = c("#123", "gold", "navy", "tan")
    ), ped$id),
    c("#112233", "#BEBEBE", "#FFFFFF", "#112233")
  )
  ped$affected <- NULL
  expect_identical(
    .colourFill(makePedigreeDiagramData(ped, conditionColors = "orange"),
                ped$id),
    rep("#FFFFFF", 4L)
  )
})

test_that(
  "makePedigreeMatingLayout with one condition fills each affected animal and
   its repeat nodes with the first colour, and writes it in conditions", {
  ped <- .colourPed(affected_diabetes = c(TRUE, NA, FALSE, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    lay <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle,
                                    conditionColors = c("orange", "navy"))
    expect_identical(.colourFill(lay, ped$id),
                     c("#FFA500", "#BEBEBE", "#FFFFFF", "#FFA500"),
                     info = edgeStyle)
    expect_identical(lay$conditions$color, "#FFA500", info = edgeStyle)
  }

  ## 8LKBV9 is affected and drawn twice, once as a repeat node.
  loopPed <- data.frame(
    id = c("5A6DFT", "8DKELJ", "G8EBU9", "8P17E3",
           "8LKBV9", "FJIB3R", "9VGCCV", "GA204Z"),
    sire = c(NA, NA, NA, NA, "5A6DFT", "8LKBV9", "8LKBV9", "8LKBV9"),
    dam = c(NA, NA, NA, NA, "8DKELJ", "G8EBU9", "8P17E3", "FJIB3R"),
    sex = c("M", "F", "F", "F", "M", "F", "F", "M"),
    gen = c(0L, 0L, 0L, 0L, 1L, 2L, 2L, 3L),
    affected = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE),
    stringsAsFactors = FALSE
  )
  lay <- makePedigreeMatingLayout(loopPed, conditionColors = "darkgreen")
  dupIds <- names(lay$duplicateToReal)[lay$duplicateToReal == "8LKBV9"]
  expect_gte(length(dupIds), 1L)
  expect_identical(.colourFill(lay, c("8LKBV9", dupIds, "GA204Z")),
                   rep("#006400", 2L + length(dupIds)))
  others <- lay$nodes[!(lay$nodes$id %in%
                          c(loopPed$id, names(lay$duplicateToReal))), ]
  expect_false(any(others[["color.background"]] %in% "#006400"))
})

test_that(
  "makePedigreeMatingLayout with two to four conditions writes the chosen
   colours, as codes, in conditions, and leaves every animal's fill white", {
  chosen <- c("Green", "maroon", "#abcdef", "grey50")
  codes <- c("#00FF00", "#B03060", "#ABCDEF", "#7F7F7F")
  for (k in 2:4) {
    ped <- .kConditions(k)
    lay <- makePedigreeMatingLayout(ped, conditionColors = chosen[seq_len(k)])
    info <- paste(k, "conditions")
    expect_identical(lay$conditions$color, codes[seq_len(k)], info = info)
    expect_identical(.colourFill(lay, ped$id), rep("#FFFFFF", 4L),
                     info = info)
    expect_identical(lay$nodes$affectedSections,
                     makePedigreeMatingLayout(ped)$nodes$affectedSections,
                     info = info)
  }
  ## Five conditions, four drawn: four colours are enough.
  lay <- makePedigreeMatingLayout(.kConditions(5L), conditionColors = chosen)
  expect_identical(lay$conditions$color, codes)
  expect_identical(lay$conditionsNotDrawn, "affected5")
})

test_that(
  "drawPedigreeDiagram paints the sections and the legend in the layout's
   colours: the one condition's hexagon, or each condition's picture, and
   the section painter's list, the defaults after the conditions drawn", {
  skip_if_not_installed("visNetwork")

  lay <- makePedigreeMatingLayout(
    .colourPed(affected = c(TRUE, NA, FALSE, TRUE)),
    conditionColors = "orange"
  )
  legend <- drawPedigreeDiagram(lay)$x$legend$nodes
  expect_identical(
    legend[["color.background"]][match("Affected", legend$label)], "#FFA500"
  )

  chosen <- c("#00FF00", "#B03060", "#112233", "#FFD700")
  for (k in 2:4) {
    lay <- makePedigreeMatingLayout(.kConditions(k),
                                    conditionColors = chosen[seq_len(k)])
    drawing <- drawPedigreeDiagram(lay)
    info <- paste(k, "conditions")
    expect_identical(.sectionColours(drawing),
                     c(chosen[seq_len(k)], .defaultColours[-seq_len(k)]),
                     info = info)
    expect_identical(.pictureFills(drawing, lay$conditions$label),
                     chosen[seq_len(k)], info = info)
  }
})

test_that(
  "colours edited in a layout's conditions table now reach the sections as
   well as the legend (the gaps document's section 9, item 2)", {
  skip_if_not_installed("visNetwork")

  lay <- makePedigreeMatingLayout(.kConditions(2L))
  lay$conditions$color <- c("#111111", "#222222")
  drawing <- drawPedigreeDiagram(lay)
  expect_identical(.sectionColours(drawing),
                   c("#111111", "#222222", "#56B4E9", "#009E73"))
  expect_identical(.pictureFills(drawing, lay$conditions$label),
                   c("#111111", "#222222"))
})

test_that(
  "with no condition column the colours change nothing: every fill is white
   and the legend's one 'Affected' row keeps the first default colour", {
  skip_if_not_installed("visNetwork")

  ped <- .colourPed()
  lay <- makePedigreeMatingLayout(ped, conditionColors = "orange")
  expect_identical(lay, makePedigreeMatingLayout(ped))
  legend <- drawPedigreeDiagram(lay)$x$legend$nodes
  expect_identical(
    legend[["color.background"]][match("Affected", legend$label)], "#CC79A7"
  )
})

test_that(
  "each colour R knows is written as its #RRGGBB code, as R reads it, not as
   a browser reads the name", {
  ped <- .colourPed(affected = c(TRUE, FALSE, FALSE, FALSE))
  codeOf <- function(colour) {
    .colourFill(makePedigreeDiagramData(ped, conditionColors = colour), "A")
  }
  expect_identical(codeOf("orange"), "#FFA500")
  expect_identical(codeOf("ORANGE"), "#FFA500")
  expect_identical(codeOf("light blue"), "#ADD8E6")
  expect_identical(codeOf("steelblue3"), "#4F94CD")
  expect_identical(codeOf("#abc"), "#AABBCC")
  expect_identical(codeOf("#7a0177"), "#7A0177")
  ## A browser reads these five names as other colours.
  expect_identical(
    vapply(c("gray30", "green", "maroon", "purple"), codeOf, character(1L),
           USE.NAMES = FALSE),
    c("#4D4D4D", "#00FF00", "#B03060", "#A020F0")
  )
})

## conditionColors values that are not 1 to 4 colours, as text, without NA.
.notColourVectors <- list(
  2, 1:2, TRUE, NULL, NA, NA_character_, c("red", NA), character(0),
  c("red", "blue", "gold", "tan", "navy"), list("red"), factor("red")
)

test_that(
  "both builders stop unless conditionColors is 1 to 4 colours, as text,
   without NA", {
  ped <- .kConditions(1L)
  for (fn in .bothBuilders) {
    for (bad in .notColourVectors) {
      expect_error(
        do.call(fn, list(ped, conditionColors = bad)),
        paste0(fn, "() requires 'conditionColors' to be 1 to 4 colours, each ",
               "a name R knows, such as \"orange\", or a code such as ",
               "\"#E69F00\"."),
        fixed = TRUE, info = paste(fn, deparse(bad))
      )
    }
  }
})

test_that(
  "both builders stop on a colour R does not know, a number, a transparent
   colour, white, the unknown grey and two conditions the same colour, naming
   the colours", {
  ped <- .kConditions(1L)
  cases <- list(
    list(c("red", "notacolour", "blue2x", ""),
         "to be colours R knows. Not known: \"notacolour\", \"blue2x\", \"\"."),
    list(c("red", "2"),
         paste0("to name each colour, not give a number: \"2\" (a number ",
                "picks from R's palette, which can be changed).")),
    list(c("#FF000080", "transparent", "red"),
         paste0("to be opaque colours. Transparent: \"#FF000080\", ",
                "\"transparent\".")),
    list(c("white", "gray", "#bebebe", "#FFF"),
         paste0("to differ from white, which marks an unaffected animal, and ",
                "from grey #BEBEBE, which marks an unknown status: \"white\", ",
                "\"gray\", \"#bebebe\", \"#FFF\".")),
    list(c("red", "gold", "#FF0000"),
         "to give each condition its own colour: \"red\", \"#FF0000\" are the same.")
  )
  for (fn in .bothBuilders) {
    for (case in cases) {
      expect_error(
        do.call(fn, list(ped, conditionColors = case[[1L]])),
        paste0(fn, "() requires 'conditionColors' ", case[[2L]]),
        fixed = TRUE, info = paste(fn, toString(case[[1L]]))
      )
    }
  }
})

test_that(
  "makePedigreeMatingLayout stops when it draws more conditions than
   conditionColors gives, naming the columns", {
  expect_error(
    makePedigreeMatingLayout(.kConditions(3L),
                             conditionColors = c("red", "blue")),
    paste0("makePedigreeMatingLayout() requires 'conditionColors' to give a ",
           "colour for each condition drawn: 2 colours for the 3 conditions ",
           "\"affected\", \"affected2\", \"affected3\"."),
    fixed = TRUE
  )
  expect_error(
    makePedigreeMatingLayout(.kConditions(5L), conditionColors = "red"),
    "1 colour for the 4 conditions", fixed = TRUE
  )
  ## makePedigreeDiagramData draws only the column affected.
  expect_no_error(makePedigreeDiagramData(.kConditions(3L),
                                          conditionColors = "red"))
})

## The colour, as "r,g,b", vis.js drew in each section j of k of each animal
## in `ids` (halfway out from the centre; with one condition, the centre), and
## in each legend row of `labels`: a hexagon's centre with one condition, the
## middle of the filled section of each picture with two or more. Returns one
## "id;j;r,g,b" line per section and one "legend;j;r,g,b" line per row
## ("legend;j;none" when the legend has no such row).
.colourPixelsJs <- function(ids, k, labels) {
  paste0(
    "(() => { const el = document.querySelector('.visNetwork'); ",
    "const w = HTMLWidgets.find('#' + el.id); const net = w.network; ",
    "const L = w.legend; const k = ", k, "; ",
    "const read = (nw, x, y) => { const cv = nw.canvas.frame.canvas; ",
    "const r = cv.width / cv.clientWidth; ",
    "const p = nw.canvasToDOM({x: x, y: y}); ",
    "const d = cv.getContext('2d').getImageData(Math.round(p.x * r), ",
    "Math.round(p.y * r), 1, 1).data; return [d[0], d[1], d[2]].join(','); }; ",
    "const at = (j, f) => { ",
    "const a = -Math.PI / 2 - (j - 0.5) * 2 * Math.PI / k; ",
    "return [f * Math.cos(a), f * Math.sin(a)]; }; ",
    "const out = []; [", paste0("'", ids, "'", collapse = ", "), "].forEach(",
    "id => { const p = net.getPosition(id); ",
    "const s = net.body.nodes[id].options.size; ",
    "for (let j = 1; j <= k; j++) { const o = at(j, k === 1 ? 0 : 0.5 * s); ",
    "out.push([id, j, read(net, p.x + o[0], p.y + o[1])].join(';')); } }); ",
    "[", paste0("'", labels, "'", collapse = ", "), "].forEach((lab, i) => { ",
    "const lid = L.body.nodeIndices.find(id => ",
    "L.body.nodes[id].options.label === lab); ",
    "if (lid === undefined) { out.push(['legend', i + 1, 'none'].join(';')); ",
    "return; } const n = L.body.nodes[lid]; ",
    "const o = at(i + 1, k === 1 ? 0 : 0.5 * n.options.size * 22 / 25); ",
    "out.push(['legend', i + 1, read(L, n.x + o[0], n.y + o[1])].join(';')); ",
    "}); return out.join('|'); })()"
  )
}

test_that(
  "in a browser, vis.js draws the chosen colours in the animals' fills or
   sections and in the legend's rows, with one, three and four conditions", {
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

  cases <- list(
    list(columns = list(affected = c(TRUE, NA, FALSE, TRUE)),
         colours = "orange"),
    list(columns = list(affected_x = c(TRUE, FALSE, FALSE, TRUE),
                        affected_y = c(FALSE, TRUE, FALSE, TRUE),
                        affected_z = c(TRUE, TRUE, FALSE, FALSE)),
         colours = c("Green", "maroon", "#123")),
    list(columns = list(affected = c(TRUE, TRUE, FALSE, TRUE),
                        affected2 = c(TRUE, FALSE, TRUE, FALSE),
                        affected3 = c(FALSE, TRUE, TRUE, TRUE),
                        affected4 = c(TRUE, TRUE, TRUE, FALSE)),
         colours = c("steelblue3", "darkolivegreen3", "#7A0177", "gold"))
  )
  rgbOf <- function(colour) as.integer(grDevices::col2rgb(colour))
  checked <- 0L
  for (case in cases) {
    ped <- do.call(.colourPed, case$columns)
    k <- length(case$columns)
    layout <- makePedigreeMatingLayout(ped, conditionColors = case$colours)
    html <- withr::local_tempfile(fileext = ".html")
    htmlwidgets::saveWidget(drawPedigreeDiagram(layout), html,
                            selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    expect_true(.waitForLegendPictures(session),
                label = paste(k, "conditions: the legend's pictures loaded"))
    cells <- strsplit(strsplit(session$Runtime$evaluate(
      .colourPixelsJs(ped$id, k, layout$conditions$label)
    )$result$value, "|", fixed = TRUE)[[1L]], ";", fixed = TRUE)
    expect_length(cells, 5L * k)
    for (cell in cells) {
      j <- as.integer(cell[[2L]])
      if (identical(cell[[3L]], "none")) {
        fail(sprintf("%d conditions: the legend has no row %d", k, j))
        next
      }
      want <- if (cell[[1L]] == "legend") {
        rgbOf(case$colours[[j]])
      } else {
        status <- case$columns[[j]][[match(cell[[1L]], ped$id)]]
        if (is.na(status)) {
          rgbOf(.unknownColor)
        } else if (status) {
          rgbOf(case$colours[[j]])
        } else {
          c(255L, 255L, 255L)
        }
      }
      got <- as.integer(strsplit(cell[[3L]], ",", fixed = TRUE)[[1L]])
      expect_lte(max(abs(got - want)), 10L, label = sprintf(
        "%d conditions, %s, section or row %d: %s (want %s)", k, cell[[1L]],
        j, cell[[3L]], paste(want, collapse = ",")
      ))
      checked <- checked + 1L
    }
  }
  expect_identical(checked, 40L)
})
