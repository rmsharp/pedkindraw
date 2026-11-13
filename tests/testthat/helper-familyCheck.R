## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase 12,
## rulings R43-R45, pedkindraw S15). It serves test_familyCheck.R's
## comparisons with kinship2's familycheck() and makefamid(), which run only
## where kinship2 is installed (R7, R28).

## The fixture pedigrees (helper-fixtures.R, helper-qcdRhesusPed.R) as
## character vectors id, sire and dam. pedOne and pedSix name their first three
## columns differently.
familyCheckPedigrees <- function() {
  firstThree <- function(p) stats::setNames(p[1:3], c("id", "sire", "dam"))
  peds <- list(
    lacy1989Ped = lacy1989Ped,
    smallPed = smallPed,
    qcPed = qcPed,
    pedWithGenotype = pedWithGenotype,
    rhesusPedigree = rhesusPedigree,
    qcdRhesusPed = qcdRhesusPed(),
    examplePedigree = examplePedigree,
    pedOne = firstThree(pedOne),
    pedSix = firstThree(pedSix)
  )
  lapply(peds, function(p) {
    list(id = as.character(p$id), sire = as.character(p$sire),
         dam = as.character(p$dam))
  })
}

## Family ids to check on one pedigree: kinship2's family trees, one id for
## every animal, and three draws each (fixed seeds) of the trees with 5 or 30
## percent of the animals given a wrong family id, and of ids drawn at random
## from five.
familyCheckPatterns <- function(ped) {
  n <- length(ped$id)
  trees <- kinship2::makefamid(ped$id, ped$sire, ped$dam)
  wrong <- max(3L, trees)
  mislabel <- function(seed, share) {
    withr::with_seed(seed, {
      famid <- paste0("F", trees)
      i <- sample(n, ceiling(n * share))
      famid[i] <- paste0("F", sample(0:wrong, length(i), replace = TRUE))
      famid
    })
  }
  patterns <- list(trees = paste0("F", trees), one = rep("F", n))
  for (seed in 1:3) {
    patterns[[paste0("mislabel05_", seed)]] <- mislabel(seed, 0.05)
    patterns[[paste0("mislabel30_", seed)]] <- mislabel(seed, 0.3)
    patterns[[paste0("random_", seed)]] <- withr::with_seed(
      seed, paste0("R", sample(1:5, n, replace = TRUE))
    )
  }
  patterns
}

## A random pedigree of 5 to 120 animals from a fixed seed: each animal after
## the second has, with probability 0.6, a sire drawn from the rows above it,
## and then, with probability 0.9, a dam drawn the same way; the rows are then
## shuffled. Its family ids are kinship2's trees with up to a third of the
## animals given a wrong one.
familyCheckRandomCase <- function(seed) {
  withr::with_seed(seed, {
    n <- sample(5:120, 1L)
    id <- paste0("a", seq_len(n))
    sire <- dam <- rep(NA_character_, n)
    for (i in seq_len(n)) {
      if (i > 2L && stats::runif(1L) < 0.6) {
        sire[i] <- id[sample(i - 1L, 1L)]
        if (stats::runif(1L) < 0.9) dam[i] <- id[sample(i - 1L, 1L)]
      }
    }
    rows <- sample(n)
    id <- id[rows]
    sire <- sire[rows]
    dam <- dam[rows]
    trees <- kinship2::makefamid(id, sire, dam)
    famid <- paste0("F", trees)
    i <- sample(n, sample(0:ceiling(n / 3), 1L))
    famid[i] <- paste0("F", sample(0:(max(trees) + 2L), length(i),
                                   replace = TRUE))
    list(famid = famid, id = id, sire = sire, dam = dam)
  })
}

## A familycheck() or familyCheck() result in common terms: family ids as
## character, counts as integer, and the join table as an integer matrix with
## its row names and without column names (kinship2 leaves them out).
normalizedFamilyCheck <- function(x) {
  out <- data.frame(famid = as.character(x$famid), n = as.integer(x$n),
                    unrelated = as.integer(x$unrelated),
                    split = as.integer(x$split), join = as.integer(x$join),
                    stringsAsFactors = FALSE)
  join <- attr(x, "join")
  if (!is.null(join)) {
    attr(out, "join") <- matrix(as.integer(join), nrow = nrow(join),
                                dimnames = list(rownames(join), NULL))
  }
  out
}

## kinship2's familycheck() on one case in common terms, or NULL when kinship2
## stops (it does whenever every join lies within one family tree).
kinship2FamilyCheck <- function(famid, id, sire, dam) {
  result <- tryCatch(kinship2::familycheck(famid, id, sire, dam),
                     error = function(e) NULL)
  if (is.null(result)) NULL else normalizedFamilyCheck(result)
}
