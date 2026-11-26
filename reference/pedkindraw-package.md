# pedkindraw: Interactive Pedigree Drawings and Kinship

Draws pedigrees as interactive 'visNetwork' graphs that can be
annotated, and computes kinship coefficients. It also trims and shrinks
pedigrees, checks pedigree records, finds sets of unrelated individuals,
and converts 'kinship2' 'pedigree' and 'Pedixplorer' 'Pedigree' objects.
Its X-chromosome kinship, bit size, pedigree shrinking, family-id check
and IBD matrix follow the methods of Sinnwell, Therneau and Schaid
(2014) [doi:10.1159/000363105](https://doi.org/10.1159/000363105) .

## Drawing

[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
lays out a pedigree's animals and matings, with a twins table, a kinship
matrix and layout hints, and
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
draws the layout as an interactive graph.
[`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
makes a simpler drawing's nodes and edges.
[`savePedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/savePedigreeDiagram.md)
saves a drawing as an SVG, a PDF or a PNG file.
[`runPedigreeApp()`](https://rmsharp.github.io/pedkindraw/reference/runPedigreeApp.md)
starts an app that opens a pedigree file and draws it, with no code.

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
find sires and dams, offspring and founders;
[`countOffspring()`](https://rmsharp.github.io/pedkindraw/reference/countOffspring.md)
counts each animal's offspring and
[`getMatings()`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)
lists the matings, each sire and dam with an offspring together or
declared mated.

## Checking and repair

[`checkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
lists each problem in a pedigree and
[`checkTwinRelations()`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
checks a twins table;
[`recodePedigree()`](https://rmsharp.github.io/pedkindraw/reference/recodePedigree.md)
rewrites other ways of writing an unknown parent or a sex into this
package's codes;
[`addParents()`](https://rmsharp.github.io/pedkindraw/reference/addParents.md),
[`correctParentSex()`](https://rmsharp.github.io/pedkindraw/reference/correctParentSex.md)
and
[`addBackSecondParents()`](https://rmsharp.github.io/pedkindraw/reference/addBackSecondParents.md)
repair a pedigree.

## Trimming and shrinking

[`trimPedigree()`](https://rmsharp.github.io/pedkindraw/reference/trimPedigree.md),
[`getProbandPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getProbandPedigree.md),
[`getDescendantPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getDescendantPedigree.md)
and
[`getNearRelativePedigree()`](https://rmsharp.github.io/pedkindraw/reference/getNearRelativePedigree.md)
reduce a pedigree to the animals of interest and their relatives;
[`removeUnknownAnimals()`](https://rmsharp.github.io/pedkindraw/reference/removeUnknownAnimals.md)
and
[`removeUninformativeFounders()`](https://rmsharp.github.io/pedkindraw/reference/removeUninformativeFounders.md)
remove animals that add nothing, and
[`removeAnimals()`](https://rmsharp.github.io/pedkindraw/reference/removeAnimals.md)
removes the animals listed, clearing their offspring's links to them;
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
`Pedigree` to the pedigree, twins table, layout hints and declared
matings the functions above take.

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
a colony-size drawing.
[`vignette("speed", package = "pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/speed.md)
gives the seconds each function took on one machine, by the number of
animals from 300 to 100,000, beside the kinship2 and Pedixplorer
functions that do the same, and how large a drawing can be drawn and
read. The README on the package's GitHub page draws a twelve-animal
pedigree; the example of
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
draws four. To draw a pedigree file with no code,
[`runPedigreeApp()`](https://rmsharp.github.io/pedkindraw/reference/runPedigreeApp.md)
opens it in an app in the web browser, which also saves the drawing and
the animals.

## See also

Useful links:

- <https://rmsharp.github.io/pedkindraw/>

- <https://github.com/rmsharp/pedkindraw>

- Report bugs at <https://github.com/rmsharp/pedkindraw/issues>

## Author

**Maintainer**: R. Mark Sharp <rmsharp@me.com>
([ORCID](https://orcid.org/0000-0002-6170-6942)) \[copyright holder\]

Authors:

- R. Mark Sharp <rmsharp@me.com>
  ([ORCID](https://orcid.org/0000-0002-6170-6942)) \[copyright holder\]
