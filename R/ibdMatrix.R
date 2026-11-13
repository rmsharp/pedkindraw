## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 12,
## rulings R46-R48, pedkindraw S16). Written from kinship2's help page for
## ibdMatrix() and from its measured results, not its source (R11, R14).

#' Build an IBD matrix from pairs of ids and their values
#'
#' Turns the identity-by-descent (IBD) values that programs such as SOLAR
#' write, one line per pair of animals, into a symmetric sparse matrix with a
#' row and a column per animal. Such programs list only the pairs with a value
#' above 0, and the matrix stores only those and the diagonal (each animal
#' with itself), which the input gives or \code{diagonal} fills in.
#'
#' It is \code{kinship2}'s \code{ibdMatrix()}, with its arguments. On every
#' case its tests compare with kinship2 (random pairs in which every animal
#' has a diagonal value or \code{diagonal} is given), it gives kinship2's
#' value for every pair. It differs from kinship2 1.9.6.2 in these ways. The
#' rows are the ids given, sorted, where kinship2 often orders them
#' otherwise and, for some number ids, gives a row for every number from 1 to
#' the largest, empty for those not given. \code{idmap} works as kinship2's
#' help page describes it; kinship2 refuses it. It stops, naming the ids,
#' when an id has no diagonal value and \code{diagonal} is not given, where
#' kinship2 returns a diagonal of 0 or, on some such input, never returns. It
#' stops on vectors of unequal length, which kinship2 recycles, and on one
#' pair given two different values, where kinship2 keeps the first. Empty
#' input gives a 0 x 0 matrix.
#'
#' @param id1,id2 the two ids of each pair: numbers, character or factor
#' ids, \code{NA} not allowed. A pair may be given either way round, and
#' twice if with the same value. Instead, \code{id1} may be a data frame or
#' matrix with 3 columns, the ids and the value, with \code{id2} and \code{x}
#' left out.
#' @param x the IBD value of each pair: finite numbers, kept as given. A 0 is
#' not stored.
#' @param idmap optional: a matrix or data frame with 2 columns, the ids as
#' they appear in \code{id1} and \code{id2} (such as SOLAR's own numbers) and
#' the name each is given in the result (such as the animals' own ids). Each
#' id in the pairs must appear in the first column, and once; ids there that
#' are not in the pairs add no row.
#' @param diagonal optional: one number, usually 1, for the diagonal entries
#' the input does not give. Diagonal entries given are kept.
#' @return A \code{dsCMatrix} (package \code{Matrix}): symmetric, its upper
#' triangle stored, with a row and a column per id in \code{id1} or
#' \code{id2}, numbers sorted by value and character ids in byte order. With
#' \code{idmap} the rows keep that order of the ids in the pairs and are
#' named from its second column.
#'
#' @seealso \code{\link{kinship}}
#'
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93.
#'
#' @export
#' @examples
#' ## SOLAR numbers the animals 1 to 4; idmap gives their own ids.
#' idmap <- data.frame(solarId = 1:4, id = c("M12", "F3", "M7", "F10"))
#' ibdMatrix(c(1, 1, 2, 3, 3, 4), c(1, 2, 2, 3, 4, 4),
#'           c(1, 0.5, 1, 1, 0.25, 1), idmap = idmap)
#' ## The pairs as one table, the diagonal entries filled in with 1.
#' pairs <- data.frame(id1 = c("A", "A", "B"), id2 = c("B", "C", "C"),
#'                     x = c(0.5, 0.25, 0.5))
#' ibdMatrix(pairs, diagonal = 1)
ibdMatrix <- function(id1, id2, x, idmap, diagonal) {
  if (is.data.frame(id1) || is.matrix(id1)) {
    if (ncol(id1) != 3L) {
      stop("A table given as id1 must have 3 columns", call. = FALSE)
    }
    if (!missing(id2) || !missing(x)) {
      stop("Give id2 and x only when id1 is not a table", call. = FALSE)
    }
    table <- as.data.frame(id1, stringsAsFactors = FALSE)
    id1 <- table[[1L]]
    id2 <- table[[2L]]
    x <- table[[3L]]
  } else if (missing(id2) || missing(x)) {
    stop("Give id2 and x, or a table with 3 columns as id1", call. = FALSE)
  }
  if (is.factor(id1)) id1 <- as.character(id1)
  if (is.factor(id2)) id2 <- as.character(id2)
  if (length(id1) != length(id2) || length(id1) != length(x)) {
    stop("id1, id2 and x must have the same length", call. = FALSE)
  }
  if (anyNA(id1) || anyNA(id2)) stop("No id may be missing", call. = FALSE)
  if (!is.numeric(x) || !all(is.finite(x))) {
    stop("x must be finite numbers", call. = FALSE)
  }
  if (!missing(diagonal) && !(is.numeric(diagonal) &&
                                length(diagonal) == 1L &&
                                is.finite(diagonal))) {
    stop("diagonal must be one finite number", call. = FALSE)
  }

  ids <- unique(c(id1, id2))
  ids <- if (is.numeric(ids)) {
    sort(ids)
  } else {
    sort(as.character(ids), method = "radix")
  }
  names <- if (missing(idmap)) as.character(ids) else .ibdNames(ids, idmap)

  entries <- .ibdEntries(id1, id2, x, ids)
  lo <- entries$lo
  hi <- entries$hi
  x <- entries$x
  noDiagonal <- setdiff(seq_along(ids), lo[lo == hi])
  if (length(noDiagonal) > 0L) {
    if (missing(diagonal)) {
      stop("Ids with no diagonal value: ", .ibdListed(ids[noDiagonal]),
           ". Give diagonal, for example diagonal = 1", call. = FALSE)
    }
    lo <- c(lo, noDiagonal)
    hi <- c(hi, noDiagonal)
    x <- c(x, rep(as.double(diagonal), length(noDiagonal)))
  }
  .ibdSparse(lo, hi, x, names)
}

## The names idmap gives the sorted ids, after checking idmap: 2 columns, no
## NA, no id or name twice, and every id in its first column.
.ibdNames <- function(ids, idmap) {
  if (!(is.data.frame(idmap) || is.matrix(idmap)) || ncol(idmap) != 2L) {
    stop("idmap must be a matrix or data frame with 2 columns",
         call. = FALSE)
  }
  map <- as.data.frame(idmap, stringsAsFactors = FALSE)
  from <- map[[1L]]
  to <- as.character(map[[2L]])
  if (anyNA(from) || anyNA(to)) {
    stop("No idmap entry may be missing", call. = FALSE)
  }
  if (anyDuplicated(from) > 0L) {
    stop("No id may appear twice in idmap's first column", call. = FALSE)
  }
  if (anyDuplicated(to) > 0L) {
    stop("No name may appear twice in idmap's second column",
         call. = FALSE)
  }
  at <- match(ids, from)
  if (anyNA(at)) {
    stop("Ids not in idmap: ", .ibdListed(ids[is.na(at)]), ".",
         call. = FALSE)
  }
  to[at]
}

## The pairs as entries of the upper triangle: lo and hi, the positions of
## each pair's ids in ids (lo <= hi), and x, its value, once per pair. Stops
## when a pair is given two different values.
.ibdEntries <- function(id1, id2, x, ids) {
  i <- match(id1, ids)
  j <- match(id2, ids)
  lo <- pmin(i, j)
  hi <- pmax(i, j)
  cell <- (as.double(hi) - 1.0) * length(ids) + lo
  conflict <- unique(cell[x != x[match(cell, cell)]])
  if (length(conflict) > 0L) {
    k <- match(conflict, cell)
    stop("Pairs given two different values: ",
         .ibdListed(sprintf("(%s, %s)", ids[lo[k]], ids[hi[k]])), ".",
         call. = FALSE)
  }
  first <- !duplicated(cell)
  list(lo = lo[first], hi = hi[first], x = as.double(x[first]))
}

## The dsCMatrix holding the entries (positions lo <= hi, values x) in its
## upper triangle, its rows and columns named names; a 0 is not stored.
.ibdSparse <- function(lo, hi, x, names) {
  n <- length(names)
  stored <- x != 0.0
  lo <- lo[stored]
  hi <- hi[stored]
  x <- x[stored]
  byColumn <- order(hi, lo)
  methods::new(methods::getClass("dsCMatrix", where = asNamespace("Matrix")),
               Dim = c(n, n), Dimnames = list(names, names), uplo = "U",
               i = lo[byColumn] - 1L,
               p = c(0L, cumsum(tabulate(hi, n))),
               x = x[byColumn])
}

## The values as one string, separated by commas: the first 10 and, when
## there are more, how many more.
.ibdListed <- function(values) {
  values <- as.character(values)
  if (length(values) > 10L) {
    values <- c(values[seq_len(10L)],
                sprintf("and %d more", length(values) - 10L))
  }
  toString(values)
}
