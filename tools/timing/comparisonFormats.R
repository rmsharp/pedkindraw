## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/comparisonFormats.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h1). Changes: BGmisc's converters, toBGmisc() and
## toBGmiscNumeric(), are dropped (R82, R153), and BGmisc's name from the
## opening comment.
## The Phase 1 comparison formats (docs/planning/standalone-pedigree-package-
## plan.md, Phase 1 step 3): every test pedigree is one CSV of id, sire, dam,
## sex (M, F, U or H) and, optionally, birth, read the same way for every
## package; the converters hand it to kinship2 and Pedixplorer in each one's
## own coding. Tests: tests/test_comparisonFormats.R.

## Read a comparison CSV: ids as text, an empty cell as an unknown parent.
readComparisonPedigree <- function(path) {
  ped <- utils::read.csv(path,
    colClasses = "character", na.strings = "",
    stringsAsFactors = FALSE
  )
  missing <- setdiff(c("id", "sire", "dam", "sex"), names(ped))
  if (length(missing) > 0L) {
    stop("missing required column(s): ", toString(missing), call. = FALSE)
  }
  if ("birth" %in% names(ped)) ped$birth <- as.Date(ped$birth)
  ped
}

## Write a comparison CSV (unknown parents as empty cells) and return the
## file's md5 checksum, so a measurement can name the exact file it read.
writeComparisonPedigree <- function(ped, path) {
  utils::write.csv(ped, path, row.names = FALSE, na = "", quote = FALSE)
  unname(tools::md5sum(path))
}

recodeSex <- function(sex, codes) {
  unknown <- setdiff(unique(sex), names(codes))
  if (length(unknown) > 0L) {
    stop("unknown sex code(s): ", toString(unknown), call. = FALSE)
  }
  unname(codes[sex])
}

## kinship2 (and ggpedigree's copy of its pedigree()): sex 1 male, 2 female,
## 3 unknown. kinship2 has no hermaphrodite code, so H becomes unknown.
toKinship2 <- function(ped) {
  data.frame(
    id = ped$id, dadid = ped$sire, momid = ped$dam,
    sex = recodeSex(ped$sex, c(M = 1L, F = 2L, U = 3L, H = 3L)),
    stringsAsFactors = FALSE
  )
}

## Pedixplorer: sex spelled out; it too has no hermaphrodite code.
toPedixplorer <- function(ped) {
  data.frame(
    id = ped$id, dadid = ped$sire, momid = ped$dam,
    sex = recodeSex(ped$sex, c(
      M = "male", F = "female", U = "unknown",
      H = "unknown"
    )),
    stringsAsFactors = FALSE
  )
}

## Give every animal with one known parent a placeholder for the other, an
## unrelated founder, for the constructors that require both parents or
## neither (kinship2::pedigree(), Pedixplorer::Pedigree()). Kinship among
## the original animals is unchanged.
completeParentage <- function(ped) {
  half <- which(xor(is.na(ped$sire), is.na(ped$dam)))
  if (length(half) == 0L) {
    return(ped)
  }
  noSire <- is.na(ped$sire[half])
  wanted <- paste0(
    "unknown_", ifelse(noSire, "sire", "dam"), "_of_",
    ped$id[half]
  )
  newIds <- make.unique(c(ped$id, wanted))[-seq_along(ped$id)]
  ped$sire[half[noSire]] <- newIds[noSire]
  ped$dam[half[!noSire]] <- newIds[!noSire]
  extra <- ped[rep(NA_integer_, length(half)), , drop = FALSE]
  extra$id <- newIds
  extra$sex <- ifelse(noSire, "M", "F")
  full <- rbind(ped, extra)
  rownames(full) <- NULL
  full
}

## For a pedigree with no sex column (lacy1989Ped): sires M, dams F, the
## rest U.
deriveSex <- function(ped) {
  both <- intersect(stats::na.omit(ped$sire), stats::na.omit(ped$dam))
  if (length(both) > 0L) {
    stop("id(s) both a sire and a dam: ", toString(both), call. = FALSE)
  }
  ped$sex <- rep("U", nrow(ped))
  ped$sex[ped$id %in% ped$dam] <- "F"
  ped$sex[ped$id %in% ped$sire] <- "M"
  ped
}
