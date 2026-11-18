## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
##
## Section 10 of docs/research/pedkindraw-gaps-2026-11-18.md (pedkindraw
## S40): which of the gaps found by tools/gapCases.R nprcgenekeepr has too.
## It runs nprcgenekeepr's own code, from an archive of one of its commits,
## with nprcgenekeepr's renv library, and prints one line per result:
## "nprcgenekeepr | what | value". nprcgenekeepr's folder is only read.
##
## Usage, with the clone beside this repository:
##   A=$(mktemp -d)
##   git -C ../nprcgenekeepr archive <commit> DESCRIPTION NAMESPACE R data \
##     inst | tar -x -C "$A"
##   cd ../nprcgenekeepr
##   Rscript ../pedkindraw/tools/gapCasesNprcgenekeepr.R "$A" <commit>
## Started from nprcgenekeepr's folder, Rscript activates its renv. Start it
## from a shell, not from an R process inside pedkindraw's renv, whose
## RENV_PROJECT and R_LIBS_USER a child would inherit (CLAUDE.md Learning 5).

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2L) {
  stop("Give the archive's folder and the commit it came from.",
       call. = FALSE)
}
suppressMessages(pkgload::load_all(args[[1L]], quiet = TRUE,
                                   export_all = FALSE))
grDevices::pdf(NULL)

say <- function(what, value) {
  shown <- if (is.character(value)) value else format(value)
  text <- gsub("\n", "\\n", paste(shown, collapse = " / "), fixed = TRUE)
  cat("nprcgenekeepr | ", what, " | ", text, "\n", sep = "")
}

probe <- function(what, expr) {
  value <- tryCatch(
    withCallingHandlers(expr, warning = function(w) {
      say(what, paste("warns:", conditionMessage(w)))
      invokeRestart("muffleWarning")
    }, message = function(m) invokeRestart("muffleMessage")),
    error = function(e) list(stopped = conditionMessage(e))
  )
  if (is.list(value) && identical(names(value), "stopped")) {
    say(what, paste("stops:", value$stopped))
  } else {
    say(what, value)
  }
  invisible(value)
}

## The typed pedigrees of tools/gapCases.R.
four <- data.frame(id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
                   dam = c(NA, NA, "B", "B"), sex = c("M", "F", "M", "F"),
                   stringsAsFactors = FALSE)
nine <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
  sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "H"),
  sex = c("M", "F", "M", "M", "F", "M", "F", "F", "F"),
  stringsAsFactors = FALSE)

withGen <- function(ped) {
  ped$gen <- nprcgenekeepr::findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

layoutOf <- function(ped) nprcgenekeepr::makePedigreeMatingLayout(withGen(ped))

fillsOf <- function(ped) {
  lay <- layoutOf(ped)
  lay$nodes$color.background[match(ped$id, lay$nodes$id)]
}

say("commit", args[[2L]])

## A1, A3
widget <- nprcgenekeepr::drawPedigreeDiagram(layoutOf(four))
probe("A1 drawPedigreeDiagram() class", class(widget))
probe("A1 drawPedigreeDiagram() arguments",
      names(formals(nprcgenekeepr::drawPedigreeDiagram)))
probe("A1 savePlotToFile() given the pedigree widget",
      nprcgenekeepr::savePlotToFile(widget, tempfile(fileext = ".pdf")))
probe("A2 drawColonyOverview() arguments",
      names(formals(nprcgenekeepr::drawColonyOverview)))
probe("A3 runGeneKeepR() arguments",
      names(formals(nprcgenekeepr::runGeneKeepR)))

## B1-B6
mates <- rbind(four, data.frame(id = c("E", "F"), sire = NA, dam = NA,
                                sex = c("M", "F")))
probe("B1 isolatedIds with E and F unmated, no offspring",
      layoutOf(mates)$isolatedIds)
probe("B1 and C3 makePedigreeMatingLayout() arguments",
      names(formals(nprcgenekeepr::makePedigreeMatingLayout)))
unknown <- four
unknown$affected <- c(TRUE, NA, FALSE, TRUE)
probe("B2 fills A, B (unknown), C, D", fillsOf(unknown))
carrier <- four
carrier$carrier <- c(TRUE, FALSE, FALSE, FALSE)
probe("B3 layout identical with a carrier column",
      identical(layoutOf(carrier), layoutOf(four)))
measured <- four
measured$affected <- c(2.5, 0.0, 0.3, 9.0)
probe("B4 fills, affected = 2.5, 0, 0.3, 9", fillsOf(measured))
labelled <- four
labelled$name <- c("age 7\nMHC A01/B02 long text", NA, NA, NA)
probe("B6 label of A", {
  lay <- layoutOf(labelled)
  lay$nodes$label[lay$nodes$id == "A"]
})

## C1, C2, C4, C5, C6
probe("C1 getPedDirectRelatives(\"F\") ids",
      sort(nprcgenekeepr::getPedDirectRelatives("F", nine)$id))
probe("C1 getPedDirectRelatives() arguments",
      names(formals(nprcgenekeepr::getPedDirectRelatives)))
probe("C2 findGeneration() arguments",
      names(formals(nprcgenekeepr::findGeneration)))
probe("C4 convertSexCodes() of 1, 2, male, female, m, f",
      as.character(nprcgenekeepr::convertSexCodes(
        c("1", "2", "male", "female", "m", "f"))))
studbook <- data.frame(
  id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
  dam = c(NA, NA, "B", "B"), sex = c("1", "2", "male", "f"),
  birth = as.Date(c("2000-01-01", "2000-01-01", "2006-01-01", "2006-01-01")),
  stringsAsFactors = FALSE)
qc <- function(sb) {
  nprcgenekeepr::qcStudbook(sb, reportChanges = FALSE, reportErrors = FALSE)
}
probe("C4 qcStudbook(), sex 1, 2, male, f: sex read",
      as.character(qc(studbook)$sex))
for (code in c("0", "")) {
  coded <- studbook
  coded$sire[1L:2L] <- code
  coded$dam[1L:2L] <- code
  probe(paste0("C4 qcStudbook(), founders' parents written \"", code, "\""),
        paste(qc(coded)$sire, collapse = ","))
}
csv <- tempfile(fileext = ".csv")
writeLines(c("id,sire,dam,sex,birth", "A,,,1,2000-01-01", "B,,,2,2000-01-01",
             "C,A,B,male,2006-01-01", "D,A,B,f,2006-01-01"), csv)
probe("C4 getPedigree() of a CSV with blank parent cells: sire",
      paste(nprcgenekeepr::getPedigree(csv)$sire, collapse = ","))
probe("C5 offspringCounts(c(\"A\", \"B\"), ped): columns",
      names(nprcgenekeepr::offspringCounts(c("A", "B"), four)))
probe("C5 offspringCounts(c(\"A\", \"B\"), ped): totalOffspring",
      nprcgenekeepr::offspringCounts(c("A", "B"), four)$totalOffspring)
probe("C3, C5 and C6 exports naming hint, mate, spouse, subset or remove",
      sort(grep("hint|mate|spouse|subset|remove",
                getNamespaceExports("nprcgenekeepr"), ignore.case = TRUE,
                value = TRUE)))

## Ruled R13 and R21
probe("R13 getPedigree() arguments", names(formals(nprcgenekeepr::getPedigree)))
probe("R21 datasets",
      length(utils::data(package = "nprcgenekeepr")$results[, "Item"]))
