## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 14,
## rulings R55-R57, pedkindraw S19): asPedFrame() for kinship2's pedigree and
## pedigreeList objects. Every expected value was computed with a scratch
## prototype before RED (Learning 18). The tests that build kinship2 objects
## skip without kinship2 (R7, R28); those on hand-built objects do not, since
## the methods read the object without kinship2 (R55).

## Seven animals with founders listed between their offspring: an unknown
## parent's index 0 comes before known indexes in findex and mindex.
asPedFrameSeven <- function() {
  data.frame(id = c("A", "B", "C", "D", "E", "F", "G"),
             sire = c(NA, NA, "A", NA, "A", "C", "C"),
             dam = c(NA, NA, "B", NA, "B", "D", "D"),
             sex = c("male", "female", "male", "female", "female", "male",
                     "male"),
             stringsAsFactors = FALSE)
}

test_that("asPedFrame() refuses any other class, naming it", {
  expect_error(asPedFrame(data.frame(id = "A")),
               paste0("asPedFrame(): cannot convert an object of class ",
                      "\"data.frame\"; it converts kinship2's pedigree and ",
                      "pedigreeList objects and Pedixplorer's Pedigree ",
                      "objects"), fixed = TRUE)
  expect_error(asPedFrame(NULL), "class \"NULL\"", fixed = TRUE)
  expect_error(asPedFrame(list(id = "A")), "class \"list\"", fixed = TRUE)
  expect_error(asPedFrame("A"), "class \"character\"", fixed = TRUE)
  expect_error(asPedFrame(structure(list(), class = c("foo", "bar"))),
               "class \"foo\", \"bar\";", fixed = TRUE)
})

test_that("a hand-built pedigree list converts without calling kinship2", {
  x <- structure(list(
    id = c("A", "B", "C"), findex = c(0L, 0L, 1L), mindex = c(0L, 0L, 2L),
    sex = factor(c("male", "female", "unknown"),
                 levels = c("male", "female", "unknown", "terminated"))
  ), class = "pedigree")
  expect_identical(
    asPedFrame(x),
    list(ped = data.frame(id = c("A", "B", "C"), sire = c(NA, NA, "A"),
                          dam = c(NA, NA, "B"), sex = c("M", "F", "U"),
                          stringsAsFactors = FALSE),
         twinRelations = NULL)
  )
})

test_that("an object lacking a field it needs stops, naming the fields", {
  expect_error(asPedFrame(structure(list(id = "A"), class = "pedigree")),
               "asPedFrame(): the object lacks findex, mindex, sex",
               fixed = TRUE)
  noFamid <- structure(list(id = "A", findex = 0L, mindex = 0L,
                            sex = factor("male")), class = "pedigreeList")
  expect_error(asPedFrame(noFamid), "asPedFrame(): the object lacks famid",
               fixed = TRUE)
})

test_that("each parent is read by its own index (unknown parents first)", {
  skip_if_not_installed("kinship2")
  s <- asPedFrameSeven()
  p <- kinship2::pedigree(s$id, s$sire, s$dam, s$sex)
  expect_identical(
    asPedFrame(p),
    list(ped = data.frame(id = s$id, sire = s$sire, dam = s$dam,
                          sex = c("M", "F", "M", "F", "F", "M", "M"),
                          stringsAsFactors = FALSE),
         twinRelations = NULL)
  )
})

test_that("sex: male M, female F, unknown U, terminated U", {
  skip_if_not_installed("kinship2")
  p <- kinship2::pedigree(c("a", "b", "c", "d"), rep(NA, 4L), rep(NA, 4L),
                          1:4)
  expect_identical(as.character(p$sex),
                   c("male", "female", "unknown", "terminated"))
  expect_identical(asPedFrame(p)$ped$sex, c("M", "F", "U", "U"))
})

test_that("ids: factor labels, and whole numbers written in full", {
  skip_if_not_installed("kinship2")
  s <- asPedFrameSeven()
  p <- kinship2::pedigree(factor(s$id), factor(s$sire), factor(s$dam), s$sex)
  expect_identical(asPedFrame(p)$ped[c("id", "sire", "dam")],
                   s[c("id", "sire", "dam")])
  p <- kinship2::pedigree(c(100000, 200000, 300001, 10, 2),
                          c(0, 0, 100000, 0, 100000),
                          c(0, 0, 200000, 0, 10), c(1, 2, 1, 2, 2))
  expect_identical(
    asPedFrame(p)$ped[c("id", "sire", "dam")],
    data.frame(id = c("100000", "200000", "300001", "10", "2"),
               sire = c(NA, NA, "100000", NA, "100000"),
               dam = c(NA, NA, "200000", NA, "10"),
               stringsAsFactors = FALSE)
  )
})

test_that("one condition becomes affected, with kinship2's 0, 1 and NA", {
  skip_if_not_installed("kinship2")
  s <- asPedFrameSeven()
  p <- kinship2::pedigree(s$id, s$sire, s$dam, s$sex,
                          affected = c(1, 0, NA, 1, 0, 1, 0))
  expect_identical(names(asPedFrame(p)$ped),
                   c("id", "sire", "dam", "sex", "affected"))
  expect_identical(asPedFrame(p)$ped$affected, c(1, 0, NA, 1, 0, 1, 0))
  p <- kinship2::pedigree(s$id, s$sire, s$dam, s$sex,
                          affected = c(TRUE, FALSE, NA, TRUE, FALSE, FALSE,
                                       TRUE))
  expect_identical(asPedFrame(p)$ped$affected, c(1, 0, NA, 1, 0, 0, 1))
})

test_that("a condition matrix becomes affected_<column name or number>", {
  skip_if_not_installed("kinship2")
  s <- asPedFrameSeven()
  aff <- cbind(c(1, 0, NA, 1, 0, 1, 0), c(0, 0, 1, NA, 1, 0, 1))
  p <- kinship2::pedigree(s$id, s$sire, s$dam, s$sex,
                          affected = `colnames<-`(aff, c("cancer", "diabetes")))
  ped <- asPedFrame(p)$ped
  expect_identical(names(ped), c("id", "sire", "dam", "sex",
                                 "affected_cancer", "affected_diabetes"))
  expect_identical(ped$affected_cancer, aff[, 1L])
  expect_identical(ped$affected_diabetes, aff[, 2L])
  ped <- asPedFrame(kinship2::pedigree(s$id, s$sire, s$dam, s$sex,
                                       affected = aff))$ped
  expect_identical(names(ped), c("id", "sire", "dam", "sex", "affected_1",
                                 "affected_2"))
  expect_identical(ped$affected_2, aff[, 2L])
  ped <- asPedFrame(kinship2::pedigree(s$id, s$sire, s$dam, s$sex,
                                       affected = aff[, 1L, drop = FALSE] |>
                                         `colnames<-`("t1")))$ped
  expect_identical(names(ped), c("id", "sire", "dam", "sex", "affected_t1"))
})

test_that("status: 1 DECEASED, 0 ALIVE; no status, no column", {
  skip_if_not_installed("kinship2")
  s <- asPedFrameSeven()
  p <- kinship2::pedigree(s$id, s$sire, s$dam, s$sex,
                          status = c(1, 0, 0, 1, 0, 0, 1))
  expect_identical(asPedFrame(p)$ped$status,
                   c("DECEASED", "ALIVE", "ALIVE", "DECEASED", "ALIVE",
                     "ALIVE", "DECEASED"))
  p <- kinship2::pedigree(s$id, s$sire, s$dam, s$sex,
                          affected = c(1, 0, 0, 0, 0, 0, 0),
                          status = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE,
                                     FALSE))
  expect_identical(names(asPedFrame(p)$ped),
                   c("id", "sire", "dam", "sex", "affected", "status"))
  expect_identical(asPedFrame(p)$ped$status[1:2], c("DECEASED", "ALIVE"))
  p <- kinship2::pedigree(s$id, s$sire, s$dam, s$sex)
  expect_identical(names(asPedFrame(p)$ped), c("id", "sire", "dam", "sex"))
})

test_that("twins from relation codes 1-3, numbers or text; spouses left out", {
  skip_if_not_installed("kinship2")
  id <- c("P1", "P2", "T1", "T2", "T3", "T4", "T5", "T6")
  sire <- c(NA, NA, rep("P1", 6L))
  dam <- c(NA, NA, rep("P2", 6L))
  sex <- c("male", "female", "male", "male", "female", "male", "female",
           "female")
  want <- data.frame(id1 = c("T1", "T3", "T5"), id2 = c("T2", "T4", "T6"),
                     code = c("MZ twin", "DZ twin", "UZ twin"),
                     stringsAsFactors = FALSE)
  rel <- data.frame(id1 = c("T1", "T3", "P1", "T5"),
                    id2 = c("T2", "T4", "P2", "T6"), code = c(1, 2, 4, 3))
  p <- kinship2::pedigree(id, sire, dam, sex, relation = rel)
  expect_identical(asPedFrame(p)$twinRelations, want)
  rel$code <- c("MZ twin", "DZ twin", "spouse", "UZ twin")
  p <- kinship2::pedigree(id, sire, dam, sex, relation = rel)
  expect_identical(asPedFrame(p)$twinRelations, want)
  p <- kinship2::pedigree(id, sire, dam, sex, relation = rel[3L, ])
  expect_null(asPedFrame(p)$twinRelations)
  expect_null(asPedFrame(kinship2::pedigree(id, sire, dam, sex))$twinRelations)
})

test_that("a pedigreeList converts whole, with famid, in the object's order", {
  skip_if_not_installed("kinship2")
  rel <- data.frame(id1 = c(13, 23), id2 = c(14, 24), code = c(1, 2),
                    famid = c(1, 2))
  pl <- kinship2::pedigree(c(11, 12, 13, 14, 21, 22, 23, 24),
                           c(0, 0, 11, 11, 0, 0, 21, 21),
                           c(0, 0, 12, 12, 0, 0, 22, 22),
                           c(1, 2, 1, 1, 1, 2, 2, 1),
                           affected = c(0, 1, 1, 0, NA, 0, 1, 1),
                           status = c(1, 0, 0, 0, 0, 0, 0, 1),
                           famid = c(1, 1, 1, 1, 2, 2, 2, 2), relation = rel)
  expect_identical(
    asPedFrame(pl),
    list(ped = data.frame(id = c("11", "12", "13", "14", "21", "22", "23",
                                 "24"),
                          sire = c(NA, NA, "11", "11", NA, NA, "21", "21"),
                          dam = c(NA, NA, "12", "12", NA, NA, "22", "22"),
                          sex = c("M", "F", "M", "M", "M", "F", "F", "M"),
                          famid = c("1", "1", "1", "1", "2", "2", "2", "2"),
                          affected = c(0, 1, 1, 0, NA, 0, 1, 1),
                          status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE",
                                     "ALIVE", "ALIVE", "ALIVE", "DECEASED"),
                          stringsAsFactors = FALSE),
         twinRelations = data.frame(id1 = c("13", "23"), id2 = c("14", "24"),
                                    code = c("MZ twin", "DZ twin"),
                                    stringsAsFactors = FALSE))
  )
})

test_that("a pedigreeList whose ids repeat across families stops", {
  skip_if_not_installed("kinship2")
  pl <- kinship2::pedigree(c(1, 2, 3, 1, 2, 3), c(0, 0, 1, 0, 0, 1),
                           c(0, 0, 2, 0, 0, 2), c(1, 2, 1, 1, 2, 2),
                           famid = c(1, 1, 1, 2, 2, 2))
  expect_error(asPedFrame(pl),
               "asPedFrame(): ids repeat across families: 1, 2, 3",
               fixed = TRUE)
  one <- asPedFrame(pl["2"])$ped
  expect_identical(one$id, c("1", "2", "3"))
  expect_identical(one$sire, c(NA, NA, "1"))
  ## Twelve founders in each of two families: the first ten in byte order.
  pl <- kinship2::pedigree(rep(1:12, 2L), rep(0L, 24L), rep(0L, 24L),
                           rep(1:2, 12L), famid = rep(1:2, each = 12L))
  expect_error(asPedFrame(pl),
               "across families: 1, 10, 11, 12, 2, 3, 4, 5, 6, 7$")
})

test_that("kinship2's sample.ped and minnbreast convert as family lists", {
  skip_if_not_installed("kinship2")
  sp <- get(utils::data("sample.ped", package = "kinship2",
                        envir = environment()))
  pl <- kinship2::pedigree(sp$id, sp$father, sp$mother, sp$sex,
                           affected = sp$affected, famid = sp$ped)
  ped <- asPedFrame(pl)$ped
  expect_identical(names(ped), c("id", "sire", "dam", "sex", "famid",
                                 "affected"))
  expect_identical(ped$id, as.character(sp$id))
  expect_identical(ped$sire, ifelse(sp$father == 0, NA,
                                    as.character(sp$father)))
  expect_identical(ped$dam, ifelse(sp$mother == 0, NA,
                                   as.character(sp$mother)))
  expect_identical(ped$famid, as.character(sp$ped))
  expect_identical(ped$sex, c("M", "F")[sp$sex])
  mb <- get(utils::data("minnbreast", package = "kinship2",
                        envir = environment()))
  ml <- kinship2::pedigree(mb$id, mb$fatherid, mb$motherid, mb$sex,
                           affected = cbind(cancer = mb$cancer,
                                            proband = mb$proband),
                           famid = mb$famid)
  ped <- asPedFrame(ml)$ped
  expect_identical(nrow(ped), 28081L)
  expect_identical(names(ped), c("id", "sire", "dam", "sex", "famid",
                                 "affected_cancer", "affected_proband"))
  expect_identical(ped$sire, ifelse(mb$fatherid == 0, NA,
                                    as.character(mb$fatherid)))
  expect_identical(ped$dam, ifelse(mb$motherid == 0, NA,
                                   as.character(mb$motherid)))
})

test_that("the round trip on the fixture pedigrees gives them back", {
  skip_if_not_installed("kinship2")
  fixtures <- asPedFrameFixtures()
  twins <- utils::read.csv(
    test_path("fixtures", "obfuscated_rhesus_mhc_twin_relations.csv"),
    stringsAsFactors = FALSE
  )
  trips <- 0L
  for (name in names(fixtures)) {
    f <- asPedFrameForKinship2(fixtures[[name]])
    for (cond in c("none", "one", "named", "unnamed")) {
      for (withStatus in c(FALSE, TRUE)) {
        trip <- asPedFrameTrip(f, cond, withStatus,
                               twins = if (name == "rhesusPedigree") twins)
        expect_identical(trip$got, trip$want,
                         label = paste(name, cond, withStatus))
        trips <- trips + 1L
      }
    }
  }
  expect_identical(trips, 72L)
})

test_that("the round trip on 300 seeded random pedigrees gives them back", {
  skip_if_not_installed("kinship2")
  for (seed in 1:300) {
    trip <- asPedFrameTrip(asPedFrameRandomCase(seed),
                           c("none", "one", "named", "unnamed")[seed %% 4L + 1L],
                           seed %% 2L == 0L, seed = seed)
    expect_identical(trip$got, trip$want, label = paste("seed", seed))
  }
})
