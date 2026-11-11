## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## A stand-in for shrinkPedigree(), which pedkindraw copies in Phase 10 (plan,
## Phases 6-10). Three copied Phase 8 test files shrink one pedigree, the
## 16-animal "Track B", with maxBits = 1L, and read only the result's ped:
## test_solveJointQP.R's .qpTrackBShrunk() and test_orderRootSubtrees.R pass
## it with its gen column, test_positionMatingUnitForest.R without. This
## stand-in returns nprcgenekeepr's result for those two calls, saved at
## commit baef1e12c by tools/makeComputedTestFixtures.R
## (fixtures/trackBShrunk.rds), and stops on any other arguments. Delete it
## when Phase 10 copies shrinkPedigree().

shrinkPedigree <- function(ped, genotyped, affected = NULL, maxBits = 16L) {
  called <- list(ped = ped, genotyped = genotyped, affected = affected,
                 maxBits = maxBits)
  for (saved in readRDS(test_path("fixtures", "trackBShrunk.rds"))) {
    if (identical(called, saved$args)) {
      return(list(ped = saved$value))
    }
  }
  stop("the shrinkPedigree() stand-in knows only the two saved Track B calls",
       call. = FALSE)
}
