# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G15 DONE (S42-S67).
**G16a DONE in S69 (R143)** (`savePedigreeDiagram(diagram, file, width, height)` writes the widget as an SVG file,
`R/savePedigreeDiagram.R:70`; the recording layer `inst/js/recordCanvas.js`) **and its CI repair DONE in S70 (R145):**
S69's push was red on GitHub (the help example's open chromote pipes; 13 Ubuntu legend failures; a Windows job that
never ended), the first two repaired, the third open (`methodology/BACKLOG.md:11`). **G16b's pre-RED measures and Mark's
three picks are MADE (R144, `docs/planning/picture-files-plan.md` section 12, `:566`): do not re-ask them.** G16b (the
PDF, the PNG and the page) and G16c (the whole large pedigree on one page and the documents) follow, then G17 (an app, a
planning session first), then 17g.
**Next: G16b**, strict TDD, from PRE-RED's gate on (the picks are made): RED, GREEN, REFACTOR, each gate an
`AskUserQuestion`. Unless S70's push shows the Windows job hanging again, in which case the Windows item
(`BACKLOG.md:11`) goes first (see "What You Must Do" 2).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S70's commits are pushed at
close (Mark's standing pick, a memory); the push's runs are NOT read yet (they start after this handoff).
**The orient picker:** G16b (recommended, or the Windows item first if the runs say so). Also, from
`methodology/BACKLOG.md`: READY, a Windows job that does not end (`:11`), the narrow legend (`:74`), the drawing
vignette's measured trait (`:84`), the `smallPed` fixture (`:107`), rewording `DIVERGENCE.md`'s older rows (`:56`),
tests for full coverage (`:113`), `findPedigreeNumber()`'s speed (`:252`), and the seven "Ready, small" items (`:178`,
`:190`, `:197`, `:206`, `:216`, `:233`, `:239`); NEEDS DECISION, a converted Pedixplorer object's `avail` (`:90`), long
names at the edges (`:98`); "Waiting on Mark", the dashboard not seeing `methodology/BACKLOG.md` (`:153`), copying
nprcgenekeepr's colony overview (`:160`), an animal with two or more mates drawn once between them as kinship2 draws it
(`:167`). BLOCKED, and so not offered: `:21`, `:65`, `:147`. Name every item in the picker (memory "Picker sets: name
items, include all"; max 4 options, so group them and name each in a description). Each title was checked at its cited
line when S70 closed out (23 of 23 by `grep`: the 22 items plus the G item at `:36`).
**Session boundary:** one session, then close out.
**Priority:** HIGH (G16b-c, G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S70 changed one comment in
   `R/savePedigreeDiagram.R`, no copied function); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log
   --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename |
   sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr was at
   `3e06730c5`, tree clean, through S70.
2. **Read S70's push, every job** (`gh run list --limit 6`, then each job: the handoff of S69 predicted one job red and
   four were; treat every figure here as a guess). R/, man/, tests/, tools/ changed, so both workflows run. A guess:
   Ubuntu release and oldrel-1 `FAIL 0, WARN 0, SKIP 2, PASS 16,188` (S69's run read 16,186 and the 13 failures; plus the
   new test's 2 expectations), macOS `FAIL 0, SKIP 0, PASS 16,212` (the figures of this Mac's run), `checking examples ...
   OK` everywhere, Ubuntu R-devel red for S4Vectors in "setup-r-dependencies" (S56-S70, not a check). **Windows is the
   unknown:** S69's job ended tests with `FAIL 13` (the same legend, "1.29 > 0.50", so the LCD flag should reach it, not
   verified) and then hung 77 minutes; if the Windows job passes 40 minutes, `gh run cancel <run>` and read its log
   (`gh api --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'`):
   it is dragon 30 of the picture plan and `BACKLOG.md:11`.
3. **G16b**, by `docs/planning/picture-files-plan.md` section 7 (`:281`), section 12 (`:566`: Mark's three picks `:580`,
   the measures `:589`, what GREEN builds `:639`, dragons 23-25 `:654`) and 13.4-13.5 (dragons 26-30, `:731`-`:753`).
   Read `R/savePedigreeDiagram.R:70` (the function), `:130` (`.recordDiagramSvg()`), `inst/js/recordCanvas.js:301`
   (`window.__svg`). The pre-RED measures and the picker are DONE: go to the PRE-RED to RED gate. The plan for GREEN
   (12.3): `dpi = 300`; `.pdf` recorded with each dash written as a short stroke (`window.__svg()` takes a third argument,
   `expandDashes`; the Python prototype is `docs/planning/picture-files-prototype/expandDashes.py`), printed by a second
   session of the same Chrome after two animation frames (`printPdf.R`); `.png` a screenshot clipped to the page at
   `scale = dpi / 96` in a Chrome with `--disable-lcd-text` (`savePng.R`). Every number there is a prediction until the
   real code runs (Learning 18): **run the RED file against a scratch reference first** (the gaps plan's dragon 89), and
   **in the Linux box too** (`tools/linux/runTests.sh savePedigreeDiagram`, dragon 95).
4. TDD: declare the phase at the top of every response; each transition (`PRE-RED->RED`, `RED->GREEN`,
   `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Run the DONE check the way GitHub does** (the gaps plan's dragon 93): `bash tools/checkExamples.sh` (30 s: examples
  with `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true`; it reads `errors: 0`; gate
  `examples-no-open-connections`), and `R CMD check --as-cran` with both set (this Mac, S70: 0 errors, 0 warnings, 1 NOTE
  for the new submission, 501 s of tests). An example or vignette chunk that starts Chrome must be guarded with
  `interactive()` (chromote leaves two pipes open; `processx::supervisor_kill()` would end every supervised process of
  the user's session, so never call it).
- **The Linux box:** `tools/linux/runTests.sh [filter]` (Docker Desktop must run; the image `pedkindraw-linux` is built,
  5.3 GB, first build about 10 minutes; Ubuntu 26.04 arm64, R 4.6.1, Google Chrome 158). It reproduced GitHub's
  failures exactly (1.57% against 1.6%; 13 against 13). Its Dockerfile compiles R packages from source because Ubuntu's
  `r-cran-*` are built for R 4.5 (dragon 28). It does not have kinship2 or Pedixplorer, so those tests skip there.
- **LCD text** (dragon 27): on Linux and Windows Chrome draws an SVG's text with coloured edges; the PNG of G16b needs
  `--disable-lcd-text` in the function's own Chrome. The tests' Chrome is `.saveChromeSession()`'s own, not the shared
  one (a flag set after the shared Chrome exists does not reach it, dragon 29).
- **Print a PDF after two animation frames, and read its words, not its size** (dragon 24): a print right after the load
  event once lost the shapes and ids at 489 KB.
- **The PDF's cause is dashes** (dragon 23): the plan's three fixes (digits, joined strokes, no clips) did nothing;
  count dashes before promising a size.
- **zsh does not split an unquoted `$var`:** `set -- $c` in a loop passed one word and lost a run in S69 and again in
  S70; use `bash -c '...'` for any loop over words. `rm -rf name*` with no match aborts a zsh `&&` chain.
- **The photograph's window** (the picture plan's dragon 15, the gaps plan's 90): a screenshot is blank beyond the
  window, in height as in width. `tests/testthat/helper-savePedigreeDiagram.R:222` (`.saveInkDiff()`) is the
  photograph-and-compare the tests use; `:290` `.saveTextSpread()`; `:211` `.savePixelsJs`.
- **Never record at the PNG's resolution** (dragon 17): `.recordDiagramSvg()` pins the device scale factor to 1; a PNG
  is a screenshot of the written SVG document at `scale = dpi / 96`. **A canvas is painted at whole device pixels, not
  stretched** (`inst/js/recordCanvas.js:297`, `:326`; the gaps plan's dragon 91).
- **chromote 0.5.1:** the function starts its own `Chromote$new()`, raises `default_timeout` to 60 s, polls
  `Runtime$evaluate(timeout_ = )` against one deadline (`.waitUntilDrawn()`, `R/savePedigreeDiagram.R:245`);
  `Page$navigate()` waits 10 s on a server that never answers (dragon 16); chromote leaves 4 small files in `tempdir()`
  and two pipes open (dragon 22); the stderr line `[warning] got non-close frame while closing` is the websocket package
  logging, not an R warning.
- **The picture's box is not the widget's size** (500 px high gives 491, 995 gives 961.25, 672 gives 654.391); the SVG's
  root takes the page in inches and the `viewBox` the box. A page asked at 6.8 in came out 490.08 pt (dragon 25).
- **G16a's test of ".pdf and .png are not available yet"** (the 4th test of `test_savePedigreeDiagram.R`, `:63`, 5
  expectations) changes in G16b; `savePedigreeDiagram()` refuses them at `R/savePedigreeDiagram.R:84`.
- **The tests:** 19 in `test_savePedigreeDiagram.R` (8 need no browser and run on CRAN; 11 start Chrome and skip on CRAN),
  145 expectations, 56 s on the Mac, 48 s in the Linux box; `mockery::stub()` needs `savePedigreeDiagram()` itself to call
  `requireNamespace()` and `chromote::find_chrome()`. The option `pedkindraw.saveTimeout` (60 s) shortens the limit.
- **Carried:** both references fail where pedkindraw does not (kinship2's `plot()` on fewer than 3 animals and on
  `twoChildless`, Pedixplorer's `align()` on both; count the cases compared with `expect_gte()`); run Rscript from the
  root (dragon 83) and a scratch copy from its root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to
  renv's library (dragons 83-84); guard every variable in a removal path (dragon 85); dry-run every edit script on a
  `git archive` copy; the 5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand,
  7.5-9 min; S70: 458 s); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj`
  untracked, Mark's; the stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:190`); a `cd` into `methodology/`
  persists (run the ratchet in a subshell); `NOT_CRAN=true` for the browser tests.
- **Ledger sizes:** see S70's receipt (both under the 196,608 B threshold).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/c314d091-eec5-4ccb-9965-e08c2b82f7f3/scratchpad/g16b/`,
  may be gone; the three that matter are committed in `docs/planning/picture-files-prototype/`): `m1_svg.R` (records
  the 375 and four animals with the real function), `variants.py` (the PDF variants), `cmpimg.py` (the picture
  differences), `pdfobjs.py` (what is in a PDF), `m2_pages.R` (page shapes), `docker/` (the first Dockerfiles), `eq/` (the
  REFACTOR's before-and-after numbers). S69's (`.../88600065-c9e3-464f-8ca6-fd3387889606/scratchpad/g16a/`) are older.
- **Times** (S70's): the full suite 458 s; `R CMD check --as-cran` tests 501 s; `tools/checkExamples.sh` 30 s; the
  Linux box's file 48 s, five Chrome files 3 minutes; the 375 animals' record 1.6 s, PDF print 0.6 s (0.17 s with short
  strokes), PNG at 300 dpi 0.1 s.

### Key files
- G16: `docs/planning/picture-files-plan.md` (`:281` G16b, `:298` G16c, `:321` dragons 1-12, `:397` section 11, `:487`
  dragons 13-22, `:529` 11.6, `:566` section 12 G16b's picks and measures, `:666` section 13 the repair);
  `docs/planning/standalone-pedigree-package-plan.md` (`:306` R144, `:307` R145, `:93` Next);
  `docs/planning/gaps-and-shared-code-plan.md` (`:873`-`:883` dragons 93-95); `methodology/BACKLOG.md:11` (Windows),
  `:36` (G15-G17).
- The code: `R/savePedigreeDiagram.R:70`, `:130`, `:197`, `:212`, `:229`, `:245`; `inst/js/recordCanvas.js:277`
  (`__ready`), `:301` (`__svg`); `tools/checkExamples.sh`; `tools/linux/Dockerfile`, `tools/linux/runTests.sh`;
  `methodology/.quality-gates.json` (`examples-no-open-connections`); `docs/planning/picture-files-prototype/`
  (`expandDashes.py`, `printPdf.R`, `savePng.R`, `recorder2.js`).
- The tests: `tests/testthat/test_savePedigreeDiagram.R` (19 tests); `tests/testthat/helper-savePedigreeDiagram.R:166`
  (`.saveChrome`), `:171` (`.saveChromeSession()`), `:211`, `:222`, `:290`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 71 Did
**Deliverable:** Phase G16b, the PDF and the PNG file for `savePedigreeDiagram()` (gaps A1 and A2,
`docs/planning/picture-files-plan.md:281`), strict TDD (IN PROGRESS)
**Started:** 2026-11-22 00:47 CST · **Model:** Claude Sonnet 5.5
**Status:** Session claimed (Mark's orient pick, "G16b: PDF and PNG files (Recommended)"). Orient done: tree clean but
`pedkindraw.Rproj`, no ghost session, ledgers at `a150a49`, dashboard 93/100, drift 91/23/0, nprcgenekeepr unchanged
(`3e06730c5`). S70's push (run 44994050682): Ubuntu release and macOS green (PASS 16,201 and 16,212), R-devel red in
"setup-r-dependencies" (known), Windows and Ubuntu oldrel-1 still running at claim (unread). Next: the PRE-RED to RED gate.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### What Session 70 Did
**Deliverable (changed mid-session by Mark's pick):** the CI repair of G16a's two faults, strict TDD. DONE. Claimed as
Phase G16b (Mark's orient pick, "G16b: PDF and PNG files (Recommended)"); G16b's pre-RED measures and Mark's three picks
(R144) were made and committed first, then S69's push was read job by job and found red, and Mark picked "Repair CI
first; G16b next session (Recommended)". G16b itself (RED, GREEN, REFACTOR) was not started.
**Started:** 2026-11-21 22:53 CST · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all the recommended
option):** "G16b: PDF and PNG files (Recommended)" (orient); R144's three, one picker (the page 10 in wide as `.svg` has
it, the PNG at 300 dpi, each dash written as a short stroke for the PDF); "Repair CI first; G16b next session
(Recommended)"; R145's two, one picker (the example only when typed in R, plus a gate; the test file's own Chrome with
LCD text off); "Yes, proceed to RED", "Yes, proceed to GREEN", "Yes, proceed to REFACTOR (Recommended)", and "Cancel it
and read its log (Recommended)" (S69's stale run). No correction and no tool use declined.
**Commits:** claim `caa4c04`; G16b's picks and measures `ff862e5`; the claim changed `184ee68`; the repair's picks and
measures `1939b0b`; RED `9c29cb4`; GREEN `63beb69`, `fe42d4b`; REFACTOR `a6e1c3d`; close-out 1 `04af66f`, `daa0e6c`;
close-out 2 (these notes, the receipt, the ledger). Pushed at close.
**Found:** S69's push (run 44986823915, `1d0e00a`) was red on four of five jobs, not one (its handoff estimated R-devel
alone): the help example failed `R CMD check` ("connections left open": chromote's two processx pipes) on every job that
runs it, 13 Ubuntu tests failed (the legend 1.6% against 0.5%), and Windows ended its tests (`FAIL 13`) and never exited
(cancelled at 77 minutes with Mark's pick; cause unknown, not fixed, `BACKLOG.md:11`). Neither fault had shown on the Mac:
S69's check ran without `NOT_CRAN`, so the Chrome example and tests skipped, and the suite ran on macOS, which has no
LCD text edges. **The causes, measured:** the example (reproduced with `NOT_CRAN=true` and
`_R_CHECK_CONNECTIONS_LEFT_OPEN_=true`); the legend (reproduced in a Linux container, 1.57% against 1.6% and 13 of 143
expectations: Chrome photographs an SVG's text with coloured LCD edges on Linux and Windows, the live canvas text in
grey, a property of the photograph, not the file). **G16b's measures** (section 12 of the picture plan): the PDF of the
375 animals is 5.77 MB because 170 dashed edges are 52,470 dashes that Chrome writes as outlines (the plan's three
fixes changed it by under 0.02%); each dash as a short stroke 1.04 MB with the picture the same at page size; a PDF
printed right after the load event can be cut short; the PNG at 96, 150 and 300 dpi is 56, 102 and 238 KB.
**The repair:** the example runs only when typed in R (`interactive()`), a new gate `examples-no-open-connections`
(`tools/checkExamples.sh`, read 1 then 0); the test file's own Chrome with `--disable-lcd-text` and a new test that it
draws grey text (fails in the Linux box, passes on the Mac); `tools/linux/` (Dockerfile, `runTests.sh`, built from
scratch). **Verified on three surfaces:** this Mac, the full suite 83 files, 1,042 tests, 16,212 expectations, 0 failed,
0 errors, SKIP 0, WARN 0 (458 s, after the REFACTOR); `lint_package()` 0; `roxygenise()` no further change;
`R CMD check --as-cran` with GitHub's settings 0 errors, 0 warnings, 1 NOTE (the new submission); the Linux box, the
file 19 tests, 145 expectations, 0 failed (it read 14 failed at RED) and five Chrome files together 61 tests, 1,128
expectations, 0 failed. The REFACTOR's before-and-after numbers byte-identical (`cmp`) on both.
**Not verified:** any GitHub run of the repaired tree (it starts after this handoff; read it first thing next time), and
Windows (dragon 30).
**Quality gates:** quality_ratchet: 5/6 pass · 0 fail · 1 unmeasured · results 534fea217641 · manifest f447be95addb; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: the full suite on `a6e1c3d` (the REFACTOR), 83 files, 1,042 tests, 16,212 expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (458 s)

#### Session 69 Handoff Evaluation (by Session 70)
**Score: 7/10.** ROI high for G16b, mixed for the rest: the handoff saved most of the orientation and the pre-RED
measures, but it left CI red and said it would not be.
- **What helped:** the orient picker's 22 titles at their cited lines (22 of 22 held at orient); drift 91/23/0 and
  nprcgenekeepr's 4 commits at `3e06730c5` exactly; "Mark's three R142 picks and R143's four are made: do not re-ask
  them"; the measure-before-picker list for G16b (all four items were measured and the first overturned the plan: the
  three PDF-size fixes did nothing, dashes were the cause); the gotchas on zsh word splitting (lost a run to it anyway,
  but recognised it at once), on the photograph's window and on chromote; the scratch scripts (`common.R`, `chrome.R`)
  and the committed prototype `recorder2.js`; and above all item 2's warning that the pixel bounds were measured on
  macOS only and that the result must be read job by job: that is the step that found the two faults.
- **What was missing:** that the local `R CMD check --as-cran` and the by-hand suite had both skipped the Chrome example
  and tests (no `NOT_CRAN`) or run where no LCD edges exist (macOS); that chromote's pipes make the check's examples an
  ERROR under `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true`; that Windows had never run the new code.
- **What was wrong:** the CI estimate, "CI fails on Ubuntu R-devel only ... the other four `success` ... PASS 16,199":
  four of five jobs failed (the example everywhere it runs, 13 tests on both Ubuntu jobs) and Windows never ended; and
  "`R CMD check --as-cran` 1 NOTE" was true of a check that skipped both.
- **ROI:** high for the measures and the orient list; the CI claim cost this session its original deliverable.

**Self-assessment: 8/10.**
+ Followed the handoff's own warning and read S69's push job by job, which found a red CI that the handoff said was
  green; measured before each of the two pickers and found the real causes (dashes, not the plan's three fixes; LCD text
  edges, not a code fault) by reproducing, not guessing: a Linux container that read 1.57% where GitHub read 1.6%, then
  looking at the pictures; every pick answered at once, all the recommended option; the RED test written against
  reference values (0 / 0 / 160), failing in the Linux box and passing on the Mac as predicted; the REFACTOR proved
  byte-identical on two platforms; the repair verified on three surfaces; the lessons written as dragons 26-30 and
  93-95 and a gate, not a row; asked before cancelling S69's run and before changing the deliverable.
- Slips: a PDF variant printed before the page was painted (489 KB, 21 words) looked like a better fix until its words
  were counted; the zsh word-splitting trap again (one lost run); the first Docker image built with apt R packages that
  do not load in R 4.6 (one wasted 10-minute build); a picker sentence misworded ("13 of 18 tests' worth", it is 13
  expectations in one test); the full suite on this Mac was run before the REFACTOR and had to be run again; one
  scratch file written to `/tmp` instead of the scratchpad; Windows' hang left unexplained. G16b itself, the session's
  claim, was not built, by Mark's pick.

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
