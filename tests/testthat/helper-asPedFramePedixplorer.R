## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase 14,
## rulings R58-R59, pedkindraw S20). It serves
## test_asPedFramePedixplorer.R: the round trip from a pedigree data frame
## through Pedixplorer::Pedigree() and back through asPedFrame(), on the
## fixture pedigrees and on seeded random ones (run only where Pedixplorer is
## installed, R7). It uses helper-asPedFrame.R's fixtures, preparation, sex
## codes and random cases. Plan Phase 15c (R62, pedkindraw S24): what it
## should give gains hints, NULL. Plan Phase G15c (R141, pedkindraw S67):
## and matings, NULL (none of these objects holds a spouse pair).

## The rhesus fixture's twin pairs that Pedixplorer accepts: both twins with
## known parents (Pedixplorer refuses a twin pair with unknown parents).
asPedFramePxTwins <- function(f, twins) {
  known <- f$id[!is.na(f$sire) & !is.na(f$dam)]
  twins[twins$id1 %in% known & twins$id2 %in% known, ]
}

## The round trip of pedigree f, prepared as for kinship2: its conditions
## ("none", "one" as the column affected, "two" as the columns cancer and
## diabetes, seeded 0, 1 and NA), its status when withStatus (DECEASED from
## f's status, else seeded TRUE, FALSE and NA), all in family F1 when family,
## and twins (id1, id2, code as text, handed to Pedixplorer as numbers).
## Returns what asPedFrame() gave and what it should give.
asPedFramePxTrip <- function(f, cond, withStatus, family, twins = NULL,
                             seed = 1L) {
  n <- nrow(f)
  aff <- withr::with_seed(seed, matrix(sample(c(0, 1, NA), 2L * n, TRUE),
                                       n, 2L))
  d <- data.frame(id = f$id, dadid = f$sire, momid = f$dam,
                  sex = unname(asPedFrameK2Sex[f$sex]),
                  stringsAsFactors = FALSE)
  if (family) d$famid <- "F1"
  args <- list()
  if (cond == "one") d$affected <- aff[, 1L]
  if (cond == "two") {
    d$cancer <- aff[, 1L]
    d$diabetes <- aff[, 2L]
    args$col_aff <- c("cancer", "diabetes")
  }
  status <- NULL
  if (withStatus) {
    status <- if (is.null(f$status)) {
      withr::with_seed(seed + 1L, sample(c(TRUE, FALSE, NA), n, TRUE))
    } else {
      !is.na(f$status) & f$status == "DECEASED"
    }
    d$status <- status
  }
  if (!is.null(twins)) {
    args$rel_df <- data.frame(
      id1 = twins$id1, id2 = twins$id2,
      code = match(twins$code, c("MZ twin", "DZ twin", "UZ twin"))
    )
    if (family) args$rel_df$famid <- "F1"
  }
  got <- asPedFrame(do.call(Pedixplorer::Pedigree, c(list(d), args)))
  held <- function(id) {
    if (family) ifelse(is.na(id), NA_character_, paste0("F1_", id)) else id
  }
  want <- data.frame(id = held(f$id), sire = held(f$sire),
                     dam = held(f$dam),
                     sex = unname(asPedFrameBackSex[f$sex]),
                     stringsAsFactors = FALSE)
  if (family) want$famid <- "F1"
  if (cond == "one") want$affected <- aff[, 1L]
  if (cond == "two") {
    want$affected_cancer <- aff[, 1L]
    want$affected_diabetes <- aff[, 2L]
  }
  if (withStatus) want$status <- ifelse(status, "DECEASED", "ALIVE")
  wantTwins <- NULL
  if (!is.null(twins)) {
    wantTwins <- data.frame(id1 = held(twins$id1), id2 = held(twins$id2),
                            code = twins$code, stringsAsFactors = FALSE)
  }
  list(got = got,
       want = list(ped = want, twinRelations = wantTwins, hints = NULL,
                   matings = NULL))
}
