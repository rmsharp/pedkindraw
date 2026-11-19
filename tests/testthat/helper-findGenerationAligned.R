## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helpers, not copied from nprcgenekeepr (plan Phase
## G8, gap C2, pedkindraw S49), for test_findGenerationAligned.R: a slow
## version of findGeneration(alignMates = TRUE) written from its four steps,
## the typed pedigrees each step was found on (kinship2's kindepth(align =
## TRUE) measured on each before RED), the pedigrees the tests run on, and
## the reader of kinship2's results (kinship2SampleFamily() is in
## helper-findUnrelated.R).

## The aligned generations, slowly: one animal at a time, by name, from the
## four steps on findGeneration()'s help page. Animals findGeneration()
## cannot place take no part and stay NA.
alignedGenerationsSlow <- function(id, sire, dam) {
  id <- as.character(id)
  sire <- as.character(sire)
  dam <- as.character(dam)
  gen <- suppressWarnings(findGeneration(id, sire, dam))
  if (length(id) == 0L || all(is.na(gen))) {
    return(gen)
  }
  ok <- !is.na(gen)
  ped <- data.frame(id = id[ok], sire = sire[ok], dam = dam[ok],
                    stringsAsFactors = FALSE)
  plain <- stats::setNames(gen[ok], ped$id)
  parentList <- stats::setNames(
    lapply(seq_len(nrow(ped)), function(r) {
      p <- c(ped$sire[[r]], ped$dam[[r]])
      p[!is.na(p)]
    }), ped$id)
  offspringList <- lapply(stats::setNames(nm = ped$id), function(x) {
    character(0L)
  })
  for (r in seq_len(nrow(ped))) {
    for (p in parentList[[r]]) {
      offspringList[[p]] <- c(offspringList[[p]], ped$id[[r]])
    }
  }
  parentsOf <- function(x) unlist(parentList[x], use.names = FALSE)
  offspringOf <- function(x) unlist(offspringList[x], use.names = FALSE)
  hasParents <- function(x) length(parentsOf(x)) > 0L
  ## The animals reached from start, one step at a time by next_, never
  ## entering avoid; start itself is not listed.
  search <- function(start, next_, avoid = character(0L)) {
    seen <- stats::setNames(logical(nrow(ped)), ped$id)
    seen[c(start, avoid)] <- TRUE
    found <- character(0L)
    todo <- start
    while (length(todo) > 0L) {
      a <- todo[[1L]]
      todo <- todo[-1L]
      for (b in next_(a)) {
        if (!seen[[b]]) {
          seen[[b]] <- TRUE
          found <- c(found, b)
          todo <- c(todo, b)
        }
      }
    }
    found
  }
  bothKnown <- !is.na(ped$sire) & !is.na(ped$dam)
  matings <- unique(ped[bothKnown, c("sire", "dam")])
  rownames(matings) <- NULL
  matingName <- paste(matings$sire, matings$dam, sep = "\r")
  matesOf <- function(x) {
    unique(c(matings$dam[matings$sire == x], matings$sire[matings$dam == x]))
  }
  jointOffspring <- function(a, b) {
    ped$id[(ped$sire %in% a & ped$dam %in% b) |
             (ped$sire %in% b & ped$dam %in% a)]
  }
  ## A path from p to m that never enters an offspring of p and m.
  relatedOtherwise <- function(p, m) {
    m %in% search(p, function(a) c(parentsOf(a), offspringOf(a)),
                  avoid = jointOffspring(p, m))
  }
  depth <- plain
  ## Step 1.
  differ <- which(plain[matings$sire] != plain[matings$dam])
  later <- pmax(plain[matings$sire], plain[matings$dam])
  todo <- differ[order(later[differ], matings$sire[differ],
                       matings$dam[differ], method = "radix")]
  done <- character(0L)
  movedBefore <- character(0L)
  while (length(todo) > 0L) {
    r <- todo[[1L]]
    todo <- todo[-1L]
    done <- c(done, matingName[[r]])
    s <- matings$sire[[r]]
    d <- matings$dam[[r]]
    ## Step 2.
    if (depth[[s]] == depth[[d]]) next
    p <- if (depth[[s]] < depth[[d]]) s else d
    if (p %in% movedBefore) next
    mates <- matesOf(p)
    laterMates <- mates[depth[mates] > depth[[p]]]
    if (any(vapply(laterMates, function(m) relatedOtherwise(p, m),
                   logical(1L)))) next
    step <- min(depth[laterMates]) - depth[[p]]
    ancestors <- search(p, parentsOf)
    founderMates <- unlist(lapply(ancestors, matesOf))
    founderMates <- founderMates[!vapply(founderMates, hasParents,
                                         logical(1L))]
    moving <- unique(c(p, ancestors, founderMates))
    depth[moving] <- depth[moving] + step
    movedBefore <- c(movedBefore, p)
    ## Step 3.
    below <- setdiff(search(moving, offspringOf), moving)
    pushed <- character(0L)
    for (x in below[order(plain[below])]) {
      new <- 1L + max(depth[parentsOf(x)])
      if (new > depth[[x]]) pushed <- c(pushed, x)
      depth[[x]] <- new
    }
    more <- which(matings$sire %in% pushed | matings$dam %in% pushed)
    more <- more[!(matingName[more] %in% done) & !(more %in% todo)]
    more <- more[order(matings$sire[more], matings$dam[more],
                       method = "radix")]
    todo <- c(todo, more)
  }
  ## Step 4.
  for (x in names(plain)[order(plain)]) {
    if (hasParents(x)) depth[[x]] <- 1L + max(depth[parentsOf(x)])
  }
  gen[ok] <- depth[ped$id]
  gen
}

## A data frame of id, sire and dam typed one row to a string, "." for an
## unknown parent.
typedPed <- function(...) {
  rows <- strsplit(c(...), " ", fixed = TRUE)
  ped <- data.frame(id = vapply(rows, `[`, "", 1L),
                    sire = vapply(rows, `[`, "", 2L),
                    dam = vapply(rows, `[`, "", 3L),
                    stringsAsFactors = FALSE)
  ped$sire[ped$sire == "."] <- NA
  ped$dam[ped$dam == "."] <- NA
  ped
}

## q's family, which the moving animal p mates into in several cases: q is
## in generation 2, and its dam q4 is a founder that moves to q3's.
withQ <- function(before, after) {
  typedPed(before, "q1 . .", "q2 . .", "q3 q1 q2", "q4 . .", "q q3 q4",
           after)
}

## The typed pedigrees, named for what each shows; each was run through
## kinship2's kindepth(align = TRUE) before RED (S49).
alignedTypedPeds <- function() {
  list(
    ## S and T have C1, S and M have C2; M is in generation 1. S moves to
    ## M's generation; T, S's mate in generation 0, stays.
    founderMateStays = typedPed("F1 . .", "F2 . .", "S . .", "T . .",
                                "M F2 F1", "C1 S T", "C2 S M"),
    ## X (generation 1) mates A2 (2) and B (3): X moves once, to A2's
    ## generation, with its sire P1 and dam P2.
    nearestMateOnce = typedPed(
      "P1 . .", "P2 . .", "X P1 P2", "a1 . .", "a2 . .", "A a1 a2", "a3 . .",
      "A2 A a3", "b1 . .", "b2 . .", "b3 b1 b2", "b4 . .", "b5 b3 b4",
      "b6 . .", "B b5 b6", "CA X A2", "CB X B"),
    ## p moves with its parents P1 and P2 and with X, P1's mate with no
    ## parents; Y, the offspring of P1 and X, is pushed below them.
    founderMateOfAncestor = withQ(
      c("P1 . .", "P2 . .", "p P1 P2", "X . .", "Y P1 X"), "c p q"),
    ## Here P1's mate X has parents: X stays.
    mateWithParentsStays = typedPed(
      "Xp1 . .", "Xp2 . .", "Z . .", "W Xp1 Z", "X Xp1 Xp2", "P1 . .",
      "P2 . .", "p P1 P2", "Y P1 X", "q1 . .", "q2 . .", "q3 q1 q2",
      "q4 . .", "q q3 q4", "q5 . .", "qq q q5", "c p qq"),
    ## p mates its own daughter D (generation 1) and q (2): p stays.
    relatedMateStays = withQ(c("p . .", "W . .", "D p W", "E p D"),
                             "c p q"),
    ## PQ moves to G3's generation and pushes its offspring M0 down; M0's
    ## mating with 5J is then visited, and 5J moves with its parents.
    pushedMatingVisited = typedPed(
      "4E . .", "PQ . .", "8Z . .", "28 . .", "RD . .", "LW . .",
      "M0 PQ 8Z", "5J 28 LW", "G3 RD 4E", "DK M0 5J", "DW PQ G3"),
    ## p's sibling sib is pushed only at the end, so its mate sm moves to
    ## sib's generation before then.
    siblingPushedLast = withQ(
      c("P1 . .", "P2 . .", "p P1 P2", "sib P1 P2"),
      c("c p q", "sm . .", "sc sib sm")),
    ## kinship2's answer here depends on the order of the rows (RY is in
    ## generation 2 as typed, 1 with the rows reversed); pedkindraw's does
    ## not.
    rowOrder = typedPed("Y7 . .", "CB . .", "X4 . .", "RJ . .", "JR X4 CB",
                        "RY . .", "0Q RJ Y7", "77 X4 0Q", "DM RY JR")
  )
}

## The pedigrees the slow version and the checks run on: the fixture
## pedigrees, then 100 seeded random ones with both parents or neither
## (bothParents1-100) and 100 in which an animal may have one parent
## (oneParent1-100).
alignedCheckPeds <- function() {
  peds <- matingFixturePeds()
  withr::with_seed(49L, {
    for (k in seq_len(100L)) {
      peds[[paste0("bothParents", k)]] <-
        randomBothParentsPed(sample(3:150, 1L))
    }
    for (k in seq_len(100L)) {
      peds[[paste0("oneParent", k)]] <- randomMatingPed(sample(3:150, 1L))
    }
  })
  peds
}

## kinship2's aligned depths of a pedigree's id, sire and dam (NA as
## unknown), or NULL when it stops or runs past 10 seconds.
kinship2Aligned <- function(ped) {
  setTimeLimit(elapsed = 10, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf))
  tryCatch(
    suppressWarnings(kinship2::kindepth(as.character(ped$id),
                                        as.character(ped$sire),
                                        as.character(ped$dam),
                                        align = TRUE)),
    error = function(e) NULL
  )
}
