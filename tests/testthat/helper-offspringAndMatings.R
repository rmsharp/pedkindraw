## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helpers, not copied from nprcgenekeepr (plan Phase
## G6, gap C5, pedkindraw S47), for test_countOffspring.R and
## test_getMatings.R: the typed pedigrees, seeded random ones, and slow
## versions of each count and mating written from their definitions, which
## agreed with the functions on 311 of 311 pedigrees before RED (S47).

## The gap case lookups (tools/gapCases.R): A and B, founders, with offspring
## C and D.
lookupsPed <- function() {
  data.frame(id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
             dam = c(NA, NA, "B", "B"), stringsAsFactors = FALSE)
}

## A and B have C; A and E have F; A has G, its dam unknown; B has H, its sire
## unknown; K and E have I. A and E have two mates each.
halfSibsPed <- function() {
  data.frame(id = c("A", "B", "E", "K", "C", "F", "G", "H", "I"),
             sire = c(NA, NA, NA, NA, "A", "A", "A", NA, "K"),
             dam = c(NA, NA, NA, NA, "B", "E", NA, "B", "E"),
             stringsAsFactors = FALSE)
}

## X sires P with Y, and is the dam of Q by Y: each recorded as both a sire
## and a dam, which checkPedigree() reports.
sireAndDamPed <- function() {
  data.frame(id = c("X", "Y", "P", "Q"), sire = c(NA, NA, "X", "Y"),
             dam = c(NA, NA, "Y", "X"), stringsAsFactors = FALSE)
}

## n animals in birth order; each later one gets a sire from the earlier
## males and a dam from the earlier females, each 7 times in 10.
randomMatingPed <- function(n) {
  id <- sprintf("a%03d", seq_len(n))
  sex <- sample(c("M", "F"), n, replace = TRUE)
  sire <- rep(NA_character_, n)
  dam <- rep(NA_character_, n)
  for (k in seq_len(n)[-1L]) {
    earlier <- seq_len(k - 1L)
    males <- id[earlier][sex[earlier] == "M"]
    females <- id[earlier][sex[earlier] == "F"]
    if (length(males) > 0L && stats::runif(1L) < 0.7) {
      sire[k] <- males[sample.int(length(males), 1L)]
    }
    if (length(females) > 0L && stats::runif(1L) < 0.7) {
      dam[k] <- females[sample.int(length(females), 1L)]
    }
  }
  data.frame(id = id, sire = sire, dam = dam, sex = sex,
             stringsAsFactors = FALSE)
}

## The fixture pedigrees with id, sire and dam columns.
matingFixturePeds <- function() {
  list(examplePedigree = examplePedigree, lacy1989Ped = lacy1989Ped,
       pedWithGenotype = pedWithGenotype, qcdRhesusPed = qcdRhesusPed(),
       qcPed = qcPed, rhesusPedigree = rhesusPedigree, smallPed = smallPed)
}

## The pedigrees the agreement tests run on: the fixture pedigrees, then 100
## seeded random ones named random1 to random100.
matingCheckPeds <- function() {
  peds <- matingFixturePeds()
  withr::with_seed(47L, {
    for (k in seq_len(100L)) {
      peds[[paste0("random", k)]] <- randomMatingPed(sample(3:150, 1L))
    }
  })
  peds
}

## Slow count: the number of distinct animals getOffspring() lists.
countOffspringSlow <- function(ped, ids) {
  vapply(as.character(ids), function(i) length(unique(getOffspring(ped, i))),
         integer(1L))
}

## Slow mates: the other parent of each of an animal's offspring that has
## both parents known, sorted.
matesSlow <- function(ped, id) {
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  both <- !is.na(sire) & !is.na(dam)
  sort(unique(c(dam[both & sire == id], sire[both & dam == id])))
}

## The matings the drawing's layout builds (sire and dam of each mating unit,
## in its order), for a pedigree with id, sire and dam.
layoutMatings <- function(ped) {
  p <- data.frame(id = as.character(ped$id), sire = as.character(ped$sire),
                  dam = as.character(ped$dam), sex = "U", gen = 0L,
                  stringsAsFactors = FALSE)
  units <- .buildMatingUnitForest(p)$matingUnits
  data.frame(sire = units$sire, dam = units$dam, stringsAsFactors = FALSE)
}
