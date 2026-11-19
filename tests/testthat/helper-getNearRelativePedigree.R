## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase
## G11, gap C1, rulings R129-R130, pedkindraw S52). It serves
## test_getNearRelativePedigree.R: typed pedigrees, seeded random pedigrees
## with probands, a slow version written from the definition with kinship(),
## and Pedixplorer's useful_inds() on the same data (run only where
## Pedixplorer is installed, R7).

## The help example's family. O is the proband; F and M are its parents, S
## its sister and K its offspring by Q. G1 and G2 are F's parents, U is F's
## brother and C is U's offspring by X. S has N by Y and N2 by Z.
nearFamily <- function() {
  data.frame(
    id = c("G1", "G2", "F", "U", "M", "X", "O", "S", "Q", "K", "Y", "Z",
           "N", "N2", "C"),
    sire = c(NA, NA, "G1", "G1", NA, NA, "F", "F", NA, "O", NA, NA, "Y",
             "Z", "U"),
    dam = c(NA, NA, "G2", "G2", NA, NA, "M", "M", NA, "Q", NA, NA, "S",
            "S", "X"),
    sex = c("M", "F", "M", "M", "F", "F", "M", "F", "F", "M", "M", "M",
            "F", "M", "F"),
    stringsAsFactors = FALSE
  )
}

## I is the offspring of P and of P's daughter E (by D): I is at distance
## 0.678 from itself, P and E at 1.415, D at 3.
nearInbred <- function() {
  data.frame(
    id = c("P", "D", "E", "I"),
    sire = c(NA, NA, "P", "P"),
    dam = c(NA, NA, "D", "E"),
    sex = c("M", "F", "F", "M"),
    stringsAsFactors = FALSE
  )
}

## Brothers B1 and B2 (of G1 and G2) are the sires of C1 and C2 by sisters
## S1 and S2 (of H1 and H2), so C1 and C2 are double first cousins, at
## distance 3. V, B1's half-brother by W, is at 4; R, of V and S2, at 3.415.
nearCousins <- function() {
  data.frame(
    id = c("G1", "G2", "H1", "H2", "B1", "B2", "S1", "S2", "C1", "C2", "W",
           "V", "R"),
    sire = c(NA, NA, NA, NA, "G1", "G1", "H1", "H1", "B1", "B2", NA, "G1",
             "V"),
    dam = c(NA, NA, NA, NA, "G2", "G2", "H2", "H2", "S1", "S2", NA, "W",
            "S2"),
    sex = c("M", "F", "M", "F", "M", "M", "F", "F", "M", "F", "F", "M",
            "F"),
    stringsAsFactors = FALSE
  )
}

## A seeded random pedigree of 6 to 200 animals (checkPedigreeClean() in
## helper-checkPedigree.R: no problems, both parents or none), each animal
## genotyped and affected at random (each with chance 0.2, 0.5 or 0.8); the
## probands are the animals both genotyped and affected, Pedixplorer's
## default informative animals. The draws are those of S52's measure.
nearRandomCase <- function(seed) {
  withr::with_seed(seed, {
    ped <- checkPedigreeClean(sample(6L:200L, 1L))
    genotypedShare <- sample(c(0.2, 0.5, 0.8), 1L)
    affectedShare <- sample(c(0.2, 0.5, 0.8), 1L)
    genotyped <- stats::runif(nrow(ped)) < genotypedShare
    affected <- stats::runif(nrow(ped)) < affectedShare
    list(ped = ped, probands = ped$id[genotyped & affected])
  })
}

## The slow version, from the definition (plan R129), with the package's
## kinship(): the ids kept, in ped's order. An animal's distance is log2 of 1
## over its largest kinship with a proband; every animal within maxDist is
## kept, and each parent of one of them whose own offspring and its mates'
## offspring, counted once, number two or more.
nearRelativesSlow <- function(ped, probands, maxDist) {
  id <- as.character(ped$id)
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  chosen <- id %in% as.character(probands)
  if (!any(chosen)) {
    return(character(0L))
  }
  kin <- as.matrix(kinship(id, sire, dam, findGeneration(id, sire, dam)))
  distance <- log2(1 / apply(kin[, chosen, drop = FALSE], 1L, max))
  near <- distance <= maxDist
  familySize <- function(p) {
    own <- id[sire %in% p | dam %in% p]
    mates <- setdiff(c(sire[id %in% own], dam[id %in% own]), c(p, NA))
    length(union(own, id[sire %in% mates | dam %in% mates]))
  }
  parents <- setdiff(c(sire[near], dam[near]), c(id[near], NA))
  joining <- parents[vapply(parents, familySize, integer(1L)) >= 2L]
  id[near | id %in% joining]
}

## Pedixplorer's useful_inds(max_dist = ) at each of maxDists, with the
## probands as its informative animals (available and affected): a list of
## the ids it marks useful, one element per distance, or NULL when it stops
## (it stops when no animal is informative). The Pedigree object is built
## once: building it takes most of the time (S52: 5.8 s of 8.0 s on 100
## cases at five distances).
pedixplorerNear <- function(ped, probands, maxDists) {
  tryCatch({
    chosen <- as.integer(ped$id %in% probands)
    frame <- data.frame(id = ped$id, dadid = ped$sire, momid = ped$dam,
                        sex = match(ped$sex, c("M", "F"), nomatch = 3L),
                        affection = chosen, avail = chosen,
                        stringsAsFactors = FALSE)
    p <- suppressWarnings(Pedixplorer::Pedigree(frame))
    p <- Pedixplorer::is_informative(p, col_aff = "affection",
                                     informative = "AvAf")
    lapply(maxDists, function(maxDist) {
      useful <- Pedixplorer::ped(Pedixplorer::useful_inds(p,
                                                          max_dist = maxDist))
      Pedixplorer::id(useful)[Pedixplorer::useful(useful)]
    })
  }, error = function(e) NULL)
}

## Pedixplorer's sample family 1 (41 animals), the gap case distanceSubset of
## tools/gapCases.R: id, sire, dam and sex, an unknown parent NA; and its 7
## animals both available and affected.
nearSampleFamily <- function() {
  env <- new.env()
  utils::data("sampleped", package = "Pedixplorer", envir = env)
  sp <- env$sampleped[env$sampleped$famid == "1", ]
  sp$dadid[sp$dadid %in% c("", "0")] <- NA
  sp$momid[sp$momid %in% c("", "0")] <- NA
  ped <- data.frame(id = sp$id, sire = sp$dadid, dam = sp$momid,
                    sex = c("M", "F")[sp$sex], stringsAsFactors = FALSE)
  list(ped = ped, probands = sp$id[sp$avail %in% 1 & sp$affection %in% 1])
}
