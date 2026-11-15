## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase
## 15a, rulings R60-R63, pedkindraw S22; Phase 15b, pedkindraw S23). It
## serves test_layoutHintsOrder.R and test_layoutHintsMate.R: the design's
## seeded random family pedigrees (docs/planning/layout-hints-design.md,
## Appendix A), each drawn row's left-to-right order, and checks written from
## each hint's definition, apart from the code they check: every sibship, and
## every family's founder lines, in hinted order; each mating's partners as
## drawn at its dot; an animal's families in the order of its mates.

## A seeded random family pedigree (the design's Appendix A generator, run
## inside withr::with_seed() so the caller's random numbers are untouched).
layoutHintsFamilies <- function(seed) {
  withr::with_seed(seed, {
    nGen <- sample(2:4, 1L)
    nextId <- 0L
    newId <- function(k) {
      ids <- paste0("I", nextId + seq_len(k))
      nextId <<- nextId + k
      ids
    }
    fId <- newId(sample(4:10, 1L))
    ped <- data.frame(id = fId, sire = NA_character_, dam = NA_character_,
                      sex = rep(c("M", "F"), length.out = length(fId)),
                      stringsAsFactors = FALSE)
    pool <- ped$id
    for (g in seq_len(nGen)) {
      males <- intersect(pool, ped$id[ped$sex == "M"])
      females <- intersect(pool, ped$id[ped$sex == "F"])
      nCouples <- min(length(males), length(females))
      if (nCouples == 0L) break
      males <- sample(males)[seq_len(nCouples)]
      females <- sample(females)[seq_len(nCouples)]
      second <- males[runif(nCouples) < 1 / 6]
      if (length(second) > 0L) {
        mi <- newId(length(second))
        ped <- rbind(ped, data.frame(id = mi, sire = NA_character_,
                                     dam = NA_character_, sex = "F",
                                     stringsAsFactors = FALSE))
        males <- c(males, second)
        females <- c(females, mi)
      }
      kids <- character()
      for (k in seq_along(males)) {
        nk <- sample(1:6, 1L)
        kid <- newId(nk)
        s <- rep(males[k], nk)
        d <- rep(females[k], nk)
        d[runif(nk) < 1 / 12] <- NA
        ped <- rbind(ped, data.frame(id = kid, sire = s, dam = d,
                                     sex = sample(c("M", "F"), nk, TRUE),
                                     stringsAsFactors = FALSE))
        kids <- c(kids, kid)
      }
      mi <- newId(max(1L, length(kids) %/% 2L))
      ped <- rbind(ped, data.frame(id = mi, sire = NA_character_,
                                   dam = NA_character_,
                                   sex = sample(c("M", "F"), length(mi), TRUE),
                                   stringsAsFactors = FALSE))
      pool <- c(kids, mi)
    }
    ped <- ped[sample(nrow(ped)), ]
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    ped
  })
}

## The design's random order hint for seed s: every animal numbered.
layoutHintsRandomOrder <- function(ped, seed) {
  withr::with_seed(1000L + seed,
                   stats::setNames(sample(nrow(ped)), ped$id))
}

## A pedigree data frame with its generations.
layoutHintsPed <- function(id, sire, dam, sex) {
  ped <- data.frame(id = id, sire = sire, dam = dam, sex = sex,
                    stringsAsFactors = FALSE)
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

## The animals' own nodes (not mating units, repeat nodes or waypoints),
## each row's ids left to right, top row first.
layoutHintsRows <- function(layout) {
  nodes <- layout$nodes[!grepl("^__", layout$nodes$id), , drop = FALSE]
  lapply(sort(unique(nodes$y)), function(y) {
    row <- nodes[nodes$y == y, , drop = FALSE]
    row$id[order(row$x, row$id, method = "radix")]
  })
}

## The same rows as one string, "A B / C D", for readable expectations.
layoutHintsRowText <- function(layout) {
  paste(vapply(layoutHintsRows(layout), paste, "", collapse = " "),
        collapse = " / ")
}

## The x of each animal's own node, named by id.
layoutHintsX <- function(layout) {
  nodes <- layout$nodes[!grepl("^__", layout$nodes$id), , drop = FALSE]
  stats::setNames(nodes$x, nodes$id)
}

## For every sibship (children of one sire and dam, or of one known parent)
## with two or more drawn children the hint numbers: are they drawn left to
## right in increasing hint order? One TRUE or FALSE per sibship.
layoutHintsSibshipsInOrder <- function(ped, layout, hintOrder) {
  x <- layoutHintsX(layout)
  hasParent <- !is.na(ped$sire) | !is.na(ped$dam)
  key <- paste(ped$sire, ped$dam)[hasParent]
  sibs <- split(ped$id[hasParent], key)
  sibs <- lapply(sibs, function(k) k[k %in% names(x) & k %in% names(hintOrder)])
  sibs <- sibs[lengths(sibs) >= 2L]
  vapply(sibs, function(k) {
    identical(k[order(x[k])], k[order(hintOrder[k])])
  }, logical(1L), USE.NAMES = FALSE)
}

## For every family (animals joined by parent-child links) with two or more
## founder lines the hint numbers: are the lines drawn left to right in
## increasing hint order (equal numbers in either order)? A founder line
## starts at a founder the layout draws its own descendants under (an
## anchor of a mating, or a founder with a one-parent offspring); it is
## placed by the female of its founder couple: a female line by her own
## number, a male line by the smallest number among the female founders he
## anchors matings with, else his own.
layoutHintsFounderLinesInOrder <- function(ped, layout, hintOrder) {
  drawn <- ped[!ped$id %in% layout$isolatedIds, , drop = FALSE]
  ids <- drawn$id
  family <- stats::setNames(seq_along(ids), ids)
  repeat {
    before <- family
    for (i in seq_along(ids)) {
      linked <- c(ids[i], drawn$sire[i], drawn$dam[i])
      linked <- linked[!is.na(linked) & linked %in% ids]
      family[linked] <- min(family[linked])
    }
    if (identical(family, before)) break
  }
  founders <- ids[is.na(drawn$sire) & is.na(drawn$dam)]
  units <- .buildMatingUnitForest(drawn)$matingUnits
  oneParent <- c(drawn$sire[is.na(drawn$dam)], drawn$dam[is.na(drawn$sire)])
  lines <- intersect(founders, c(units$anchor, oneParent))
  sexOf <- stats::setNames(drawn$sex, ids)
  placeBy <- vapply(lines, function(f) {
    if (sexOf[[f]] == "F") return(as.numeric(hintOrder[f]))
    wives <- units$nonAnchor[units$anchor %in% f]
    wives <- wives[wives %in% founders & sexOf[wives] == "F"]
    n <- as.numeric(hintOrder[wives])
    n <- n[!is.na(n)]
    if (length(n) > 0L) min(n) else as.numeric(hintOrder[f])
  }, numeric(1L))
  x <- layoutHintsX(layout)
  checked <- lapply(split(lines, family[lines]), function(fl) {
    fl <- fl[!is.na(placeBy[fl])]
    if (length(fl) < 2L) return(NULL)
    !is.unsorted(placeBy[fl[order(x[fl])]])
  })
  unlist(checked, use.names = FALSE)
}

## kinship2's drawing with an order hint: each row's ids left to right.
layoutHintsKinship2Rows <- function(ped, hintOrder) {
  sex <- ifelse(ped$sex == "M", 1L, ifelse(ped$sex == "F", 2L, 3L))
  p <- kinship2::pedigree(id = ped$id, dadid = ped$sire, momid = ped$dam,
                          sex = sex, missid = NA)
  a <- kinship2::align.pedigree(
    p, hints = list(order = unname(hintOrder[as.character(p$id)]))
  )
  lapply(seq_len(nrow(a$nid)), function(r) {
    as.character(p$id)[a$nid[r, seq_len(a$n[r])]]
  })
}

## Do two drawings put the animals each draws once in a row in the same
## left-to-right order? One TRUE or FALSE per row (NA when fewer than two
## such animals are shared).
layoutHintsRowsAgree <- function(a, b) {
  vapply(seq_len(min(length(a), length(b))), function(i) {
    once <- function(r) r[!r %in% r[duplicated(r)]]
    ra <- once(a[[i]])
    rb <- once(b[[i]])
    common <- intersect(ra, rb)
    if (length(common) < 2L) return(NA)
    identical(ra[ra %in% common], rb[rb %in% common])
  }, logical(1L))
}

## A mate hint: one row per mating, 'left' drawn left of 'right', 'anchor'
## the partner the offspring hang under ("left", "right" or "either").
layoutHintsMate <- function(left, right, anchor = "either") {
  data.frame(left = left, right = right, anchor = anchor,
             stringsAsFactors = FALSE)
}

## Each row's nodes left to right, top row first, as "A B / C D'": the
## animals' own nodes and their repeat nodes, a repeat node written as its
## animal's id followed by '.
layoutHintsRowTextAll <- function(layout) {
  nodes <- layout$nodes
  repeats <- layout$duplicateToReal
  nodes <- nodes[!grepl("^__", nodes$id) | nodes$id %in% names(repeats), ,
                 drop = FALSE]
  nodes$text <- ifelse(nodes$id %in% names(repeats),
                       paste0(repeats[nodes$id], "'"), nodes$id)
  rows <- lapply(sort(unique(nodes$y)), function(y) {
    row <- nodes[nodes$y == y, , drop = FALSE]
    paste(row$text[order(row$x, row$id, method = "radix")], collapse = " ")
  })
  paste(unlist(rows), collapse = " / ")
}

## The same key for a pair in either order.
layoutHintsPairKey <- function(a, b) {
  ifelse(a < b, paste(a, b), paste(b, a))
}

## Each mating as drawn in a layout made with edgeStyle = "direct": its dot,
## the node standing for each partner there (the partner's own node or one
## of its repeat nodes, the two nodes with an edge into the dot), left to
## right, the partners' ids, and each node's x and y.
layoutHintsMatings <- function(layout) {
  edges <- layout$edges
  nodes <- layout$nodes
  xOf <- stats::setNames(nodes$x, nodes$id)
  yOf <- stats::setNames(nodes$y, nodes$id)
  repeats <- layout$duplicateToReal
  animal <- function(node) {
    ifelse(node %in% names(repeats), unname(repeats[node]), node)
  }
  dots <- unique(edges$to[grepl("^__union_", edges$to)])
  matings <- lapply(dots, function(dot) {
    from <- edges$from[edges$to == dot]
    from <- from[!grepl("^__", from) | from %in% names(repeats)]
    if (length(from) != 2L) return(NULL)
    from <- from[order(xOf[from])]
    data.frame(dot = dot, leftNode = from[[1L]], rightNode = from[[2L]],
               left = animal(from[[1L]]), right = animal(from[[2L]]),
               dotX = xOf[[dot]], dotY = yOf[[dot]],
               leftX = xOf[[from[[1L]]]], rightX = xOf[[from[[2L]]]],
               leftY = yOf[[from[[1L]]]], rightY = yOf[[from[[2L]]]],
               stringsAsFactors = FALSE)
  })
  do.call(rbind, matings)
}

## For every animal that anchors two or more of a layout's matings (in the
## mating-unit table of the animals drawn): are its mates drawn left to
## right in the same order as the mean x of each mating's offspring? One
## TRUE or FALSE per animal. The layout is made with edgeStyle = "direct".
layoutHintsFamiliesFollow <- function(ped, layout) {
  drawn <- ped[!ped$id %in% layout$isolatedIds, , drop = FALSE]
  units <- .buildMatingUnitForest(drawn)$matingUnits
  matings <- layoutHintsMatings(layout)
  if (is.null(matings)) return(logical(0L))
  matings$anchor <- units$anchor[match(
    layoutHintsPairKey(matings$left, matings$right),
    layoutHintsPairKey(units$sire, units$dam)
  )]
  matings <- matings[!is.na(matings$anchor), , drop = FALSE]
  x <- layoutHintsX(layout)
  matings$mateX <- ifelse(matings$anchor == matings$left, matings$rightX,
                          matings$leftX)
  matings$offspringX <- vapply(seq_len(nrow(matings)), function(i) {
    pair <- c(matings$left[[i]], matings$right[[i]])
    mean(x[drawn$id[drawn$sire %in% pair & drawn$dam %in% pair]])
  }, numeric(1L))
  byAnchor <- split(matings, matings$anchor)
  byAnchor <- byAnchor[vapply(byAnchor, nrow, integer(1L)) >= 2L]
  vapply(byAnchor, function(m) {
    identical(order(m$mateX), order(m$offspringX))
  }, logical(1L), USE.NAMES = FALSE)
}

## kinship2's drawing with a mate hint (its 'spouse' matrix) and, when
## given, an order hint; without one, kinship2's own autohint() order.
layoutHintsKinship2MateRows <- function(ped, hintMate, hintOrder = NULL) {
  sex <- ifelse(ped$sex == "M", 1L, ifelse(ped$sex == "F", 2L, 3L))
  p <- kinship2::pedigree(id = ped$id, dadid = ped$sire, momid = ped$dam,
                          sex = sex, missid = NA)
  ids <- as.character(p$id)
  hints <- kinship2::autohint(p)
  if (!is.null(hintOrder)) hints$order <- unname(hintOrder[ids])
  hints$spouse <- cbind(match(hintMate$left, ids), match(hintMate$right, ids),
                        c(left = 1L, right = 2L, either = 0L)[hintMate$anchor])
  a <- kinship2::align.pedigree(p, hints = hints)
  lapply(seq_len(nrow(a$nid)), function(r) ids[a$nid[r, seq_len(a$n[r])]])
}
