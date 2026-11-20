# Draw an interactive pedigree diagram from a mating layout

Returns an interactive pedigree diagram, as a `visNetwork` widget, for a
layout made by
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md).
The diagram has the sex symbols at the layout's fixed positions, the
legend (the five sex symbols, one row per affected condition or a single
“Affected” row, a grey “Affected status unknown” row when an animal's
status is unknown, a “Genotyped” row when an animal is genotyped, a
“Carrier” row when an animal is a carrier, “Proband” and “Consultand”
rows when an animal is one, an “Evaluated” row when an animal is
evaluated, “Infertile” and “No offspring” rows when an animal is one,
“Deceased”, and the dashed repeat-appearance and twin lines), each
multi-condition symbol split into its colored sections, the slash
through each deceased animal's symbol, a canvas that grows with the
number of legend rows, the **Export Diagram (PNG)** button, a “Select by
id” box that lists the animals, and the highlight on hover. The sections
and the slash are painted by a drawing script inside the widget, so they
appear wherever the widget is shown: in the RStudio viewer, in an R
Markdown or Quarto document, or in a web page saved with
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html).

## Usage

``` r
drawPedigreeDiagram(
  layout,
  edgeStyle = c("rectilinear", "direct"),
  onClick = NULL
)
```

## Arguments

- layout:

  the list returned by
  [`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md).

- edgeStyle:

  the `edgeStyle` the layout was made with, `"rectilinear"` (the
  default) or `"direct"`. It sets how far the hover highlight reaches: 6
  steps under `"rectilinear"`, whose invisible routing points count as
  steps, and 1 under `"direct"`.

- onClick:

  `NULL` (the default), or a JavaScript function, as a character string,
  that runs when the diagram is clicked. A Shiny application can pass
  one that sends the clicked animal to its server.

## Value

A `visNetwork` widget, 500 pixels tall, 45 more for each affected
condition past the first (at most four are drawn), for the “Affected
status unknown” row, for the “Genotyped” row, for the “Carrier” row, for
each of the “Proband” and “Consultand” rows, for the “Evaluated” row,
for each of the “Infertile” and “No offspring” rows, and for each of the
“Miscarriage”, “Termination” and “Ectopic” rows.

## Details

With two or more conditions, every animal's symbol is cut into equal
sections, one per condition, counter-clockwise from the top (the first
of two is the left half), and each condition's legend row shows a circle
cut the same way with that condition's section filled in its color, so
the legend says which section is which.

The colours of the conditions are set by
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)'s
`conditionColors`: the layout fills the symbols with them, and the
drawing paints the sections and the legend's rows from the layout's
`conditions` table, so all three agree.

An animal whose affected status is unknown (`NA`) is filled grey, with
one condition, or has that condition's section grey, with two or more,
so it does not look unaffected; the legend's grey hexagon “Affected
status unknown” then says what the grey is, and the canvas is 45 pixels
taller for that row.

An animal whose `genotyped` column is `TRUE` (see
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md))
is drawn with its outline 4 pixels wide, where every other symbol's is
1; the legend's “Genotyped” row, a square with that outline, then says
what the thick outline is, and the canvas is 45 pixels taller for that
row.

An animal whose `carrier` column is `TRUE` (see
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md))
is drawn with a black dot at the centre of its symbol, on top of its
fill, its sections and the slash; the legend's “Carrier” row, a circle
with the dot, then says what the dot is, and the canvas is 45 pixels
taller for that row.

An animal whose `proband` or `consultand` column is `TRUE` (see
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md))
has a black arrow pointing at its symbol from the lower left, a
proband's with “P” beside its tail; the legend's “Proband” and
“Consultand” rows, each the arrow, then say what they are, and the
canvas is 45 pixels taller for each. The drawing takes in each arrow, so
one at its left edge is not cut off.

An animal whose `evaluated` column is `TRUE` (see
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md))
has a black `*` to the right of the upper-right corner of its symbol;
the legend's “Evaluated” row, the `*`, then says what it is, and the
canvas is 45 pixels taller for that row. The drawing takes in each `*`,
so one at its right edge is not cut off.

An animal whose `fertility` column says it is infertile (see
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md))
has a black line down from the bottom of its symbol and two bars across
it, and one with no offspring by choice or for an unknown reason a line
and one bar, as in Pedixplorer; its id moves down below them. The
legend's “Infertile” and “No offspring” rows, each its mark, then say
what they are, and the canvas is 45 pixels taller for each. The drawing
takes in each moved id, so one in its bottom row is not cut off.

An animal whose `miscarriage` column says it is one (see
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md))
is drawn as a triangle 0.6 the size of the other symbols, so smaller
than the “Unknown” sex's, with no deceased slash. The triangle of a
termination of pregnancy or of an ectopic pregnancy has a black line
across it from its lower-left to its upper-right corner, and an ectopic
pregnancy's has “ECT” under it, as in Pedixplorer. Its id moves down
into the row of the other ids. The legend's “Miscarriage”, “Termination”
and “Ectopic” rows, each its triangle, then say what they are, and the
canvas is 45 pixels taller for each. The drawing keeps the room a
full-size symbol would have, so a long id at its edge is not cut off.

Each animal is drawn at the size
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)'s
`symbolSize` gives it; an infertile animal's and a miscarriage's id
moves down in proportion, and with symbols smaller than full size the
drawing keeps the room a full-size symbol would have, so a long id at
its edge is not cut off.

A click does nothing unless `onClick` is given: a Shiny application can
pass one to act on the clicked animal, which needs a live Shiny session,
so a script leaves `onClick` out.

## See also

[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)

## Examples

``` r
## Four animals: A and B are the parents of C and D; A has died, and C
## is affected
ped <- data.frame(
  id = c("A", "B", "C", "D"),
  sire = c(NA, NA, "A", "A"),
  dam = c(NA, NA, "B", "B"),
  sex = c("M", "F", "F", "M"),
  status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
  affected = c(FALSE, FALSE, TRUE, FALSE),
  stringsAsFactors = FALSE
)
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
layout <- makePedigreeMatingLayout(ped)
diagram <- drawPedigreeDiagram(layout)
## Print `diagram` in an interactive session to see it, or save it as a web
## page with htmlwidgets::saveWidget(diagram, "pedigree.html").
```
