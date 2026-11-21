# Phase G16: picture files from a script, and a whole large pedigree on one page (gaps A1 and A2) -- the plan

**Date:** 2026-11-21 · **Session:** pedkindraw S68 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; failure mode #18: this session writes no package code; the one code file it adds is a measured
prototype, section 10). **Governs:** Phase G16 of `docs/planning/gaps-and-shared-code-plan.md` (section 5.1, G16's
row), gaps A1 and A2 of `docs/research/pedkindraw-gaps-2026-11-18.md` (section 3). **Ruling made here:** R142 (Mark's
three picks, `docs/planning/standalone-pedigree-package-plan.md` section 2). **Status:** plan written; no build
session started.

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
| the same three | legend | 4,282 / 7,887 / 4,282 | 11.7% / 22.7% / 11.7% (38.9% / 55.3% / 38.6%) |

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

### G16a -- the recording layer and the SVG file (one session; two if the legend takes it)

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

### G16b -- PDF and PNG, and the page (one session)

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
