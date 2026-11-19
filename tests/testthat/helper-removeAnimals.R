## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helpers, not copied from nprcgenekeepr (plan Phase
## G7, gap C6, pedkindraw S48), for test_removeAnimals.R: the gap case, a
## slow removal written from its definition, which agreed with the prototype
## on 307 of 307 pedigrees before RED (S48), seeded removal lists and the
## readers of kinship2's and Pedixplorer's results. The random pedigrees come
## from randomMatingPed() in helper-offspringAndMatings.R.

## The gap case removeAnimals (tools/gapCases.R): A and B have C and D; C and
## E have F and G; D and H have I.
removeAnimalsPed <- function() {
  data.frame(id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
             sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "D"),
             dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "H"),
             sex = c("M", "F", "M", "M", "F", "M", "F", "F", "F"),
             stringsAsFactors = FALSE)
}

## Slow removal, row by row: a row whose id is listed is dropped, and in each
## row kept a sire or dam that is listed becomes NA. Returns id, sire and dam
## as text.
removeAnimalsSlow <- function(ped, ids) {
  ids <- as.character(ids)
  listed <- function(x) {
    if (is.na(x)) anyNA(ids) else any(!is.na(ids) & ids == x)
  }
  id <- as.character(ped$id)
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  keep <- logical(length(id))
  for (r in seq_along(id)) {
    keep[r] <- !listed(id[r])
    if (!is.na(sire[r]) && listed(sire[r])) sire[r] <- NA
    if (!is.na(dam[r]) && listed(dam[r])) dam[r] <- NA
  }
  data.frame(id = id[keep], sire = sire[keep], dam = dam[keep],
             stringsAsFactors = FALSE)
}

## A pedigree's id, sire and dam as text, its rows numbered from 1.
pedTrio <- function(ped) {
  data.frame(id = as.character(ped$id), sire = as.character(ped$sire),
             dam = as.character(ped$dam), stringsAsFactors = FALSE)
}

## n animals in birth order; each later one gets, 7 times in 10, both a sire
## from the earlier males and a dam from the earlier females (kinship2 and
## Pedixplorer take an animal with both parents or neither).
randomBothParentsPed <- function(n) {
  id <- sprintf("b%03d", seq_len(n))
  sex <- sample(c("M", "F"), n, replace = TRUE)
  sire <- rep(NA_character_, n)
  dam <- rep(NA_character_, n)
  for (k in seq_len(n)[-1L]) {
    earlier <- seq_len(k - 1L)
    males <- id[earlier][sex[earlier] == "M"]
    females <- id[earlier][sex[earlier] == "F"]
    if (length(males) > 0L && length(females) > 0L &&
          stats::runif(1L) < 0.7) {
      sire[k] <- males[sample.int(length(males), 1L)]
      dam[k] <- females[sample.int(length(females), 1L)]
    }
  }
  data.frame(id = id, sire = sire, dam = dam, sex = sex,
             stringsAsFactors = FALSE)
}

## The pedigrees the kinship2 and Pedixplorer tests run on: the fixture
## pedigrees, then 100 seeded random ones with both parents or neither,
## named bothParents1 to bothParents100.
removeCheckPeds <- function() {
  peds <- matingFixturePeds()
  withr::with_seed(48L, {
    for (k in seq_len(100L)) {
      peds[[paste0("bothParents", k)]] <-
        randomBothParentsPed(sample(3:150, 1L))
    }
  })
  peds
}

## A list of ids to remove from each pedigree, drawn with seed: a tenth of
## its ids (at least one) and one of its parents that has a row.
removalLists <- function(peds, seed) {
  withr::with_seed(seed, lapply(peds, function(ped) {
    ids <- unique(as.character(ped$id))
    parents <- unique(c(as.character(ped$sire), as.character(ped$dam)))
    parents <- parents[!is.na(parents) & parents %in% ids]
    chosen <- sample(ids, max(1L, round(length(ids) / 10L)))
    if (length(parents) > 0L) {
      chosen <- c(chosen, parents[sample.int(length(parents), 1L)])
    }
    unique(chosen)
  }))
}

## The ids and, again and again, every other parent of their offspring, so
## that no offspring keeps only one of its parents (kinship2's pedigree.trim()
## stops otherwise).
withMates <- function(ped, ids) {
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  repeat {
    mates <- c(dam[sire %in% ids], sire[dam %in% ids])
    more <- setdiff(mates[!is.na(mates)], ids)
    if (length(more) == 0L) {
      return(ids)
    }
    ids <- c(ids, more)
  }
}

## kinship2's pedigree's id, sire and dam as text.
kinship2Trio <- function(k) {
  id <- as.character(k$id)
  data.frame(id = id,
             sire = ifelse(k$findex > 0L, id[pmax(k$findex, 1L)], NA_character_),
             dam = ifelse(k$mindex > 0L, id[pmax(k$mindex, 1L)], NA_character_),
             stringsAsFactors = FALSE)
}

## Pedixplorer's Ped's sire and dam of the given ids, as text; the parents it
## makes up ("addin-...") read as NA.
pedixplorerTrio <- function(q, ids) {
  i <- match(ids, Pedixplorer::id(q))
  sire <- as.character(Pedixplorer::dadid(q))[i]
  dam <- as.character(Pedixplorer::momid(q))[i]
  sire[grepl("^addin", sire)] <- NA
  dam[grepl("^addin", dam)] <- NA
  data.frame(id = ids, sire = sire, dam = dam, stringsAsFactors = FALSE)
}

## Sex as kinship2 and Pedixplorer number it: 1 male, 2 female, 3 unknown.
sexNumbers <- function(sex) {
  sex <- as.character(sex)
  ifelse(sex %in% "M", 1L, ifelse(sex %in% "F", 2L, 3L))
}

## Runs expr, muffling only Pedixplorer's two warnings these tests expect:
## that more than a quarter of the sexes are unknown (a fixture pedigree
## without a sex column), and that a pedigree it refuses is not valid (it then
## returns a data frame, which the tests read as refusing).
quietPedixplorer <- function(expr) {
  withCallingHandlers(expr, warning = function(w) {
    message <- conditionMessage(w)
    if (startsWith(message,
                   "More than 25% of the gender values are 'unknown'") ||
          startsWith(message, "The Pedigree informations are not valid")) {
      invokeRestart("muffleWarning")
    }
  })
}
