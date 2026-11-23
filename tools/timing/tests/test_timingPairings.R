## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Each timing pairing gives pedkindraw's answer, or the difference measured
## and recorded (docs/planning/pedkindraw-timing-plan.md sections 3.8 and 6,
## Phase 17h1; ruling R154; Learning 19), on the seed-1 colony of 300
## animals and the 375-animal sample, from the very calls the timing cases
## make (caseValues(), helper-caseValues.R). The package's own suite compares
## each function with kinship2 and Pedixplorer on typed and seeded cases; these
## tests check that the harness hands every package the same input. A
## difference here fails the test when it changes. Run from the project root
## with PKD_LIB set:
##   Rscript -e 'testthat::test_file(
##     "tools/timing/tests/test_timingPairings.R")'

library(testthat) # nolint: undesirable_function_linter.

sourceComparisonScript("comparisonFormats.R")
sourceComparisonScript("generateColonyPedigree.R")
sourceComparisonScript("timingHarness.R")
sourceComparisonScript("measure.R")
sourceComparisonScript("timingCases.R")

## A matrix with its rows and columns in id order.
sorted <- function(m) {
  m <- as.matrix(m)
  m[order(rownames(m)), order(colnames(m))]
}
## id, sire and dam as text, in id order, a parent without a row NA.
trio <- function(id, sire, dam) {
  d <- data.frame(
    id = as.character(id), sire = as.character(sire),
    dam = as.character(dam), stringsAsFactors = FALSE
  )
  d$sire[!(d$sire %in% d$id)] <- NA
  d$dam[!(d$dam %in% d$id)] <- NA
  d <- d[order(d$id), ]
  rownames(d) <- NULL
  d
}
pedixplorerTrio <- function(obj) {
  q <- Pedixplorer::ped(obj)
  trio(Pedixplorer::id(q), Pedixplorer::dadid(q), Pedixplorer::momid(q))
}
## The pedigree, the shared inputs and the case values, by pedigree name.
pairing <- function(name) {
  p <- timingPedigree(name) # nolint: object_usage_linter.
  # nolint next: object_usage_linter.
  list(p = p, i = timingInputs(p), v = caseValues(name))
}
both <- c(colony = "colony", sample = "sample")

## ---- the study's computations (R153's first group) ------------------------

test_that("the family numbers the inputs carry are findPedigreeNumber()'s", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    x <- pairing(name)
    expect_identical(x$i$families, x$v$pkd_fam, info = name)
  }
})

test_that("kinship: kinship2's and Pedixplorer's equal pedkindraw's", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    for (id in c("k2_kin", "pdx_kin")) {
      expect_equal(sorted(v[[id]]), sorted(v$pkd_kin), info = paste(name, id))
    }
    for (id in c("k2_kinX", "pdx_kinX")) {
      expect_equal(sorted(v[[id]]), sorted(v$pkd_kinX),
        info = paste(name, id)
      )
    }
  }
})

test_that("sparse kinship: makekinship() equals pedkindraw's but gives 1 as
  the self-kinship of each animal in no family (10 in the colony)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    mine <- sorted(v$pkd_kin_sparse)
    theirs <- sorted(v$k2_makekinship)
    differs <- which(abs(mine - theirs) > 1e-12, arr.ind = TRUE)
    alone <- sort(pairing(name)$p$id[v$k2_fam == 0L])
    expect_identical(nrow(differs),
      c(colony = 10L, sample = 0L)[[name]],
      info = name
    )
    expect_identical(rownames(mine)[differs[, 1L]], alone, info = name)
    expect_identical(differs[, 1L], differs[, 2L], info = name)
    expect_true(all(theirs[differs] == 1.0 & mine[differs] == 0.5))
  }
})

test_that("generation depth: kindepth() equals findGeneration()", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    expect_identical(as.integer(v$k2_depth), as.integer(v$pkd_gen))
    expect_identical(as.integer(v$pdx_depth), as.integer(v$pkd_gen))
  }
})

## kinship2's makefamid() puts each animal related to no other in family 0,
## Pedixplorer's make_famid() in none (NA); pedkindraw gives each its own.
test_that("families: the same animals together; an animal related to no
  other alone in pedkindraw's, in family 0 or NA in theirs", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    alone <- v$k2_fam == 0L
    expect_identical(sum(alone), c(colony = 10L, sample = 0L)[[name]])
    expect_identical(is.na(v$pdx_fam), alone, info = name)
    expect_true(all(table(v$pkd_fam)[as.character(v$pkd_fam[alone])] == 1L))
    mine <- v$pkd_fam[!alone]
    for (theirs in list(v$k2_fam[!alone], v$pdx_fam[!alone])) {
      pairs <- unique(paste(mine, theirs))
      expect_identical(length(pairs), length(unique(mine)), info = name)
      expect_length(unique(theirs), length(unique(mine)))
    }
  }
})

## kinship2 and Pedixplorer choose among ties at random (seed 1 here, as
## timeOne.R sets it): the same number kept and the same last bit size.
test_that("shrinking to 16 bits keeps as many animals at the same bit size", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    kept <- c(
      nrow(v$pkd_shrink$ped), length(v$k2_shrink$pedObj$id),
      length(Pedixplorer::id(Pedixplorer::ped(v$pdx_shrink$pedObj)))
    )
    last <- c(
      utils::tail(unlist(v$pkd_shrink$bitSize), 1L),
      utils::tail(v$k2_shrink$bitSize, 1L),
      utils::tail(v$pdx_shrink$bit_size, 1L)
    )
    expect_identical(kept, rep(c(colony = 18L, sample = 56L)[[name]], 3L))
    expect_identical(last, rep(c(colony = 12.0, sample = 16.0)[[name]], 3L))
  }
})

test_that("unrelated sets: the same size", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    expect_identical(
      lengths(list(v$pkd_unrel, v$k2_unrel, v$pdx_unrel)),
      rep(c(colony = 7L, sample = 44L)[[name]], 3L)
    )
  }
})

test_that("ancestors and descendants: Pedixplorer's plus the probands", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    x <- pairing(name)
    v <- x$v
    expect_setequal(v$pkd_anc$id, union(x$p$id[v$pdx_anc], x$i$probands))
    expect_setequal(v$pkd_desc$id, union(v$pdx_desc, x$i$probands))
  }
})

## ---- with a kinship2 or Pedixplorer function (R153's third group) --------

test_that("bit size: the same three numbers", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  expected <- list(colony = c(528L, 24L, 276L), sample = c(378L, 124L, 251L))
  for (name in both) {
    v <- pairing(name)$v
    expect_identical(unname(unlist(v$pkd_bits)), expected[[name]])
    expect_identical(as.integer(unlist(v$k2_bits)[1L:3L]), expected[[name]])
    expect_identical(as.integer(unlist(v$pdx_bits)[1L:3L]), expected[[name]])
  }
})

test_that("unavailable animals: the same on the colony; on the sample 104,
  97 and 96, theirs among pedkindraw's (R154)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  counts <- list(colony = c(173L, 173L, 173L), sample = c(104L, 97L, 96L))
  for (name in both) {
    v <- pairing(name)$v
    theirs <- list(as.character(v$k2_unavail), as.character(v$pdx_unavail))
    expect_identical(lengths(c(list(v$pkd_unavail), theirs)), counts[[name]])
    expect_true(all(unlist(theirs) %in% v$pkd_unavail), info = name)
  }
})

test_that("available uninformative animals: 13, 186 and 173 in the colony;
  4, 98 and 96 on the sample (R40, R154)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  counts <- list(colony = c(13L, 186L, 173L), sample = c(4L, 98L, 96L))
  for (name in both) {
    v <- pairing(name)$v
    expect_identical(
      lengths(list(v$pkd_noninform, v$k2_noninform, v$pdx_noninform)),
      counts[[name]]
    )
  }
})

test_that("one available affected animal: the same bit size; pedkindraw
  lists every animal removed, the others the one chosen (R154)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    bits <- c(colony = 208.0, sample = 378.0)[[name]]
    expect_identical(
      c(v$pkd_availaff$bitSize, v$k2_availaff$bitSize,
        v$pdx_availaff$bit_size),
      rep(bits, 3L)
    )
    expect_length(v$pkd_availaff$idTrimmed,
      c(colony = 175L, sample = 0L)[[name]]
    )
  }
  v <- pairing("colony")$v
  expect_length(v$k2_availaff$idTrimmed, 1L)
  expect_true(v$k2_availaff$idTrimmed %in% v$pkd_availaff$idTrimmed)
  expect_true(v$pdx_availaff$id_trimmed %in% v$pkd_availaff$idTrimmed)
  v <- pairing("sample")$v
  expect_false(v$pkd_availaff$isTrimmed)
  expect_false(v$k2_availaff$isTrimmed)
  expect_false(v$pdx_availaff$is_trimmed)
})

test_that("family check: kinship2's equals pedkindraw's; Pedixplorer's on
  the sample too (on the colony it stops, R154)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  columns <- c("famid", "n", "unrelated", "split", "join")
  table <- function(d) {
    d <- as.data.frame(d)[, columns]
    rownames(d) <- NULL
    lapply(d, as.numeric)
  }
  for (name in both) {
    v <- pairing(name)$v
    expect_identical(nrow(v$pkd_famcheck), c(colony = 11L, sample = 5L)[[name]])
    expect_equal(table(v$k2_famcheck), table(v$pkd_famcheck), info = name)
  }
  v <- pairing("sample")$v
  expect_identical(table(v$pdx_famcheck), table(v$pkd_famcheck))
})

test_that("IBD matrix: the same values", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    n <- c(colony = 300L, sample = 375L)[[name]]
    expect_identical(dim(v$pkd_ibd), c(n, n))
    expect_equal(sorted(v$k2_ibd), sorted(v$pkd_ibd), info = name)
    expect_equal(sorted(v$pdx_ibd), sorted(v$pkd_ibd), info = name)
  }
})

test_that("near relatives: the same animals as useful_inds(max_dist = 3)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    expect_length(v$pdx_near, c(colony = 234L, sample = 84L)[[name]])
    expect_setequal(v$pkd_near$id, v$pdx_near)
  }
})

test_that("removing 5 animals without offspring: the same pedigree", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    mine <- trio(v$pkd_remove$id, v$pkd_remove$sire, v$pkd_remove$dam)
    ids <- as.character(v$k2_remove$id)
    k2 <- trio(
      ids, ids[ifelse(v$k2_remove$findex > 0L, v$k2_remove$findex, NA)],
      ids[ifelse(v$k2_remove$mindex > 0L, v$k2_remove$mindex, NA)]
    )
    expect_identical(nrow(mine), c(colony = 295L, sample = 370L)[[name]])
    expect_identical(k2, mine, info = name)
    expect_identical(pedixplorerTrio(v$pdx_remove), mine, info = name)
  }
})

test_that("an object as a data frame: asPedFrame() gives as.data.frame()'s
  animals and parents", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  noParent <- function(x) ifelse(x %in% c("0", ""), NA, as.character(x))
  for (name in both) {
    v <- pairing(name)$v
    mine <- v$pkd_frame_k2$ped
    theirs <- v$k2_frame
    expect_identical(
      trio(mine$id, mine$sire, mine$dam),
      trio(theirs$id, noParent(theirs$dadid), noParent(theirs$momid))
    )
    mine <- v$pkd_frame_pdx$ped
    theirs <- v$pdx_frame
    expect_identical(
      trio(mine$id, mine$sire, mine$dam),
      trio(theirs$id, theirs$dadid, theirs$momid)
    )
  }
})

test_that("adding missing parents: none to add in either pedigree (R154)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    n <- c(colony = 300L, sample = 375L)[[name]]
    expect_identical(
      c(
        nrow(v$pkd_addparents), nrow(v$k2_addparents),
        nrow(v$pdx_addparents)
      ),
      rep(n, 3L)
    )
  }
})

test_that("offspring counts, recoding and founders: the same answers", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    x <- pairing(name)
    v <- x$v
    counted <- v$pdx_offspring$num_child_dir[match(x$p$id, v$pdx_offspring$id)]
    expect_identical(unname(v$pkd_offspring), as.integer(counted))
    expect_identical(v$pkd_recode$sire, v$pdx_recode$dadid)
    expect_identical(v$pkd_recode$dam, v$pdx_recode$momid)
    expect_identical(v$pkd_founder, as.logical(v$pdx_founder))
    expect_identical(sum(v$pkd_founder), c(colony = 24L, sample = 124L)[[name]])
  }
})

test_that("aligned generations: kinship2's differ in 0 and 3 animals,
  Pedixplorer's in 290 and 336 (R154)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    v <- pairing(name)$v
    mine <- as.integer(v$pkd_aligned)
    expect_identical(
      sum(as.integer(v$k2_aligned) != mine),
      c(colony = 0L, sample = 3L)[[name]]
    )
    expect_identical(
      sum(as.integer(v$pdx_aligned) != mine),
      c(colony = 290L, sample = 336L)[[name]]
    )
  }
})

## ---- the functions only pedkindraw has (R153's fourth group) -------------

test_that("the repair functions find nothing to fix in either pedigree
  (R154)", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in both) {
    x <- pairing(name)
    v <- x$v
    expect_true(all(as.character(v$pkd_parentsex) == x$p$sex), info = name)
    expect_identical(nrow(v$pkd_unknown), nrow(x$p))
    expect_length(v$pkd_oneparent, 0L)
    expect_identical(nrow(v$pkd_addback), nrow(v$pkd_anc))
    expect_identical(nrow(v$pkd_twins), 3L)
  }
})
