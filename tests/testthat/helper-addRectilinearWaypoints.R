## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (pedkindraw S88,
## plan Phase 17j, ruling R162). It serves test_addRectilinearWaypointsDogleg.R
## and test_addRectilinearWaypointsInputs.R, which call
## .addRectilinearWaypoints() directly with the four tables it takes.

## The nodes, edges, forest and positions of 'ped', drawn direct (no
## waypoints yet), as makePedigreeMatingLayout() hands them to
## .addRectilinearWaypoints().
.directStyleInputs <- function(ped) {
  layout <- makePedigreeMatingLayout(ped, edgeStyle = "direct")
  forest <- .buildMatingUnitForest(ped)
  list(nodes = layout$nodes, edges = layout$edges, forest = forest,
       pos = .positionMatingUnitForest(ped, forest))
}
