# 17h1, S79: T1 probe 3, the alternative inputs checked before the picker (a
# split family; 5 animals without offspring removed; the IBD pair counts; a
# damaged copy of the 300 colony).
# Not package code. <src dir> holds nprcgenekeepr's harness files, read from
# its clone (only read):
#   git -C ../nprcgenekeepr archive 3e06730c5 tools/pedigreeComparison \
#     tools/perf/harness.R | tar -x -C <src dir>
# Run from the pedkindraw root with renv's library and RENV_PROJECT unset
# (Learning 5), under bash:
#   Rscript --no-init-file docs/planning/timing-plan-prototype/s79T1Probe3.R <src dir>
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
trio <- function(id, sire, dam) {
  d <- data.frame(id = as.character(id), sire = as.character(sire),
                  dam = as.character(dam))
  d$sire[!(d$sire %in% d$id)] <- NA
  d$dam[!(d$dam %in% d$id)] <- NA
  d[order(d$id), ]
}
for (nm in names(peds)) {
  p <- peds[[nm]]
  i <- timingInputs(p)
  k <- toKinship2(p)
  kp <- kinship2::pedigree(k$id, k$dadid, k$momid, k$sex, affected = i$affected)
  q <- toPedixplorer(p); q$avail <- i$avail; q$affection <- i$affected
  pp <- suppressWarnings(suppressMessages(Pedixplorer::Pedigree(q)))
  cat("==", nm, nrow(p), "\n")
  ## familyCheck: findPedigreeNumber()'s numbers, every 7th animal (seeded
  ## would do as well) moved to a family of its own number
  fam <- findPedigreeNumber(p$id, p$sire, p$dam)
  famSplit <- fam
  famSplit[seq(1L, nrow(p), by = 7L)] <- max(fam) + 1L
  a <- familyCheck(famSplit, p$id, p$sire, p$dam)
  b <- q1(kinship2::familycheck(famSplit, p$id, p$sire, p$dam))
  cc <- q1(Pedixplorer::family_check(p$id, p$sire, p$dam, famSplit))
  cols <- c("famid", "n", "unrelated", "split", "join")
  norm <- function(d) { d <- as.data.frame(d)[, cols]; rownames(d) <- NULL; lapply(d, as.numeric) }
  cat(sprintf("  familyCheck split: rows %d, splits>0 %d, joins>0 %d; k2 same %s; pdx same %s\n",
              nrow(a), sum(a$split > 0), sum(a$join > 0),
              if (is.character(b)) b else isTRUE(all.equal(norm(a), norm(b))),
              if (is.character(cc)) cc else isTRUE(all.equal(norm(a), norm(cc)))))
  ## removeAnimals: 5 seeded animals with a known sire and no offspring
  leaves <- p$id[!is.na(p$sire) & !(p$id %in% c(p$sire, p$dam))]
  lv <- withSeed(7L, sample(leaves, 5L))
  mine <- removeAnimals(p, lv)
  t <- q1(kinship2::pedigree.trim(lv, kp))
  u <- q1(Pedixplorer::ped(Pedixplorer::subset(pp, setdiff(p$id, lv), del_parents = "one")))
  m <- trio(mine$id, mine$sire, mine$dam)
  kt <- if (is.character(t)) t else {
    ids <- as.character(t$id)
    kk <- trio(ids, ids[ifelse(t$findex > 0, t$findex, NA)], ids[ifelse(t$mindex > 0, t$mindex, NA)]); rownames(kk) <- rownames(m) <- NULL; if (identical(m, kk)) TRUE else sum(!(m$sire %in% kk$sire & m$dam %in% kk$dam) | xor(is.na(m$sire), is.na(kk$sire)) | xor(is.na(m$dam), is.na(kk$dam)))
  }
  pt <- if (is.character(u)) u else { pu <- trio(Pedixplorer::id(u), Pedixplorer::dadid(u), Pedixplorer::momid(u)); rownames(pu) <- rownames(m) <- NULL; if (identical(m, pu)) TRUE else paste(sum(xor(is.na(m$sire), is.na(pu$sire)) | xor(is.na(m$dam), is.na(pu$dam)) | (m$sire != pu$sire) %in% TRUE | (m$dam != pu$dam) %in% TRUE), 'rows differ;', nrow(m), nrow(pu)) }
  cat(sprintf("  removeAnimals(5 leaves): %d rows left; k2 identical %s; pdx identical %s\n",
              nrow(mine), kt, pt))
  ## the probands are leaves too?
  cat(sprintf("  probands with offspring: %d of 5\n", sum(i$probands %in% c(p$sire, p$dam))))
}
## the ibd pair counts at each size
for (n in c(300L, 1000L, 3000L, 10000L, 30000L, 100000L)) {
  p <- generateColonyPedigree(n, 1L)
  cat(sprintf("ibd pairs at %d: sire only %d, both parents %d\n", n,
              n + sum(!is.na(p$sire)), n + sum(!is.na(p$sire)) + sum(!is.na(p$dam))))
}
## a damaged copy of the 300 colony: what the six repair functions find
p <- generateColonyPedigree(300L, 1L)
kids <- which(!is.na(p$sire))
d <- p
cut <- withSeed(11L, sample(kids, round(0.05 * length(kids))))
d$sire[cut] <- NA
parents <- unique(stats::na.omit(c(d$sire, d$dam)))
gone <- withSeed(12L, sample(parents, max(1L, round(0.01 * nrow(d)))))
d <- d[!(d$id %in% gone), ]
ap <- addParents(d)
tp <- trimPedigree(d, timingInputs(d)$probands)
cat(sprintf("damaged 300: %d rows; one parent %d; rowless parents %d; addParents adds %d; removeUnknownAnimals drops %d; addBackSecondParents adds %d\n",
            nrow(d), length(getIdsWithOneParent(d)), length(setdiff(stats::na.omit(c(d$sire, d$dam)), d$id)),
            nrow(ap) - nrow(d), nrow(ap) - nrow(removeUnknownAnimals(ap)),
            nrow(addBackSecondParents(tp, d)) - nrow(tp)))
