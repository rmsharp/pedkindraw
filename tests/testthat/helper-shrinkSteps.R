## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). It serves the tests of the four exports
## that give shrinkPedigree()'s answer one step at a time: bitSize(),
## findUnavailable(), findAvailNonInform() and findAvailAffected().

## The fixture pedigrees (helper-fixtures.R, helper-qcdRhesusPed.R). smallPed
## has an animal with one known parent, which kinship2 refuses, so the kinship2
## comparisons use the others.
shrinkStepPedigrees <- function(forKinship2 = FALSE) {
  peds <- list(
    lacy1989Ped = lacy1989Ped,
    smallPed = smallPed,
    qcPed = qcPed,
    pedWithGenotype = pedWithGenotype,
    rhesusPedigree = rhesusPedigree,
    qcdRhesusPed = qcdRhesusPed(),
    examplePedigree = examplePedigree
  )
  if (forKinship2) peds$smallPed <- NULL
  peds
}

## Genotyped patterns for a pedigree of n animals, each drawn from a fixed seed
## so every run tests the same cases: none, all, and about 30, 60 and 90
## percent genotyped.
shrinkStepGenotyped <- function(n) {
  draw <- function(seed, share) withr::with_seed(seed, stats::runif(n) < share)
  list(none = rep(FALSE, n), all = rep(TRUE, n), r30 = draw(30L, 0.3),
       r60 = draw(60L, 0.6), r90 = draw(90L, 0.9))
}

## An affected status per animal from a fixed seed: FALSE, TRUE or NA.
shrinkStepAffected <- function(n, seed = 7L) {
  withr::with_seed(seed, sample(c(FALSE, TRUE, NA), n, replace = TRUE,
                                prob = c(0.6, 0.3, 0.1)))
}

## shrinkPedigree()'s third step walked one removal at a time. maxBits = Inf
## stops shrinkPedigree() after its first two steps; from that pedigree,
## findAvailAffected() removes one animal per round, trying an NA affected
## status first, then FALSE, then TRUE (shrinkPedigree()'s order), until the
## bit size is within maxBits or no animal can be removed.
walkThirdTrim <- function(ped, genotyped, affected, maxBits) {
  firstTwo <- shrinkPedigree(ped, genotyped, affected = affected,
                             maxBits = Inf)
  current <- firstTwo$ped
  currentGenotyped <- unname(firstTwo$genotyped)
  currentAffected <- affected[match(current$id, as.character(ped$id))]
  bitSizes <- firstTwo$bitSize
  trimmed <- character(0L)
  while (bitSizes[length(bitSizes)] > maxBits && nrow(current) > 0L) {
    step <- NULL
    for (status in list(NA, FALSE, TRUE)) {
      step <- findAvailAffected(current, currentGenotyped, currentAffected,
                                status)
      if (step$isTrimmed) break
    }
    if (!step$isTrimmed) break
    trimmed <- c(trimmed, step$idTrimmed)
    bitSizes <- c(bitSizes, step$bitSize)
    kept <- match(step$ped$id, current$id)
    currentGenotyped <- currentGenotyped[kept]
    currentAffected <- currentAffected[kept]
    current <- step$ped
  }
  list(ped = current, idTrimmed = trimmed, bitSize = bitSizes)
}

## A kinship2 pedigree object made from one of this package's pedigrees. Sex
## comes from each animal's role (a dam is female, every other animal male),
## which kinship2 checks for parents and the shrink steps never read; an
## unknown parent is "0". affected is FALSE, TRUE or NA per animal.
asKinship2Pedigree <- function(ped, affected) {
  id <- as.character(ped$id)
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  sex <- ifelse(id %in% dam, 2L, 1L)
  sire[is.na(sire)] <- "0"
  dam[is.na(dam)] <- "0"
  kinship2::pedigree(id = id, dadid = sire, momid = dam, sex = sex,
                     affected = as.integer(affected), missid = "0")
}

## kinship2's pedigree.shrink() returns each idList element as one string of
## ids joined by spaces; this splits it back into ids.
splitKinship2Ids <- function(x) {
  x <- as.character(x)
  if (length(x) == 0L || all(!nzchar(x))) return(character(0L))
  unlist(strsplit(x, " ", fixed = TRUE), use.names = FALSE)
}
