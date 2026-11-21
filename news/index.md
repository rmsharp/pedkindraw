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
- New: the “Select by id” box lists the animals only; nprcgenekeepr’s
  also lists the routing points (ids starting `__jog_`) a drawing adds
  to step a line around an animal: 196 of the 571 entries in the drawing
  vignette’s colony drawing.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  stops on an animal id that starts with `__jog_`, as for the other
  prefixes it keeps for its own nodes; nprcgenekeepr accepts one, and
  its drawing can then have two nodes with that id.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  and
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  stop when a condition column (`affected`, `affected2`, …) holds a
  number other than 0 and 1, naming the column and the numbers. A
  measured trait (2.5, 0.3, 9) was drawn affected wherever it was not 0,
  with no message, as it still is in nprcgenekeepr. `TRUE`, `FALSE`,
  `NA`, 0 and 1 (kinship2’s codes, which
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  writes) and text read as before.
- New: an animal whose affected status is unknown (`NA`) is filled grey
  (`#BEBEBE`, R’s “grey”, as Pedixplorer fills it), with one condition,
  or has that condition’s section grey, with two to four, so it no
  longer looks unaffected;
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  fills it grey too. The legend then has a grey row “Affected status
  unknown” after the condition rows, and the drawing is 45 px taller for
  it. nprcgenekeepr still fills an unknown status white. Text in a
  condition column that
  [`as.logical()`](https://rdrr.io/r/base/logical.html) cannot read
  (such as “yes”, or “1” read as text) is unknown, so it is now drawn
  grey.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  and
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  take `maxNameChars`, the most characters of the `name` column written
  under an animal’s id, 15 by default as before: a longer name is cut
  and ends in “…”, and the hover text keeps it whole. A line break
  counts as one character. `maxNameChars = Inf` writes every name whole,
  as kinship2 and Pedixplorer write their labels; a long name can then
  run into the labels of the animals beside it. nprcgenekeepr cuts every
  name after 15 characters.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  and
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  take `conditionColors`, the colours of the affected conditions, by
  default the four drawn before (pink, orange, sky blue and bluish
  green). Each is a name R knows, such as “orange”, or a code, such as
  “#E69F00”, and is written as its “#RRGGBB” code, the colour R means by
  it: a browser reads most of R’s colour names as no colour, and “grey”
  as a darker grey. The layout fills the symbols with them and keeps
  them in its `conditions` table, from which
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  now paints the sections and the legend, so all three agree; before,
  colours edited in that table reached the legend but not the sections.
  A colour R does not know, a number, a transparent colour, white, the
  grey of an unknown status, a colour given twice, or fewer colours than
  conditions drawn stops, with a message naming them. nprcgenekeepr’s
  colours are fixed.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  and
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  take `conditionThresholds`, cut-offs for measured traits. A condition
  column of numbers is drawn by its cut-off, a comparison and a number,
  such as
  `conditionThresholds = c(affected_glucose = ">= 126", affected_hb = "< 13")`:
  an animal whose number passes is affected, one whose number does not
  is unaffected, and one with no number is unknown (grey). The rule goes
  into the condition’s name, so the legend reads “Affected (glucose ≥
  126)” and the hover text “Affected (glucose ≥ 126): Yes (140)”. `>`
  and `<` decide as Pedixplorer’s `threshold` does. Without a cut-off a
  number other than 0 and 1 still stops, and the message now names
  `conditionThresholds`. nprcgenekeepr has no cut-off.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  reads a column `genotyped` (`TRUE`, `FALSE`, `NA`, 1, 0, or text such
  as “TRUE”): each genotyped animal’s symbol is drawn with its outline 4
  pixels wide, where every other symbol’s is 1, and its hover text says
  “Genotyped: Yes”, “No” or “Unknown”; any other value stops, naming the
  column.
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
  legend then has a row “Genotyped”, a square with the thick outline,
  and the drawing is 45 px taller. Pedixplorer marks an available animal
  with a green border; nprcgenekeepr has no such mark. Without the
  column every drawing is as before.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  reads a column `carrier` (`TRUE`, `FALSE`, `NA`, 1, 0, or text such as
  “TRUE”), for animals that have the genetic trait but are not expected
  to show the disease: each carrier’s symbol is drawn with a black dot
  at its centre, on top of its fill, its sections and the deceased
  slash, and its hover text says “Carrier: Yes”, “No” or “Unknown”; any
  other value stops, naming the column.
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
  legend then has a row “Carrier”, a circle with the dot, and the
  drawing is 45 px taller. A Pedixplorer object converted by
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  keeps its carriers in that column. Pedixplorer draws a smaller dot;
  nprcgenekeepr has no such mark. Without the column every drawing is as
  before.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  reads the columns `proband` and `consultand` (`TRUE`, `FALSE`, `NA`,
  1, 0, or text such as “TRUE”): the proband, an affected animal through
  whom the family came to attention, and the consultand, an animal for
  whom counselling or testing is sought. Each is drawn with a black
  arrow pointing at its symbol from the lower left, a proband’s with “P”
  beside its tail, and the hover text says “Proband:” and “Consultand:”
  “Yes”, “No” or “Unknown”; any other value stops, naming the column,
  and so does an animal marked both, naming it.
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
  legend then has a row “Proband” and a row “Consultand”, each the
  arrow, and the drawing is 45 px taller for each; the view takes in
  each arrow, so one at the left edge is not cut off. An id starting
  `__mark_` is now refused, as the other reserved prefixes are. A
  Pedixplorer object converted by
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  keeps both columns. Pedixplorer draws a smaller arrow at 45 degrees,
  reads `NA` as `FALSE` and warns of a proband who is not affected,
  which pedkindraw does not check; nprcgenekeepr has no such mark.
  Without the columns every drawing is as before.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  reads a column `evaluated` (`TRUE`, `FALSE`, `NA`, 1, 0, or text such
  as “TRUE”), for animals with a documented evaluation: each is drawn
  with a black “\*” to the right of the upper-right corner of its
  symbol, clear of the deceased slash and the lines, and its hover text
  says “Evaluated: Yes”, “No” or “Unknown”; any other value stops,
  naming the column.
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
  legend then has a row “Evaluated”, the “\*”, and the drawing is 45 px
  taller; the view takes in each “\*”, so one at the right edge is not
  cut off. An id starting `__eval_` is now refused, as the other
  reserved prefixes are. A Pedixplorer object converted by
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  keeps the column. Pedixplorer draws its “\*” just outside the corner,
  where it meets a deceased animal’s slash, reads `NA` as `FALSE` and
  has no legend row; nprcgenekeepr has no such mark. Without the column
  every drawing is as before.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  reads a column `fertility` in Pedixplorer’s words and values:
  “infertile” (also “steril”, `FALSE` or 0), “infertile_choice_na” for
  an animal with no offspring by choice or for an unknown reason (also
  “infertile_choice” or “infertile_na”), and “fertile” (also `TRUE` or
  1), in any case, `NA` where it is not recorded. An infertile animal is
  drawn with a black line down from its symbol and two bars, as in
  Pedixplorer, and one with no offspring by choice or for an unknown
  reason with a line and one bar; the animal’s id moves down below the
  bars. Its hover text says “Fertility: Fertile”, “Infertile”, “No
  offspring by choice or for an unknown reason” or “Unknown”; any other
  value stops, naming the column (Pedixplorer reads such a value as
  fertile). An animal with offspring is marked as recorded, since a
  colony animal can be sterilised after it has bred (Pedixplorer refuses
  it).
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
  legend then has a row “Infertile” and a row “No offspring”, each its
  mark, 45 px each; the view takes in each moved id, so one at the
  bottom edge is not cut off. An id starting `__fert_` is now refused,
  as the other reserved prefixes are. A Pedixplorer object converted by
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  keeps the column and is drawn with its marks. nprcgenekeepr has no
  such mark. Without the column every drawing is as before.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  reads a column `miscarriage` in Pedixplorer’s words and values: “SAB”
  for a spontaneous abortion (also “spontaneous” or “spontaneous
  abortion”), “TOP” for a termination of pregnancy (also “termination”,
  “terminated” or “termination of pregnancy”), “ECT” for an ectopic
  pregnancy (also “ectopic” or “ectopic pregnancy”), and `FALSE`, 0 or
  “no” for none, without spaces and in any case, `NA` where it is not
  recorded. A miscarriage is drawn as a triangle in place of its symbol,
  as in Pedixplorer, but 0.6 the size, so it is not the “Unknown” sex’s
  triangle; a termination’s or an ectopic pregnancy’s has a black line
  across it and an ectopic pregnancy’s “ECT” under it, as in
  Pedixplorer. Its id moves down into the row of the other ids, and it
  has no deceased slash, which would lie along a termination’s line. Its
  hover text says “Miscarriage: Spontaneous abortion (SAB)”,
  “Termination of pregnancy (TOP)”, “Ectopic pregnancy (ECT)”, “No” or
  “Unknown”; any other value stops, naming the column (Pedixplorer reads
  such a value as none, `TRUE` and 1 among them). A miscarriage that is
  a sire or dam, or that the `fertility` column marks infertile or with
  no offspring, stops, naming it, as Pedixplorer refuses both.
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
  legend then has a row “Miscarriage”, “Termination” and “Ectopic” for
  each kind drawn, its triangle, 45 px each; the view keeps the room a
  full-size symbol would have, so a long id at the edge is not cut off.
  An id starting `__misc_` is now refused, as the other reserved
  prefixes are. A Pedixplorer object converted by
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  keeps the column and is drawn with its marks. nprcgenekeepr has no
  such mark. Without the column every drawing is as before.
- New: `makePedigreeMatingLayout(symbolSize = )` sets the size of the
  animals’ symbols as a multiple of the size drawn before (1, the
  default), as kinship2’s and Pedixplorer’s `symbolsize` does: each
  animal and each repeat appearance is drawn 25 times it units across,
  rounded to a whole unit, and the mating points keep theirs. The layout
  works out its lines’ detours around the symbols from it, and an
  infertile animal’s and a miscarriage’s id moves down in proportion.
  Since the drawing zooms to fit, a larger symbol leaves less room
  between the symbols: measured at 500 px, from 2 the symbols reach the
  lines and the mating points, and at 3 the rectilinear layout warns
  that it could not clear every symbol. With symbols smaller than full
  size,
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  keeps the room a full-size symbol would have, so a long id at the edge
  is not cut off. An id starting `__size_` is now refused, as the other
  reserved prefixes are. Anything but one positive number stops.
  nprcgenekeepr has no such argument. At 1 every layout and drawing is
  as before.
- New: `makePedigreeMatingLayout(textSize = )` sets the size of the
  animals’ ids and names as a multiple of the 14 px written before (1,
  the default), as kinship2’s and Pedixplorer’s `cex` does: every node
  gets 14 times it as its `font.size`, rounded to a whole pixel. The
  marks’ own words (a proband’s “P”, an ectopic pregnancy’s “ECT”), the
  twins’ labels and the symbols keep their sizes, and the layout’s
  places and lines are the same at every text size. With text larger
  than before,
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  keeps room for the outermost labels, so a long id at the edge is not
  cut off (measured at 500 px: without that room the 10-character ids at
  the edges lost 8-10 px at 1.4 and 27-29 px at 2), and an infertile
  animal’s and a miscarriage’s moved id keeps its room below its mark.
  Since the drawing zooms to fit, larger text leaves less room between
  the ids: an id of 10 characters is 118 units wide at 1.4 and 165 at 2,
  and the animals in a row are 120 apart. An id starting `__text_` is
  now refused, as the other reserved prefixes are. Anything but one
  positive number stops. nprcgenekeepr has no such argument. At 1 every
  layout and drawing is as before.
- New: `makePedigreeMatingLayout(columnSpacing = , rowSpacing = )` set
  the distance between neighbouring animals in a row and between
  generations as multiples of the 120 and 150 units used before (1, the
  defaults), each rounded to a whole unit, so a drawing can be made
  wider or deeper, as kinship2’s distances follow the width and height
  of its page. Every place in the layout is the one before times the
  spacing, and the rectilinear lines’ steps and curves are worked out at
  the spacing given. Since the drawing zooms to fit, wider spacing
  leaves the symbols and text smaller beside the distances. Larger text
  needs wider columns: at `textSize = 2` an id of 10 characters is up to
  167 units wide, so neighbours’ ids run together at `columnSpacing = 1`
  and stand apart at 1.4. Measured at 500 px, columns at 0.5 lay long
  ids over their neighbours’ and rows at 0.5 run the lines from parents
  to their offspring through the parents’ ids. Anything but one positive
  number stops. nprcgenekeepr has no such arguments. At 1 every layout
  and drawing is as before.
- New: `makePedigreeMatingLayout(lineWidth = )` sets the width of the
  lines as a multiple of the widths drawn before (1, the default), as
  kinship2’s and Pedixplorer’s `lwd` does. Every line between animals,
  the mating line of related parents (4 times it), each symbol’s outline
  and the lines of each mark (the deceased slash, the proband’s arrow,
  the evaluated star, the infertile bars, the miscarriage line and the
  lines between a symbol’s sections) follow it, and the dashed lines’
  dashes and gaps grow with it, so a thick line stays dashed (kept at
  their old length, the DZ twins’ line would be solid at 5, like the MZ
  twins’). A genotyped animal’s outline is the line width plus 3 (4 at
  1, as before), so its fill keeps more of the symbol than 4 times the
  width would leave. The legend keeps its widths. The width is not
  rounded, and the drawing’s zoom is the same at every width, so thicker
  lines leave less room: measured at 500 px, at 3 the lines and outlines
  reach the ids in 4 of 16 drawings (2 at 1). Anything but one positive
  number stops. nprcgenekeepr has no such argument. At 1 every layout
  and drawing is as before.
- New: `makePedigreeMatingLayout(matings = )` draws two animals as mates
  although they have no offspring together, as kinship2’s relation code
  4 and Pedixplorer’s “Spouse” rows do: a data frame with the columns
  `sire` and `dam`, one row per mating (other columns are ignored, so
  [`getMatings()`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)’s
  result can be passed with rows added). The two are drawn side by side
  on one row, joined at a mating point with no line down, whose hover
  reads “0 offspring”; before, both were left out of the drawing when
  neither had parents or offspring (`isolatedIds`). An animal with other
  matings is drawn at each, as for two matings with offspring. A mate
  hint may place such a mating. A row naming an animal not in `ped` (as
  after trimming) is left out with a message; a pair named twice, in
  either column, is drawn once; any sexes are drawn as given. Anything
  but `NULL` or a data frame with those columns stops, as do `NA` and
  the same id as sire and dam. nprcgenekeepr has no such argument.
  Without it every layout is as before.
- New: the legend’s four lines (the dashed line joining two places of
  the same animal, and the three twin lines) have no arrowheads, as the
  drawing’s own lines have none, and each line’s label sits on white.
  nprcgenekeepr’s legend draws an arrowhead at the right end of each
  line, which covers the end of “Same animal, again” in drawings 776 px
  wide (the package’s website) and 700 px wide.
- New: layout hints, `makePedigreeMatingLayout(hints = )`: the
  left-to-right `order` of animals and, with `mate`, the side of a
  mating each mate is drawn on, in the form kinship2 and Pedixplorer
  give their hints.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  returns the hints it used as `hints`, in the form its `hints` argument
  takes, so that `makePedigreeMatingLayout(ped, hints = layout$hints)`
  gives the same layout and an edit can start from the layout’s own:
  `order` numbers each animal with a parent by the row the layout drew
  it from (a founder only where your order named it); `mate` holds your
  rows, then the layout’s own row for each other mating (none for an
  animal with three or more matings, where a row can move its mates).

### Kinship and relatedness

- [`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
  computes the kinship matrix, dense or sparse; identical twins get the
  kinship of an animal with itself.
- New:
  [`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)’s
  parent arguments are `sire` and `dam`, in the places of
  nprcgenekeepr’s `fatherId` and `motherId`, and it stops when a known
  sire’s or dam’s generation number (`pdepth`) is not below its
  offspring’s, naming the animal. Before, kinship2’s call form
  `kinship(id, dadid, momid, sex)` gave a wrong matrix with no error,
  taking the sex codes for generation numbers.
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md),
  unless given a `kinshipMatrix`, passes the pedigree’s `gen` column to
  [`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md),
  so it stops the same way. The help page and the README name the
  functions kinship2 and Pedixplorer also export.
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
- New: the pedigree argument is `ped` in
  [`getParents()`](https://rmsharp.github.io/pedkindraw/reference/getParents.md),
  [`getOffspring()`](https://rmsharp.github.io/pedkindraw/reference/getOffspring.md)
  and
  [`getIdsWithOneParent()`](https://rmsharp.github.io/pedkindraw/reference/getIdsWithOneParent.md),
  in the place of nprcgenekeepr’s `pedSourceDf` and `uPed`, and
  `addBackSecondParents(trimmedPed, ped)` calls the trimmed pedigree
  `trimmedPed`, in the place of `uPed`. A call that passes the pedigree
  by position is unchanged; one that names the old argument stops with
  “unused argument”.
- New: the pedigree is the first argument in
  `getProbandPedigree(ped, probands)`,
  `getDescendantPedigree(ped, probands)`,
  `trimPedigree(ped, probands, ...)` and `hasBothParents(ped, id)`, as
  in the other functions that take one; nprcgenekeepr takes the ids
  first. A call that names both arguments is unchanged; one that passes
  them in nprcgenekeepr’s order stops with “\$ operator is invalid for
  atomic vectors”.
- New:
  [`familyCheck()`](https://rmsharp.github.io/pedkindraw/reference/familyCheck.md)
  checks family ids against the family trees the sires and dams form.
- New:
  [`countOffspring()`](https://rmsharp.github.io/pedkindraw/reference/countOffspring.md)
  counts each animal’s offspring (the animals naming it as sire or dam,
  each once), and
  [`getMatings()`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)
  lists each sire and dam with an offspring recorded with both, once,
  with the number of offspring they share: the matings a drawing draws.
- New: `findGeneration(alignMates = TRUE)` puts, where it can be done,
  the sire and dam of each offspring in the same generation, as
  kinship2’s `kindepth(align = TRUE)` does; its help lists the steps. On
  the pedigrees its tests compare it equals kinship2’s on most, and
  unlike kinship2’s its answer does not depend on the order of the rows.
  The default is unchanged.
- New: `getMatings(matings = )` lists declared matings too. Given the
  table `makePedigreeMatingLayout(matings = )` takes, it adds each pair
  declared mated with no offspring together after the matings built from
  offspring, in the table’s order, with `offspring` 0, so its rows are
  the matings the drawing draws, in its order. In both functions a row
  naming a pair that has offspring together is set aside without a
  message, so
  [`getMatings()`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)’s
  result can be passed back; before, the layout said it left out such a
  row when one of the pair had no row of its own, and stopped on an
  animal recorded as both sire and dam of one offspring. Without
  `matings`, the result is as before.

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
- New:
  [`recodePedigree()`](https://rmsharp.github.io/pedkindraw/reference/recodePedigree.md)
  rewrites other ways of writing an unknown parent and a sex into
  pedkindraw’s codes. By default a parent written `"0"` or `"NA"`, or
  left empty, becomes `NA`, unless it is the id of a row. A sex written
  as a word (`"male"`, `"female"`, `"hermaphrodite"`, `"unknown"`) or
  its first letter, in any case, becomes `"M"`, `"F"`, `"H"` or `"U"`,
  as do the numbers 1 and 2 (male and female) and 3 and 4 (unknown); a
  sex it does not know is left for
  [`checkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
  to report. kinship2’s `sample.ped` and `testped1`, which write an
  unknown parent as 0 and sex as 1 and 2, then give kinship2’s own
  kinship.

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
- New:
  [`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md),
  [`findAvailNonInform()`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md)
  and
  [`findAvailAffected()`](https://rmsharp.github.io/pedkindraw/reference/findAvailAffected.md)
  stop in the same way when `affected`, the argument or the column,
  holds a number other than 0 and 1, which they counted as affected;
  [`bitSize()`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md)
  and
  [`findUnavailable()`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md),
  which do not use the status, do not read the column.
- New:
  [`removeAnimals()`](https://rmsharp.github.io/pedkindraw/reference/removeAnimals.md)
  removes the listed animals and sets to `NA` each sire or dam entry
  that names one of them, so no animal is left with a parent that has no
  row; an offspring keeps its other parent. kinship2’s `pedigree.trim()`
  stops when an offspring would keep only one parent, and Pedixplorer’s
  `subset(del_parents = "one")` clears that parent too.
- New: `getNearRelativePedigree(ped, probands, maxDist)` keeps the
  animals within a distance of the probands, read from kinship (1 the
  proband, 2 a parent, offspring or full sibling, 3 a grandparent, half
  sibling, uncle or aunt, 4 a first cousin), and each parent that joins
  their families, as Pedixplorer’s `useful_inds(max_dist = )` does; a
  parent left out becomes `NA` in its offspring’s row.
- New:
  [`?shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)’s
  example draws the whole pedigree with the animals shrinking removed
  filled, from `idTrimmed`, as a condition column (`affected_removed`,
  which the legend calls “Affected (removed)”). kinship2’s
  `plot.pedigree.shrink()` draws only the animals kept.

### Converters

- New:
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  converts a kinship2 `pedigree` or `pedigreeList` and a Pedixplorer
  `Pedigree` to pedkindraw’s pedigree, twins table and layout hints.
  kinship2 and Pedixplorer are suggested, never required.
- New:
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  returns a fourth element, `matings`: the pairs a kinship2 object’s
  relation code 4 or a Pedixplorer object’s “Spouse” rows declare mated,
  as the data frame of `sire` and `dam` that
  `makePedigreeMatingLayout(matings = )` and `getMatings(matings = )`
  take, or `NULL` when the object has none. Each row is kept as the
  object holds it, a pair with offspring together or named twice
  included; the male is the sire, else the female is the dam, else the
  two are in the object’s order. A mate hint row naming such a pair is
  kept. Draw with
  `makePedigreeMatingLayout(x$ped, hints = x$hints, matings = x$matings)`.
  Before, spouse pairs were left out, and so were mate hint rows naming
  them, with a message.
