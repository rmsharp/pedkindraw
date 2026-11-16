## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 14,
## rulings R55-R57, pedkindraw S19; rulings R58-R59, pedkindraw S20; plan
## Phase 15c, the layout hints, rulings R62 and R73, pedkindraw S24). New
## code (R7), written from kinship2's help pages for pedigree(), autohint()
## and align.pedigree(), Pedixplorer's help pages for Pedigree(), Ped, Rel,
## Scales, Hints, auto_hint() and align(), and the objects each was measured
## to make, neither package's source read (R11, R14).

#' Convert a kinship2 or Pedixplorer pedigree object to the package's data
#' frames
#'
#' Turns a kinship2 \code{pedigree} or \code{pedigreeList} object, or a
#' Pedixplorer \code{Pedigree} object, back into the data frames the rest of
#' the package takes: a pedigree with one row per animal, and a table of twin
#' pairs; and its layout hints into the form
#' \code{\link{makePedigreeMatingLayout}()} takes.
#'
#' \strong{kinship2 objects.} The rows keep the object's order, which is the
#' order the animals were given to \code{kinship2::pedigree()}. Each parent is
#' read by its own index, so an unknown parent (index 0) never moves another
#' animal's parent. Ids become text: a factor's labels, and whole numbers
#' written in full (\code{"100000"}, not \code{"1e+05"}), so no id is renamed.
#'
#' Sex becomes \code{M}, \code{F} or \code{U}: male, female, and unknown or
#' terminated. kinship2 has no code for a hermaphrodite, so an animal entered
#' as \code{H} comes back \code{U}. A single \code{affected} vector becomes
#' the column \code{affected}; the columns of an \code{affected} matrix become
#' \code{affected_<column name>}, or \code{affected_1}, \code{affected_2} and
#' so on when the matrix has no column names. Their values stay as kinship2
#' holds them: 0, 1 or \code{NA}. A \code{status} of 1 becomes
#' \code{"DECEASED"} and 0 \code{"ALIVE"}. An object with no \code{affected}
#' or no \code{status} gives no such column. kinship2 keeps no other column,
#' so names, dates and the like are not in its objects to convert.
#'
#' Twin pairs come from the object's \code{relation} codes 1, 2 and 3 (MZ, DZ
#' and UZ twins), whether kinship2 stored them as numbers or as text; code 4,
#' a spouse pair, is left out, since the package draws a mating from its
#' offspring.
#'
#' A \code{pedigreeList} (several families) is converted whole when no id
#' appears in two families, with a \code{famid} column naming each animal's
#' family. When ids repeat across families, \code{asPedFrame()} stops and
#' names them (ten at most, in byte order); one family, such as
#' \code{x["2"]}, is a \code{pedigree} and converts on its own.
#'
#' A kinship2 object is a plain list, so it is read without calling kinship2:
#' kinship2 need not be installed, for an object read back from a file for
#' instance. \code{asPedFrame()} stops for a \code{pedigree} or
#' \code{pedigreeList} that lacks a part it needs (\code{id}, \code{findex},
#' \code{mindex}, \code{sex}, and \code{famid} for a \code{pedigreeList}),
#' naming the parts.
#'
#' \strong{Pedixplorer objects.} A \code{Pedigree} is read through
#' Pedixplorer's own functions, so Pedixplorer must be installed;
#' \code{asPedFrame()} stops, saying so, when it is not. The rows keep the
#' object's order. Ids and parents are as the object holds them: when it has
#' families, Pedixplorer has joined each id to its family (\code{"F1_A"}),
#' and a \code{famid} column names each animal's family. Sex becomes
#' \code{M}, \code{F} or \code{U} (Pedixplorer, too, holds a hermaphrodite as
#' unknown).
#'
#' Each condition Pedixplorer holds (one row of \code{fill(x)} and its
#' \code{<name>_mods} column) becomes a column with 0, 1 or \code{NA}:
#' Pedixplorer's default condition \code{affection}, the name it gives a
#' column \code{affected}, becomes \code{affected}; a condition whose name
#' starts with \code{affected} keeps it; any other becomes
#' \code{affected_<name>}. A condition with no known value is left out: an
#' object built with no condition still holds an all-\code{NA}
#' \code{affection}, and that is not a condition. The death status becomes
#' \code{status}: \code{"DECEASED"}, \code{"ALIVE"}, or \code{NA} where it is
#' unknown, with no column when every value is unknown.
#'
#' Then come those of Pedixplorer's fields \code{fertility},
#' \code{miscarriage}, \code{avail}, \code{evaluated}, \code{consultand},
#' \code{proband}, \code{carrier}, \code{asymptomatic}, \code{adopted},
#' \code{dateofbirth} and \code{dateofdeath} that hold anything besides the
#' value Pedixplorer fills in when none is given, under their own names and
#' types (Pedixplorer keeps a \code{birth} column it is given as
#' \code{dateofbirth}, as text). Last come the object's other columns, of
#' its \code{mcols()}, as they are, less Pedixplorer's own (\code{error}, and
#' each condition's and the availability's columns). \code{asPedFrame()}
#' stops when a column name would appear twice (an extra column called
#' \code{sire}, say), naming it. Twin pairs are the MZ, DZ and UZ twins of
#' \code{rel(x)}; spouse pairs are left out.
#'
#' \strong{Layout hints.} An object's layout hints come back in the form
#' \code{\link{makePedigreeMatingLayout}()} takes, so
#' \code{makePedigreeMatingLayout(x$ped, hints = x$hints)} draws with them,
#' once \code{x$ped} has its generations (\code{\link{findGeneration}()}).
#' kinship2 keeps them in the object's \code{hints} element, which a user
#' sets, to \code{kinship2::autohint()}'s result for instance: its
#' \code{order}, one number per animal in the object's order, becomes
#' \code{order}, the numbers named by id (an \code{NA} leaves that animal
#' unnumbered); its \code{spouse} rows (the places of the left and the right
#' animal and an anchor, 1 left, 2 right, 0 either) become \code{mate}, a
#' data frame of the ids \code{left} and \code{right} and the \code{anchor}
#' \code{"left"}, \code{"right"} or \code{"either"}. A \code{pedigreeList}'s
#' hints are read the same way, one number per animal of the whole list.
#' \code{asPedFrame()} stops, saying what is wrong, when they cannot be read
#' as ids: hints that are not a list, an order that is not numbers or not one
#' per animal, or a \code{spouse} table that is not three columns of whole
#' numbers, places from 1 to the number of animals and an anchor 1, 2 or 0.
#' Pedixplorer keeps them in the object's hints, \code{horder()} (already
#' named by id) and \code{spouse()}, read the same way.
#'
#' Both packages make their automatic hints for their own layouts, and some
#' of the mate rows are ones \code{makePedigreeMatingLayout()} refuses.
#' \code{asPedFrame()} fixes them and one message names each change: a pair
#' with no offspring together is left out (both packages ignore it); a pair
#' named in an earlier row is left out, the first row kept (as kinship2
#' keeps it); and an anchor on the partner of the earlier generation
#' (\code{\link{findGeneration}()}) becomes \code{"either"}, its side kept,
#' since the layout draws a mating on the row of its later partner.
#'
#' \code{asPedFrame()} stops for an object of any other class, naming the
#' class.
#'
#' @param x a kinship2 \code{pedigree} or \code{pedigreeList} object, or a
#' Pedixplorer \code{Pedigree} object.
#' @param ... not used.
#' @return A list of three:
#' \describe{
#'   \item{\code{ped}}{a data frame with the character columns \code{id},
#'   \code{sire}, \code{dam} (an unknown parent is \code{NA}) and \code{sex};
#'   then \code{famid} for a \code{pedigreeList} or a \code{Pedigree} with
#'   families; then the condition columns; then \code{status}; and, for a
#'   \code{Pedigree}, Pedixplorer's fields that hold data and the object's
#'   other columns.}
#'   \item{\code{twinRelations}}{a data frame with the character columns
#'   \code{id1}, \code{id2} and \code{code} (\code{"MZ twin"},
#'   \code{"DZ twin"} or \code{"UZ twin"}), or \code{NULL} when the object has
#'   no twin pair.}
#'   \item{\code{hints}}{the object's layout hints as a list of \code{order}
#'   (numbers named by id) and \code{mate} (a data frame of \code{left},
#'   \code{right} and \code{anchor}), each only when the object holds it, or
#'   \code{NULL} when it holds none.}
#' }
#'
#' @seealso \code{\link{checkPedigree}}, \code{\link{checkTwinRelations}},
#' \code{\link{drawPedigreeDiagram}}
#'
#' @export
#' @examples
#' if (requireNamespace("kinship2", quietly = TRUE)) {
#'   ## A and B are the parents of C and D, DZ twins; A has died and C is
#'   ## affected.
#'   p <- kinship2::pedigree(
#'     id = c("A", "B", "C", "D"),
#'     dadid = c(NA, NA, "A", "A"),
#'     momid = c(NA, NA, "B", "B"),
#'     sex = c("male", "female", "male", "female"),
#'     affected = c(0, 0, 1, 0),
#'     status = c(1, 0, 0, 0),
#'     relation = data.frame(id1 = "C", id2 = "D", code = 2)
#'   )
#'   asPedFrame(p)
#'   ## A layout hint: D drawn left of C.
#'   p$hints <- list(order = c(1, 2, 4, 3))
#'   asPedFrame(p)$hints
#' }
#' if (requireNamespace("Pedixplorer", quietly = TRUE)) {
#'   ## The same family as a Pedixplorer object, with a name for each animal.
#'   p <- Pedixplorer::Pedigree(data.frame(
#'     id = c("A", "B", "C", "D"),
#'     dadid = c(NA, NA, "A", "A"),
#'     momid = c(NA, NA, "B", "B"),
#'     sex = c("male", "female", "male", "female"),
#'     affected = c(0, 0, 1, 0),
#'     status = c(1, 0, 0, 0),
#'     name = c("Al", "Bea", "Cy", "Di")
#'   ), rel_df = data.frame(id1 = "C", id2 = "D", code = 2))
#'   asPedFrame(p)
#' }
asPedFrame <- function(x, ...) {
  UseMethod("asPedFrame")
}

#' @rdname asPedFrame
#' @export
asPedFrame.default <- function(x, ...) {
  stop("asPedFrame(): cannot convert an object of class ",
       toString(dQuote(class(x), q = FALSE)),
       "; it converts kinship2's pedigree and pedigreeList objects and ",
       "Pedixplorer's Pedigree objects", call. = FALSE)
}

#' @rdname asPedFrame
#' @export
asPedFrame.pedigree <- function(x, ...) {
  .asPedFrameKinship2(x, family = FALSE)
}

#' @rdname asPedFrame
#' @export
asPedFrame.pedigreeList <- function(x, ...) {
  .asPedFrameKinship2(x, family = TRUE)
}

#' @rdname asPedFrame
#' @export
asPedFrame.Pedigree <- function(x, ...) {
  if (!isS4(x)) {
    return(asPedFrame.default(x))
  }
  if (!.asPedFrameHasPedixplorer()) {
    stop("asPedFrame(): converting a Pedixplorer Pedigree object needs the ",
         "Pedixplorer package, which is not installed", call. = FALSE)
  }
  .asPedFramePedixplorer(x)
}

## The two data frames of a kinship2 pedigree (family FALSE) or pedigreeList
## (family TRUE) object, read from the list's parts (plan R56).
.asPedFrameKinship2 <- function(x, family) {
  needed <- c("id", "findex", "mindex", "sex", if (family) "famid")
  lacking <- setdiff(needed, names(x))
  if (length(lacking) > 0L) {
    stop("asPedFrame(): the object lacks ", toString(lacking), call. = FALSE)
  }
  id <- .asPedFrameText(x[["id"]])
  if (family) {
    repeated <- sort(unique(id[duplicated(id)]), method = "radix")
    if (length(repeated) > 0L) {
      stop("asPedFrame(): ids repeat across families: ",
           toString(utils::head(repeated, 10L)), call. = FALSE)
    }
  }
  parentOf <- function(index) {
    parent <- rep(NA_character_, length(index))
    known <- index > 0L
    parent[known] <- id[index[known]]
    parent
  }
  sexOf <- c(male = "M", female = "F", unknown = "U", terminated = "U")
  ped <- data.frame(id = id, sire = parentOf(x[["findex"]]),
                    dam = parentOf(x[["mindex"]]),
                    sex = unname(sexOf[as.character(x[["sex"]])]),
                    stringsAsFactors = FALSE)
  if (family) {
    ped$famid <- .asPedFrameText(x[["famid"]])
  }
  ped <- .asPedFrameConditions(ped, x[["affected"]])
  if (!is.null(x[["status"]])) {
    ped$status <- ifelse(x[["status"]] == 1L, "DECEASED", "ALIVE")
  }
  list(ped = ped, twinRelations = .asPedFrameTwins(x[["relation"]], id),
       hints = .asPedFrameK2Hints(x[["hints"]], ped))
}

## ped with kinship2's conditions added: a single affected vector as the
## column affected, a matrix's columns as affected_<column name>, or
## affected_<column number> when the matrix has no column names (plan R56).
.asPedFrameConditions <- function(ped, affected) {
  if (is.null(affected)) {
    return(ped)
  }
  if (!is.matrix(affected)) {
    ped$affected <- affected
    return(ped)
  }
  conditionNames <- colnames(affected)
  if (is.null(conditionNames)) {
    conditionNames <- as.character(seq_len(ncol(affected)))
  }
  for (j in seq_len(ncol(affected))) {
    ped[[paste0("affected_", conditionNames[j])]] <- affected[, j]
  }
  ped
}

## Ids as text: a factor's labels, and whole numbers written in full
## ("100000", where as.character() gives "1e+05"; plan R56).
.asPedFrameText <- function(x) {
  text <- as.character(x)
  if (is.numeric(x)) {
    whole <- !is.na(x) & x == trunc(x) & abs(x) < 1e15
    text[whole] <- sprintf("%.0f", x[whole])
  }
  text
}

## The twin pairs of a kinship2 relation table: codes 1-3 (stored as a factor
## or as whole numbers), the spouse code 4 left out; NULL when no pair is
## left (plan R56).
.asPedFrameTwins <- function(relation, id) {
  if (is.null(relation)) {
    return(NULL)
  }
  code <- as.integer(relation[["code"]])
  twin <- code %in% 1L:3L
  .asPedFrameTwinTable(id[relation[["indx1"]][twin]],
                       id[relation[["indx2"]][twin]],
                       c("MZ twin", "DZ twin", "UZ twin")[code[twin]])
}

## The twins table of either package's pairs: id1, id2 and code as text, or
## NULL when there is no pair.
.asPedFrameTwinTable <- function(id1, id2, code) {
  if (length(code) == 0L) {
    return(NULL)
  }
  data.frame(id1 = id1, id2 = id2, code = code, stringsAsFactors = FALSE)
}

## TRUE when Pedixplorer can be loaded (a function of its own, so a test can
## stand in for a machine without it).
.asPedFrameHasPedixplorer <- function() {
  requireNamespace("Pedixplorer", quietly = TRUE)
}

## Pedixplorer's fields and the value it fills in when none is given (plan
## R58): a field is kept only when it holds something else.
.asPedFramePxFields <- list(fertility = "fertile", miscarriage = "FALSE",
                            avail = NA, evaluated = FALSE, consultand = FALSE,
                            proband = FALSE, carrier = NA, asymptomatic = NA,
                            adopted = FALSE, dateofbirth = NA,
                            dateofdeath = NA)

## The two data frames of a Pedixplorer Pedigree object (plan R58).
.asPedFramePedixplorer <- function(x) {
  pd <- Pedixplorer::ped(x)
  sexOf <- c(male = "M", female = "F", unknown = "U")
  ped <- data.frame(id = as.character(Pedixplorer::id(pd)),
                    sire = as.character(Pedixplorer::dadid(pd)),
                    dam = as.character(Pedixplorer::momid(pd)),
                    sex = unname(sexOf[as.character(Pedixplorer::sex(pd))]),
                    stringsAsFactors = FALSE)
  famid <- Pedixplorer::famid(pd)
  if (!all(is.na(famid))) {
    ped$famid <- as.character(famid)
  }
  extra <- as.data.frame(Pedixplorer::mcols(x))
  fill <- Pedixplorer::fill(x)
  added <- c(.asPedFramePxConditions(fill, extra),
             .asPedFramePxStatus(Pedixplorer::deceased(pd)),
             .asPedFramePxKeptFields(pd))
  own <- c("error", fill$column_values, fill$column_mods,
           Pedixplorer::border(x)$column_mods)
  extraNames <- setdiff(names(extra), own)
  columns <- c(names(ped), names(added), extraNames)
  twice <- unique(columns[duplicated(columns)])
  if (length(twice) > 0L) {
    stop("asPedFrame(): column names would appear twice: ", toString(twice),
         call. = FALSE)
  }
  for (name in names(added)) ped[[name]] <- added[[name]]
  for (name in extraNames) ped[[name]] <- extra[[name]]
  rownames(ped) <- NULL
  list(ped = ped,
       twinRelations = .asPedFramePxTwins(as.data.frame(Pedixplorer::rel(x))),
       hints = .asPedFramePxHints(Pedixplorer::hints(x), ped))
}

## The condition columns, in fill's order, each with a known value: affection
## as affected, a name starting "affected" as it is, any other as
## affected_<name> (plan R58).
.asPedFramePxConditions <- function(fill, extra) {
  conditions <- unique(fill[order(fill$order),
                            c("column_values", "column_mods")])
  out <- list()
  for (k in seq_len(nrow(conditions))) {
    mods <- extra[[conditions$column_mods[k]]]
    if (all(is.na(mods))) next
    name <- conditions$column_values[k]
    if (name == "affection") {
      name <- "affected"
    } else if (!startsWith(name, "affected")) {
      name <- paste0("affected_", name)
    }
    out[[name]] <- as.numeric(mods)
  }
  out
}

## status from Pedixplorer's deceased: DECEASED, ALIVE or NA; none when every
## value is unknown (plan R58).
.asPedFramePxStatus <- function(deceased) {
  if (all(is.na(deceased))) {
    return(list())
  }
  list(status = c("ALIVE", "DECEASED")[as.integer(deceased) + 1L])
}

## Pedixplorer's fields that hold anything besides its filled-in value.
.asPedFramePxKeptFields <- function(pd) {
  out <- list()
  for (field in names(.asPedFramePxFields)) {
    value <- methods::slot(pd, field)
    fillIn <- .asPedFramePxFields[[field]]
    same <- if (is.na(fillIn)) {
      is.na(value)
    } else {
      !is.na(value) & as.character(value) == fillIn
    }
    if (!all(same)) out[[field]] <- value
  }
  out
}

## The MZ, DZ and UZ twin pairs of a Pedixplorer relation table, spouses left
## out; NULL when no pair is left (plan R58).
.asPedFramePxTwins <- function(rel) {
  code <- as.character(rel$code)
  twin <- code %in% c("MZ twin", "DZ twin", "UZ twin")
  .asPedFrameTwinTable(as.character(rel$id1[twin]),
                       as.character(rel$id2[twin]), code[twin])
}

## The layout hints of a kinship2 object (x$hints: order, one number per
## animal in the object's order; spouse, rows of two animals' places and an
## anchor, 1 left, 2 right, 0 either) in makePedigreeMatingLayout()'s form,
## or NULL when it holds none (plan R62, R73). Stops on hints it cannot read
## as ids (pedkindraw S24).
.asPedFrameK2Hints <- function(hints, ped) {
  if (is.null(hints)) {
    return(NULL)
  }
  if (!is.list(hints)) {
    stop("asPedFrame(): the object's hints must be a list with the ",
         "elements order and spouse", call. = FALSE)
  }
  id <- ped$id
  hintOrder <- hints[["order"]]
  if (!is.null(hintOrder)) {
    if (!is.numeric(hintOrder) || length(hintOrder) != length(id)) {
      stop("asPedFrame(): the object's hints$order must be numbers, one ",
           "per animal (", length(id), "); it is ", typeof(hintOrder),
           " of length ", length(hintOrder), call. = FALSE)
    }
    hintOrder <- stats::setNames(hintOrder, id)
  }
  .asPedFrameHints(hintOrder, .asPedFrameK2Mate(hints[["spouse"]], id), ped)
}

## kinship2's spouse rows as mate rows of ids, or NULL when it has none.
## Stops unless it is three columns of whole numbers: two animals' places,
## 1 to n, and an anchor, 1, 2 or 0.
.asPedFrameK2Mate <- function(spouse, id) {
  if (NROW(spouse) == 0L) {
    return(NULL)
  }
  spouse <- as.matrix(spouse)
  n <- length(id)
  readable <- is.numeric(spouse) && ncol(spouse) == 3L && !anyNA(spouse) &&
    all(spouse == trunc(spouse)) &&
    all(spouse[, 1L:2L] >= 1L & spouse[, 1L:2L] <= n) &&
    all(spouse[, 3L] %in% 0L:2L)
  if (!readable) {
    stop("asPedFrame(): the object's hints$spouse must have three columns ",
         "of whole numbers: the places of two animals (1 to ", n, ") and ",
         "an anchor, 1, 2 or 0", call. = FALSE)
  }
  data.frame(left = id[spouse[, 1L]], right = id[spouse[, 2L]],
             anchor = c("either", "left", "right")[spouse[, 3L] + 1L],
             stringsAsFactors = FALSE)
}

## The layout hints of a Pedixplorer Hints object (horder named by id;
## spouse with idl, idr and an ordered factor anchor) in
## makePedigreeMatingLayout()'s form, or NULL when it holds none (plan R62,
## R73).
.asPedFramePxHints <- function(h, ped) {
  spouse <- Pedixplorer::spouse(h)
  hintMate <- NULL
  if (nrow(spouse) > 0L) {
    hintMate <- data.frame(left = as.character(spouse$idl),
                           right = as.character(spouse$idr),
                           anchor = as.character(spouse$anchor),
                           stringsAsFactors = FALSE)
  }
  .asPedFrameHints(Pedixplorer::horder(h), hintMate, ped)
}

## The order and mate hints as one list, NULL when neither asks for
## anything: an NA in the order leaves that animal unnumbered, and mate rows
## makePedigreeMatingLayout() would refuse are changed
## (.asPedFrameUsableMate()).
.asPedFrameHints <- function(hintOrder, hintMate, ped) {
  hintOrder <- hintOrder[!is.na(hintOrder)]
  if (!is.null(hintMate)) {
    hintMate <- .asPedFrameUsableMate(hintMate, ped)
  }
  hints <- list(order = hintOrder, mate = hintMate)
  hints <- hints[lengths(hints) > 0L]
  if (length(hints) == 0L) NULL else hints
}

## Mate rows made usable by makePedigreeMatingLayout(), each change named in
## one message (pedkindraw S24): a pair with no offspring together left out
## (kinship2 and Pedixplorer ignore it); a pair named before left out, the
## first row kept (as kinship2 keeps it); an anchor on the partner of the
## earlier generation set to "either", its side kept. NULL when no row is
## left.
.asPedFrameUsableMate <- function(hintMate, ped) {
  left <- hintMate$left
  right <- hintMate$right
  both <- !is.na(ped$sire) & !is.na(ped$dam)
  pairs <- c(paste(ped$sire[both], ped$dam[both], sep = "\u0001"),
             paste(ped$dam[both], ped$sire[both], sep = "\u0001"))
  together <- paste(left, right, sep = "\u0001") %in% pairs
  key <- ifelse(left < right, paste(left, right, sep = "\u0001"),
                paste(right, left, sep = "\u0001"))
  again <- together & duplicated(key)
  keep <- together & !again
  gen <- stats::setNames(findGeneration(ped$id, ped$sire, ped$dam), ped$id)
  gen[is.na(gen)] <- 0L
  anchored <- ifelse(hintMate$anchor == "left", left, right)
  other <- ifelse(hintMate$anchor == "left", right, left)
  early <- keep & hintMate$anchor != "either" & gen[anchored] < gen[other]
  pairText <- function(i) toString(paste(left[i], "and", right[i]))
  changes <- c(
    if (!all(together)) {
      paste0("left out, no offspring together: ", pairText(!together))
    },
    if (any(again)) {
      paste0("left out, pair named before: ", pairText(again))
    },
    if (any(early)) {
      paste0("anchor set to \"either\", it named the partner of the ",
             "earlier generation: ", pairText(early))
    }
  )
  if (length(changes) > 0L) {
    message("asPedFrame(): changed the object's mate hints so that ",
            "makePedigreeMatingLayout() can use them; ",
            paste(changes, collapse = "; "))
  }
  hintMate$anchor[early] <- "either"
  hintMate <- hintMate[keep, , drop = FALSE]
  rownames(hintMate) <- NULL
  if (nrow(hintMate) == 0L) NULL else hintMate
}
