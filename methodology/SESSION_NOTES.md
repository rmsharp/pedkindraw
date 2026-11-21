# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G15 DONE (S42-S67).
**G16 (gaps A1, picture files from a script, and A2, a whole large pedigree on one page with every id written;
`docs/planning/picture-files-plan.md`) is PLANNED in S68 (R142)**: Mark picked, each first time, to record the widget's
own drawing in headless Chrome and write it as SVG (Chrome then makes the PDF from that SVG and the PNG as a picture of
the page), SVG, PDF and PNG chosen by the file name's ending, and a page size the user gives (`width` and `height` in
inches). Three build sessions follow: G16a, G16b, G16c (the plan's section 7). Then G17 (an app, a planning session
first), then 17g.
**Next: G16a, the recording layer and the SVG file** (`docs/planning/picture-files-plan.md:253`), strict TDD: first
its pre-RED measures, then its pre-RED picker, then RED, GREEN, REFACTOR by the gates (each an `AskUserQuestion`).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S68's commits are pushed
at close (Mark's standing pick, a memory).
**The orient picker:** G16a (recommended: the plan's order, R97). Also, from `methodology/BACKLOG.md`: READY, the
narrow legend (`:63`), the drawing vignette's measured trait (`:70`), the `smallPed` fixture (`:93`), rewording
`DIVERGENCE.md`'s older rows (`:45`), tests for full coverage (`:99`), `findPedigreeNumber()`'s speed (`:238`), and the
seven "Ready, small" items (`:164`, `:176`, `:183`, `:192`, `:202`, `:219`, `:225`); NEEDS DECISION, a converted
Pedixplorer object's `avail` (`:76`), long names at the edges (`:84`); "Waiting on Mark", the dashboard not seeing
`methodology/BACKLOG.md` (`:139`), copying nprcgenekeepr's colony overview (`:146`), an animal with two or more mates
drawn once between them as kinship2 draws it (`:153`). BLOCKED, and so not offered: `:11`, `:54`, `:133`. Name every
item in the picker (memory "Picker sets: name items, include all"); S68's orient picker named four groups, each item
in its description, and was answered at once. **The legend item (`:63`) overlaps G16a's legend work** (the plan's
G16a measures the legend's labels and icons): say so in the picker.
**Session boundary:** one session, G16a (two if the legend takes it, the plan's section 7), then close out.
**Priority:** HIGH (G16a-c, G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S68 changed no copied function: its only
   additions are the plan and a prototype under `docs/`); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr
   log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename
   | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at
   `3e06730c5`, tree clean, through S68.
2. Check S68's push: it changed `docs/planning/` (both workflows' `paths-ignore` is only `CLAUDE.md` and
   `methodology/**`, so S67's note that `R/`, `tests/` and the rest "changed, so both run" was true but not the rule),
   so R-CMD-check and the site run. An estimate, not measured: CI fails on Ubuntu R-devel only (S4Vectors in
   "setup-r-dependencies", S56-S68), the other four `success`, Ubuntu release FAIL 0, WARN 0, SKIP 2, PASS **16,056**
   (no test changed since S67: S67's run `44939299378` read exactly that); the site builds. `gh run list --limit 6`.
3. **G16a**, by `docs/planning/picture-files-plan.md` section 7 (`:253`). Read, in order: the plan's sections 3-5 and
   dragons (`:66`-`:200`, `:319`); `docs/planning/picture-files-prototype/recorder.js` (the 180-line prototype, not
   package code: the real layer is written test-first); the gaps plan's dragons 86-88 (`:840`-`:853`). Then the
   plan's **measure-before-picker list** on a scratch copy (Learning 17): the legend's three ways (rows drawn from R's
   tables, the small PNG rasters kept, an icon with a `viewBox`) as the share of the legend's ink that differs and the
   file size; the baseline (canvas `middle` against SVG `central`); the legend's title; the `direct` edge style and the
   other style settings (`symbolSize`, `textSize`, spacing, `lineWidth`) on the feature pedigree; what `chromote` and
   `htmlwidgets` pull in as Imports; the time of a picture with the fixed 8 s wait replaced by vis.js's own "drawn"
   event; the time limit for a stuck page. Then the pre-RED picker (the function's name and arguments, the legend's
   way, Imports or Suggests, a layout accepted as well as a widget, the recording layer as a string or a file in
   `inst/`), each option with its measured counts, in plain words (Learnings 1-2). **Mark's three picks are made
   (R142): do not re-ask them.** The function's name, `savePedigreeDiagram()`, is a working name only.
4. TDD: declare the phase at the top of every response; each transition (`PRE-RED->RED`, `RED->GREEN`,
   `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format"). Every number in the plan's section 4
   is a prediction until the real code runs (Learning 18): compute each value a RED test states with the real
   function in a scratch run first, and state the bound for the pixel comparison at RED beside the measured number.

### Gotchas
- **chromote:** `Page$enable()` before `Page$addScriptToEvaluateOnNewDocument()` or the script never runs (the gaps
  plan's dragon 86); the saved widget is 960 px wide whatever the window (`w$width`), and a screenshot is blank beyond
  the window without `captureBeyondViewport = TRUE` (dragon 87); a small SVG document's `loadEventFired()` timed out
  after `navigate(wait_ = FALSE)`, so use the navigation call's own wait; close each session you open (the shared
  default one closes at the suite's end, `tests/testthat/helper-live-render-positions.R`).
- **The legend** is its own vis.Network: its icons reach the canvas as small PNG canvases (36 x 25 px in the first
  one read; 11 of 11 in the feature legend), its title ("Sex") is a page element, its text baselines differ by about
  1 px from SVG's: the weak part of the prototype (the plan's 4.5). Its rows are a table in R
  (`R/drawPedigreeDiagram.R:269`-`:411`).
- **vis.js writes an id only at 4 px or taller:** 0 ids at a widget width of 6,000 px, all 545 at 6,200 (the plan's
  4.6). For a file the function lowers `nodes.scaling.label.drawThreshold` to 0 on a copy of the widget.
- **The references' "every id written" overlaps** (94-100% of their ids on 7 and 14 inch pages, the plan's section 2):
  count text objects and overlaps, not text alone. Chrome's PDF of the live widget is a picture with 1 word, so a
  PDF is printed from the recorded SVG only. The recorded PDF of the 375 animals is 5.7 MB (kinship2's 0.1 MB), cause
  not found (G16b measures three fixes).
- **R has no PDF reader:** `pdftools` is not installed here (the plan's dragon 9: a renv install by name with
  `rebuild = TRUE`, a `dev = TRUE` snapshot, the `renv-lock-no-latest-repository` gate, Learning 3); `pdfinfo` and
  `pdftotext` are Homebrew's, here only. G16c picks how ids in a PDF are counted.
- **`R CMD check` runs examples and builds vignettes without Chrome:** guard a Chrome example or chunk with
  `chromote::find_chrome()` (dragon 10). The CI's chromote is the flakiest part (`.github/workflows/R-CMD-check.yaml:55`-
  `:102`: Chrome pinned on Ubuntu and Windows, not macOS, where the pinned binary hung); read the new tests' result job
  by job.
- **`drawPedigreeDiagram()` is copied code:** the new function is in a new file, so no `DIVERGENCE.md` row; a `@seealso`
  line in its help (G16c) is help text only, but run the drift tool to confirm it reads 91/23/0 afterwards.
- **A new export needs `_pkgdown.yml:18`-`:22`** (the "Drawing" group) or the site build stops on a topic missing from
  the index.
- **Carried:** both references fail where pedkindraw does not (kinship2's `plot()` on fewer than 3 animals and on
  `twoChildless`, Pedixplorer's `align()` on both; count the cases compared with `expect_gte()`); run Rscript from the
  root (dragon 83) and a scratch copy from its root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to
  renv's library (dragons 83-84); guard every variable in a removal path (dragon 85); dry-run every edit script on a
  `git archive` copy and check new lines' widths; the 5-file cap splits commits; the ratchet's suite gate times out at
  300 s (run the suite by hand, 6.5 min); `CLAUDE.md` is over its budget (learnings go to the plans' dragons);
  `pedkindraw.Rproj` untracked, Mark's; the stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:176`; README.md is
  rendered from a scratch install, S52's way); a `cd` into `methodology/` persists (run the ratchet in a subshell);
  `NOT_CRAN=true` for the browser tests.
- **Ledger sizes:** see S68's receipt (both under the 196,608 B threshold).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/f5b9e076-db0f-420f-a887-a264f6db4dac/scratchpad/g16/`,
  may be gone; they `source` each other by that absolute path): `common.R` (the feature pedigree, the rhesus layout),
  `chrome.R` (a chromote session, the injected script, `evalJs()`), `recorder.js` (the committed prototype's original),
  `m1_layout.R`, `m2_canvas.R` (the canvas-call tally), `m3_svg.R` with `cmp2.py` (the recorded SVG against a screenshot:
  `Rscript m3_svg.R <four|feature|rhesus375> <width>`), `m4_large.R` (375 animals at label limits 5 and 0, the SVG and
  Chrome's PDF), `m5_refs.R` with `wordboxes.py` and `overlap.py` (the references' PDFs), `m6_raster.R` (the PNG at
  widths), `m7_cost.R`. S67's (`.../1886a128-eeac-48de-ae2e-0b96026a4ec5/scratchpad/g15c/`) and S65's are older.
- **Times** (S68's): the ratchet's suite gate timed out at its 300 s limit again (4/5); the prototype's one picture of 375 animals about 9 s (8 s of it a fixed
  wait); kinship2's PDF of the 375 animals 1.2 s, Pedixplorer's 3.2 s. S67's: the full suite 386 s; `R CMD check
  --as-cran` tests 177 s; the fidelity tool 3.5 min.

### Key files
- G16: `docs/planning/picture-files-plan.md` (`:17` section 1, `:38` section 2, `:66` the decision, `:87` the
  prototype's measures, `:172` the interface, `:201` the inventory, `:253` G16a, `:279` G16b, `:296` G16c, `:319`
  dragons, `:360` out of scope); `docs/planning/picture-files-prototype/recorder.js`;
  `docs/planning/standalone-pedigree-package-plan.md:303` (R142), `:93` (Next), `:1340` (G16's plan entry);
  `docs/planning/gaps-and-shared-code-plan.md:384` (G16's row), `:840`-`:853` (dragons 86-88);
  `docs/planning/cran-submission-plan.md:709`; `methodology/BACKLOG.md:26`.
- The code G16a reads: `R/drawPedigreeDiagram.R:205` (the function), `:269`-`:411` (the legend rows), `:427`-`:451`
  (the widget; `visExport()` `:448`-`:451`); `R/affectedConditions.R:143` (`.conditionSectionsHandler()`), `:293`
  (`.diagramAfterDrawing()`), `:345` (`.diagramHeight()`); `R/makePedigreeDiagramData.R:2222`
  (`makePedigreeMatingLayout()`); `tests/testthat/helper-live-render-positions.R:190` (`skip_if_no_chrome()`);
  `tools/gapCases.R:167` (`files`), `:221` (`largeIds`); `_pkgdown.yml:18`-`:22`; `DESCRIPTION:27`-`:28` (chromote,
  htmlwidgets in Suggests); `.github/workflows/R-CMD-check.yaml:55`-`:102`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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
