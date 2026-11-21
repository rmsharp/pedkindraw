## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S65, plan
## Phase G15a, gap B1 (mates with no offspring) of
## docs/research/pedkindraw-gaps-2026-11-18.md; ruling R141;
## docs/planning/mates-without-offspring-plan.md section 7). The layout built
## every mating from offspring sharing a sire and a dam, so two animals mated
## with no offspring together were left out of the drawing (isolatedIds) or
## drawn with no sign of their mating; kinship2 (relation code 4) and
## Pedixplorer ("Spouse") draw them joined. R141 (S64): a matings table, a
## data frame of sire and dam, given to makePedigreeMatingLayout(matings = ),
## each row a mating drawn whether or not the two have offspring together.
## Mark's picks (S65): an animal with several matings is drawn at each, as
## pedkindraw draws two matings with offspring today (kinship2 draws it once,
## between its mates); a row naming an animal not in ped is left out with a
## message (a trimming function removes a declared partner in 190 of 200
## random rows); a pair named twice, in either column, is drawn once; any
## sexes are accepted, as kinship2 and Pedixplorer accept them; the mating
## point is drawn as every other, its hover "0 offspring". Every expected
## value here computed on a prototype of the change first (Learning 18), the
## typed shapes' rows drawn in headless Chrome at 500 pixels first. The
## stops are the plan's section 5. nprcgenekeepr has no such argument;
## DIVERGENCE.md records it "at the switch" (R98).
library(testthat)

test_that("matings is the layout's last argument, NULL by default", {
  args <- formals(makePedigreeMatingLayout)
  expect_identical(names(args)[[length(args)]], "matings")
  expect_null(args$matings)
})

test_that(
  "the gap case: E and F, mated with no offspring, are drawn as a mating
   and not left out, in both edge styles", {
  shape <- .matesShapes()$matesNoOffspring
  ## Without matings E and F are left out, with the message.
  expect_message(
    before <- makePedigreeMatingLayout(shape$ped, edgeStyle = "direct"),
    "2 individual\\(s\\) with no recorded parents, mates, or offspring"
  )
  expect_identical(before$isolatedIds, c("E", "F"))
  direct <- NULL
  for (edgeStyle in c("direct", "rectilinear")) {
    expect_no_message(
      layout <- makePedigreeMatingLayout(shape$ped, edgeStyle = edgeStyle,
                                         matings = shape$matings)
    )
    if (edgeStyle == "direct") direct <- layout
    expect_identical(layout$isolatedIds, character(0L))
    expect_identical(.matesRows(layout), c("A B E F", "C D"))
    expect_identical(.matesCheck(layout, direct, shape$matings), "ok")
    ## A and B's point keeps its number; E and F's comes after it, and its
    ## hover reads as every point's does.
    points <- layout$nodes[grepl("^__union_[0-9]+$", layout$nodes$id), ]
    expect_identical(points$id, c("__union_1", "__union_2"))
    expect_identical(points$title, c("2 offspring", "0 offspring"))
    expect_identical(points$size, c(6L, 6L))
  }
})

test_that(
  "each typed shape draws its declared matings, an animal with several
   matings drawn at each, any sexes accepted", {
  want <- list(
    matesNoOffspring = c("A B E F", "C D"),
    onlyTwo = "E F",
    marryIn = c("A B", "C E D"),
    secondMate = c("A B A' G", "C D"),
    twoChildless = "A B A' G",
    sibMates = c("A B", "C D' D"),
    bothHaveParents = c("A B H I", "C J' D J"),
    crossGen = c("A B", "C H D", "E K"),
    childlessPlusKids = c("A B", "H C E D", "K"),
    sameSex = c("A B E F", "C D"),
    unknownSex = c("A B E F", "C D"),
    femaleFirst = c("A B E F", "C D")
  )
  shapes <- .matesShapes()
  expect_setequal(names(shapes), names(want))
  for (nm in names(shapes)) {
    shape <- shapes[[nm]]
    direct <- .matesLayout(shape$ped, shape$matings)
    rect <- .matesLayout(shape$ped, shape$matings, "rectilinear")
    for (layout in list(direct, rect)) {
      expect_identical(.matesRows(layout), want[[nm]], info = nm)
      expect_identical(.matesCheck(layout, direct, shape$matings),
                       rep("ok", nrow(shape$matings)), info = nm)
      expect_false(any(c(shape$matings$sire, shape$matings$dam) %in%
                         layout$isolatedIds), info = nm)
    }
  }
})

test_that(
  "an animal whose one mating with offspring is beside a declared one is
   drawn (a mating with no offspring has no side of its offspring)", {
  ## secondMate: A has C and D by B, and is declared mated with G. G anchors
  ## the declared mating, whose side cannot come from its offspring.
  shape <- .matesShapes()$secondMate
  for (edgeStyle in c("direct", "rectilinear")) {
    layout <- .matesLayout(shape$ped, shape$matings, edgeStyle)
    expect_true(all(is.finite(layout$nodes$x)), info = edgeStyle)
    expect_identical(unname(layout$duplicateToReal), "A", info = edgeStyle)
  }
})

test_that("a related pair declared mated gets the related parents' line", {
  ## sibMates: C and D are full siblings.
  shape <- .matesShapes()$sibMates
  layout <- .matesLayout(shape$ped, shape$matings)
  point <- layout$nodes$id[which(layout$nodes$title == "0 offspring")]
  lines <- layout$edges[layout$edges$to == point, ]
  expect_identical(nrow(lines), 2L)
  expect_identical(lines$color, c("#D55E00", "#D55E00"))
  expect_identical(lines$width, c(4, 4))
})

test_that(
  "NULL, a table with no rows, and a pair with offspring together give
   the layout of no matings", {
  b4 <- .matesPlus()
  gap <- .matesShapes()$matesNoOffspring$ped
  for (edgeStyle in c("direct", "rectilinear")) {
    for (ped in list(b4, gap)) {
      today <- .matesLayout(ped, NULL, edgeStyle)
      expect_identical(.matesLayout(ped, .matesTable(character(),
                                                     character()),
                                    edgeStyle), today)
      expect_identical(.matesLayout(ped, .matesTable("A", "B"), edgeStyle),
                       today)
      expect_identical(.matesLayout(ped, .matesTable("B", "A"), edgeStyle),
                       today)
    }
  }
})

test_that(
  "a pair named twice, in the same or swapped columns, is drawn once", {
  shape <- .matesShapes()$matesNoOffspring
  once <- .matesLayout(shape$ped, shape$matings)
  expect_identical(.matesLayout(shape$ped, .matesTable(c("E", "E"),
                                                       c("F", "F"))), once)
  expect_identical(.matesLayout(shape$ped, .matesTable(c("E", "F"),
                                                       c("F", "E"))), once)
  expect_identical(
    .matesLayout(shape$ped, .matesTable(c("E", "F", "E"), c("F", "E", "F")),
                 "rectilinear"),
    .matesLayout(shape$ped, shape$matings, "rectilinear")
  )
})

test_that(
  "sire and dam may be factors; other columns are ignored, so a table
   getMatings() returns can be passed with rows added", {
  shape <- .matesShapes()$matesNoOffspring
  once <- .matesLayout(shape$ped, shape$matings)
  asFactors <- data.frame(sire = factor("E"), dam = factor("F"))
  expect_identical(.matesLayout(shape$ped, asFactors), once)
  listed <- getMatings(shape$ped)
  listed <- rbind(listed, data.frame(sire = "E", dam = "F", offspring = 0L))
  expect_identical(.matesLayout(shape$ped, listed), once)
})

test_that(
  "a row naming an animal not in ped is left out, with a message naming
   the pair; the other rows are drawn", {
  shape <- .matesShapes()$matesNoOffspring
  once <- .matesLayout(shape$ped, shape$matings)
  expect_message(
    got <- makePedigreeMatingLayout(shape$ped, edgeStyle = "direct",
                                    matings = .matesTable(c("E", "C"),
                                                          c("F", "Z"))),
    paste0("makePedigreeMatingLayout\\(\\): 1 mating\\(s\\) in 'matings' ",
           "naming an animal not in 'ped' left out: C and Z")
  )
  expect_identical(got, once)
  ## Both absent, and a sire with no row of its own (a trimmed parent).
  dangling <- data.frame(id = c("B", "C", "E", "F"), sire = c(NA, "S", NA, NA),
                         dam = c(NA, "B", NA, NA), sex = c("F", "M", "M", "F"),
                         gen = c(0L, 1L, 0L, 0L), stringsAsFactors = FALSE)
  expect_message(
    got <- makePedigreeMatingLayout(dangling, matings = .matesTable(
      c("E", "S", "X"), c("F", "B", "Y")
    )),
    paste0("2 mating\\(s\\) in 'matings' naming an animal not in 'ped' ",
           "left out: S and B, X and Y")
  )
  expect_identical(got, .matesLayout(dangling, .matesTable("E", "F"),
                                     "rectilinear"))
  ## Every row left out: the layout of no matings, E and F left out too.
  expect_message(
    expect_message(
      none <- makePedigreeMatingLayout(shape$ped, edgeStyle = "direct",
                                       matings = .matesTable("E", "Q")),
      "naming an animal not in 'ped' left out: E and Q"
    ),
    "2 individual\\(s\\) with no recorded parents"
  )
  expect_identical(none, .matesLayout(shape$ped))
  ## After trimming: the matings of the animals kept are drawn.
  ped <- .matesPlus(c("E", "F", "G"), c(NA, NA, "A"), c(NA, NA, "B"),
                    c("M", "F", "F"))
  trimmed <- trimPedigree(ped, "C")
  expect_message(
    got <- makePedigreeMatingLayout(trimmed, matings = .matesTable(
      c("A", "E"), c("G", "F")
    )),
    "left out: A and G, E and F"
  )
  expect_identical(got, .matesLayout(trimmed, NULL, "rectilinear"))
})

test_that("stops on a matings table it cannot read", {
  ped <- .matesShapes()$matesNoOffspring$ped
  lay <- function(m) makePedigreeMatingLayout(ped, matings = m)
  notFrame <- paste0("requires 'matings' to be NULL or a data frame with ",
                     "the columns sire and dam")
  expect_error(lay(list(sire = "E", dam = "F")), notFrame)
  expect_error(lay(cbind(sire = "E", dam = "F")), notFrame)
  expect_error(lay("E"), notFrame)
  expect_error(lay(data.frame(sire = "E")),
               paste0("requires 'matings' to have the columns sire and dam. ",
                      "Missing: dam"))
  expect_error(lay(data.frame(id = "E")), "Missing: sire, dam")
  expect_error(lay(data.frame()), "Missing: sire, dam")
  expect_error(lay(.matesTable("E", NA)),
               "found NA in 'matings' columns sire and dam")
  expect_error(lay(.matesTable(NA, "F")),
               "found NA in 'matings' columns sire and dam")
  expect_error(lay(.matesTable(c("E", "F"), c("E", "F"))),
               "found the same id as sire and dam in 'matings': E, F")
  ## The matings are checked before the hints.
  expect_error(
    makePedigreeMatingLayout(ped, matings = "E", hints = "bogus"),
    notFrame
  )
})

test_that(
  "a mate hint may place a declared mating; one naming a pair with no
   offspring that matings does not declare still stops", {
  shape <- .matesShapes()$matesNoOffspring
  hints <- list(mate = data.frame(left = "F", right = "E",
                                  anchor = "either"))
  layout <- .matesLayout(shape$ped, shape$matings, hints = hints)
  expect_identical(.matesRows(layout), c("A B F E", "C D"))
  expect_identical(.matesCheck(layout, layout, shape$matings), "ok")
  expect_error(
    makePedigreeMatingLayout(shape$ped, hints = hints),
    paste0("no offspring together in 'ped': F and E. A mating with no ",
           "offspring is declared in 'matings'.")
  )
})

test_that(
  "the hints a layout returns, passed back with the same matings, give the
   same layout", {
  shapes <- .matesShapes()
  for (nm in c("matesNoOffspring", "secondMate", "twoChildless", "sibMates",
               "crossGen", "childlessPlusKids")) {
    shape <- shapes[[nm]]
    for (edgeStyle in c("direct", "rectilinear")) {
      layout <- .matesLayout(shape$ped, shape$matings, edgeStyle)
      again <- .matesLayout(shape$ped, shape$matings, edgeStyle,
                            hints = layout$hints)
      expect_identical(again, layout, info = paste(nm, edgeStyle))
    }
  }
  ## The returned hints name the declared mating as drawn.
  shape <- shapes$matesNoOffspring
  layout <- .matesLayout(shape$ped, shape$matings)
  expect_identical(layout$hints$mate,
                   data.frame(left = c("A", "E"), right = c("B", "F"),
                              anchor = c("left", "left")))
})

test_that(
  "random pedigrees: each declared mating drawn as a mating in both edge
   styles, the offspring matings' points keeping their numbers", {
  skip_on_cran()
  nPedigrees <- 0L
  nMatings <- 0L
  seed <- 0L
  while (nPedigrees < 100L) {
    seed <- seed + 1L
    ped <- layoutHintsFamilies(seed)
    if (nrow(ped) > 300L) next
    matings <- .matesPick(ped, seed, 1L + seed %% 3L)
    if (nrow(matings) == 0L) next
    nPedigrees <- nPedigrees + 1L
    nMatings <- nMatings + nrow(matings)
    direct <- .matesLayout(ped, matings)
    rect <- .matesLayout(ped, matings, "rectilinear")
    for (layout in list(direct, rect)) {
      expect_identical(.matesCheck(layout, direct, matings),
                       rep("ok", nrow(matings)), info = seed)
      expect_false(any(c(matings$sire, matings$dam) %in% layout$isolatedIds),
                   info = seed)
      expect_true(all(is.finite(layout$nodes$x)), info = seed)
    }
    today <- .matesLayout(ped)
    points <- today$nodes[grepl("^__union_", today$nodes$id), c("id", "title")]
    after <- direct$nodes[match(points$id, direct$nodes$id), c("id", "title")]
    rownames(points) <- NULL
    rownames(after) <- NULL
    expect_identical(after, points, info = seed)
    added <- setdiff(direct$nodes$id[grepl("^__union_", direct$nodes$id)],
                     points$id)
    expect_identical(length(added), nrow(matings), info = seed)
  }
  expect_gte(nPedigrees, 100L)
  expect_gte(nMatings, 200L)
})

test_that(
  "in a browser, a declared mating is drawn as two mates on one row with the
   point between them and no line down from it, in both edge styles", {
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

  ## The point's place and E's and F's, as vis.js draws them, and the far
  ## end of each line vis.js draws at the point; as text, "|"-separated.
  shape <- .matesShapes()$matesNoOffspring
  for (edgeStyle in c("direct", "rectilinear")) {
    layout <- .matesLayout(shape$ped, shape$matings, edgeStyle)
    point <- layout$nodes$id[which(layout$nodes$title == "0 offspring")]
    widget <- drawPedigreeDiagram(layout, edgeStyle = edgeStyle)
    widget$width <- "500px"
    html <- withr::local_tempfile(fileext = ".html")
    htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    js <- paste0(
      "(() => { const el = document.querySelector('.visNetwork'); ",
      "const net = HTMLWidgets.find('#' + el.id).network; ",
      "const p = net.getPositions(['E', 'F', '", point, "']); ",
      "const ends = net.getConnectedEdges('", point, "').map(e => { ",
      "const d = net.body.edges[e]; ",
      "return d.fromId === '", point, "' ? d.toId : d.fromId; }); ",
      "return [p.E.x, p.E.y, p.F.x, p.F.y, p['", point, "'].x, ",
      "p['", point, "'].y].join(',') + '|' + ends.sort().join(','); })()"
    )
    got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                    fixed = TRUE)[[1L]]
    xy <- as.numeric(strsplit(got[[1L]], ",", fixed = TRUE)[[1L]])
    expect_identical(xy[[2L]], xy[[6L]], info = edgeStyle)
    expect_identical(xy[[4L]], xy[[6L]], info = edgeStyle)
    expect_true(xy[[1L]] < xy[[5L]] && xy[[5L]] < xy[[3L]], info = edgeStyle)
    expect_identical(got[[2L]], "E,F", info = edgeStyle)
  }
})
