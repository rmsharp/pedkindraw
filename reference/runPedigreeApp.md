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

- **Open** a CSV or text file with one row per animal, its values
  separated by commas, tabs or semicolons (the app takes the one that
  splits the first line into the most columns), or the sample pedigree
  (375 rhesus macaques, with its file of 3 twin pairs), or the `ped`
  given here; and, if you have one, a twins file with the columns id1,
  id2 and code, one pair per row, read the same way.

- **Say which columns** are the animal's id, its sire, its dam and its
  sex. The app recognizes pedkindraw's names and common others (ego,
  egoid, indid; father, fatherid, dadid; mother, motherid, momid;
  gender), whatever their case and with or without spaces, dots or
  underscores; the user can change each. Sex values m, f, h and u in any
  case, male, female, hermaphrodite and unknown, and 1 and 2 (male and
  female, as kinship2 and PLINK files code them) are read as M, F, H and
  U, and the app says so; any other value is drawn as unknown.

- **Choose what is drawn**: up to four conditions, from a list of the
  file's columns that starts with those whose names begin with
  "affected" in any case, each drawn in its own color and labeled
  "Affected (its name)"; a column of numbers is drawn once it has a
  cut-off (a comparison and a number, such as `>= 126`), which the
  legend states. The marks
  [`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  draws are found by their names in any case: genotyped (or avail),
  carrier, proband, consultand, evaluated, fertility, miscarriage,
  status (or deceased) and name, and the app lists those it found. A
  condition or a yes-or-no mark reads TRUE, T, yes, Y and 1 as yes and
  FALSE, F, no, N and 0 as no, in any case; deceased reads DECEASED,
  deceased, dead, died, D and the yes-words as deceased, and alive, A,
  shipped, sold, sale, S, unknown, U, the no-words and an empty cell as
  living (nprcgenekeepr's status words without its numbers, whose 1 is
  alive where kinship2's and Pedixplorer's is dead). A column holding
  any other value is not drawn, and the app names it and the values.
  Lines are drawn at right angles or straight. A twins file's codes may
  be MZ twin, DZ twin and UZ twin or 1, 2 and 3, as kinship2 numbers
  them; the file is checked with
  [`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md),
  its problem shown and the pedigree drawn without twins until it is
  corrected, and a pair is drawn when both its animals are.

- **See the pedigree drawn** on the Diagram tab, with `gen` added by
  [`findGeneration`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md),
  laid out by
  [`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md).
  What the layout says (a warning, or an animal it leaves out) is shown
  under the count of animals drawn; when a pedigree cannot be drawn, the
  app says so. A sire or dam with no row of its own is added by
  [`addParents`](https://rmsharp.github.io/pedkindraw/reference/addParents.md),
  and the app names it.

- **Choose the animals to draw**: everyone; one family (from
  [`findPedigreeNumber`](https://rmsharp.github.io/pedkindraw/reference/findPedigreeNumber.md),
  the families of two or more animals listed largest first); focal
  animals with their ancestors and descendants
  ([`trimPedigree`](https://rmsharp.github.io/pedkindraw/reference/trimPedigree.md)
  and
  [`getDescendantPedigree`](https://rmsharp.github.io/pedkindraw/reference/getDescendantPedigree.md)),
  each other parent of a descendant drawn too, without its own parents;
  or focal animals' near relatives
  ([`getNearRelativePedigree`](https://rmsharp.github.io/pedkindraw/reference/getNearRelativePedigree.md),
  3 by default). Type the focal animals' ids, or click an animal in the
  drawing to make it the focal animal (a repeated animal's symbol counts
  as the animal). With more than 1,000 animals chosen, the app asks
  before drawing them, which can take a minute or more.

- **See the records' problems** on the Checks tab, from
  [`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
  on the whole file, and the animals chosen on the Animals tab.

- **Save** the drawing as an SVG, a PDF or a PNG file with the buttons
  above it, through
  [`savePedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/savePedigreeDiagram.md)
  at its own page (10 inches wide; a PNG at 300 dpi); and the animals
  chosen as a CSV file with the button on the Animals tab: the rows that
  tab shows, with every column of the file, which the app opens again to
  the same drawing. The pictures need the chromote package and Google
  Chrome or Chromium; without them the picture buttons are grayed and
  the page says what is missing.

## Requirements

The shiny package (`install.packages("shiny")`), checked before anything
else. Saving the drawing as a picture also needs the chromote package
and Google Chrome or Chromium, as
[`savePedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/savePedigreeDiagram.md)
does; the app looks for them once, when it starts.

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
