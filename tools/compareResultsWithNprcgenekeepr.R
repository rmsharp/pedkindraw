## Fidelity check for the copy slices (nprcgenekeepr's
## standalone-pedigree-package-plan.md, Phases 6-10 DONE): runs each copied
## function in pedkindraw and in nprcgenekeepr on the Phase 1 pedigrees and
## requires identical() results, warnings included.
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
## and an empty field as NA; the twins table is not a pedigree and is skipped.
##
## Exit status 0 when every result is identical, 1 otherwise.

## The cases: one result per pedigree and function, each a list of the value
## and any warning messages. Runs inside a child process; `ns` is the loaded
## package's namespace.
runCases <- function(ns, dataDir) {
  capture <- function(expr) {
    warnings <- character(0L)
    value <- withCallingHandlers(expr, warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    })
    list(value = value, warnings = warnings)
  }
  ## Evenly spread ids: at most `n`, in pedigree order.
  spread <- function(ids, n) {
    ids[unique(round(seq(1L, length(ids), length.out = min(n, length(ids)))))]
  }
  fn <- function(name) get(name, envir = ns, inherits = FALSE)
  files <- list.files(dataDir, pattern = "\\.csv$", full.names = TRUE)
  files <- files[!grepl("twinRelations", files, fixed = TRUE)]
  results <- list()
  for (file in files) {
    ped <- utils::read.csv(file, colClasses = "character", na.strings = "")
    some <- spread(ped$id, 25L)
    few <- spread(ped$id, 5L)
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

## This process's renv sets RENV_PROJECT and the library variables, and a
## child would inherit them and load this project's library. Undo them: put
## back the values renv saved as RENV_DEFAULT_* (the text "<NA>" where the
## variable was unset), so the child's own .Rprofile activates its own
## project.
renvFreeEnv <- function() {
  if (!nzchar(Sys.getenv("RENV_PROJECT"))) {
    return(character(0L))
  }
  vars <- c(
    "R_LIBS", "R_LIBS_USER", "R_LIBS_SITE", "R_PROFILE", "R_PROFILE_USER",
    "R_ENVIRON", "R_ENVIRON_USER"
  )
  unsets <- c("-u", "RENV_PROJECT")
  sets <- character(0L)
  for (v in vars) {
    default <- Sys.getenv(paste0("RENV_DEFAULT_", v), unset = NA)
    if (is.na(default) || identical(default, "<NA>")) {
      unsets <- c(unsets, "-u", v)
    } else {
      sets <- c(sets, paste0(v, "=", shQuote(default)))
    }
  }
  ## env reads its options only before the first NAME=value.
  c(unsets, sets)
}

runChild <- function(folder, outFile) {
  ## One change of folder for one child process; withr is not a dependency.
  old <- setwd(folder) # nolint: undesirable_function_linter.
  on.exit(setwd(old)) # nolint: undesirable_function_linter.
  status <- system2("env", c(
    renvFreeEnv(), "Rscript", shQuote(script), "--child", shQuote(folder),
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
cat(sprintf(
  "%d results (%d with warnings, compared too); %d identical; %d differ\n",
  length(same), sum(withWarnings), sum(same), sum(!same)
))
if (!all(same)) {
  cat("Differ:\n", paste0("  ", names(same)[!same], "\n"), sep = "")
}
quit(status = if (all(same)) 0L else 1L)
