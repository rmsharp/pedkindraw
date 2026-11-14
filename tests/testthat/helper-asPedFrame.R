## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase 14,
## rulings R55-R57, pedkindraw S19). It serves test_asPedFrame.R: the round
## trip from a pedigree data frame through kinship2::pedigree() and back
## through asPedFrame(), on the fixture pedigrees and on seeded random ones
## (run only where kinship2 is installed, R7, R28).

## kinship2's sex words for the package's sex codes, and the code each comes
## back as (kinship2 has no hermaphrodite).
asPedFrameK2Sex <- c(M = "male", F = "female", H = "unknown", U = "unknown")
asPedFrameBackSex <- c(M = "M", F = "F", H = "U", U = "U")

## kinship2::pedigree() with its one expected warning muffled: it warns when
## more than a quarter of the sexes are unknown (lacy1989Ped has no sex).
## Any other warning still reaches the test.
asPedFrameK2 <- function(...) {
  withCallingHandlers(
    kinship2::pedigree(...),
    warning = function(w) {
      if (grepl("More than 25% of the gender values are 'unknown'",
                conditionMessage(w), fixed = TRUE)) {
        invokeRestart("muffleWarning")
      }
    }
  )
}

## A fixture's id, sire, dam and sex as text (sex U when it has none), and its
## status when it has one.
asPedFrameStd <- function(d, idCol, sireCol, damCol, sexCol = NULL) {
  out <- data.frame(id = as.character(d[[idCol]]),
                    sire = as.character(d[[sireCol]]),
                    dam = as.character(d[[damCol]]),
                    stringsAsFactors = FALSE)
  out$sex <- if (is.null(sexCol)) "U" else as.character(d[[sexCol]])
  if ("status" %in% names(d)) {
    out$status <- as.character(d$status)
  }
  out
}

## The nine fixture pedigrees in that form.
asPedFrameFixtures <- function() {
  list(
    examplePedigree = asPedFrameStd(examplePedigree, "id", "sire", "dam",
                                    "sex"),
    lacy1989Ped = asPedFrameStd(lacy1989Ped, "id", "sire", "dam"),
    pedOne = asPedFrameStd(pedOne, "ego_id", "sire.id", "dam_id", "sex"),
    pedSix = asPedFrameStd(pedSix, "Ego Id", "Sire Id", "Dam", "Sex"),
    pedWithGenotype = asPedFrameStd(pedWithGenotype, "id", "sire", "dam",
                                    "sex"),
    qcdRhesusPed = asPedFrameStd(readRDS(test_path("fixtures",
                                                   "qcdRhesusPed.rds")),
                                 "id", "sire", "dam", "sex"),
    qcPed = asPedFrameStd(qcPed, "id", "sire", "dam", "sex"),
    rhesusPedigree = asPedFrameStd(rhesusPedigree, "id", "sire", "dam", "sex"),
    smallPed = asPedFrameStd(smallPed, "id", "sire", "dam", "sex")
  )
}

## A pedigree changed only as far as kinship2::pedigree() demands: a made-up
## second parent for an animal with one known parent, a row for each parent
## with none, and each parent's sex set by its role.
asPedFrameForKinship2 <- function(f) {
  one <- xor(is.na(f$sire), is.na(f$dam))
  noSire <- one & is.na(f$sire)
  noDam <- one & is.na(f$dam)
  f$sire[noSire] <- paste0(f$id[noSire], ".s")
  f$dam[noDam] <- paste0(f$id[noDam], ".d")
  rowsFor <- function(ids, sex) {
    data.frame(id = ids, sire = rep(NA_character_, length(ids)),
               dam = rep(NA_character_, length(ids)),
               sex = rep(sex, length(ids)), stringsAsFactors = FALSE)
  }
  extra <- rbind(rowsFor(setdiff(unique(stats::na.omit(f$sire)), f$id), "M"),
                 rowsFor(setdiff(unique(stats::na.omit(f$dam)), f$id), "F"))
  for (column in setdiff(names(f), names(extra))) {
    extra[[column]] <- rep(NA_character_, nrow(extra))
  }
  f <- rbind(f, extra[names(f)])
  f$sex[f$id %in% f$sire] <- "M"
  f$sex[f$id %in% f$dam] <- "F"
  f
}

## The round trip of pedigree f: its conditions ("none", "one" vector,
## "named" or "unnamed" two-column matrix, seeded 0, 1 and NA), its status
## when withStatus (DECEASED from f's status, else seeded) and twins (id1, id2,
## code as text, handed to kinship2 as numbers). Returns what asPedFrame()
## gave and what it should give.
asPedFrameTrip <- function(f, cond, withStatus, twins = NULL, seed = 1L) {
  n <- nrow(f)
  aff <- withr::with_seed(seed, matrix(sample(c(0, 1, NA), 2L * n, TRUE),
                                       n, 2L))
  args <- list(id = f$id, dadid = f$sire, momid = f$dam,
               sex = unname(asPedFrameK2Sex[f$sex]))
  if (cond == "one") args$affected <- aff[, 1L]
  if (cond == "named") {
    args$affected <- `colnames<-`(aff, c("cancer", "diabetes"))
  }
  if (cond == "unnamed") args$affected <- aff
  status <- NULL
  if (withStatus) {
    status <- if (is.null(f$status)) {
      withr::with_seed(seed + 1L, sample(0L:1L, n, TRUE))
    } else {
      as.integer(!is.na(f$status) & f$status == "DECEASED")
    }
    args$status <- status
  }
  if (!is.null(twins)) {
    args$relation <- data.frame(
      id1 = twins$id1, id2 = twins$id2,
      code = match(twins$code, c("MZ twin", "DZ twin", "UZ twin"))
    )
  }
  got <- asPedFrame(do.call(asPedFrameK2, args))
  want <- data.frame(id = f$id, sire = f$sire, dam = f$dam,
                     sex = unname(asPedFrameBackSex[f$sex]),
                     stringsAsFactors = FALSE)
  if (cond == "one") want$affected <- aff[, 1L]
  if (cond == "named") {
    want$affected_cancer <- aff[, 1L]
    want$affected_diabetes <- aff[, 2L]
  }
  if (cond == "unnamed") {
    want$affected_1 <- aff[, 1L]
    want$affected_2 <- aff[, 2L]
  }
  if (withStatus) want$status <- ifelse(status == 1L, "DECEASED", "ALIVE")
  wantTwins <- NULL
  if (!is.null(twins)) {
    wantTwins <- data.frame(id1 = twins$id1, id2 = twins$id2,
                            code = twins$code, stringsAsFactors = FALSE)
  }
  list(got = got, want = list(ped = want, twinRelations = wantTwins))
}

## A seeded random pedigree (checkPedigreeClean() in helper-checkPedigree.R)
## with one hermaphrodite and one unknown sex, ready for kinship2.
asPedFrameRandomCase <- function(seed) {
  f <- withr::with_seed(seed, {
    p <- checkPedigreeClean(sample(6L:200L, 1L))
    p$sex[sample(nrow(p), 2L)] <- c("H", "U")
    p
  })
  asPedFrameForKinship2(f)
}
