# Package index

## The package

- [`pedkindraw`](https://rmsharp.github.io/pedkindraw/reference/pedkindraw-package.md)
  [`pedkindraw-package`](https://rmsharp.github.io/pedkindraw/reference/pedkindraw-package.md)
  : pedkindraw: Interactive Pedigree Drawings and Kinship

## Drawing

- [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  : Combine the mating-unit forest into visNetwork-ready diagram data
- [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  : Draw an interactive pedigree diagram from a mating layout
- [`savePedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/savePedigreeDiagram.md)
  : Save a pedigree diagram as a picture file
- [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  : Convert a pedigree data frame into visNetwork-ready diagram data

## Kinship and relatedness

- [`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
  : Generate a kinship matrix
- [`ibdMatrix()`](https://rmsharp.github.io/pedkindraw/reference/ibdMatrix.md)
  : Build an IBD matrix from pairs of ids and their values
- [`findUnrelated()`](https://rmsharp.github.io/pedkindraw/reference/findUnrelated.md)
  : Find a set of unrelated genotyped animals

## Pedigree structure

- [`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md)
  : Determine the generation number for each ID
- [`findPedigreeNumber()`](https://rmsharp.github.io/pedkindraw/reference/findPedigreeNumber.md)
  : Determine the pedigree number for each ID
- [`familyCheck()`](https://rmsharp.github.io/pedkindraw/reference/familyCheck.md)
  : Check family ids against the family trees the parents form
- [`getParents()`](https://rmsharp.github.io/pedkindraw/reference/getParents.md)
  : Get parents to corresponding animal IDs provided
- [`getOffspring()`](https://rmsharp.github.io/pedkindraw/reference/getOffspring.md)
  : Get offspring to corresponding animal IDs provided
- [`countOffspring()`](https://rmsharp.github.io/pedkindraw/reference/countOffspring.md)
  : Count each animal's offspring
- [`getMatings()`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)
  : List the matings of a pedigree
- [`getFounders()`](https://rmsharp.github.io/pedkindraw/reference/getFounders.md)
  : Get the founder ids from a pedigree
- [`isFounder()`](https://rmsharp.github.io/pedkindraw/reference/isFounder.md)
  : Identify the founders in a pedigree
- [`hasBothParents()`](https://rmsharp.github.io/pedkindraw/reference/hasBothParents.md)
  : Check whether an animal has both parents
- [`getIdsWithOneParent()`](https://rmsharp.github.io/pedkindraw/reference/getIdsWithOneParent.md)
  : Get ids of animals with only one parent

## Checking and repair

- [`checkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
  : Check a pedigree for problems
- [`checkTwinRelations()`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
  : Validate a twin/zygosity relations table
- [`recodePedigree()`](https://rmsharp.github.io/pedkindraw/reference/recodePedigree.md)
  : Rewrite other codes for unknown parents and sex into pedkindraw's
- [`addParents()`](https://rmsharp.github.io/pedkindraw/reference/addParents.md)
  : Add parents
- [`correctParentSex()`](https://rmsharp.github.io/pedkindraw/reference/correctParentSex.md)
  : Correct the sex of animals listed as a sire or dam
- [`addBackSecondParents()`](https://rmsharp.github.io/pedkindraw/reference/addBackSecondParents.md)
  : Add back second parents to a trimmed pedigree

## Trimming and shrinking

- [`trimPedigree()`](https://rmsharp.github.io/pedkindraw/reference/trimPedigree.md)
  : Trim a pedigree to a group's ancestors
- [`getProbandPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getProbandPedigree.md)
  : Reduce a pedigree to probands and their ancestors
- [`getDescendantPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getDescendantPedigree.md)
  : Reduce a pedigree to a group and its descendants
- [`getNearRelativePedigree()`](https://rmsharp.github.io/pedkindraw/reference/getNearRelativePedigree.md)
  : Reduce a pedigree to the near relatives of a group
- [`removeUnknownAnimals()`](https://rmsharp.github.io/pedkindraw/reference/removeUnknownAnimals.md)
  : Remove placeholder animals added for unknown parents
- [`removeUninformativeFounders()`](https://rmsharp.github.io/pedkindraw/reference/removeUninformativeFounders.md)
  : Remove uninformative founders
- [`removeAnimals()`](https://rmsharp.github.io/pedkindraw/reference/removeAnimals.md)
  : Remove listed animals from a pedigree
- [`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
  : Shrink a pedigree to fit within a bit-size budget
- [`bitSize()`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md)
  : Bit size of a pedigree
- [`findUnavailable()`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md)
  : Find the animals a pedigree can lose because they are unavailable
- [`findAvailNonInform()`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md)
  : Find genotyped animals that add no information to a pedigree
- [`findAvailAffected()`](https://rmsharp.github.io/pedkindraw/reference/findAvailAffected.md)
  : Remove the one animal of an affected status that shrinks a pedigree
  most

## Converting kinship2 and Pedixplorer objects

- [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  : Convert a kinship2 or Pedixplorer pedigree object to the package's
  data frames
