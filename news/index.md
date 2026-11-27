# Changelog

## pedkindraw 1.0.0

The first release. About half of its code is in files copied from
nprcgenekeepr at nprcgenekeepr’s commit `baef1e12c`
([`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
at the later `4283e3502`); the items marked “New” were written for
pedkindraw. Where the copy now differs from nprcgenekeepr’s code,
`DIVERGENCE.md` in the repository says how and why.

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
  stops on the id of an animal it draws that starts with `__jog_`, as
  for the other prefixes it keeps for its own nodes; nprcgenekeepr
  accepts one, and its drawing can then have two nodes with that id.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  and
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  stop when a condition column they draw (the layout’s up to four,
  `affected`, `affected2`, …;
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)’s
  `affected`) holds a number other than 0 and 1, naming the column and
  the numbers. A measured trait (2.5, 0.3, 9) was drawn affected
  wherever it was not 0, with no message, as it still is in
  nprcgenekeepr. `TRUE`, `FALSE`, `NA`, 0 and 1 (kinship2’s codes, which
  [`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
  writes) and text read as before.
- New: an animal whose affected status is unknown (`NA`) is filled gray
  (`#BEBEBE`, R’s `"grey"`, as Pedixplorer fills it), with one
  condition, or has that condition’s section gray, with two to four, so
  it no longer looks unaffected;
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  fills it gray too. The legend then has a gray row “Affected status
  unknown” after the condition rows, and the drawing is 45 px taller for
  it. nprcgenekeepr still fills an unknown status white. Text in a
  condition column that
  [`as.logical()`](https://rdrr.io/r/base/logical.html) cannot read
  (such as “yes”, or “1” read as text) is unknown, so it is now drawn
  gray.
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
  take `conditionColors`, the colors of the affected conditions, by
  default the four drawn before (pink, orange, sky blue and bluish
  green). Each is a name R knows, such as “orange”, or a code, such as
  “#E69F00”, and is written as its “#RRGGBB” code, the color R means by
  it: a browser reads most of R’s color names as no color, and `"grey"`
  as a darker gray. The layout fills the symbols with them and keeps
  them in its `conditions` table, from which
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  now paints the sections and the legend, so all three agree; before,
  colors edited in that table reached the legend but not the sections. A
  color R does not know, a number, a transparent color, white, the gray
  of an unknown status, a color given twice, or fewer colors than
  conditions drawn stops, with a message naming them; a value that is
  not text stops with a message saying what `conditionColors` takes.
  nprcgenekeepr’s colors are fixed.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  and
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  take `conditionThresholds`, cut-offs for measured traits. A condition
  column of numbers is drawn by its cut-off, a comparison and a number,
  such as
  `conditionThresholds = c(affected_glucose = ">= 126", affected_hb = "< 13")`:
  an animal whose number passes is affected, one whose number does not
  is unaffected, and one with no number is unknown (gray). The rule goes
  into the condition’s name, so the legend reads “Affected (glucose ≥
  126)” and the hover text “Affected (glucose ≥ 126): Yes (140)”. `>`
  and `<` decide as Pedixplorer’s `threshold` does. Without a cut-off a
  number other than 0 and 1 still stops, with a message that names
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
  at its center, on top of its fill, its sections and the deceased
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
  whom counseling or testing is sought. Each is drawn with a black arrow
  pointing at its symbol from the lower left, a proband’s with “P”
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
  symbol, clear of the deceased slash and, in the rectilinear style, of
  the lines, and its hover text says “Evaluated: Yes”, “No” or
  “Unknown”; any other value stops, naming the column.
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
  colony animal can be sterilized after it has bred (Pedixplorer refuses
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
  animal and each repeat appearance gets a size of 25 times it, rounded
  to a whole unit (vis.js draws a symbol twice its size across, 50 units
  at 1), and the mating points keep theirs. The layout works out its
  lines’ detours around the symbols from it, and an infertile animal’s
  and a miscarriage’s id moves down in proportion. Since the drawing
  zooms to fit, a larger symbol leaves less room between the symbols:
  measured at 500 px, from 2 the symbols reach the lines and the mating
  points, and at 3 the rectilinear layout warns that it could not clear
  every symbol. With symbols smaller than full size,
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
  the ids: the 10-character ids measured are 117 to 119 units wide at
  1.4 and 163 to 167 at 2, and the animals in a row are 120 apart. An id
  starting `__text_` is now refused, as the other reserved prefixes are.
  Anything but one positive number stops. nprcgenekeepr has no such
  argument. At 1 every layout and drawing is as before.
- New: `makePedigreeMatingLayout(columnSpacing = , rowSpacing = )` set
  the distance between neighboring animals in a row and between
  generations as multiples of the 120 and 150 units used before (1, the
  defaults), each rounded to a whole unit, so a drawing can be made
  wider or deeper, as kinship2’s distances follow the width and height
  of its page. Every place in the layout is the one before times the
  spacing, and the rectilinear lines’ steps and curves are worked out at
  the spacing given. Since the drawing zooms to fit, wider spacing
  leaves the symbols and text smaller beside the distances. Larger text
  needs wider columns: at `textSize = 2` the 10-character ids measured
  are up to 167 units wide, so neighbors’ ids run together at
  `columnSpacing = 1` and stand apart at 1.4. Measured at 500 px,
  columns at 0.5 lay long ids over their neighbors’ and rows at 0.5 run
  the lines from parents to their offspring through the parents’ ids.
  Anything but one positive number stops. nprcgenekeepr has no such
  arguments. At 1 every layout and drawing is as before.
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
  mating each mate is drawn on: the two kinds of hint kinship2 and
  Pedixplorer take.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  returns the hints it used as `hints`, in the form its `hints` argument
  takes, so that `makePedigreeMatingLayout(ped, hints = layout$hints)`
  gives the same layout and an edit can start from the layout’s own:
  `order` numbers each animal with a parent by the row the layout drew
  it from (a founder only where your order named it); `mate` holds your
  rows, then the layout’s own row for each other mating, except the
  matings of an animal that anchors three or more matings or that your
  rows place, where a row can move its mates.
- New: `savePedigreeDiagram(diagram, file, width, height, dpi)` writes
  the widget
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  returns as an SVG, a PDF or a PNG file (the file’s ending chooses),
  from a script: before, a drawing could be saved only as a web page, or
  by clicking its “Export Diagram (PNG)” button in a browser. A headless
  Chrome (the chromote package and Chrome or Chromium on the computer)
  runs the same drawing the widget shows and a recording layer writes
  it, so every mark, color and legend row comes out as drawn, the
  legend’s pictures as vector pictures, and every id as text a reader
  can select and zoom to: the widget draws an id only when it would be 4
  pixels tall, so its 375 rhesus animals show none until zoomed in, and
  the file has all 545 id labels (375 distinct, the rest repeat
  appearances). `width` and `height` are the page in inches; left out,
  the widget’s own width and height, 10 inches wide when its width is
  not a number of pixels
  ([`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
  sets none). The PDF is that drawing on one page of that size, still
  vector with its ids as text; each dashed line is written as a row of
  short strokes, because Chrome would otherwise write every dash as an
  outline (the 375 animals on a 14 by 7 inch page: 1.0 MB, 5.8 MB
  without). The PNG is the page at `dpi` pixels per inch, 300 unless
  told (a 7 by 5 inch page is 2100 by 1500 pixels). Measured against the
  live widget in Chrome 157 on macOS, over the pixels that are not white
  in either, for the SVG and for the PNG at 96 dpi: on the four animals
  none of the drawing’s and 0.03% of the legend’s differ by more than
  100 in a color channel, on an 18-animal pedigree with all seven marks
  0.26% and 0.07%. It stops, saying what is missing, without chromote
  (in Suggests) or Chrome. It ends every process of the Chrome it
  starts, on Windows too, where the renderer of a page that never
  finishes drawing outlives its browser’s close. It waits up to 60
  seconds for each Chrome it starts to open its port, as it waits for
  Chrome’s answers: chromote’s own 10 seconds can pass for a fresh
  Chrome on a busy computer; a larger `chromote.timeout` option is kept.
  nprcgenekeepr has no such function.
- New: the 375 rhesus animals of the example pedigree, with their 3 twin
  pairs, are one page of
  [`savePedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/savePedigreeDiagram.md)’s
  SVG or PDF on a 14 by 7 inch page or on letter paper (8.5 by 11
  inches), with every id written: 545 id labels, 375 distinct, and none
  overlapping another id or label (checked with pdftotext on the PDF on
  both pages, and in Chrome on the SVG of the 14 by 7 inch page, id
  against id). The ids are small, under 1 point high at the median on
  those pages, so a reader zooms in on the SVG or PDF; in a PNG at the
  default 300 dpi an id is about 3 pixels high (a larger `dpi` makes it
  bigger). The drawing vignette’s “Saving a drawing” and “A colony-size
  drawing” show the files.
- New: `runPedigreeApp(ped, port, launch.browser)` starts an app in the
  web browser that draws a pedigree from a CSV or text file, its values
  separated by commas, tabs or semicolons, with no code, for someone who
  keeps a pedigree in a spreadsheet. It opens the file, the 375 rhesus
  animals of the sample pedigree, or a `ped` data frame from R;
  recognizes the id, sire, dam and sex columns by pedkindraw’s names and
  common others (ego, egoid, indid; father, fatherid, dadid; mother,
  motherid, momid; gender), in any case and with or without spaces, dots
  or underscores, and lets you choose each; reads the sex codes m, f, h
  and u, male, female, hermaphrodite and unknown, and 1 and 2 (male and
  female, as kinship2 and PLINK files code them) as M, F, H and U, and
  says so; adds `gen`; and draws everyone. What the layout says (a
  warning, an animal it leaves out) is shown on the page, and a pedigree
  that cannot be drawn is said so. The Checks tab lists
  [`checkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)’s
  problems and the Animals tab the animals chosen. It needs the shiny
  package (in Suggests). Pedixplorer’s `ped_shiny()` is such an app;
  nprcgenekeepr’s app is its whole colony application, `runGeneKeepR()`.
- New:
  [`runPedigreeApp()`](https://rmsharp.github.io/pedkindraw/reference/runPedigreeApp.md)‘s
  app chooses the animals it draws: everyone, one family (the families
  of two or more animals listed largest first, with their sizes), focal
  animals with their ancestors and descendants, or focal animals’ near
  relatives (3 by default, as Pedixplorer’s app). With ancestors and
  descendants, a descendant’s other parent is drawn too, without its own
  parents, so every offspring appears with both parents; with each of
  the sample pedigree’s 375 animals as the focal animal in turn, 344 of
  the drawings have such a parent. The focal animals are typed, or an
  animal is clicked in the drawing (a repeated animal’s symbol counts as
  the animal); the clicked animal becomes the only focal animal, as in
  nprcgenekeepr’s Pedigree Browser. With more than 1,000 animals chosen,
  the app asks before drawing them (on the computer measured, 9 to 19
  seconds for about 1,000 animals, by the pedigree’s shape, and 50 for
  2,000). A sire or dam with no row of its own is added with
  [`addParents()`](https://rmsharp.github.io/pedkindraw/reference/addParents.md)
  and named, so such a file is drawn; the Checks tab still lists it. The
  Animals tab shows the animals chosen.
- New:
  [`runPedigreeApp()`](https://rmsharp.github.io/pedkindraw/reference/runPedigreeApp.md)’s
  app chooses what it draws: up to four conditions from the file’s
  columns (those whose names begin with “affected”, in any case, chosen
  at first), each labeled “Affected (its name)”, and a column of numbers
  cut at a cut-off the legend states, such as “Affected (glucose ≥
  126)”; the marks
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  draws, found by their names in any case and by Pedixplorer’s avail and
  deceased, and listed on the page; lines at right angles or straight;
  and a twins file (id1, id2, code; MZ twin, DZ twin and UZ twin, or
  kinship2’s 1, 2 and 3), checked with
  [`checkTwinRelations()`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md),
  a pair drawn when both its animals are. A file’s yes-or-no values are
  read as TRUE, T, yes, Y or 1 and FALSE, F, no, N or 0, in any case.
  The deceased mark reads deceased, dead, died, D and the yes-words as
  deceased, and alive, A, shipped, sold, sale, S, unknown, U and the
  no-words as living (nprcgenekeepr’s status words without its numbers,
  whose 1 is alive). A condition or mark column with any other value is
  left out and named. The sample pedigree opens with its file of 3 twin
  pairs.
- New:
  [`runPedigreeApp()`](https://rmsharp.github.io/pedkindraw/reference/runPedigreeApp.md)’s
  app saves what it shows. On the Diagram tab, the SVG, PDF and PNG
  buttons save the drawing through
  [`savePedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/savePedigreeDiagram.md),
  at that function’s own page (10 inches wide); on the Animals tab, a
  button saves the animals chosen as a CSV file with every column of the
  file, which the app opens again to the same drawing. The pictures need
  the chromote package and Google Chrome or Chromium; without them the
  picture buttons are grayed and the page says what is missing, and the
  CSV button still works.
- New:
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  draws a pedigree with a sire or dam that has no row of its own,
  without that parent: an animal whose other parent is unknown is drawn
  with no line up, as a founder is. It stopped with R’s own messages on
  many such pedigrees (676 of 1,181 random ones), as nprcgenekeepr’s
  still does;
  [`addParents()`](https://rmsharp.github.io/pedkindraw/reference/addParents.md)
  adds the missing rows. It also stops on an id on more than one row,
  naming it, where it stopped with “node stack overflow”.

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
  [`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
  when it draws a mating, and so stops the same way. The help page and
  the README name the functions kinship2 and Pedixplorer also export.
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
  result can be passed back. Without `matings`,
  [`getMatings()`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)
  lists only the matings built from offspring.

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
  that names one of them, so none of them is left as a parent with no
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

### Requirements

- pedkindraw needs R 4.5.0 or later. Its checks run on R 4.5 and later;
  no older R is checked.

### Documentation

- New: the README draws a pedigree of twelve animals in four generations
  (a death, a condition, identical twins and a mating of first cousins),
  computes their kinship, says what each mark of the drawing means,
  lists the functions by what they do, and says how pedkindraw began as
  a copy of nprcgenekeepr’s code.
- New:
  [`vignette("pedkindraw", package = "pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/pedkindraw.md),
  “Getting started with pedkindraw”, takes one pedigree from its records
  to a drawing: it checks the example pedigree, numbers its generations
  and family trees, computes kinship, trims it and draws it, then
  shrinks it and finds a set of unrelated animals; its last section
  converts a kinship2 pedigree.
- New:
  [`vignette("drawing", package = "pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/drawing.md),
  “Drawing pedigrees”, shows the drawing part by part: the symbols and
  the legend, conditions, twins, animals drawn twice, matings of
  relatives, the two line styles, animals with no relative, layout
  hints, kinship2 and Pedixplorer objects, saving a drawing, clicks in a
  Shiny application, a colony-size drawing and how large a drawing can
  be.
- New:
  [`vignette("speed", package = "pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/speed.md),
  “Speed and size limits”, gives the seconds pedkindraw’s functions took
  on one machine, by the number of animals from 300 to 100,000, beside
  the kinship2 and Pedixplorer functions that do the same; where each
  one stopped and its memory there; and how large a drawing can be drawn
  and read. A script in the repository, `tools/checkSpeedTables.R`,
  checks every number in the page’s tables against the timing records in
  `tools/timing/results/`, and that each number in its text is a table’s
  or one of the method’s own.
  [`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)’s
  help gives the measured size of a drawing and points to the page, as
  do
  [`?pedkindraw`](https://rmsharp.github.io/pedkindraw/reference/pedkindraw-package.md)
  and the other two vignettes.
- New: the website, <https://rmsharp.github.io/pedkindraw/>, has every
  help page, in the groups of
  [`?pedkindraw`](https://rmsharp.github.io/pedkindraw/reference/pedkindraw-package.md),
  the three vignettes as articles, and this NEWS.
- The help pages, vignettes, README and NEWS use US spelling throughout
  (color, gray, center, labeled), as the package’s `Language: en-US`
  says; so do the messages
  [`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  and
  [`makePedigreeDiagramData()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeDiagramData.md)
  stop with when `conditionColors` is wrong.
