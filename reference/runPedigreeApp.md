# Draw a pedigree in an app, from a file, with no code

Starts a small app in the web browser that opens a pedigree file and
draws it with
[`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md),
for someone who keeps a pedigree in a spreadsheet and does not write R.
The call waits until the app is closed (press Escape or Ctrl-C in R, or
stop the R session).

## Usage

``` r
runPedigreeApp(ped = NULL, port = NULL, launch.browser = interactive())
```

## Arguments

- ped:

  `NULL`, or a data frame with the columns `id`, `sire`, `dam` and `sex`
  (its other columns kept), opened in the app as if read from a file.

- port:

  `NULL`, for a free port chosen by shiny, or the port, one whole number
  from 1 to 65535.

- launch.browser:

  `TRUE` to open the app in the web browser, `FALSE` to print its
  address only. By default, `TRUE` in an interactive R session.

## Value

What [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html)
returns when the app is closed, invisibly.

## Details

In the app:

- **Open** a CSV or text file with one row per animal, or the sample
  pedigree (375 rhesus macaques), or the `ped` given here.

- **Say which columns** are the animal's id, its sire, its dam and its
  sex. The app recognises pedkindraw's names and common others (ego,
  egoid, indid; father, fatherid, dadid; mother, motherid, momid;
  gender), whatever their case and with or without spaces, dots or
  underscores; the user can change each. Sex values m, f, h and u in any
  case, male, female, hermaphrodite and unknown, and 1 and 2 (male and
  female, as kinship2 and PLINK files code them) are read as M, F, H and
  U, and the app says so; any other value is drawn as unknown. Every
  other column is kept, so a column pedkindraw reads by name is drawn as
  a script draws it.

- **See everyone drawn** on the Diagram tab, with `gen` added by
  [`findGeneration`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md),
  laid out by
  [`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md).
  What the layout says (a warning, or an animal it leaves out) is shown
  under the count of animals drawn; when a pedigree cannot be drawn, the
  app says so.

- **See the records' problems** on the Checks tab, from
  [`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md),
  and the animals read on the Animals tab.

## Requirements

The shiny package (`install.packages("shiny")`), checked before anything
else.

## See also

[`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md),
which draws the pedigree, and
[`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md),
which finds the records' problems.

## Examples

``` r
# It starts an app and waits until it is closed, so it runs when typed in
# R, and not in R CMD check.
if (interactive() && requireNamespace("shiny", quietly = TRUE)) {
  runPedigreeApp()

  ped <- data.frame(
    id = c("A", "B", "C", "D"),
    sire = c(NA, NA, "A", "A"),
    dam = c(NA, NA, "B", "B"),
    sex = c("M", "F", "F", "M")
  )
  runPedigreeApp(ped)
}
```
