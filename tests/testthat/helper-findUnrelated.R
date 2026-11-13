## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase 13,
## rulings R52-R54, pedkindraw S18). It serves test_findUnrelated.R: seeded
## random pedigrees with some animals genotyped, a slow check written from the
## definition with kinship(), and kinship2's pedigree.unrelated() on the same
## data (run only where kinship2 is installed, R7, R28).

## A seeded random pedigree of 6 to 200 animals (checkPedigreeClean() in
## helper-checkPedigree.R: no problems, both parents or none) with 10, 30, 50,
## 80 or 100 percent of its animals genotyped.
findUnrelatedRandomCase <- function(seed) {
  withr::with_seed(seed, {
    ped <- checkPedigreeClean(sample(6L:200L, 1L))
    share <- sample(c(0.1, 0.3, 0.5, 0.8, 1), 1L)
    list(ped = ped, genotyped = stats::runif(nrow(ped)) < share)
  })
}

## The slow check, from the definition (R53), with the package's kinship():
## every chosen animal is genotyped, every two chosen animals have kinship 0,
## no genotyped animal left out has kinship 0 with all of them, and no chosen
## animal can be traded for two left-out animals that have kinship 0 with
## each other and with every other chosen animal.
findUnrelatedSlow <- function(ped, genotyped, chosen) {
  id <- as.character(ped$id)
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  kin <- kinship(id, sire, dam, findGeneration(id, sire, dam))
  related <- function(a, b) kin[a, b] > 0
  left <- setdiff(id[genotyped], chosen)
  among <- kin[chosen, chosen, drop = FALSE]
  noTrade <- vapply(chosen, function(v) {
    others <- setdiff(chosen, v)
    free <- left[vapply(left, function(u) {
      related(u, v) && !any(related(u, others))
    }, logical(1L))]
    if (length(free) < 2L) {
      return(TRUE)
    }
    all(kin[free, free][upper.tri(kin[free, free])] > 0)
  }, logical(1L))
  c(
    genotyped = all(chosen %in% id[genotyped]),
    unrelated = all(among[upper.tri(among)] == 0),
    maximal = all(vapply(left, function(u) any(related(u, chosen)),
                         logical(1L))),
    noTrade = all(noTrade)
  )
}

## kinship2's pedigree.unrelated() on the same data (sex M 1, F 2, anything
## else 3), from set.seed(seed), under a 10 s time limit: the ids it chose, or
## NULL when it stops.
kinship2Unrelated <- function(ped, genotyped, seed) {
  sexCode <- ifelse(ped$sex %in% "M", 1L, ifelse(ped$sex %in% "F", 2L, 3L))
  setTimeLimit(elapsed = 10, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf))
  tryCatch(withr::with_seed(seed, {
    p <- kinship2::pedigree(id = ped$id, dadid = ped$sire, momid = ped$dam,
                            sex = sexCode)
    as.character(kinship2::pedigree.unrelated(p,
                                              avail = as.integer(genotyped)))
  }), error = function(e) NULL)
}

## kinship2's sample.ped family f with its unknown parents NA, and its avail.
kinship2SampleFamily <- function(f) {
  sp <- get(utils::data("sample.ped", package = "kinship2",
                        envir = environment()))
  sp <- sp[sp$ped == f, ]
  list(
    ped = data.frame(id = as.character(sp$id),
                     sire = ifelse(sp$father == 0, NA, as.character(sp$father)),
                     dam = ifelse(sp$mother == 0, NA, as.character(sp$mother)),
                     stringsAsFactors = FALSE),
    genotyped = sp$avail == 1L
  )
}

## The rhesus fixture (the comparison's rhesus375, same rows in the same
## order) with 30 percent genotyped as the comparison drew them.
findUnrelatedRhesus <- function() {
  ped <- utils::read.csv(test_path("fixtures", "obfuscated_rhesus_mhc_ped.csv"),
                         stringsAsFactors = FALSE)
  list(ped = ped,
       genotyped = withr::with_seed(42L, stats::runif(nrow(ped)) < 0.3))
}
