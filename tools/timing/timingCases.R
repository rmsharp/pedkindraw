## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/timingCases.R at
## nprcgenekeepr commit 3e06730c5 and rewritten for pedkindraw's timing runs
## (docs/planning/pedkindraw-timing-plan.md sections 4.1, 5.1 and 5.2;
## rulings R153 and R154). Changes: nprcgenekeepr's eight cases are
## pedkindraw's, called as a user calls them today (pkd_ for npg_); BGmisc's
## four cases are dropped; pkd_unrel is added; then one case for each of the
## 13 functions kinship2 or Pedixplorer also has, findGeneration(alignMates =
## TRUE) and asPedFrame() of each object, with kinship2's and Pedixplorer's
## functions for them; then the 13 functions only pedkindraw has: 78 cases.
## timingInputs() gains R154's inputs, and a case may name packages it loads
## besides its own (`loads`). A case's computation is the words the speed
## vignette's tables use.
##
## The Phase 1 timing cases (nprcgenekeepr's
## standalone-pedigree-package-plan.md, Phase 1 steps 4-5): one per
## computation and package. prepare(p) builds the
## inputs and is not timed; call(x) is the timed call. A step a user must run
## first (findGeneration() before kinship(), kinship2's makefamid() before
## makekinship(), Pedixplorer's is_informative() before useful_inds()) is part
## of the timed call; a pedigree object a computation takes is built in
## prepare(), because building it is its own row. Each case names only its own
## package and its `loads`, so that a child process loads only those. Needs
## comparisonFormats.R and measure.R (withSeed()) sourced first; the tests
## are in tests/test_timingHarness.R and tests/test_timingPairings.R.

## The inputs shared by every case: the pedigree, a seeded 30% available and
## 10% affected (as nprcgenekeepr's runAgreement.R's rhesus375 run), and 5
## seeded probands with a known sire. withSeed() puts the caller's random
## state back. R154 adds: 5 seeded animals with a known sire and no offspring
## (`leaves`, the animals removed); the family numbers findPedigreeNumber()
## gives (`families`); the IBD pairs (`ibd`); and the twin pairs (`twins`).
# nolint start: object_usage_linter.
timingInputs <- function(p) {
  draws <- withSeed(42L, list(
    avail = as.integer(stats::runif(nrow(p)) < 0.3),
    affected = as.integer(stats::runif(nrow(p)) < 0.1)
  ))
  withSire <- p$id[!is.na(p$sire)]
  probands <- withSeed(7L, {
    if (length(withSire) > 5L) sample(withSire, 5L) else withSire
  })
  leaves <- withSire[!(withSire %in% c(p$sire, p$dam))]
  leaves <- withSeed(7L, {
    if (length(leaves) > 5L) sample(leaves, 5L) else leaves
  })
  list(
    p = p, avail = draws$avail, affected = draws$affected,
    probands = probands, leaves = leaves,
    families = familyNumbers(p$id, p$sire, p$dam), ibd = ibdPairs(p),
    twins = twinPairs(p)
  )
}
# nolint end

## The family number of each animal, as pedkindraw's findPedigreeNumber()
## gives it: the animals joined through parents and offspring (a parent
## without a row included) share one, numbered from 1 in the order of each
## family's first founder (an animal with neither parent known); NA for an
## animal no founder reaches. Written here, in base R, so that kinship2's and
## Pedixplorer's cases need no pedkindraw; the tests check it against
## findPedigreeNumber().
familyNumbers <- function(id, sire, dam) {
  nodes <- unique(c(id, sire[!is.na(sire)], dam[!is.na(dam)]))
  child <- match(c(id, id), nodes)
  parent <- match(c(sire, dam), nodes)
  known <- !is.na(parent)
  child <- child[known]
  parent <- parent[known]
  label <- seq_along(nodes)
  repeat {
    low <- pmin(label[child], label[parent])
    lowest <- label
    for (end in list(child, parent)) {
      least <- tapply(low, end, min)
      at <- as.integer(names(least))
      lowest[at] <- pmin(lowest[at], as.integer(least))
    }
    if (identical(lowest, label)) break
    label <- lowest
  }
  founder <- is.na(sire) & is.na(dam)
  order <- unique(label[match(id[founder], nodes)])
  match(label[match(id, nodes)], order)
}

## Each animal's own value 1 and 0.5 for each sire and each dam pair (R154),
## for ibdMatrix(), in SOLAR's form.
ibdPairs <- function(p) {
  hasSire <- !is.na(p$sire) & p$sire %in% p$id
  hasDam <- !is.na(p$dam) & p$dam %in% p$id
  data.frame(
    id1 = c(p$id, p$id[hasSire], p$id[hasDam]),
    id2 = c(p$id, p$sire[hasSire], p$dam[hasDam]),
    x = c(rep(1.0, nrow(p)), rep(0.5, sum(hasSire) + sum(hasDam))),
    stringsAsFactors = FALSE
  )
}

## 1 full-sibling pair per 100 animals (at least 1), each from another
## sibship, seeded, coded "DZ twin" (R154: no colony has full siblings born in
## one year, so the pairs are not twins by birth, only by the table).
twinPairs <- function(p) {
  both <- which(!is.na(p$sire) & !is.na(p$dam))
  key <- paste(p$sire[both], p$dam[both], sep = "\r")
  sibships <- split(p$id[both], factor(key, levels = unique(key)))
  sibships <- sibships[lengths(sibships) >= 2L]
  n <- min(length(sibships), max(1L, nrow(p) %/% 100L))
  # nolint next: object_usage_linter.
  chosen <- withSeed(13L, sample.int(length(sibships), n))
  data.frame(
    id1 = vapply(sibships[chosen], `[[`, "", 1L),
    id2 = vapply(sibships[chosen], `[[`, "", 2L),
    code = rep("DZ twin", n), row.names = NULL, stringsAsFactors = FALSE
  )
}

timingCase <- function(id, computation, package, prepare, call,
                       loads = character()) {
  list(
    id = id, computation = computation, package = package,
    prepare = prepare, call = call, loads = loads
  )
}

## A kinship2 pedigree object and a Pedixplorer Pedigree object of p, with
## the shared availability and affected status, as the study's shrinking and
## unrelated-set cases build them.
kinship2Object <- function(p, i = timingInputs(p)) {
  k <- toKinship2(p) # nolint: object_usage_linter.
  kinship2::pedigree(k$id, k$dadid, k$momid, k$sex, affected = i$affected)
}
pedixplorerObject <- function(p, i = timingInputs(p)) {
  q <- toPedixplorer(p) # nolint: object_usage_linter.
  q$avail <- i$avail
  q$affection <- i$affected
  Pedixplorer::Pedigree(q)
}

## A kinship2 object of p with the shared availability, as kinship2's
## shrinking, unrelated-set and trimming functions take them.
kinship2WithAvail <- function(p) {
  i <- timingInputs(p)
  list(ped = kinship2Object(p, i), avail = i$avail)
}

## toKinship2() and toPedixplorer() come from comparisonFormats.R, sourced
## first, which lintr cannot see.
# nolint start: object_usage_linter.
timingCases <- function() {
  c(studyCases(), pairedCases(), pedkindrawOnlyCases())
}

## The study's computations (R153's first group): nprcgenekeepr's study's
## 25 cases for kinship2, Pedixplorer and nprcgenekeepr, nprcgenekeepr's now
## pedkindraw's, and pedkindraw's findUnrelated().
studyCases <- function() {
  kin <- "Kinship, autosomal"
  kinSparse <- "Kinship, autosomal, sparse or by family"
  kinX <- "Kinship, X chromosome"
  depth <- "Generation depth"
  family <- "Family (connected component)"
  shrink <- "Shrink to 16 bits"
  unrelated <- "Unrelated set"
  ancestors <- "Probands and their ancestors"
  descendants <- "Probands and their descendants"
  object <- "Build a pedigree object"
  list(
    timingCase(
      "k2_kin", kin, "kinship2", function(p) toKinship2(p),
      function(x) kinship2::kinship(x$id, x$dadid, x$momid, x$sex)
    ),
    timingCase(
      "pdx_kin", kin, "Pedixplorer", function(p) toPedixplorer(p),
      function(x) Pedixplorer::kinship(x$id, x$dadid, x$momid, x$sex)
    ),
    timingCase(
      "pkd_kin", kin, "pedkindraw", function(p) p,
      function(x) {
        g <- pedkindraw::findGeneration(x$id, x$sire, x$dam)
        pedkindraw::kinship(x$id, x$sire, x$dam, g)
      }
    ),
    timingCase(
      "pkd_kin_sparse", kinSparse, "pedkindraw", function(p) p,
      function(x) {
        g <- pedkindraw::findGeneration(x$id, x$sire, x$dam)
        pedkindraw::kinship(x$id, x$sire, x$dam, g, sparse = TRUE)
      }
    ),
    timingCase(
      "k2_makekinship", kinSparse, "kinship2", function(p) p,
      function(x) {
        f <- kinship2::makefamid(x$id, x$sire, x$dam)
        kinship2::makekinship(f, x$id, x$sire, x$dam)
      }
    ),
    timingCase(
      "k2_kinX", kinX, "kinship2", function(p) toKinship2(p),
      function(x) {
        kinship2::kinship(x$id, x$dadid, x$momid, x$sex, chrtype = "X")
      }
    ),
    timingCase(
      "pdx_kinX", kinX, "Pedixplorer", function(p) toPedixplorer(p),
      function(x) {
        Pedixplorer::kinship(x$id, x$dadid, x$momid, x$sex, chrtype = "X")
      }
    ),
    timingCase(
      "pkd_kinX", kinX, "pedkindraw", function(p) p,
      function(x) {
        g <- pedkindraw::findGeneration(x$id, x$sire, x$dam)
        pedkindraw::kinship(x$id, x$sire, x$dam, g,
          chrtype = "x",
          sex = x$sex
        )
      }
    ),
    timingCase(
      "k2_depth", depth, "kinship2", function(p) p,
      function(x) kinship2::kindepth(x$id, x$sire, x$dam)
    ),
    timingCase(
      "pdx_depth", depth, "Pedixplorer", function(p) p,
      function(x) Pedixplorer::kindepth(x$id, x$sire, x$dam)
    ),
    timingCase(
      "pkd_gen", depth, "pedkindraw", function(p) p,
      function(x) pedkindraw::findGeneration(x$id, x$sire, x$dam)
    ),
    timingCase(
      "k2_fam", family, "kinship2", function(p) p,
      function(x) kinship2::makefamid(x$id, x$sire, x$dam)
    ),
    timingCase(
      "pdx_fam", family, "Pedixplorer", function(p) p,
      function(x) Pedixplorer::make_famid(x$id, x$sire, x$dam)
    ),
    timingCase(
      "pkd_fam", family, "pedkindraw", function(p) p,
      function(x) pedkindraw::findPedigreeNumber(x$id, x$sire, x$dam)
    ),
    timingCase(
      "k2_shrink", shrink, "kinship2",
      function(p) kinship2WithAvail(p),
      function(x) {
        kinship2::pedigree.shrink(x$ped, avail = x$avail, maxBits = 16L)
      }
    ),
    timingCase(
      "pdx_shrink", shrink, "Pedixplorer",
      function(p) pedixplorerObject(p),
      function(x) Pedixplorer::shrink(x, max_bits = 16L)
    ),
    timingCase(
      "pkd_shrink", shrink, "pedkindraw", function(p) timingInputs(p),
      function(x) {
        pedkindraw::shrinkPedigree(x$p,
          genotyped = x$avail == 1L,
          affected = x$affected == 1L, maxBits = 16L
        )
      }
    ),
    timingCase(
      "k2_unrel", unrelated, "kinship2",
      function(p) kinship2WithAvail(p),
      function(x) kinship2::pedigree.unrelated(x$ped, avail = x$avail)
    ),
    timingCase(
      "pdx_unrel", unrelated, "Pedixplorer",
      function(p) pedixplorerObject(p),
      function(x) Pedixplorer::unrelated(x)
    ),
    timingCase(
      "pkd_unrel", unrelated, "pedkindraw", function(p) timingInputs(p),
      function(x) pedkindraw::findUnrelated(x$p, genotyped = x$avail == 1L)
    ),
    timingCase(
      "pkd_anc", ancestors, "pedkindraw", function(p) timingInputs(p),
      function(x) pedkindraw::trimPedigree(x$p, x$probands)
    ),
    timingCase(
      "pdx_anc", ancestors, "Pedixplorer",
      function(p) {
        i <- timingInputs(p)
        list(
          probands = match(i$probands, p$id), momx = match(p$dam, p$id),
          dadx = match(p$sire, p$id)
        )
      },
      function(x) {
        unlist(lapply(x$probands, Pedixplorer::ancestors,
          momx = x$momx, dadx = x$dadx
        ))
      }
    ),
    timingCase(
      "pkd_desc", descendants, "pedkindraw", function(p) timingInputs(p),
      function(x) pedkindraw::getDescendantPedigree(x$p, x$probands)
    ),
    timingCase(
      "pdx_desc", descendants, "Pedixplorer", function(p) timingInputs(p),
      function(x) {
        Pedixplorer::descendants(x$probands, x$p$id, x$p$sire, x$p$dam)
      }
    ),
    timingCase(
      "k2_ped", object, "kinship2", function(p) toKinship2(p),
      function(x) kinship2::pedigree(x$id, x$dadid, x$momid, x$sex)
    ),
    timingCase(
      "pdx_ped", object, "Pedixplorer", function(p) toPedixplorer(p),
      function(x) Pedixplorer::Pedigree(x)
    )
  )
}

## R153's third group: the 13 functions kinship2 or Pedixplorer also has,
## findGeneration(alignMates = TRUE) and asPedFrame() of each object (15
## pedkindraw cases), with kinship2's 10 and Pedixplorer's 14 functions for
## them (plan section 3.3), on R154's inputs.
pairedCases <- function() {
  bits <- "Bit size"
  unavail <- "Unavailable animals to trim"
  noninform <- "Available, uninformative animals to trim"
  availAff <- "One available affected animal to trim"
  famCheck <- "Family check"
  ibd <- "IBD matrix from pairs"
  near <- "Near relatives (distance 3)"
  remove <- "Remove 5 animals"
  fromK2 <- "A kinship2 object as a data frame"
  fromPdx <- "A Pedixplorer object as a data frame"
  addParents <- "Add rows for missing parents"
  offspring <- "Count offspring"
  recode <- "Recode a pedigree file's values"
  founder <- "Founder or not"
  aligned <- "Generation depth, mates aligned"
  list(
    timingCase(
      "pkd_bits", bits, "pedkindraw", function(p) p,
      function(x) pedkindraw::bitSize(x)
    ),
    timingCase(
      "k2_bits", bits, "kinship2", function(p) kinship2Object(p),
      function(x) kinship2::bitSize(x)
    ),
    timingCase(
      "pdx_bits", bits, "Pedixplorer", function(p) pedixplorerObject(p),
      function(x) Pedixplorer::bit_size(x)
    ),
    timingCase(
      "pkd_unavail", unavail, "pedkindraw", function(p) timingInputs(p),
      function(x) pedkindraw::findUnavailable(x$p, x$avail == 1L)
    ),
    timingCase(
      "k2_unavail", unavail, "kinship2",
      function(p) kinship2WithAvail(p),
      function(x) kinship2::findUnavailable(x$ped, x$avail)
    ),
    timingCase(
      "pdx_unavail", unavail, "Pedixplorer",
      function(p) pedixplorerObject(p),
      function(x) Pedixplorer::find_unavailable(x)
    ),
    timingCase(
      "pkd_noninform", noninform, "pedkindraw", function(p) timingInputs(p),
      function(x) {
        pedkindraw::findAvailNonInform(x$p, x$avail == 1L, x$affected == 1L)
      }
    ),
    timingCase(
      "k2_noninform", noninform, "kinship2",
      function(p) kinship2WithAvail(p),
      function(x) kinship2::findAvailNonInform(x$ped, x$avail)
    ),
    timingCase(
      "pdx_noninform", noninform, "Pedixplorer",
      function(p) pedixplorerObject(p),
      function(x) Pedixplorer::find_avail_noninform(x)
    ),
    timingCase(
      "pkd_availaff", availAff, "pedkindraw", function(p) timingInputs(p),
      function(x) {
        pedkindraw::findAvailAffected(x$p, x$avail == 1L, x$affected == 1L,
          affstatus = TRUE
        )
      }
    ),
    timingCase(
      "k2_availaff", availAff, "kinship2",
      function(p) kinship2WithAvail(p),
      function(x) kinship2::findAvailAffected(x$ped, x$avail, affstatus = 1L)
    ),
    timingCase(
      "pdx_availaff", availAff, "Pedixplorer",
      function(p) pedixplorerObject(p),
      function(x) Pedixplorer::find_avail_affected(x, affstatus = 1L)
    ),
    timingCase(
      "pkd_famcheck", famCheck, "pedkindraw", function(p) timingInputs(p),
      function(x) {
        pedkindraw::familyCheck(x$families, x$p$id, x$p$sire, x$p$dam)
      }
    ),
    timingCase(
      "k2_famcheck", famCheck, "kinship2", function(p) timingInputs(p),
      function(x) {
        kinship2::familycheck(x$families, x$p$id, x$p$sire, x$p$dam)
      }
    ),
    timingCase(
      "pdx_famcheck", famCheck, "Pedixplorer", function(p) timingInputs(p),
      function(x) {
        Pedixplorer::family_check(x$p$id, x$p$sire, x$p$dam, x$families)
      }
    ),
    timingCase(
      "pkd_ibd", ibd, "pedkindraw", function(p) ibdPairs(p),
      function(x) pedkindraw::ibdMatrix(x$id1, x$id2, x$x)
    ),
    timingCase(
      "k2_ibd", ibd, "kinship2", function(p) ibdPairs(p),
      function(x) kinship2::ibdMatrix(x$id1, x$id2, x$x)
    ),
    timingCase(
      "pdx_ibd", ibd, "Pedixplorer", function(p) ibdPairs(p),
      function(x) Pedixplorer::ibd_matrix(x$id1, x$id2, x$x)
    ),
    timingCase(
      "pkd_near", near, "pedkindraw", function(p) timingInputs(p),
      function(x) pedkindraw::getNearRelativePedigree(x$p, x$probands, 3L)
    ),
    timingCase(
      "pdx_near", near, "Pedixplorer",
      function(p) {
        chosen <- as.integer(p$id %in% timingInputs(p)$probands)
        q <- toPedixplorer(p)
        q$avail <- chosen
        q$affection <- chosen
        Pedixplorer::Pedigree(q)
      },
      function(x) {
        x <- Pedixplorer::is_informative(x,
          col_aff = "affection",
          informative = "AvAf"
        )
        u <- Pedixplorer::ped(Pedixplorer::useful_inds(x, max_dist = 3L))
        Pedixplorer::id(u)[Pedixplorer::useful(u)]
      }
    ),
    timingCase(
      "pkd_remove", remove, "pedkindraw", function(p) timingInputs(p),
      function(x) pedkindraw::removeAnimals(x$p, x$leaves)
    ),
    timingCase(
      "k2_remove", remove, "kinship2",
      function(p) {
        i <- timingInputs(p)
        list(ped = kinship2Object(p, i), leaves = i$leaves)
      },
      function(x) kinship2::pedigree.trim(x$leaves, x$ped)
    ),
    timingCase(
      "pdx_remove", remove, "Pedixplorer",
      function(p) {
        i <- timingInputs(p)
        list(ped = pedixplorerObject(p, i), kept = setdiff(p$id, i$leaves))
      },
      function(x) Pedixplorer::subset(x$ped, x$kept, del_parents = "one")
    ),
    timingCase(
      "pkd_frame_k2", fromK2, "pedkindraw", function(p) kinship2Object(p),
      function(x) pedkindraw::asPedFrame(x),
      loads = "kinship2"
    ),
    timingCase(
      "k2_frame", fromK2, "kinship2", function(p) kinship2Object(p),
      function(x) as.data.frame(x)
    ),
    timingCase(
      "pkd_frame_pdx", fromPdx, "pedkindraw",
      function(p) pedixplorerObject(p),
      function(x) pedkindraw::asPedFrame(x),
      loads = "Pedixplorer"
    ),
    timingCase(
      "pdx_frame", fromPdx, "Pedixplorer", function(p) pedixplorerObject(p),
      function(x) as.data.frame(Pedixplorer::ped(x))
    ),
    timingCase(
      "pkd_addparents", addParents, "pedkindraw", function(p) p,
      function(x) pedkindraw::addParents(x)
    ),
    timingCase(
      "k2_addparents", addParents, "kinship2", function(p) toKinship2(p),
      function(x) kinship2::fixParents(x$id, x$dadid, x$momid, x$sex)
    ),
    timingCase(
      "pdx_addparents", addParents, "Pedixplorer",
      function(p) toPedixplorer(p),
      function(x) Pedixplorer::fix_parents(x$id, x$dadid, x$momid, x$sex)
    ),
    timingCase(
      "pkd_offspring", offspring, "pedkindraw", function(p) p,
      function(x) pedkindraw::countOffspring(x)
    ),
    timingCase(
      "pdx_offspring", offspring, "Pedixplorer", function(p) p,
      function(x) Pedixplorer::num_child(x$id, x$sire, x$dam)
    ),
    timingCase(
      "pkd_recode", recode, "pedkindraw", function(p) p,
      function(x) pedkindraw::recodePedigree(x)
    ),
    timingCase(
      "pdx_recode", recode, "Pedixplorer",
      function(p) {
        data.frame(
          id = p$id, dadid = p$sire, momid = p$dam, sex = p$sex,
          stringsAsFactors = FALSE
        )
      },
      function(x) Pedixplorer::norm_ped(x)
    ),
    timingCase(
      "pkd_founder", founder, "pedkindraw", function(p) p,
      function(x) pedkindraw::isFounder(x)
    ),
    timingCase(
      "pdx_founder", founder, "Pedixplorer", function(p) p,
      function(x) Pedixplorer::is_founder(x$dam, x$sire)
    ),
    timingCase(
      "pkd_aligned", aligned, "pedkindraw", function(p) p,
      function(x) {
        pedkindraw::findGeneration(x$id, x$sire, x$dam, alignMates = TRUE)
      }
    ),
    timingCase(
      "k2_aligned", aligned, "kinship2", function(p) p,
      function(x) kinship2::kindepth(x$id, x$sire, x$dam, align = TRUE)
    ),
    timingCase(
      "pdx_aligned", aligned, "Pedixplorer",
      function(p) pedixplorerObject(p),
      function(x) Pedixplorer::kindepth(x, align_parents = TRUE)
    )
  )
}

## R153's fourth group: the 13 functions only pedkindraw has, on the shared
## inputs (R154: the repair functions on the colony as it is).
pedkindrawOnlyCases <- function() {
  only <- function(id, computation, prepare, call) {
    timingCase(id, computation, "pedkindraw", prepare, call)
  }
  list(
    only(
      "pkd_check", "Check a pedigree", function(p) p,
      function(x) pedkindraw::checkPedigree(x)
    ),
    only(
      "pkd_matings", "Matings", function(p) p,
      function(x) pedkindraw::getMatings(x)
    ),
    only(
      "pkd_parentsex", "Correct parents' sex", function(p) p,
      function(x) {
        pedkindraw::correctParentSex(
          x$id, x$sire, x$dam, x$sex,
          rep("original", nrow(x))
        )
      }
    ),
    only(
      "pkd_addback", "Add back second parents", function(p) {
        i <- timingInputs(p)
        list(trimmed = pedkindraw::trimPedigree(p, i$probands), ped = p)
      },
      function(x) pedkindraw::addBackSecondParents(x$trimmed, x$ped)
    ),
    only(
      "pkd_uninformative", "Remove uninformative founders", function(p) p,
      function(x) pedkindraw::removeUninformativeFounders(x)
    ),
    only(
      "pkd_unknown", "Remove added animals",
      function(p) pedkindraw::addParents(p),
      function(x) pedkindraw::removeUnknownAnimals(x)
    ),
    only(
      "pkd_proband", "Probands' pedigree", function(p) timingInputs(p),
      function(x) pedkindraw::getProbandPedigree(x$p, x$probands)
    ),
    only(
      "pkd_parents", "Parents of 5 animals", function(p) timingInputs(p),
      function(x) pedkindraw::getParents(x$p, x$probands)
    ),
    only(
      "pkd_offspringids", "Offspring of 5 animals",
      function(p) timingInputs(p),
      function(x) pedkindraw::getOffspring(x$p, x$probands)
    ),
    only(
      "pkd_founders", "Founders' ids", function(p) p,
      function(x) pedkindraw::getFounders(x)
    ),
    only(
      "pkd_bothparents", "Has both parents", function(p) timingInputs(p),
      function(x) pedkindraw::hasBothParents(x$p, x$probands[[1L]])
    ),
    only(
      "pkd_oneparent", "Animals with one parent", function(p) p,
      function(x) pedkindraw::getIdsWithOneParent(x)
    ),
    only(
      "pkd_twins", "Check twin pairs", function(p) timingInputs(p),
      function(x) pedkindraw::checkTwinRelations(x$p, x$twins)
    )
  )
}
# nolint end
