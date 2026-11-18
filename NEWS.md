# pedkindraw 0.0.1 (development version)

The first version, not yet on CRAN. Most of its code is a copy of
nprcgenekeepr's at nprcgenekeepr's commit `baef1e12c`; the items marked "New"
were written for pedkindraw. Where the copy now differs from nprcgenekeepr's
code, `DIVERGENCE.md` in the repository says how and why.

## Drawing

* `makePedigreeMatingLayout()` lays out a pedigree's animals and matings, and
  `drawPedigreeDiagram()` draws the layout as an interactive visNetwork graph:
  a symbol for each sex, a slash through each animal that has died, up to four
  conditions, twin lines, matings between relatives marked, an animal drawn
  twice where the layout needs it with its two places joined by a dashed line,
  a legend, a "Select by id" box and a PNG export button.
  `makePedigreeDiagramData()` makes a simpler drawing's nodes and edges.
* New: with two or more conditions, each condition's row in
  `drawPedigreeDiagram()`'s legend shows a circle cut into the same sections as
  the animals' symbols, with that condition's section filled, so the legend
  says which section is which. nprcgenekeepr's legend still shows a filled
  hexagon for each condition.
* New: the "Select by id" box lists the animals only; nprcgenekeepr's also
  lists the routing points (ids starting `__jog_`) a drawing adds to step a
  line around an animal: 196 of the 571 entries in the drawing vignette's
  colony drawing.
* New: `makePedigreeMatingLayout()` stops on an animal id that starts with
  `__jog_`, as for the other prefixes it keeps for its own nodes;
  nprcgenekeepr accepts one, and its drawing can then have two nodes with that
  id.
* New: layout hints, `makePedigreeMatingLayout(hints = )`: the left-to-right
  `order` of animals and, with `mate`, the side of a mating each mate is drawn
  on, in the form kinship2 and Pedixplorer give their hints.

## Kinship and relatedness

* `kinship()` computes the kinship matrix, dense or sparse; identical twins get
  the kinship of an animal with itself.
* New: `kinship()`'s parent arguments are `sire` and `dam`, in the places of
  nprcgenekeepr's `fatherId` and `motherId`, and it stops when a known sire's
  or dam's generation number (`pdepth`) is not below its offspring's, naming
  the animal. Before, kinship2's call form `kinship(id, dadid, momid, sex)`
  gave a wrong matrix with no error, taking the sex codes for generation
  numbers. `makePedigreeMatingLayout()`, unless given a `kinshipMatrix`,
  passes the pedigree's `gen` column to `kinship()`, so it stops the same way.
  The help page and the README name the functions kinship2 and Pedixplorer
  also export.
* New: `ibdMatrix()` builds an IBD matrix from pairs of ids and their values,
  and `findUnrelated()` finds a set of unrelated genotyped animals.

## Pedigree structure

* `findGeneration()`, `findPedigreeNumber()`, `getParents()`, `getOffspring()`,
  `getFounders()`, `isFounder()`, `hasBothParents()` and
  `getIdsWithOneParent()`.
* New: the pedigree argument is `ped` in `getParents()`, `getOffspring()` and
  `getIdsWithOneParent()`, in the place of nprcgenekeepr's `pedSourceDf` and
  `uPed`, and `addBackSecondParents(trimmedPed, ped)` calls the trimmed
  pedigree `trimmedPed`, in the place of `uPed`. A call that passes the
  pedigree by position is unchanged; one that names the old argument stops
  with "unused argument".
* New: the pedigree is the first argument in
  `getProbandPedigree(ped, probands)`,
  `getDescendantPedigree(ped, probands)`,
  `trimPedigree(ped, probands, ...)` and `hasBothParents(ped, id)`, as in the
  other functions that take one; nprcgenekeepr takes the ids first. A call
  that names both arguments is unchanged; one that passes them in
  nprcgenekeepr's order stops with "$ operator is invalid for atomic vectors".
* New: `familyCheck()` checks family ids against the family trees the sires
  and dams form.

## Checking and repair

* `checkTwinRelations()`, `addParents()`, `addBackSecondParents()` and
  `correctParentSex()`.
* New: `checkPedigree()` lists each problem in a pedigree, one row per
  problem, and changes nothing.

## Trimming and shrinking

* `trimPedigree()`, `getProbandPedigree()`, `getDescendantPedigree()`,
  `removeUnknownAnimals()`, `removeUninformativeFounders()` and
  `shrinkPedigree()`.
* New: the steps of `shrinkPedigree()`, exported under kinship2's names:
  `bitSize()`, `findUnavailable()`, `findAvailNonInform()` and
  `findAvailAffected()`.

## Converters

* New: `asPedFrame()` converts a kinship2 `pedigree` or `pedigreeList` and a
  Pedixplorer `Pedigree` to pedkindraw's pedigree, twins table and layout
  hints. kinship2 and Pedixplorer are suggested, never required.
