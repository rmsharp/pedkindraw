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
#' [savePedigreeDiagram()] saves a drawing as an SVG, a PDF or a PNG file.
#' [runPedigreeApp()] starts an app that opens a pedigree file and draws it,
#' with no code.
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
#' [getIdsWithOneParent()] find sires and dams, offspring and founders;
#' [countOffspring()] counts each animal's offspring and [getMatings()] lists
#' the matings, each sire and dam with an offspring together or declared
#' mated.
#'
#' @section Checking and repair:
#' [checkPedigree()] lists each problem in a pedigree and
#' [checkTwinRelations()] checks a twins table; [recodePedigree()] rewrites
#' other ways of writing an unknown parent or a sex into this package's codes;
#' [addParents()], [correctParentSex()] and [addBackSecondParents()] repair a
#' pedigree.
#'
#' @section Trimming and shrinking:
#' [trimPedigree()], [getProbandPedigree()], [getDescendantPedigree()] and
#' [getNearRelativePedigree()] reduce a pedigree to the animals of interest and
#' their relatives; [removeUnknownAnimals()] and
#' [removeUninformativeFounders()] remove animals that add nothing, and
#' [removeAnimals()] removes the animals listed, clearing their offspring's
#' links to them; [shrinkPedigree()] shrinks a pedigree to a bit-size budget,
#' in steps also exported: [bitSize()], [findUnavailable()],
#' [findAvailNonInform()] and [findAvailAffected()].
#'
#' @section Converting kinship2 and Pedixplorer objects:
#' [asPedFrame()] converts a kinship2 `pedigree` or `pedigreeList` and a
#' Pedixplorer `Pedigree` to the pedigree, twins table, layout hints and
#' declared matings the functions above take.
#'
#' @section Getting started:
#' `vignette("pedkindraw", package = "pedkindraw")` takes the 375-animal
#' example pedigree that comes with the package from its records to a drawing:
#' checking it, its generations and family trees, kinship, trimming it to one
#' animal's ancestors, drawing them, shrinking it and finding unrelated
#' animals. `vignette("drawing", package = "pedkindraw")` shows what a drawing
#' shows and how to change it: the symbols and the legend, deceased animals,
#' conditions, twins, animals drawn twice, matings of relatives, the two edge
#' styles, layout hints, kinship2 and Pedixplorer objects, saving a drawing,
#' clicks in a Shiny application and a colony-size drawing.
#' `vignette("speed", package = "pedkindraw")` gives the seconds each function
#' took on one machine, by the number of animals from 300 to 100,000, beside
#' the kinship2 and Pedixplorer functions that do the same, and how large a
#' drawing can be drawn and read. The README on the
#' package's GitHub page draws a twelve-animal pedigree; the example of
#' [drawPedigreeDiagram()] draws four. To draw a pedigree file with no code,
#' [runPedigreeApp()] opens it in an app in the web browser, which also saves
#' the drawing and the animals.
"_PACKAGE"
