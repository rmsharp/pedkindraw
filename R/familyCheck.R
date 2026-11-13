## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 12,
## rulings R43-R45, pedkindraw S15). Written from kinship2's help pages for
## familycheck() and makefamid() and from their measured results, not their
## source (R11, R14).

#' Check family ids against the family trees the parents form
#'
#' Compares the family id each animal is given with the family trees its
#' parent links form. Two animals are in the same tree when a chain of
#' parent-offspring links joins them. A link counts only when the parent has
#' a row (an id in \code{id}), so a parent id with no row, such as \code{"0"}
#' or \code{""}, links no one, as in \code{kinship2}. An animal linked to no
#' other is related to no one.
#'
#' For each family id, \code{familyCheck()} counts its animals (\code{n}),
#' those related to no one (\code{unrelated}), the trees its other animals
#' fall in (\code{split}: 1 is what a family should be; 0 means none of its
#' animals is related to another; 2 or more means it is two or more trees
#' with no link between them), and the other family ids sharing those trees
#' (\code{join}: 0 is what a family should be). \code{join} counts another
#' family id once for each tree the two share, as
#' \code{kinship2::familycheck()} does.
#'
#' It is \code{kinship2}'s \code{familycheck()} for pedigree vectors whose
#' unknown parents are \code{NA}. On every case its tests compare with
#' kinship2 (the fixture pedigrees with family ids given wrongly, and random
#' families), it gives kinship2's counts and join table. It differs where
#' kinship2 stops with an error: when every join lies within one family tree,
#' and for empty input, where it returns zero rows. It sorts character family
#' ids in byte order, where kinship2 follows the locale; keeps the family ids'
#' type and returns integer counts; names the join table's columns by tree
#' number; and stops on a repeated id, which kinship2 accepts. An animal that
#' is its own ancestor does not stop it (kinship2 stops on some such
#' pedigrees).
#'
#' @param famid a vector of family ids, one per animal. \code{NA} is not
#' allowed.
#' @param id a vector of unique animal ids. \code{NA} is not allowed.
#' @param sire a vector with each animal's sire, \code{NA} if unknown.
#' @param dam a vector with each animal's dam, \code{NA} if unknown.
#' @param newfam optional: a family-tree number per animal, 0 for an animal
#' related to no one, as \code{kinship2::makefamid()} returns. When given it
#' is used as it is, instead of computing the trees.
#' @return A data frame with one row per family id, sorted (character ids in
#' byte order, numbers by value), and the columns \code{famid} (the family
#' id, of the type given; a factor's as character), \code{n},
#' \code{unrelated}, \code{split} and \code{join} (integers). When any
#' \code{join} is above 0, the data frame has an attribute \code{"join"}: an
#' integer matrix with a row per joined family id and a column per family tree
#' their animals belong to, named by tree number, each entry the number of
#' that family's animals in that tree. Trees are numbered 1, 2, ... in the
#' order of their first animal, as \code{kinship2::makefamid()} numbers them.
#'
#' @seealso \code{\link{findPedigreeNumber}}
#'
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93.
#'
#' @export
#' @examples
#' ## A and B are the parents of C, and D and E of F; G is related to no one.
#' ## Family "a" is given to A and B, but C, their child, is given "x".
#' id <- c("A", "B", "C", "D", "E", "F", "G")
#' sire <- c(NA, NA, "A", NA, NA, "D", NA)
#' dam <- c(NA, NA, "B", NA, NA, "E", NA)
#' famid <- c("a", "a", "x", "b", "b", "b", "b")
#' result <- familyCheck(famid, id, sire, dam)
#' result
#' attr(result, "join")
familyCheck <- function(famid, id, sire, dam, newfam) {
  n <- length(id)
  if (length(famid) != n || length(sire) != n || length(dam) != n) {
    stop("famid, id, sire and dam must have the same length", call. = FALSE)
  }
  if (anyNA(famid)) stop("No famid may be missing", call. = FALSE)
  if (anyNA(id)) stop("No id may be missing", call. = FALSE)
  if (anyDuplicated(id) > 0L) stop("No id may appear twice", call. = FALSE)
  if (missing(newfam)) {
    newfam <- .familyTrees(id, sire, dam)
  } else {
    if (length(newfam) != n) {
      stop("newfam must be as long as id", call. = FALSE)
    }
    if (anyNA(newfam)) stop("No newfam may be missing", call. = FALSE)
  }
  if (is.factor(famid)) famid <- as.character(famid)

  families <- sort(unique(famid), method = "radix")
  nFamilies <- length(families)
  family <- match(famid, families)
  linked <- newfam != 0L

  ## One row per family and tree it shares in; each tree's other families
  ## are that tree's joins for the family.
  pairFamily <- family[linked]
  pairTree <- newfam[linked]
  firstPair <- !duplicated(cbind(pairFamily, pairTree))
  pairFamily <- pairFamily[firstPair]
  pairTree <- pairTree[firstPair]
  treeIndex <- match(pairTree, unique(pairTree))
  others <- tabulate(treeIndex)[treeIndex] - 1L
  joinCount <- tabulate(rep(pairFamily, others), nbins = nFamilies)

  result <- data.frame(
    famid = families,
    n = tabulate(family, nbins = nFamilies),
    unrelated = tabulate(family[!linked], nbins = nFamilies),
    split = tabulate(pairFamily, nbins = nFamilies),
    join = joinCount,
    stringsAsFactors = FALSE
  )
  if (any(joinCount > 0L)) {
    joined <- which(joinCount > 0L)
    inJoined <- linked & family %in% joined
    trees <- sort(unique(newfam[inJoined]))
    counts <- table(factor(family[inJoined], levels = joined),
                    factor(newfam[inJoined], levels = trees))
    attr(result, "join") <- matrix(
      as.integer(counts), nrow = length(joined),
      dimnames = list(as.character(families[joined]), as.character(trees))
    )
  }
  result
}

## The family-tree number of each animal: animals joined by a chain of
## parent links whose parent has a row share a number, numbered 1, 2, ... in
## the order of their first row; an animal linked to no other gets 0
## (kinship2's makefamid() convention, from its help page). Each animal starts
## with its own row as its label; every round gives each animal the smallest
## label among itself and its links, then the label of that label, until no
## label changes.
.familyTrees <- function(id, sire, dam) {
  n <- length(id)
  sireRow <- match(sire, id)
  damRow <- match(dam, id)
  child <- c(which(!is.na(sireRow)), which(!is.na(damRow)))
  parent <- c(sireRow[!is.na(sireRow)], damRow[!is.na(damRow)])
  node <- c(seq_len(n), child, parent)
  tree <- seq_len(n)
  repeat {
    linkLabel <- pmin(tree[child], tree[parent])
    label <- c(tree, linkLabel, linkLabel)
    byNode <- order(node, label)
    newTree <- label[byNode][!duplicated(node[byNode])]
    newTree <- newTree[newTree]
    if (identical(newTree, tree)) break
    tree <- newTree
  }
  size <- tabulate(tree, nbins = n)[tree]
  number <- match(tree, unique(tree[size > 1L]))
  number[size == 1L] <- 0L
  number
}
