# Phase G16: picture files from a script, and a whole large pedigree on one page (gaps A1 and A2) -- the plan

**Date:** 2026-11-21 · **Session:** pedkindraw S68 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; failure mode #18: this session writes no package code; the one code file it adds is a measured
prototype, section 10). **Governs:** Phase G16 of `docs/planning/gaps-and-shared-code-plan.md` (section 5.1, G16's
row), gaps A1 and A2 of `docs/research/pedkindraw-gaps-2026-11-18.md` (section 3). **Ruling made here:** R142 (Mark's
three picks, `docs/planning/standalone-pedigree-package-plan.md` section 2). **Status:** plan written; G16a started in
S69 (pre-RED measures and R143's picks in section 11, which corrects 4.3's and 4.5's legend figures and the plan's
dragon 4); no code yet.

**Versions:** kinship2 1.9.6.2, Pedixplorer 1.8.0, visNetwork 2.1.4 and chromote 0.5.1 from this project's renv
library; Google Chrome 157.0.8103.51; pedkindraw at `ec8356b` (its `R/` unchanged since `1a6092e`); nprcgenekeepr at
`3e06730c5`; R 4.6.2; this Mac (Apple M2 Max). Every count below was measured in this session by the scratch scripts
of section 10 and covers the cases run, no more (Learning 19).

---

## 1. What G16 closes, and for whom

`drawPedigreeDiagram()` returns a `visNetwork` widget, drawn by JavaScript on a canvas in a browser. A script cannot
get a picture file out of it: `plot()` on the widget inside `pdf()` stops (the research record, A1) and the PDF has 0
pages; `htmlwidgets::saveWidget()` saves a web page; a PNG comes only from the widget's "Export Diagram (PNG)" button
(`R/drawPedigreeDiagram.R:448`-`:451`), clicked in a browser. There is no PDF and no SVG.

**What it means for users (A1):** a drawing cannot go straight into a paper, a printed report or a PDF or Word document
made with R Markdown; it shows in HTML output only. kinship2's `plot.pedigree()` and Pedixplorer's `plot()` draw with
R graphics, so any device (PDF, SVG, PNG) takes the picture; Pedixplorer also returns a ggplot object. **(A2):** a
colony-size pedigree has no one-page overview with its ids, on screen or on paper: the 375-animal rhesus pedigree shows
no id until the reader zooms in 6.27 times (the research record, A2), because vis.js draws a label only when it would be
at least 4 px tall.

**nprcgenekeepr shares the gap** (its Diagram tab offers the PNG button and a saved web page, no SVG or PDF: the
comparison study's section 8.2). Under R98 and R101 pedkindraw leads; a new function in a new file changes no copied
code, so no `DIVERGENCE.md` row, and nprcgenekeepr gains it when it imports pedkindraw (N3). No nprcgenekeepr session is
needed. Whether the function also works on nprcgenekeepr's own widget was not measured.

---

## 2. What kinship2 and Pedixplorer do (measured)

**Files, four animals** (the research record's `files` case, `tools/gapCases.R:167`): kinship2 writes a PDF (4,742 B),
an SVG (8,606 B) and a PNG (9,872 B), Pedixplorer 4,752, 8,957 and 9,489 B, each PDF one page; Pedixplorer's
`plot(ggplot_gen = TRUE)` has a `ggplot2::ggplot` element.

**The 375-animal rhesus pedigree on one page** (`tools/gapCases.R:221`, the `largeIds` case, here read from the PDF
each package wrote, `pdftotext -bbox`, one page each; `kinship2::plot.pedigree()`, `Pedixplorer::plot(cex = 0.5)`,
which stops at its default `cex`):

| Picture | Page | id words | distinct ids | id word height | ids overlapped by another id | PDF bytes |
|---|---|---:|---:|---:|---:|---:|
| kinship2 | 7 x 7 in | 517 | 375 | 11.1 pt | 517 (100%) | 97,007 |
| kinship2 | 14 x 14 in | 515 | 372 | 11.1 pt | 511 (99%) | 100,096 |
| Pedixplorer, cex 0.5 | 7 x 7 in | 472 | 356 | 5.55 pt | 467 (99%) | 98,978 |
| Pedixplorer, cex 0.5 | 14 x 14 in | 468 | 356 | 5.55 pt | 440 (94%) | 101,971 |
| pedkindraw, section 4's prototype | 10 x 5.1 in | 545 | 375 | 0.53 pt | 0 (0%) | 5,668,432 |

Both references write every id they plot **at a fixed point size, whatever the page**, so on these pages nearly every
id lies over another one; Pedixplorer also leaves 18 animals out ("won't be plotted"). The S40 case counted `text()`
calls (kinship2 520, Pedixplorer 473 at `cex` 0.5); the PDFs' words give 517 and 472 that are ids (the 3 and 1 that
differ are not explained). **"Every id written" is therefore a count of text objects in the file, not a readable
picture**: the research record's "the ids can be read by zooming the file" holds only if the ids do not overlap.

**Time** (one process each, this Mac): kinship2 1.2-1.3 s, Pedixplorer 3.2 s for the 375 animals.

---

## 3. The decision (R142)

Four ways to write picture files were put to Mark by picker, each measured or costed first (section 4). **R142**, Mark's
picks (S68), each first time:

1. **The way: "Record the widget's own drawing (Recommended)".** Headless Chrome (chromote) runs the same drawing the
   widget shows; a recording layer writes what that drawing paints as SVG; Chrome makes the PDF from the SVG, and the
   PNG as a picture of the page. Every mark, colour and legend row already drawn comes out with no second version to
   keep alike. The other three options: "Screenshot only (PNG)" (no SVG; Chrome's PDF of the widget is a picture with
   0 ids as text), "A second drawing program in R" (about 5-7 build sessions, a guess, and every mark drawn twice) and
   "A second drawing program as a ggplot2 picture" (6-8 sessions, a guess, the same upkeep, and ggplot2 in Suggests).
2. **The file types: SVG, PDF and PNG**, chosen by the ending of the file name.
3. **The page: "Fit to a page size the user gives (Recommended)".** `width` and `height` in inches; the drawing is scaled
   to fit; every id is text in the file, read by zooming. The other two: "Size the page so ids are readable on paper"
   (6 pt ids need a page about 80 inches wide for the 375 animals) and "Both".

Needs Chrome on the user's computer (the cost Mark accepted). **Not picked, so out of scope** (section 9): a ggplot
object, which only a second drawing program gives.

---

## 4. What the prototype showed

Scratch prototypes only (section 10); `docs/planning/picture-files-prototype/recorder.js` is the recording layer, 180
lines (176 of code).

**4.1 What the widget draws.** Every canvas call the widget makes while drawing was tallied in headless Chrome by
wrapping `CanvasRenderingContext2D.prototype` before the page ran: the feature pedigree of section 4.3 (19 rows, 18
drawn; 2 conditions; all seven marks, though not the "no offspring" variant of infertile, whose animal is left out as
isolated; the legend's 11 pictures) and the 375-animal pedigree together call **22 methods** (`arc`,
`beginPath`, `clearRect`, `clip`, `closePath`, `drawImage`, `fill`, `fillRect`, `fillText`, `lineTo`, `measureText`,
`moveTo`, `quadraticCurveTo`, `rect`, `restore`, `save`, `scale`, `setLineDash`, `setTransform`, `stroke`, `strokeText`,
`translate`) and set **10 properties** (`fillStyle`, `font`, `globalAlpha`, `lineCap`, `lineDashOffset`, `lineJoin`,
`lineWidth`, `strokeStyle`, `textAlign`, `textBaseline`). A recorder needs the 21 that draw (`measureText` only reads).
The drawing is the copied `vis-network` plus pedkindraw's seven `afterDrawing` handlers (208 lines of JavaScript:
sections 65, slash 20, carrier dot 15, arrows 34, star 23, bars 24, miscarriage 27), all through that one context.

**4.2 What the recorder does.** It keeps, per canvas, the transform matrix, the drawing styles and a clip stack
(`save`/`restore`), turns each path call into SVG path data in the canvas's own units, and writes a `fill`, `stroke`,
text or image call as an element; `clearRect` empties the canvas's list, so only the last frame stays; `__svg()` puts
each canvas at its place on the page, clipped to its box. 28-260 elements for the small cases, 4,428 on the 375-animal
canvas.

**4.3 Fidelity.** The recorded SVG, opened in Chrome, against a screenshot of the live widget at the same size (the
Export button and the select box hidden). "Ink" is a pixel that is not near white in either; a pixel "differs" when a
colour channel differs by more than 100 (more than 40 in brackets):

| Pedigree | Part | Ink pixels | Differ >100 (>40) |
|---|---|---:|---:|
| four animals (the help example) | drawing | 4,181 | 0 (22, 0.5%) |
| feature pedigree: 18 animals drawn, deceased, 2 conditions with an unknown status, genotyped, carrier, proband, consultand, evaluated, infertile, miscarriage (3 kinds), MZ twins, a repeat animal | drawing | 12,554 | 86, **0.7%** (899, 7.2%) |
| 375 rhesus animals, fitted view (zoom 0.0456) | drawing | 21,240 | 770, 3.6% (6,253, 29.4%) |
| the same three | legend | 4,282 / 7,887 / 4,282 | 11.7% / 22.7% / 11.7% (38.9% / 55.3% / 38.6%) -- **corrected in section 11.2:** the feature row's photograph was taken in a 700 px window for a 961 px widget, blank below it; on a tall window the prototype's legend is 14.0%, and 0.2% after S69's four fixes |

The sections, slash, dot, arrows, star, bars, miscarriage triangles and "ECT", the MZ label and the dashed repeat arc
all came out as in the widget (looked at). The 375-animal figure is hairline anti-aliasing: at that zoom every line is
under a pixel wide, so Chrome's canvas and its SVG renderer shade the same lines differently. **The legend is the weak
part** (4.5). The screenshot checks only the conversion: what the SVG is true to is the canvas's own calls, which is
where the cran plan's dragon 25 says to measure (a screenshot once drew a legend row 30 px from where vis.js put it);
the recording reads the real `fillText()` positions, so it does not inherit that kind of difference.

**4.4 What the files hold, 375 animals** (Chrome 157; the page = the canvas, 960 x 491 px at 1 px = 1/96 in, as a page
720 x 369 pt):

- The label limit: at vis.js's default, **0 ids** are written (they are under 4 px); with `nodes.scaling.label.
  drawThreshold = 0` set before saving, **545 labels**, 375 distinct: the 375 animals and the 170 repeat appearances
  (`__dup_` nodes). The ids come out 0.638 px tall in the SVG, 0.53 pt in the PDF.
- SVG 849,232 B (761,580 B with no ids); 560 `<text>` elements, 545 of them ids.
- PDF (Chrome's `Page.printToPDF` of the SVG, `paperWidth` and `paperHeight` the SVG's, margins 0, `pageRanges = "1"`):
  **one page**, 720 x 369.12 pt, fonts embedded, the ids real text (`pdftotext -bbox` reads 545 id words, 375 distinct, 0
  overlapped); **5,668,432 B**, 58 times kinship2's. A Ghostscript rewrite gives 3,969,953 B. Why is not known.
- Zoomed (Ghostscript at 1,200 dpi, a crop of the middle): the ids are legible, 9 px tall, none over another.
- Time: about 9 s per picture, of which a fixed 8 s wait after the page's load event (the real time is shorter; not
  measured).

**4.5 What is wrong or unmeasured in the prototype.**

- **The legend's pictures.** vis.js draws each legend row's inline-SVG icon from a small PNG canvas it makes (36 x 25 px
  in the first one read), so the recorded `<image>` is a squeezed raster (11 of 11 in the feature legend; the first
  attempt's `viewBox` patch changed nothing, because the data is PNG). Two fixes: draw the legend rows from R's own
  tables (it holds each row's shape, colour and picture), or accept the rasters.
- **The legend's title** ("Sex", `main` of `visLegend()`) is a page element, not canvas drawing: not recorded.
- **Text baselines** in the legend differ by about 1 px (canvas `middle` against SVG `central`).
- **The PDF's size** (4.4).
- Not measured: `direct` edge style; `symbolSize`, `textSize`, spacing and `lineWidth` at other settings; more than one
  pedigree of colony size; Windows and Linux; a widget with `onClick`.

**4.6 The PNG route, measured for the option not picked, and for the PNG file itself.** The saved widget is 960 px wide
whatever the browser window (the viewport), so `w$width` is set before saving; the legend takes 0.28 of the width
(`visLegend(width = 0.28)`), so the drawing's 13,740 units fill only part of it (2,870 px of 4,400, 65%, at the zoom
0.2089 below). Ids drawn at vis.js's default limit, 375 animals:

| Widget width | Drawing's zoom | Id labels drawn | PNG bytes |
|---:|---:|---:|---:|
| 960 | 0.0456 | 0 | 53 KB |
| 2,000 | 0.0949 | 0 | 99 KB |
| 4,400 | 0.2089 | 0 | 165 KB |
| 6,000 | 0.2848 (14 px x zoom = 3.99 px) | 0 | 197 KB |
| 6,200 | 0.2943 | 545 (375 distinct) | 235 KB |
| 8,000 | 0.3416 | 545 | 284 KB |

A crop of the 8,000 px picture reads. Chrome's own `printToPDF` of the live widget is a letter page with one 269 x 475
px image and **1 word**: a picture, so a PDF must come from the recorded SVG.

---

## 5. The interface (R142, with what each build session decides)

A proposal, with names and defaults that each build session's pre-RED picker settles (Learning 1):

```r
savePedigreeDiagram(diagram, file, width = , height = , dpi = , ...)   # working name
```

- **`diagram`:** the widget `drawPedigreeDiagram()` returns. Whether a layout is also accepted is G16a's choice.
- **`file`:** the path; the type is its ending, `.svg`, `.pdf` or `.png` (case ignored); another ending stops naming the
  three (R142).
- **`width`, `height`:** the page, in inches (R142); the drawing is scaled to fit, as a widget of that size in pixels
  (96 per inch) fits it. Defaults, and what happens when the drawing's shape leaves white space, are G16b's.
- **`dpi`** (PNG only): pixels per inch of the page; the default is G16b's. Ids are written whatever the size; they read
  in the PNG only above 4 px (4.6).
- **The ids:** for a file the function lowers vis.js's label limit to 0, on a copy of the widget; the widget in the
  viewer is unchanged (`identical()` before and after, a test).
- **Return:** the path, invisibly.
- **Stops, each with a test:** `diagram` not a `drawPedigreeDiagram()` widget; `file` not one string or its ending not
  one of the three; `width`, `height` or `dpi` not a positive finite number; `chromote` or `htmlwidgets` not installed;
  Chrome not found (`chromote::find_chrome()`, `CHROMOTE_CHROME`); the page not drawn within a time limit; the file not
  writable.
- **Dependencies:** `chromote` and `htmlwidgets` are in Suggests today (`DESCRIPTION:27`-`:28`); whether they stay there
  (the function stops with a message) or move to Imports is G16a's choice, measured first (what each pulls in).
- **Where the recording layer lives:** an R string, as the other drawing scripts do, or a file in `inst/` read with
  `system.file()` (the installed size has about 800 KB left, `methodology/BACKLOG.md:23`); G16a's choice.

---

## 6. Inventory (grep, at `ec8356b`)

Searched: `Export Diagram`, `visExport`, `saveWidget`, `chromote`, `skip_if_no_chrome`, `htmlwidgets`, `drawThreshold`,
`ggplot` and `svg` over `R/`, `tests/`, `tools/`, `vignettes/`, `README.Rmd`, `NEWS.md`, `_pkgdown.yml`, `DESCRIPTION`,
`.github/workflows/` and the contract; the pictures' mentions in the vignettes and README read.

| File | Lines (text) | Change | Phase |
|---|---|---|---|
| new `R/savePedigreeDiagram.R` (own; name at G16a's picker) | -- | the function, its help and example (guarded: CRAN's examples run without Chrome) | G16a |
| `R/drawPedigreeDiagram.R` (copied) | `:71` (help: "Export Diagram (PNG)"), `:445`-`:451` (`visExport()`) | none in code; a `@seealso` line is help text only (the drift tool compares arguments and code: confirm by running it) | G16c |
| `R/pedkindraw-package.R` | `:10` ("[drawPedigreeDiagram()] draws the layout as an interactive graph"), `:60` | one sentence | G16c |
| `_pkgdown.yml` | `:18`-`:22` (the "Drawing" group of the reference index) | the new topic (pkgdown stops on a topic missing from the index) | G16a |
| `DESCRIPTION` | `:27`-`:28` (`chromote`, `htmlwidgets` in Suggests) | per G16a's pick; `pdftools` in Suggests if G16c counts a PDF's words (section 8, dragon 9) | G16a, G16c |
| `README.Rmd` | `:136` ("picture with the "Export Diagram (PNG)" button"), `:146` | a sentence; README.md rendered from a scratch install (S52's way) | G16c |
| `vignettes/pedkindraw.Rmd` | `:187` (the same sentence) | a sentence | G16c |
| `vignettes/drawing.Rmd` | `:634`-`:647` ("Export Diagram (PNG)" and its check); `:690`-`:716` ("A colony-size drawing": "Fitted to the page, the drawing is too small to read its ids") | a section "Saving a drawing" and a sentence in the colony section; chunks guarded (CRAN builds vignettes without Chrome) | G16c |
| `tests/testthat/test_drawPedigreeDiagram.R` | `:201`-`:213` (the button test) | none | -- |
| `tests/testthat/helper-live-render-positions.R` | `:190` (`skip_if_no_chrome()`), the shared session's closing | reused | G16a |
| new `tests/testthat/test_savePedigreeDiagram.R` and a helper | -- | typed pedigrees, the feature pedigree, the rhesus pedigree; headless Chrome | G16a-c |
| 21 test and helper files that use chromote | `grep -l chromote tests/testthat/*.R` | unchanged; the model for the new ones | -- |
| `tools/gapCases.R` | `:167` (`files`), `:221` (`largeIds`) | probes with the new function: the three files, their pages, the ids as text | G16a-c |
| `docs/planning/pedkindraw-api-contract.md` | section 4, the drawing group | a row for the export, each phase's arguments | G16a-c |
| `NEWS.md` | -- | a bullet each phase | G16a-c |
| `NAMESPACE`, `man/` | -- | `roxygen2::roxygenise()` | G16a |
| `.github/workflows/R-CMD-check.yaml` | `:73`-`:102` (Chrome set up on Ubuntu and Windows, not macOS) | none; read each job's result for the new tests | G16a-c |
| `docs/research/pedkindraw-gaps-2026-11-18.md`, the comparison study | A1, A2; section 10 | none: dated records (`CLAUDE.md` "Governing documents") | -- |

---

## 7. Phases

**Common to each** (the gaps plan's "Every G phase", `docs/planning/gaps-and-shared-code-plan.md:345`): strict TDD, its
three gates and a pre-RED picker by `AskUserQuestion` in plain words, each option measured on a scratch copy first
(Learning 17); every expected value computed before RED (Learnings 18-21; the prototype's numbers in section 4 are
predictions until the real code is run); **DONE:** the full suite 0 failed, WARN 0; `lintr::lint_package()` 0;
`roxygen2::roxygenise()` leaves `NAMESPACE` and `man/` unchanged; `covr` reaches every new statement; `R CMD check
--as-cran` R16's NOTE only; a NEWS bullet; the contract's row; the drift tool exit 0 (no copied function changes: the
function is new, in a file of its own); the fidelity tool 600 of 600 identical (nothing it compares changes); the live
widget `identical()` before and after the function runs. **Commands:** `CLAUDE.md`'s Build / Test / Verify table with
`NOT_CRAN=true` for the browser tests; `Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`; `Rscript
tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr`; `Rscript tools/gapCases.R files` and `largeIds` (then `rm -f
Rplots.pdf`). **Surface:** this Mac, headless Chrome 157 for every file; GitHub Actions after the push, where Chrome is
set up by the workflow on Ubuntu and Windows but not macOS (`.github/workflows/R-CMD-check.yaml:73`-`:102`), and chromote
has been the flakiest part of the CI (the file's own comments: Chrome not found, the debugging port not open, a probe
that hangs on macOS), so the new tests' CI result is read job by job, not assumed from this Mac; CRAN's machines skip
the browser tests (`skip_on_cran()`), so a file is checked only here and on GitHub, and the new tests add nothing to
CRAN's check time (win-builder read 398 s at 17a). Ubuntu R-devel stops before checking pedkindraw (S4Vectors in
"setup-r-dependencies", S56-S67), so it enforces nothing. kinship2 and Pedixplorer are compared only where each returns,
under a time limit (Learning 19). The browser is the surface that **cannot** enforce a property for a reader of the file
in another program: a file is checked in Chrome (an SVG read by Chrome, a PDF by `pdftotext`), not in Word, Inkscape or
a print driver.

### G16a -- the recording layer and the SVG file (one session; two if the legend takes it) -- DONE in S69 (R143)

- **Work:** the function for `.svg` (R142 picks 1-2), end to end: a copy of the widget with the label limit at 0 and its
  size set, saved to a temp folder, opened in a chromote session with the recording layer in place, the last frame of
  each canvas read, the SVG composed (the legend at its place); help and a guarded example; `_pkgdown.yml`; the contract
  row; NEWS; the `files` case's probes; its tests.
- **Measure before the pre-RED picker** (Learning 17, on a scratch copy; section 10's scripts and `recorder.js` are the
  start): the legend's three ways (rows drawn from R's tables, rasters kept, an icon with a `viewBox` read back from the
  pictures' source), each as the share of the legend's ink that differs (4.3: 11.7% and 22.7% now) and its file size;
  the baseline's fix; the title; the `direct` edge style and the other style settings (`symbolSize`, `textSize`,
  spacing, `lineWidth`) on the feature pedigree; what `chromote` and `htmlwidgets` pull in as Imports; how long a
  picture takes when the fixed wait is replaced by waiting for vis.js's own "drawn" event; the time limit for a stuck
  page.
- **Pre-RED picker:** the name and arguments; the legend's way; Imports or Suggests; a layout accepted as well as a
  widget; whether the recording layer is a string or a file.
- **DONE, its own:** `savePedigreeDiagram(w, "x.svg")` on the four-animal case, the 12 typed shapes of the drawing's
  tests and the feature pedigree writes an SVG that Chrome loads as an SVG document (no parse error); its drawing's ink
  differs from the live widget's in at most a bound set from section 4.3's 0.7% (the bound is stated at RED, with the
  measured number beside it); the legend as picked; every animal's id is a `<text>` in the file when the label limit is
  lowered, and none when it is not (the widget's own); the stops of section 5 each tested; the widget unchanged;
  600 of 600.
- **Surface:** as common. The browser test reads pixels from a screenshot and counts SVG elements (dragon 73 of the gaps
  plan: an outline is in screen pixels, a line in units).
- **Session boundary:** close out when DONE. The 5-file cap splits GREEN into commits (`R/`, then `man/` with NEWS and
  `_pkgdown.yml`, then the contract and the gap case).
- **DONE (S69):** one session, the legend taken in it; the result and what G16b inherits are section 11.6.

### G16b -- PDF and PNG, and the page (one session)

*Pre-RED measures and Mark's picks made in S70: section 12 (R144). The sizes in the DONE below are read there.*

- **Work:** `.pdf` (Chrome prints the SVG on a page of `width` x `height`), `.png` (a picture of the page at `dpi`),
  the page rule (R142 pick 3), help, the contract row, NEWS, the `files` case.
- **Measure before the pre-RED picker:** the PDF's size (4.4: 5.7 MB): what Chrome writes for the 375 animals under each
  of fewer path numbers (rounding to one decimal), the same style's strokes joined into one path, and no clip paths
  where a shape needs none; and each one's effect on the picture; the defaults for `width`, `height`, `dpi` (kinship2's
  PDF default is 7 x 7 in); what the drawing's shape (375 animals: 13,740 units wide, 1,200 tall) leaves of a letter page;
  the PNG route's size and time at 96, 150 and 300 dpi.
- **Pre-RED picker:** the defaults; what a page the drawing does not fill looks like; the PDF's size fix.
- **DONE, its own:** the `files` case's three files for the four animals, each of the right type: the PDF one page of the
  given size (`pdfinfo`'s page size within 1 pt), the PNG of `width * dpi` by `height * dpi` pixels, the SVG as G16a;
  kinship2's and Pedixplorer's three files made for comparison, one page each, counted with a floor (`expect_gte()`);
  the 375-animal pedigree's PDF within the size G16b's measure picks.
- **Surface:** as common; a PDF is read by `pdfinfo` and `pdftotext` here, and by `pdftools` if G16c adds it.
- **Session boundary:** close out when DONE.

### G16c -- the whole large pedigree on one page, and the documents (one session)

- **Work:** gap A2's case: the 375-animal rhesus pedigree on one page with every id text; the drawing vignette's section
  "Saving a drawing" and the colony section's sentence; README, `vignettes/pedkindraw.Rmd` and the package help's
  sentences; `drawPedigreeDiagram()`'s `@seealso`; the `largeIds` case's probes; NEWS.
- **Measure before the pre-RED picker:** how a test counts the ids in a PDF with no PDF reader in R (dragon 9: `pdftools`
  in Suggests, or the SVG's count alone, or the `pdftotext` command, which is not portable); an overlap test from the
  PDF's word boxes (the prototype: 0 of 545) against the SVG's text positions; the colony's picture on a 14 x 7 in page
  (the shape the layout fits) and on letter paper, each as the ids' size in points; the time of the whole case.
- **Pre-RED picker:** how ids are counted in a PDF; the vignette's wording and whether its example runs in the site build.
- **DONE, its own (`largeIds`):** the rhesus pedigree (375 animals, 3 twin pairs) in one PDF page: **545 id labels, 375
  distinct, 0 overlapped** (the prototype's numbers; a count the real code must reproduce or replace with its own,
  measured, before RED), against kinship2's 517 and Pedixplorer's 472 at `cex` 0.5 on 7 inch pages (their 94-100%
  overlapped, section 2); the SVG and the PNG of the same drawing (the PNG's ids drawn at 6,200 px and wider); the
  vignette builds with its chunks guarded and the site builds; every statement the documents make is checked in a chunk.
- **Surface:** as common; the documents are checked by building the vignettes and the site (GitHub Actions).
- **Session boundary:** close out when DONE; G16 DONE (the gaps plan's row, the backlog item).

**Sessions:** 1 (this) + 3 to 4 (a guess; the gaps plan guessed 1 + 3-6, and Mark's pick of the recorded drawing is
the smaller way).

---

## 8. Here be dragons (found this session)

1. **`addScriptToEvaluateOnNewDocument()` runs only after `Page$enable()`** (chromote 0.5.1, Chrome 157): without it
   the call returns an identifier and the script never runs, silently (`window.__probe` was `undefined` after the load;
   with `Page$enable()` first it read 42). Also: on a small SVG document `loadEventFired()` timed out after
   `navigate(wait_ = FALSE)`, while the navigation call's own wait worked (the likely cause, an event already fired,
   was not tested).
2. **The saved widget is 960 px wide whatever the window** (`w$width` sets it), and a screenshot clip wider than the
   window is blank beyond it unless `captureBeyondViewport = TRUE` (the first fidelity run lost the whole legend that
   way). The widget's height is `.diagramHeight()`'s (`R/affectedConditions.R:345`): 500 px, and 45 more for each optional
   legend row (a condition past the first, and the unknown, genotyped, carrier, proband, consultand, evaluated,
   infertile, no-offspring, miscarriage, termination and ectopic rows).
3. **vis.js draws a label only at 4 px or taller, and the legend takes 0.28 of the width**: at a width of 6,000 px the
   14 px label is 3.99 px tall and nothing is written; at 6,200 all 545 are. The limit is
   `nodes.scaling.label.drawThreshold` (default 5, drawn at 4).
4. **The legend is its own network, its icons are PNG canvases and its title a page element.** A recording of the
   canvas holds the icons as small rasters (11 of 11) and not the title; the legend's rows are a table in R
   (`R/drawPedigreeDiagram.R:269`-`:411`), so drawing them from R is possible.
5. **Chrome's PDF of the recorded SVG is 58 times kinship2's** (5.7 MB against 97 KB for the 375 animals), by a cause not
   found; Ghostscript brings it to 4.0 MB.
6. **Chrome prints the live widget as a picture** (a letter page, one 269 x 475 px image, 1 word): never print the widget
   for a PDF.
7. **The references' "every id written" is overlapping text** (section 2): a test that counts ids and does not look
   at overlap passes for kinship2 and Pedixplorer, whose pictures nobody can read. Count both.
8. **A fixed 8 s wait is the prototype's, not a design**: the time to draw 375 animals was not separated from it.
9. **R has no PDF reader.** `pdftools` (poppler) reads words and word boxes; it is not installed here, and adding it
   is a renv install from the dated repository by name with `rebuild = TRUE`, a `dev = TRUE` snapshot and the
   `renv-lock-no-latest-repository` gate (Learning 3). `pdftotext` and `pdfinfo` are installed here (Homebrew) and in
   no CI job that has been read.
10. **`R CMD check` runs the examples and builds the vignettes without Chrome.** A help example or a chunk that needs
    Chrome must be guarded (`chromote::find_chrome()`), or it fails the check on CRAN's machines.
11. **chromote is the CI's flakiest part** (`.github/workflows/R-CMD-check.yaml:55`-`:72`): macOS's pinned Chrome hangs on
    its first probe, Windows once reported the debugging port not open. A session the new function starts needs its own
    time limit and its own close; the shared default session (`helper-live-render-positions.R`) closes at the suite's
    end and is not the function's to reuse.
12. **The prototype's numbers are one machine's and one Chrome's** (157, Apple M2 Max). Sizes and counts of files are
    kept in the DONE criteria as floors or as measured at RED, not as equalities; Chrome's PDF writer can change
    between versions.

---

## 9. Out of scope

- **A ggplot object** (Pedixplorer's `plot(ggplot_gen = TRUE)`; A1's row named it): only a second drawing program gives
  one, and Mark did not pick that (R142). If he wants it later it is a new gap item.
- **A second drawing program in R** (no Chrome, any R device): not picked; its cost (section 3) is the reason to
  revisit only if Chrome becomes unusable for users.
- **A fitted view of a large pedigree that shows its ids without zooming, in the browser** (A2's "to close it"): the
  limit is vis.js's; lowering it draws labels under a pixel tall.
- **The PNG button, `htmlwidgets::saveWidget()`:** unchanged.
- **`drawColonyOverview()`'s picture** (nprcgenekeepr's, issue #138) and **the app** (G17).
- **Any change to nprcgenekeepr** (R8, R98, R101).

---

## 10. Sources

- `docs/research/pedkindraw-gaps-2026-11-18.md` (A1 `:109`, A2 `:128`, the summary `:36`-`:40`, `:67`-`:68`);
  `docs/research/pedigree-package-comparison-2026-11.md` (section 8.2 the feature table, 9.4 readability, 10 what is
  left to offer); `docs/planning/gaps-and-shared-code-plan.md` (3.1's A1 and A2 rows, 5.1, G16's row); `docs/planning/
  standalone-pedigree-package-plan.md` (R81, R94, R95, R98, R101, R133-R140, R142); `docs/planning/cran-submission-plan.md`
  (dragon 25, measure from vis.js rather than a screenshot); `CLAUDE.md` (Learnings 1-3, 17-21).
- `docs/planning/picture-files-prototype/recorder.js`: the recording layer (committed; a prototype, not package code).
- S68's other scratch scripts (not committed; session scratchpad `g16/`, may be gone): `common.R` (the feature pedigree
  and the rhesus layout), `chrome.R` (a chromote session, the injected script, `evalJs()`), `m0.R` and `m1_layout.R` (what
  the layout returns: 8 nodes and 7 edges for the four animals; 46 and 44 for the feature pedigree; 1,466 and 1,496 for
  the rhesus pedigree, 684 of its nodes invisible, 375 animals, 170 repeat appearances, 1,320 solid and 170 dashed
  edges), `m2_canvas.R` (the canvas-call tally, 4.1), `m3_svg.R` with `cmp2.py` (the recorded SVG against a screenshot,
  4.3), `m4_large.R` (the 375 animals at label limits 5 and 0, SVG and Chrome's PDF, 4.4), `m5_refs.R` with
  `wordboxes.py` and `overlap.py` (the references' PDFs, section 2), `m6_raster.R` (the PNG at six widths, 4.6),
  `m7_cost.R` (the handlers' lines, 4.1).
- The files measured: the references' PDFs 97,007-101,971 B; the recorded SVGs 14,993 B (four animals), 72,090 B (feature)
  and 761,580 or 849,232 B (375 animals); the PDF 5,668,432 B.

---

## 11. G16a's pre-RED measures and picks (pedkindraw S69; R143)

**Date:** 2026-11-21 · **Session:** pedkindraw S69 · same machine, Chrome 157, chromote 0.5.1, visNetwork 2.1.4; scratch
scripts in the session's scratchpad `g16a/` (may be gone); the measured layer is committed as
`docs/planning/picture-files-prototype/recorder2.js` (a prototype, not package code).

**Method (every figure below).** The live widget is photographed in a window tall enough for it (`captureBeyondViewport`
or a 1,300 px window), the select box, the export button and the labels hidden, over the box of its two canvases; the
recorded SVG is loaded in Chrome and photographed at its own size; "ink" is a pixel that is not near white (channel sum
under 740) in either picture; one *differs* when a colour channel differs by more than 100; the legend is the part
right of the legend canvas's left edge. Widths of 1,000 px unless said.

### 11.1 Mark's picks (R143), each first time, all the recommended option

1. **The function:** `savePedigreeDiagram(diagram, file, width, height)`; `width` and `height` the page in inches (R142),
   left out the picture has the widget's own size, 10 in wide (960 px); `.svg` only in G16a, `.pdf` and `.png` stop with
   a message until G16b. (The other option: no page size until G16b.)
2. **The input:** the drawing only, not a layout. (The other: a layout too: measured safe, a layout made with
   `edgeStyle = "direct"` and drawn with the default gave an identical picture, 0 of 13,341 ink pixels, because
   `edgeStyle` at draw time only sets how far hovering highlights, `R/drawPedigreeDiagram.R:578`; it costs 2-3 tests
   and a second input shape.)
3. **The legend's pictures:** the original vector pictures. (Small rasters; or the rows redrawn from R's tables, not
   built: R's tables hold each row's shape, colour and picture but not its place, which vis.js fits to the canvas.)
4. **The packages:** `chromote` in Suggests, the recording layer a file in `inst/js/`; `htmlwidgets` to Imports.

### 11.2 What the measures found

| Question | Result |
|---|---|
| Why the legend differed (4.5) | `recorder.js` ignored `drawImage()`'s **source rectangle**: vis.js keeps each icon in a detached 36 x 25 canvas, four copies side by side (25, 12, 6, 3 px: a mipmap), and draws one region of it with the nine-argument form; the whole pyramid was squeezed into each icon (11 of 11 on the feature pedigree). Each such canvas is itself drawn from the original `Image` whose `src` is the picture's SVG data URI, so the recording layer can read it back. |
| The legend's pictures | all 11 sources are `width='50' height='50'` with **no `viewBox`** (so the layer adds one; the two image functions in copied files, `R/deceasedSlash.R` and `R/affectedConditions.R`, are not changed): written as vectors or as cropped rasters the match at 100% is the same, below. |
| Text baselines | canvas and SVG both put a text baseline on a whole pixel, canvas to the nearest (a tie down), SVG by its own rule: `dominant-baseline="central"` (the prototype's) sits 1 px below canvas `middle` and `middle` matches only where y is under .5; every label here has a scaled transform and a `hanging` or `middle` baseline. Reading `ctx.measureText(t).alphabeticBaseline` (Chrome: -10.859 for `top`, -10.400 `hanging`, -3.859 `middle`, 3.000 `ideographic`, 14 px Arial, **not scaled** by the transform, and the opposite sign to the spec's wording) gives the alphabetic y = y - alphabeticBaseline x scale; rounding it to the nearest pixel then matches canvas. |
| The title | "Sex" is `div#legend_main...` above the legend canvas (the canvas starts 16 px lower, 91 against 75): written as a `<text>` from its computed style and box. |
| Legend, differing ink | four animals: prototype 10.4%, crop 8.1%, vector 8.1%, +title 5.3%, +measured baselines **0.0%** (76 pixels, 1.9%, differ by more than 40). Feature pedigree: prototype 14.0%, crop 6.4%, vector 6.5%, +title 5.0%, +baselines 2.2%, +round to nearest **0.2%** (13 of 7,371; crop 0.1%). Rounding up and half down gave the same 13: no ties; rounding down 8.1%. |
| The drawing | feature 0.4% (49 of 13,198; prototype 0.5%), four animals 0.0%, the 375 animals 4.2% (957 of 22,702; hairlines, as 4.3). |
| Vector against raster | the same at 100% (legend 0.2% against 0.1%); 4 times enlarged the rasters are visibly blurred and the vectors sharp; the feature file 64,050 B against 73,550 B. |
| The 12 typed shapes (`.matesShapes()`, 2-7 animals) | **0 of their ink pixels differ**, drawing and legend, all 12 (the legend 76 pixels over 40, 1.9%, in each). |
| Style settings, feature pedigree | `direct` edges, `symbolSize` 0.6 and 1.5, `textSize` 0.7 and 1.5, `columnSpacing` and `rowSpacing` 1.5, `lineWidth` 3: drawing 0.2-0.4%, legend 0.2% in all eight (ink and element counts changed, so each setting took effect). |
| Page size in inches | the 18-animal pedigree on 7 x 7 in (672 px): drawing 0.6%, legend 0.8%; the 375 animals on 14 x 7 in (1,344 x 672 px) at label limit 0: 561 `<text>`, 545 of them ids, drawing 6.6% (hairlines), legend 5.3%. |
| Size of the picture box | defaults: four animals 960 x 491 px (10 x 5.1146 in), feature 960 x 961.25 (10 x 10.013 in); a widget set to 672 x 672 px gives 672 x 654.391: the box is not the widget's size (500 px high gives 491, 995 gives 961.25, 672 gives 654.391; the cause was not worked out), and the legend canvas starts 16 px below the main one, under its title. |
| Ids, 375 animals | at vis.js's default limit **0 id texts** (16 texts, the legend's); with `nodes.scaling.label.drawThreshold = 0` set by `visNodes(w, scaling = list(label = list(drawThreshold = 0)))` on a copy, **545 id texts, 375 distinct** (S68's numbers, reproduced). |
| `edgeStyle` | see 11.1, 2. |
| `Imports` weight | `chromote` as Imports adds 13 packages (chromote, curl, later, processx, promises, websocket, withr, zip, Rcpp, ps, otel, cpp11, AsioHeaders), about 32 MB installed, 7 compiled (curl, later, processx, websocket, zip, Rcpp, ps; websocket 7.9 MB); `htmlwidgets` adds 0 (it is in `visNetwork`'s closure: 31 packages today). |
| The wait | a quiet-time signal (the last canvas call 300 ms ago, both canvases drawn) took 0.31-0.33 s (7 polls of 50 ms) against the prototype's fixed 8 s; the SVG read then was identical to one read 5 s later (2 of 2: feature, 375 animals). Whole pipeline: save 0.04 s, a new Chrome 0.77 s (0.06 s when one is running), load 0.09-0.15 s, read 0.01-0.04 s. |
| A stuck page | `Runtime$evaluate(..., timeout_ = 3)` on a page that never returns from JavaScript raised "Chromote: timed out waiting for response to command Runtime.evaluate" at 3.01 s and the session closed in 0 s; a server that accepts and never answers made `Page$navigate()` itself wait out chromote's 10 s command timeout, then `loadEventFired(timeout_ = 3)` failed with an internal error (`could not find function "deregister_callback_fn"`, 13.01 s in all). `parent$close()` leaves no Chrome process (0 before and after). |
| A device scale factor of 2 | canvases are 2 times wider than their CSS width and the recorded drawing 2 times too large (font 18.881 against 9.441) inside the same box: the layer must scale each canvas by its CSS width over its pixel width. |
| Another reader | librsvg 2.63.3 (`rsvg-convert`) renders the feature file 0.1% different from Chrome's (drawing and legend), the legend's nested SVG pictures included. One file, one reader. |
| The layer | 239 lines, 13,765 B, 9 backslashes (5 lines), 77 lines over 80 columns; the seven existing drawing scripts are R strings in `R/`. |

### 11.3 What G16a builds (the plan for GREEN)

`savePedigreeDiagram()` in `R/savePedigreeDiagram.R`: (1) checks, in order, `diagram` (a `visNetwork` widget),
`file` (one string; the folder exists; the ending `.svg`, case ignored; `.pdf` and `.png` named as not yet written;
any other ending naming the three), `width` and `height` (NULL or one positive finite number); (2) `chromote` installed,
Chrome found (`chromote::find_chrome()`); (3) a copy of the widget with the label limit 0 and, when given, the size
(`width * 96` px wide, `height * 96` px high); (4) saves it with `htmlwidgets::saveWidget(selfcontained = FALSE)` to a
folder it removes; (5) its own `chromote::Chromote$new()` (not the tests' shared one), `default_timeout` raised as the
shared helper does for macOS CI's first launch, a `ChromoteSession` with `Page$enable()` first, the layer from
`inst/js/` injected, navigate; (6) polls `Runtime$evaluate()` against one deadline (the option
`pedkindraw.saveTimeout`, 60 s by default; the tests set it) until both canvases have drawn, the last canvas call is
300 ms old and every legend picture has loaded (the logic of `.waitForLegendPictures()`,
`tests/testthat/helper-legendPictures.R:15`); (7) reads `window.__svg()` and writes the file (UTF-8); (8) closes the
session and the browser on every path. The internal `.recordDiagramSvg(diagram, timeout, scaleFactor = 1)` does 5-7 and
returns the SVG and its box, so a test can record an unchanged widget (0 ids) or a scale factor of 2. The SVG's root has
`width` and `height` in inches (the page given, or the box's pixels over 96) and a `viewBox` of the box, the
drawing scaled to fit by `preserveAspectRatio` `xMidYMid meet`.

### 11.4 RED's tests, each value computed with the scratch layer first (Learning 18)

No Chrome (cheap, run on CRAN): `diagram` not a widget (NULL, a list, a data frame, the layout list, a string); `file`
not one string (NULL, NA, two strings, a number); an ending not `.svg`, `.pdf` or `.png` (`x`, `x.txt`, `x.jpg`); `.pdf`
and `.png` "not available yet"; `width` and `height` each not a positive finite number (0, -1, NA, Inf, "7", two numbers);
the folder of `file` missing; `chromote` not installed and Chrome not found (`mockery::stub()` of
`requireNamespace` and `chromote::find_chrome`). Messages: "requires 'diagram' to be", "requires 'file' to be one",
"to end in .svg, .pdf or .png", "not available yet", "requires 'width' to be NULL or one positive number", "folder",
"needs the 'chromote' package", "could not find Google Chrome".

Chrome (`skip_if_no_chrome()`, `skip_on_cran()`): the four-animal help case writes a file that Chrome loads as an SVG
document (root `svg`, no `parsererror`), root `width="10in"`, `height` agreeing with the `viewBox` and between 300 and 500 px (measured 491 px, 5.1146 in; the test does not state the machine's 491), returns the path invisibly, and an
ending in capitals (`X.SVG`) works; the ink comparison (method above) on the four animals and the 12 typed shapes,
**differing ink at most 0.5%, drawing and legend, measured 0.0% in all 13**, on the feature pedigree **at most 1.0%,
measured 0.4% (drawing) and 0.2% (legend)** (14 cases compared, `expect_equal(length(...), 14L)`); the feature file
holds 11 `<image>` elements, every `href` beginning `data:image/svg+xml`, none `data:image/png`, and a `<text>` "Sex";
the 375 animals: 545 id texts, 375 distinct (the ids found among the `<text>` contents), and `.recordDiagramSvg()` of
the unchanged widget 0; `width = 7, height = 7` gives root `7in` by `7in` and a `viewBox` 672 wide; a scale factor of 2
gives the same box and a drawing within 1.0% of the live widget's (measured 0.00% for the four animals, 0.54% for the feature pedigree; its legend, 9.8% and 5.5%, is not compared, dragon 17); the widget is `identical()` before and
after, and the temporary folder is gone; the option set to 0.01 s stops "did not finish drawing within"; a widget whose
page never returns from JavaScript (`htmlwidgets::onRender()` with a loop), the option 3 s, stops with the same message
within 20 s. The pixel bounds were measured on macOS, Chrome 157: Linux and Windows text rounding may differ (dragon 20).

### 11.5 Dragons found in G16a's measures

13. **A canvas `drawImage()` has a source rectangle** (the nine-argument form): a recording that takes the whole source
    squeezes vis.js's mipmap pyramid into each icon. The same canvas's own `drawImage()` calls hold the original picture.
14. **Canvas and SVG round a text baseline to a whole pixel by different rules, and `middle` is not `central`.** Read
    `measureText().alphabeticBaseline` (opposite sign to the spec's wording, unscaled by the transform), write every
    label with an alphabetic baseline, round the y to the nearest pixel. A test with one label cannot show it: the first
    micro test gave 4 cases right by luck; the cases that failed were rows whose y was .5-1.0.
15. **A screenshot window shorter than the widget is blank below it**: S68's legend figures (11.7-22.7%) and the
    first runs of S69 counted that blank as difference (the rows below 620 px "3 px off"). Check what the photograph
    holds before reading a difference, and state the window's size with the number (dragon 2 had the width; this is the
    height).
16. **chromote 0.5.1's event timeouts are not reliable**: `Page$navigate()` waits out the 10 s command timeout on a
    server that never answers and `loadEventFired(timeout_ =)` then fails with an internal error. Poll
    `Runtime$evaluate(timeout_ = )` against one deadline of your own, and close the parent (its own Chrome).
17. **A device scale factor other than 1 doubles the recording**: scale each canvas by CSS width over pixel width, with
    6 decimals (3 turned 0.4996 into 0.5, 0.2 px across the legend). At 2 the drawing still matches the live widget
    (0.00%) and the legend does not (9.8% for four animals, 5.5% for the feature pedigree): its labels round to a half
    CSS pixel, the canvas's own pixel at 2 ("Female" at y 56.5 against 56 at 1), which moves the anti-aliasing of
    all its text; the scaling itself is right (`scale(0.5 0.5)`). The function pins the factor to 1, so a user never
    meets it; the test compares the drawing only.
18. **The legend's pictures load after the first draw** (an image node's `imageObj.width` is 0 until it loads): wait for
    them as well as for quiet, as `.waitForLegendPictures()` does.
19. **The picture's box is not the widget's size** (11.2: 500 px high gives 491, 995 gives 961.25, 672 gives
    654.391; the cause was not worked out) and the legend canvas starts 16 px below the main one, under its title; the
    SVG's root takes the page in inches and the `viewBox` the box, so a page 7 x 7 in holds a drawing 7 x 6.8166 in,
    centred. Never size a test's expectation from the widget's height: measure the box.
20. **The pixel bounds are one machine's** (macOS, Chrome 157, the same Chrome's canvas and SVG text rules): read each CI
    job's result for the new tests (Linux, Windows) before trusting a bound; a different rounding there is a finding,
    not a reason to widen a bound unread.
21. **A scratch layer that passes is not the layer: validate RED against a reference first.** The RED file was run
    against a scratch implementation built from the measured prototype (not committed) before RED was written to the
    repository: it found four faults in the *tests* (an R `NULL` sent to the page as `[]`, truthy in JavaScript, made the
    root `width="NaNin"`, so Chrome drew the SVG at 300 x 150 and the ink comparison read 86%; a font-size compared
    across scale factors that is the same size at `font-size="28"` in a group scaled 0.5; a stuck-page widget whose
    loop started at 500 ms, which races the first quiet window, now 50 ms) and one in the *prototype*:
    `dominant-baseline="[object Object]"` on every label, a ternary's precedence. Chrome ignores the invalid value and
    takes the alphabetic default, which is what the measures measured. GREEN writes `alphabetic`.
22. **chromote leaves 4 small files in `tempdir()` after `parent$close()`** (`chrome-*-stderr.log`, `chrome-*-stdout.log`
    and two `supervisor_*` pipes): a test cannot require `tempdir()` to be unchanged; it checks the function's own
    folder (`pedkindraw-save-*`) is gone, also after an error.

### 11.6 What G16a delivered, and what G16b inherits (S69)

**Delivered** (commits: claim `bbb3b04`; picks and measures `8d3834a`; RED `3bc62dc`; GREEN `35932ac`, `7418f9c`,
`71409eb`; REFACTOR `dc672f2`): `savePedigreeDiagram(diagram, file, width, height)` in `R/savePedigreeDiagram.R`, with
`.recordDiagramSvg()`, `.checkInches()`, `.waitUntilDrawn()`, `.secondsLeft()` and `.widgetPixels()`, and the layer
`inst/js/recordCanvas.js`; `htmlwidgets` in Imports; the help page, NEWS, the site index, the contract's row, the
`files` case's probes. Tests: `tests/testthat/test_savePedigreeDiagram.R`, 18 tests (8 need no browser, 10 start Chrome),
143 expectations, about 56 s; the full suite 83 files, 1,041 tests, 16,210 expectations, 0 failed, SKIP 0, WARN 0 (447 s);
`lint_package()` 0; `covr` 100 of 100 lines of the new R file; drift 91 / 23 / 0; fidelity 600 of 600; `R CMD check
--as-cran` 1 NOTE (the new submission), tests 175 s.

**Measured on the real code, all 14 cases of the ink comparison** (over the pixels not white in either picture, a
channel differing by more than 100): the four animals and the 12 typed shapes, 0 of 892-4,207 drawing pixels and 1 of
3,926 legend pixels (0.03%); the 18-animal pedigree with every mark, 33 of 12,507 (0.26%) and 5 of 7,261 (0.07%).
Section 4.3's prototype figures are superseded for the four animals, the shapes and the feature pedigree (drawing and
legend); the 375 animals' drawing was not re-measured on the real code (the scratch layer's 4.2%, hairlines, stands as
a prediction, Learning 18).

**Found in GREEN, not in the measures:** a canvas is painted at whole device pixels and not stretched, so each canvas is
written at its box snapped to whole device pixels and scaled by 1 over the device pixel ratio (dragon 91 of the gaps
plan); the scratch reference's 3-decimal rounding had hidden it. **Miscounts of mine, corrected:** chromote's
dependencies are 7 compiled packages, not 8 (R143 and 11.2 say 7); of the 18 tests 8 need no browser, not 9.

**G16b inherits:** the layer writes an SVG whose root is the page in inches (`width`, `height`) with a `viewBox` of the
canvases' box, so Chrome's `Page.printToPDF` of that file at the same size is the PDF, and a screenshot of the SVG
document at `scale = dpi / 96` is the PNG; the recorded drawing itself stays at a device scale factor of 1 (at 2 the
legend does not match the live widget, 9.8%, dragon 17, so never record at the PNG's resolution). The function starts its
own `Chromote` and closes it on every way out; G16b's second Chrome use (printing) can reuse that session inside
`.recordDiagramSvg()` or start another, a choice for its pre-RED picker. The box is not the widget's size (dragon 19: 500
px high gives 491, 995 gives 961.25, 672 gives 654.391, cause not worked out): the page rule's "what the drawing's shape
leaves of a page" is measured on the box. The PDF's size (5.7 MB for the 375 animals, section 4.4) is still the open
measure of section 7's G16b. The one test of G16a that names `.pdf` and `.png` ("is not available yet") changes in G16b.

---

## 12. G16b's pre-RED measures and picks (pedkindraw S70; R144)

**Date:** 2026-11-21 · **Session:** pedkindraw S70 · same machine (Apple M2 Max, macOS), Chrome 157, chromote 0.5.1;
scratch scripts in the session's scratchpad `g16b/` (may be gone); the three that matter are committed in
`docs/planning/picture-files-prototype/` (`expandDashes.py`, `printPdf.R`, `savePng.R`; prototypes, not package code).

**Method (every figure below).** Each file starts from the real function's SVG (`savePedigreeDiagram()` as G16a left
it, the 375-animal rhesus pedigree, label limit 0, at the page named). A PDF is Chrome's `Page.printToPDF` of that SVG
(paper = the page in inches, margins 0, `printBackground`, `pageRanges = "1"`) after two animation frames; it counts
as complete when `pdfinfo` reads 1 page and `pdftotext -bbox` reads 567 words (545 ids and the legend's words).
Picture differences: `pdftoppm` of each PDF at 150 and 300 dpi (the whole page), and a 300 x 160 px crop at 1,200
dpi (x 3,350, y 3,540: a stretch of the repeat-animal edges beside three animals); "ink" is a pixel not white in either
picture, and it *differs* when a colour channel differs by more than 100.

### 12.1 Mark's picks (R144), each first time, all the recommended option

1. **The page when none is given:** 10 in wide, the widget's own size, as `.svg` has it since G16a; one default for
   all three kinds of file. (The others: 7 x 7 in like kinship2; US letter landscape 11 x 8.5 in; both would change
   the `.svg` default too.)
2. **The PNG's dpi when none is given:** 300. (The others: 150; 96.)
3. **The PDF's size:** write each dash as a short stroke (5.77 MB to 1.04 MB), for the PDF only; `.svg` and `.png`
   unchanged. (The others: those lines solid, 0.37 MB; flat ends on the dashes, 2.14 MB; leave as Chrome writes it.)

### 12.2 What the measures found

**Why the PDF is 5.77 MB.** The 375 animals' PDF at 14 x 7 in is 5,770,567 B (the 4 animals at 7 x 7 in: 91,265 B).
One drawing stream is 5,566,634 B of it (96.5%; 15,482,574 B inflated, 198,198 curve, 90,510 line and 48,000 move
operators against 2,111 strokes). The cause is the dashes: 170 paths (quadratic curves, `stroke-dasharray="0.319
0.319"`, width 0.3, round ends: the repeat-animal edges) hold about 52,470 dashes in 34,145 units of dashed length, and
Chrome's PDF writer bakes each dash into a closed outline (`m l c c c c ... h`), where a solid stroke is one operator
(three more dashed paths are legend rows). The three fixes of section 7 do not touch it:

| Variant (375 animals, 14 x 7 in) | PDF bytes | ink differing at 150 dpi | at 300 dpi | at 1,200 dpi, the crop |
|---|---:|---:|---:|---:|
| as Chrome writes it | 5,770,567 | | | |
| numbers in paths to 1 decimal | 5,770,665 | 0.62% | 2.30% | not measured |
| strokes of one style joined (4,460 paths) | 5,769,710 | 0.00% | not measured | not measured |
| no clip paths | 5,770,505 | 0.00% | not measured | not measured |
| flat ends on the dashes | 2,141,283 | 0.07% | 3.01% | 7.32% |
| every dashed line solid | 357,178 | 0.55% | not measured | not measured |
| solid where the round ends close the gaps (the 170 lines) | 367,062 | 0.02% | 0.10% | 7.57% |
| that, with digits, joined strokes and no clip | 366,804 | 1.51% | 2.50% | not measured |
| **each dash a short stroke (`expandDashes.py`)** | **1,038,369** | 0.00% | 0.03% | 11.22% |

Every one of the nine is 1 page and 567 words. Viewed at 1,200 dpi (a crop of the edges): the baseline's repeat-animal
edges are dotted lines; the solid variant draws them solid (the "same animal, again" marking lost at that zoom); the
short-stroke variant keeps the dotted look with the dots a little differently placed along the line (its 11.22% is
that, not a different drawing). Time: record 1.6 s (the real function, 375 animals at 14 x 7 in), a new Chrome and the
SVG's load 0.85 s, the two frames 0.05 s, the print 0.59 s as written, 0.16-0.18 s with short strokes, 0.09 s solid.
The page sizes `pdfinfo` reads: 14 x 7 in 1008 x 504 pt, 7 x 7 in 504 x 504 pt, a page asked at 6.8 in high 720 x 490.08
pt.

**A PDF printed right after the load event can be cut short.** The segments SVG's first print was 489 KB, 1 page, 21
words (the animals' shapes, ids and the legend's title missing, the edges and legend rows there); the same file after
a 2 s wait, 1.04 MB and 567 words; after `Runtime.evaluate` of a promise on two `requestAnimationFrame`s with
`awaitPromise`, 1,038,369 B and 567 words in 3 of 3 runs (and the baseline's, 5,770,567 B, 3 of 3), 0.05 s. The nine
other files (the baseline and eight variants) printed complete without any wait, so the fault depends on timing.

**The page** (the real function's SVG header, three pedigrees; the box is the widget redrawn at the page's size): the
box fills 100.0% of a default page and 97.4% (7 x 7 in), 97.0% (11 x 8.5 in), 96.5% (8.5 x 11 in) and 97.0% (11.69
x 8.27 in) of the others, the same for all three pedigrees. What stays blank is the drawing's own white space, as in
the browser: the ink is 1.4-2.5% of a page for the 4 animals, 2.6-3.3% for the feature pedigree (18 animals), 4.1-8.7%
for the 375 animals (8.7% on the default page); the drawing's ink is 15.8-26.5% of the page's width for the 4 animals
and 65.3-65.8% for the other two (the legend is the right 28%), and 12.3-30.8% of the page's height for the 375 animals
(30.8% on the default page, 16.1% on 7 x 7 in), 19.1-34.7% for the feature pedigree, 21.8-46.6% for the 4 animals.

**The PNG** (a screenshot of the SVG document, clipped to the page, `scale = dpi / 96`; the default page, 10 x 5.11 in
typed): 96 dpi 960 x 491 px, 56,001 B, 0.05 s; 150 dpi 1,500 x 767, 102,080 B, 0.26 s; 300 dpi 3,000 x 1,533, 238,454 B,
0.10 s; 600 dpi 6,000 x 3,066, 552,108 B, 0.25 s; 1,200 dpi 12,000 x 6,132, 1,363,168 B, 0.99 s; 2,400 dpi 24,000 x
12,264 (294 megapixels), 3,129,464 B, 2.51 s: no limit met. The 4 animals: 16,568, 29,932 and 68,285 B at 96, 150 and
300 dpi; the 18-animal pedigree (10 x 10.01 in): 40,029, 69,762 and 162,342 B. The 375 animals' ids are unreadable
specks at 300 dpi and read at 1,200 dpi. Pixels are the page in inches times dpi.

### 12.3 What G16b builds (the plan for GREEN; every number a prediction until the real code runs, Learning 18)

- `savePedigreeDiagram(diagram, file, width = NULL, height = NULL, dpi = 300)`: `dpi` a positive finite number,
  checked for every kind of file, used for `.png` only (the help says so).
- `.svg`: as G16a. `.pdf`: record with the dashes written as short strokes (`window.__svg()` takes a third argument,
  `expandDashes`: each dashed line's path flattened, cut along its length into dashes, each an `M L` with the round
  ends and the colour kept, the `stroke-dasharray` dropped), write the SVG to the function's own folder, open it in a
  second session of the same Chrome, wait two animation frames, `Page.printToPDF` (paper = the page in inches, margins
  0, `printBackground`, `pageRanges = "1"`), write the bytes. `.png`: record as for `.svg`, load it, wait two frames,
  `Page.captureScreenshot` clipped to the page at `scale = dpi / 96`.
- The page left out is the box's own size over 96 pixels per inch (G16a's rule), for all three kinds.
- The `files` case's DONE (section 7), with the 375-animal PDF's bound at 1.5 MB (the measured 1.04 MB with room:
  Chrome's writer changes, dragon 12).

### 12.4 Dragons found in G16b's measures

23. **A dashed line costs a PDF one outline per dash.** The size follows the number of dashes, not the paths or the
    digits (section 12.2's table): 170 lines gave 52,470 dashes and 5.57 MB. A pedigree with more repeat-animal edges
    is larger still. Count a drawing's dashes before promising a PDF size.
24. **Print after the page is painted, not after it loads**, and read the PDF's words, not its size: a print that lost
    the animals' shapes and ids was 489 KB, and a test that only reads the size would have taken it for a better fix.
25. **Chrome rounds the paper:** a page asked at 6.8 in high came out 490.08 pt (489.6 expected, 0.48 pt over; the
    cause was not worked out); 14 x 7 in and 7 x 7 in were exact. DONE's "within 1 pt" held in both.

---

## 13. G16a's CI repair: the two faults found in S69's push (pedkindraw S70; R145)

**Date:** 2026-11-21 · **Session:** pedkindraw S70. Claimed as G16b; after G16b's picks and measures (section 12,
`ff862e5`) S69's push (`1d0e00a`, run 44986823915) was read job by job and found red, and Mark chose "Repair CI first;
G16b next session (Recommended)". Section 12 stands unchanged for G16b.

**What GitHub showed.** ubuntu-latest (devel): fails in setup-r-dependencies ("unable to load R code in package
‘S4Vectors’": the known fault of S56-S69, not a check). macOS (release, R 4.6.2): `checking examples ... ERROR`; tests
FAIL 0, WARN 0, SKIP 0, PASS 16,210. ubuntu-latest (release) and (oldrel-1, R 4.5.3): `checking examples ... ERROR`
and tests FAIL 13, WARN 0, SKIP 2, PASS 16,186: all 13 in one test (`test_savePedigreeDiagram.R:188`), each "legend ink
differing, percent <= limit: 1.6 > 0.5" (the 4 animals and the 12 typed shapes; the feature pedigree passes at its bound
of 1.0; the drawing passes everywhere). Windows (release): still running when this was written (read at close-out).
Neither showed on the Mac: S69's local `R CMD check --as-cran` ran without `NOT_CRAN`, so the example and the 10 Chrome
tests skipped, and the full suite by hand ran on macOS, where the legend matches.

### 13.1 Mark's picks (R145), each first time, all the recommended option

1. **The example:** it runs only in an interactive session (a person typing `example(savePedigreeDiagram)`), never in
   `R CMD check`, and a new quality gate runs the check's examples with GitHub's settings. (The others: the same
   change with no gate; `\dontrun`. Not offered: closing chromote's pipes ourselves, because the only way,
   `processx::supervisor_kill()`, "terminates all supervised processes and the supervisor process itself": every
   browser the user's session has running.)
2. **The Linux legend:** the test file's photographs are taken by a Chrome of its own started with
   `--disable-lcd-text`. (The others: compare brightness instead of colour channels; widen the bound to 2%.)

### 13.2 What the measures found

**The example.** Reproduced on this Mac: `NOT_CRAN=true _R_CHECK_CONNECTIONS_LEFT_OPEN_=true R CMD check --no-tests
--no-manual --no-vignettes --no-build-vignettes --ignore-vignettes` gives `checking examples ... ERROR  connections left
open: .../supervisor_stdin... (fifo) .../supervisor_stdout... (fifo)`; without the variable, `OK`. Two pipes stay open
after the first `savePedigreeDiagram()` call of an R session and stay at two over later calls (`showConnections()`):
chromote starts Chrome through processx with `supervise = TRUE`, and processx keeps one supervisor per session. With
the guard `interactive() &&` in place of `identical(Sys.getenv("NOT_CRAN"), "true") &&` the same check reads `OK`;
build and check together take 28 s. testthat does not check connections: macOS's tests passed.

**The legend on Linux.** Reproduced in a container (`tools/linux/`: Ubuntu 26.04.1, R 4.6.1, Google Chrome
158.0.8127.36 for arm64; GitHub's runner is x86-64 on the same Ubuntu): the four animals' legend differs 1.57% (61 of 3,881
ink pixels) and the drawing 0%, as on GitHub (1.6%); the whole test file reads 18 tests, 143 expectations, **13 expectations failed**,
all in the one test, as GitHub's FAIL 13; the other 17 tests pass on Linux. The 61 pixels lie along the legend's rows (y 66 to
387; none in the title). The pictures show the cause: on Linux the live widget's canvas text is grey, and the SVG
document's text photographed by the same Chrome has coloured (LCD) edges, so the same letters differ in colour channels
(macOS: 1 pixel). It is a property of the photograph, not of the file. The three ways, on those pictures:

| The test's way | Linux legend differing | macOS | Test file on Linux |
|---|---:|---:|---|
| as it is (colour channels, bound 0.5%) | 61 pixels, 1.57% | 1 pixel, 0.03% | 13 expectations failed |
| Chrome started with `--disable-lcd-text` | 0 pixels, 0% (drawing 0%) | unchanged | 0 failed of 18 tests, 143 expectations |
| brightness instead of colour channels (difference over 100) | 0 pixels | 0 pixels | not run |

With a Chrome of its own (not the shared one) three Chrome test files run together on Linux read 42 tests, 604
expectations, 0 failed. Setting the flag with `chromote::set_chrome_args()` after the shared Chrome exists changes
nothing for that Chrome: other files (`test_carrierMark.R` to `test_symbolSize.R`) start it before
`test_savePedigreeDiagram.R` runs.

### 13.3 The plan for RED and GREEN (every number a prediction until the real code runs, Learning 18)

- **RED:** the gate `examples-no-open-connections` (`methodology/.quality-gates.json`, max 0, command
  `tools/checkExamples.sh`, which builds the package in a scratch folder and runs `R CMD check`'s examples with
  `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true`, printing the count of ERRORs; it reads 1); one new test in
  `test_savePedigreeDiagram.R` that photographs a line of text through `.saveChromeSession()` and expects every ink pixel
  grey (it fails in the Linux container, where the shared Chrome draws LCD text, and passes on macOS, which has none).
- **GREEN:** the example's guard (`R/savePedigreeDiagram.R`, `man/`); `.saveChromeSession()` makes a Chrome of its own
  with `--disable-lcd-text`, closed after the suite. Checked by: the gate 1 to 0; `tools/linux/runTests.sh
  savePedigreeDiagram` 0 failed; the full suite on this Mac; lint; roxygen; the push's five jobs.

### 13.4 Dragons found in the repair's measures

26. **Run the DONE check the way GitHub does.** `R CMD check` without `NOT_CRAN=true` skips the Chrome example and tests,
    and without `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` does not see chromote's two open pipes; S69's "1 NOTE" was true of a
    check that skipped both. An example or vignette chunk that starts Chrome must not run in `R CMD check` (G16c's
    vignette chunks: not measured whether the vignette step has the same check).
27. **On Linux Chrome draws SVG text with coloured LCD edges and canvas text in grey** (macOS draws neither). Any pixel
    comparison, and any PNG file, made from an SVG's text needs `--disable-lcd-text` in the Chrome that photographs it:
    G16b's PNG, in the function's own Chrome (the PDF is vector and has no such edges). Windows: not measured here.
28. **A Linux box to reproduce GitHub's Ubuntu jobs:** `tools/linux/Dockerfile` and `runTests.sh`. Ubuntu's own
    `r-cran-*` packages are built for R 4.5 and do not load in R 4.6 (`rlang.so: undefined symbol: SETLENGTH`), so every
    R package in it is compiled from CRAN source. It reproduced GitHub's 1.6% as 1.57% and FAIL 13 as 13.
29. **A Chrome flag set after the shared Chrome exists does not reach it:** the test file needs a Chrome of its own.
