## Fidelity check for the copy slices
## (docs/planning/standalone-pedigree-package-plan.md, Phases 6-10 DONE):
## runs each copied function in pedkindraw and in nprcgenekeepr on the
## Phase 1 pedigrees and requires identical() results, warnings and messages
## included.
##
## Usage, from the pedkindraw root:
##   Rscript tools/compareResultsWithNprcgenekeepr.R [nprcgenekeepr clone]
## Default clone: ../nprcgenekeepr. Its working tree is what gets loaded, so
## the script first checks that the clone's file for every copied function is
## unchanged since the commit the copy names (git diff --quiet).
##
## Each package runs in its own R process started in its own folder, so each
## uses its own renv library (nprcgenekeepr needs its imports, pedkindraw does
## not have them). The pedigrees are the clone's
## tools/pedigreeComparison/data/*.csv, read with every column as character
## and an empty field as NA. A twins table (<pedigree>_twinRelations.csv, so
## far rhesus375's) is not a pedigree: it is skipped as one, and read with its
## pedigree for the Phase 7 and 8 cases.
##
## Exit status 0 when every result is identical and the kinship matrices'
## largest absolute difference is 0 (the plan's DONE line), 1 otherwise.

## The cases: one result per pedigree and function, each a list of the value
## and the texts of any warnings and messages (Phase 8: the layout's message
## naming the animals it leaves out). Runs inside a child process; `ns` is
## the loaded package's namespace.
runCases <- function(ns, dataDir) {
  capture <- function(expr) {
    warnings <- character(0L)
    messages <- character(0L)
    value <- withCallingHandlers(expr, warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }, message = function(m) {
      messages <<- c(messages, conditionMessage(m))
      invokeRestart("muffleMessage")
    })
    list(value = value, warnings = warnings, messages = messages)
  }
  ## Evenly spread ids: at most `n`, in pedigree order.
  spread <- function(ids, n) {
    ids[unique(round(seq(1L, length(ids), length.out = min(n, length(ids)))))]
  }
  fn <- function(name) get(name, envir = ns, inherits = FALSE)
  ## Phase 7: made-up twins for a pedigree without a twins table of its own:
  ## a UZ pair of the first two animals; the first two animals of each of the
  ## first three full sibships, MZ when of one sex and DZ otherwise; and a
  ## chained MZ trio (A-B, B-C) from the first sibship with three of one sex.
  madeUpTwins <- function(p) {
    pair <- function(a, b, code) {
      data.frame(id1 = p$id[[a]], id2 = p$id[[b]], code = code)
    }
    rows <- list(pair(1L, 2L, "UZ twin"))
    both <- which(!is.na(p$sire) & !is.na(p$dam))
    family <- paste(p$sire[both], p$dam[both])
    sibships <- split(both, factor(family, levels = unique(family)))
    sibships <- sibships[lengths(sibships) >= 2L]
    for (s in utils::head(sibships, 3L)) {
      oneSex <- identical(p$sex[[s[[1L]]]], p$sex[[s[[2L]]]])
      rows <- c(rows, list(pair(s[[1L]], s[[2L]],
        if (oneSex) "MZ twin" else "DZ twin"
      )))
    }
    for (s in sibships) {
      for (sex in unique(p$sex[s])) {
        trio <- s[p$sex[s] == sex]
        if (length(trio) >= 3L) {
          rows <- c(rows, list(pair(trio[[1L]], trio[[2L]], "MZ twin"),
                               pair(trio[[2L]], trio[[3L]], "MZ twin")))
          return(do.call(rbind, rows))
        }
      }
    }
    do.call(rbind, rows)
  }
  files <- list.files(dataDir, pattern = "\\.csv$", full.names = TRUE)
  files <- files[!grepl("twinRelations", files, fixed = TRUE)]
  results <- list()
  for (file in files) {
    ped <- utils::read.csv(file, colClasses = "character", na.strings = "")
    some <- spread(ped$id, 25L)
    few <- spread(ped$id, 5L)
    ## Phase 6b: a made-up status, "added" for every animal without a sire.
    status <- ifelse(is.na(ped$sire), "added", "original")
    ## Phase 6b: the probands' pedigree, before and after removing the
    ## uninformative founders, for addBackSecondParents().
    trimmed <- function() fn("getProbandPedigree")(few, ped)
    ## Phase 6b: the Phase 1 pedigrees list a record for every parent, have no
    ## female sire or male dam, and (but one) no animal with one known parent,
    ## so these made-up variants reach the branches the pedigrees do not:
    ## founders' records dropped, M and F swapped, every third dam unknown.
    noFounders <- ped[!is.na(ped$sire) | !is.na(ped$dam), ]
    flip <- c(M = "F", F = "M")
    swapped <- ped$sex
    toFlip <- ped$sex %in% names(flip)
    swapped[toFlip] <- flip[ped$sex[toFlip]]
    oneParent <- ped
    oneParent$dam[seq(1L, nrow(ped), by = 3L)] <- NA
    ## Phase 7 (pedkindraw S8): kinship on the whole pedigree up to 2,000
    ## animals; above that, on the pedigree of 100 spread animals and their
    ## ancestors (310 to 942 animals; the example's 417 hold two animals of
    ## unknown sex with parents, the X chromosome's NA branch), so the saved
    ## results stay a few hundred megabytes.
    kin <- if (nrow(ped) <= 2000L) {
      ped
    } else {
      fn("getProbandPedigree")(spread(ped$id, 100L), ped)
    }
    kin$gen <- fn("findGeneration")(kin$id, kin$sire, kin$dam)
    ## The pedigree's own twins table where it has one (rhesus375), else
    ## made-up twins; then inputs checkTwinRelations() or kinship() stops on.
    twinsFile <- sub("\\.csv$", "_twinRelations.csv", file)
    twins <- if (file.exists(twinsFile)) {
      utils::read.csv(twinsFile, colClasses = "character")
    } else {
      madeUpTwins(kin)
    }
    mzOfMixedSex <- twins
    mzOfMixedSex$code[mzOfMixedSex$code == "DZ twin"] <- "MZ twin"
    selfPair <- twins[1L, ]
    selfPair$id2 <- selfPair$id1
    founders <- kin$id[is.na(kin$sire) & is.na(kin$dam)]
    badTwins <- list(
      twins[, c("id1", "id2")], selfPair,
      data.frame(id1 = "no such animal", id2 = kin$id[[1L]], code = "UZ twin"),
      data.frame(id1 = kin$id[[1L]], id2 = kin$id[[2L]], code = "XZ twin"),
      data.frame(id1 = founders[[1L]], id2 = founders[[2L]], code = "MZ twin")
    )
    kinOf <- function(...) {
      fn("kinship")(kin$id, kin$sire, kin$dam, kin$gen, ...)
    }
    stopsWith <- function(f) tryCatch(f(), error = conditionMessage)
    ## Phase 8 (pedkindraw S10): the layout on the whole pedigree up to 400
    ## animals (nprcgenekeepr's app draws rectilinear lines up to 400), else
    ## on 20 spread animals and their ancestors (74 to 268 animals), so the
    ## layout cases take seconds, not the 180 s of 3,694 animals.
    lay <- if (nrow(ped) <= 400L) {
      ped
    } else {
      fn("getProbandPedigree")(spread(ped$id, 20L), ped)
    }
    lay$gen <- fn("findGeneration")(lay$id, lay$sire, lay$dam)
    layTwins <- if (file.exists(twinsFile)) twins else madeUpTwins(lay)
    layKinship <- fn("kinship")(lay$id, lay$sire, lay$dam, lay$gen)
    ## Columns no Phase 1 pedigree has (samplePed's affected holds 0 and 1,
    ## which as.logical() reads as NA), so the cases reach the layout's code
    ## for them: every fifth animal DECEASED; names with HTML's special
    ## characters, some longer than a label's 15 characters, every fourth
    ## missing; one condition column (layOne), then five (layColumns), one
    ## more than the layout draws.
    row <- seq_len(nrow(lay))
    cycle <- function(offset) c("TRUE", "FALSE", NA)[(row + offset) %% 3L + 1L]
    layOne <- lay
    layOne$status <- ifelse(row %% 5L == 0L, "DECEASED", "ALIVE")
    layOne$name <- ifelse(row %% 4L == 0L, NA_character_,
      paste0("<b>", lay$id, "</b> & ", strrep("x", row %% 20L))
    )
    layOne$affected <- cycle(0L)
    layColumns <- layOne
    layColumns[["affected2"]] <- cycle(1L)
    layColumns[["affected_diabetes"]] <- cycle(2L)
    layColumns[["affected.eyes"]] <- rev(cycle(0L))
    layColumns[["affectedLast"]] <- cycle(1L)
    ## Founders only: no animal has a parent, mate or offspring, so the
    ## layout leaves every one out and returns its empty result.
    layFounders <- is.na(lay$sire) & is.na(lay$dam)
    ## Every dam unknown: no mating at all, only lines from one parent (the
    ## layout's and the comparison's branches for a pedigree without matings,
    ## which only the tests' own small pedigrees reached).
    layNoDams <- lay
    layNoDams$dam <- NA_character_
    layNoDams$gen <- fn("findGeneration")(lay$id, lay$sire, layNoDams$dam)
    layout <- function(...) fn("makePedigreeMatingLayout")(...)
    bothStyles <- function(p, ...) {
      lapply(c("direct", "rectilinear"), function(style) {
        layout(p, edgeStyle = style, ...)
      })
    }
    cases <- list(
      findGeneration = function() {
        fn("findGeneration")(ped$id, ped$sire, ped$dam)
      },
      findPedigreeNumber = function() {
        fn("findPedigreeNumber")(ped$id, ped$sire, ped$dam)
      },
      isFounder = function() fn("isFounder")(ped),
      getFounders = function() fn("getFounders")(ped),
      getParents = function() fn("getParents")(ped, some),
      getOffspring = function() fn("getOffspring")(ped, some),
      getProbandPedigree = function() fn("getProbandPedigree")(few, ped),
      getDescendantPedigree = function() fn("getDescendantPedigree")(few, ped),
      walkPedigree = function() {
        lapply(c("ancestors", "descendants", "both"), function(direction) {
          fn("walkPedigree")(few, ped, direction)
        })
      },
      isEmpty = function() {
        lapply(list(ped$sire, ped$id, character(0L), NA), fn("isEmpty"))
      },
      ## Phase 6b (pedkindraw S7).
      sexCodes = function() fn("sexCodes"),
      isAddedRecord = function() {
        list(fn("isAddedRecord")(status), fn("isAddedRecord")(NULL, nrow(ped)))
      },
      rbindFill = function() {
        fn("rbindFill")(ped, ped[seq_len(min(3L, nrow(ped))), c("id", "sex")])
      },
      addParents = function() {
        list(fn("addParents")(ped), fn("addParents")(noFounders))
      },
      correctParentSex = function() {
        lapply(list(ped$sex, swapped), function(sex) {
          list(
            fn("correctParentSex")(ped$id, ped$sire, ped$dam, sex, status,
              reportErrors = TRUE
            ),
            ## Stops when an id is both a sire and a dam: compare the message.
            tryCatch(
              fn("correctParentSex")(ped$id, ped$sire, ped$dam, sex, status),
              error = conditionMessage
            )
          )
        })
      },
      removeUnknownAnimals = function() {
        list(
          fn("removeUnknownAnimals")(ped),
          fn("removeUnknownAnimals")(cbind(ped, recordStatus = status))
        )
      },
      hasBothParents = function() lapply(few, fn("hasBothParents"), ped = ped),
      getIdsWithOneParent = function() {
        list(
          fn("getIdsWithOneParent")(ped), fn("getIdsWithOneParent")(oneParent)
        )
      },
      addIdRecords = function() {
        fn("addIdRecords")(few, ped, ped[!ped$id %in% few, ])
      },
      removeUninformativeFounders = function() {
        fn("removeUninformativeFounders")(ped)
      },
      addBackSecondParents = function() {
        fn("addBackSecondParents")(
          fn("removeUninformativeFounders")(trimmed()), trimmed()
        )
      },
      trimPedigree = function() {
        ## removeUninformative and addBackParents: all four combinations.
        flags <- list(
          c(FALSE, FALSE), c(TRUE, FALSE), c(FALSE, TRUE), c(TRUE, TRUE)
        )
        lapply(flags, function(f) {
          fn("trimPedigree")(few, ped,
            removeUninformative = f[[1L]], addBackParents = f[[2L]]
          )
        })
      },
      ## Phase 7 (pedkindraw S8).
      mzTwinIdsAbsentMessage = function() fn("mzTwinIdsAbsentMessage"),
      mzTwinGroups = function() {
        mz <- twins[twins$code == "MZ twin", ]
        n <- nrow(kin)
        list(
          fn("mzTwinGroups")(match(mz$id1, kin$id), match(mz$id2, kin$id), n),
          fn("mzTwinGroups")(c(n, 2L, n - 1L), c(3L, 3L, 1L), n)
        )
      },
      checkTwinRelations = function() {
        lapply(c(list(twins, mzOfMixedSex), badTwins), function(t) {
          stopsWith(function() fn("checkTwinRelations")(kin, t))
        })
      },
      kinship = function() {
        list(
          kinOf(), kinOf(sparse = TRUE), kinOf(chrtype = "x", sex = kin$sex),
          kinOf(chrtype = "x", sex = kin$sex, sparse = TRUE)
        )
      },
      kinshipFounders = function() {
        ## Founders only: no two animals related, so sparse = TRUE gives a
        ## ddiMatrix, the branch the whole pedigrees do not reach.
        none <- rep(NA_character_, length(founders))
        depth <- rep(0L, length(founders))
        list(
          fn("kinship")(founders, none, none, depth, sparse = TRUE),
          fn("kinship")(founders, none, none, depth, sparse = TRUE,
            chrtype = "x", sex = kin$sex[match(founders, kin$id)]
          )
        )
      },
      kinshipOneParent = function() {
        ## The pedigrees hold almost no animal with one known parent (smallPed
        ## one, sire known), so a variant of kin reaches kinship()'s branches
        ## for a missing sire and a missing dam: every third dam unknown, and
        ## every third sire from the second animal on.
        sire <- kin$sire
        dam <- kin$dam
        dam[seq(1L, nrow(kin), by = 3L)] <- NA
        sire[seq(2L, nrow(kin), by = 3L)] <- NA
        gen <- fn("findGeneration")(kin$id, sire, dam)
        list(
          fn("kinship")(kin$id, sire, dam, gen),
          fn("kinship")(kin$id, sire, dam, gen, chrtype = "x", sex = kin$sex)
        )
      },
      kinshipTwins = function() {
        list(
          kinOf(twinRelations = twins),
          kinOf(twinRelations = twins, sparse = TRUE),
          kinOf(twinRelations = twins, chrtype = "x", sex = kin$sex)
        )
      },
      kinshipErrors = function() {
        lapply(list(
          function() {
            fn("kinship")(c(kin$id, kin$id[[1L]]), c(kin$sire, NA),
                          c(kin$dam, NA), c(kin$gen, 0L))
          },
          function() kinOf(chrtype = "x"),
          function() kinOf(sex = kin$sex[-1L], chrtype = "x"),
          function() {
            kinOf(twinRelations = data.frame(
              id1 = "no such animal", id2 = kin$id[[1L]], code = "MZ twin"
            ))
          },
          function() kinOf(sparse = NA)
        ), stopsWith)
      },
      ## Phase 8 (pedkindraw S10).
      makePedigreeDiagramData = function() {
        list(
          fn("makePedigreeDiagramData")(lay),
          fn("makePedigreeDiagramData")(lay, twinRelations = layTwins),
          fn("makePedigreeDiagramData")(layOne)
        )
      },
      makePedigreeMatingLayout = function() bothStyles(lay),
      layoutTwins = function() bothStyles(lay, twinRelations = layTwins),
      layoutKinshipMatrix = function() {
        list(
          layout(lay, edgeStyle = "direct", kinshipMatrix = layKinship),
          layout(lay, edgeStyle = "direct", kinshipMatrix = fn("kinship")(
            lay$id, lay$sire, lay$dam, lay$gen, sparse = TRUE
          ))
        )
      },
      layoutColumns = function() {
        list(layout(layOne, edgeStyle = "direct"), bothStyles(layColumns))
      },
      layoutAllLeftOut = function() {
        list(layout(layOne[layFounders, ]), layout(layColumns[layFounders, ]))
      },
      layoutNoMatings = function() {
        direct <- layout(layNoDams, edgeStyle = "direct")
        list(
          direct, layout(layNoDams, edgeStyle = "rectilinear"),
          fn(".extractNprcStructure")(direct)
        )
      },
      comparePedigreeStructure = function() {
        ## The kinship2 side reads a plain list shaped like kinship2's
        ## pedigree object, so kinship2 is not needed.
        pedLike <- list(
          id = lay$id, findex = match(lay$sire, lay$id, nomatch = 0L),
          mindex = match(lay$dam, lay$id, nomatch = 0L)
        )
        a <- fn(".extractKinship2Structure")(pedLike)
        b <- fn(".extractNprcStructure")(layout(lay, edgeStyle = "direct"))
        ## A made-up difference: b less its first parent-child edge and
        ## first mate pair, with an animal neither side has.
        changed <- b
        changed$parentChildEdges <- b$parentChildEdges[-1L, ]
        changed$matePairs <- b$matePairs[-1L, ]
        changed$individuals <- c(b$individuals, "no such animal")
        compare <- fn(".comparePedigreeStructures")
        comparisons <- list(
          compare(a, b), compare(b, b), compare(a, changed), compare(changed, a)
        )
        list(
          a, fn(".extractKinship2Structure")(pedLike, spread(lay$id, 5L)), b,
          comparisons, lapply(comparisons, function(x) {
            fn(".formatStructuralDiscrepancy")("made-up", x)
          })
        )
      },
      layoutErrors = function() {
        noRowNames <- layKinship
        rownames(noRowNames) <- NULL
        noColNames <- layKinship
        colnames(noColNames) <- NULL
        lapply(list(
          function() fn("makePedigreeDiagramData")(as.list(lay)),
          function() fn("makePedigreeDiagramData")(lay[, c("id", "sire")]),
          function() layout(as.list(lay)),
          function() layout(lay[, c("id", "sire", "dam", "sex")]),
          function() layout(lay, kinshipMatrix = as.data.frame(layKinship)),
          function() layout(lay, kinshipMatrix = noRowNames),
          function() layout(lay, kinshipMatrix = noColNames),
          function() layout(lay, edgeStyle = "curved")
        ), stopsWith)
      }
    )
    for (name in names(cases)) {
      key <- paste(basename(file), name, sep = " :: ")
      results[[key]] <- capture(cases[[name]]())
    }
  }
  results
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) >= 1L && identical(args[[1L]], "--child")) {
  ## Child mode: --child <package folder> <data folder> <output .rds>
  pkgload::load_all(args[[2L]], quiet = TRUE, export_all = TRUE)
  pkgName <- read.dcf(file.path(args[[2L]], "DESCRIPTION"), "Package")[[1L]]
  started <- proc.time()[["elapsed"]]
  saveRDS(runCases(asNamespace(pkgName), args[[3L]]), args[[4L]])
  cat(sprintf("  %s: %.1f s\n", pkgName, proc.time()[["elapsed"]] - started))
  quit(status = 0L)
}

clone <- normalizePath(
  if (length(args) >= 1L) args[[1L]] else file.path("..", "nprcgenekeepr")
)
here <- normalizePath(".")
script <- normalizePath(file.path("tools", "compareResultsWithNprcgenekeepr.R"))
dataDir <- file.path(clone, "tools", "pedigreeComparison", "data")

## The clone must hold, for every copied file, the code the copy was taken
## from: no commit since, and no uncommitted change.
cat("nprcgenekeepr clone:", clone, "at", system2(
  "git", c("-C", shQuote(clone), "rev-parse", "--short=9", "HEAD"),
  stdout = TRUE
), "\n")
## The nprcgenekeepr path and commit a file's header names, or NULL (as in
## tools/compareWithNprcgenekeepr.R).
copiedFrom <- function(path) {
  lines <- readLines(path, n = 12L, warn = FALSE)
  comments <- sub("^## ?", "", lines[startsWith(lines, "##")])
  header <- paste(comments, collapse = " ")
  pattern <- paste0(
    "Copied from nprcgenekeepr ([^ ]+) at nprcgenekeepr commit ",
    "([0-9a-f]{7,40})"
  )
  found <- regmatches(header, regexec(pattern, header))[[1L]]
  if (length(found) == 0L) {
    return(NULL)
  }
  list(path = found[[2L]], commit = found[[3L]])
}
unchanged <- TRUE
for (path in list.files("R", pattern = "\\.R$", full.names = TRUE)) {
  origin <- copiedFrom(path)
  if (is.null(origin)) {
    next
  }
  status <- system2("git", c(
    "-C", shQuote(clone), "diff", "--quiet", origin$commit, "--", origin$path
  ))
  if (!identical(status, 0L)) {
    cat("  the clone's", origin$path, "differs from", origin$commit, "\n")
    unchanged <- FALSE
  }
}
if (!unchanged) {
  stop("check out the source commit in the clone first", call. = FALSE)
}

## The arguments for env that undo this process's renv settings, so each
## child starts in its own folder's renv (renvFreeEnv(), tools/renvFreeEnv.R).
helperFile <- file.path("tools", "renvFreeEnv.R")
source(helperFile) # nolint: undesirable_function_linter.
childEnv <- renvFreeEnv()

runChild <- function(folder, outFile) {
  ## One change of folder for one child process; withr is only a test
  ## dependency (Suggests).
  old <- setwd(folder) # nolint: undesirable_function_linter.
  on.exit(setwd(old)) # nolint: undesirable_function_linter.
  status <- system2("env", c(
    childEnv, "Rscript", shQuote(script), "--child", shQuote(folder),
    shQuote(dataDir), shQuote(outFile)
  ))
  if (!identical(status, 0L)) {
    stop("the run in ", folder, " failed", call. = FALSE)
  }
  readRDS(outFile)
}
cat("Running the cases (", length(list.files(dataDir, "\\.csv$")) - 1L,
  " pedigrees) in each package:\n", sep = "")
theirs <- runChild(clone, tempfile(fileext = ".rds"))
ours <- runChild(here, tempfile(fileext = ".rds"))

if (!identical(names(ours), names(theirs))) {
  stop("the two runs produced different cases", call. = FALSE)
}
same <- unlist(Map(identical, ours, theirs))
withWarnings <- lengths(lapply(ours, `[[`, "warnings")) > 0L
withMessages <- lengths(lapply(ours, `[[`, "messages")) > 0L
cat(sprintf(paste(
  "%d results (%d with warnings, %d with messages, both compared too);",
  "%d identical; %d differ\n"
), length(same), sum(withWarnings), sum(withMessages), sum(same), sum(!same)))
if (!all(same)) {
  cat("Differ:\n", paste0("  ", names(same)[!same], "\n"), sep = "")
}
## Phase 7: the plan's DONE line also asks for kinship's largest absolute
## difference (0 follows from identical(), but is shown). Every matrix in the
## kinship results, dense or Matrix sparse, cell by cell; NA in both is equal.
## Matrix (pedkindraw's import) gives the sparse results their as.matrix().
invisible(loadNamespace("Matrix"))
matrices <- function(x) {
  if (is.matrix(x) || methods::is(x, "Matrix")) {
    return(list(as.matrix(x)))
  }
  if (is.list(x) && !is.data.frame(x)) {
    return(unlist(lapply(x, matrices), recursive = FALSE))
  }
  list()
}
kinshipKeys <- grep(" :: kinship", names(ours), fixed = TRUE, value = TRUE)
largest <- 0.0
count <- 0L
for (key in kinshipKeys) {
  a <- matrices(ours[[key]]$value)
  b <- matrices(theirs[[key]]$value)
  for (i in seq_along(a)) {
    if (!identical(dim(a[[i]]), dim(b[[i]])) ||
          !identical(is.na(a[[i]]), is.na(b[[i]]))) {
      largest <- Inf
    } else {
      largest <- max(largest, abs(a[[i]] - b[[i]]), na.rm = TRUE)
    }
    count <- count + 1L
  }
}
cat(sprintf("kinship: %d matrices, largest absolute difference %g\n",
            count, largest))
quit(status = if (all(same) && largest == 0.0) 0L else 1L)
