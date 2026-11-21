## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 15c,
## rulings R62 and R73, pedkindraw S24): asPedFrame() passes a kinship2 or
## Pedixplorer object's layout hints on as its third element, hints, in
## makePedigreeMatingLayout()'s form, list(order = , mate = ), or NULL
## (docs/planning/layout-hints-design.md, sections 7.4 and 9). Mark's picks
## at S24's pre-RED picker: mate rows the layout would refuse are fixed and
## one message names each change (a pair with no offspring together left
## out, a pair named before left out, an anchor on the partner of the
## earlier generation set to "either"); kinship2 hints that cannot be read
## as ids stop asPedFrame(), naming the problem; a pedigreeList's hints are
## read as a pedigree's. Every expected value was computed with a scratch
## prototype before this file was written (Learning 18). Helpers:
## helper-asPedFrame.R (kinship2 objects, random cases),
## helper-layoutHints.R (the random family pedigrees, the rows drawn). Plan
## Phase G15c (R141, pedkindraw S67): asPedFrame() returns a fourth
## element, matings; a mate hint row naming a pair it declares is kept
## (test_asPedFrameMatings.R).

## A kinship2 pedigree object built by hand, as kinship2 holds one (each
## parent by its place, 0 when unknown; sex a factor), with hints when
## given; with famid, a pedigreeList. No kinship2 needed (R55).
asPedFrameHintsK2 <- function(id, sire, dam, sex, hints = NULL,
                              famid = NULL) {
  x <- list(id = id, findex = match(sire, id, nomatch = 0L),
            mindex = match(dam, id, nomatch = 0L),
            sex = factor(unname(c(M = "male", F = "female")[sex]),
                         levels = c("male", "female", "unknown",
                                    "terminated")))
  cls <- "pedigree"
  if (!is.null(famid)) {
    x <- c(list(famid = famid), x)
    cls <- "pedigreeList"
  }
  x$hints <- hints
  structure(x, class = cls)
}

## The design's M1 (A x B have C, D, E; D x F have G, H) as such an object.
asPedFrameHintsIds <- c("A", "B", "C", "D", "E", "F", "G", "H")
asPedFrameHintsM1 <- function(hints) {
  asPedFrameHintsK2(asPedFrameHintsIds,
                    c(NA, NA, "A", "A", "A", NA, "D", "D"),
                    c(NA, NA, "B", "B", "B", NA, "F", "F"),
                    c("M", "F", "F", "M", "M", "F", "M", "F"), hints)
}

## The same animals as a data frame for Pedixplorer::Pedigree().
asPedFrameHintsM1Px <- function() {
  data.frame(id = asPedFrameHintsIds,
             dadid = c(NA, NA, "A", "A", "A", NA, "D", "D"),
             momid = c(NA, NA, "B", "B", "B", NA, "F", "F"),
             sex = c(1, 2, 2, 1, 1, 2, 1, 2), stringsAsFactors = FALSE)
}

asPedFrameHintsMate <- function(left, right, anchor) {
  data.frame(left = left, right = right, anchor = anchor,
             stringsAsFactors = FALSE)
}

## The layout of a converted object: x$ped with its generations, drawn with
## x$hints (edgeStyle "direct", so each mating's partners can be read).
asPedFrameHintsLayout <- function(x) {
  ped <- x$ped
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  suppressMessages(makePedigreeMatingLayout(ped, edgeStyle = "direct",
                                            hints = x$hints))
}

## asPedFrame() with its message muffled; returns the conversion and
## whether a message was given.
asPedFrameHintsQuiet <- function(obj) {
  said <- FALSE
  x <- withCallingHandlers(asPedFrame(obj), message = function(m) {
    said <<- TRUE
    invokeRestart("muffleMessage")
  })
  list(x = x, said = said)
}

## The mate rows asPedFrame() should give for an object's rows (ids and
## anchor words, in the object's order), worked out row by row apart from
## the code: a row whose pair has no offspring together in ped is left out;
## a row whose pair an earlier kept row named is left out; a kept row's
## anchor becomes "either" when it names the partner of the earlier
## generation (findGeneration()). NULL when no row is kept.
asPedFrameHintsWantMate <- function(rows, ped) {
  gen <- stats::setNames(findGeneration(ped$id, ped$sire, ped$dam), ped$id)
  kept <- list()
  seen <- character(0L)
  for (i in seq_len(nrow(rows))) {
    l <- rows$left[[i]]
    r <- rows$right[[i]]
    kids <- any((ped$sire %in% l & ped$dam %in% r) |
                  (ped$sire %in% r & ped$dam %in% l))
    key <- paste(sort(c(l, r)), collapse = " ")
    if (!kids || key %in% seen) next
    seen <- c(seen, key)
    anchor <- rows$anchor[[i]]
    if (anchor != "either") {
      a <- if (anchor == "left") l else r
      o <- if (anchor == "left") r else l
      if (gen[[a]] < gen[[o]]) anchor <- "either"
    }
    kept[[length(kept) + 1L]] <- asPedFrameHintsMate(l, r, anchor)
  }
  if (length(kept) == 0L) NULL else do.call(rbind, kept)
}

test_that("an object without hints, or hints that ask for nothing, gives
           hints NULL", {
  for (h in list(NULL, list(), list(order = NULL, spouse = NULL),
                 list(spouse = matrix(0L, 0L, 3L)), list(foo = 1),
                 list(order = rep(NA_real_, 8L)))) {
    x <- asPedFrame(asPedFrameHintsM1(h))
    expect_identical(names(x), c("ped", "twinRelations", "hints",
                                 "matings"))
    expect_null(x$hints)
  }
})

test_that("kinship2's order becomes its numbers named by id; an NA leaves
           that animal unnumbered", {
  expect_identical(
    asPedFrame(asPedFrameHintsM1(list(order = c(1, 2, 6, 4, 3, 5, 8,
                                                7))))$hints,
    list(order = c(A = 1, B = 2, C = 6, D = 4, E = 3, F = 5, G = 8, H = 7))
  )
  expect_identical(
    asPedFrame(asPedFrameHintsM1(list(order = 8:1)))$hints,
    list(order = stats::setNames(8:1, asPedFrameHintsIds))
  )
  expect_identical(
    asPedFrame(asPedFrameHintsM1(list(order = c(1, NA, 6, 4, 3, 5, 8,
                                                7))))$hints,
    list(order = c(A = 1, C = 6, D = 4, E = 3, F = 5, G = 8, H = 7))
  )
})

test_that("kinship2's spouse rows become mate rows of ids, anchors 1, 2, 0
           as left, right, either", {
  hints <- asPedFrame(asPedFrameHintsM1(list(
    order = 1:8, spouse = rbind(c(2, 1, 0), c(6, 4, 2))
  )))$hints
  expect_identical(hints, list(
    order = stats::setNames(1:8, asPedFrameHintsIds),
    mate = asPedFrameHintsMate(c("B", "F"), c("A", "D"),
                               c("either", "right"))
  ))
  expect_identical(
    asPedFrame(asPedFrameHintsM1(list(spouse = rbind(c(2, 1, 1)))))$hints,
    list(mate = asPedFrameHintsMate("B", "A", "left"))
  )
  ## A data frame reads as kinship2's matrix does, and no order is needed.
  expect_identical(
    asPedFrame(asPedFrameHintsM1(list(spouse = data.frame(
      l = c(2L, 6L), r = c(1L, 4L), a = c(0L, 2L)
    ))))$hints,
    list(mate = asPedFrameHintsMate(c("B", "F"), c("A", "D"),
                                    c("either", "right")))
  )
})

test_that("mate rows makePedigreeMatingLayout() would refuse are fixed, one
           message naming each change", {
  p <- asPedFrameHintsM1(list(order = 1:8, spouse = rbind(
    c(2, 1, 0), c(1, 2, 2), c(1, 6, 0), c(6, 4, 1)
  )))
  expect_message(
    x <- asPedFrame(p),
    paste0("asPedFrame(): changed the object's mate hints so that ",
           "makePedigreeMatingLayout() can use them; left out, no ",
           "offspring together: A and F; left out, pair named before: A ",
           "and B; anchor set to \"either\", it named the partner of the ",
           "earlier generation: F and D"),
    fixed = TRUE
  )
  expect_identical(x$hints$mate,
                   asPedFrameHintsMate(c("B", "F"), c("A", "D"),
                                       c("either", "either")))
  expect_identical(layoutHintsRowText(asPedFrameHintsLayout(x)),
                   "B A / C F D E / G H")
  ## Every row left out: no mate element; nothing left: NULL.
  expect_message(
    x <- asPedFrame(asPedFrameHintsM1(list(spouse = rbind(c(1, 6, 0),
                                                          c(6, 1, 0))))),
    "left out, no offspring together: A and F, F and A", fixed = TRUE
  )
  expect_null(x$hints)
  ## An animal paired with itself has no offspring together with itself.
  expect_message(
    x <- asPedFrame(asPedFrameHintsM1(list(order = 1:8,
                                           spouse = rbind(c(1, 1, 0))))),
    "left out, no offspring together: A and A", fixed = TRUE
  )
  expect_identical(x$hints,
                   list(order = stats::setNames(1:8, asPedFrameHintsIds)))
  ## Nothing to fix: no message.
  expect_silent(asPedFrame(asPedFrameHintsM1(list(
    order = 1:8, spouse = rbind(c(2, 1, 0), c(6, 4, 2))
  ))))
})

test_that("kinship2 hints that cannot be read as ids stop asPedFrame(),
           naming the problem", {
  expect_error(asPedFrame(asPedFrameHintsM1(1:8)),
               paste0("asPedFrame(): the object's hints must be a list with ",
                      "the elements order and spouse"), fixed = TRUE)
  orderStop <- function(type, n) {
    paste0("asPedFrame(): the object's hints$order must be numbers, one ",
           "per animal (8); it is ", type, " of length ", n)
  }
  expect_error(asPedFrame(asPedFrameHintsM1(list(order = letters[1:8]))),
               orderStop("character", 8), fixed = TRUE)
  expect_error(asPedFrame(asPedFrameHintsM1(list(order = 1:5))),
               orderStop("integer", 5), fixed = TRUE)
  expect_error(asPedFrame(asPedFrameHintsM1(list(order = numeric(0L)))),
               orderStop("double", 0), fixed = TRUE)
  expect_error(asPedFrame(asPedFrameHintsM1(list(order = rep(NA, 8L)))),
               orderStop("logical", 8), fixed = TRUE)
  spouseStop <- paste0("asPedFrame(): the object's hints$spouse must have ",
                       "three columns of whole numbers: the places of two ",
                       "animals (1 to 8) and an anchor, 1, 2 or 0")
  unreadable <- list(cbind(2, 1), c(2, 1, 0), cbind(2.5, 1, 0),
                     cbind(0, 1, 0), cbind(2, 9, 0), cbind(2, 1, 3),
                     cbind(2, NA, 0), data.frame(l = "B", r = "A", a = 0))
  for (spouse in unreadable) {
    expect_error(asPedFrame(asPedFrameHintsM1(list(spouse = spouse))),
                 spouseStop, fixed = TRUE)
  }
})

test_that("a pedigreeList's hints read as a pedigree's: a number per animal
           and places in the whole list", {
  pl <- asPedFrameHintsK2(
    c("A", "B", "C", "D", "E", "F"), c(NA, NA, "A", NA, NA, "D"),
    c(NA, NA, "B", NA, NA, "E"), c("M", "F", "M", "M", "F", "F"),
    hints = list(order = 6:1, spouse = rbind(c(2, 1, 0), c(5, 4, 2))),
    famid = c(1, 1, 1, 2, 2, 2)
  )
  expect_identical(asPedFrame(pl)$hints, list(
    order = stats::setNames(6:1, c("A", "B", "C", "D", "E", "F")),
    mate = asPedFrameHintsMate(c("B", "E"), c("A", "D"),
                               c("either", "right"))
  ))
})

test_that("Pedixplorer's horder and spouse become order and mate, ids as
           the object holds them", {
  skip_if_not_installed("Pedixplorer")
  d <- asPedFrameHintsM1Px()
  expect_null(asPedFrame(Pedixplorer::Pedigree(d))$hints)
  horder <- c(A = 1, B = 2, C = 6, D = 4, E = 3, F = 5, G = 8, H = 7)
  expect_identical(
    asPedFrame(Pedixplorer::Pedigree(d, hints = list(horder = horder)))$hints,
    list(order = horder)
  )
  x <- asPedFrame(Pedixplorer::Pedigree(d, hints = list(
    horder = stats::setNames(1:8, asPedFrameHintsIds),
    spouse = data.frame(idl = c("B", "F"), idr = c("A", "D"),
                        anchor = c(0, 2))
  )))
  expect_identical(x$hints, list(
    order = stats::setNames(1:8, asPedFrameHintsIds),
    mate = asPedFrameHintsMate(c("B", "F"), c("A", "D"),
                               c("either", "right"))
  ))
  ## Families: Pedixplorer joins each id to its family.
  d2 <- rbind(transform(d, famid = "F1"), transform(d, famid = "F2"))
  ids <- paste0(rep(c("F1_", "F2_"), each = 8L), asPedFrameHintsIds)
  x <- asPedFrame(Pedixplorer::Pedigree(d2, hints = list(
    horder = stats::setNames(c(1:8, 8:1), ids),
    spouse = data.frame(idl = c("F1_B", "F2_F"), idr = c("F1_A", "F2_D"),
                        anchor = c(0, 2))
  )))
  expect_identical(x$hints, list(
    order = stats::setNames(c(1:8, 8:1), ids),
    mate = asPedFrameHintsMate(c("F1_B", "F2_F"), c("F1_A", "F2_D"),
                               c("either", "right"))
  ))
})

test_that("Pedixplorer's mate rows the layout would refuse are fixed, with
           the message", {
  skip_if_not_installed("Pedixplorer")
  p <- Pedixplorer::Pedigree(asPedFrameHintsM1Px(), hints = list(
    horder = stats::setNames(1:8, asPedFrameHintsIds),
    spouse = data.frame(idl = c("B", "A", "F"), idr = c("A", "F", "D"),
                        anchor = c(0, 1, 1))
  ))
  expect_message(
    x <- asPedFrame(p),
    paste0("asPedFrame(): changed the object's mate hints so that ",
           "makePedigreeMatingLayout() can use them; left out, no ",
           "offspring together: A and F; anchor set to \"either\", it ",
           "named the partner of the earlier generation: F and D"),
    fixed = TRUE
  )
  expect_identical(x$hints$mate,
                   asPedFrameHintsMate(c("B", "F"), c("A", "D"),
                                       c("either", "either")))
})

test_that("objects holding kinship2's autohint() hints convert and draw:
           100 seeded random family pedigrees", {
  skip_if_not_installed("kinship2")
  skip_on_cran()
  converted <- 0L
  fixed <- 0L
  rowsKept <- 0L
  drawn <- 0L
  sides <- 0L
  for (seed in 1:100) {
    f <- asPedFrameForKinship2(layoutHintsFamilies(seed)[c("id", "sire",
                                                           "dam", "sex")])
    p <- asPedFrameK2(id = f$id, dadid = f$sire, momid = f$dam,
                      sex = unname(asPedFrameK2Sex[f$sex]))
    h <- tryCatch(asPedFrameHintsAuto(kinship2::autohint(p)),
                  error = function(e) NULL)
    if (is.null(h)) next
    p$hints <- h
    got <- asPedFrameHintsQuiet(p)
    x <- got$x
    ids <- as.character(p$id)
    expect_identical(x$hints$order, stats::setNames(h$order, ids),
                     label = paste("seed", seed))
    rows <- NULL
    if (!is.null(h$spouse)) {
      rows <- asPedFrameHintsMate(ids[h$spouse[, 1L]], ids[h$spouse[, 2L]],
                                  c("either", "left", "right")[
                                    h$spouse[, 3L] + 1L])
    }
    want <- if (is.null(rows)) NULL else asPedFrameHintsWantMate(rows, x$ped)
    expect_identical(x$hints$mate, want, label = paste("seed", seed))
    expect_identical(got$said, !identical(want, rows),
                     label = paste("seed", seed))
    converted <- converted + 1L
    fixed <- fixed + got$said
    rowsKept <- rowsKept + NROW(want)
    if (nrow(x$ped) <= 300L) {
      matings <- layoutHintsMatings(asPedFrameHintsLayout(x))
      if (!is.null(want)) {
        i <- match(layoutHintsPairKey(want$left, want$right),
                   layoutHintsPairKey(matings$left, matings$right))
        expect_identical(matings$left[i[!is.na(i)]],
                         want$left[!is.na(i)], label = paste("seed", seed))
        sides <- sides + sum(!is.na(i))
      }
      drawn <- drawn + 1L
    }
  }
  expect_gte(converted, 100L)
  expect_gte(fixed, 14L)
  expect_gte(rowsKept, 779L)
  expect_gte(drawn, 65L)
  expect_gte(sides, 236L)
})

test_that("objects holding Pedixplorer's auto_hint() hints convert and draw:
           100 seeded random family pedigrees", {
  skip_if_not_installed("Pedixplorer")
  skip_on_cran()
  converted <- 0L
  fixed <- 0L
  rowsKept <- 0L
  drawn <- 0L
  sides <- 0L
  for (seed in 1:100) {
    f <- asPedFrameForKinship2(layoutHintsFamilies(seed)[c("id", "sire",
                                                           "dam", "sex")])
    p <- Pedixplorer::Pedigree(data.frame(
      id = f$id, dadid = f$sire, momid = f$dam,
      sex = unname(asPedFrameK2Sex[f$sex]), stringsAsFactors = FALSE
    ))
    h <- tryCatch(asPedFrameHintsAuto(Pedixplorer::auto_hint(p)),
                  error = function(e) NULL)
    if (is.null(h)) next
    Pedixplorer::hints(p) <- h
    got <- asPedFrameHintsQuiet(p)
    x <- got$x
    expect_identical(x$hints$order, Pedixplorer::horder(h),
                     label = paste("seed", seed))
    spouse <- Pedixplorer::spouse(h)
    rows <- NULL
    if (nrow(spouse) > 0L) {
      rows <- asPedFrameHintsMate(as.character(spouse$idl),
                                  as.character(spouse$idr),
                                  as.character(spouse$anchor))
    }
    want <- if (is.null(rows)) NULL else asPedFrameHintsWantMate(rows, x$ped)
    expect_identical(x$hints$mate, want, label = paste("seed", seed))
    expect_identical(got$said, !identical(want, rows),
                     label = paste("seed", seed))
    converted <- converted + 1L
    fixed <- fixed + got$said
    rowsKept <- rowsKept + NROW(want)
    if (nrow(x$ped) <= 300L) {
      matings <- layoutHintsMatings(asPedFrameHintsLayout(x))
      if (!is.null(want)) {
        i <- match(layoutHintsPairKey(want$left, want$right),
                   layoutHintsPairKey(matings$left, matings$right))
        expect_identical(matings$left[i[!is.na(i)]],
                         want$left[!is.na(i)], label = paste("seed", seed))
        sides <- sides + sum(!is.na(i))
      }
      drawn <- drawn + 1L
    }
  }
  expect_gte(converted, 71L)
  expect_gte(fixed, 25L)
  expect_gte(rowsKept, 1095L)
  expect_gte(drawn, 55L)
  expect_gte(sides, 293L)
})

## The typed cases of test_layoutHintsOrder.R and test_layoutHintsMate.R:
## M1; a sire with two and with three dams; three founder couples whose
## offspring mate across families.
asPedFrameHintsTyped <- list(
  m1 = layoutHintsPed(
    id = asPedFrameHintsIds, sire = c(NA, NA, "A", "A", "A", NA, "D", "D"),
    dam = c(NA, NA, "B", "B", "B", NA, "F", "F"),
    sex = c("M", "F", "F", "M", "M", "F", "M", "F")
  ),
  twoDams = layoutHintsPed(
    id = c("P", "Q", "A", "B", "C", "K1", "K2", "K3", "K4"),
    sire = c(NA, NA, "P", NA, NA, "A", "A", "A", "A"),
    dam = c(NA, NA, "Q", NA, NA, "B", "B", "C", "C"),
    sex = c("M", "F", "M", "F", "F", "M", "F", "M", "F")
  ),
  threeDams = layoutHintsPed(
    id = c("P", "Q", "A", "B", "C", "D", "K1", "K2", "K3"),
    sire = c(NA, NA, "P", NA, NA, NA, "A", "A", "A"),
    dam = c(NA, NA, "Q", NA, NA, NA, "B", "C", "D"),
    sex = c("M", "F", "M", "F", "F", "F", "M", "F", "M")
  ),
  couples = layoutHintsPed(
    id = c("A", "B", "X", "Y", "P", "Q", "C", "D", "Z", "U", "W", "K1",
           "K2"),
    sire = c(NA, NA, NA, NA, NA, NA, "A", "A", "X", "X", "P", "C", "U"),
    dam = c(NA, NA, NA, NA, NA, NA, "B", "B", "Y", "Y", "Q", "Z", "W"),
    sex = c("M", "F", "M", "F", "M", "F", "M", "F", "F", "M", "F", "M", "F")
  )
)

## The typed hints: S22's and S23's, each mate hint also with every anchor
## "left" and with every anchor "right" unless that names the partner of
## the earlier generation. One list(ped, mate, order) per case.
asPedFrameHintsCases <- function() {
  m <- function(left, right) asPedFrameHintsMate(left, right, "either")
  typed <- asPedFrameHintsTyped
  m1Order <- c(A = 1, B = 2, E = 3, D = 4, F = 5, C = 6, H = 7, G = 8)
  cases <- list(
    list(typed$m1, NULL, m1Order),
    list(typed$m1, NULL, c(A = 1, B = 2, C = 3, D = 3, E = 3, F = 5, G = 8,
                           H = 8)),
    list(typed$m1, m("B", "A"), NULL), list(typed$m1, m("F", "D"), NULL),
    list(typed$m1, m(c("B", "F"), c("A", "D")), NULL),
    list(typed$m1, m(c("B", "F"), c("A", "D")), m1Order)
  )
  two <- list(m("A", "B"), m("B", "A"), m("C", "A"), m("A", "C"),
              m(c("A", "A"), c("B", "C")), m(c("A", "A"), c("C", "B")),
              m(c("B", "C"), c("A", "A")), m(c("C", "A"), c("A", "B")))
  three <- list(m(c("A", "A", "A"), c("B", "C", "D")),
                m(c("A", "A", "A"), c("D", "B", "C")),
                m(c("B", "C", "D"), c("A", "A", "A")),
                m(c("D", "B", "C"), c("A", "A", "A")),
                m("A", "B"), m("B", "A"), m("D", "A"),
                m(c("A", "A"), c("C", "B")), m(c("C", "B"), c("A", "A")),
                m(c("B", "A"), c("A", "C")))
  cases <- c(cases, lapply(two, function(h) list(typed$twoDams, h, NULL)),
             lapply(three, function(h) list(typed$threeDams, h, NULL)))
  varied <- list()
  for (case in cases) {
    if (is.null(case[[2L]])) next
    gen <- stats::setNames(case[[1L]]$gen, case[[1L]]$id)
    for (anchor in c("left", "right")) {
      h <- case[[2L]]
      h$anchor <- anchor
      anchored <- if (anchor == "left") h$left else h$right
      other <- if (anchor == "left") h$right else h$left
      if (any(gen[anchored] < gen[other])) next
      varied[[length(varied) + 1L]] <- list(case[[1L]], h, case[[3L]])
    }
  }
  c(cases, varied)
}

## Each row of an alignment left to right, or NULL when the drawing is not
## complete (an animal missing or a row empty, as where kinship2's or
## Pedixplorer's quadratic program fails).
asPedFrameHintsAligned <- function(a, ids) {
  rows <- lapply(seq_len(nrow(a$nid)), function(r) {
    ids[a$nid[r, seq_len(a$n[r])]]
  })
  if (!setequal(unlist(rows), ids) || any(lengths(rows) == 0L)) {
    return(NULL)
  }
  rows
}

## A kinship2 object of ped with hints: the order given, else autohint()'s;
## the mate hint as its spouse matrix.
asPedFrameHintsK2Typed <- function(ped, hintMate, hintOrder) {
  p <- kinship2::pedigree(id = ped$id, dadid = ped$sire, momid = ped$dam,
                          sex = ifelse(ped$sex == "M", 1L, 2L), missid = NA)
  ids <- as.character(p$id)
  h <- if (is.null(hintOrder)) {
    kinship2::autohint(p)
  } else {
    list(order = unname(hintOrder[ids]))
  }
  if (!is.null(hintMate)) {
    h$spouse <- cbind(match(hintMate$left, ids), match(hintMate$right, ids),
                      c(left = 1L, right = 2L, either = 0L)[hintMate$anchor])
  }
  p$hints <- h
  p
}

## A Pedixplorer object of ped with hints: the order given, else
## auto_hint()'s horder; the mate hint as its spouse data frame.
asPedFrameHintsPxTyped <- function(ped, hintMate, hintOrder) {
  d <- data.frame(id = ped$id, dadid = ped$sire, momid = ped$dam,
                  sex = ifelse(ped$sex == "M", 1L, 2L),
                  stringsAsFactors = FALSE)
  h <- list(horder = if (is.null(hintOrder)) {
    Pedixplorer::horder(Pedixplorer::auto_hint(Pedixplorer::Pedigree(d)))
  } else {
    hintOrder[ped$id]
  })
  if (!is.null(hintMate)) {
    h$spouse <- data.frame(idl = hintMate$left, idr = hintMate$right,
                           anchor = c(left = 1, right = 2,
                                      either = 0)[hintMate$anchor])
  }
  Pedixplorer::Pedigree(d, hints = h)
}

## Pedixplorer's alignment, its notes on a failed quadratic program kept
## out of the test's output.
asPedFrameHintsPxAlign <- function(x) {
  utils::capture.output(a <- Pedixplorer::align(x), type = "message")
  asPedFrameHintsAligned(a, as.character(Pedixplorer::id(Pedixplorer::ped(x))))
}

test_that("through asPedFrame(), each row is drawn as kinship2's
           align.pedigree() draws it with the object's hints, where it
           returns", {
  skip_if_not_installed("kinship2")
  compared <- 0L
  for (case in asPedFrameHintsCases()) {
    p <- asPedFrameHintsK2Typed(case[[1L]], case[[2L]], case[[3L]])
    want <- asPedFrameHintsAligned(kinship2::align.pedigree(p),
                                   as.character(p$id))
    if (is.null(want)) next
    expect_identical(layoutHintsRows(asPedFrameHintsLayout(asPedFrame(p))),
                     want)
    compared <- compared + 1L
  }
  expect_gte(compared, 42L)
  ## The founder couples, 24 seeded orders of the six founders: the top two
  ## rows hold the same animals in the same order (kinship2 draws the
  ## couple P x Q a row lower, S22).
  for (seed in 1L:24L) {
    founders <- withr::with_seed(seed, sample(c("A", "B", "X", "Y", "P",
                                                "Q")))
    hintOrder <- stats::setNames(seq_len(13L), c(founders, "C", "D", "Z",
                                                 "U", "W", "K1", "K2"))
    p <- asPedFrameHintsK2Typed(asPedFrameHintsTyped$couples, NULL,
                                hintOrder)
    agree <- layoutHintsRowsAgree(
      layoutHintsRows(asPedFrameHintsLayout(asPedFrame(p))),
      asPedFrameHintsAligned(kinship2::align.pedigree(p), as.character(p$id))
    )
    expect_identical(agree[1:2], c(TRUE, TRUE), label = paste("seed", seed))
  }
})

test_that("through asPedFrame(), each row is drawn as Pedixplorer's align()
           draws it with the object's hints, where it returns", {
  skip_if_not_installed("Pedixplorer")
  compared <- 0L
  for (case in asPedFrameHintsCases()) {
    x <- asPedFrameHintsPxTyped(case[[1L]], case[[2L]], case[[3L]])
    want <- asPedFrameHintsPxAlign(x)
    if (is.null(want)) next
    expect_identical(layoutHintsRows(asPedFrameHintsLayout(asPedFrame(x))),
                     want)
    compared <- compared + 1L
  }
  expect_gte(compared, 21L)
  for (seed in 1L:24L) {
    founders <- withr::with_seed(seed, sample(c("A", "B", "X", "Y", "P",
                                                "Q")))
    hintOrder <- stats::setNames(seq_len(13L), c(founders, "C", "D", "Z",
                                                 "U", "W", "K1", "K2"))
    x <- asPedFrameHintsPxTyped(asPedFrameHintsTyped$couples, NULL,
                                hintOrder)
    agree <- layoutHintsRowsAgree(
      layoutHintsRows(asPedFrameHintsLayout(asPedFrame(x))),
      asPedFrameHintsPxAlign(x)
    )
    expect_identical(agree[1:2], c(TRUE, TRUE), label = paste("seed", seed))
  }
})
