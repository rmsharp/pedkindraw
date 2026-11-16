# Draw an interactive pedigree diagram from a mating layout

Returns an interactive pedigree diagram, as a `visNetwork` widget, for a
layout made by
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md).
The diagram has the sex symbols at the layout's fixed positions, the
legend (the five sex symbols, one row per affected condition or a single
“Affected” row, “Deceased”, and the dashed repeat-appearance and twin
lines), each multi-condition symbol split into its colored sections, the
slash through each deceased animal's symbol, a canvas that grows with
the number of conditions, the **Export Diagram (PNG)** button, a “Select
by id” box that lists the animals, and the highlight on hover. The
sections and the slash are painted by a drawing script inside the
widget, so they appear wherever the widget is shown: in the RStudio
viewer, in an R Markdown or Quarto document, or in a web page saved with
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
condition past the first (at most four are drawn).

## Details

With two or more conditions, every animal's symbol is cut into equal
sections, one per condition, counter-clockwise from the top (the first
of two is the left half), and each condition's legend row shows a circle
cut the same way with that condition's section filled in its color, so
the legend says which section is which.

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
