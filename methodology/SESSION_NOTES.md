# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G15 DONE (S42-S67).
**G16a DONE in S69 (R143):** `savePedigreeDiagram(diagram, file, width, height)` writes the widget as an SVG file
(`R/savePedigreeDiagram.R:69`; the recording layer `inst/js/recordCanvas.js`); `.pdf` and `.png` stop "is not
available yet". G16b (the PDF, the PNG and the page) and G16c (the whole large pedigree on one page and the
documents) follow, then G17 (an app, a planning session first), then 17g.
**Next: G16b** (`docs/planning/picture-files-plan.md:281`; what it inherits, section 11.6 `:529`), strict TDD: first
its pre-RED measures, then its pre-RED picker, then RED, GREEN, REFACTOR by the gates (each an `AskUserQuestion`).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S69's commits are pushed
at close (Mark's standing pick, a memory).
**The orient picker:** G16b (recommended: the plan's order, R97). Also, from `methodology/BACKLOG.md`: READY, the
narrow legend (`:64`), the drawing vignette's measured trait (`:74`), the `smallPed` fixture (`:97`), rewording
`DIVERGENCE.md`'s older rows (`:46`), tests for full coverage (`:103`), `findPedigreeNumber()`'s speed (`:242`), and
the seven "Ready, small" items (`:168`, `:180`, `:187`, `:196`, `:206`, `:223`, `:229`); NEEDS DECISION, a converted
Pedixplorer object's `avail` (`:80`), long names at the edges (`:88`); "Waiting on Mark", the dashboard not seeing
`methodology/BACKLOG.md` (`:143`), copying nprcgenekeepr's colony overview (`:150`), an animal with two or more mates
drawn once between them as kinship2 draws it (`:157`). BLOCKED, and so not offered: `:11`, `:55`, `:137`. Name every
item in the picker (memory "Picker sets: name items, include all"); S69's orient picker had four options and was
answered at once. Each title was checked at its cited line when S69 oriented (22 of 22 held).
**Session boundary:** one session, G16b, then close out.
**Priority:** HIGH (G16b-c, G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S69 added a function in a file of its own and
   changed no copied one); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at
   `3e06730c5`, tree clean, through S69.
2. Check S69's push (R/, inst/, tests/ changed, so both workflows run). An estimate, not measured: CI fails on Ubuntu
   R-devel only (S4Vectors in "setup-r-dependencies", S56-S69), the other four `success`, Ubuntu release FAIL 0, WARN 0,
   SKIP 2, PASS **16,199** (S68's run read 16,056; plus the 143 new expectations, if the 10 browser tests run there).
   **The risk:** the pixel bounds of `test_savePedigreeDiagram.R` were measured on macOS, Chrome 157 only (the picture
   plan's dragon 20): read that file's result job by job; a different text rounding on Linux or Windows is a finding to
   measure, not a bound to widen unread. `gh run list --limit 6`.
3. **G16b**, by `docs/planning/picture-files-plan.md` section 7 (`:281`) and 11.6 (`:529`). Read, in order: the plan's
   G16b, dragons 8-12 (`:345`-`:356`) and 11.5 (`:487`); `R/savePedigreeDiagram.R:129` (`.recordDiagramSvg()`) and
   `inst/js/recordCanvas.js:301` (`window.__svg()`). Then the plan's **measure-before-picker list** on a scratch copy
   (Learning 17): the PDF's size (5.7 MB for the 375 animals, kinship2's 0.1 MB) under three fixes (fewer path
   numbers, joined strokes of one style, no clip path where a shape needs none) and each fix's effect on the
   picture; the defaults for `width`, `height` and `dpi` (kinship2's PDF is 7 x 7 in); what the drawing's shape
   leaves of a page (measure the **box**, dragon 19, not the widget's size); the PNG route's size and time at 96,
   150 and 300 dpi. Then the pre-RED picker (the defaults; what a page the drawing does not fill looks like; the PDF's
   size fix), each option with its measured counts, in plain words (Learnings 1-2). **Mark's three R142 picks and
   R143's four are made: do not re-ask them.**
4. TDD: declare the phase at the top of every response; each transition (`PRE-RED->RED`, `RED->GREEN`,
   `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format"). Every number in the plan's section 4 and
   11 is a prediction until the real code runs (Learning 18). **Run the RED file against a scratch reference
   implementation before committing it** (the gaps plan's dragon 89: S69's found 4 faults in its tests and 1 in the
   prototype in an hour).

### Gotchas
- **The photograph's window:** a screenshot is blank beyond the window, in height as in width. Use a window as tall
  as the widget or `captureBeyondViewport = TRUE`, and state the window's size beside every figure from a photograph
  (the picture plan's dragon 15, the gaps plan's 90). `tests/testthat/helper-savePedigreeDiagram.R:201`
  (`.saveInkDiff()`) is the photograph-and-compare the tests use.
- **Never record at the PNG's resolution:** `.recordDiagramSvg()` pins the device scale factor to 1 (its argument
  exists for a test); at 2 the legend differs 9.8% from the live widget (dragon 17). A PNG is a screenshot of the
  written SVG document at `scale = dpi / 96`.
- **A canvas is painted at whole device pixels, not stretched** (`inst/js/recordCanvas.js:297` `snap()`, `:326`): scale 1
  over the device pixel ratio, the box snapped; do not "improve" it to CSS size over pixel size (legend 1.10% against
  0.03% of ink differing; the gaps plan's dragon 91).
- **chromote 0.5.1:** the function starts its own `Chromote$new()`, raises `default_timeout` to 60 s for a first launch
  (macOS CI), polls `Runtime$evaluate(timeout_ = )` against one deadline (`.waitUntilDrawn()`, `R/savePedigreeDiagram.R:244`);
  `Page$navigate()` waits 10 s on a server that never answers and `loadEventFired(timeout_ = )` then fails with an
  internal error (dragon 16); chromote leaves 4 small files in `tempdir()` after closing (dragon 22); the stderr line
  `[warning] got non-close frame while closing` is the websocket package logging when a browser with a stuck page
  closes, not an R warning (WARN stays 0).
- **The picture's box is not the widget's size** (500 px high gives 491, 995 gives 961.25, 672 gives 654.391; the cause
  was not worked out, dragon 19); the SVG's root takes the page in inches and the `viewBox` the box.
- **G16a's test of ".pdf and .png are not available yet"** (the 4th test of `test_savePedigreeDiagram.R`, with 5
  expectations) changes in G16b; `savePedigreeDiagram()` refuses them at `R/savePedigreeDiagram.R:83`.
- **The tests:** 18 in `test_savePedigreeDiagram.R`, 8 need no browser (they run on CRAN), 10 start Chrome (about 56 s;
  `skip_on_cran()` and `skip_if_no_chrome()`); `mockery::stub()` needs `savePedigreeDiagram()` itself to call
  `requireNamespace()` and `chromote::find_chrome()`. The option `pedkindraw.saveTimeout` (60 s) is how a test shortens the
  limit; a stuck-page widget must start its loop 50 ms after render (500 ms races the first quiet window).
- **A new example, vignette chunk or test that needs Chrome** is guarded as `savePedigreeDiagram()`'s example is
  (`NOT_CRAN`, `chromote`, a Chrome found; dragon 10); a new export needs `_pkgdown.yml:22`'s "Drawing" group.
- **R has no PDF reader:** `pdftools` is not installed here (the plan's dragon 9: a renv install by name with
  `rebuild = TRUE`, a `dev = TRUE` snapshot, the `renv-lock-no-latest-repository` gate, Learning 3); `pdfinfo` and
  `pdftotext` are Homebrew's, here only. G16b reads a PDF's page count and size with `pdfinfo`.
- **Carried:** both references fail where pedkindraw does not (kinship2's `plot()` on fewer than 3 animals and on
  `twoChildless`, Pedixplorer's `align()` on both; count the cases compared with `expect_gte()`); run Rscript from the
  root (dragon 83) and a scratch copy from its root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to
  renv's library (dragons 83-84); guard every variable in a removal path (dragon 85); dry-run every edit script on a
  `git archive` copy and check new lines' widths; the 5-file cap splits commits; the ratchet's suite gate times out at
  300 s (run the suite by hand, 7.5-9 min); `CLAUDE.md` is over its budget (learnings go to the plans' dragons);
  `pedkindraw.Rproj` untracked, Mark's; the stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:180`; README.md is
  rendered from a scratch install, S52's way); a `cd` into `methodology/` persists (run the ratchet in a subshell);
  `NOT_CRAN=true` for the browser tests; zsh does not split an unquoted `$var` into words (a shell loop over "a b"
  pairs passed one argument: S69 lost a run to it).
- **Ledger sizes:** see S69's receipt (both under the 196,608 B threshold).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/88600065-c9e3-464f-8ca6-fd3387889606/scratchpad/g16a/`,
  may be gone; they `source` each other by that absolute path): `common.R`, `chrome.R`, `drv.R` (one case, recorded and
  compared with the live widget: `Rscript drv.R <case> <width> <recorder.js> <modeJson> <tag>`), `ref_impl.R` with
  `ref_recorder.js` (the scratch reference the RED file was validated against), `run_red_ref.R`, `snap_files.R` (writes
  five files to compare byte for byte before and after a REFACTOR), `real14.R` (the 14-case measure on the real code),
  `recorder2.js` (committed as `docs/planning/picture-files-prototype/recorder2.js`), `p1`-`p12` micro-measures.
  S68's (`.../f5b9e076-db0f-420f-a887-a264f6db4dac/scratchpad/g16/`) are older.
- **Times** (S69's): the full suite 447-522 s; `R CMD check --as-cran` tests 175 s; the fidelity tool 3.4 min; the new
  test file 56 s; one `savePedigreeDiagram()` call about 1-2 s (a new Chrome 0.8 s, the wait 0.3 s); the 375 animals'
  file 847 KB.

### Key files
- G16: `docs/planning/picture-files-plan.md` (`:281` G16b, `:298` G16c, `:321` dragons 1-12, `:397` section 11, `:422`
  11.2 the measures, `:446` 11.3 the design, `:464` 11.4 RED's tests, `:487` 11.5 dragons 13-22, `:529` 11.6 what G16b
  inherits); `docs/planning/standalone-pedigree-package-plan.md:304` (R143), `:93` (Next), `:1351` (G16a's entry);
  `docs/planning/gaps-and-shared-code-plan.md:385` (G16's row), `:855`-`:869` (dragons 89-92);
  `docs/planning/cran-submission-plan.md:716`; `docs/planning/pedkindraw-api-contract.md:137` (the function's row);
  `methodology/BACKLOG.md:26`.
- The code: `R/savePedigreeDiagram.R:69` (`savePedigreeDiagram()`), `:129` (`.recordDiagramSvg()`), `:196`
  (`.widgetPixels()`), `:211` (`.checkInches()`), `:244` (`.waitUntilDrawn()`); `inst/js/recordCanvas.js:175`
  (`drawImage`), `:236` (`text()`), `:277` (`window.__ready`), `:301` (`window.__svg`); `DESCRIPTION:20`
  (`htmlwidgets` in Imports); `NAMESPACE:41`; `_pkgdown.yml:22`; `NEWS.md:265`; `tools/gapCases.R:167` (`files`, the new
  probes `:220`-`:231`), `:235` (`largeIds`).
- The tests: `tests/testthat/test_savePedigreeDiagram.R` (18 tests); `tests/testthat/helper-savePedigreeDiagram.R:163`
  (`.saveChromeSession()`), `:201` (`.saveInkDiff()`); `tests/testthat/helper-legendPictures.R:15`
  (`.waitForLegendPictures()`); `tests/testthat/helper-live-render-positions.R:190` (`skip_if_no_chrome()`).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 70 Did
**Deliverable:** Phase G16b, the PDF and the PNG file (gaps A1 and A2, `docs/planning/picture-files-plan.md:281`):
`savePedigreeDiagram()` accepts `.pdf` and `.png` as well as `.svg` (IN PROGRESS), strict TDD.
**Started:** 2026-11-21 22:53 CST · **Model:** Claude Sonnet 5.5 · **Mark's pick:** "G16b: PDF and PNG files
(Recommended)" (orient picker, answered at once).
**Status:** Session claimed. Work beginning: the plan's measure-before-picker list on a scratch copy (Learning 17),
then the pre-RED picker, then RED, GREEN, REFACTOR by the gates.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### What Session 69 Did
**Deliverable:** Phase G16a, the recording layer and the SVG file (gaps A1 and A2): `savePedigreeDiagram(diagram, file,
width, height)` writes the widget `drawPedigreeDiagram()` returns as an SVG file, by recording its own drawing in headless
Chrome. DONE, strict TDD.
**Started:** 2026-11-21 · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all the recommended option):**
"G16a: SVG picture file (Recommended)" (orient); the function "savePedigreeDiagram(diagram, file, width, height)", "Drawing
only", "Original vector pictures", "Suggests + inst/ file" (R143's four, one picker); "Yes, proceed to RED"; "Yes, proceed
to GREEN"; "Yes, proceed to REFACTOR (Recommended)". No correction and no tool use declined; one `AskUserQuestion` took
four questions at once.
**Commits:** claim `bbb3b04`; picks and measures `8d3834a`; RED `3bc62dc`; GREEN `35932ac`, `7418f9c`, `71409eb`; REFACTOR
`dc672f2`; close-out 1 `e04826f`, `59da73c`; close-out 2 (these notes, the receipt, the ledger). Pushed at close.
**Measured before the picker (scratch layer, Chrome 157, a window tall enough):** the prototype's legend fault was
`drawImage()`'s **source rectangle ignored** (vis.js's mipmap pyramid squeezed into each icon), not the icons' format;
plus the title (a page `div`) not recorded and the text baselines (canvas `middle` is not SVG `central`: read
`measureText().alphabeticBaseline`, round to the nearest pixel); S68's legend figures were partly a 700 px window for a
961 px widget. Legend differing ink 14.0% to 0.2% (feature) and 10.4% to 0.0% (four animals); the 12 typed shapes 0 of
their pixels; eight style settings 0.2-0.4%; a quiet-time wait 0.3 s for the 8 s; chromote's timeouts on a stuck page;
`chromote` as Imports 13 packages, about 32 MB, 7 compiled; a layout made with `edgeStyle = "direct"` drawn with the
default identical (`edgeStyle` at draw time sets only the hover's reach).
**Found in GREEN:** a canvas is painted at whole device pixels, not stretched; scaling by CSS size over pixel size matched
worse (legend 1.10% against 0.03%). The scratch reference's 3-decimal rounding had hidden it.
**On the real code, all 14 cases:** the four animals and 12 typed shapes 0 of the drawing's pixels and 0.03% of the legend's
differ; the 18-animal pedigree with every mark 0.26% and 0.07%; the 375 animals 545 id texts (375 distinct). 18 tests
(143 expectations); full suite 83 files, 1,041 tests, 16,210 expectations, 0 failed, SKIP 0, WARN 0 (447 s, run before and
after REFACTOR); `lint_package()` 0; `roxygenise()` no change; `covr` 100 of 100 lines of the new file; drift 91 / 23 / 0;
fidelity 600 of 600; `R CMD check --as-cran` 1 NOTE (the new submission); the REFACTOR's five SVG files byte-identical
before and after.
**Quality gates:** quality_ratchet: 4/5 pass · 0 fail · 1 unmeasured · results 42b564bc4c70 · manifest 01151c525b8a; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: the full suite on `dc672f2`, 83 files, 1,041 tests, 16,210 expectations, 0 failed, SKIP 0, WARN 0 (447 s)

#### Session 68 Handoff Evaluation (by Session 69)
**Score: 8/10.** ROI high: the handoff saved most of the orientation and a day of re-deriving.
- **What helped:** the scratch scripts were there (`common.R`, `chrome.R`, `m3_svg.R` became `drv.R`, and `cmp2.py`
  was used as written); the committed prototype was the layer's start; section 7's measure-before-picker list was the
  session's order and each of its seven items was measured; "Mark's three picks are made: do not re-ask" saved a
  question; every cited line held (the 22 backlog titles at their lines, `R/drawPedigreeDiagram.R:578`, the plan's
  sections); drift 91/23/0 and nprcgenekeepr's 4 commits at `3e06730c5` exactly; its CI estimate for S68's push held
  (Ubuntu release FAIL 0, WARN 0, SKIP 2, PASS 16,056, R-devel alone failing); the gotchas list was right about
  `Page$enable()` first and the saved widget's 960 px.
- **What was missing:** that the legend's fault was a source rectangle ignored (the handoff and the plan named the icons'
  format, "small PNG canvases", and offered three ways of drawing legend rows that all treated a prototype bug as a
  limit); that a photograph's *height* matters as the width does; the device scale factor; chromote's `navigate()` and
  `loadEventFired()` timeout faults; that an R `NULL` sent to the page is `[]`.
- **What was wrong:** the plan's legend figures (11.7-22.7%, section 4.3) were measured in a window shorter than the
  widget (blank below it) and so overstated; "the legend's icons ... the weak part of the prototype" described a bug as a
  property. Both were corrected in the plan (11.2, 4.3's note, dragon 15).

**Self-assessment: 8/10.**
+ Measured before every picker option, with counts, and found the real fault (not the three ways the plan offered); four
  picks in one picker, answered at once; plain words; the RED file validated against a scratch reference before
  commit (4 faults in the tests, 1 in the prototype, found in an hour); every gate evidenced (the new tests, the full suite
  twice, lint, roxygen, `covr` 100%, drift, fidelity, `R CMD check`); the REFACTOR guarded byte for byte; a wrong figure of
  S68's corrected in the plan; the documents' every number re-run on the real code.
- Slips, none reaching a release: two miscounts I told Mark (chromote's compiled dependencies 8, it is 7: corrected at
  the RED gate; the tests that need no browser "nine", it is 8, found at close-out: the test header and three documents
  corrected); an explanation of the picture box's size ("the select box and footer") written without support and
  corrected before its commit; `dominant-baseline="[object Object]"` in the prototype committed in `8d3834a` (found by the
  reference, fixed in RED's commit, the measures unchanged); the 3-decimal scale hid the stretch until GREEN; a stuck-page
  test that raced the first quiet window (found by the reference); a zsh loop that passed one word for two; the dragons
  inserted out of order (fixed). No correction by Mark.

### What Session 68 Did
**Deliverable:** G16's planning session: `docs/planning/picture-files-plan.md` (gaps A1 and A2, picture files from a
script and a whole large pedigree on one page), no package code (failure mode #18). DONE.
**Started:** 2026-11-21 13:12 CST · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all
Recommended where the picker named one):** "G16 planning session (Recommended)" (orient); the approach "Record the
widget's own drawing (Recommended)", the file types "SVG, PDF, PNG" and the page "Fit to a page size the user gives
(Recommended)" (R142). The deepest reasoning mode the runner asks for at a planning session's start (`/effort max`)
cannot be set by the agent; it ran at the session's setting. No tool use declined and no correction.
**Commits:** claim `ec8356b`; the plan and the prototype `1a7077b`; close-out 1 `0b700c2` (the four plans), `e387825`
(roadmap, backlog); close-out 2 (these notes, the receipt, the ledger, the gaps plan's dragon 88). Pushed at close.
**Measured (scratch prototypes, section 10 of the plan):** what the layout returns (46 nodes, 44 edges for the feature
pedigree; 1,466 and 1,496 for the 375 animals); every canvas call the widget makes (22 methods, 10 properties); a
180-line recording layer: the recorded SVG's drawing differs from the live widget in 0 of 4,181 (four animals), 86
of 12,554, 0.7% (feature pedigree, all seven marks) and 770 of 21,240, 3.6% (375 animals, hairlines) ink pixels, the
legend in 11.7-22.7%; the 375 animals at label limit 0: 545 labels, 375 distinct, a one-page vector PDF of 5.7 MB
with 545 id words, 0 overlapped, legible at 1,200 dpi; kinship2's 517 and Pedixplorer's 472 id words overlap another
id in 94-100% of cases on 7 and 14 inch pages; the PNG shows ids only from 6,200 px wide; Chrome's own PDF of the
live widget is a picture (1 word). Verified: every cited line by `grep`/`sed` (two errors found and fixed before
commit: the feature pedigree draws 18 of its 19 rows, and a "72% of the widget" claim that was an inference); the
four plans' and two methodology files' edits applied by `Edit` after reading each region; no `R/`, `tests/`, `man/`,
`NAMESPACE` or `DESCRIPTION` change (the drift tool needs no re-run for them; it read 91/23/0 at orient).
**Quality gates:** quality_ratchet: 4/5 pass · 0 fail · 1 unmeasured · results 42b564bc4c70 · manifest 01151c525b8a; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: not re-run this session; R/, tests/, man/, NAMESPACE and DESCRIPTION are identical to S67's 1a6092e (git diff empty), whose full suite read 82 files, 1,023 tests, 16,067 expectations, 0 failed, 0 warnings
**Self-assessment: 8/10.**
+ Measured before every picker option, with counts, and found a third way (record the canvas calls) that the gaps
  plan's two options did not name, by tallying the drawing's primitives first (dragon 88); the picker's options
  carried the numbers and said what each cost; every pick answered at once; the plan follows G15's template (inventory,
  per-phase DONE, commands, surface, session boundary, dragons, out of scope, sources); every number traced to a
  run and re-checked against the files; the prototype committed so the build session starts from it.
- Slips, none reaching a commit: the first three `AskUserQuestion` calls were malformed (a wrapper key and a very
  long body; the fourth, in the plain `questions` format, worked: a wasted round trip each); a `viewBox` patch to
  the prototype that did nothing because the legend images are PNG canvases (found by decoding one); the first
  screenshot lost the legend to a too-narrow window; the feature pedigree miscounted as 18 animals "with every mark"
  when it draws 18 of 19 and not the "no offspring" variant; a "72%" statement inferred, not measured. Not measured
  and said so: the `direct` edge style, other style settings, Windows and Linux, why the PDF is 58 times kinship2's,
  the real time of a picture.
**Learnings:** the gaps plan's dragons 86-88; the plan's 12 dragons. No `CLAUDE.md` row (over its budget).
**Ledger:** `CHANGELOG.md` S68 entries (the session, R142's picks, push 1).

### Session 67 Handoff Evaluation (by Session 68)
**Score: 9/10.**
- **What helped:** the ACTIVE TASK named the deliverable and its steps, and item 3's measure-first list (the layout
  against what the drawing draws, chromote's PNG and PDF and whether SVG, the references' one-page pictures of the
  375 animals, then the picker, then the plan with DONE, commands and surface) was the session's plan: all of it was
  done, in that order. Every key-file line held (`R/drawPedigreeDiagram.R:205`, `:450`; `R/makePedigreeDiagramData.R:2222`;
  the gaps plan's `:383`, `:122`-`:123`; the research record's `:109`, `:128`; `DESCRIPTION:27`), and all 18 backlog line
  numbers in the orient picker matched the file. The predictions held: drift 91/23/0 and nprcgenekeepr's 4 commits at
  `3e06730c5` with a clean tree; S67's CI estimate, Ubuntu release PASS about 16,056 with R-devel failing alone, was
  exact (run `44939299378`: FAIL 0, WARN 0, SKIP 2, PASS 16,056; the other three non-devel jobs and the site
  `success`). The named gotchas (guarded removals, scratch copies run from the root) were applied.
- **What was missing:** that the workflows' `paths-ignore` is only `CLAUDE.md` and `methodology/**` (the note read as
  if the changed directories decided it, and a push of `docs/` alone runs both workflows); that `Page$enable()` must come
  before an injected page script and that the saved widget is 960 px wide (found by running); the reference counts
  "520 and 473 labels" were `text()` calls, not words in a page, and 94-100% of them overlap (the plan's section 2);
  S65's `pics.R` and `sheet.R` were named as reusable and were not needed (the session wrote its own `chrome.R`).
- **What was wrong:** nothing found wrong. The orient picker's "G16 ... gaps A1 and A2 ... `:122` and `:123`" rows
  pointed to the right lines.
- **ROI:** high.

*S1-S67's entries were removed in S3-S68 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*
