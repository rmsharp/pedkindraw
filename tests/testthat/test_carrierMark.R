## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S55, plan
## Phase G13, gap B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R133 and R135). Pedixplorer marks a carrier, an animal that has the
## genetic trait but is not expected to show the disease, with a small black
## point at the centre of its symbol, and draws nothing for an unknown (NA)
## status; pedkindraw ignored any such column. Mark's picks (S55): a black dot
## at the centre of the symbol, its radius 0.24 of the symbol's size
## (Pedixplorer's is about 0.14), drawn after the deceased slash; NA drawn
## unmarked, its hover text "Carrier: Unknown". The column `carrier` is read
## as R134 reads `genotyped`: TRUE, FALSE and NA, 1 and 0, and the text
## as.logical() reads; anything else stops. A legend row "Carrier", a circle
## with the dot, comes before "Deceased" when any animal is a carrier, which
## makes the drawing 45 px taller. The looks were measured in headless Chrome
## at 500 px before the picker, and every expected value here was computed on
## a prototype of the change first (Learning 18). nprcgenekeepr has no such
## mark; DIVERGENCE.md records it "at the switch" (R98).
library(testthat)

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's markings case. Each named argument adds
## a column.
.carrierPed <- function(...) {
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

## The carrier field of each of `ids`' own nodes in a layout.
.carrierOf <- function(result, ids) {
  result$nodes[["carrier"]][match(ids, result$nodes$id)]
}

## The hover text of each of `ids`' own nodes in a layout.
.carrierTitleOf <- function(result, ids) {
  result$nodes$title[match(ids, result$nodes$id)]
}

## The loop pedigree of G2's tests: 8LKBV9 is drawn more than once.
.carrierLoopPed <- function(...) {
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

test_that(".carrierDotRatio makes the dot's radius 0.24 of the symbol's size", {
  expect_identical(.carrierDotRatio, 0.24)
})

test_that(
  "makePedigreeMatingLayout marks a carrier's node TRUE and every other node
   FALSE, in both edge styles; without the column the nodes have no carrier
   field", {
  ped <- .carrierPed(carrier = c(TRUE, FALSE, NA, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    expect_identical(.carrierOf(result, ped$id), c(TRUE, FALSE, FALSE, TRUE),
                     info = edgeStyle)
    others <- result$nodes[!result$nodes$id %in% ped$id, ]
    expect_gt(nrow(others), 0L)
    expect_identical(unique(others$carrier), FALSE, info = edgeStyle)
    without <- makePedigreeMatingLayout(.carrierPed(), edgeStyle = edgeStyle)
    expect_false("carrier" %in% names(without$nodes), info = edgeStyle)
  }
})

test_that(
  "every repeat appearance of a carrier is marked and has its hover line,
   and the mating-union and routing nodes are not", {
  ped <- .carrierLoopPed(carrier = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE,
                                     NA, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    dupIds <- names(result$duplicateToReal)[result$duplicateToReal == "8LKBV9"]
    expect_gte(length(dupIds), 1L)
    expect_identical(.carrierOf(result, c("8LKBV9", dupIds)),
                     rep(TRUE, 1L + length(dupIds)), info = edgeStyle)
    expect_true(all(grepl("<b>Carrier:</b> Yes",
                          .carrierTitleOf(result, c("8LKBV9", dupIds)),
                          fixed = TRUE)), info = edgeStyle)
    expect_identical(.carrierOf(result, ped$id),
                     c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE),
                     info = edgeStyle)
    others <- result$nodes[!(result$nodes$id %in%
                               c(ped$id, names(result$duplicateToReal))), ]
    expect_true(any(startsWith(others$id, "__union_")), info = edgeStyle)
    expect_identical(unique(others$carrier), FALSE, info = edgeStyle)
  }
})

test_that(
  "the hover text says Carrier: Yes, No or Unknown, after the conditions and
   the genotyped line and before the name, and nothing without the column", {
  ped <- .carrierPed(affected = c(TRUE, FALSE, NA, FALSE),
                     genotyped = c(TRUE, FALSE, NA, TRUE),
                     carrier = c(FALSE, TRUE, NA, TRUE),
                     name = c("Ace", "Bea", "Cy", "Di"))
  result <- makePedigreeMatingLayout(ped)
  titles <- .carrierTitleOf(result, ped$id)
  shown <- c("No", "Yes", "Unknown", "Yes")
  for (i in seq_along(titles)) {
    line <- paste0("<br><b>Carrier:</b> ", shown[[i]])
    at <- regexpr(line, titles[[i]], fixed = TRUE)
    expect_gt(at, regexpr("<b>Affected:</b>", titles[[i]], fixed = TRUE),
              label = ped$id[[i]])
    expect_gt(at, regexpr("<b>Genotyped:</b>", titles[[i]], fixed = TRUE),
              label = ped$id[[i]])
    expect_lt(at, regexpr("<b>Name:</b>", titles[[i]], fixed = TRUE),
              label = ped$id[[i]])
  }
  ped$carrier <- NULL
  without <- makePedigreeMatingLayout(ped)
  expect_false(any(grepl("Carrier", without$nodes$title, fixed = TRUE)))
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
  base <- makePedigreeMatingLayout(.carrierPed(carrier = forms$logical))
  for (form in names(forms)) {
    result <- makePedigreeMatingLayout(.carrierPed(carrier = forms[[form]]))
    expect_identical(.carrierOf(result, c("A", "B", "C", "D")), want,
                     info = form)
    expect_identical(result$nodes$title, base$nodes$title, info = form)
  }
})

test_that(
  "a carrier column holding anything else stops, naming the column and up to
   five values, before any animal is left out", {
  stopsWith <- function(values, shown) {
    expect_error(
      makePedigreeMatingLayout(.carrierPed(carrier = values)),
      paste0("makePedigreeMatingLayout(): the column 'carrier' holds ",
             "values other than TRUE, FALSE and NA (", shown, "). Give TRUE ",
             "or FALSE (or 1 or 0) for each animal, NA where it is not ",
             "recorded."),
      fixed = TRUE
    )
  }
  stopsWith(c(2.0, 1.0, 0.0, 0.5), "2, 0.5")
  stopsWith(c(1.0, Inf, 0.0, NA), "Inf")
  stopsWith(c("yes", "no", "TRUE", ""), "'yes', 'no', ''")
  stopsWith(factor(c("Y", "N", "Y", "TRUE")), "'Y', 'N'")
  stopsWith(as.Date(c("2026-01-01", NA, NA, NA)), "a column of class Date")
  ## Six odd values over seven animals: five shown, then "...".
  ped <- data.frame(id = LETTERS[1:7], sire = c(NA, NA, rep("A", 5L)),
                    dam = c(NA, NA, rep("B", 5L)),
                    sex = c("M", "F", "M", "F", "M", "F", "M"),
                    gen = c(0L, 0L, rep(1L, 5L)),
                    carrier = c(2, 3, 4, 5, 6, 7, 1),
                    stringsAsFactors = FALSE)
  expect_error(makePedigreeMatingLayout(ped), "(2, 3, 4, 5, 6, ...)",
               fixed = TRUE)
  ## E has no parent, mate or offspring, so the layout leaves it out; its
  ## value still stops the layout.
  ped <- .carrierPed(carrier = c(TRUE, FALSE, TRUE, FALSE))
  ped <- rbind(ped, data.frame(id = "E", sire = NA, dam = NA, sex = "M",
                               gen = 0L, carrier = "maybe"))
  expect_error(suppressMessages(makePedigreeMatingLayout(ped)),
               paste0("the column 'carrier' holds values other than TRUE, ",
                      "FALSE and NA ('maybe')"),
               fixed = TRUE)
})

test_that(
  "with every animal left out the layout's empty nodes gain an empty carrier
   field only when the pedigree has the column", {
  ped <- data.frame(id = c("A", "B"), sire = NA, dam = NA, sex = c("M", "F"),
                    gen = 0L, stringsAsFactors = FALSE)
  without <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_false("carrier" %in% names(without$nodes))
  ped$carrier <- c(TRUE, FALSE)
  result <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(nrow(result$nodes), 0L)
  expect_identical(result$nodes$carrier, logical())
})

test_that(
  "on seeded random pedigrees the column adds the carrier field and the hover
   line and changes nothing else", {
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
      list(ped = ped, marked = sample(c(TRUE, FALSE, NA), nrow(ped),
                                      replace = TRUE))
    })
    ped <- case$ped
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    without <- quietLayout(ped)
    ped$carrier <- case$marked
    with <- quietLayout(ped)
    label <- paste("seed", seed)
    drawn <- with$nodes$id %in% ped$id
    want <- case$marked[match(with$nodes$id[drawn], ped$id)] %in% TRUE
    expect_identical(with$nodes$carrier[drawn], want, label = label)
    keep <- setdiff(names(without$nodes), "title")
    expect_identical(with$nodes[keep], without$nodes[keep], label = label)
    expect_identical(sub("<br><b>Carrier:</b> [A-Za-z]+", "",
                         with$nodes$title),
                     without$nodes$title, label = label)
    expect_identical(with[names(with) != "nodes"],
                     without[names(without) != "nodes"], label = label)
    compared <- compared + 1L
  }
  expect_identical(compared, 40L)
})

test_that(
  "the dot is painted by a handler run after the deceased slash, its radius
   .carrierDotRatio of each node's size, only when some node is a carrier's", {
  handler <- .carrierDotHandler()
  expect_match(handler, "var ratio = 0.24;", fixed = TRUE)
  expect_match(handler, "n.carrier === true", fixed = TRUE)
  expect_match(handler, "(n.size || 25) * ratio", fixed = TRUE)
  expect_false(grepl("\"", handler, fixed = TRUE))
  for (sections in c(FALSE, TRUE)) {
    chained <- .diagramAfterDrawing(sections, .conditionColors, TRUE)
    slashAt <- regexpr(.deceasedSlashHandler(), chained, fixed = TRUE)
    dotAt <- regexpr(handler, chained, fixed = TRUE)
    expect_gt(slashAt, 0L, label = paste("sections", sections))
    expect_gt(dotAt, slashAt, label = paste("sections", sections))
    expect_identical(grepl("affectedSections", chained, fixed = TRUE),
                     sections)
  }
  expect_identical(.diagramAfterDrawing(FALSE, carrier = FALSE),
                   .deceasedSlashHandler())
  expect_false(grepl("n.carrier", .diagramAfterDrawing(TRUE), fixed = TRUE))
})

test_that("the legend's picture is the Deceased row's circle with a black dot of radius 5.3", {
  svg <- utils::URLdecode(sub("data:image/svg+xml;charset=utf-8,", "",
                              .carrierLegendImage(), fixed = TRUE))
  expect_identical(svg, paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    "<circle cx='25' cy='25' r='22' fill='white' stroke='#2B7CE9' ",
    "stroke-width='2'/><circle cx='25' cy='25' r='5.3' fill='black'/></svg>"
  ))
})

test_that(
  "drawPedigreeDiagram adds a Carrier row, a picture of a circle with the dot,
   before Deceased, the handler and 45 px, when any animal is a carrier", {
  skip_if_not_installed("visNetwork")
  rowsOf <- function(w) w$x$legend$nodes
  sexRows <- c("Female", "Male", "Hermaphrodite", "Unknown",
               "Other / Unrecorded")
  one <- drawPedigreeDiagram(makePedigreeMatingLayout(
    .carrierPed(affected = c(TRUE, FALSE, FALSE, TRUE),
                carrier = c(TRUE, FALSE, NA, TRUE))
  ))
  rows <- rowsOf(one)
  expect_identical(rows$label,
                   c(sexRows, "Affected", "Carrier", "Deceased"))
  expect_identical(rows$shape[rows$label == "Carrier"], "image")
  expect_identical(rows$image[rows$label == "Carrier"],
                   .carrierLegendImage())
  expect_identical(one$height, "545px")
  expect_identical(as.character(one$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE, carrier = TRUE))
  ## Three conditions, an unknown status and a genotyped animal: the row
  ## after the Genotyped one.
  three <- drawPedigreeDiagram(makePedigreeMatingLayout(
    .carrierPed(affected = c(TRUE, FALSE, NA, TRUE),
                affected2 = c(FALSE, TRUE, TRUE, FALSE),
                affected3 = c(TRUE, TRUE, FALSE, FALSE),
                genotyped = c(FALSE, TRUE, FALSE, FALSE),
                carrier = c(FALSE, FALSE, TRUE, FALSE))
  ))
  rows <- rowsOf(three)
  expect_identical(rows$label,
                   c(sexRows, "Affected", "Affected 2", "Affected 3",
                     "Affected status unknown", "Genotyped", "Carrier",
                     "Deceased"))
  expect_identical(rows$borderWidth[rows$label == "Carrier"], 1L)
  expect_identical(three$height, "725px")
  expect_match(as.character(three$x$events$afterDrawing),
               "n.carrier === true", fixed = TRUE)
})

test_that(
  "with no carrier the drawing has no Carrier row, no dot handler and its
   height; without the column the drawing is as before", {
  skip_if_not_installed("visNetwork")
  base <- drawPedigreeDiagram(makePedigreeMatingLayout(.carrierPed()))
  for (values in list(c(FALSE, FALSE, NA, FALSE), c(NA, NA, NA, NA))) {
    w <- drawPedigreeDiagram(makePedigreeMatingLayout(
      .carrierPed(carrier = values)
    ))
    expect_identical(w$x$legend, base$x$legend)
    expect_identical(w$height, "500px")
    expect_identical(w$x$events, base$x$events)
    expect_identical(unique(w$x$nodes$carrier), FALSE)
  }
  expect_false("Carrier" %in% base$x$legend$nodes$label)
  expect_identical(as.character(base$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE))
})

test_that("in a browser, vis.js draws each carrier's dot and the legend row's", {
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

  ## A is a deceased carrier (white, the slash through it), B a carrier
  ## filled pink, C unknown, D filled pink and not a carrier.
  layout <- makePedigreeMatingLayout(.carrierPed(
    affected = c(FALSE, TRUE, FALSE, TRUE),
    status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
    carrier = c(TRUE, TRUE, NA, FALSE)
  ))
  widget <- drawPedigreeDiagram(layout)
  widget$width <- "500px"
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  expect_true(.waitForLegendPictures(session))
  ## Each animal's colour 0.18 of its size left of its centre, inside the
  ## dot's 0.24 and off the slash, which runs on the diagonal, and 0.32 left,
  ## outside the dot. The legend's Carrier row is read at its centre (the
  ## picture's dot) and 0.6 of its size left of it (the white circle); then
  ## whether its label ends inside the canvas.
  js <- .pixelReaderJs(paste0(
    "const out = []; ['A', 'B', 'C', 'D'].forEach(id => { ",
    "const p = net.getPosition(id); const s = net.body.nodes[id].options.size; ",
    "out.push(read(net, p.x - 0.18 * s, p.y)); ",
    "out.push(read(net, p.x - 0.32 * s, p.y)); }); ",
    "const id = L.body.nodeIndices.find(i => ",
    "L.body.nodes[i].options.label === 'Carrier'); ",
    "if (id === undefined) { out.push('none', 'none', 'none'); } else { ",
    "const n = L.body.nodes[id]; out.push(read(L, n.x, n.y)); ",
    "out.push(read(L, n.x - 0.6 * n.options.size, n.y)); ",
    "const s = n.labelModule.size; ",
    "out.push(String(L.canvasToDOM({x: s.left + s.width, y: s.top}).x <= ",
    "L.canvas.frame.canvas.clientWidth)); } ",
    "return out.join('|');"
  ))
  got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                  fixed = TRUE)[[1L]]
  expect_length(got, 11L)
  rgbOf <- function(x) {
    suppressWarnings(as.integer(strsplit(x, ",", fixed = TRUE)[[1L]]))
  }
  near <- function(x, colour) {
    max(abs(rgbOf(x) - as.integer(grDevices::col2rgb(colour)))) <= 10L
  }
  want <- c("#000000", "#FFFFFF", "#000000", "#CC79A7", "#FFFFFF", "#FFFFFF",
            "#CC79A7", "#CC79A7", "#000000", "#FFFFFF")
  what <- c("A inside", "A outside", "B inside", "B outside", "C inside",
            "C outside", "D inside", "D outside", "legend dot",
            "legend circle")
  for (i in seq_along(want)) {
    expect_true(near(got[[i]], want[[i]]), label = paste(what[[i]], got[[i]]))
  }
  expect_identical(got[[11L]], "true")
})
