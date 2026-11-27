## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (pedkindraw S74, plan
## Phase G17a, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R149, docs/planning/pedigree-app-plan.md sections 5, 7 and 11;
## choosing the animals pedkindraw S75, Phase G17b, R150, section 12; what is
## drawn, the conditions, marks, lines and twins, pedkindraw S76, Phase G17c,
## R151, section 13; saving the drawing and the animals, pedkindraw S77, Phase
## G17d, R152, section 14; a file separated by tabs or semicolons, and the
## deceased mark's words, pedkindraw S97, backlog item "What 17m's check of
## NEWS found outside NEWS").
## The app runPedigreeApp() starts: its page and its server, internal so they
## can change (R148). shiny is in Suggests, so every shiny call is written
## shiny:: and runs only after runPedigreeApp() has found shiny.

## The names the app recognises for each of the four columns, in the order it
## prefers them (R149): pedkindraw's own, nprcgenekeepr's (egoid, sireid,
## damid) and Pedixplorer's app's (indid, dadid, fatherid, momid, motherid,
## gender). A column's name is compared after lower-casing it and removing
## spaces, dots and underscores.
.appColumnNames <- list(
  id = c("id", "ego", "egoid", "indid"),
  sire = c("sire", "sireid", "father", "fatherid", "dadid"),
  dam = c("dam", "damid", "mother", "motherid", "momid"),
  sex = c("sex", "gender")
)

## The sex values the app reads as pedkindraw's codes (R149), keyed by the
## value lower-cased with its spaces at either end removed; 1 and 2 are
## kinship2's and PLINK's male and female.
.appSexCodes <- c(m = "M", male = "M", "1" = "M",
                  f = "F", female = "F", "2" = "F",
                  h = "H", hermaphrodite = "H",
                  u = "U", unknown = "U")

#' A column's name as the app compares it: lower case, without spaces, dots
#' and underscores
#'
#' S76's REFACTOR: the four helpers that find a column by its name had each
#' written this out.
#' @param columns the names.
#' @return The names so compared.
#' @noRd
.appNameKey <- function(columns) {
  gsub("[ ._]", "", tolower(columns))
}

#' Guess which of a file's columns are id, sire, dam and sex
#'
#' S76's REFACTOR: the names looked for are an argument, so the marks are
#' found the same way (\code{.appFindMarks()}).
#' @param columns the file's column names.
#' @param names the names looked for, a list named by what each finds, each
#'   element its names in the order preferred.
#' @return A character vector named as \code{names} (id, sire, dam and sex by
#'   default): for each, the first column whose name is the earliest of its
#'   names, or \code{NA} where none matches.
#' @noRd
.guessAppColumns <- function(columns, names = .appColumnNames) {
  key <- .appNameKey(columns)
  vapply(names, function(wanted) {
    for (name in wanted) {
      hit <- which(key == name)
      if (length(hit) > 0L) {
        return(columns[[hit[[1L]]]])
      }
    }
    NA_character_
  }, character(1L))
}

#' Read the common sex codes as M, F, H and U
#'
#' @param sex the sex values, of any type.
#' @return A character vector: each value of \code{.appSexCodes} read as its
#'   code, any other value (and \code{NA}) as it was.
#' @noRd
.readSexCodes <- function(sex) {
  sex <- as.character(sex)
  read <- unname(.appSexCodes[tolower(trimws(sex))])
  known <- !is.na(read)
  sex[known] <- read[known]
  sex
}

#' Say which sex values the app read as which code
#'
#' @param sex the sex values as the file holds them.
#' @return One sentence naming each value read as another, in the order the
#'   values first appear, or \code{""} when none changed.
#' @noRd
.sexCodeNote <- function(sex) {
  sex <- as.character(sex)
  read <- .readSexCodes(sex)
  changed <- !is.na(sex) & sex != read
  if (!any(changed)) {
    return("")
  }
  paste0("Sex values read as pedkindraw's codes: ",
         toString(unique(paste(sex[changed], "as", read[changed]))), ".")
}

#' The sample pedigree's file
#' @noRd
.appSamplePath <- function() {
  system.file("extdata", "obfuscated_rhesus_mhc_ped.csv",
              package = "pedkindraw")
}

#' The sample pedigree's twins file (G17c, R151)
#' @noRd
.appSampleTwinsPath <- function() {
  system.file("extdata", "obfuscated_rhesus_mhc_twin_relations.csv",
              package = "pedkindraw")
}

#' The separator of a pedigree file
#'
#' pedkindraw S97 (backlog item "What 17m's check of NEWS found outside
#' NEWS"; Mark's pick "Read all three"): of a comma, a tab and a semicolon,
#' the one that splits the file's first line into the most columns, outside
#' quotes; a comma on a tie and for a file with no line.
#' @param path the file.
#' @return \code{","}, \code{"\t"} or \code{";"}.
#' @noRd
.appSeparator <- function(path) {
  first <- readLines(path, n = 1L, warn = FALSE)
  separators <- c(",", "\t", ";")
  columns <- vapply(separators, function(sep) {
    length(scan(text = first, what = "", sep = sep, quote = "\"",
                comment.char = "", quiet = TRUE))
  }, 1L)
  separators[[which.max(columns)]]
}

#' Read a pedigree file as text
#'
#' Its values separated by commas, tabs or semicolons
#' (\code{.appSeparator()}, S97).
#' @param path the file.
#' @return A list: \code{data}, the file's rows with every column as text and
#'   empty cells as \code{NA} (\code{NULL} when it could not be read), and
#'   \code{problem}, what went wrong or \code{""}.
#' @noRd
.readAppFile <- function(path) {
  data <- tryCatch(
    utils::read.csv(path, sep = .appSeparator(path), colClasses = "character",
                    na.strings = c("", "NA"), check.names = FALSE),
    error = function(e) e
  )
  if (inherits(data, "error")) {
    return(list(data = NULL, problem = paste("The file could not be read:",
                                             conditionMessage(data))))
  }
  list(data = data, problem = "")
}

#' What is wrong with the rows read, for the page to say
#'
#' @param data the rows read, or \code{NULL}.
#' @param readProblem what went wrong reading them, or \code{""}.
#' @return The first problem found, or \code{""}.
#' @noRd
.appTableProblem <- function(data, readProblem) {
  if (nzchar(readProblem) || is.null(data)) {
    return(readProblem)
  }
  if (ncol(data) < 4L) {
    columns <- ngettext(ncol(data), "%d column", "%d columns")
    return(sprintf(paste0("The file has ", columns, "; the app needs at ",
                          "least four: id, sire, dam and sex."), ncol(data)))
  }
  if (nrow(data) == 0L) {
    return("The file has no animals.")
  }
  ""
}

#' What is wrong with the columns chosen, for the page to say
#'
#' @param columns the columns chosen so far: fewer than four until each of
#'   id, sire, dam and sex has been given one.
#' @return The problem, or \code{""}.
#' @noRd
.appColumnProblem <- function(columns) {
  if (length(columns) < 4L) {
    return("")
  }
  if (!all(nzchar(columns))) {
    return("Choose a column for each of id, sire, dam and sex.")
  }
  if (anyDuplicated(columns) > 0L) {
    return("Choose a different column for each of id, sire, dam and sex.")
  }
  ""
}

#' The pedigree the app draws, from the rows read and the columns chosen
#'
#' @param data the rows read.
#' @param columns the columns chosen, named id, sire, dam and sex.
#' @return A data frame: id, sire and dam as text, sex read by
#'   \code{.readSexCodes()}, then the other columns but any whose name is one
#'   of the four.
#' @noRd
.appPedigree <- function(data, columns) {
  four <- data.frame(id = as.character(data[[columns[["id"]]]]),
                     sire = as.character(data[[columns[["sire"]]]]),
                     dam = as.character(data[[columns[["dam"]]]]),
                     sex = .readSexCodes(data[[columns[["sex"]]]]))
  rest <- !names(data) %in% c(columns, names(columns))
  cbind(four, data[, rest, drop = FALSE])
}

#' Add a row for each parent with no row of its own (R150)
#'
#' @param ped the pedigree.
#' @return A list: \code{ped}, the pedigree with \code{addParents()}'s rows
#'   (unchanged when every parent has a row), and \code{added}, the ids
#'   added.
#' @noRd
.appAddParents <- function(ped) {
  parents <- c(ped$sire, ped$dam)
  if (!any(!is.na(parents) & !parents %in% ped$id)) {
    return(list(ped = ped, added = character(0L)))
  }
  ped <- addParents(ped)
  list(ped = ped, added = ped$id[ped$recordStatus == "added"])
}

#' The ids typed in the focal box
#'
#' @param text what was typed, or \code{NULL}.
#' @return The ids, split at commas, semicolons, spaces, tabs and new lines,
#'   each once, in the order typed.
#' @noRd
.appFocalIds <- function(text) {
  ids <- as.character(unlist(strsplit(as.character(text), "[,;[:space:]]+")))
  unique(ids[nzchar(ids)])
}

#' The families the app lists, for a select input
#'
#' @param family each animal's family, from \code{findPedigreeNumber()}.
#' @return The families of two or more animals, largest first (the lower
#'   number first among equals), each named "Family n: k animals".
#' @noRd
.appFamilyChoices <- function(family) {
  sizes <- table(family)
  sizes <- sizes[sizes >= 2L]
  numbers <- as.character(names(sizes))
  numbers <- numbers[order(-as.integer(sizes), as.numeric(numbers))]
  stats::setNames(numbers, sprintf("Family %s: %d animals", numbers,
                                   as.integer(sizes[numbers])))
}

#' Say how many animals the family list leaves out
#'
#' @param family each animal's family, from \code{findPedigreeNumber()}.
#' @return A sentence counting the families of one animal, or \code{""}.
#' @noRd
.appAloneNote <- function(family) {
  n <- sum(table(family) == 1L)
  if (n == 0L) {
    return("")
  }
  sprintf(ngettext(n,
                   "%s animal has no relative in the file and is not listed.",
                   paste("%s animals have no relative in the file and are not",
                         "listed.")),
          format(n, big.mark = ","))
}

#' Focal animals with their ancestors and descendants (F7, R150)
#'
#' @param ped the pedigree.
#' @param focal the focal animals' ids, each with a row.
#' @return The rows of \code{ped} that are the focal animals, their
#'   ancestors and their descendants, with each other parent of theirs added,
#'   its \code{sire} and \code{dam} set to \code{NA}; in \code{ped}'s order.
#' @noRd
.appLineal <- function(ped, focal) {
  keep <- union(trimPedigree(ped, focal)$id,
                getDescendantPedigree(ped, focal)$id)
  kept <- ped[ped$id %in% keep, ]
  parents <- c(kept$sire, kept$dam)
  outside <- parents[!is.na(parents) & !parents %in% keep]
  lineal <- ped[ped$id %in% c(keep, outside), ]
  added <- lineal$id %in% outside
  lineal$sire[added] <- NA
  lineal$dam[added] <- NA
  lineal
}

#' Choose the animals to draw (F6-F8, R150)
#'
#' @param ped the pedigree, every parent with a row of its own.
#' @param view \code{"all"}, \code{"family"}, \code{"lineal"} or
#'   \code{"near"}.
#' @param focal the focal animals' ids as typed; an id with no row is left
#'   out.
#' @param close how close, for \code{"near"}.
#' @param family the family chosen, or \code{NULL}.
#' @param families each animal's family, for \code{"family"}.
#' @return A list: \code{rows}, the animals chosen (\code{NULL} when none can
#'   be chosen yet or they could not be chosen), and \code{problem}, what the
#'   page says, or \code{""}.
#' @noRd
.appChooseAnimals <- function(ped, view, focal, close, family, families) {
  focal <- intersect(focal, ped$id)
  if (view %in% c("lineal", "near") && length(focal) == 0L) {
    return(list(rows = NULL, problem = ""))
  }
  if (view == "near" && !(is.numeric(close) && length(close) == 1L &&
                            is.finite(close) && close >= 1.0)) {
    return(list(rows = NULL,
                problem = "Choose how close: a number, 1 or more."))
  }
  rows <- tryCatch(switch(
    view,
    family = if (is.null(family)) {
      NULL
    } else {
      ped[as.character(families) %in% family, ]
    },
    lineal = .appLineal(ped, focal),
    near = getNearRelativePedigree(ped, focal, close),
    ped
  ), error = function(e) e)
  if (inherits(rows, "error")) {
    return(list(rows = NULL, problem = sprintf(paste0(
      "The animals could not be chosen (%s). The Checks tab lists the ",
      "records' problems."), conditionMessage(rows))))
  }
  list(rows = rows, problem = "")
}

## What is drawn (pedkindraw S76, Phase G17c, R151; plan section 13).

## The words a condition or a yes-or-no mark reads as yes and as no (R151),
## compared in lower case with the spaces at either end removed.
.appYesWords <- c("true", "t", "yes", "y", "1")
.appNoWords <- c("false", "f", "no", "n", "0")

#' Read a condition's or a yes-or-no mark's values (R151)
#'
#' @param x the column: text, as a file gives it, or a column given in R.
#' @param numbers whether a column all of whose values are numbers is read as
#'   numbers (a condition's, so a cut-off can apply) rather than as yes and
#'   no.
#' @return A list: \code{values}, \code{TRUE}, \code{FALSE} or \code{NA} for
#'   each animal (the numbers, when \code{numbers} is \code{TRUE} and every
#'   value is one), an empty cell \code{NA}; and \code{unread}, each value
#'   read as neither, once, as the column holds it. A logical column, and a
#'   number column when \code{numbers} is \code{TRUE}, are kept as they are.
#' @noRd
.appReadValues <- function(x, numbers = FALSE) {
  if (is.factor(x)) x <- as.character(x)
  if (is.logical(x) || (numbers && is.numeric(x))) {
    return(list(values = x, unread = x[0L]))
  }
  if (is.numeric(x)) {
    odd <- !is.na(x) & !x %in% c(0.0, 1.0)
    values <- x == 1.0
    values[odd] <- NA
    return(list(values = values, unread = unique(x[odd])))
  }
  text <- trimws(as.character(x))
  text[!is.na(text) & !nzchar(text)] <- NA
  if (numbers) {
    number <- suppressWarnings(as.numeric(text))
    if (all(is.na(text) | !is.na(number))) {
      return(list(values = number, unread = character(0L)))
    }
  }
  key <- tolower(text)
  values <- rep(NA, length(key))
  values[key %in% .appYesWords] <- TRUE
  values[key %in% .appNoWords] <- FALSE
  list(values = values, unread = unique(x[!is.na(text) & is.na(values)]))
}

#' Whether a condition's column needs a cut-off: it holds numbers other than
#' 0 and 1
#' @noRd
.appNeedsCutoff <- function(x) {
  values <- .appReadValues(x, numbers = TRUE)$values
  is.numeric(values) && any(!is.na(values) & !values %in% c(0.0, 1.0))
}

#' A cut-off as conditionThresholds takes it
#'
#' @param op the comparison chosen, or \code{NULL} for \code{">"}.
#' @param value the number, or \code{NULL} or \code{NA} when none is given.
#' @return The cut-off, such as \code{">= 126"}, or \code{NA} when there is
#'   no number.
#' @noRd
.appCutoff <- function(op, value) {
  if (is.null(value) || length(value) != 1L || !is.finite(value)) {
    return(NA_character_)
  }
  paste(if (is.null(op)) ">" else op, value)
}

#' Guess a file's conditions (R151)
#'
#' @param columns the file's column names.
#' @return The first four whose names begin with "affected", case, spaces,
#'   dots and underscores ignored.
#' @noRd
.guessAppConditions <- function(columns) {
  columns <- as.character(columns)
  utils::head(columns[startsWith(.appNameKey(columns), "affected")], 4L)
}

#' The names the drawing gives the conditions chosen (R151)
#'
#' A name that begins "affected" in any case keeps its rest; any other is
#' put after "affected_". The layout then draws each and labels it
#' "Affected (its name)" (\code{.conditionLabels()}).
#' @param columns the columns chosen.
#' @return The names, made unique.
#' @noRd
.appConditionNames <- function(columns) {
  affected <- startsWith(tolower(columns), "affected")
  named <- paste0("affected", ifelse(affected, substring(columns, 9L),
                                     paste0("_", columns)))
  make.unique(named, sep = "_")
}

## The marks the app finds by name (R151): pedkindraw's column for each, and
## the names it is found by, compared as .guessAppColumns() compares them,
## pedkindraw's own first, then Pedixplorer's (avail, deceased).
.appMarkNames <- list(genotyped = c("genotyped", "avail"),
                      carrier = "carrier", proband = "proband",
                      consultand = "consultand", evaluated = "evaluated",
                      fertility = "fertility", miscarriage = "miscarriage",
                      status = c("status", "deceased"), name = "name")

## What the page calls each mark.
.appMarkWords <- c(genotyped = "genotyped", carrier = "carrier",
                   proband = "proband", consultand = "consultand",
                   evaluated = "evaluated", fertility = "fertility",
                   miscarriage = "miscarriage", status = "deceased",
                   name = "name")

#' Find the marks' columns by name (R151)
#'
#' S76's REFACTOR: found by \code{.guessAppColumns()}, which had the same
#' search.
#' @param columns the columns the marks may be in.
#' @return The columns found, named by pedkindraw's column for each mark, in
#'   the order of \code{.appMarkNames}.
#' @noRd
.appFindMarks <- function(columns) {
  found <- .guessAppColumns(columns, .appMarkNames)
  found[!is.na(found)]
}

#' Say which marks the app found
#'
#' @param marks what \code{.appFindMarks()} returns.
#' @return One sentence naming each mark, and its column when the column's
#'   name is not the mark's, or \code{""} when none was found.
#' @noRd
.appMarkNote <- function(marks) {
  if (length(marks) == 0L) {
    return("")
  }
  words <- .appMarkWords[names(marks)]
  shown <- ifelse(marks == words, words,
                  sprintf("%s (column '%s')", words, marks))
  paste0("Marks from the file: ", toString(shown), ".")
}

## The words a status or deceased column is read by (R151; S97, Mark's pick
## "More words; name the rest"): nprcgenekeepr's status words
## (convertStatusCodes()) without its numbers, whose 1 is alive where
## kinship2's and Pedixplorer's is dead; with the yes-words as deceased and the
## no-words as living. Compared as .appDeceased() compares them.
.appDeceasedWords <- c("deceased", "dead", "died", "d")
.appLivingWords <- c("alive", "a", "shipped", "sold", "sale", "s", "unknown",
                     "u")

#' Read a deceased column (R151)
#'
#' @param x the column.
#' @return \code{"DECEASED"} for \code{.appDeceasedWords} (DECEASED, dead,
#'   died, D) and the yes-words, in any case and with the spaces at either end
#'   removed; \code{NA} for anything else.
#' @noRd
.appDeceased <- function(x) {
  key <- tolower(trimws(as.character(x)))
  ifelse(key %in% c(.appDeceasedWords, .appYesWords), "DECEASED",
         NA_character_)
}

#' The values of a status or deceased column the app cannot read (S97)
#'
#' @param x the column.
#' @return Each value that is neither deceased nor living (\code{.appDeceased()}
#'   and \code{.appLivingWords}, the yes- and no-words, an empty cell), once,
#'   as the column holds it (a factor's as text).
#' @noRd
.appUnreadStatus <- function(x) {
  if (is.factor(x)) x <- as.character(x)
  key <- tolower(trimws(as.character(x)))
  read <- is.na(x) | !nzchar(key) |
    key %in% c(.appDeceasedWords, .appYesWords, .appLivingWords, .appNoWords)
  unique(x[!read])
}

#' The values of a fertility or miscarriage column pedkindraw cannot read
#'
#' @param x the column.
#' @param mark \code{"fertility"} or \code{"miscarriage"}.
#' @return Each value whose key is not among pedkindraw's words for it
#'   (\code{.fertilityWords}, \code{.miscarriageWords}), once.
#' @noRd
.appUnreadWords <- function(x, mark) {
  if (is.factor(x)) x <- as.character(x)
  key <- tolower(as.character(x))
  if (mark == "fertility") {
    words <- .fertilityWords
  } else {
    words <- .miscarriageWords
    key <- gsub("[[:space:]]", "", key)
  }
  unique(x[!is.na(x) & !key %in% names(words)])
}

## The twin codes the app reads (R151), as Pedixplorer's rel_code_to_factor()
## reads them: keyed by the code in lower case without spaces; kinship2 numbers
## them 1 to 4.
.appTwinCodes <- c(mztwin = "MZ twin", dztwin = "DZ twin", uztwin = "UZ twin",
                   spouse = "Spouse", "1" = "MZ twin", "2" = "DZ twin",
                   "3" = "UZ twin", "4" = "Spouse")

#' Read a twins file's rows (R151)
#'
#' @param rows the file's rows, or \code{NULL}.
#' @return A list: \code{twins}, the pairs (\code{id1}, \code{id2} and
#'   \code{code}, its codes read by \code{.appTwinCodes}), or \code{NULL};
#'   and \code{problem}, what is wrong with the file, or \code{""}.
#' @noRd
.appReadTwins <- function(rows) {
  if (is.null(rows)) {
    return(list(twins = NULL, problem = ""))
  }
  needed <- c("id1", "id2", "code")
  at <- match(needed, .appNameKey(names(rows)))
  if (anyNA(at)) {
    return(list(twins = NULL, problem = sprintf(
      "The twins file needs the columns id1, id2 and code; missing: %s.",
      toString(needed[is.na(at)])
    )))
  }
  twins <- data.frame(id1 = as.character(rows[[at[[1L]]]]),
                      id2 = as.character(rows[[at[[2L]]]]),
                      code = as.character(rows[[at[[3L]]]]))
  if (nrow(twins) == 0L) {
    return(list(twins = NULL, problem = "The twins file has no pairs."))
  }
  empty <- which(Reduce(`|`, lapply(twins, function(x) {
    is.na(x) | !nzchar(trimws(x))
  })))
  if (length(empty) > 0L) {
    return(list(twins = NULL, problem = sprintf(
      ngettext(length(empty), "The twins file has an empty cell in row %s.",
               "The twins file has empty cells in rows %s."),
      toString(empty)
    )))
  }
  read <- .appTwinCodes[gsub("[[:space:]]", "", tolower(twins$code))]
  twins$code <- ifelse(is.na(read), twins$code, unname(read))
  list(twins = twins, problem = "")
}

#' The twin pairs both of whose animals are drawn
#'
#' @param twins the pairs, or \code{NULL}.
#' @param ids the animals drawn.
#' @return The pairs, or \code{NULL} when none is (the layout stops on a
#'   twins table with no rows, plan section 13.2).
#' @noRd
.appTwinsInView <- function(twins, ids) {
  if (is.null(twins)) {
    return(NULL)
  }
  kept <- twins[twins$id1 %in% ids & twins$id2 %in% ids, , drop = FALSE]
  if (nrow(kept) == 0L) {
    return(NULL)
  }
  rownames(kept) <- NULL
  kept
}

#' The data frame the app draws (R151)
#'
#' @param rows the animals chosen, with the file's columns.
#' @param conditions the columns chosen as conditions, in order.
#' @param cutoffs the cut-off of each, named by the column, \code{NA} where
#'   none is given.
#' @param marks the marks' columns, from \code{.appFindMarks()}.
#' @return A list: \code{ped}, the four columns, then each condition drawn
#'   (named by \code{.appConditionNames()}), then each mark drawn (named by
#'   pedkindraw's column); \code{thresholds}, the cut-offs of the conditions
#'   drawn, named by their new names, or \code{NULL}; and \code{notes}, a
#'   sentence for each column not drawn, saying why.
#' @noRd
.appDrawnPedigree <- function(rows, conditions, cutoffs, marks) {
  ped <- data.frame(id = rows$id, sire = rows$sire, dam = rows$dam,
                    sex = rows$sex)
  notes <- character(0L)
  thresholds <- character(0L)
  drawnNames <- .appConditionNames(conditions)
  for (i in seq_along(conditions)) {
    column <- conditions[[i]]
    read <- .appReadValues(rows[[column]], numbers = TRUE)
    if (length(read$unread) > 0L) {
      notes <- c(notes, sprintf(paste0(
        "The column '%s' is not drawn: the app cannot read %s as yes or no."
      ), column, .oddValuesShown(read$unread)))
      next
    }
    if (.appNeedsCutoff(read$values)) {
      cut <- if (column %in% names(cutoffs)) cutoffs[[column]] else NA
      if (is.na(cut)) {
        notes <- c(notes, sprintf(paste0(
          "The column '%s' is not drawn until it has a cut-off: it holds ",
          "numbers other than 0 and 1."
        ), column))
        next
      }
      thresholds[[drawnNames[[i]]]] <- cut
    }
    ped[[drawnNames[[i]]]] <- read$values
  }
  for (mark in names(marks)) {
    column <- marks[[mark]]
    x <- rows[[column]]
    how <- ""
    unread <- NULL
    if (mark %in% c("fertility", "miscarriage")) {
      unread <- .appUnreadWords(x, mark)
      value <- x
    } else if (mark == "status") {
      unread <- .appUnreadStatus(x)
      value <- .appDeceased(x)
      how <- " as deceased or living"
    } else if (mark == "name") {
      value <- as.character(x)
    } else {
      read <- .appReadValues(x)
      unread <- read$unread
      value <- read$values
      how <- " as yes or no"
    }
    if (length(unread) > 0L) {
      notes <- c(notes, sprintf(
        "The column '%s' is not drawn: the app cannot read %s%s.", column,
        .oddValuesShown(unread), how
      ))
      next
    }
    ped[[mark]] <- value
  }
  list(ped = ped,
       thresholds = if (length(thresholds) == 0L) NULL else thresholds,
       notes = notes)
}

#' The JavaScript a drawing runs when clicked: it sends the clicked nodes'
#' ids to the server's input "clicked", even when they are the same as last
#' time
#' @noRd
.appClickJs <- paste0("function(n) { Shiny.setInputValue('clicked', n.nodes, ",
                      "{priority: 'event'}); }")

#' The animals a click landed on
#'
#' @param nodes the clicked nodes' ids, as the drawing sends them.
#' @param duplicateToReal the drawing's repeat nodes, named by their ids, or
#'   \code{NULL}.
#' @return The animals' ids: a repeat node is its animal, a mating dot or a
#'   routing point is none.
#' @noRd
.appClickedAnimals <- function(nodes, duplicateToReal) {
  ids <- as.character(unlist(nodes))
  repeats <- ids %in% names(duplicateToReal)
  ids[repeats] <- unname(duplicateToReal[ids[repeats]])
  unique(ids[repeats | !grepl(.reservedIdPattern, ids)])
}

#' Draw a pedigree, keeping what the functions said
#'
#' Adds \code{gen} with \code{findGeneration()} and draws with
#' \code{makePedigreeMatingLayout()} and \code{drawPedigreeDiagram()}. Their
#' warnings and messages, which would reach only the console, are kept as
#' notes, and an error is kept instead of stopping the app.
#'
#' @param ped the pedigree.
#' @param onClick passed to \code{drawPedigreeDiagram()}.
#' @param edgeStyle passed to both functions (G17c: the two must agree, plan
#'   section 13.2).
#' @param twinRelations,conditionThresholds passed to
#'   \code{makePedigreeMatingLayout()} (G17c).
#' @return A list: \code{widget} (\code{NULL} when the drawing failed),
#'   \code{notes}, \code{error} (\code{NULL} or the error's message),
#'   \code{duplicateToReal}, the layout's repeat nodes, and \code{layout}
#'   (each \code{NULL} when the drawing failed).
#' @noRd
.appDraw <- function(ped, onClick = NULL, edgeStyle = "rectilinear",
                     twinRelations = NULL, conditionThresholds = NULL) {
  kept <- new.env(parent = emptyenv())
  kept$notes <- character(0L)
  keep <- function(condition, restart) {
    kept$notes <- c(kept$notes, trimws(conditionMessage(condition)))
    invokeRestart(restart)
  }
  drawn <- withCallingHandlers(
    tryCatch({
      ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
      layout <- makePedigreeMatingLayout(
        ped, edgeStyle = edgeStyle, twinRelations = twinRelations,
        conditionThresholds = conditionThresholds
      )
      list(widget = drawPedigreeDiagram(layout, edgeStyle = edgeStyle,
                                        onClick = onClick),
           duplicateToReal = layout$duplicateToReal, layout = layout)
    }, error = function(e) e),
    warning = function(w) keep(w, "muffleWarning"),
    message = function(m) keep(m, "muffleMessage")
  )
  if (inherits(drawn, "error")) {
    return(list(widget = NULL, notes = kept$notes,
                error = conditionMessage(drawn), duplicateToReal = NULL,
                layout = NULL))
  }
  list(widget = drawn$widget, notes = kept$notes, error = NULL,
       duplicateToReal = drawn$duplicateToReal, layout = drawn$layout)
}

#' How many animals a drawing shows
#' @noRd
.appDrawnCount <- function(widget) {
  ids <- as.character(widget$x$nodes$id)
  n <- sum(!startsWith(ids, "__"))
  sprintf(ngettext(n, "%d animal drawn", "%d animals drawn"), n)
}

## Saving the drawing and the animals (pedkindraw S77, Phase G17d, R152; plan
## section 14).

#' Whether the drawing can be saved as a picture here (R152)
#'
#' \code{savePedigreeDiagram()} needs the chromote package and Google Chrome
#' or Chromium. \code{chromote::find_chrome()} returns \code{CHROMOTE_CHROME}
#' as it is, whether or not a file is there (plan section 14.3), so the path
#' it names must be a file or a command on the path.
#' @return \code{""} when both are found, or a sentence saying which is
#'   missing.
#' @noRd
.appPictureProblem <- function() {
  if (!requireNamespace("chromote", quietly = TRUE)) {
    return(paste0("Saving the drawing as a picture needs the chromote ",
                  "package: install.packages(\"chromote\")."))
  }
  chrome <- suppressMessages(chromote::find_chrome())
  if (is.null(chrome) || !(file.exists(chrome) || nzchar(Sys.which(chrome)))) {
    return(paste0("Saving the drawing as a picture needs Google Chrome or ",
                  "Chromium on this computer; set CHROMOTE_CHROME to its ",
                  "path if it is not found."))
  }
  ""
}

#' A download of the drawing as a picture file (R152)
#'
#' @param ending \code{"svg"}, \code{"pdf"} or \code{"png"}.
#' @param drawing the server's drawing, a reactive whose \code{widget} is the
#'   drawing shown.
#' @return A download handler: \code{savePedigreeDiagram()} of the widget at
#'   its own page, in a file named \code{pedigree.<ending>}.
#' @noRd
.appPictureDownload <- function(ending, drawing) {
  force(ending)
  force(drawing)
  shiny::downloadHandler(
    filename = paste0("pedigree.", ending),
    content = function(file) savePedigreeDiagram(drawing()$widget, file)
  )
}

#' The app's page
#' @noRd
.pedigreeAppUi <- function() {
  shiny::fluidPage(
    shiny::titlePanel("pedkindraw: draw a pedigree"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3L,
        shiny::fileInput("file", "Pedigree file (CSV or text)",
                         accept = c(".csv", ".txt")),
        shiny::actionButton("sample", "Use the sample pedigree"),
        shiny::fileInput("twins", "Twins file (CSV or text): id1, id2, code",
                         accept = c(".csv", ".txt")),
        shiny::textOutput("twinsNote"),
        shiny::tagAppendAttributes(shiny::textOutput("twinsProblem"),
                                   style = "color: #b00020;"),
        shiny::hr(),
        shiny::uiOutput("columns"),
        shiny::textOutput("sexNote"),
        shiny::hr(),
        shiny::uiOutput("conditionChoice"),
        shiny::uiOutput("cutoffs"),
        shiny::textOutput("marks"),
        shiny::tagAppendAttributes(
          shiny::textOutput("columnNotes"),
          style = "color: #b00020; white-space: pre-wrap;"
        ),
        shiny::radioButtons("lines", "Lines",
                            c("Right angles" = "rectilinear",
                              Straight = "direct")),
        shiny::hr(),
        shiny::radioButtons(
          "view", "Animals to draw",
          c(Everyone = "all", "One family" = "family",
            "Focal animals with their ancestors and descendants" = "lineal",
            "Focal animals' near relatives" = "near")
        ),
        shiny::conditionalPanel("input.view == 'family'",
                                shiny::uiOutput("familyChoice")),
        shiny::textAreaInput(
          "focal", "Focal animals: type their ids, or click one in the drawing",
          rows = 3L
        ),
        shiny::textOutput("focalNote"),
        shiny::conditionalPanel(
          "input.view == 'near'",
          shiny::numericInput("howClose", "How close", 3L, min = 1L,
                              step = 1L),
          shiny::helpText(paste(
            "2 holds the parents, offspring and full siblings; 3 adds",
            "grandparents, grandoffspring, half siblings, aunts, uncles,",
            "nephews and nieces; 4 adds first cousins."
          ))
        )
      ),
      shiny::mainPanel(
        width = 9L,
        shiny::tabsetPanel(
          id = "tabs",
          shiny::tabPanel(
            "Diagram",
            shiny::textOutput("drawn"),
            shiny::textOutput("added"),
            shiny::tagAppendAttributes(shiny::textOutput("problem"),
                                       style = "color: #b00020;"),
            shiny::tagAppendAttributes(shiny::textOutput("notes"),
                                       style = "white-space: pre-wrap;"),
            shiny::uiOutput("large"),
            shiny::uiOutput("saves"),
            visNetwork::visNetworkOutput("diagram", height = "650px")
          ),
          shiny::tabPanel("Checks", shiny::textOutput("checkSummary"),
                          shiny::tableOutput("checks")),
          shiny::tabPanel("Animals", shiny::uiOutput("saveRows"),
                          shiny::tableOutput("table"))
        )
      )
    )
  )
}

#' The app's server
#'
#' @param ped \code{NULL}, or a pedigree to open as if read from a file.
#' @param drawLimit the most animals drawn without asking first (R150).
#' @param pictureProblem \code{""} when the drawing can be saved as a
#'   picture, or the sentence saying why not (R152), found once when the app
#'   is made.
#' @return A server function for \code{shiny::shinyApp()}.
#' @noRd
.pedigreeAppServer <- function(ped = NULL, drawLimit = 1000L,
                               pictureProblem = .appPictureProblem()) {
  force(ped)
  force(drawLimit)
  force(pictureProblem)
  function(input, output, session) {
    rawData <- shiny::reactiveVal(ped)
    readProblem <- shiny::reactiveVal("")
    ## G17c (R151): the conditions chosen, set to the guess when a file is
    ## opened and by the list; the twins file read, with where it came from.
    chosenConditions <- shiny::reactiveVal(.guessAppConditions(names(ped)))
    twinsRead <- shiny::reactiveVal(NULL)
    openRows <- function(read) {
      rawData(read$data)
      readProblem(read$problem)
      chosenConditions(.guessAppConditions(names(read$data)))
    }
    shiny::observeEvent(input$file, {
      openRows(.readAppFile(input$file$datapath))
      if (identical(twinsRead()$source, "sample")) {
        twinsRead(NULL)
      }
    })
    shiny::observeEvent(input$sample, {
      openRows(.readAppFile(.appSamplePath()))
      twinsRead(list(read = .readAppFile(.appSampleTwinsPath()),
                     source = "sample"))
    })
    shiny::observeEvent(input$twins, {
      twinsRead(list(read = .readAppFile(input$twins$datapath),
                     source = input$twins$name))
    })
    shiny::observeEvent(input$conditions,
                        chosenConditions(as.character(input$conditions)),
                        ignoreNULL = FALSE, ignoreInit = TRUE)

    columnGuess <- shiny::reactive({
      shiny::req(rawData())
      .guessAppColumns(names(rawData()))
    })
    output$columns <- shiny::renderUI({
      guess <- columnGuess()
      choices <- c("(choose)" = "", names(rawData()))
      shiny::tagList(lapply(names(guess), function(field) {
        shiny::selectInput(paste0(field, "Column"),
                           sprintf("Column for %s", field), choices,
                           selected = if (is.na(guess[[field]])) {
                             ""
                           } else {
                             guess[[field]]
                           })
      }))
    })
    chosen <- shiny::reactive(c(id = input$idColumn, sire = input$sireColumn,
                                dam = input$damColumn,
                                sex = input$sexColumn))

    tableProblem <- shiny::reactive(.appTableProblem(rawData(), readProblem()))
    columnProblem <- shiny::reactive(.appColumnProblem(chosen()))
    ready <- shiny::reactive({
      columns <- chosen()
      !is.null(rawData()) && !nzchar(tableProblem()) &&
        length(columns) == 4L && !nzchar(columnProblem()) &&
        all(columns %in% names(rawData()))
    })

    pedigree <- shiny::reactive({
      shiny::req(rawData(), !nzchar(tableProblem()), length(chosen()) == 4L)
      shiny::validate(shiny::need(!nzchar(columnProblem()), columnProblem()))
      shiny::req(ready())
      .appPedigree(rawData(), chosen())
    })
    checks <- shiny::reactive(checkPedigree(pedigree()))
    completed <- shiny::reactive(.appAddParents(pedigree()))
    families <- shiny::reactive({
      ped <- completed()$ped
      findPedigreeNumber(ped$id, ped$sire, ped$dam)
    })

    ## G17c (R151): the columns left for conditions and marks, the conditions
    ## in use, their cut-offs, the marks found, the lines and the twins.
    otherColumns <- shiny::reactive({
      shiny::req(rawData())
      setdiff(names(rawData()), c(chosen(), names(.appColumnNames)))
    })
    conditionColumns <- shiny::reactive(
      utils::head(intersect(chosenConditions(), otherColumns()), 4L)
    )
    cutoffValues <- shiny::reactive({
      columns <- conditionColumns()
      stats::setNames(vapply(columns, function(column) {
        k <- match(column, names(rawData()))
        .appCutoff(input[[paste0("cutOp", k)]], input[[paste0("cutValue", k)]])
      }, character(1L)), columns)
    })
    markColumns <- shiny::reactive(
      .appFindMarks(setdiff(otherColumns(), conditionColumns()))
    )
    lineStyle <- shiny::reactive(if (is.null(input$lines)) {
      "rectilinear"
    } else {
      input$lines
    })
    twinsChecked <- shiny::reactive({
      read <- twinsRead()
      if (is.null(read)) {
        return(list(twins = NULL, problem = ""))
      }
      if (nzchar(read$read$problem)) {
        return(list(twins = NULL, problem = sub("^The file", "The twins file",
                                                read$read$problem)))
      }
      twins <- .appReadTwins(read$read$data)
      if (is.null(twins$twins) || !ready()) {
        return(twins)
      }
      checked <- tryCatch(checkTwinRelations(completed()$ped, twins$twins),
                          error = function(e) e)
      if (inherits(checked, "error")) {
        return(list(twins = NULL, problem = sprintf(paste0(
          "The twins file could not be used: %s The pedigree is drawn ",
          "without twins."), conditionMessage(checked))))
      }
      twins
    })

    focalText <- shiny::reactiveVal("")
    shiny::observeEvent(input$focal, focalText(input$focal))
    focalIds <- shiny::reactive(.appFocalIds(focalText()))
    view <- shiny::reactive(if (is.null(input$view)) "all" else input$view)
    howClose <- shiny::reactive(if (is.null(input$howClose)) {
      3L
    } else {
      input$howClose
    })

    choice <- shiny::reactive({
      shiny::req(ready())
      byFamily <- view() == "family"
      .appChooseAnimals(completed()$ped, view(), focalIds(), howClose(),
                        if (byFamily) input$family, if (byFamily) families())
    })
    shown <- shiny::reactive({
      shiny::req(choice()$rows)
      choice()$rows
    })

    approved <- shiny::reactiveVal(NULL)
    shiny::observeEvent(input$drawAnyway, approved(shown()$id))
    tooLarge <- shiny::reactive({
      rows <- choice()$rows
      !is.null(rows) && nrow(rows) > drawLimit &&
        !identical(approved(), rows$id)
    })
    prepared <- shiny::reactive(
      .appDrawnPedigree(shown(), conditionColumns(), cutoffValues(),
                        markColumns())
    )
    drawing <- shiny::reactive({
      if (is.null(choice()$rows) || tooLarge()) {
        return(NULL)
      }
      drawn <- prepared()
      .appDraw(drawn$ped, onClick = .appClickJs, edgeStyle = lineStyle(),
               twinRelations = .appTwinsInView(twinsChecked()$twins,
                                               drawn$ped$id),
               conditionThresholds = drawn$thresholds)
    })

    shiny::observeEvent(input$clicked, {
      ids <- .appClickedAnimals(input$clicked, drawing()$duplicateToReal)
      if (length(ids) > 0L) {
        text <- paste(ids, collapse = "\n")
        focalText(text)
        shiny::updateTextAreaInput(session, "focal", value = text)
      }
    })

    output$sexNote <- shiny::renderText({
      shiny::req(ready())
      .sexCodeNote(rawData()[[chosen()[["sex"]]]])
    })
    output$conditionChoice <- shiny::renderUI({
      available <- otherColumns()
      shiny::selectizeInput(
        "conditions", "Conditions (up to four)", available,
        selected = shiny::isolate(intersect(chosenConditions(), available)),
        multiple = TRUE, options = list(maxItems = 4L)
      )
    })
    output$cutoffs <- shiny::renderUI({
      needing <- Filter(function(column) .appNeedsCutoff(rawData()[[column]]),
                        conditionColumns())
      if (length(needing) == 0L) {
        return(NULL)
      }
      shiny::tagList(lapply(needing, function(column) {
        k <- match(column, names(rawData()))
        value <- shiny::isolate(input[[paste0("cutValue", k)]])
        shiny::tagList(
          shiny::selectInput(paste0("cutOp", k),
                             sprintf("Cut-off for %s", column),
                             c(">" = ">", "\u2265" = ">=", "<" = "<",
                               "\u2264" = "<="),
                             selected = shiny::isolate(
                               input[[paste0("cutOp", k)]]
                             )),
          shiny::numericInput(paste0("cutValue", k), NULL,
                              if (is.null(value)) NA else value)
        )
      }))
    })
    output$marks <- shiny::renderText({
      if (!ready()) {
        return("")
      }
      .appMarkNote(markColumns())
    })
    output$columnNotes <- shiny::renderText({
      if (!ready() || is.null(choice()$rows)) {
        return("")
      }
      paste(prepared()$notes, collapse = "\n")
    })
    output$twinsNote <- shiny::renderText({
      read <- twinsRead()
      twins <- twinsChecked()$twins
      if (is.null(read) || is.null(twins)) {
        return("")
      }
      from <- if (identical(read$source, "sample")) {
        "the sample's twins file"
      } else {
        read$source
      }
      sprintf(ngettext(nrow(twins), "%d twin pair read from %s.",
                       "%d twin pairs read from %s."), nrow(twins), from)
    })
    output$twinsProblem <- shiny::renderText(twinsChecked()$problem)
    output$problem <- shiny::renderText({
      for (problem in c(tableProblem(), columnProblem())) {
        if (nzchar(problem)) {
          return(problem)
        }
      }
      if (!ready()) {
        return("")
      }
      if (nzchar(choice()$problem)) {
        return(choice()$problem)
      }
      if (is.null(drawing()$error)) {
        return("")
      }
      sprintf(paste0("The pedigree could not be drawn (%s). The Checks tab ",
                     "lists the records' problems."), drawing()$error)
    })
    output$drawn <- shiny::renderText({
      if (!ready() || is.null(drawing()$widget)) {
        return("")
      }
      .appDrawnCount(drawing()$widget)
    })
    output$added <- shiny::renderText({
      if (!ready() || length(completed()$added) == 0L) {
        return("")
      }
      sprintf(paste0("Parents with no row of their own, added so the ",
                     "pedigree can be drawn: %s."),
              toString(completed()$added))
    })
    output$focalNote <- shiny::renderText({
      if (!ready()) {
        return("")
      }
      missing <- setdiff(focalIds(), completed()$ped$id)
      if (length(missing) > 0L) {
        return(sprintf("Not in the pedigree: %s.", toString(missing)))
      }
      if (view() %in% c("lineal", "near") && length(focalIds()) == 0L) {
        return(paste0("Type the id of a focal animal, or click one in the ",
                      "drawing."))
      }
      ""
    })
    output$familyChoice <- shiny::renderUI({
      shiny::req(ready())
      shiny::tagList(
        shiny::selectInput("family", "Family",
                           .appFamilyChoices(families())),
        shiny::helpText(.appAloneNote(families()))
      )
    })
    output$large <- shiny::renderUI({
      shiny::req(ready())
      if (!tooLarge()) {
        return(NULL)
      }
      shiny::tagList(
        shiny::p(sprintf(paste0(
          "%s animals are chosen. Drawing more than %s can take a minute or ",
          "more, and the app waits until it is done. Choose one family or ",
          "focal animals, or draw them all."),
          format(nrow(shown()), big.mark = ","),
          format(drawLimit, big.mark = ","))),
        shiny::actionButton("drawAnyway", "Draw anyway")
      )
    })
    output$notes <- shiny::renderText({
      if (!ready()) {
        return("")
      }
      paste(unique(drawing()$notes), collapse = "\n")
    })
    output$diagram <- visNetwork::renderVisNetwork({
      shiny::req(drawing()$widget)
    })
    output$checkSummary <- shiny::renderText({
      if (!ready()) {
        return("")
      }
      n <- nrow(checks())
      if (n == 0L) {
        return("No problems found.")
      }
      sprintf(ngettext(n, "%d problem found.", "%d problems found."), n)
    })
    output$checks <- shiny::renderTable(checks())
    output$table <- shiny::renderTable(shown())

    ## G17d (R152): the drawing saved as a picture through
    ## savePedigreeDiagram() at its own page; without chromote or Chrome no
    ## download is defined, so shiny shows the buttons greyed, and the page
    ## says why. The animals chosen saved as a CSV file: the rows the Animals
    ## tab shows, which the app opens again to the same drawing.
    output$saves <- shiny::renderUI({
      if (!ready() || is.null(drawing()$widget)) {
        return(NULL)
      }
      shiny::tagList(
        shiny::tags$span("Save the drawing:"),
        shiny::downloadButton("saveSvg", "SVG"),
        shiny::downloadButton("savePdf", "PDF"),
        shiny::downloadButton("savePng", "PNG"),
        if (nzchar(pictureProblem)) {
          shiny::tags$p(pictureProblem, style = "color: #b00020;")
        }
      )
    })
    if (!nzchar(pictureProblem)) {
      output$saveSvg <- .appPictureDownload("svg", drawing)
      output$savePdf <- .appPictureDownload("pdf", drawing)
      output$savePng <- .appPictureDownload("png", drawing)
    }
    output$saveRows <- shiny::renderUI({
      if (!ready() || is.null(choice()$rows)) {
        return(NULL)
      }
      shiny::downloadButton("saveCsv", "Save these animals as a CSV file")
    })
    output$saveCsv <- shiny::downloadHandler(
      filename = "pedigree.csv",
      content = function(file) {
        utils::write.csv(shown(), file, row.names = FALSE, na = "")
      }
    )
  }
}
