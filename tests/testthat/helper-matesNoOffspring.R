## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (pedkindraw
## S65, plan Phase G15a, gap B1 (mates with no offspring) of
## docs/research/pedkindraw-gaps-2026-11-18.md; ruling R141;
## docs/planning/mates-without-offspring-plan.md). It serves
## test_matesNoOffspring.R: the typed shapes of the plan's section 2, each
## drawn row's left-to-right order, random declared matings for the seeded
## family pedigrees of helper-layoutHints.R, and a check of each declared
## mating written from its definition, apart from the code it checks.

## A pedigree from columns; gen from findGeneration().
.matesPed <- function(id, sire, dam, sex) {
  ped <- data.frame(id = id, sire = sire, dam = dam, sex = sex,
                    stringsAsFactors = FALSE)
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

## A and B with offspring C and D: the start of most shapes.
.matesB4 <- function() {
  data.frame(id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
             dam = c(NA, NA, "B", "B"), sex = c("M", "F", "M", "F"),
             stringsAsFactors = FALSE)
}

## A pedigree of .matesB4() and more rows (each column recycled to the ids),
## gen added.
.matesPlus <- function(id = character(), sire = NA, dam = NA, sex = "F") {
  b4 <- .matesB4()
  n <- length(id)
  .matesPed(c(b4$id, id), c(b4$sire, rep_len(sire, n)),
            c(b4$dam, rep_len(dam, n)), c(b4$sex, rep_len(sex, n)))
}

## The layout in one style, its messages muffled and the rectilinear
## style's warning that a line could not be cleared of every animal (49 of
## 100 random pedigrees give it with no matings, S64-S65) muffled; any other
## warning is kept.
.matesLayout <- function(ped, matings = NULL, edgeStyle = "direct", ...) {
  withCallingHandlers(
    suppressMessages(makePedigreeMatingLayout(ped, edgeStyle = edgeStyle,
                                              matings = matings, ...)),
    warning = function(w) {
      if (grepl("could not be fully resolved", conditionMessage(w),
                fixed = TRUE)) {
        invokeRestart("muffleWarning")
      }
    }
  )
}

## The matings table.
.matesTable <- function(sire, dam) {
  data.frame(sire = sire, dam = dam, stringsAsFactors = FALSE)
}

## The typed shapes of the plan's section 2 (S64's refcases.R), each a
## pedigree and its declared matings, the sire column the male's unless the
## shape says otherwise.
.matesShapes <- function() {
  list(
    matesNoOffspring = list(
      ped = .matesPlus(c("E", "F"), NA, NA, c("M", "F")),
      matings = .matesTable("E", "F")),
    onlyTwo = list(
      ped = .matesPed(c("E", "F"), NA, NA, c("M", "F")),
      matings = .matesTable("E", "F")),
    marryIn = list(
      ped = .matesPlus("E", NA, NA, "F"),
      matings = .matesTable("C", "E")),
    secondMate = list(
      ped = .matesPlus("G", NA, NA, "F"),
      matings = .matesTable("A", "G")),
    twoChildless = list(
      ped = .matesPed(c("A", "B", "G"), NA, NA, c("M", "F", "F")),
      matings = .matesTable(c("A", "A"), c("B", "G"))),
    sibMates = list(
      ped = .matesPlus(),
      matings = .matesTable("C", "D")),
    bothHaveParents = list(
      ped = .matesPlus(c("H", "I", "J"), c(NA, NA, "H"), c(NA, NA, "I"),
                       c("M", "F", "F")),
      matings = .matesTable("C", "J")),
    crossGen = list(
      ped = .matesPlus(c("H", "K", "E"), c(NA, "C", NA), c(NA, "H", NA),
                       c("F", "F", "M")),
      matings = .matesTable("E", "K")),
    childlessPlusKids = list(
      ped = .matesPlus(c("H", "K", "E"), c(NA, "C", NA), c(NA, "H", NA),
                       c("F", "F", "F")),
      matings = .matesTable("C", "E")),
    sameSex = list(
      ped = .matesPlus(c("E", "F"), NA, NA, c("M", "M")),
      matings = .matesTable("E", "F")),
    unknownSex = list(
      ped = .matesPlus(c("E", "F"), NA, NA, c("U", "F")),
      matings = .matesTable("E", "F")),
    femaleFirst = list(
      ped = .matesPlus(c("E", "F"), NA, NA, c("M", "F")),
      matings = .matesTable("F", "E"))
  )
}

## Each drawn row of a layout, top to bottom, as its animals' ids left to
## right, a repeat node as its animal's id and "'"; rows with no animal (the
## rectilinear style's routing rows) left out.
.matesRows <- function(layout) {
  nodes <- layout$nodes
  animal <- !grepl("^__", nodes$id) | grepl("^__dup_", nodes$id)
  nodes <- nodes[animal, , drop = FALSE]
  shown <- ifelse(grepl("^__dup_", nodes$id),
                  paste0(layout$duplicateToReal[nodes$id], "'"), nodes$id)
  rows <- split(seq_len(nrow(nodes)), nodes$y)
  rows <- rows[order(as.numeric(names(rows)))]
  unname(vapply(rows, function(i) {
    paste(shown[i][order(nodes$x[i])], collapse = " ")
  }, character(1L)))
}

## Each declared mating as drawn, checked from its definition: in the direct
## style, find the mating point whose two lines from above come from the two
## partners (each its own node or a repeat node of it); then, in that style's
## nodes, the two partners and the point on one row, the point between the
## partners, no animal between them, and the lines at the point reaching the
## two partners and nothing else (no line down), through any routing points
## the rectilinear style adds around an animal. 'direct' is the direct-style
## layout
## of the same pedigree and matings, whose point ids the other style shares;
## 'layout' is the layout checked, either style. Returns "ok" or what failed,
## one per row of 'matings'.
.matesCheck <- function(layout, direct, matings) {
  realOf <- function(n) {
    real <- direct$duplicateToReal[n]
    ifelse(is.na(real), n, real)
  }
  points <- direct$nodes$id[grepl("^__union_", direct$nodes$id)]
  nodes <- layout$nodes
  vapply(seq_len(nrow(matings)), function(i) {
    want <- sort(c(matings$sire[i], matings$dam[i]))
    found <- NA_character_
    ends <- character()
    for (p in points) {
      e <- direct$edges$from[direct$edges$to == p]
      if (length(e) == 2L && identical(sort(unname(realOf(e))), want)) {
        found <- p
        ends <- e
        break
      }
    }
    if (is.na(found)) return("no mating point")
    at <- function(n) nodes[match(n, nodes$id), c("x", "y")]
    pt <- at(found)
    e1 <- at(ends[[1L]])
    e2 <- at(ends[[2L]])
    if (anyNA(c(pt$x, e1$x, e2$x))) return("a node not drawn")
    if (!(e1$y == pt$y && e2$y == pt$y)) return("not one row")
    lo <- min(e1$x, e2$x)
    hi <- max(e1$x, e2$x)
    if (!(pt$x > lo && pt$x < hi)) return("point not between")
    onRow <- nodes[nodes$y == pt$y & !nodes$id %in% ends &
                     (!grepl("^__", nodes$id) | grepl("^__dup_", nodes$id)), ]
    if (any(onRow$x > lo & onRow$x < hi)) return("an animal between")
    nextTo <- function(n) {
      c(layout$edges$to[layout$edges$from == n],
        layout$edges$from[layout$edges$to == n])
    }
    seen <- found
    frontier <- nextTo(found)
    reached <- character()
    while (length(frontier) > 0L) {
      n <- frontier[[1L]]
      frontier <- frontier[-1L]
      if (n %in% seen) next
      seen <- c(seen, n)
      if (grepl("^__jog_", n)) {
        frontier <- c(frontier, nextTo(n))
      } else {
        reached <- c(reached, n)
      }
    }
    if (!setequal(reached, ends) || length(reached) != 2L) return("a line down")
    "ok"
  }, character(1L))
}

## Up to k declared matings with no offspring together for a random
## pedigree: a male and a female, no pair with offspring together, no pair
## twice (S64's pickMatings(), protorun.R).
.matesPick <- function(ped, seed, k) {
  withr::with_seed(seed, {
    both <- !is.na(ped$sire) & !is.na(ped$dam)
    have <- c(paste(ped$sire[both], ped$dam[both]),
              paste(ped$dam[both], ped$sire[both]))
    males <- ped$id[ped$sex == "M"]
    females <- ped$id[ped$sex == "F"]
    got <- .matesTable(character(), character())
    tries <- 0L
    while (nrow(got) < k && tries < 200L) {
      tries <- tries + 1L
      s <- sample(males, 1L)
      d <- sample(females, 1L)
      if (paste(s, d) %in% have) next
      if (paste(s, d) %in% paste(got$sire, got$dam)) next
      got <- rbind(got, .matesTable(s, d))
    }
    got
  })
}
