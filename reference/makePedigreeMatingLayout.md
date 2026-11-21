# Combine the mating-unit forest into visNetwork-ready diagram data

Builds a kinship2-style pedigree layout in which each mating (a sire and
dam pair) is drawn as a union node between the parents and their
offspring. Returns the same `list(nodes, edges)` shape that
[`makePedigreeDiagramData`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
returns, plus a lookup table that maps each duplicate node id to the
real individual it stands for.
[`makePedigreeDiagramData`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
itself is unaffected; this is a separate function.

## Usage

``` r
makePedigreeMatingLayout(
  ped,
  edgeStyle = c("rectilinear", "direct"),
  twinRelations = NULL,
  kinshipMatrix = NULL,
  hints = NULL,
  maxNameChars = 15,
  conditionColors = c("#CC79A7", "#E69F00", "#56B4E9", "#009E73"),
  conditionThresholds = NULL,
  symbolSize = 1,
  textSize = 1,
  columnSpacing = 1,
  rowSpacing = 1,
  lineWidth = 1
)
```

## Arguments

- ped:

  data frame with `id`, `sire`, `dam`, `sex`, and `gen` columns, same
  contract as
  [`makePedigreeDiagramData`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md).
  An optional `status` column marks deceased animals: see the `deceased`
  column of the returned `nodes`. Every column whose name starts
  `affected` is an affected condition, in the order the data frame holds
  them, the first four drawn (see `conditions` in the return value). A
  lone one fills the symbol, in the first of `conditionColors` (pink by
  default) where the animal is affected and grey where its status is
  unknown (`NA`); two or more split it into sections, one colour each.
  ([`makePedigreeDiagramData`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  reads the column `affected` alone.) A condition drawn reads as
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)'s
  `affected` does: a number other than 0 and 1 stops, before any animal
  is left out. An optional `genotyped` column marks the genotyped
  animals (what kinship2 and Pedixplorer call available): `TRUE`,
  `FALSE` or `NA` (not recorded) for each animal, or 1 and 0, or text
  [`as.logical()`](https://rdrr.io/r/base/logical.html) reads (`"TRUE"`,
  `"false"`, `"T"`). A genotyped animal's symbol is drawn with its
  outline 4 pixels wide, every other symbol's 1 (see `borderWidth` in
  the returned `nodes`), and its hover text says “Genotyped: Yes”, “No”
  or “Unknown”; any other value stops, naming the column, before any
  animal is left out. An optional `carrier` column marks the carriers,
  animals that have the genetic trait but are not expected to show the
  disease, in the same values: a carrier's symbol is drawn with a black
  dot at its centre (see `carrier` in the returned `nodes`), and its
  hover text says “Carrier: Yes”, “No” or “Unknown”, after the genotyped
  line. Optional `proband` and `consultand` columns, in the same values,
  mark the proband (an affected animal through whom the family came to
  attention) and the consultand (an animal for whom counselling or
  testing is sought): each is drawn with a black arrow pointing at its
  symbol from the lower left, a proband's with “P” beside it (see
  `proband` and `consultand` in the returned `nodes`), and the hover
  text says “Proband:” and “Consultand:” “Yes”, “No” or “Unknown”, one
  line for each column, after the carrier line. An animal marked both
  stops, naming it, before any animal is left out. An optional
  `evaluated` column, in the same values, marks the animals with a
  documented evaluation: each is drawn with a black `*` to the right of
  the upper-right corner of its symbol (see `evaluated` in the returned
  `nodes`), and its hover text says “Evaluated: Yes”, “No” or “Unknown”,
  after the consultand line. An optional `fertility` column, in
  Pedixplorer's words and values, marks the animals that are infertile
  (`"infertile"`, also `"steril"`, `FALSE` or 0) and those with no
  offspring by choice or for an unknown reason (`"infertile_choice_na"`,
  also `"infertile_choice"` or `"infertile_na"`); `"fertile"`, `TRUE` or
  1 marks nothing, `NA` is not recorded, text is read in any case, and
  any other value stops, naming the column, before any animal is left
  out. An infertile animal is drawn with a line down from its symbol and
  two bars, one with no offspring by choice or for an unknown reason
  with a line and one bar, its id moved below them (see `fertility` in
  the returned `nodes`); an animal with offspring is marked as recorded.
  The hover text says “Fertility: Fertile”, “Infertile”, “No offspring
  by choice or for an unknown reason” or “Unknown”, after the evaluated
  line. An optional `miscarriage` column, in Pedixplorer's words and
  values, marks the miscarriages: `"SAB"`, a spontaneous abortion (also
  `"spontaneous"` or `"spontaneous abortion"`), `"TOP"`, a termination
  of pregnancy (also `"termination"`, `"terminated"` or
  `"termination of pregnancy"`), and `"ECT"`, an ectopic pregnancy (also
  `"ectopic"` or `"ectopic pregnancy"`); `FALSE`, 0 or `"no"` marks
  nothing, `NA` is not recorded, text is read without its spaces and in
  any case, and any other value stops, naming the column, before any
  animal is left out. A miscarriage is drawn as a small triangle in
  place of its symbol, a termination's or an ectopic pregnancy's with a
  line across it, an ectopic pregnancy's also with “ECT” under it (see
  `miscarriage` in the returned `nodes`). A miscarriage that is a sire
  or dam, or that the `fertility` column marks infertile or with no
  offspring, stops, naming it. The hover text says “Miscarriage:
  Spontaneous abortion (SAB)”, “Termination of pregnancy (TOP)”,
  “Ectopic pregnancy (ECT)”, “No” or “Unknown”, after the fertility
  line.

- edgeStyle:

  one of `"rectilinear"` (default), which routes mate-line and
  sibship-bar edges through invisible waypoint nodes so they render as a
  strict right angle, kinship2-style, or `"direct"`, which draws a
  straight edge from each parent to their mating unit and from each
  mating unit to each child.

- twinRelations:

  optional data.frame with columns `id1`, `id2`, `code` (see
  [`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)).
  Not validated here; validate with
  [`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
  first. `NULL` (default) adds no connector edges. A connector always
  targets the two individuals' real node ids and always renders as a
  direct edge regardless of `edgeStyle`.

- kinshipMatrix:

  optional precomputed kinship matrix (a base `matrix` or a `Matrix`)
  with row AND column names set to individual ids. When supplied, it
  replaces this function's internal
  [`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
  call as the sole source of the consanguineous-mating-unit flags
  (`kinshipMatrix[sire, dam] > 0`): `twinRelations` then drives twin
  connector edges only, so a caller wanting twin-corrected consanguinity
  must bake it into the matrix (e.g.
  `kinship(..., twinRelations = ...)`). A sire/dam id absent from the
  matrix's dimnames leaves that unit at the safe `FALSE` default,
  exactly as a dangling parent does on the default path. `NULL`
  (default) computes
  `kinship(ped$id, ped$sire, ped$dam, ped$gen, twinRelations = twinRelations)`.

- hints:

  `NULL` (default: the layout's own order) or a list with the elements
  `order` and `mate`, either one or both. `order` is a numeric vector
  named by ids in `ped`, as kinship2's and Pedixplorer's layout hints
  give it. Only the order of the numbers matters. Siblings, separate
  families and founder couples are drawn left to right in increasing
  order of their numbers; equal numbers keep the order of the rows of
  `ped`, and an animal the order does not name keeps its row's place. A
  founder couple is placed by its female's number (a male whose mate is
  not named, by his own), as kinship2 and Pedixplorer place them. In a
  family whose founders the order names, the layout's own reordering of
  founder lines (which shortens the lines joining an animal drawn twice)
  is not done. An order may put a sibling between twins; the twin line
  then crosses it. `mate` is a data frame with one row per mating to
  place and the columns `left`, `right` and `anchor`: `left` and `right`
  are a sire and a dam with offspring together in `ped`, in either
  column, and `left` is drawn left of `right` at their mating; `anchor`
  (`"left"`, `"right"` or `"either"`) names the partner whose own place
  the offspring are drawn under, the other partner then drawn beside it
  as a repeat node when it has parents of its own, and `"either"` keeps
  the layout's own choice. As kinship2 draws its `spouse` hint, the
  offspring of an animal's several matings follow its mates' sides,
  mates hinted to one side are drawn left to right in the order of the
  rows, and mates not hinted are drawn nearest the animal. A hint can
  change where the layout draws matings it does not name.
  [`list()`](https://rdrr.io/r/base/list.html), and `order` or `mate`
  `NULL` or empty, give the layout of no hint. Stops on an element other
  than `order` and `mate`; on an order that is not numeric, a number
  without a name, a name given twice or not in `ped`, and `NA`; and on a
  `mate` that is not a data frame or lacks a column, `NA`, the same id
  as `left` and `right`, an id not in `ped` (a sire or dam without a row
  of its own), a pair with no offspring together or named twice, an
  `anchor` other than those three, and an anchor on the partner of an
  earlier generation than its mate (the layout draws a mating on the row
  of its later partner). The returned `hints` are the hints the layout
  used, in this form: passed back, they give the same layout, so an edit
  can start from the layout's own order (see the example).

- maxNameChars:

  the most characters of an animal's `name` written in `label` under its
  id, on its node and on each of its repeat nodes, 15 by default: a
  longer name is cut there and ends in `"..."`, while `title` keeps it
  whole. A line break counts as one character. `Inf` writes every name
  whole, as kinship2 and Pedixplorer write their labels; a long name can
  then run into the labels of the animals beside it. It changes nothing
  but the labels. Stops unless it is one whole number of 1 or more, or
  `Inf`.

- conditionColors:

  the colours of the affected conditions, in the order they are drawn: 1
  to 4 colours, at least one for each condition drawn, each a name R
  knows (such as `"orange"` or `"steelblue3"`) or a code (such as
  `"#E69F00"`). Each is written as its `"#RRGGBB"` code, the colour R
  means by it: a browser reads most of R's names as no colour, and
  `"grey"`, `"gray"`, `"green"`, `"maroon"` and `"purple"` as other
  colours. The default is the four colours drawn before this argument:
  pink, orange, sky blue and bluish green, the last three Okabe and
  Ito's colour-blind-safe ones. They fill the symbols here and go into
  the returned `conditions` table, from which
  [`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  paints the sections and the legend, so all three agree. With no
  condition column nothing is coloured, and the drawing's one “Affected”
  legend row keeps the default pink. Stops on anything but 1 to 4
  colours as text, on `NA`, on a colour R does not know, on a number (it
  picks from R's palette, which can be changed), on a transparent
  colour, on white and on the grey `"#BEBEBE"` (they mark an unaffected
  animal and an unknown status), on a colour given twice, and on fewer
  colours than conditions drawn.

- conditionThresholds:

  `NULL` (the default), or the cut-offs of measured traits: a character
  vector named by condition columns, each a comparison, `>`, `>=`, `<`
  or `<=`, and a number, such as
  `c(affected_glucose = ">= 126", affected_hb = "< 13")`. An animal
  whose number passes its column's cut-off is drawn affected, one whose
  number does not is drawn unaffected, and one with no number (`NA`) is
  drawn as unknown. The rule goes into the condition's label, so the
  legend and the tooltip state it, `>=` and `<=` written as the signs
  for at least and at most: “Affected (glucose \>= 126)” with the sign;
  the tooltip also gives the animal's number, “Yes (140)”. A column
  without a cut-off is read as before, and a number in it other than 0
  and 1 stops. Stops on anything but a named character vector, on a
  cut-off it cannot read, on a name that is not a condition column of
  `ped`, and on a column with a cut-off that does not hold numbers.

- symbolSize:

  the size of the animals' symbols, as a multiple of the size drawn
  before this argument (1, the default), as kinship2's and Pedixplorer's
  `symbolsize` is: each animal's node and each of its repeat nodes gets
  25 times it in `size`, rounded to a whole unit and at least 1, and the
  mating points keep 6. The layout works out the lines' detours around
  the symbols from it, and
  [`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  moves an infertile animal's and a miscarriage's id down in proportion.
  The drawing zooms to fit, so a larger symbol leaves less room between
  the symbols rather than making a larger drawing: measured at 500
  pixels, from 2 the symbols reach the lines and the mating points and
  long ids reach the marks beside them, and at 3 the rectilinear layout
  warns that it could not clear every symbol. Stops unless it is one
  positive number.

- textSize:

  the size of the animals' ids and names, as a multiple of the 14 pixels
  written before this argument (1, the default), as kinship2's and
  Pedixplorer's `cex` is: every node gets 14 times it in `font.size`,
  rounded to a whole pixel and at least 1, unless that is 14. The marks'
  own words (a proband's “P”, an ectopic pregnancy's “ECT”) and the
  twins' labels keep their sizes, and so do the symbols (`symbolSize`
  sets theirs; kinship2's and Pedixplorer's grow with `cex`). The
  layout's places and lines are the same at every text size, and
  [`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  keeps larger labels inside the drawing and an infertile animal's and a
  miscarriage's moved id clear of the drawing's bottom edge. The drawing
  zooms to fit, so larger text leaves less room between the ids: an id
  of 10 characters is 118 units wide at 1.4 and 165 at 2, and the
  animals in a row are 120 apart at `columnSpacing` 1, so larger text
  needs wider columns (168 apart at 1.4). Stops unless it is one
  positive number.

- columnSpacing:

  the distance between neighbouring animals in a row, as a multiple of
  the 120 units used before this argument (1, the default): the columns
  are 120 times it apart, rounded to a whole unit and at least 1. With
  `rowSpacing` it sets the drawing's proportions, as the width and
  height of kinship2's page set its distances; the drawing zooms to fit,
  so wider columns leave the symbols and text smaller beside the
  distances rather than making a larger drawing. The layout works the
  lines' detours out at the spacing given. Larger text needs wider
  columns: at `textSize` 2 an id of 10 characters is up to 167 units
  wide, and at 1.4 the columns are 168 apart. Measured at 500 pixels, at
  0.5 long ids run over their neighbours'. Stops unless it is one
  positive number.

- rowSpacing:

  the distance between generations, as a multiple of the 150 units used
  before this argument (1, the default): the rows are 150 times it
  apart, rounded to a whole unit and at least 1. In the rectilinear
  style a step around an animal keeps its depth, 1 unit below the
  symbols, or 0.15 of the gap to the nearest row of lines when that is
  more. Measured at 500 pixels, at 0.5 the lines from parents to their
  offspring cross the parents' ids. Stops unless it is one positive
  number.

- lineWidth:

  the width of the lines, as a multiple of the widths drawn before this
  argument (1, the default), as kinship2's and Pedixplorer's `lwd` is:
  every line between animals is `lineWidth` units wide (1 before) and
  the mating line of related parents 4 times it; the dashed lines'
  dashes and gaps grow with it, so a thick line keeps its gaps (vis.js
  draws each dash with round ends: kept at today's length, the DZ twins'
  line is solid at 5, like the MZ twins'); each symbol's outline is
  `lineWidth` pixels and a genotyped animal's `lineWidth + 3` (1 and 4
  before), so its fill keeps more of the symbol than 4 times the width
  would leave; and
  [`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  strokes each mark's lines (the deceased slash, the proband's arrow,
  the evaluated star, the infertile bars, the miscarriage line and the
  lines between the sections) that many times as wide. The legend keeps
  its widths. Not rounded: 0.5 and 1.5 draw thinner and thicker lines
  than 1. The drawing zooms to fit, and the zoom is the same at every
  width, so thicker lines leave less room between them: measured at 500
  pixels, at 3 the lines and outlines reach the ids in 4 of 16 drawings
  (2 at 1). Stops unless it is one positive number.

## Value

A list with `nodes` (`id`, `label`, `shape`, `title`, `size`,
`color.background`, `deceased` (logical, never `NA`: `TRUE` for the node
of an animal whose `status` reads `DECEASED`, and for each of its
repeat-appearance nodes, `FALSE` for every other node and for all of
them when `ped` has no `status` column), `x`, `y`; `color.border` is
added under `edgeStyle = "rectilinear"`; `affectedSections` is added
when there are two or more conditions: a character string with one
character per condition, `"1"` where the animal is affected, `"0"` where
it is unaffected and `"?"` where it is unknown (the drawing fills that
section grey), the same for a repeat-appearance node as for its animal,
`""` for a node that is not an animal, never `NA`; with two or more
conditions the animals' `color.background` is white, the sections
carrying the color; `borderWidth` is added when `ped` has a `genotyped`
column: 4 for the node of a genotyped animal and each of its
repeat-appearance nodes, 1 for every other node, the width of the
symbol's outline; `carrier` is added when `ped` has a `carrier` column:
`TRUE` for the node of a carrier and each of its repeat-appearance
nodes, `FALSE` for every other node, never `NA`; `proband`, `consultand`
and `evaluated` likewise, each added when `ped` has that column;
`fertility` is added when `ped` has a `fertility` column: `"infertile"`
or `"infertile_choice_na"` for the node of such an animal and each of
its repeat-appearance nodes, `""` for every other node, never `NA`;
`miscarriage` is added when `ped` has a `miscarriage` column: `"SAB"`,
`"TOP"` or `"ECT"` for the node of such an animal and each of its
repeat-appearance nodes, `""` for every other node, never `NA`;
`font.size` is added when `textSize` gives other than 14 pixels: that
size, for every node; at a `lineWidth` other than 1, `lineWidth` is
added, that width for every node, and `borderWidth` is on every node,
`lineWidth` for an ordinary one and `lineWidth + 3` for a genotyped
one), `edges` (`from`, `to`, `dashes`, `smooth.enabled`, `smooth.type`,
`smooth.roundness`, `color`, `width`; the `color` and `width` columns
are always present once any mating unit exists: a consanguineous mating
unit's (`kinship(sire, dam) > 0`) 2 spouse-to-union edges get
`"#D55E00"`/`4`, an Okabe-Ito colorblind-safe vermillion in kinship2's
doubled/thickened mate-line convention, and every other edge gets `NA`
(at a `lineWidth` other than 1, that width, the consanguineous edges' 4
times it, and each dash pattern times it, `TRUE` as vis.js's 5 and 5);
`label` is added when `twinRelations` is supplied), and
`duplicateToReal` (a named character vector, duplicate node id -\> real
individual id). Under `edgeStyle = "rectilinear"`, an already-set edge
`color` (e.g. the twin connector's or the consanguinity marker's) is
preserved when the edge is kept as-is; a marked mate edge that gets
replaced by a right-angle projection currently falls back to the generic
routing color and width. Also `isolatedIds`, a character vector of ids
suppressed from `nodes`/`edges` because they have no known parent, are
never a parent, and are not connected by `twinRelations`; it is
`character(0)` when nothing was suppressed. When every individual in
`ped` is isolated, `nodes`/`edges` are both 0-row and `duplicateToReal`
is empty. Also `conditions`, a data frame with one row per drawn
condition (`column`, `label` such as “Affected” or “Affected
(diabetes)”, and its `color`, from `conditionColors` as a `"#RRGGBB"`
code), 0-row when `ped` has no such column, and `conditionsNotDrawn`,
the names of any such columns past the fourth. Last, `hints`, the hints
the layout used, in the form the argument `hints` takes, so that passing
them back gives the same layout: `order` numbers each animal drawn that
has a parent by its row in the rows the layout drew from (an order hint
applied, the animals left out not counted), and a founder only where an
order hint named it, since naming a founder turns off the layout's own
ordering of founder lines; `mate` holds the rows of a mate hint as
given, then a row for each other mating whose sire and dam both have
rows in `ped`, `left` and `right` as drawn and `anchor` the partner the
offspring hang under, except the matings of an animal that anchors three
or more matings or that the given rows place, where a row can change how
far its mates are drawn. With every animal left out, `order` has no
numbers and `mate` no rows.

## Details

Mating-unit nodes render as a small, unlabeled dot with an
offspring-count tooltip, visually distinct from the 5 sex-coded shapes.
An individual who has to appear more than once in the layout gets
duplicate nodes. A duplicate node keeps the real individual's own shape,
label and tooltip content (plus a cue that it is a duplicate), so it
reads as that individual, and is connected to it by a dashed edge.

In the default `"rectilinear"` edge style, mate-line and sibship-bar
edges are routed through invisible waypoint nodes so they render as
strict right angles, as kinship2 draws them. In the `"direct"` edge
style, edges are straight segments from each parent to the mating unit
and from the mating unit to each child.

A simple two-real-parent mating unit (each parent has exactly one mate
and both have unambiguous `"M"`/`"F"` sex codes) is drawn with the male
parent to the left of the female parent. The final horizontal positions
come from a joint quadratic program that preserves each row's
provisional left-to-right order, so this rule carries into the rendered
layout. It cannot be turned off, unless a mate hint says otherwise (see
`hints`).

## Examples

``` r
## Seven animals: C and D are full siblings, and so are F and G, D's
## offspring
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E"),
  sex = c("M", "F", "F", "M", "F", "M", "F"),
  stringsAsFactors = FALSE
)
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
layout <- makePedigreeMatingLayout(ped)

## The hints the layout used: passed back, the same layout
layout$hints
#> $order
#> C D F G 
#> 3 4 6 7 
#> 
#> $mate
#>   left right anchor
#> 1    A     B   left
#> 2    D     E   left
#> 
identical(makePedigreeMatingLayout(ped, hints = layout$hints), layout)
#> [1] TRUE

## Edited: G drawn left of F
hints <- layout$hints
hints$order[c("F", "G")] <- hints$order[c("G", "F")]
swapped <- makePedigreeMatingLayout(ped, hints = hints)
```
