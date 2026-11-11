## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## A stand-in for shrinkPedigree(), which pedkindraw copies in Phase 10 (plan,
## Phases 6-10). Three copied Phase 8 test files shrink one pedigree, the
## 16-animal "Track B" (test_solveJointQP.R's .qpTrackBShrunk(),
## test_orderRootSubtrees.R and test_positionMatingUnitForest.R, each with
## maxBits = 1L), and read only the result's ped. This stand-in returns
## nprcgenekeepr's result for those arguments, saved at commit baef1e12c by
## tools/makeComputedTestFixtures.R (fixtures/trackBShrunk.rds), and stops on
## any other arguments. Delete it when Phase 10 copies shrinkPedigree().

shrinkPedigree <- function(ped, genotyped, affected = NULL, maxBits = 16L) {
  saved <- readRDS(test_path("fixtures", "trackBShrunk.rds"))
  called <- list(ped = ped, genotyped = genotyped, affected = affected,
                 maxBits = maxBits)
  if (!identical(called, saved$args)) {
    stop("the shrinkPedigree() stand-in knows only the saved Track B call",
         call. = FALSE)
  }
  list(ped = saved$value)
}
