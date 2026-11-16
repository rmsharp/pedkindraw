# Changelog

## pedkindraw 0.0.1 (development version)

The first version, not yet on CRAN. Most of its code is a copy of
nprcgenekeepr’s at nprcgenekeepr’s commit `baef1e12c`; the items marked
“New” were written for pedkindraw. Where the copy now differs from
nprcgenekeepr’s code, `DIVERGENCE.md` in the repository says how and
why.

### Drawing

- [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  lays out a pedigree’s animals and matings, and
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  draws the layout as an interactive visNetwork graph: a symbol for each
  sex, a slash through each animal that has died, up to four conditions,
  twin lines, matings between relatives marked, an animal drawn twice
  where the layout needs it with its two places joined by a dashed line,
  a legend, a “Select by id” box and a PNG export button.
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  makes a simpler drawing’s nodes and edges.
- New: with two or more conditions, each condition’s row in
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)‘s
  legend shows a circle cut into the same sections as the animals’
  symbols, with that condition’s section filled, so the legend says
  which section is which. nprcgenekeepr’s legend still shows a filled
  hexagon for each condition.
- New: layout hints, `makePedigreeMatingLayout(hints = )`: the
  left-to-right `order` of animals and, with `mate`, the side of a
  mating each mate is drawn on, in the form kinship2 and Pedixplorer
  give their hints.

### Kinship and relatedness

- [`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
  computes the kinship matrix, dense or sparse; identical twins get the
  kinship of an animal with itself.
- New:
  [`ibdMatrix()`](https://rmsharp.github.io/pedkindraw/reference/ibdMatrix.md)
  builds an IBD matrix from pairs of ids and their values, and
  [`findUnrelated()`](https://rmsharp.github.io/pedkindraw/reference/findUnrelated.md)
  finds a set of unrelated genotyped animals.

### Pedigree structure

- [`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md),
  [`findPedigreeNumber()`](https://rmsharp.github.io/pedkindraw/reference/findPedigreeNumber.md),
  [`getParents()`](https://rmsharp.github.io/pedkindraw/reference/getParents.md),
  [`getOffspring()`](https://rmsharp.github.io/pedkindraw/reference/getOffspring.md),
  [`getFounders()`](https://rmsharp.github.io/pedkindraw/reference/getFounders.md),
  [`isFounder()`](https://rmsharp.github.io/pedkindraw/reference/isFounder.md),
  [`hasBothParents()`](https://rmsharp.github.io/pedkindraw/reference/hasBothParents.md)
  and
  [`getIdsWithOneParent()`](https://rmsharp.github.io/pedkindraw/reference/getIdsWithOneParent.md).
- New:
  [`familyCheck()`](https://rmsharp.github.io/pedkindraw/reference/familyCheck.md)
  checks family ids against the family trees the sires and dams form.

### Checking and repair

- [`checkTwinRelations()`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md),
  [`addParents()`](https://rmsharp.github.io/pedkindraw/reference/addParents.md),
  [`addBackSecondParents()`](https://rmsharp.github.io/pedkindraw/reference/addBackSecondParents.md)
  and
  [`correctParentSex()`](https://rmsharp.github.io/pedkindraw/reference/correctParentSex.md).
- New:
  [`checkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
  lists each problem in a pedigree, one row per problem, and changes
  nothing.

### Trimming and shrinking

- [`trimPedigree()`](https://rmsharp.github.io/pedkindraw/reference/trimPedigree.md),
  [`getProbandPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getProbandPedigree.md),
  [`getDescendantPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getDescendantPedigree.md),
  [`removeUnknownAnimals()`](https://rmsharp.github.io/pedkindraw/reference/removeUnknownAnimals.md),
  [`removeUninformativeFounders()`](https://rmsharp.github.io/pedkindraw/reference/removeUninformativeFounders.md)
  and
  [`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md).
- New: the steps of
  [`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md),
  exported under kinship2’s names:
  [`bitSize()`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md),
  [`findUnavailable()`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md),
  [`findAvailNonInform()`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md)
  and
  [`findAvailAffected()`](https://rmsharp.github.io/pedkindraw/reference/findAvailAffected.md).

### Converters

- New:
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  converts a kinship2 `pedigree` or `pedigreeList` and a Pedixplorer
  `Pedigree` to pedkindraw’s pedigree, twins table and layout hints.
  kinship2 and Pedixplorer are suggested, never required.
