# pedkindraw: Interactive Pedigree Drawings and Kinship

Draws pedigrees as interactive 'visNetwork' graphs that can be
annotated, and computes kinship coefficients. It also trims and shrinks
pedigrees, checks pedigree records, finds sets of unrelated individuals,
and converts 'kinship2' 'pedigree' and 'Pedixplorer' 'Pedigree' objects.

## Drawing

[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
lays out a pedigree's animals and matings, with a twins table, a kinship
matrix and layout hints, and
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
draws the layout as an interactive graph.
[`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
makes a simpler drawing's nodes and edges.

## Kinship and relatedness

[`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
computes the kinship matrix,
[`ibdMatrix()`](https://rmsharp.github.io/pedkindraw/reference/ibdMatrix.md)
builds an IBD matrix from pairs of ids and their values, and
[`findUnrelated()`](https://rmsharp.github.io/pedkindraw/reference/findUnrelated.md)
finds a set of unrelated genotyped animals.

## Pedigree structure

[`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md),
[`findPedigreeNumber()`](https://rmsharp.github.io/pedkindraw/reference/findPedigreeNumber.md)
and
[`familyCheck()`](https://rmsharp.github.io/pedkindraw/reference/familyCheck.md)
number and check each animal's generation and family tree;
[`getParents()`](https://rmsharp.github.io/pedkindraw/reference/getParents.md),
[`getOffspring()`](https://rmsharp.github.io/pedkindraw/reference/getOffspring.md),
[`getFounders()`](https://rmsharp.github.io/pedkindraw/reference/getFounders.md),
[`isFounder()`](https://rmsharp.github.io/pedkindraw/reference/isFounder.md),
[`hasBothParents()`](https://rmsharp.github.io/pedkindraw/reference/hasBothParents.md)
and
[`getIdsWithOneParent()`](https://rmsharp.github.io/pedkindraw/reference/getIdsWithOneParent.md)
find sires and dams, offspring and founders.

## Checking and repair

[`checkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
lists each problem in a pedigree and
[`checkTwinRelations()`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
checks a twins table;
[`addParents()`](https://rmsharp.github.io/pedkindraw/reference/addParents.md),
[`correctParentSex()`](https://rmsharp.github.io/pedkindraw/reference/correctParentSex.md)
and
[`addBackSecondParents()`](https://rmsharp.github.io/pedkindraw/reference/addBackSecondParents.md)
repair a pedigree.

## Trimming and shrinking

[`trimPedigree()`](https://rmsharp.github.io/pedkindraw/reference/trimPedigree.md),
[`getProbandPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getProbandPedigree.md)
and
[`getDescendantPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getDescendantPedigree.md)
reduce a pedigree to the animals of interest and their relatives;
[`removeUnknownAnimals()`](https://rmsharp.github.io/pedkindraw/reference/removeUnknownAnimals.md)
and
[`removeUninformativeFounders()`](https://rmsharp.github.io/pedkindraw/reference/removeUninformativeFounders.md)
remove animals that add nothing;
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
shrinks a pedigree to a bit-size budget, in steps also exported:
[`bitSize()`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md),
[`findUnavailable()`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md),
[`findAvailNonInform()`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md)
and
[`findAvailAffected()`](https://rmsharp.github.io/pedkindraw/reference/findAvailAffected.md).

## Converting kinship2 and Pedixplorer objects

[`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
converts a kinship2 `pedigree` or `pedigreeList` and a Pedixplorer
`Pedigree` to the pedigree, twins table and layout hints the functions
above take.

## Getting started

[`vignette("pedkindraw", package = "pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/pedkindraw.md)
takes the 375-animal example pedigree that comes with the package from
its records to a drawing: checking it, its generations and family trees,
kinship, trimming it to one animal's ancestors, drawing them, shrinking
it and finding unrelated animals.
[`vignette("drawing", package = "pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/drawing.md)
shows what a drawing shows and how to change it: the symbols and the
legend, deceased animals, conditions, twins, animals drawn twice,
matings of relatives, the two edge styles, layout hints, kinship2 and
Pedixplorer objects, saving a drawing, clicks in a Shiny application and
a colony-size drawing. The README on the package's GitHub page draws a
twelve-animal pedigree; the example of
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
draws four.

## See also

Useful links:

- <https://github.com/rmsharp/pedkindraw>

- Report bugs at <https://github.com/rmsharp/pedkindraw/issues>

## Author

**Maintainer**: R. Mark Sharp <rmsharp@me.com>
([ORCID](https://orcid.org/0000-0002-6170-6942)) \[copyright holder\]

Authors:

- R. Mark Sharp <rmsharp@me.com>
  ([ORCID](https://orcid.org/0000-0002-6170-6942)) \[copyright holder\]
