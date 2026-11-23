# 17g, S78: a sizing probe, NOT the timing method: one call of each pedkindraw
# function in one process, loaded from source, a 60 s limit each, to size
# Phase 17h (docs/planning/pedkindraw-timing-plan.md section 3.4). Not package
# code. <dir> holds the colonies s78Colonies.R builds. From the root:
#   Rscript --no-init-file docs/planning/timing-plan-prototype/s78ProbePedkindraw.R <dir> <n>
suppressMessages(pkgload::load_all(".", quiet = TRUE))
S <- commandArgs(trailingOnly = TRUE)[[1L]]
n <- as.integer(commandArgs(trailingOnly = TRUE)[[2L]])
p <- utils::read.csv(file.path(S, sprintf("synthetic_%d.csv", n)),
  colClasses = "character", na.strings = "")
set.seed(42L); g <- stats::runif(nrow(p)) < 0.3; a <- stats::runif(nrow(p)) < 0.1
set.seed(7L); pr <- sample(p$id[!is.na(p$sire)], 5L)
p$genotyped <- g
one <- function(label, expr) {
  setTimeLimit(elapsed = 60, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf))
  t0 <- proc.time()[["elapsed"]]
  r <- tryCatch({ force(expr); "ok" }, error = function(e) substr(conditionMessage(e), 1, 60))
  cat(sprintf("%-34s n=%-7d %8.3f s  %s\n", label, n, proc.time()[["elapsed"]] - t0, r))
}
fam <- findPedigreeNumber(p$id, p$sire, p$dam)
one("bitSize", bitSize(p))
one("findUnavailable", findUnavailable(p, g))
one("findAvailNonInform", findAvailNonInform(p, g, a))
one("findAvailAffected", findAvailAffected(p, g, a, TRUE))
one("familyCheck", familyCheck(fam, p$id, p$sire, p$dam))
one("getNearRelativePedigree(3)", getNearRelativePedigree(p, pr, 3))
one("removeAnimals(5)", removeAnimals(p, pr))
one("addParents", addParents(p))
one("countOffspring", countOffspring(p))
one("recodePedigree", recodePedigree(p))
one("isFounder", isFounder(p))
one("findGeneration(alignMates)", findGeneration(p$id, p$sire, p$dam, alignMates = TRUE))
one("checkPedigree", checkPedigree(p))
one("getMatings", getMatings(p))
one("correctParentSex", correctParentSex(p$id, p$sire, p$dam, p$sex, rep("original", nrow(p))))
one("removeUninformativeFounders", removeUninformativeFounders(p))
one("getProbandPedigree", getProbandPedigree(p, pr))
one("getParents", getParents(p, pr))
one("getOffspring", getOffspring(p, pr))
one("getFounders", getFounders(p))
one("hasBothParents", hasBothParents(p, pr[[1L]]))
one("getIdsWithOneParent", getIdsWithOneParent(p))
one("findUnrelated", findUnrelated(p, g))
ap <- addParents(p)
one("removeUnknownAnimals", removeUnknownAnimals(ap))
tp <- trimPedigree(p, pr)
one("addBackSecondParents", addBackSecondParents(tp, p))
k <- data.frame(id1 = c(p$id, p$id[!is.na(p$sire)]), id2 = c(p$id, p$sire[!is.na(p$sire)]),
  x = c(rep(1, nrow(p)), rep(0.5, sum(!is.na(p$sire)))))
one(sprintf("ibdMatrix(%d pairs)", nrow(k)), ibdMatrix(k$id1, k$id2, k$x))
