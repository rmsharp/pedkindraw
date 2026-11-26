## Copyright(c) 2026 R. Mark Sharp
## This file is part of pedkindraw
##
## CRAN plan Phase 17l (docs/planning/cran-submission-plan.md; S95, Mark's pick
## "Guards plus a guard test"): the suggested packages a check without them
## hides from the tests, and the test code that calls one with no
## skip_if_not_installed() for it first. testthat turns a missing package into
## a skip only on CRAN (its test_code(): `if (on_cran()) skip(...)`), so off
## CRAN such a call errors: measured S95, the full suite without the suggested
## packages failed 4 blocks, all calling mockery with no guard
## (test_suggestsGuarded.R).

## The suggested packages a check run with _R_CHECK_DEPENDS_ONLY_ hides from
## the tests: those in Suggests but testthat and the VignetteBuilder packages,
## which R CMD check keeps (tools:::setRlibs()), and their own hard
## dependencies (testthat brings withr, callr, jsonlite, pkgload and ps).
hiddenSuggests <- function(descFile = system.file("DESCRIPTION",
                                                  package = "pedkindraw"),
                           db = utils::installed.packages()) {
  desc <- read.dcf(descFile, fields = c("Suggests", "VignetteBuilder"))
  field <- function(x) {
    if (is.na(x)) {
      return(character(0L))
    }
    names <- trimws(sub("\\(.*$", "", strsplit(x, ",")[[1L]]))
    names[nzchar(names)]
  }
  suggests <- field(desc[1L, "Suggests"])
  kept <- intersect(c("testthat", field(desc[1L, "VignetteBuilder"])),
                    rownames(db))
  deps <- unlist(tools::package_dependencies(
    kept, db = db, which = c("Depends", "Imports", "LinkingTo"),
    recursive = TRUE
  ), use.names = FALSE)
  setdiff(suggests, c(kept, deps))
}

## TRUE for a top-level `name <- function(...)` (or `=`): its body runs only
## when something calls it, so its calls are not read where it is defined.
.isFunctionDefinition <- function(e) {
  is.call(e) && length(e) == 3L &&
    (identical(e[[1L]], as.name("<-")) || identical(e[[1L]], as.name("="))) &&
    is.call(e[[3L]]) && identical(e[[3L]][[1L]], as.name("function"))
}

## The parser's tokens of one top-level expression, in source order.
.expressionTokens <- function(tokens, ref) {
  inside <- tokens$terminal &
    (tokens$line1 > ref[1L] | (tokens$line1 == ref[1L] & tokens$col1 >= ref[5L])) &
    (tokens$line2 < ref[3L] | (tokens$line2 == ref[3L] & tokens$col2 <= ref[6L]))
  found <- tokens[inside, ]
  found[order(found$line1, found$col1), ]
}

## The packages each guard in `tokens` covers, with the guard's row: a call to
## skip_if_not_installed("pkg") or requireNamespace("pkg") (as in
## `if (requireNamespace("pkg", quietly = TRUE)) {...}`), or to a function of
## `guards` (its name to the packages it guards).
.guardRows <- function(tokens, guards) {
  rows <- list()
  calls <- which(tokens$token == "SYMBOL_FUNCTION_CALL")
  for (i in calls) {
    name <- tokens$text[i]
    if (name %in% c("skip_if_not_installed", "requireNamespace")) {
      str <- which(tokens$token == "STR_CONST" & seq_len(nrow(tokens)) > i)
      if (length(str) > 0L) {
        pkg <- gsub("^[\"']|[\"']$", "", tokens$text[str[1L]])
        rows[[length(rows) + 1L]] <- data.frame(row = i, package = pkg)
      }
    } else if (name %in% names(guards)) {
      rows[[length(rows) + 1L]] <- data.frame(row = i, package = guards[[name]])
    }
  }
  if (length(rows) == 0L) {
    return(data.frame(row = integer(0L), package = character(0L)))
  }
  do.call(rbind, rows)
}

## The guard functions the files define: each top-level function whose body
## calls skip_if_not_installed("pkg"), or another guard function, named with
## the packages it guards.
guardFunctions <- function(files) {
  defs <- list()
  for (file in files) {
    exprs <- parse(file, keep.source = TRUE)
    tokens <- utils::getParseData(exprs)
    refs <- attr(exprs, "srcref")
    for (i in seq_along(exprs)) {
      if (.isFunctionDefinition(exprs[[i]])) {
        defs[[as.character(exprs[[i]][[2L]])]] <-
          .expressionTokens(tokens, refs[[i]])
      }
    }
  }
  guards <- list()
  repeat {
    before <- guards
    for (name in names(defs)) {
      pkgs <- unique(.guardRows(defs[[name]], guards)$package)
      if (length(pkgs) > 0L) {
        guards[[name]] <- pkgs
      }
    }
    if (identical(before, guards)) {
      break
    }
  }
  guards
}

## Each call in `file` to a package of `hidden` (`pkg::f` or `pkg:::f`) with no
## guard for that package before it: in the same top-level expression (a
## test_that() block), or in an earlier top-level expression. Function
## definitions are not read. One row per expression and package: the file's
## name, the line of the first such call, the package.
unguardedSuggests <- function(file, hidden, guards = list()) {
  exprs <- parse(file, keep.source = TRUE)
  tokens <- utils::getParseData(exprs)
  refs <- attr(exprs, "srcref")
  guarded <- character(0L)
  found <- list()
  for (i in seq_along(exprs)) {
    if (.isFunctionDefinition(exprs[[i]])) {
      next
    }
    tok <- .expressionTokens(tokens, refs[[i]])
    guardRows <- .guardRows(tok, guards)
    uses <- which(tok$token == "SYMBOL_PACKAGE" & tok$text %in% hidden)
    for (pkg in unique(tok$text[uses])) {
      first <- min(uses[tok$text[uses] == pkg])
      before <- guardRows$row[guardRows$package == pkg] < first
      if (!(pkg %in% guarded) && !any(before)) {
        found[[length(found) + 1L]] <- data.frame(
          file = basename(file), line = tok$line1[first], package = pkg
        )
      }
    }
    if (!is.call(exprs[[i]]) ||
          !identical(exprs[[i]][[1L]], as.name("test_that"))) {
      guarded <- union(guarded, guardRows$package)
    }
  }
  if (length(found) == 0L) {
    return(data.frame(file = character(0L), line = integer(0L),
                      package = character(0L)))
  }
  do.call(rbind, found)
}
