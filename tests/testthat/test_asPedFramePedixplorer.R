## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 14,
## rulings R58-R59, pedkindraw S20): asPedFrame() for Pedixplorer's Pedigree
## objects. Every expected value was computed with a scratch prototype before
## RED (Learning 18). The tests that build Pedixplorer objects skip without
## Pedixplorer (R7); the refusal of a non-S4 Pedigree and the stop without
## Pedixplorer do not. Plan Phase 15c (R62, pedkindraw S24): the tests
## comparing the whole returned list expect its third element, hints, NULL
## (none of these objects holds hints). Plan Phase G15c (R141, pedkindraw
## S67): and its fourth, matings, NULL (none holds a spouse pair); the
## Spouse rows come back in matings (test_asPedFrameMatings.R).

## Five animals with founders listed after their offspring, and a
## hermaphrodite, which Pedixplorer holds as unknown.
asPedFramePxFive <- function() {
  data.frame(id = c("C", "A", "B", "E", "D"),
             dadid = c("A", NA, NA, "C", NA),
             momid = c("B", NA, NA, "D", NA),
             sex = c("male", "male", "female", "unknown", "female"),
             stringsAsFactors = FALSE)
}

test_that("a Pedigree that is not Pedixplorer's S4 object is refused", {
  expect_error(asPedFrame(structure(list(), class = "Pedigree")),
               paste0("asPedFrame(): cannot convert an object of class ",
                      "\"Pedigree\"; it converts kinship2's pedigree and ",
                      "pedigreeList objects and Pedixplorer's Pedigree ",
                      "objects"), fixed = TRUE)
})

test_that("the Pedixplorer method stops when Pedixplorer is not installed", {
  local_mocked_bindings(.asPedFrameHasPedixplorer = function() FALSE)
  ## An S4 object of class Pedigree that needs no Pedixplorer to exist.
  x <- asS4(structure(list(), class = "Pedigree"))
  expect_error(asPedFrame(x),
               paste0("asPedFrame(): converting a Pedixplorer Pedigree ",
                      "object needs the Pedixplorer package, which is not ",
                      "installed"), fixed = TRUE)
})

test_that("ids, parents and sex in the object's order; nothing else", {
  skip_if_not_installed("Pedixplorer")
  p <- Pedixplorer::Pedigree(asPedFramePxFive())
  ## The comparison's required case: an object built with no condition holds
  ## an all-NA affection condition, which is not a condition.
  expect_identical(Pedixplorer::fill(p)$column_values, "affection")
  expect_true(all(is.na(Pedixplorer::fill(p)$mods)))
  expect_identical(
    asPedFrame(p),
    list(ped = data.frame(id = c("C", "A", "B", "E", "D"),
                          sire = c("A", NA, NA, "C", NA),
                          dam = c("B", NA, NA, "D", NA),
                          sex = c("M", "M", "F", "U", "F"),
                          stringsAsFactors = FALSE),
         twinRelations = NULL, hints = NULL, matings = NULL)
  )
})

test_that("conditions: affection becomes affected, others affected_<name>", {
  skip_if_not_installed("Pedixplorer")
  d <- asPedFramePxFive()
  d$affected <- c(1, 0, NA, 1, 0)
  expect_identical(asPedFrame(Pedixplorer::Pedigree(d))$ped$affected,
                   c(1, 0, NA, 1, 0))
  ## A number is split at Pedixplorer's threshold, 0.5 by default.
  d$affected <- c(0.2, 0.9, NA, 0.5, 0.6)
  expect_identical(asPedFrame(Pedixplorer::Pedigree(d))$ped$affected,
                   c(0, 1, NA, 0, 1))
  d$affected <- NULL
  d$cancer <- c(1, 0, NA, 1, 0)
  d$diabetes <- c(0, 0, 1, NA, NA)
  d$affected_eye <- c(NA, 1, 1, 0, 0)
  ped <- asPedFrame(Pedixplorer::Pedigree(
    d, col_aff = c("diabetes", "cancer", "affected_eye")
  ))$ped
  expect_identical(names(ped), c("id", "sire", "dam", "sex",
                                 "affected_diabetes", "affected_cancer",
                                 "affected_eye"))
  expect_identical(ped$affected_diabetes, c(0, 0, 1, NA, NA))
  expect_identical(ped$affected_cancer, c(1, 0, NA, 1, 0))
  expect_identical(ped$affected_eye, c(NA, 1, 1, 0, 0))
})

test_that("a condition with no known value is left out", {
  skip_if_not_installed("Pedixplorer")
  d <- asPedFramePxFive()
  d$cancer <- NA_real_
  d$diabetes <- c(0, 0, 1, NA, NA)
  p <- Pedixplorer::Pedigree(d, col_aff = c("cancer", "diabetes"))
  expect_setequal(Pedixplorer::fill(p)$column_values, c("cancer", "diabetes"))
  ped <- asPedFrame(p)$ped
  expect_identical(names(ped), c("id", "sire", "dam", "sex",
                                 "affected_diabetes"))
  p <- Pedixplorer::Pedigree(d, col_aff = "cancer")
  expect_identical(names(asPedFrame(p)$ped),
                   c("id", "sire", "dam", "sex", "diabetes"))
})

test_that("status: TRUE DECEASED, FALSE ALIVE, NA NA; all unknown, none", {
  skip_if_not_installed("Pedixplorer")
  d <- asPedFramePxFive()
  d$status <- c(TRUE, FALSE, NA, FALSE, TRUE)
  expect_identical(asPedFrame(Pedixplorer::Pedigree(d))$ped$status,
                   c("DECEASED", "ALIVE", NA, "ALIVE", "DECEASED"))
  d$status <- NA
  expect_false("status" %in% names(asPedFrame(Pedixplorer::Pedigree(d))$ped))
})

test_that("families: ids as Pedixplorer holds them, with famid", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C", "D", "A", "B", "C", "D"),
                  famid = rep(c("f1", "f2"), each = 4L),
                  dadid = c(NA, NA, "A", "A", NA, NA, "A", "A"),
                  momid = c(NA, NA, "B", "B", NA, NA, "B", "B"),
                  sex = c(1, 2, 1, 1, 1, 2, 2, 2))
  rel <- data.frame(id1 = c("C", "C"), id2 = c("D", "D"), code = c(1, 3),
                    famid = c("f1", "f2"))
  expect_identical(
    asPedFrame(Pedixplorer::Pedigree(d, rel_df = rel)),
    list(ped = data.frame(id = paste(d$famid, d$id, sep = "_"),
                          sire = c(NA, NA, "f1_A", "f1_A",
                                   NA, NA, "f2_A", "f2_A"),
                          dam = c(NA, NA, "f1_B", "f1_B",
                                  NA, NA, "f2_B", "f2_B"),
                          sex = c("M", "F", "M", "M", "M", "F", "F", "F"),
                          famid = d$famid, stringsAsFactors = FALSE),
         twinRelations = data.frame(id1 = c("f1_C", "f2_C"),
                                    id2 = c("f1_D", "f2_D"),
                                    code = c("MZ twin", "UZ twin"),
                                    stringsAsFactors = FALSE),
         hints = NULL, matings = NULL)
  )
})

test_that("twins from rel(x), codes MZ, DZ and UZ; spouses in matings", {
  skip_if_not_installed("Pedixplorer")
  ## An animal is in one twin set only: Pedixplorer refuses one in two sets
  ## with different codes.
  d <- data.frame(id = c("A", "B", "C", "D", "E", "F", "G", "H"),
                  dadid = c(NA, NA, "A", "A", "A", "A", "A", "A"),
                  momid = c(NA, NA, "B", "B", "B", "B", "B", "B"),
                  sex = c(1, 2, 1, 1, 2, 2, 1, 2))
  rel <- data.frame(id1 = c("C", "E", "A", "G"), id2 = c("D", "F", "B", "H"),
                    code = c(1, 2, 4, 3))
  expect_identical(
    asPedFrame(Pedixplorer::Pedigree(d, rel_df = rel))$twinRelations,
    data.frame(id1 = c("C", "E", "G"), id2 = c("D", "F", "H"),
               code = c("MZ twin", "DZ twin", "UZ twin"),
               stringsAsFactors = FALSE)
  )
  pair <- data.frame(sire = "A", dam = "B", stringsAsFactors = FALSE)
  expect_identical(
    asPedFrame(Pedixplorer::Pedigree(d, rel_df = rel))$matings, pair
  )
  spouses <- Pedixplorer::Pedigree(d, rel_df = rel[3L, ])
  expect_identical(as.character(Pedixplorer::rel(spouses, "code")), "Spouse")
  expect_null(asPedFrame(spouses)$twinRelations)
  expect_identical(asPedFrame(spouses)$matings, pair)
})

test_that("Pedixplorer's fields are kept when not all its filled-in value", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C"), dadid = c(NA, NA, "A"),
                  momid = c(NA, NA, "B"), sex = c(1, 2, 1),
                  birth = c("2001-01-02", NA, "2005-03-04"),
                  available = c(TRUE, FALSE, NA),
                  proband = c(FALSE, FALSE, TRUE),
                  fertility = c("fertile", "fertile", "infertile"),
                  stringsAsFactors = FALSE)
  ped <- asPedFrame(Pedixplorer::Pedigree(d))$ped
  expect_identical(names(ped), c("id", "sire", "dam", "sex", "fertility",
                                 "avail", "proband", "dateofbirth"))
  expect_identical(ped$fertility,
                   factor(c("fertile", "fertile", "infertile"),
                          levels = c("infertile_choice_na", "infertile",
                                     "fertile")))
  expect_identical(ped$avail, c(TRUE, FALSE, NA))
  expect_identical(ped$proband, c(FALSE, FALSE, TRUE))
  expect_identical(ped$dateofbirth, c("2001-01-02", NA, "2005-03-04"))
})

test_that("extra columns are kept with their types, Pedixplorer's left out", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C"), dadid = c(NA, NA, "A"),
                  momid = c(NA, NA, "B"), sex = c(1, 2, 1),
                  status = c(FALSE, TRUE, FALSE), affected = c(0, 1, NA),
                  name = c("x", "y", "z"), weight = c(1.5, NA, 3),
                  litter = 1:3, flag = c(TRUE, FALSE, NA),
                  colony = factor(c("p", "q", "p")),
                  exit = as.Date(c("2020-01-01", NA, "2021-02-03")),
                  stringsAsFactors = FALSE)
  p <- Pedixplorer::Pedigree(d)
  expect_true(all(c("error", "affection", "affection_mods", "avail_mods") %in%
                    names(Pedixplorer::mcols(p))))
  expect_identical(
    asPedFrame(p)$ped,
    data.frame(id = c("A", "B", "C"), sire = c(NA, NA, "A"),
               dam = c(NA, NA, "B"), sex = c("M", "F", "M"),
               affected = c(0, 1, NA),
               status = c("ALIVE", "DECEASED", "ALIVE"),
               name = d$name, weight = d$weight, litter = d$litter,
               flag = d$flag, colony = d$colony, exit = d$exit,
               stringsAsFactors = FALSE)
  )
})

test_that("a column name that would appear twice stops, naming it", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C"), dadid = c(NA, NA, "A"),
                  momid = c(NA, NA, "B"), sex = c(1, 2, 1),
                  sire = c("x", "y", "z"), cancer = c(1, 0, 1),
                  affected_cancer = c("a", "b", "c"))
  expect_error(asPedFrame(Pedixplorer::Pedigree(d, col_aff = "cancer")),
               paste0("asPedFrame(): column names would appear twice: sire, ",
                      "affected_cancer"), fixed = TRUE)
})

test_that("an empty Pedigree gives no rows", {
  skip_if_not_installed("Pedixplorer")
  p <- Pedixplorer::Pedigree(data.frame(id = character(), dadid = character(),
                                        momid = character(),
                                        sex = character()))
  result <- asPedFrame(p)
  expect_identical(nrow(result$ped), 0L)
  expect_identical(result$ped[c("id", "sire", "dam", "sex")],
                   data.frame(id = character(), sire = character(),
                              dam = character(), sex = character(),
                              stringsAsFactors = FALSE))
  expect_null(result$twinRelations)
})

test_that("the round trip on the fixture pedigrees gives them back", {
  skip_if_not_installed("Pedixplorer")
  fixtures <- asPedFrameFixtures()
  twins <- utils::read.csv(
    test_path("fixtures", "obfuscated_rhesus_mhc_twin_relations.csv"),
    stringsAsFactors = FALSE
  )
  trips <- 0L
  for (name in names(fixtures)) {
    f <- asPedFrameForKinship2(fixtures[[name]])
    fTwins <- NULL
    if (name == "rhesusPedigree") {
      fTwins <- asPedFramePxTwins(f, twins)
      expect_identical(nrow(fTwins), 2L)
    }
    for (cond in c("none", "one", "two")) {
      for (withStatus in c(FALSE, TRUE)) {
        for (family in c(FALSE, TRUE)) {
          trip <- asPedFramePxTrip(f, cond, withStatus, family, fTwins)
          expect_identical(trip$got, trip$want,
                           label = paste(name, cond, withStatus, family))
          trips <- trips + 1L
        }
      }
    }
  }
  expect_identical(trips, 108L)
})

test_that("the round trip on 100 seeded random pedigrees gives them back", {
  skip_if_not_installed("Pedixplorer")
  for (seed in 1:100) {
    trip <- asPedFramePxTrip(asPedFrameRandomCase(seed),
                             c("none", "one", "two")[seed %% 3L + 1L],
                             seed %% 2L == 0L, seed %% 5L == 0L, seed = seed)
    expect_identical(trip$got, trip$want, label = paste("seed", seed))
  }
})
