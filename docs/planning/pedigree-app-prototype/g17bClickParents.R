# G17b, S75: what a click can land on in the app's drawing, and what
# addParents() does to a file whose parent has no row (backlog
# methodology/BACKLOG.md:201). Not package code. Run from the repository root
# with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17bClickParents.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))

## ---- the click: the node ids of the sample's drawing, by kind ----
ped <- utils::read.csv(.appSamplePath(), colClasses = "character",
                       na.strings = c("", "NA"))[, c("id", "sire", "dam",
                                                     "sex")]
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
layout <- suppressWarnings(makePedigreeMatingLayout(ped))
ids <- as.character(layout$nodes$id)
kind <- ifelse(startsWith(ids, "__"), sub("^(__[a-z]+_).*", "\\1", ids),
               "animal")
cat("sample's nodes:", length(ids), "| by kind:",
    paste(names(table(kind)), table(kind), collapse = ", "), "\n")
dups <- layout$duplicateToReal
cat("duplicateToReal:", length(dups), "repeat nodes; each maps to an animal",
    "with a row:", all(dups %in% ped$id), "; repeats of",
    length(unique(dups)), "animals\n")
hidden <- layout$nodes$hidden
if (!is.null(hidden)) {
  cat("hidden nodes by kind:",
      paste(names(table(kind[hidden %in% TRUE])),
            table(kind[hidden %in% TRUE]), collapse = ", "), "\n")
}
cat("reserved prefixes:", paste(.reservedIdPrefixes, collapse = " "), "\n")
cat("an animal id may not start with one:",
    tryCatch({
      bad <- data.frame(id = c("__dup_x", "b"), sire = NA, dam = NA,
                        sex = c("M", "F"), gen = 0)
      makePedigreeMatingLayout(bad)
      "accepted"
    }, error = function(e) conditionMessage(e)), "\n")

## ---- parents with no row (backlog :201) ----
four <- data.frame(id = c("s1", "d1", "o1", "o2"), sire = c(NA, NA, "s1", "s9"),
                   dam = c(NA, NA, "d1", "d1"), sex = c("M", "F", "F", "M"))
added <- addParents(four)
print(added)
d <- .appDraw(added)
cat("addParents() then .appDraw(): error", format(d$error), "| animals drawn",
    sum(!startsWith(as.character(d$widget$x$nodes$id), "__")), "| notes",
    length(d$notes), "| checkPedigree() after:",
    nrow(checkPedigree(added)), "problems\n")
both <- four
both$dam[4L] <- "d9"
cat("a sire and a dam with no row: added rows",
    nrow(addParents(both)) - nrow(both), "| sexes",
    paste(addParents(both)$sex[5:6], collapse = ","), "\n")
