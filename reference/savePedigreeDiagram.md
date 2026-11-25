# Save a pedigree diagram as a picture file

Writes the widget
[`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
returns as a picture file, from a script: it is drawn in a browser by
JavaScript, and nothing else in R can turn it into a file. A headless
Chrome (through the chromote package) runs the very drawing the widget
shows, a small recording layer writes every line, shape and word it
draws, and the result is an SVG file: the same drawing, with every mark,
colour and legend row, and each id as text that a reader can select,
search and zoom to.

## Usage

``` r
savePedigreeDiagram(diagram, file, width = NULL, height = NULL, dpi = 300)
```

## Arguments

- diagram:

  the widget
  [`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  returns.

- file:

  the file to write, one file name. Its ending, in any case, chooses the
  kind of file: `.svg`, `.pdf` or `.png`. The folder must exist.

- width, height:

  the page, in inches: a positive number, or `NULL` (the default) for
  the size the widget has in the browser, 10 inches wide. The widget is
  drawn at `width * 96` by `height * 96` pixels, so the drawing fills
  the page, with its legend at the right.

- dpi:

  the pixels per inch of the page in a `.png` file, one positive number
  (the default is 300): a page of 7 by 5 inches is 2100 by 1500 pixels.
  An `.svg` or `.pdf` file is vector and has no pixels, so the number
  does not change it; it is checked for every kind of file.

## Value

`file`, invisibly.

## Details

The ending of `file` chooses the kind of file: `.svg`, the recorded
drawing as it is; `.pdf`, that drawing printed as one page of the
picture's size, still vector, with each id as text (each dashed line is
written as a row of short strokes, because Chrome writes every dash of a
dashed line as an outline and a pedigree with many repeat animals would
otherwise be a PDF of several megabytes); or `.png`, a photograph of the
same drawing at `dpi` pixels per inch of the page.

The widget on screen draws an id only when it would be 4 pixels tall, so
a large pedigree shows no ids until a reader zooms in. A file has no
zoom, so the function writes every id: it lowers that limit on a copy of
the widget, and the widget `diagram` itself is not changed.

The picture is the widget's size in the browser, 10 inches (960 pixels)
wide, unless `width` or `height` say otherwise. The drawing and its
legend are drawn for that page, and the file's own size is the page, so
it prints at that size.

The function starts its own headless Chrome for each call (two for a
`.pdf` or `.png`), waits up to 60 seconds for each to start (chromote's
own wait is 10; a larger `chromote.timeout` option is kept), closes it,
and stops if the drawing is not done within 60 seconds
(`options(pedkindraw.saveTimeout = seconds)` changes that).

## Requirements

The chromote package, and Google Chrome or Chromium on the computer (set
`CHROMOTE_CHROME` to its path if chromote cannot find it). Both are
checked before anything is drawn. A `.pdf` or `.png` file also needs
jsonlite, which chromote needs too.

## See also

[`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
for the widget, and
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
for what it draws.

## Examples

``` r
# It starts Chrome, so it runs when typed in R, and not in R CMD check.
if (interactive() &&
      requireNamespace("chromote", quietly = TRUE) &&
      !is.null(suppressMessages(chromote::find_chrome()))) {
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
  diagram <- drawPedigreeDiagram(makePedigreeMatingLayout(ped))
  for (kind in c(".svg", ".pdf", ".png")) {
    file <- tempfile(fileext = kind)
    savePedigreeDiagram(diagram, file, width = 7, height = 5)
    print(file.exists(file))
    unlink(file)
  }
}
```
