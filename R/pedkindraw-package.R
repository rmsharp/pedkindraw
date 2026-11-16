## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own documentation, not copied from nprcgenekeepr (plan
## Phase 16a, pedkindraw S26): the package help page, ?pedkindraw. Its title
## and description come from DESCRIPTION.

#' @section Drawing:
#' [makePedigreeMatingLayout()] lays out a pedigree's animals and matings,
#' with a twins table, a kinship matrix and layout hints, and
#' [drawPedigreeDiagram()] draws the layout as an interactive graph.
#' [makePedigreeDiagramData()] makes a simpler drawing's nodes and edges.
#'
#' @section Kinship and relatedness:
#' [kinship()] computes the kinship matrix, [ibdMatrix()] builds an IBD matrix
#' from pairs of ids and their values, and [findUnrelated()] finds a set of
#' unrelated genotyped animals.
#'
#' @section Pedigree structure:
#' [findGeneration()], [findPedigreeNumber()] and [familyCheck()] number and
#' check each animal's generation and family tree; [getParents()],
#' [getOffspring()], [getFounders()], [isFounder()], [hasBothParents()] and
#' [getIdsWithOneParent()] find sires and dams, offspring and founders.
#'
#' @section Checking and repair:
#' [checkPedigree()] lists each problem in a pedigree and
#' [checkTwinRelations()] checks a twins table; [addParents()],
#' [correctParentSex()] and [addBackSecondParents()] repair a pedigree.
#'
#' @section Trimming and shrinking:
#' [trimPedigree()], [getProbandPedigree()] and [getDescendantPedigree()]
#' reduce a pedigree to the animals of interest and their relatives;
#' [removeUnknownAnimals()] and [removeUninformativeFounders()] remove
#' animals that add nothing; [shrinkPedigree()] shrinks a pedigree to a
#' bit-size budget, in steps also exported: [bitSize()], [findUnavailable()],
#' [findAvailNonInform()] and [findAvailAffected()].
#'
#' @section Converting kinship2 and Pedixplorer objects:
#' [asPedFrame()] converts a kinship2 `pedigree` or `pedigreeList` and a
#' Pedixplorer `Pedigree` to the pedigree, twins table and layout hints the
#' functions above take.
#'
#' @section Getting started:
#' `vignette("pedkindraw", package = "pedkindraw")` takes the 375-animal
#' example pedigree that comes with the package from its records to a drawing:
#' checking it, its generations and family trees, kinship, trimming it to one
#' animal's ancestors, drawing them, shrinking it and finding unrelated
#' animals. The README on the package's GitHub page draws a twelve-animal
#' pedigree; the example of [drawPedigreeDiagram()] draws four.
"_PACKAGE"
