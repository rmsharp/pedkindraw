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
* New: `makePedigreeMatingLayout()` and `makePedigreeDiagramData()` stop when
  a condition column (`affected`, `affected2`, ...) holds a number other than
  0 and 1, naming the column and the numbers. A measured trait (2.5, 0.3, 9)
  was drawn affected wherever it was not 0, with no message, as it still is in
  nprcgenekeepr. `TRUE`, `FALSE`, `NA`, 0 and 1 (kinship2's codes, which
  `asPedFrame()` writes) and text read as before.
* New: an animal whose affected status is unknown (`NA`) is filled grey
  (`#BEBEBE`, R's "grey", as Pedixplorer fills it), with one condition, or has
  that condition's section grey, with two to four, so it no longer looks
  unaffected; `makePedigreeDiagramData()` fills it grey too. The legend then
  has a grey row "Affected status unknown" after the condition rows, and the
  drawing is 45 px taller for it. nprcgenekeepr still fills an unknown status
  white. Text in a condition column that `as.logical()` cannot read (such as
  "yes", or "1" read as text) is unknown, so it is now drawn grey.
* New: `makePedigreeMatingLayout()` and `makePedigreeDiagramData()` take
  `maxNameChars`, the most characters of the `name` column written under an
  animal's id, 15 by default as before: a longer name is cut and ends in
  "...", and the hover text keeps it whole. A line break counts as one
  character. `maxNameChars = Inf` writes every name whole, as kinship2 and
  Pedixplorer write their labels; a long name can then run into the labels of
  the animals beside it. nprcgenekeepr cuts every name after 15 characters.
* New: `makePedigreeMatingLayout()` and `makePedigreeDiagramData()` take
  `conditionColors`, the colours of the affected conditions, by default the
  four drawn before (pink, orange, sky blue and bluish green). Each is a name
  R knows, such as "orange", or a code, such as "#E69F00", and is written as
  its "#RRGGBB" code, the colour R means by it: a browser reads most of R's
  colour names as no colour, and "grey" as a darker grey. The layout fills the
  symbols with them and keeps them in its `conditions` table, from which
  `drawPedigreeDiagram()` now paints the sections and the legend, so all three
  agree; before, colours edited in that table reached the legend but not the
  sections. A colour R does not know, a number, a transparent colour, white,
  the grey of an unknown status, a colour given twice, or fewer colours than
  conditions drawn stops, with a message naming them. nprcgenekeepr's colours
  are fixed.
* New: the legend's four lines (the dashed line joining two places of the
  same animal, and the three twin lines) have no arrowheads, as the drawing's
  own lines have none, and each line's label sits on white. nprcgenekeepr's
  legend draws an arrowhead at the right end of each line, which covers the
  end of "Same animal, again" in drawings 776 px wide (the package's website)
  and 700 px wide.
* New: layout hints, `makePedigreeMatingLayout(hints = )`: the left-to-right
  `order` of animals and, with `mate`, the side of a mating each mate is drawn
  on, in the form kinship2 and Pedixplorer give their hints.
* New: `makePedigreeMatingLayout()` returns the hints it used as `hints`, in
  the form its `hints` argument takes, so that
  `makePedigreeMatingLayout(ped, hints = layout$hints)` gives the same layout
  and an edit can start from the layout's own: `order` numbers each animal
  with a parent by the row the layout drew it from (a founder only where your
  order named it); `mate` holds your rows, then the layout's own row for each
  other mating (none for an animal with three or more matings, where a row
  can move its mates).

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
* New: `countOffspring()` counts each animal's offspring (the animals naming it
  as sire or dam, each once), and `getMatings()` lists each sire and dam with
  an offspring recorded with both, once, with the number of offspring they
  share: the matings a drawing draws.
* New: `findGeneration(alignMates = TRUE)` puts, where it can be done, the sire
  and dam of each offspring in the same generation, as kinship2's
  `kindepth(align = TRUE)` does; its help lists the steps. On the pedigrees
  its tests compare it equals kinship2's on most, and unlike kinship2's its
  answer does not depend on the order of the rows. The default is unchanged.

## Checking and repair

* `checkTwinRelations()`, `addParents()`, `addBackSecondParents()` and
  `correctParentSex()`.
* New: `checkPedigree()` lists each problem in a pedigree, one row per
  problem, and changes nothing.
* New: `recodePedigree()` rewrites other ways of writing an unknown parent and
  a sex into pedkindraw's codes. By default a parent written `"0"` or `"NA"`,
  or left empty, becomes `NA`, unless it is the id of a row. A sex written as
  a word (`"male"`, `"female"`, `"hermaphrodite"`, `"unknown"`) or its first
  letter, in any case, becomes `"M"`, `"F"`, `"H"` or `"U"`, as do the numbers
  1 and 2 (male and female) and 3 and 4 (unknown); a sex it does not know is
  left for `checkPedigree()` to report. kinship2's `sample.ped` and
  `testped1`, which write an unknown parent as 0 and sex as 1 and 2, then give
  kinship2's own kinship.

## Trimming and shrinking

* `trimPedigree()`, `getProbandPedigree()`, `getDescendantPedigree()`,
  `removeUnknownAnimals()`, `removeUninformativeFounders()` and
  `shrinkPedigree()`.
* New: the steps of `shrinkPedigree()`, exported under kinship2's names:
  `bitSize()`, `findUnavailable()`, `findAvailNonInform()` and
  `findAvailAffected()`.
* New: `shrinkPedigree()`, `findAvailNonInform()` and `findAvailAffected()`
  stop in the same way when `affected`, the argument or the column, holds a
  number other than 0 and 1, which they counted as affected; `bitSize()` and
  `findUnavailable()`, which do not use the status, do not read the column.
* New: `removeAnimals()` removes the listed animals and sets to `NA` each sire
  or dam entry that names one of them, so no animal is left with a parent that
  has no row; an offspring keeps its other parent. kinship2's
  `pedigree.trim()` stops when an offspring would keep only one parent, and
  Pedixplorer's `subset(del_parents = "one")` clears that parent too.
* New: `?shrinkPedigree`'s example draws the whole pedigree with the animals
  shrinking removed filled, from `idTrimmed`, as a condition column
  (`affected_removed`, which the legend calls "Affected (removed)").
  kinship2's `plot.pedigree.shrink()` draws only the animals kept.

## Converters

* New: `asPedFrame()` converts a kinship2 `pedigree` or `pedigreeList` and a
  Pedixplorer `Pedigree` to pedkindraw's pedigree, twins table and layout
  hints. kinship2 and Pedixplorer are suggested, never required.
