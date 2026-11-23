# 17g, S78: a sizing probe, NOT the timing method: kinship2's and
# Pedixplorer's functions, one call each in one process, a 60 s limit each, to
# size Phase 17h (docs/planning/pedkindraw-timing-plan.md section 3.4). Not
# package code. <dir> holds the colonies and the two files s78Colonies.R reads
# from the clone. From the root:
#   Rscript --no-init-file docs/planning/timing-plan-prototype/s78ProbeOthers.R <dir> <n>
# Three calls stop on their inputs as written here (kinship2 findAvailNonInform,
# Pedixplorer useful_inds and num_child): 17h1 builds each case properly.
S <- commandArgs(trailingOnly = TRUE)[[1L]]
source(file.path(S, "comparisonFormats.R"))
n <- as.integer(commandArgs(trailingOnly = TRUE)[[2L]])
p <- readComparisonPedigree(file.path(S, sprintf("synthetic_%d.csv", n)))
set.seed(42L); av <- as.integer(stats::runif(nrow(p)) < 0.3); af <- as.integer(stats::runif(nrow(p)) < 0.1)
set.seed(7L); pr <- sample(p$id[!is.na(p$sire)], 5L)
suppressMessages({ loadNamespace("kinship2"); loadNamespace("Pedixplorer") })
one <- function(label, expr) {
  setTimeLimit(elapsed = 60, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf))
  t0 <- proc.time()[["elapsed"]]
  r <- tryCatch({ suppressWarnings(suppressMessages(force(expr))); "ok" },
    error = function(e) substr(gsub("\n", " ", conditionMessage(e)), 1, 70))
  cat(sprintf("%-38s n=%-6d %8.3f s  %s\n", label, n, proc.time()[["elapsed"]] - t0, r))
}
k <- toKinship2(p)
kp <- kinship2::pedigree(k$id, k$dadid, k$momid, k$sex, affected = af)
q <- toPedixplorer(p); q$avail <- av; q$affection <- af
pp <- suppressWarnings(suppressMessages(Pedixplorer::Pedigree(q)))
fam <- kinship2::makefamid(p$id, p$sire, p$dam)
one("k2 bitSize", kinship2::bitSize(kp))
one("pdx bit_size", Pedixplorer::bit_size(pp))
one("k2 findUnavailable", kinship2::findUnavailable(kp, av))
one("pdx find_unavailable", Pedixplorer::find_unavailable(pp))
one("k2 findAvailNonInform", kinship2::findAvailNonInform(kp, av))
one("pdx find_avail_noninform", Pedixplorer::find_avail_noninform(pp))
one("k2 findAvailAffected", kinship2::findAvailAffected(kp, av, 1))
one("pdx find_avail_affected", Pedixplorer::find_avail_affected(pp, affstatus = 1))
one("k2 familycheck", kinship2::familycheck(fam, p$id, p$sire, p$dam))
one("pdx family_check", Pedixplorer::family_check(pp))
one("pdx useful_inds(max_dist 3)", Pedixplorer::useful_inds(pp, informative = pr, max_dist = 3))
one("k2 pedigree.trim(5)", kinship2::pedigree.trim(pr, kp))
one("pdx subset(5)", Pedixplorer::subset(pp, pr, keep = FALSE))
one("k2 fixParents", kinship2::fixParents(k$id, k$dadid, k$momid, k$sex))
one("pdx num_child", Pedixplorer::num_child(pp))
one("pdx norm_ped", Pedixplorer::norm_ped(q))
one("pdx is_founder", Pedixplorer::is_founder(q$momid, q$dadid))
one("k2 kindepth(align)", kinship2::kindepth(p$id, p$sire, p$dam, align = TRUE))
one("pdx kindepth(align)", Pedixplorer::kindepth(pp, align_parents = TRUE))
one("k2 as.data.frame", kinship2:::as.data.frame.pedigree(kp))
one("pdx as.data.frame", as.data.frame(Pedixplorer::ped(pp)))
one("k2 pedigree.unrelated", kinship2::pedigree.unrelated(kp, av))
one("pdx unrelated", Pedixplorer::unrelated(pp))
kk <- data.frame(id1 = c(p$id, p$id[!is.na(p$sire)]), id2 = c(p$id, p$sire[!is.na(p$sire)]),
  x = c(rep(1, nrow(p)), rep(0.5, sum(!is.na(p$sire)))))
one("k2 ibdMatrix", kinship2::ibdMatrix(kk$id1, kk$id2, kk$x))
one("pdx ibd_matrix", Pedixplorer::ibd_matrix(kk$id1, kk$id2, kk$x))
