## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G8, gap
## C2, pedkindraw S49). Written from kinship2's description of
## kindepth(align = TRUE) ("try to make both parents of each child have the
## same depth") and from its measured results, not from its code (R11).

## The aligned generations of findGeneration(alignMates = TRUE), from the
## plain ones, gen. Matings are the sire and dam pairs with an offspring
## recording both; an animal gen leaves NA takes no part and stays NA.
## 1. The matings whose sire and dam are in different generations are
##    visited in the order of their offspring's generation, then of the
##    sire's and the dam's ids (text, C locale), each mating at most once.
## 2. At a visit, if the two parents still differ, the parent in the earlier
##    generation, p, moves down to its nearest later-generation mate, unless
##    p has moved this way before or is related to one of its
##    later-generation mates other than through their own offspring. With p
##    move its ancestors and those of the ancestors' mates who have no
##    parents, all by the same number of generations.
## 3. The descendants of the animals moved are then put one generation below
##    their later parent; a mating of a descendant pushed further down that
##    is not yet visited or waiting joins the end of the list, in order of
##    the sire's and the dam's ids.
## 4. When the list is empty, every animal with a known parent is put one
##    generation below its later parent, top down.
.alignGenerations <- function(id, sire, dam, gen) {
  n <- length(id)
  if (n == 0L || all(is.na(gen))) {
    return(gen)
  }
  placed <- !is.na(gen)
  si <- match(sire, id)
  di <- match(dam, id)
  si[!placed] <- NA_integer_
  di[!placed] <- NA_integer_
  hasS <- !is.na(si)
  hasD <- !is.na(di)
  both <- hasS & hasD
  rows <- seq_len(n)
  children <- split(c(rows[hasS], rows[hasD]),
                    factor(c(si[hasS], di[hasD]), levels = rows))
  parents <- split(c(si[hasS], di[hasD]),
                   factor(c(rows[hasS], rows[hasD]), levels = rows))
  neighbours <- Map(c, parents, children)

  ## One row per mating, its offspring listed.
  key <- paste(si[both], di[both])
  first <- !duplicated(key)
  pairS <- si[both][first]
  pairD <- di[both][first]
  offspring <- split(rows[both], factor(key, levels = key[first]))
  names(offspring) <- NULL
  nPairs <- length(pairS)
  pairsOf <- split(c(seq_len(nPairs), seq_len(nPairs)),
                   factor(c(pairS, pairD), levels = rows))

  depth <- gen
  differ <- which(gen[pairS] != gen[pairD])
  queue <- differ[order(pmax(gen[pairS[differ]], gen[pairD[differ]]),
                        id[pairS[differ]], id[pairD[differ]],
                        method = "radix")]
  waiting <- logical(nPairs)
  waiting[queue] <- TRUE
  visited <- logical(nPairs)
  movedOnce <- logical(n)

  ## TRUE when a path leads from p to m other than through their offspring.
  related <- function(p, m, joint) {
    seen <- logical(n)
    seen[c(p, joint)] <- TRUE
    front <- p
    while (length(front) > 0L) {
      nxt <- unlist(neighbours[front], use.names = FALSE)
      nxt <- unique(nxt[!seen[nxt]])
      if (m %in% nxt) {
        return(TRUE)
      }
      seen[nxt] <- TRUE
      front <- nxt
    }
    FALSE
  }

  k <- 0L
  while (k < length(queue)) {
    k <- k + 1L
    r <- queue[[k]]
    visited[r] <- TRUE
    waiting[r] <- FALSE
    s <- pairS[[r]]
    d <- pairD[[r]]
    if (depth[s] == depth[d]) next
    p <- if (depth[s] < depth[d]) s else d
    if (movedOnce[p]) next
    own <- pairsOf[[p]]
    mates <- ifelse(pairS[own] == p, pairD[own], pairS[own])
    later <- depth[mates] > depth[p]
    if (any(vapply(which(later), function(j) {
      related(p, mates[[j]], offspring[[own[[j]]]])
    }, logical(1L)))) {
      next
    }
    step <- min(depth[mates[later]]) - depth[p]

    ## p, its ancestors and the ancestors' mates who have no parents.
    inBlock <- logical(n)
    inBlock[p] <- TRUE
    front <- p
    while (length(front) > 0L) {
      ups <- unlist(parents[front], use.names = FALSE)
      ups <- unique(ups[!inBlock[ups]])
      inBlock[ups] <- TRUE
      upPairs <- unlist(pairsOf[unique(c(ups,
        unlist(parents[front], use.names = FALSE)))], use.names = FALSE)
      matesUp <- unique(c(pairS[upPairs], pairD[upPairs]))
      matesUp <- matesUp[!inBlock[matesUp] & !hasS[matesUp] & !hasD[matesUp]]
      inBlock[matesUp] <- TRUE
      front <- ups
    }
    block <- which(inBlock)
    depth[block] <- depth[block] + step
    movedOnce[p] <- TRUE

    ## Push the block's descendants below their later parent.
    seen <- inBlock
    below <- integer(0L)
    front <- block
    while (length(front) > 0L) {
      nxt <- unlist(children[front], use.names = FALSE)
      nxt <- unique(nxt[!seen[nxt]])
      seen[nxt] <- TRUE
      below <- c(below, nxt)
      front <- nxt
    }
    pushed <- integer(0L)
    for (c in below[order(gen[below])]) {
      new <- 1L + max(depth[parents[[c]]])
      if (new > depth[c]) {
        pushed <- c(pushed, c)
      }
      depth[c] <- new
    }
    if (length(pushed) > 0L) {
      more <- unique(unlist(pairsOf[pushed], use.names = FALSE))
      more <- more[!visited[more] & !waiting[more]]
      more <- more[order(id[pairS[more]], id[pairD[more]], method = "radix")]
      waiting[more] <- TRUE
      queue <- c(queue, more)
    }
  }

  for (c in rows[placed & (hasS | hasD)][order(gen[placed & (hasS | hasD)])]) {
    depth[c] <- 1L + max(depth[parents[[c]]])
  }
  depth
}
