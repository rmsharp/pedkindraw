## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G15c,
## gap B1 (mates with no offspring) of
## docs/research/pedkindraw-gaps-2026-11-18.md; ruling R141, pedkindraw
## S67; docs/planning/mates-without-offspring-plan.md): asPedFrame() returns
## a fourth element, matings, from kinship2's relation code 4 and
## Pedixplorer's "Spouse" rows, for makePedigreeMatingLayout(matings = ).
## Mark's picks at S67's pre-RED picker: every spouse row the object holds is
## kept as stored (a pair with offspring together, and a pair named twice,
## included); any sexes, the male as sire, else the female as dam, else the
## object's order. A mate hint row naming a declared pair is kept. Every
## expected value was computed with a scratch prototype before this file was
## written (Learning 18). Helpers: helper-matesNoOffspring.R (the typed
## shapes), helper-layoutHints.R (the random family pedigrees),
## helper-offspringAndMatings.R (drawnMatings(), matingPairs()),
## helper-asPedFrame.R (asPedFrameForKinship2(), asPedFrameK2Sex).

## A kinship2 pedigree object built by hand, as kinship2 holds one (each
## parent by its place, 0 when unknown; sex a factor; relation's code a
## factor of kinship2's four words), its relation rows given as ids. No
## kinship2 needed (R55).
asPedFrameMatingsK2 <- function(id, sire, dam, sex, id1 = NULL, id2 = NULL,
                                code = 4L) {
  x <- list(id = id, findex = match(sire, id, nomatch = 0L),
            mindex = match(dam, id, nomatch = 0L),
            sex = factor(unname(c(M = "male", F = "female",
                                  U = "unknown")[sex]),
                         levels = c("male", "female", "unknown",
                                    "terminated")))
  if (!is.null(id1)) {
    words <- c("MZ twin", "DZ twin", "UZ twin", "spouse")
    x$relation <- data.frame(indx1 = match(id1, id), indx2 = match(id2, id),
                             code = factor(words[rep_len(code, length(id1))],
                                           levels = words))
  }
  class(x) <- "pedigree"
  x
}

## The matings table asPedFrame() should give for spouse rows id1, id2 of a
## pedigree with sexes sex (named by id), worked out row by row apart from
## the code: each row kept, in order; the male as sire, else the female as
## dam, else id1 as sire. NULL when there is no row.
asPedFrameMatingsWant <- function(id1, id2, sex) {
  if (length(id1) == 0L) {
    return(NULL)
  }
  sire <- id1
  dam <- id2
  for (i in seq_along(id1)) {
    s1 <- sex[[id1[i]]]
    s2 <- sex[[id2[i]]]
    swap <- if (s1 == "M" || s2 == "M") {
      s2 == "M" && s1 != "M"
    } else {
      s1 == "F" && s2 != "F"
    }
    if (swap) {
      sire[i] <- id2[i]
      dam[i] <- id1[i]
    }
  }
  data.frame(sire = sire, dam = dam, stringsAsFactors = FALSE)
}

## The pairs an alignment from kinship2::align.pedigree() or
## Pedixplorer::align() joins as mates: two animals side by side on a row
## with the mate mark between them, each pair its two ids sorted and joined
## with "+", sorted, each once. On a pedigree this small every joined pair is
## a mating (kinship2 draws an animal with three mates as a chain, so on
## large ones a pair side by side need not be).
asPedFrameMatingsJoined <- function(al, ids) {
  out <- character(0L)
  for (i in seq_len(nrow(al$nid))) {
    n <- al$n[i]
    if (n < 2L) next
    who <- ids[al$nid[i, seq_len(n)]]
    mark <- al$spouse[i, seq_len(n)]
    for (j in seq_len(n - 1L)) {
      if (mark[j] > 0L) {
        out <- c(out, paste(sort(who[c(j, j + 1L)]), collapse = "+"))
      }
    }
  }
  sort(unique(out))
}

## The pairs pedkindraw draws as matings for a converted object: x$ped with
## its generations, drawn with x$matings and x$hints (edgeStyle "direct"),
## each pair sorted and joined with "+", sorted, each once.
asPedFrameMatingsDrawn <- function(x) {
  ped <- x$ped
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  drawn <- drawnMatings(.matesLayout(ped, matings = x$matings,
                                     hints = x$hints))
  sort(unique(drawn[!is.na(drawn)]))
}

## kinship2's autohint() or Pedixplorer's auto_hint() with their one
## expected warning muffled ("Unexpected result in autohint, please contact
## developer", as test_asPedFrameHints.R muffles it); any other warning
## still reaches the test.
asPedFrameMatingsAuto <- function(expr) {
  withCallingHandlers(expr, warning = function(w) {
    if (grepl("Unexpected result in auto_?hint, ?please contact developer",
              conditionMessage(w))) {
      invokeRestart("muffleWarning")
    }
  })
}

## kinship2's sex numbers for the package's sex codes.
asPedFrameMatingsSexNumber <- c(M = 1L, F = 2L, U = 3L)

test_that("an object with no spouse pair gives matings NULL, the fourth
           element", {
  id <- c("A", "B", "C", "D")
  sire <- c(NA, NA, "A", "A")
  dam <- c(NA, NA, "B", "B")
  sex <- c("M", "F", "M", "F")
  x <- asPedFrame(asPedFrameMatingsK2(id, sire, dam, sex))
  expect_identical(names(x), c("ped", "twinRelations", "hints", "matings"))
  expect_null(x$matings)
  x <- asPedFrame(asPedFrameMatingsK2(id, sire, dam, sex, "C", "D", 2L))
  expect_identical(names(x), c("ped", "twinRelations", "hints", "matings"))
  expect_null(x$matings)
  expect_identical(x$twinRelations$code, "DZ twin")
})

test_that("kinship2's spouse rows become matings, each row as stored, the
           male as sire, else the female as dam", {
  id <- c("A", "B", "C", "D", "E", "F", "G", "H")
  sire <- c(NA, NA, "A", "A", NA, NA, NA, NA)
  dam <- c(NA, NA, "B", "B", NA, NA, NA, NA)
  sex <- c("M", "F", "M", "F", "M", "F", "M", "U")
  ## The dam first; a pair with offspring together; a pair named again, the
  ## other way round; two males, each way round; an unknown sex with a
  ## female, each way round; and with a male, each way round.
  id1 <- c("F", "A", "E", "E", "G", "H", "F", "E", "H")
  id2 <- c("E", "B", "F", "G", "E", "F", "H", "H", "E")
  want <- data.frame(sire = c("E", "A", "E", "E", "G", "H", "H", "E", "E"),
                     dam = c("F", "B", "F", "G", "E", "F", "F", "H", "H"),
                     stringsAsFactors = FALSE)
  expect_identical(want, asPedFrameMatingsWant(id1, id2,
                                               stats::setNames(sex, id)))
  x <- asPedFrame(asPedFrameMatingsK2(id, sire, dam, sex, id1, id2))
  expect_identical(x$matings, want)
  expect_null(x$twinRelations)
  ## A twin pair beside them is a twin pair still, and no mating.
  x <- asPedFrame(asPedFrameMatingsK2(id, sire, dam, sex, c("C", id1),
                                      c("D", id2), c(2L, rep(4L, 9L))))
  expect_identical(x$matings, want)
  expect_identical(x$twinRelations,
                   data.frame(id1 = "C", id2 = "D", code = "DZ twin",
                              stringsAsFactors = FALSE))
  skip_if_not_installed("kinship2")
  for (code in list(4L, "spouse")) {
    p <- kinship2::pedigree(id, sire, dam,
                            unname(asPedFrameMatingsSexNumber[sex]),
                            missid = NA,
                            relation = data.frame(id1 = id1, id2 = id2,
                                                  code = code))
    expect_identical(asPedFrame(p)$matings, want)
  }
})

test_that("a pedigreeList's spouse pairs are read as a pedigree's, with the
           ids of the whole list", {
  skip_if_not_installed("kinship2")
  rel <- data.frame(id1 = c(13, 26), id2 = c(14, 25), code = c(1, 4),
                    famid = c(1, 2))
  pl <- kinship2::pedigree(c(11, 12, 13, 14, 21, 22, 23, 24, 25, 26),
                           c(0, 0, 11, 11, 0, 0, 21, 21, 0, 0),
                           c(0, 0, 12, 12, 0, 0, 22, 22, 0, 0),
                           c(1, 2, 1, 1, 1, 2, 2, 1, 1, 2),
                           famid = c(1, 1, 1, 1, 2, 2, 2, 2, 2, 2),
                           relation = rel)
  want <- data.frame(sire = "25", dam = "26", stringsAsFactors = FALSE)
  x <- asPedFrame(pl)
  expect_identical(x$matings, want)
  expect_identical(x$twinRelations$code, "MZ twin")
  expect_identical(asPedFrame(pl["2"])$matings, want)
  expect_null(asPedFrame(pl["1"])$matings)
})

test_that("Pedixplorer's Spouse rows become matings, the male as sire", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C", "D", "E", "F", "G"),
                  dadid = c(NA, NA, "A", "A", NA, NA, NA),
                  momid = c(NA, NA, "B", "B", NA, NA, NA),
                  sex = c(1, 2, 1, 2, 1, 2, 1))
  ## The dam first; a pair with offspring together; two males; and a twin
  ## pair beside them.
  rel <- data.frame(id1 = c("F", "A", "G", "C"), id2 = c("E", "B", "E", "D"),
                    code = c(4, 4, 4, 2))
  x <- asPedFrame(Pedixplorer::Pedigree(d, rel_df = rel))
  ## Pedixplorer holds each pair with its two ids in sorted order, so two
  ## males come back in that order, not as given.
  got <- x$matings[order(x$matings$sire, x$matings$dam), ]
  rownames(got) <- NULL
  expect_identical(got, data.frame(sire = c("A", "E", "E"),
                                   dam = c("B", "F", "G"),
                                   stringsAsFactors = FALSE))
  expect_identical(x$twinRelations,
                   data.frame(id1 = "C", id2 = "D", code = "DZ twin",
                              stringsAsFactors = FALSE))
  expect_null(asPedFrame(Pedixplorer::Pedigree(d))$matings)
  ## With families, the ids as Pedixplorer holds them.
  d$famid <- "f1"
  rel <- data.frame(id1 = "F", id2 = "E", code = 4, famid = "f1")
  expect_identical(
    asPedFrame(Pedixplorer::Pedigree(d, rel_df = rel))$matings,
    data.frame(sire = "f1_E", dam = "f1_F", stringsAsFactors = FALSE)
  )
})

test_that("a mate hint row naming a declared pair is kept, without a
           message; one naming a pair neither declared nor with offspring
           is left out, as before", {
  ## C and J are declared mates; H and I are J's parents; D and H have no
  ## offspring together and are not declared.
  id <- c("A", "B", "C", "D", "H", "I", "J")
  sire <- c(NA, NA, "A", "A", NA, NA, "H")
  dam <- c(NA, NA, "B", "B", NA, NA, "I")
  sex <- c("M", "F", "M", "F", "M", "F", "F")
  p <- asPedFrameMatingsK2(id, sire, dam, sex, "C", "J")
  p$hints <- list(spouse = rbind(c(3, 7, 1)))
  expect_silent(x <- asPedFrame(p))
  expect_identical(x$hints$mate,
                   data.frame(left = "C", right = "J", anchor = "left",
                              stringsAsFactors = FALSE))
  expect_identical(x$matings,
                   data.frame(sire = "C", dam = "J", stringsAsFactors = FALSE))
  expect_identical(asPedFrameMatingsDrawn(x), c("A+B", "C+J", "H+I"))
  p$hints <- list(spouse = rbind(c(3, 7, 1), c(4, 5, 0)))
  expect_message(x <- asPedFrame(p),
                 "left out, no offspring together: D and H", fixed = TRUE)
  expect_identical(x$hints$mate,
                   data.frame(left = "C", right = "J", anchor = "left",
                              stringsAsFactors = FALSE))
  ## Without the declared pair, its hint row is left out too, as before.
  p <- asPedFrameMatingsK2(id, sire, dam, sex)
  p$hints <- list(spouse = rbind(c(3, 7, 1)))
  expect_message(x <- asPedFrame(p),
                 "left out, no offspring together: C and J", fixed = TRUE)
  expect_null(x$hints)
  expect_null(x$matings)
  skip_if_not_installed("Pedixplorer")
  px <- Pedixplorer::Pedigree(
    data.frame(id = id, dadid = sire, momid = dam,
               sex = unname(asPedFrameMatingsSexNumber[sex])),
    rel_df = data.frame(id1 = "C", id2 = "J", code = 4)
  )
  Pedixplorer::hints(px) <- Pedixplorer::auto_hint(px)
  expect_silent(x <- asPedFrame(px))
  expect_identical(x$hints$mate,
                   data.frame(left = "C", right = "J", anchor = "right",
                              stringsAsFactors = FALSE))
  expect_identical(asPedFrameMatingsDrawn(x), c("A+B", "C+J", "H+I"))
})

test_that("each typed shape, converted and drawn: pedkindraw joins the
           pairs kinship2 and Pedixplorer join", {
  shapes <- .matesShapes()
  ## Two shapes more: a pair with offspring together, and a pair named
  ## twice, each way round.
  shapes$redundant <- list(ped = .matesPlus(),
                           matings = .matesTable("A", "B"))
  shapes$twice <- list(ped = .matesPlus(c("E", "F"), NA, NA, c("M", "F")),
                       matings = .matesTable(c("E", "F"), c("F", "E")))
  k2Compared <- 0L
  pxCompared <- 0L
  for (name in names(shapes)) {
    ped <- shapes[[name]]$ped
    m <- shapes[[name]]$matings
    want <- asPedFrameMatingsWant(m$sire, m$dam,
                                  stats::setNames(ped$sex, ped$id))
    number <- unname(asPedFrameMatingsSexNumber[ped$sex])
    if (requireNamespace("kinship2", quietly = TRUE)) {
      p <- kinship2::pedigree(ped$id, ped$sire, ped$dam, number, missid = NA,
                              relation = data.frame(id1 = m$sire,
                                                    id2 = m$dam, code = 4L))
      x <- asPedFrame(p)
      expect_identical(x$matings, want, label = name)
      expect_identical(asPedFrameMatingsDrawn(x),
                       asPedFrameMatingsJoined(kinship2::align.pedigree(p),
                                               as.character(p$id)),
                       label = name)
      k2Compared <- k2Compared + 1L
    }
    if (requireNamespace("Pedixplorer", quietly = TRUE) && name != "twice") {
      px <- Pedixplorer::Pedigree(
        data.frame(id = ped$id, dadid = ped$sire, momid = ped$dam,
                   sex = number),
        rel_df = data.frame(id1 = m$sire, id2 = m$dam, code = 4L)
      )
      x <- asPedFrame(px)
      expect_setequal(matingPairs(x$matings), matingPairs(want))
      al <- tryCatch(Pedixplorer::align(px), error = function(e) NULL)
      if (is.null(al)) next
      expect_identical(asPedFrameMatingsDrawn(x),
                       asPedFrameMatingsJoined(al, Pedixplorer::id(
                         Pedixplorer::ped(px)
                       )),
                       label = name)
      pxCompared <- pxCompared + 1L
    }
  }
  skip_if_not_installed("kinship2")
  skip_if_not_installed("Pedixplorer")
  expect_gte(k2Compared, 14L)
  expect_gte(pxCompared, 11L)
})

test_that("the round trip: a table of matings through kinship2::pedigree()
           and Pedixplorer::Pedigree() and back, then drawn, on 100 seeded
           random family pedigrees", {
  skip_on_cran()
  skip_if_not_installed("kinship2")
  skip_if_not_installed("Pedixplorer")
  cases <- 0L
  rows <- 0L
  k2Hinted <- 0L
  k2HintRows <- 0L
  pxHinted <- 0L
  pxHintRows <- 0L
  seed <- 0L
  while (cases < 100L) {
    seed <- seed + 1L
    ped <- asPedFrameForKinship2(layoutHintsFamilies(seed)[c("id", "sire",
                                                             "dam", "sex")])
    if (nrow(ped) > 300L) next
    m <- .matesPick(ped, seed, 1L + seed %% 3L)
    if (nrow(m) == 0L) next
    cases <- cases + 1L
    ## Some rows the dam first; a pair with offspring together every 4th
    ## case; two males with no offspring together every 5th.
    flip <- withr::with_seed(seed, stats::runif(nrow(m)) < 0.5)
    m[flip, c("sire", "dam")] <- m[flip, c("dam", "sire")]
    if (seed %% 4L == 0L) {
      i <- which(!is.na(ped$sire))[1L]
      m <- rbind(m, .matesTable(ped$sire[i], ped$dam[i]))
    }
    if (seed %% 5L == 0L) {
      males <- ped$id[ped$sex == "M"]
      pairs <- utils::combn(males, 2L)
      none <- !.layoutHintTogether(pairs[1L, ], pairs[2L, ], ped)
      if (any(none)) {
        j <- which(none)[1L]
        m <- rbind(m, .matesTable(pairs[1L, j], pairs[2L, j]))
      }
    }
    rows <- rows + nrow(m)
    sexOf <- stats::setNames(ped$sex, ped$id)
    want <- asPedFrameMatingsWant(m$sire, m$dam, sexOf)
    number <- unname(asPedFrameMatingsSexNumber[ped$sex])
    label <- paste("seed", seed)
    p <- kinship2::pedigree(ped$id, ped$sire, ped$dam, number, missid = NA,
                            relation = data.frame(id1 = m$sire, id2 = m$dam,
                                                  code = 4L))
    x <- asPedFrame(p)
    expect_identical(x$matings, want, label = label)
    expect_true(all(matingPairs(want) %in% asPedFrameMatingsDrawn(x)),
                label = label)
    h <- tryCatch(asPedFrameMatingsAuto(kinship2::autohint(p)),
                  error = function(e) NULL)
    if (!is.null(h)) {
      p$hints <- h
      x <- suppressMessages(asPedFrame(p))
      k2HintRows <- k2HintRows + sum(
        .layoutHintPairKey(x$hints$mate$left, x$hints$mate$right) %in%
          .layoutHintPairKey(want$sire, want$dam) &
          !.layoutHintTogether(x$hints$mate$left, x$hints$mate$right, ped)
      )
      expect_true(all(matingPairs(want) %in% asPedFrameMatingsDrawn(x)),
                  label = label)
      k2Hinted <- k2Hinted + 1L
    }
    ## Pedixplorer holds each pair's ids in sorted order and its rows in an
    ## order of its own: the same pairs come back, each with the male as
    ## sire.
    px <- Pedixplorer::Pedigree(
      data.frame(id = ped$id, dadid = ped$sire, momid = ped$dam,
                 sex = number),
      rel_df = data.frame(id1 = m$sire, id2 = m$dam, code = 4L)
    )
    x <- asPedFrame(px)
    expect_identical(sort(matingPairs(x$matings)), sort(matingPairs(want)),
                     label = label)
    oneMale <- (sexOf[x$matings$sire] == "M") != (sexOf[x$matings$dam] == "M")
    expect_true(all(sexOf[x$matings$sire[oneMale]] == "M"), label = label)
    expect_true(all(matingPairs(want) %in% asPedFrameMatingsDrawn(x)),
                label = label)
    h <- tryCatch(asPedFrameMatingsAuto(Pedixplorer::auto_hint(px)),
                  error = function(e) NULL)
    if (!is.null(h)) {
      Pedixplorer::hints(px) <- h
      x <- suppressMessages(asPedFrame(px))
      pxHintRows <- pxHintRows + sum(
        .layoutHintPairKey(x$hints$mate$left, x$hints$mate$right) %in%
          .layoutHintPairKey(want$sire, want$dam) &
          !.layoutHintTogether(x$hints$mate$left, x$hints$mate$right, ped)
      )
      expect_true(all(matingPairs(want) %in% asPedFrameMatingsDrawn(x)),
                  label = label)
      pxHinted <- pxHinted + 1L
    }
  }
  expect_gte(cases, 100L)
  expect_gte(rows, 243L)
  expect_gte(k2Hinted, 98L)
  expect_gte(k2HintRows, 30L)
  expect_gte(pxHinted, 81L)
  expect_gte(pxHintRows, 32L)
})
