## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S56, plan
## Phase G13, gap B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R133 and R136). Pedixplorer marks the proband, an affected family member
## who came to medical attention independent of the others, with an arrow
## from the lower left of its symbol and "P" beside it, and the consultand,
## who seeks genetic counselling or testing, with the arrow alone; it reads
## NA as FALSE and refuses an animal marked both. pedkindraw ignored such
## columns. Mark's picks (S56): an arrow rising at 30 degrees to just outside
## the lower-left corner of the symbol's square (Pedixplorer's 45 degrees
## runs along the deceased slash), "P" left of a proband's tail; invisible
## points so an arrow at the drawing's left edge is not cut off; an animal
## marked both stops, as in Pedixplorer; a "Proband" and a "Consultand"
## legend row, each the arrow, before "Deceased", 45 px each. The columns
## `proband` and `consultand` are read as R134 reads `genotyped`; NA is drawn
## unmarked, its hover text "Proband: Unknown" or "Consultand: Unknown". The
## looks were measured in headless Chrome at 500 px before the picker, and
## every expected value here was computed on a prototype of the change first
## (Learning 18). nprcgenekeepr has no such mark; DIVERGENCE.md records it
## "at the switch" (R98).
library(testthat)

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's markings case. Each named argument adds
## a column.
.probandPed <- function(...) {
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
.probandFieldOf <- function(result, field, ids) {
  result$nodes[[field]][match(ids, result$nodes$id)]
}

## The loop pedigree of G2's tests: 8LKBV9 is drawn more than once.
.probandLoopPed <- function(...) {
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
  ".probandArrow puts the tip just outside the lower-left corner, rising at
   30 degrees; .probandArrowTail() is its tail", {
  expect_identical(.probandArrow, list(tipX = -1.1, tipY = 0.55, angle = 30,
                                       length = 0.96, head = 0.3))
  expect_equal(.probandArrowTail(),
               c(x = -1.1 - 0.96 * cos(pi / 6), y = 0.55 + 0.96 * 0.5),
               tolerance = 1e-12)
})

test_that(
  "makePedigreeMatingLayout marks a proband's and a consultand's node TRUE
   and every other node FALSE, in both edge styles; each field only with its
   column", {
  ped <- .probandPed(proband = c(FALSE, NA, TRUE, FALSE),
                     consultand = c(TRUE, FALSE, NA, FALSE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    expect_identical(.probandFieldOf(result, "proband", ped$id),
                     c(FALSE, FALSE, TRUE, FALSE), info = edgeStyle)
    expect_identical(.probandFieldOf(result, "consultand", ped$id),
                     c(TRUE, FALSE, FALSE, FALSE), info = edgeStyle)
    others <- result$nodes[!result$nodes$id %in% ped$id, ]
    expect_gt(nrow(others), 0L)
    expect_identical(unique(others$proband), FALSE, info = edgeStyle)
    expect_identical(unique(others$consultand), FALSE, info = edgeStyle)
    without <- makePedigreeMatingLayout(.probandPed(), edgeStyle = edgeStyle)
    expect_false(any(c("proband", "consultand") %in% names(without$nodes)),
                 info = edgeStyle)
    onlyProband <- makePedigreeMatingLayout(
      .probandPed(proband = c(TRUE, FALSE, FALSE, FALSE)),
      edgeStyle = edgeStyle
    )
    expect_true("proband" %in% names(onlyProband$nodes), info = edgeStyle)
    expect_false("consultand" %in% names(onlyProband$nodes), info = edgeStyle)
  }
})

test_that(
  "every repeat appearance of a proband is marked and has its hover line,
   and the mating-union and routing nodes are not", {
  ped <- .probandLoopPed(proband = c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE,
                                     NA, FALSE),
                         consultand = c(FALSE, FALSE, FALSE, FALSE, FALSE,
                                        FALSE, FALSE, TRUE))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    dupIds <- names(result$duplicateToReal)[result$duplicateToReal == "8LKBV9"]
    expect_gte(length(dupIds), 1L)
    expect_identical(.probandFieldOf(result, "proband", c("8LKBV9", dupIds)),
                     rep(TRUE, 1L + length(dupIds)), info = edgeStyle)
    expect_true(all(grepl("<b>Proband:</b> Yes",
                          .probandFieldOf(result, "title",
                                          c("8LKBV9", dupIds)),
                          fixed = TRUE)), info = edgeStyle)
    expect_identical(.probandFieldOf(result, "proband", ped$id),
                     c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE),
                     info = edgeStyle)
    expect_identical(.probandFieldOf(result, "consultand", ped$id),
                     c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE),
                     info = edgeStyle)
    others <- result$nodes[!(result$nodes$id %in%
                               c(ped$id, names(result$duplicateToReal))), ]
    expect_true(any(startsWith(others$id, "__union_")), info = edgeStyle)
    expect_identical(unique(others$proband), FALSE, info = edgeStyle)
    expect_identical(unique(others$consultand), FALSE, info = edgeStyle)
  }
})

test_that(
  "the hover text says Proband: and Consultand: Yes, No or Unknown, after the
   carrier line and before the name, and nothing without the columns", {
  ped <- .probandPed(affected = c(TRUE, FALSE, NA, FALSE),
                     carrier = c(FALSE, TRUE, NA, TRUE),
                     proband = c(FALSE, NA, TRUE, FALSE),
                     consultand = c(TRUE, FALSE, NA, FALSE),
                     name = c("Ace", "Bea", "Cy", "Di"))
  result <- makePedigreeMatingLayout(ped)
  titles <- .probandFieldOf(result, "title", ped$id)
  shownProband <- c("No", "Unknown", "Yes", "No")
  shownConsultand <- c("Yes", "No", "Unknown", "No")
  for (i in seq_along(titles)) {
    probandAt <- regexpr(paste0("<br><b>Proband:</b> ", shownProband[[i]]),
                         titles[[i]], fixed = TRUE)
    consultandAt <- regexpr(paste0("<br><b>Consultand:</b> ",
                                   shownConsultand[[i]]),
                            titles[[i]], fixed = TRUE)
    expect_gt(probandAt, regexpr("<b>Carrier:</b>", titles[[i]],
                                 fixed = TRUE), label = ped$id[[i]])
    expect_gt(consultandAt, probandAt, label = ped$id[[i]])
    expect_lt(consultandAt, regexpr("<b>Name:</b>", titles[[i]],
                                    fixed = TRUE), label = ped$id[[i]])
  }
  ped$proband <- NULL
  ped$consultand <- NULL
  without <- makePedigreeMatingLayout(ped)
  expect_false(any(grepl("Proband|Consultand", without$nodes$title)))
})

test_that(
  "each column reads TRUE and FALSE as logical values, as 1 and 0, and as text
   or a factor, NA and NaN as not recorded", {
  want <- c(TRUE, FALSE, FALSE, TRUE)
  forms <- list(
    logical = c(TRUE, FALSE, NA, TRUE),
    double = c(1.0, 0.0, NaN, 1.0),
    integer = c(1L, 0L, NA, 1L),
    text = c("TRUE", "false", NA, "T"),
    factor = factor(c("True", "F", NA, "TRUE"))
  )
  for (column in c("proband", "consultand")) {
    base <- makePedigreeMatingLayout(
      do.call(.probandPed, stats::setNames(list(forms$logical), column))
    )
    for (form in names(forms)) {
      result <- makePedigreeMatingLayout(
        do.call(.probandPed, stats::setNames(list(forms[[form]]), column))
      )
      expect_identical(.probandFieldOf(result, column, c("A", "B", "C", "D")),
                       want, info = paste(column, form))
      expect_identical(result$nodes$title, base$nodes$title,
                       info = paste(column, form))
    }
  }
})

test_that(
  "a proband or consultand column holding anything else stops, naming the
   column and its values", {
  for (column in c("proband", "consultand")) {
    expect_error(
      makePedigreeMatingLayout(do.call(.probandPed, stats::setNames(
        list(c(2.0, 1.0, 0.0, 0.5)), column
      ))),
      paste0("makePedigreeMatingLayout(): the column '", column, "' holds ",
             "values other than TRUE, FALSE and NA (2, 0.5). Give TRUE or ",
             "FALSE (or 1 or 0) for each animal, NA where it is not ",
             "recorded."),
      fixed = TRUE
    )
    expect_error(
      makePedigreeMatingLayout(do.call(.probandPed, stats::setNames(
        list(c("yes", "no", "TRUE", "")), column
      ))),
      paste0("the column '", column, "' holds values other than TRUE, ",
             "FALSE and NA ('yes', 'no', '')"),
      fixed = TRUE
    )
  }
})

test_that(
  "an animal marked both proband and consultand stops, naming up to five
   animals, before any animal is left out; NA is neither", {
  expect_error(
    makePedigreeMatingLayout(.probandPed(proband = c(TRUE, FALSE, TRUE, NA),
                                         consultand = c(TRUE, NA, TRUE,
                                                        TRUE))),
    paste0("makePedigreeMatingLayout(): the columns 'proband' and ",
           "'consultand' are both TRUE for A, C. Mark each animal as a ",
           "proband or as a consultand, not both."),
    fixed = TRUE
  )
  ## Six animals marked both over seven: five shown, then "...".
  ped <- data.frame(id = LETTERS[1:7], sire = c(NA, NA, rep("A", 5L)),
                    dam = c(NA, NA, rep("B", 5L)),
                    sex = c("M", "F", "M", "F", "M", "F", "M"),
                    gen = c(0L, 0L, rep(1L, 5L)),
                    proband = c(rep(TRUE, 6L), FALSE),
                    consultand = c(rep(TRUE, 6L), TRUE),
                    stringsAsFactors = FALSE)
  expect_error(makePedigreeMatingLayout(ped), "for A, B, C, D, E, ...",
               fixed = TRUE)
  ## E has no parent, mate or offspring, so the layout leaves it out; it
  ## still stops the layout.
  ped <- .probandPed(proband = c(TRUE, FALSE, FALSE, FALSE),
                     consultand = c(FALSE, FALSE, TRUE, FALSE))
  ped <- rbind(ped, data.frame(id = "E", sire = NA, dam = NA, sex = "M",
                               gen = 0L, proband = TRUE, consultand = TRUE))
  expect_error(suppressMessages(makePedigreeMatingLayout(ped)),
               "are both TRUE for E.", fixed = TRUE)
  ## NA beside TRUE is not both, and one column alone never stops.
  expect_no_error(makePedigreeMatingLayout(
    .probandPed(proband = c(TRUE, NA, NA, FALSE),
                consultand = c(NA, TRUE, NA, TRUE))
  ))
  expect_no_error(makePedigreeMatingLayout(
    .probandPed(proband = c(TRUE, TRUE, TRUE, TRUE))
  ))
})

test_that(
  "with every animal left out the layout's empty nodes gain empty proband
   and consultand fields only when the pedigree has the columns", {
  ped <- data.frame(id = c("A", "B"), sire = NA, dam = NA, sex = c("M", "F"),
                    gen = 0L, stringsAsFactors = FALSE)
  without <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_false(any(c("proband", "consultand") %in% names(without$nodes)))
  ped$proband <- c(TRUE, FALSE)
  ped$consultand <- c(FALSE, TRUE)
  result <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(nrow(result$nodes), 0L)
  expect_identical(result$nodes$proband, logical())
  expect_identical(result$nodes$consultand, logical())
})

test_that(
  "a real id starting __mark_, the prefix of the drawing's points, is
   refused", {
  ped <- .probandPed()
  for (column in c("id", "sire")) {
    ped[[column]][ped[[column]] %in% "A"] <- "__mark_A"
  }
  expect_error(makePedigreeMatingLayout(ped), "'__mark_' prefix",
               fixed = TRUE)
})

test_that(
  "on seeded random pedigrees the columns add the fields and the hover lines
   and change nothing else", {
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
      proband <- sample(c(TRUE, FALSE, NA), nrow(ped), replace = TRUE)
      consultand <- sample(c(TRUE, FALSE, NA), nrow(ped), replace = TRUE)
      consultand[proband %in% TRUE] <- FALSE
      list(ped = ped, proband = proband, consultand = consultand)
    })
    ped <- case$ped
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    without <- quietLayout(ped)
    ped$proband <- case$proband
    ped$consultand <- case$consultand
    with <- quietLayout(ped)
    label <- paste("seed", seed)
    drawn <- with$nodes$id %in% ped$id
    at <- match(with$nodes$id[drawn], ped$id)
    expect_identical(with$nodes$proband[drawn], case$proband[at] %in% TRUE,
                     label = label)
    expect_identical(with$nodes$consultand[drawn],
                     case$consultand[at] %in% TRUE, label = label)
    keep <- setdiff(names(without$nodes), "title")
    expect_identical(with$nodes[keep], without$nodes[keep], label = label)
    expect_identical(
      sub("<br><b>Proband:</b> [A-Za-z]+<br><b>Consultand:</b> [A-Za-z]+",
          "", with$nodes$title),
      without$nodes$title, label = label
    )
    expect_identical(with[names(with) != "nodes"],
                     without[names(without) != "nodes"], label = label)
    compared <- compared + 1L
  }
  expect_identical(compared, 40L)
})

test_that(
  "the arrows are drawn by a handler run after the carrier's dot and the
   deceased slash, only when some node is a proband's or a consultand's", {
  handler <- .probandArrowHandler()
  expect_match(handler, "n.proband === true || n.consultand === true",
               fixed = TRUE)
  expect_match(handler, "var a = 30 * Math.PI / 180;", fixed = TRUE)
  expect_match(handler, "var tx = p.x + s * -1.1, ty = p.y + s * 0.55;",
               fixed = TRUE)
  expect_match(handler, "var len = s * 0.96, h = s * 0.3;", fixed = TRUE)
  expect_match(handler,
               "if (n.proband === true) { ctx.fillText('P', sx - 2, sy); }",
               fixed = TRUE)
  expect_false(grepl("\"", handler, fixed = TRUE))
  for (sections in c(FALSE, TRUE)) {
    for (carrier in c(FALSE, TRUE)) {
      label <- paste("sections", sections, "carrier", carrier)
      chained <- .diagramAfterDrawing(sections, .conditionColors, carrier,
                                      TRUE)
      slashAt <- regexpr(.deceasedSlashHandler(), chained, fixed = TRUE)
      arrowAt <- regexpr(handler, chained, fixed = TRUE)
      expect_gt(slashAt, 0L, label = label)
      expect_gt(arrowAt, slashAt, label = label)
      if (carrier) {
        expect_gt(arrowAt, regexpr(.carrierDotHandler(), chained,
                                   fixed = TRUE), label = label)
      }
      expect_identical(grepl("affectedSections", chained, fixed = TRUE),
                       sections, label = label)
    }
  }
  expect_identical(.diagramAfterDrawing(FALSE, arrows = FALSE),
                   .deceasedSlashHandler())
  expect_false(grepl("n.proband", .diagramAfterDrawing(TRUE, carrier = TRUE),
                     fixed = TRUE))
})

test_that(
  ".probandArrowRoom adds one invisible point per marked node, 12 units left
   of its arrow's tail and level with it", {
  ped <- .probandPed(affected = c(TRUE, FALSE, FALSE, TRUE),
                     affected2 = c(FALSE, TRUE, FALSE, FALSE),
                     status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
                     genotyped = c(TRUE, FALSE, FALSE, FALSE),
                     carrier = c(TRUE, FALSE, FALSE, FALSE),
                     proband = c(FALSE, FALSE, TRUE, FALSE),
                     consultand = c(TRUE, FALSE, FALSE, FALSE))
  tail <- .probandArrowTail()
  for (edgeStyle in c("rectilinear", "direct")) {
    nodes <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)$nodes
    out <- .probandArrowRoom(nodes)
    expect_identical(nrow(out), nrow(nodes) + 2L, info = edgeStyle)
    expect_identical(out$id[seq_len(nrow(nodes))], nodes$id, info = edgeStyle)
    room <- out[-seq_len(nrow(nodes)), ]
    expect_identical(room$id, c("__mark_A", "__mark_C"), info = edgeStyle)
    owner <- nodes[match(c("A", "C"), nodes$id), ]
    expect_equal(room$x, owner$x + 25 * tail[["x"]] - 12, info = edgeStyle)
    expect_equal(room$y, owner$y + 25 * tail[["y"]], info = edgeStyle)
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
    for (field in c("deceased", "carrier", "proband", "consultand")) {
      expect_identical(unique(room[[field]]), FALSE,
                       info = paste(edgeStyle, field))
    }
    ## The nodes are kept; rbind() makes the direct style's integer y double.
    kept <- out[seq_len(nrow(nodes)), names(nodes)]
    rownames(kept) <- NULL
    expect_equal(kept, nodes, info = edgeStyle)
  }
  plain <- makePedigreeMatingLayout(
    .probandPed(proband = c(FALSE, NA, FALSE, FALSE)),
    edgeStyle = "direct"
  )$nodes
  expect_identical(.probandArrowRoom(plain), plain)
  expect_identical(.probandArrowRoom(makePedigreeMatingLayout(
    .probandPed()
  )$nodes), makePedigreeMatingLayout(.probandPed())$nodes)
})

test_that("the legend's pictures are the arrow, the proband's with P", {
  svgOf <- function(uri) {
    utils::URLdecode(sub("data:image/svg+xml;charset=utf-8,", "", uri,
                         fixed = TRUE))
  }
  expect_identical(svgOf(.probandLegendImage(TRUE)), paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    "<line x1='18.3' y1='34.0' x2='37.3' y2='23.0' stroke='black' ",
    "stroke-width='3'/>",
    "<polygon points='46.0,18.0 39.8,27.3 34.8,18.7' fill='black'/>",
    "<text x='16.3' y='34.0' font-family='arial' font-size='18' ",
    "text-anchor='end' dominant-baseline='middle'>P</text></svg>"
  ))
  expect_identical(svgOf(.probandLegendImage(FALSE)), paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    "<line x1='12.3' y1='34.0' x2='31.3' y2='23.0' stroke='black' ",
    "stroke-width='3'/>",
    "<polygon points='40.0,18.0 33.8,27.3 28.8,18.7' fill='black'/></svg>"
  ))
})

test_that(
  "drawPedigreeDiagram adds a Proband and a Consultand row before Deceased,
   45 px each, the handler and the points, each row when an animal is one", {
  skip_if_not_installed("visNetwork")
  rowsOf <- function(w) w$x$legend$nodes
  sexRows <- c("Female", "Male", "Hermaphrodite", "Unknown",
               "Other / Unrecorded")
  layout <- makePedigreeMatingLayout(
    .probandPed(proband = c(FALSE, NA, TRUE, FALSE),
                consultand = c(TRUE, FALSE, NA, FALSE))
  )
  both <- drawPedigreeDiagram(layout)
  rows <- rowsOf(both)
  expect_identical(rows$label, c(sexRows, "Affected", "Proband",
                                 "Consultand", "Deceased"))
  expect_identical(rows$shape[rows$label %in% c("Proband", "Consultand")],
                   c("image", "image"))
  expect_identical(rows$image[rows$label == "Proband"],
                   .probandLegendImage(TRUE))
  expect_identical(rows$image[rows$label == "Consultand"],
                   .probandLegendImage(FALSE))
  expect_identical(both$height, "590px")
  expect_identical(as.character(both$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE, arrows = TRUE))
  expect_identical(both$x$nodes, .probandArrowRoom(layout$nodes))
  expect_identical(both$x$idselection$values, c("A", "B", "C", "D"))
  ## A proband alone: its row only.
  onlyProband <- drawPedigreeDiagram(makePedigreeMatingLayout(
    .probandPed(proband = c(FALSE, FALSE, TRUE, FALSE))
  ))
  expect_identical(rowsOf(onlyProband)$label,
                   c(sexRows, "Affected", "Proband", "Deceased"))
  expect_identical(onlyProband$height, "545px")
  ## Every row: three conditions, an unknown status, a genotyped animal and a
  ## carrier, the arrows' rows after Carrier.
  every <- drawPedigreeDiagram(makePedigreeMatingLayout(
    .probandPed(affected = c(TRUE, FALSE, NA, TRUE),
                affected2 = c(FALSE, TRUE, TRUE, FALSE),
                affected3 = c(TRUE, TRUE, FALSE, FALSE),
                genotyped = c(FALSE, TRUE, FALSE, FALSE),
                carrier = c(FALSE, FALSE, TRUE, FALSE),
                proband = c(FALSE, FALSE, FALSE, TRUE),
                consultand = c(TRUE, FALSE, FALSE, FALSE))
  ))
  rows <- rowsOf(every)
  expect_identical(rows$label,
                   c(sexRows, "Affected", "Affected 2", "Affected 3",
                     "Affected status unknown", "Genotyped", "Carrier",
                     "Proband", "Consultand", "Deceased"))
  expect_identical(rows$borderWidth[rows$label %in% c("Proband",
                                                      "Consultand")],
                   c(1L, 1L))
  expect_identical(every$height, "815px")
  afterDrawing <- as.character(every$x$events$afterDrawing)
  expect_match(afterDrawing, "n.carrier === true", fixed = TRUE)
  expect_match(afterDrawing, "n.proband === true", fixed = TRUE)
})

test_that(
  "with no proband or consultand the drawing has no row, handler, point or
   height for them; without the columns the drawing is as before", {
  skip_if_not_installed("visNetwork")
  base <- drawPedigreeDiagram(makePedigreeMatingLayout(.probandPed()))
  for (values in list(c(FALSE, FALSE, NA, FALSE), c(NA, NA, NA, NA))) {
    layout <- makePedigreeMatingLayout(
      .probandPed(proband = values, consultand = rev(values))
    )
    w <- drawPedigreeDiagram(layout)
    expect_identical(w$x$legend, base$x$legend)
    expect_identical(w$height, "500px")
    expect_identical(w$x$events, base$x$events)
    expect_identical(w$x$nodes, layout$nodes)
    expect_identical(unique(w$x$nodes$proband), FALSE)
    expect_identical(unique(w$x$nodes$consultand), FALSE)
  }
  expect_false(any(c("Proband", "Consultand") %in%
                     base$x$legend$nodes$label))
  expect_identical(as.character(base$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE))
})

test_that(
  "in a browser, vis.js draws each arrow, the P, and the legend rows' arrows,
   and an arrow at the left edge stays inside the canvas", {
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

  ## Six animals, as measured before the picker: A (a deceased proband) and B
  ## (an affected consultand, its mating line coming from the left) are the
  ## parents of C (a proband, the leftmost animal), D (a deceased proband), E
  ## (unknown sex, a consultand) and F (neither).
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E", "F"),
    sire = c(NA, NA, "A", "A", "A", "A"),
    dam = c(NA, NA, "B", "B", "B", "B"),
    sex = c("M", "F", "M", "F", "U", "H"),
    gen = c(0L, 0L, 1L, 1L, 1L, 1L),
    status = c("DECEASED", "ALIVE", "ALIVE", "DECEASED", "ALIVE", "ALIVE"),
    affected = c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE),
    proband = c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE),
    consultand = c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE),
    stringsAsFactors = FALSE
  )
  widget <- drawPedigreeDiagram(makePedigreeMatingLayout(ped))
  widget$width <- "500px"
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  expect_true(.waitForLegendPictures(session))
  ## For each animal: the number of near-black pixels (not the blue lines;
  ## the alpha counted, as read() does not, dragon 39) in a 4-unit box at the
  ## middle of its arrow's shaft, and in the box where a proband's P is drawn
  ## (12 by 14 units, right-aligned 2 units left of the tail); and the canvas
  ## x, in
  ## CSS pixels, of that box's left side. Then, for each legend row, its
  ## picture's dark pixels and whether its label ends inside the canvas.
  tail <- .probandArrowTail()
  tip <- c(.probandArrow$tipX, .probandArrow$tipY)
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
    "const tx = p.x + s * %s, ty = p.y + s * %s, sx = p.x + s * %s, sy = p.y + s * %s; ",
    "const mx = (tx + sx) / 2, my = (ty + sy) / 2; ",
    "out.push(String(dark(mx - 2, my - 2, mx + 2, my + 2))); ",
    "out.push(String(dark(sx - 14, sy - 7, sx - 2, sy + 7))); ",
    "out.push(net.canvasToDOM({x: sx - 14, y: sy}).x.toFixed(1)); }); ",
    "['Proband', 'Consultand'].forEach(label => { ",
    "const id = L.body.nodeIndices.find(i => L.body.nodes[i].options.label === label); ",
    "if (id === undefined) { out.push('none', 'none'); return; } ",
    "const n = L.body.nodes[id]; const s = n.options.size; ",
    "const a = L.canvasToDOM({x: n.x - s, y: n.y - s}), b = L.canvasToDOM({x: n.x + s, y: n.y + s}); ",
    "const lc = L.canvas.frame.canvas; const lr = lc.width / lc.clientWidth; ",
    "const d = lc.getContext('2d').getImageData(Math.round(a.x * lr), Math.round(a.y * lr), ",
    "Math.round((b.x - a.x) * lr), Math.round((b.y - a.y) * lr)).data; ",
    "let k = 0; for (let i = 0; i < d.length; i += 4) { const al = d[i + 3] / 255; ",
    "if ((0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2]) * al + 255 * (1 - al) < 128) k++; } ",
    "out.push(String(k)); const t = n.labelModule.size; ",
    "out.push(String(L.canvasToDOM({x: t.left + t.width, y: t.top}).x <= lc.clientWidth)); }); ",
    "return out.join('|');"
  ), tip[[1L]], tip[[2L]], tail[["x"]], tail[["y"]]))
  got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                  fixed = TRUE)[[1L]]
  expect_length(got, 22L)
  ids <- c("A", "B", "C", "D", "E", "F")
  shaft <- as.integer(got[seq(1L, 18L, by = 3L)])
  pDark <- as.integer(got[seq(2L, 18L, by = 3L)])
  pLeft <- as.numeric(got[seq(3L, 18L, by = 3L)])
  marked <- ped$proband | ped$consultand
  for (i in seq_along(ids)) {
    if (marked[[i]]) {
      expect_gt(shaft[[i]], 0L, label = paste(ids[[i]], "shaft"))
    } else {
      expect_identical(shaft[[i]], 0L, label = paste(ids[[i]], "no shaft"))
    }
    if (ped$proband[[i]]) {
      expect_gt(pDark[[i]], 0L, label = paste(ids[[i]], "P"))
    } else {
      expect_identical(pDark[[i]], 0L, label = paste(ids[[i]], "no P"))
    }
  }
  ## C is the leftmost animal: its P stays inside the canvas.
  expect_gte(pLeft[[3L]], 0.0)
  expect_gt(as.integer(got[[19L]]), 0L)
  expect_identical(got[[20L]], "true")
  expect_gt(as.integer(got[[21L]]), 0L)
  expect_identical(got[[22L]], "true")
})
