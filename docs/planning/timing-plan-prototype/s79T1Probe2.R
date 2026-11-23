# 17h1, S79: T1 probe 2, the five pairings probe 1 left open (findAvailAffected,
# family_check, pedigree.trim of the probands, the aligned kindepth,
# findUnavailable) on the sample and the colonies of 300, 1,000 and 3,000.
# Not package code. <src dir> holds nprcgenekeepr's harness files, read from
# its clone (only read):
#   git -C ../nprcgenekeepr archive 3e06730c5 tools/pedigreeComparison \
#     tools/perf/harness.R | tar -x -C <src dir>
# Run from the pedkindraw root with renv's library and RENV_PROJECT unset
# (Learning 5), under bash:
#   Rscript --no-init-file docs/planning/timing-plan-prototype/s79T1Probe2.R <src dir>
args <- commandArgs(trailingOnly = TRUE)
src <- args[[1L]]
suppressMessages(pkgload::load_all(".", quiet = TRUE))
here <- file.path(src, "tools", "pedigreeComparison")
source(file.path(here, "comparisonFormats.R"))
source(file.path(here, "generateColonyPedigree.R"))
source(file.path(src, "tools", "perf", "harness.R"))
source(file.path(here, "timingCases.R"))
suppressMessages({ loadNamespace("kinship2"); loadNamespace("Pedixplorer") })
q1 <- function(expr) tryCatch(suppressWarnings(suppressMessages(expr)),
  error = function(e) paste("STOP:", substr(conditionMessage(e), 1, 70)))
peds <- list(sample = {
  s <- utils::read.csv("inst/extdata/obfuscated_rhesus_mhc_ped.csv",
                       colClasses = "character", na.strings = c("", "NA"))
  s[, c("id", "sire", "dam", "sex", "birth")]
})
for (n in c(300L, 1000L, 3000L)) peds[[paste0("c", n)]] <- generateColonyPedigree(n, 1L)
for (nm in names(peds)) {
  p <- peds[[nm]]
  i <- timingInputs(p)
  gen <- i$avail == 1L; aff <- i$affected == 1L; pr <- i$probands
  k <- toKinship2(p)
  kp <- kinship2::pedigree(k$id, k$dadid, k$momid, k$sex, affected = i$affected)
  q <- toPedixplorer(p); q$avail <- i$avail; q$affection <- i$affected
  pp <- suppressWarnings(suppressMessages(Pedixplorer::Pedigree(q)))
  cat("==", nm, nrow(p), "\n")
  ## findAvailAffected
  if (nrow(p) <= 3000L) {
    a <- findAvailAffected(p, gen, aff, TRUE)
    b <- q1(kinship2::findAvailAffected(kp, i$avail, 1))
    cat(sprintf("  findAvailAffected: pkd isTrimmed %s, %d ids, bits %s; k2 %s\n",
                a$isTrimmed, length(a$idTrimmed), a$bitSize,
                if (is.character(b)) b else sprintf("isTrimmed %s, %d ids (%s), bits %s",
                  b$isTrimmed, length(b$idTrimmed), toString(utils::head(b$idTrimmed, 3)), b$bitSize)))
    if (!is.character(b)) cat("    k2 ids all in pkd's:", all(as.character(b$idTrimmed) %in% a$idTrimmed),
                              "; first pkd id = k2's:", identical(a$idTrimmed[1], as.character(b$idTrimmed[1])), "\n")
  }
  ## family_check
  fam <- findPedigreeNumber(p$id, p$sire, p$dam)
  cat(sprintf("  families %d; pdx family_check: %s\n", length(unique(fam)),
              { r <- q1(Pedixplorer::family_check(p$id, p$sire, p$dam, fam)); if (is.character(r)) r else "ok" }))
  famSplit <- fam; famSplit[seq(1, nrow(p), by = 7)] <- 99L
  cat(sprintf("  pdx family_check with a split family: %s\n",
              { r <- q1(Pedixplorer::family_check(p$id, p$sire, p$dam, famSplit)); if (is.character(r)) r else "ok" }))
  ## pedigree.trim of the probands, and of 5 seeded leaves with a known sire
  leaves <- p$id[!is.na(p$sire) & !(p$id %in% c(p$sire, p$dam))]
  lv <- withSeed(7L, sample(leaves, 5L))
  cat(sprintf("  probands with offspring %d of 5; k2 pedigree.trim(probands): %s; (5 leaves): %s\n",
              sum(pr %in% c(p$sire, p$dam)),
              { r <- q1(kinship2::pedigree.trim(pr, kp)); if (is.character(r)) r else "ok" },
              { r <- q1(kinship2::pedigree.trim(lv, kp)); if (is.character(r)) r else "ok" }))
  ## kindepth aligned
  if (nrow(p) <= 1000L) {
    mine <- findGeneration(p$id, p$sire, p$dam, alignMates = TRUE)
    plain <- findGeneration(p$id, p$sire, p$dam)
    pu <- as.integer(Pedixplorer::kindepth(pp))
    pa <- as.integer(Pedixplorer::kindepth(pp, align_parents = TRUE))
    ord <- match(p$id, Pedixplorer::id(Pedixplorer::ped(pp)))
    cat(sprintf("  pdx kindepth order same as input: %s; unaligned vs pkd differ %d; aligned vs pkd aligned differ %d; aligned max pkd %d pdx %d; pdx aligned - pkd aligned: %s\n",
                identical(ord, seq_len(nrow(p))), sum(pu[ord] != plain), sum(pa[ord] != mine),
                max(mine), max(pa), paste(names(table(pa[ord] - mine)), table(pa[ord] - mine), sep = ":", collapse = " ")))
  }
  ## findUnavailable: kinship2 and Pedixplorer against pedkindraw
  if (nrow(p) <= 3000L) {
    mine <- findUnavailable(p, gen)
    k2 <- as.character(kinship2::findUnavailable(kp, i$avail))
    pdx <- as.character(Pedixplorer::find_unavailable(pp))
    cat(sprintf("  findUnavailable pkd %d, k2 %d, pdx %d; theirs all among pkd's: %s\n",
                length(mine), length(k2), length(pdx), all(c(k2, pdx) %in% mine)))
  }
}
