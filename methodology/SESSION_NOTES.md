# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G15 DONE (S42-S67).
G16a DONE in S69 (R143, the SVG), its CI repair DONE in S70 (R145), **G16b DONE in S71 (R144 built, R146):**
`savePedigreeDiagram(diagram, file, width, height, dpi = 300)` writes `.svg`, `.pdf` and `.png` by the file's ending
(`R/savePedigreeDiagram.R:88`; the recording layer `inst/js/recordCanvas.js`, its third argument `expandDashes`, `:374`).
**Open, not fixed:** the Windows job whose check step does not end after its tests pass (`methodology/BACKLOG.md:11`;
Mark's pick in S71: go on with G16b). Then **G16c** (the whole large pedigree on one page and the documents, the
`largeIds` case), G17 (an app, a planning session first), then 17g.
**Next: G16c**, strict TDD, from the orient picker: measure first (the list below), a pre-RED picker, then RED, GREEN,
REFACTOR, each gate an `AskUserQuestion`.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S71's commits are pushed at
close (Mark's standing pick, a memory); what the push's runs showed is in `CHANGELOG.md`'s S71 push entry.
**The orient picker:** G16c (recommended), or the Windows item (`BACKLOG.md:11`) first. Also, from
`methodology/BACKLOG.md`: READY, the legend's labels in a narrow drawing (`:80`), the drawing vignette's measured trait
(`:90`), the `smallPed` fixture (`:113`), rewording `DIVERGENCE.md`'s older rows (`:62`), tests for full coverage
(`:119`), `findPedigreeNumber()`'s speed (`:258`), and the seven "Ready, small" items (`:184` the suite gate's time
limit, `:196` the stale pedkindraw 0.0.1 in renv, `:203` the drift tool and copied constants, `:212` the context-budget
tool, `:222` CI notices, `:239` report a vacuous test to nprcgenekeepr, `:245` tell nprcgenekeepr's edition-3 conversion);
NEEDS DECISION, a converted Pedixplorer object's `avail` (`:96`), long names at the edges (`:104`); "Waiting on Mark", the
dashboard not seeing `methodology/BACKLOG.md` (`:159`), copying nprcgenekeepr's colony overview (`:166`), an animal with
two or more mates drawn once between them as kinship2 draws it (`:173`). BLOCKED, and so not offered: `:26` (the speed
vignette), `:71` (retire the drift tools), `:153` (nprcgenekeepr imports pedkindraw). Name every item in the picker
(memory "Picker sets: name items, include all"; max 4 options, so group them and name each in a description). Each
title was checked at its cited line when S71 closed out (23 of 23 by `grep`: the 22 items plus the G item at `:41`).
**Session boundary:** one session, then close out.
**Priority:** HIGH (G16c, G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S71 changed no copied function);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied
   from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr was at `3e06730c5`, tree clean, through S71.
2. **Read S71's push, every job** (`gh run list --limit 6`, then each job; treat every figure here as a guess). R/,
   inst/, man/, tests/, tools/ changed, so both workflows run. A guess: Ubuntu release and oldrel-1 `FAIL 0, WARN 0,
   PASS 16,283`, SKIP 2 (S70's run read SKIP 2) plus 2 if GitHub's Ubuntu has no `pdftotext` (not measured); macOS
   `FAIL 0` and PASS 16,283 less the two word tests' expectations if it has no `pdftotext` (S70's read SKIP 0 and PASS
   16,212); Ubuntu R-devel red in "setup-r-dependencies" (S56-S71, not a check). **Windows will probably hang again**
   (S69's and S70's both did, with the tests passing): at 40 minutes `gh run cancel <run>` and read its log
   (`gh api --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'`,
   available once the run has completed or been cancelled, not while it runs); its `proc.time()` line is the tests' time.
3. **G16c**, by `docs/planning/picture-files-plan.md` section 7 (`:301`), 14.5 (`:841`) and dragons 31-34 (`:851`). The
   plan's measure-before-picker list: how a test counts the ids in a PDF (dragon 9 of the plan: `pdftools` in Suggests, or
   the SVG's count alone, or the `pdftotext` command, which is not portable; `.savePdfWords()` at
   `tests/testthat/helper-savePedigreeDiagram.R:193` already counts the 375 animals' 545 id words, 375 distinct, with
   `pdftotext`); an overlap test from the PDF's word boxes (`pdftotext -bbox`; the prototype read 0 of 545) against the SVG's
   text positions; the colony's picture on a 14 x 7 in page (the shape the layout fits) and on letter paper, each as the
   ids' size in points; the time of the whole case. The pre-RED picker: how ids are counted in a PDF; the vignette's
   wording and whether its example runs in the site build (an example or vignette chunk that starts Chrome must be guarded
   with `interactive()`: dragon 26 of the plan). Its DONE (`largeIds`, plan `:301`): 545 id labels, 375 distinct, 0
   overlapped; the SVG and the PNG of the same drawing; the vignette and the site build; every statement the documents
   make checked in a chunk. **Run each RED test on a throwaway reference first** (S71's way: `git archive HEAD | tar -x -C
   <scratch>`, the reference patched there, the new file run there and in the Linux box; gaps plan dragon 89), and read
   the SKIP count beside FAIL (Learning 14).
4. TDD: declare the phase at the top of every response; each transition (`PRE-RED->RED`, `RED->GREEN`,
   `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Windows:** see item 2; a hang does not cost a session if you cancel at 40 minutes; the cause is not known
  (`BACKLOG.md:11` lists what to try first). Do not run two Chrome-starting jobs at once on the Mac (the suite, the
  ratchet, a Docker run): they share CPU and the stuck-page tests have time limits.
- **A PDF is read by its page and words, never its pixels** (plan dragons 31-32): `pdftoppm` at 96 dpi gave 960 x 493
  for a 960 x 491 picture and 18% of the ink differing; the page size and count are plain text in Chrome's PDF
  (`.savePdfPages()`, `helper-savePedigreeDiagram.R:170`), the words need `pdftotext` (`:188` skips without it). The
  Linux image has `pdftotext` and `pdfinfo` (S71 found it; the Dockerfile does not install them, the base image does).
- **Chrome rounds a page's height** (up to 0.87 pt for the four animals' default page, 369.12 pt for 368.25): typed
  pages are exact; a test on a default page states a 1.5 pt bound.
- **Two Chromes per `.pdf` or `.png`** (the recording's, then the render step's with `--disable-lcd-text`,
  `R/savePedigreeDiagram.R:290`); `mockery::stub(savePedigreeDiagram, ".recordDiagramSvg", list(svg = , x = , y = , w =
  , h = ))` replaces the recording, which is how the stuck-print test works (`tests/testthat/test_savePedigreeDiagram.R:564`).
- **A dashed path the layer cannot cut keeps its dashes** (an arc, `Z`, several subpaths, a dash offset, more than two dash
  numbers): `dashStrokes()`, `inst/js/recordCanvas.js:102`; on the 375 animals all 179 are cut (none keeps a
  `stroke-dasharray`); a pedigree with a dashed arc would give a bigger PDF.
- **Not tested:** an absurd `dpi` (the prototype's Chrome, 20,000 dpi on 7 x 5 in, timed out after chromote's own 60 s);
  Windows; whether GitHub's runners have `pdftotext`.
- **Run the DONE check the way GitHub does** (gaps plan dragon 93): `bash tools/checkExamples.sh` (30 s; gate
  `examples-no-open-connections`) and `R CMD check --as-cran` with `NOT_CRAN=true` and
  `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` from a scratch folder (S71's script: 581 s, 0 errors, 0 warnings, 1 NOTE for the
  new submission, `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16283 ]`). An example or vignette chunk that starts Chrome is guarded
  with `interactive()` (chromote leaves two pipes open; never call `processx::supervisor_kill()`).
- **The Linux box:** `tools/linux/runTests.sh [filter]` (Docker Desktop must run; the image `pedkindraw-linux` is built;
  Ubuntu 26.04 arm64, R 4.6.1, Google Chrome 158); `savePedigreeDiagram`'s file 98 s there. It does not have kinship2 or
  Pedixplorer, so those tests skip there. Run it from another tree's copy to test a reference: it copies the tree the
  script is in.
- **zsh does not split an unquoted `$var`** (use `bash -c '...'` for any loop over words); `rm -rf name*` with no match
  aborts a zsh `&&` chain; a `cd` into `methodology/` persists (run the ratchet in a subshell).
- **The photograph's window** (the plans' dragons 15 and 90): a screenshot is blank beyond the window, in height as in
  width; `.saveInkDiff()` (`helper-savePedigreeDiagram.R:277`) photographs an `.svg` or, since S71, a `.png`.
- **chromote 0.5.1:** the function raises `default_timeout` to 60 s and polls against one deadline; `Page$navigate()`
  waits 10 s on a server that never answers; the stderr line `[warning] got non-close frame while closing` is the
  websocket package logging, not an R warning.
- **Carried:** both references fail where pedkindraw does not (kinship2's `plot()` on fewer than 3 animals and on
  `twoChildless`, Pedixplorer's `align()` on both; count the cases compared with `expect_gte()`); run Rscript from the root
  (dragon 83) and a scratch copy from its root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to renv's
  library (dragons 83-84); guard every variable in a removal path (dragon 85); dry-run every edit script on a `git archive`
  copy; the 5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, 7.5-9 min; S71:
  528 s); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; the
  stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:196`); `NOT_CRAN=true` for the browser tests.
- **Ledger sizes** (S71's close-out 2, before its push entry): `CHANGELOG.md` 175,716 B; `HANDOFFS.md` 156,965 B, both
  under their 196,608 B archive threshold.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/09440ea4-4a72-4b6c-a386-a67b9bc8369a/scratchpad/g16b71/`,
  may be gone): `patchref.py` and `patchref2.py` (the throwaway reference), `ref/` (its tree), `red.R` (a test file's
  table), `fullsuite.R`, `check71.sh` (the full check), `eq.R` (the before-and-after of the REFACTOR), `ref375.R` (the 375
  animals' files). The three prototypes that matter are committed in `docs/planning/picture-files-prototype/`.
- **Times** (S71's): the full suite 528 s; `R CMD check --as-cran` 581 s; the test file 2 min 9 s on the Mac, 98 s in the
  Linux box; the 375 animals on 14 x 7 in: SVG 1.6 s, PDF 2.5 s, PNG 2.4 s.

### Key files
- G16: `docs/planning/picture-files-plan.md` (`:301` G16c, `:567` section 12, `:772` section 14, `:841` 14.5 what G16c
  inherits, `:851` dragons 31-34); `docs/planning/standalone-pedigree-package-plan.md` (`:309` R146, `:95` Next);
  `docs/planning/gaps-and-shared-code-plan.md` (`:887`, `:892` dragons 96-97); `methodology/BACKLOG.md:11` (Windows),
  `:41` (G15-G17).
- The code: `R/savePedigreeDiagram.R:88` (the function), `:157` (`.recordDiagramSvg()`), `:257` (`.checkDpi()`), `:290`
  (`.renderPicture()`), `:352` (`.stopTooSlow()`); `inst/js/recordCanvas.js:102` (`dashStrokes()`), `:151` (`opsOf()`),
  `:374` (`window.__svg`); `tools/gapCases.R:167` (`files`), `:247` (`largeIds`).
- The tests: `tests/testthat/test_savePedigreeDiagram.R` (30 tests, 216 expectations; `:347` the PDF test, `:490` the
  375 animals' words, `:564` the stuck print); `tests/testthat/helper-savePedigreeDiagram.R:170` (`.savePdfPages`), `:193`
  (`.savePdfWords`), `:205` (`.savePngSize`), `:226` (`.saveChromeSession`), `:277` (`.saveInkDiff`).

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
`docs/planning/picture-files-plan.md` section 7, G16b), strict TDD. DONE.
**Started:** 2026-11-22 00:47 CST · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all the recommended
option):** "G16b: PDF and PNG files (Recommended)" (orient); "Yes, proceed to RED"; "Cancel it and read its log" (S70's
Windows run, at 40 minutes); "Go on with G16b" (when that run was found to have hung again; I had said in the orient
picker that I would stop and ask); R146's decoder, "jsonlite in Suggests", with "Yes, proceed to GREEN" (one picker, two
questions); "Yes, proceed to REFACTOR". No correction and no tool use declined.
**Commits:** claim `fd207de`; RED `3ed03b8`; GREEN `42e090b` (function, recording layer, `DESCRIPTION`), `fc8df0c` (help,
NEWS), `8cb2b8c` (contract row, the `files` case); REFACTOR `057a2e2`; close-out 1 `2bfd5b7`, `10da9bd`; close-out 2
(these notes, the receipt, the ledger). Pushed at close.
**Found:** S70's push (run 44994050682, `a150a49`): Ubuntu release `FAIL 0, WARN 0, SKIP 2, PASS 16201`, macOS `FAIL 0,
SKIP 0, PASS 16212`, Ubuntu oldrel-1 `success` (its counts not read), R-devel red in "setup-r-dependencies" (known); the
Windows job passed its tests (`FAIL 0, WARN 0, SKIP 1, PASS 16211`, `proc.time()` 936 s: S70's LCD repair reached
Windows) and the check step did not end: cancelled at 07:14 UTC, 24 minutes after the tests ended, two orphan `Rterm`
processes killed: the second run in a row; not fixed (Mark's pick), `BACKLOG.md:11` rewritten with the reading.
**Built:** `savePedigreeDiagram(..., dpi = 300.0)` writes `.pdf` and `.png` as well: the recording asks the layer to cut
each dashed line into short strokes (PDF only; a path it cannot cut safely keeps its dashes), a second Chrome (LCD text
off) opens the recorded SVG, waits two animation frames, then prints it (paper = the page) or photographs it clipped to
the page at `dpi / 96`; `jsonlite::base64_dec()` (Suggests) decodes the answer; one time limit covers the recording and the
render step. **Measured first, on a throwaway reference** (the prototypes in a `git archive` copy, not committed;
gaps plan dragon 89): every value the 30 tests state (PDF 504 x 360 pt for 7 x 5 in; the default page 720 x 369.12 pt;
PNG 672 x 480 / 1050 x 750 / 2100 x 1500 at 96 / 150 / 300 dpi and 3000 x 1534 by default; the PNG at 96 dpi against
the live widget 0.00% and 0.03% of ink differing for the four animals, 0.26% and 0.07% for the feature pedigree; the 375
animals on 14 x 7 in a one-page PDF of 1,025,352 B on the real code with 545 id words, 375 distinct, a 4200 x 2100 PNG),
and a pixel comparison of a PDF through `pdftoppm` that failed (960 x 493 for 960 x 491, 18% differing), so the tests
read a PDF's page and words, not its pixels (plan dragon 31). The reference passed on the Mac and in the Linux box (216
expectations); RED on the real tree read 140 expectations, 12 errors, SKIP 0, WARN 0 on both.
**Verified on the final tree:** the 30 tests (it was 19), 216 expectations, 0 failed, SKIP 0, WARN 0 on the Mac and in
the Linux box (98 s) after GREEN and again after REFACTOR; the full suite at `057a2e2` 83 files, 1,053 tests, 16,283
expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (528 s); `R CMD check --as-cran` with `NOT_CRAN=true` and
`_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` at `8cb2b8c`: 0 errors, 0 warnings, 1 NOTE (the new submission), `PASS 16283`
(581 s); `lint_package()` 0; `roxygenise()` no further change; drift 91 / 23 / 0 with no copied file changed; the REFACTOR's
time-limit paths byte-identical before and after (`cmp`, 870 bytes); the `files` case prints the three files.
**Not verified:** any GitHub run of the final tree (it starts after this handoff; read it first thing next time);
Windows; an absurd `dpi`; whether GitHub's runners have `pdftotext`.
**Quality gates:** quality_ratchet: 5/6 pass · 0 fail · 1 unmeasured · results 534fea217641 · manifest f447be95addb; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: the full suite on `057a2e2` (the REFACTOR), 83 files, 1,053 tests, 16,283 expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (528 s)

#### Session 70 Handoff Evaluation (by Session 71)
**Score: 9/10.** ROI high: the handoff saved the orientation, the plan reading and the CI reading, and its one wrong
figure was labelled a guess.
- **What helped:** the orient picker's 23 titles at their cited lines (23 of 23 held at orient); drift 91/23/0 and
  nprcgenekeepr's 4 commits at `3e06730c5` exactly; "G16b's picks are MADE: do not re-ask them" (saved a picker); the
  instruction to read S70's push job by job and what to do if Windows hung (it did; the cancel-and-read steps worked);
  the plan sections for G16b with line numbers (`:281`, `:566`, `:639`) and the three committed prototypes
  (`expandDashes.py`, `printPdf.R`, `savePng.R`), from which the throwaway reference was built in an hour; the Linux box
  (`tools/linux/runTests.sh`) worked first time and showed the reference passing on Ubuntu; the gotchas on
  `NOT_CRAN=true`, the 5-file cap, "run the suite by hand" (458 s then, 528 s now), the zsh trap; `.saveInkDiff()` and
  `.savePixelsJs` at their lines, which the PNG comparison extended.
- **What was missing:** that the Linux image already has `pdftotext` and `pdfinfo` (found by running); that `jsonlite`
  is not in `DESCRIPTION` and a PDF needs a base64 decoder (a pick of Mark's, R146); that the PDF cannot be compared
  with the live widget pixel by pixel; that a test helper that photographs needs a testthat context (`teardown_env()`),
  so a scratch script must run inside `test_file()`.
- **What was wrong:** the CI estimate "Ubuntu `PASS 16,188`" (the real run read 16,201: the guess forgot that the 13
  failing expectations of S69 now pass; it was labelled a guess); "a second session of the same Chrome" (12.3) was a
  plan, not a measurement: the build uses a second Chrome, so the recording stays replaceable in a test.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Followed the handoff's order (read the push job by job, the picks not re-asked), kept the promise made in the orient
  picker (stopped and asked when Windows hung again, then asked before cancelling a run), ran every RED value on a
  throwaway reference on two platforms before committing (one idea, a PDF pixel comparison, failed there and was
  dropped with its helper before it reached a commit), GREEN passed on its first run on both surfaces, the REFACTOR was
  proved byte-identical, the check was run the way GitHub does, and every figure in the plans was re-measured on the
  real code (the 375 animals' PDF 1,025,352 B against the reference's 1,025,349) before the close-out committed it.
- Slips, none reaching a release: a placeholder anchor in one `Edit` call (it failed harmlessly); the first measuring
  script ran outside testthat and failed on `teardown_env()`; a helper (`.savePdfAsPng`) written and deleted unused; the
  CRAN plan said 11 of the 30 tests start a browser (it is 22; found by counting the file before the commit); the
  reference's PDF size entered a draft of the plan before the real code was measured (corrected before commit); the
  orient and close-out took long reading five plan sections that the handoff already summarised. The Windows hang is
  still unexplained and every push will probably show it again.

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

*S1-S68's entries were removed in S3-S71 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*
