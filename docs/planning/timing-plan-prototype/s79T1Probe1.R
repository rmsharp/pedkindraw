# 17h1, S79: the T1 probe (docs/planning/pedkindraw-timing-plan.md section 5.2,
# R154): each input built on a pedigree, each pairing's pedkindraw, kinship2 and
# Pedixplorer call made once, and their answers compared.
# Not package code. <src dir> holds nprcgenekeepr's harness files, read from
# its clone (only read):
#   git -C ../nprcgenekeepr archive 3e06730c5 tools/pedigreeComparison \
#     tools/perf/harness.R | tar -x -C <src dir>
# Run from the pedkindraw root with renv's library and RENV_PROJECT unset
# (Learning 5), under bash:
#   Rscript --no-init-file docs/planning/timing-plan-prototype/s79T1Probe1.R \
#     <src dir> <300|1000|sample>
# S79 (300 and sample): every case returns; the differences R154 records.
args <- commandArgs(trailingOnly = TRUE)
src <- args[[1L]]
which <- args[[2L]]
suppressMessages(pkgload::load_all(".", quiet = TRUE))
here <- file.path(src, "tools", "pedigreeComparison")
source(file.path(here, "comparisonFormats.R"))
source(file.path(here, "generateColonyPedigree.R"))
source(file.path(src, "tools", "perf", "harness.R"))
source(file.path(here, "timingCases.R"))
suppressMessages({
  loadNamespace("kinship2")
  loadNamespace("Pedixplorer")
})
p <- if (identical(which, "sample")) {
  s <- utils::read.csv("inst/extdata/obfuscated_rhesus_mhc_ped.csv",
                       colClasses = "character", na.strings = c("", "NA"))
  s[, c("id", "sire", "dam", "sex", "birth")]
} else {
  generateColonyPedigree(as.integer(which), 1L)
}
i <- timingInputs(p)
gen <- i$avail == 1L
aff <- i$affected == 1L
pr <- i$probands
cat(sprintf("== %s: %d animals, %d genotyped, %d affected, probands %s\n",
            which, nrow(p), sum(gen), sum(aff), toString(pr)))
cat(sprintf("   one parent %d; rowless parents %d\n",
            sum(xor(is.na(p$sire), is.na(p$dam))),
            length(setdiff(stats::na.omit(c(p$sire, p$dam)), p$id))))

## kinship2 and Pedixplorer objects, as the study built them (placeholder
## parents for one known parent; rowless parents given rows here only if
## the constructors refuse them).
full <- completeParentage(p)
rowless <- setdiff(stats::na.omit(c(full$sire, full$dam)), full$id)
if (length(rowless) > 0L) {
  extra <- full[rep(NA_integer_, length(rowless)), , drop = FALSE]
  extra$id <- rowless
  extra$sex <- ifelse(rowless %in% full$sire, "M", "F")
  full <- rbind(full, extra)
}
avF <- as.integer(full$id %in% p$id[gen])
afF <- as.integer(full$id %in% p$id[aff])
k <- toKinship2(full)
kp <- tryCatch(kinship2::pedigree(k$id, k$dadid, k$momid, k$sex,
                                  affected = afF),
               error = function(e) conditionMessage(e))
q <- toPedixplorer(full)
q$avail <- avF
q$affection <- afF
pp <- tryCatch(suppressWarnings(suppressMessages(Pedixplorer::Pedigree(q))),
               error = function(e) conditionMessage(e))
cat("   kinship2 object:", class(kp)[1L], " Pedixplorer object:",
    class(pp)[1L], " rows added for rowless parents:", length(rowless), "\n")

try1 <- function(expr) {
  setTimeLimit(elapsed = 60, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf))
  tryCatch(suppressWarnings(suppressMessages(expr)),
           error = function(e) structure(list(msg = conditionMessage(e)),
                                         class = "failed"))
}
show <- function(label, mine, k2, pdx, same) {
  st <- function(x) if (inherits(x, "failed")) {
    paste0("STOP(", substr(gsub("\n", " ", x$msg), 1L, 50L), ")")
  } else "ok"
  agree <- function(x) {
    if (is.null(x) || inherits(x, "failed") || inherits(mine, "failed")) {
      return("-")
    }
    r <- tryCatch(same(mine, x), error = function(e) {
      paste("cmp-error", conditionMessage(e))
    })
    if (isTRUE(r)) "same" else paste("DIFF", if (is.character(r)) r else "")
  }
  cat(sprintf("%-26s pkd %-4s | k2 %-28s %-22s | pdx %-28s %s\n", label,
              st(mine), if (is.null(k2)) "--" else st(k2), agree(k2),
              if (is.null(pdx)) "--" else st(pdx), agree(pdx)))
}
ok <- function(cond, msg) if (isTRUE(cond)) TRUE else msg
sameSet <- function(a, b) {
  a <- as.character(a); b <- as.character(b)
  if (setequal(a, b)) TRUE else sprintf("%d vs %d, %d shared", length(a),
                                        length(b), length(intersect(a, b)))
}
pdxIds <- function(x) Pedixplorer::id(Pedixplorer::ped(x))

## bitSize
mine <- try1(bitSize(p))
k2 <- try1(kinship2::bitSize(kp))
pdx <- try1(Pedixplorer::bit_size(pp))
show("bitSize", mine, k2, pdx, function(a, b) {
  ok(identical(unname(unlist(a)), as.integer(unname(unlist(b))[1:3])),
     sprintf("%s vs %s", toString(unlist(a)), toString(unlist(b)[1:3])))
})

## findUnavailable
mine <- try1(findUnavailable(p, gen))
k2 <- try1(kinship2::findUnavailable(kp, avF))
pdx <- try1(Pedixplorer::find_unavailable(pp))
show("findUnavailable", mine, k2, pdx, sameSet)

## findAvailNonInform
mine <- try1(findAvailNonInform(p, gen, aff))
k2 <- try1(kinship2::findAvailNonInform(kp, avF))
pdx <- try1(Pedixplorer::find_avail_noninform(pp))
show("findAvailNonInform", mine, k2, pdx, sameSet)
cat("   pdx noninform returns", class(pdx)[1L], "head", toString(utils::head(pdx, 4L)),
    "; k2 has pkd's all:", all(mine %in% k2), "\n")

## findAvailAffected, affstatus TRUE / 1
mine <- try1(findAvailAffected(p, gen, aff, TRUE))
k2 <- try1(kinship2::findAvailAffected(kp, avF, 1))
pdx <- try1(Pedixplorer::find_avail_affected(pp, affstatus = 1))
show("findAvailAffected", mine, k2, pdx, function(a, b) {
  ida <- as.character(a$idTrimmed)
  idb <- as.character(if (!is.null(b$idTrimmed)) b$idTrimmed else b$id_trimmed)
  bsa <- a$bitSize
  bsb <- if (!is.null(b$bitSize)) b$bitSize else b$bit_size
  ok(identical(ida, idb) && isTRUE(all.equal(as.numeric(bsa), as.numeric(bsb))),
     sprintf("id %s/%s bits %s/%s", toString(ida), toString(idb), bsa, bsb))
})

## familyCheck on findPedigreeNumber()'s families
fam <- findPedigreeNumber(p$id, p$sire, p$dam)
mine <- try1(familyCheck(fam, p$id, p$sire, p$dam))
famF <- fam[match(full$id, p$id)]
famF[is.na(famF)] <- max(fam, na.rm = TRUE) + 1L
k2 <- try1(kinship2::familycheck(famF[seq_len(nrow(p))], p$id, p$sire, p$dam))
pdx <- try1(Pedixplorer::family_check(p$id, p$sire, p$dam, fam))
cols <- c("famid", "n", "unrelated", "split", "join")
show("familyCheck", mine, k2, pdx, function(a, b) {
  a <- as.data.frame(a)[, cols]; b <- as.data.frame(b)
  names(b) <- sub("^n$", "n", names(b))
  b <- b[, intersect(cols, names(b)), drop = FALSE]
  if (ncol(b) < 5L) return(paste("cols", toString(names(b))))
  rownames(a) <- NULL; rownames(b) <- NULL
  ok(isTRUE(all.equal(lapply(a, as.numeric), lapply(b, as.numeric))),
     sprintf("%d vs %d rows", nrow(a), nrow(b)))
})

## ibdMatrix: each animal 1; each parent-offspring pair 0.5 (sire and dam)
hasS <- !is.na(p$sire) & p$sire %in% p$id
hasD <- !is.na(p$dam) & p$dam %in% p$id
id1 <- c(p$id, p$id[hasS], p$id[hasD])
id2 <- c(p$id, p$sire[hasS], p$dam[hasD])
x <- c(rep(1, nrow(p)), rep(0.5, sum(hasS) + sum(hasD)))
cat(sprintf("   ibd pairs, both parents: %d (sire only %d)\n", length(id1),
            nrow(p) + sum(hasS)))
mine <- try1(ibdMatrix(id1, id2, x))
k2 <- try1(kinship2::ibdMatrix(id1, id2, x))
pdx <- try1(Pedixplorer::ibd_matrix(id1, id2, x))
show("ibdMatrix", mine, k2, pdx, function(a, b) {
  a <- as.matrix(a); b <- as.matrix(b)
  if (identical(dimnames(a), dimnames(b)) && isTRUE(all.equal(a, b))) return(TRUE)
  if (setequal(rownames(a), rownames(b)) &&
      isTRUE(all.equal(a, b[rownames(a), colnames(a)]))) return("same values, order differs")
  "values differ"
})

## getNearRelativePedigree, maxDist 3, the probands
mine <- try1(getNearRelativePedigree(p, pr, 3)$id)
chosen <- as.integer(full$id %in% pr)
qn <- data.frame(id = full$id, dadid = full$sire, momid = full$dam,
                 sex = match(full$sex, c("M", "F"), nomatch = 3L),
                 affection = chosen, avail = chosen, stringsAsFactors = FALSE)
pdx <- try1({
  pn <- Pedixplorer::Pedigree(qn)
  pn <- Pedixplorer::is_informative(pn, col_aff = "affection",
                                    informative = "AvAf")
  u <- Pedixplorer::ped(Pedixplorer::useful_inds(pn, max_dist = 3))
  Pedixplorer::id(u)[Pedixplorer::useful(u)]
})
show("getNearRelative(3)", mine, NULL, pdx, sameSet)

## removeAnimals, the probands
trio <- function(d) data.frame(id = as.character(d$id),
                               sire = as.character(d$sire),
                               dam = as.character(d$dam))
mine <- try1(trio(removeAnimals(p, pr)))
k2 <- try1({
  t <- kinship2::pedigree.trim(pr, kp)
  data.frame(id = as.character(t$id),
             sire = ifelse(t$findex > 0, as.character(t$id)[t$findex], NA),
             dam = ifelse(t$mindex > 0, as.character(t$id)[t$mindex], NA))
})
pdx <- try1({
  u <- Pedixplorer::ped(Pedixplorer::subset(pp, setdiff(pdxIds(pp), pr),
                                            del_parents = "one"))
  data.frame(id = Pedixplorer::id(u), sire = Pedixplorer::dadid(u),
             dam = Pedixplorer::momid(u))
})
sameTrio <- function(a, b) {
  b <- b[b$id %in% a$id, ]
  b <- b[match(a$id, b$id), ]
  b$sire[!(b$sire %in% a$id)] <- NA
  b$dam[!(b$dam %in% a$id)] <- NA
  a$sire[!(a$sire %in% a$id)] <- NA
  a$dam[!(a$dam %in% a$id)] <- NA
  rownames(b) <- NULL
  ok(identical(a, b), sprintf("%d of %d rows differ (%d vs %d rows)", sum(
    !(a$sire %in% b$sire & a$dam %in% b$dam) |
      xor(is.na(a$sire), is.na(b$sire)) | xor(is.na(a$dam), is.na(b$dam)), na.rm = TRUE),
    nrow(a), nrow(a), nrow(b)))
}
show("removeAnimals(probands)", mine, k2, pdx, sameTrio)

## asPedFrame of a kinship2 and a Pedixplorer object
mine <- try1(trio(asPedFrame(kp)$ped))
k2 <- try1({
  d <- kinship2:::as.data.frame.pedigree(kp)
  data.frame(id = as.character(d$id),
             sire = ifelse(d$dadid %in% c("0", ""), NA, as.character(d$dadid)),
             dam = ifelse(d$momid %in% c("0", ""), NA, as.character(d$momid)))
})
show("asPedFrame(kinship2)", mine, k2, NULL, sameTrio)
mine <- try1(trio(asPedFrame(pp)$ped))
pdx <- try1({
  d <- as.data.frame(Pedixplorer::ped(pp))
  data.frame(id = d$id, sire = d$dadid, dam = d$momid)
})
show("asPedFrame(Pedixplorer)", mine, NULL, pdx, sameTrio)

## addParents vs fixParents / fix_parents
added <- function(d) sort(setdiff(as.character(d$id), p$id))
mine <- try1(added(addParents(p)))
k2 <- try1(added(kinship2::fixParents(k$id[seq_len(nrow(p))], p$sire, p$dam,
                                      k$sex[seq_len(nrow(p))])))
pdx <- try1(added(Pedixplorer::fix_parents(p$id, p$sire, p$dam,
  toPedixplorer(p)$sex)))
show("addParents (rows added)", mine, k2, pdx, function(a, b) {
  ok(length(a) == length(b), sprintf("%d vs %d", length(a), length(b)))
})
cat(sprintf("   addParents adds %d rows; getIdsWithOneParent %d; removeUnknownAnimals drops %d\n",
            length(added(addParents(p))), length(getIdsWithOneParent(p)),
            nrow(addParents(p)) - nrow(removeUnknownAnimals(addParents(p)))))
tp <- trimPedigree(p, pr)
cat(sprintf("   trimPedigree keeps %d; addBackSecondParents adds %d\n",
            nrow(tp), nrow(addBackSecondParents(tp, p)) - nrow(tp)))

## countOffspring vs num_child
mine <- try1(unname(countOffspring(p)))
pdx <- try1({
  r <- Pedixplorer::num_child(p$id, p$sire, p$dam)
  as.integer(r$num_child_dir[match(p$id, r$id)])
})
show("countOffspring", mine, NULL, pdx, function(a, b) ok(identical(a, b),
       sprintf("%d differ", sum(a != b))))

## recodePedigree vs norm_ped, on the pedigree as it is
mine <- try1(recodePedigree(p))
pdx <- try1(Pedixplorer::norm_ped(data.frame(id = p$id, dadid = p$sire,
                                             momid = p$dam, sex = p$sex)))
show("recodePedigree", mine, NULL, pdx, function(a, b) {
  ok(identical(as.character(a$sire), as.character(b$dadid)) &&
    identical(as.character(a$dam), as.character(b$momid)), "parents differ")
})

## isFounder vs is_founder
mine <- try1(isFounder(p))
pdx <- try1(Pedixplorer::is_founder(p$dam, p$sire))
show("isFounder", mine, NULL, pdx, function(a, b) ok(identical(a, as.logical(b)),
       sprintf("%d differ", sum(a != b))))

## findGeneration(alignMates = TRUE) vs kindepth(align = TRUE)
mine <- try1(findGeneration(p$id, p$sire, p$dam, alignMates = TRUE))
k2 <- try1(as.integer(kinship2::kindepth(k$id, k$dadid, k$momid,
                                         align = TRUE))[seq_len(nrow(p))])
pdx <- try1({
  d <- Pedixplorer::kindepth(pp, align_parents = TRUE)
  as.integer(d)[match(p$id, pdxIds(pp))]
})
show("findGeneration(aligned)", mine, k2, pdx, function(a, b) {
  ok(identical(as.integer(a), as.integer(b)),
    sprintf("%d of %d differ", sum(a != b, na.rm = TRUE), length(a)))
})
cat(sprintf("   unaligned: findGeneration vs kindepth: %s\n",
            sum(findGeneration(p$id, p$sire, p$dam) !=
                  kinship2::kindepth(k$id, k$dadid, k$momid)[seq_len(nrow(p))])))

## findUnrelated vs pedigree.unrelated / unrelated (sizes; theirs random)
mine <- try1(findUnrelated(p, gen))
k2 <- try1(kinship2::pedigree.unrelated(kp, avF))
pdx <- try1(Pedixplorer::unrelated(pp))
show("findUnrelated (size)", mine, k2, pdx, function(a, b) {
  ok(length(a) >= length(b), sprintf("%d vs %d", length(a), length(b)))
})
cat(sprintf("   sizes: pkd %s, k2 %s, pdx %s\n", length(mine), length(k2),
            length(pdx)))
