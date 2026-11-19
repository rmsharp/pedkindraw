## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S54, plan
## Phase G13, gap B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R133-R134). Pedixplorer marks an animal that is available (genotyped) by
## its symbol's border, green, black for unavailable and grey for unknown;
## pedkindraw ignored any such column. Mark's picks (S54): the column
## `genotyped` (pedkindraw's word, the argument of shrinkPedigree() and
## findUnrelated()); a genotyped animal's outline drawn 4 px wide, vis.js's
## own borderWidth, where every other symbol's is 1; TRUE, FALSE and NA, 1
## and 0, and the text as.logical() reads, anything else stopping; NA drawn
## unmarked, its hover text "Genotyped: Unknown"; a legend row "Genotyped", a
## square with the thick outline, before "Deceased", when any animal is
## genotyped, which makes the drawing 45 px taller. The looks were measured
## in headless Chrome at 500 px before the picker, and every expected value
## here was computed on a prototype of the change first (Learning 18).
## nprcgenekeepr has no such mark; DIVERGENCE.md records it "at the switch"
## (R98).
library(testthat)

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's markings case. Each named argument adds
## a column.
.g13Ped <- function(...) {
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

## The outline width of each of `ids`' own nodes in a layout.
.borderOf <- function(result, ids) {
  result$nodes[["borderWidth"]][match(ids, result$nodes$id)]
}

## The hover text of each of `ids`' own nodes in a layout.
.titleOf <- function(result, ids) {
  result$nodes$title[match(ids, result$nodes$id)]
}

## The loop pedigree of G2's tests: 8LKBV9 is drawn more than once.
.g13LoopPed <- function(...) {
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

test_that(".genotypedBorderWidth is 4, where vis.js draws an outline 1 wide", {
  expect_identical(.genotypedBorderWidth, 4L)
})

test_that(
  "makePedigreeMatingLayout gives a genotyped animal's node a 4 px outline
   and every other node 1 px, in both edge styles; without the column the
   nodes have no borderWidth", {
  ped <- .g13Ped(genotyped = c(TRUE, FALSE, NA, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    expect_identical(.borderOf(result, ped$id), c(4L, 1L, 1L, 4L),
                     info = edgeStyle)
    others <- result$nodes[!result$nodes$id %in% ped$id, ]
    expect_gt(nrow(others), 0L)
    expect_identical(unique(others$borderWidth), 1L, info = edgeStyle)
    without <- makePedigreeMatingLayout(.g13Ped(), edgeStyle = edgeStyle)
    expect_false("borderWidth" %in% names(without$nodes), info = edgeStyle)
  }
})

test_that(
  "every repeat appearance of a genotyped animal has its 4 px outline and its
   hover line, and the mating-union and routing nodes keep 1 px", {
  ped <- .g13LoopPed(genotyped = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE,
                                   NA, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    dupIds <- names(result$duplicateToReal)[result$duplicateToReal == "8LKBV9"]
    expect_gte(length(dupIds), 1L)
    expect_identical(.borderOf(result, c("8LKBV9", dupIds)),
                     rep(4L, 1L + length(dupIds)), info = edgeStyle)
    expect_true(all(grepl("<b>Genotyped:</b> Yes",
                          .titleOf(result, c("8LKBV9", dupIds)),
                          fixed = TRUE)), info = edgeStyle)
    expect_identical(.borderOf(result, ped$id),
                     c(1L, 1L, 1L, 1L, 4L, 1L, 1L, 4L), info = edgeStyle)
    others <- result$nodes[!(result$nodes$id %in%
                               c(ped$id, names(result$duplicateToReal))), ]
    expect_true(any(startsWith(others$id, "__union_")), info = edgeStyle)
    expect_identical(unique(others$borderWidth), 1L, info = edgeStyle)
  }
})

test_that(
  "the hover text says Genotyped: Yes, No or Unknown, after the conditions
   and before the name, and nothing without the column", {
  ped <- .g13Ped(affected = c(TRUE, FALSE, NA, FALSE),
                 genotyped = c(TRUE, FALSE, NA, TRUE),
                 name = c("Ace", "Bea", "Cy", "Di"))
  result <- makePedigreeMatingLayout(ped)
  titles <- .titleOf(result, ped$id)
  shown <- c("Yes", "No", "Unknown", "Yes")
  for (i in seq_along(titles)) {
    line <- paste0("<br><b>Genotyped:</b> ", shown[[i]])
    at <- regexpr(line, titles[[i]], fixed = TRUE)
    expect_gt(at, regexpr("<b>Affected:</b>", titles[[i]], fixed = TRUE),
              label = ped$id[[i]])
    expect_lt(at, regexpr("<b>Name:</b>", titles[[i]], fixed = TRUE),
              label = ped$id[[i]])
  }
  ped$genotyped <- NULL
  without <- makePedigreeMatingLayout(ped)
  expect_false(any(grepl("Genotyped", without$nodes$title, fixed = TRUE)))
})

test_that(
  "the column reads TRUE and FALSE as logical values, as 1 and 0, and as text
   or a factor, NA and NaN as not recorded", {
  want <- c(4L, 1L, 1L, 4L)
  forms <- list(
    logical = c(TRUE, FALSE, NA, TRUE),
    double = c(1.0, 0.0, NaN, 1.0),
    integer = c(1L, 0L, NA, 1L),
    text = c("TRUE", "false", NA, "T"),
    factor = factor(c("True", "F", NA, "TRUE"))
  )
  base <- makePedigreeMatingLayout(.g13Ped(genotyped = forms$logical))
  for (form in names(forms)) {
    result <- makePedigreeMatingLayout(.g13Ped(genotyped = forms[[form]]))
    expect_identical(.borderOf(result, c("A", "B", "C", "D")), want,
                     info = form)
    expect_identical(result$nodes$title, base$nodes$title, info = form)
  }
})

test_that(
  "a genotyped column holding anything else stops, naming the column and up
   to five values, before any animal is left out", {
  stopsWith <- function(values, shown) {
    expect_error(
      makePedigreeMatingLayout(.g13Ped(genotyped = values)),
      paste0("makePedigreeMatingLayout(): the column 'genotyped' holds ",
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
                    genotyped = c(2, 3, 4, 5, 6, 7, 1),
                    stringsAsFactors = FALSE)
  expect_error(makePedigreeMatingLayout(ped), "(2, 3, 4, 5, 6, ...)",
               fixed = TRUE)
  ## E has no parent, mate or offspring, so the layout leaves it out; its
  ## value still stops the layout.
  ped <- .g13Ped(genotyped = c(TRUE, FALSE, TRUE, FALSE))
  ped <- rbind(ped, data.frame(id = "E", sire = NA, dam = NA, sex = "M",
                               gen = 0L, genotyped = "maybe"))
  expect_error(suppressMessages(makePedigreeMatingLayout(ped)),
               "holds values other than TRUE, FALSE and NA ('maybe')",
               fixed = TRUE)
})

test_that(
  "with every animal left out the layout's empty nodes gain an empty
   borderWidth only when the pedigree has the column", {
  ped <- data.frame(id = c("A", "B"), sire = NA, dam = NA, sex = c("M", "F"),
                    gen = 0L, stringsAsFactors = FALSE)
  without <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_false("borderWidth" %in% names(without$nodes))
  ped$genotyped <- c(TRUE, FALSE)
  result <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(nrow(result$nodes), 0L)
  expect_identical(result$nodes$borderWidth, integer())
})

test_that(
  "on seeded random pedigrees the column adds the outline and the hover line
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
      list(ped = ped, typed = sample(c(TRUE, FALSE, NA), nrow(ped),
                                     replace = TRUE))
    })
    ped <- case$ped
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    without <- quietLayout(ped)
    ped$genotyped <- case$typed
    with <- quietLayout(ped)
    label <- paste("seed", seed)
    drawn <- with$nodes$id %in% ped$id
    want <- ifelse(case$typed[match(with$nodes$id[drawn], ped$id)] %in% TRUE,
                   4L, 1L)
    expect_identical(with$nodes$borderWidth[drawn], want, label = label)
    keep <- setdiff(names(without$nodes), "title")
    expect_identical(with$nodes[keep], without$nodes[keep], label = label)
    expect_identical(sub("<br><b>Genotyped:</b> [A-Za-z]+", "",
                         with$nodes$title),
                     without$nodes$title, label = label)
    expect_identical(with[names(with) != "nodes"],
                     without[names(without) != "nodes"], label = label)
    compared <- compared + 1L
  }
  expect_identical(compared, 40L)
})

test_that(
  "drawPedigreeDiagram adds a Genotyped row, a white square with the 4 px
   outline, before Deceased, and 45 px, when any animal is genotyped", {
  skip_if_not_installed("visNetwork")
  rowsOf <- function(w) w$x$legend$nodes
  one <- drawPedigreeDiagram(makePedigreeMatingLayout(
    .g13Ped(affected = c(TRUE, FALSE, FALSE, TRUE),
            genotyped = c(TRUE, FALSE, NA, TRUE))
  ))
  rows <- rowsOf(one)
  at <- match("Genotyped", rows$label)
  expect_identical(rows$label[(at - 1L):(at + 1L)],
                   c("Affected", "Genotyped", "Deceased"))
  expect_identical(rows$shape[[at]], "square")
  expect_identical(rows$color.background[[at]], "#FFFFFF")
  expect_identical(rows$borderWidth[[at]], 4L)
  expect_identical(unique(rows$borderWidth[-at]), 1L)
  expect_identical(one$height, "545px")
  ## Three conditions and an unknown status: the row after the unknown one.
  three <- drawPedigreeDiagram(makePedigreeMatingLayout(
    .g13Ped(affected = c(TRUE, FALSE, NA, TRUE),
            affected2 = c(FALSE, TRUE, TRUE, FALSE),
            affected3 = c(TRUE, TRUE, FALSE, FALSE),
            genotyped = c(FALSE, TRUE, FALSE, FALSE))
  ))
  rows <- rowsOf(three)
  at <- match("Genotyped", rows$label)
  expect_identical(rows$label[(at - 1L):(at + 1L)],
                   c("Affected status unknown", "Genotyped", "Deceased"))
  expect_identical(three$height, "680px")
})

test_that(
  "with no animal genotyped the drawing has no Genotyped row and no outline
   widths in the legend; without the column the legend is as before", {
  skip_if_not_installed("visNetwork")
  base <- drawPedigreeDiagram(makePedigreeMatingLayout(.g13Ped()))
  for (values in list(c(FALSE, FALSE, NA, FALSE), c(NA, NA, NA, NA))) {
    w <- drawPedigreeDiagram(makePedigreeMatingLayout(
      .g13Ped(genotyped = values)
    ))
    expect_identical(w$x$legend, base$x$legend)
    expect_identical(w$height, "500px")
    expect_identical(unique(w$x$nodes$borderWidth), 1L)
  }
  expect_false("borderWidth" %in% names(base$x$legend$nodes))
  expect_identical(base$height, "500px")
})

test_that("in a browser, vis.js draws each genotyped animal's outline and the legend row thick", {
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

  layout <- makePedigreeMatingLayout(
    .g13Ped(genotyped = c(TRUE, FALSE, NA, TRUE))
  )
  widget <- drawPedigreeDiagram(layout)
  widget$width <- "500px"
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  expect_true(.waitForLegendPictures(session))
  ## Each animal's colour 1.75 units outside its outline, on the side no line
  ## leaves (A's mating line leaves its right, B's its left): solid blue in a
  ## 4 px outline, nothing past a 1 px one (measured on the prototype). The
  ## legend is drawn at 0.70 of full size, where a 1 px outline is blurred
  ## over two pixels of faint blue, so its Genotyped and Male rows are read
  ## 1.5 units inside the outline: blue in the thick one, the white fill in
  ## the thin. Then whether the Genotyped label ends inside the canvas.
  js <- .pixelReaderJs(paste0(
    "const side = {A: -1, B: 1, C: -1, D: 1}; ",
    "const out = ['A', 'B', 'C', 'D'].map(id => { ",
    "const p = net.getPosition(id); const s = net.body.nodes[id].options.size; ",
    "return read(net, p.x + side[id] * (s + 1.75), p.y); }); ",
    "const row = label => L.body.nodes[L.body.nodeIndices.find(id => ",
    "L.body.nodes[id].options.label === label)]; ",
    "['Genotyped', 'Male'].forEach(label => { const n = row(label); ",
    "out.push(n ? read(L, n.x - n.options.size + 1.5, n.y) : 'none'); }); ",
    "const g = row('Genotyped'); const s = g.labelModule.size; ",
    "out.push(String(L.canvasToDOM({x: s.left + s.width, y: s.top}).x <= ",
    "L.canvas.frame.canvas.clientWidth)); ",
    "return out.join('|');"
  ))
  got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                  fixed = TRUE)[[1L]]
  expect_length(got, 7L)
  outline <- as.integer(grDevices::col2rgb("#2B7CE9"))
  thick <- c(TRUE, FALSE, FALSE, TRUE, TRUE, FALSE)
  what <- c("A", "B", "C", "D", "legend Genotyped", "legend Male")
  for (i in seq_along(thick)) {
    expect_false(identical(got[[i]], "none"), label = what[[i]])
    rgb <- suppressWarnings(as.integer(strsplit(got[[i]], ",",
                                                fixed = TRUE)[[1L]]))
    near <- max(abs(rgb - outline)) <= 10L
    expect_identical(near, thick[[i]], label = paste(what[[i]], got[[i]]))
  }
  expect_identical(got[[7L]], "true")
})
