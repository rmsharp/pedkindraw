# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G15 DONE (S42-S67).
**G16 DONE:** G16a S69 (R143, the SVG), its CI repair S70 (R145), G16b S71 (R146, the PDF and the PNG), **G16c S72 (R147):**
the 375 animals through `savePedigreeDiagram()` on 14 x 7 in and on letter paper hold **545 id labels, 375 distinct, 0
overlapping** (SVG in Chrome, PDF by pdftotext), the PNG holds its ids too; the README, both vignettes, the two help pages and
NEWS say how to save a drawing and what the colony's files hold (`docs/planning/picture-files-plan.md` section 15). **Each id is
under a point high** (0.75 pt on 14 x 7 in): the files are to zoom in on (backlog `:120`, NEEDS DECISION).
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; four runs in a row, probably
at R's exit: plan dragon 37; the fifth run, S72's first push, ended its tests with an error and still hung).
**Next: G17's planning session** (an app; the deliverable is a plan document in `docs/planning/`, no code), or another item
from the orient picker below. Then G17's build sessions, then 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S72's commits are pushed at close
(Mark's standing pick, a memory), in two pushes: 1 (`605512a`: read job by job in S72, plan section 15.5) and 2 (the Windows
test repair, `30d5555` and the notes after it); push 2's runs are read in the push entries of `CHANGELOG.md`: if an entry
says "not read", read that run first.
**The orient picker:** G17's planning session (recommended), or the Windows item (`BACKLOG.md:11`) first. Also, from
`methodology/BACKLOG.md`: READY, the legend's labels in a narrow drawing (`:87`), the drawing vignette's measured trait
(`:97`), the `smallPed` fixture (`:127`), rewording `DIVERGENCE.md`'s older rows (`:69`), tests for full coverage
(`:133`), `findPedigreeNumber()`'s speed (`:277`), installing poppler in CI so the PDF word tests run there (`:281`),
tracing kinship2's and Pedixplorer's label counts in `largeIds` (`:270`, found S72), and the seven "Ready, small" items
(`:198` the suite gate's time limit, `:210` the stale pedkindraw 0.0.1 in renv, `:217` the drift tool and copied constants,
`:226` the context-budget tool, `:236` CI notices, `:253` report a vacuous test to nprcgenekeepr, `:259` tell
nprcgenekeepr's edition-3 conversion); NEEDS DECISION, a converted Pedixplorer object's `avail` (`:103`), long names at the
edges (`:111`), a colony's ids under a point high (`:120`, found S72); "Waiting on Mark", the dashboard not seeing
`methodology/BACKLOG.md` (`:173`), copying nprcgenekeepr's colony overview (`:180`), an animal with two or more mates drawn
once between them as kinship2 draws it (`:187`). BLOCKED, and so not offered: `:33` (the speed vignette), `:78` (retire the
drift tools), `:167` (nprcgenekeepr imports pedkindraw). Name every item in the picker (memory "Picker sets: name items,
include all"; max 4 options, so group them and name each in a description). Each title was checked at its cited line when
S72 closed out (26 of 26 by `grep`: the 25 items plus the G item at `:48`).
**Session boundary:** one session, then close out.
**Priority:** HIGH (G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S72 changed no copied function);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied
   from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr was at `3e06730c5`, tree clean, through S72.
2. **Read S72's last push first, job by job** (`gh run list --limit 6`; its entry in `CHANGELOG.md` says what was read).
   S72's first push read: pkgdown `success`; Ubuntu release and oldrel-1 `FAIL 0 WARN 0 SKIP 11 PASS 16279`; macOS `SKIP 9
   PASS 16290`; Ubuntu R-devel red in "setup-r-dependencies" (S4Vectors does not load; S56-S72, not a check); **Windows `FAIL
   1`** (the PNG test's floor of 100: 27 pixels there, 347 on the Mac, 573 in the Linux box), repaired in S72. A guess for
   the next push (the repair adds the rule test's 9 expectations, no skip): Ubuntu `SKIP 11 PASS 16288`, macOS `SKIP 9
   PASS 16299`, Windows `SKIP 11` and `FAIL 0`. **Windows hangs every time** (S69-S72, five runs): at 40 minutes `gh run
   cancel <run>` and read its log (`gh api --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed
   's/\x1b\[[0-9;]*[A-Za-z]//g'`, available once the run has completed or been cancelled, not while it runs); its `proc.time()`
   line is the tests' time when the tests pass (936, 1,041 s). **A watcher script's clock:** `date -u -j` is BSD and this
   shell's `date` is GNU (S72's first watcher ended at once): start from `date -u +%s`.
3. **G17's planning session, if picked** (`docs/planning/gaps-and-shared-code-plan.md:386`, the row: "what the app does,
   `shiny` in Suggests or Imports, its tests' CRAN time, then its build sessions", `app`: the app builds and starts; 1 + 4-8
   sessions, a guess). The evidence to read: the gap itself (`docs/research/pedkindraw-gaps-2026-11-18.md:144`, A3), what
   exists (nprcgenekeepr's `runGeneKeepR(port, launch.browser)` with its Pedigree Browser, in `../nprcgenekeepr`; Pedixplorer's
   `ped_shiny()`, `ped_ui()`, `ped_server()`, 1.8.0 in renv's library), and `tools/gapCases.R`'s `app` case (`cases$app`; run
   `Rscript tools/gapCases.R app`). The runner's rules for a planning session (`methodology/SESSION_RUNNER.md` "Planning
   Sessions"): the deepest reasoning mode (ask Mark to set it), a grep-based inventory, each phase with its DONE, its
   verification, its surface and its session boundary, the pre-RED style pickers for the choices; S68's plan
   (`docs/planning/picture-files-plan.md`) is the precedent. The plan is the deliverable: write no code.
4. TDD for any code session: declare the phase at the top of every response; each transition (`PRE-RED->RED`,
   `RED->GREEN`, `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format"). **When the code is already
   built and the tests lock it, say so at the RED gate** (S72's did): RED's failures are then the documents' tests, and
   each locking test is shown able to fail on a throwaway copy with the behaviour broken (plan dragon 39).

### Gotchas
- **A count from one machine is not a floor for another** (plan dragons 42-43): the same 2.8 pixel ids gave 347, 573 and 27
  differing pixels on the Mac, in the Linux box and on GitHub's Windows; S72's PNG test failed there on a floor of 100 it had
  measured on the Mac only. State an order, a presence or an exact 0 (`.pngHoldsIds()`, `helper-savePedigreeDiagram.R:540`).
- **Windows:** see item 2; a hang does not cost a session if you cancel at 40 minutes; the cause is not known, probably
  R's exit after the tests (plan dragon 37; `BACKLOG.md:11` lists what to try first). Set a monitor's clock by `date -u` and
  the run's own `createdAt` (BSD `date -j` misparses). **A tool's existing is not its working** (plan dragons 35-36):
  GitHub's Ubuntu and macOS have no `pdftotext`, Windows has Git's, which exits 99 on a PDF; `.skipUnlessPdftotext()`
  (`tests/testthat/helper-savePedigreeDiagram.R:209`) tries it on a PDF R writes first. **`tools/linux/runTests.sh` hides an
  error's text** (it prints the counts): S71's Linux box read one error in 2 of 10 runs of the file; S72's three runs
  (RED, after GREEN, after the REFACTOR) read none. Do not run two Chrome-starting jobs at once on the Mac (the
  suite, the ratchet, a check, a Docker run): they share CPU and the stuck-page tests have time limits.
- **The shared test Chrome's window is 1200 px wide:** a photograph of a page wider than the window is blank beyond it unless
  taken with `captureBeyondViewport = TRUE` (plan dragons 2 and 38; `.savePngIdInk()`, `helper-savePedigreeDiagram.R:478`).
  A test helper that photographs or evaluates needs a testthat context (`.saveChromeSession()` uses `teardown_env()`): a
  scratch script runs inside `test_file()`.
- **A PDF is read by its page and words, never its pixels** (plan dragons 31-32): the page size and count are plain text in
  Chrome's PDF (`.savePdfPages()`, `:187`), the words and their boxes need `pdftotext -bbox` (`.savePdfBoxes()`, `:444`;
  `.savePdfWords()`, `:230`, is its text); `pdftools` reads the words too but its boxes are whole numbers (R147).
- **Each id is one `<text>` (545 of them, `font-size` 0.893 on the colony's 14 x 7 in viewBox), with no halo;** the legend's
  labels have a halo (a first `<text>` with fill `none`). The 16 other texts are the legend's.
- **A document test needs the source tree** (`README.Rmd`, `vignettes/`, `man/`, `NEWS.md`) and skips under `R CMD check`
  (`SKIP 6`); look for a statement's words beside the call it is about (`.docsAfter()`, `test_savePedigreeDiagramDocs.R:39`),
  because a badge's `.svg` and a picture's `.png` already say them.
- **README.md is made from README.Rmd in a scratch copy** with the current package installed into a scratch library
  (`R CMD INSTALL --library=<scratch> .`, then `rmarkdown::render("README.Rmd")` with that library first on `R_LIBS`), not
  from renv's stale pedkindraw 0.0.1 (`BACKLOG.md:210`); diff it against the old README.md before copying.
- **Chrome rounds a page's height** (up to 0.87 pt for the four animals' default page): typed pages are exact; a test on a
  default page states a 1.5 pt bound.
- **Two Chromes per `.pdf` or `.png`** (the recording's, then the render step's with `--disable-lcd-text`,
  `R/savePedigreeDiagram.R:290`); `mockery::stub(savePedigreeDiagram, ".recordDiagramSvg", list(svg = , x = , y = , w =
  , h = ))` replaces the recording (`tests/testthat/test_savePedigreeDiagram.R`, the stuck-print test).
- **A dashed path the layer cannot cut keeps its dashes** (an arc, `Z`, several subpaths, a dash offset, more than two dash
  numbers): `dashStrokes()`, `inst/js/recordCanvas.js:102`; on the 375 animals all 179 are cut.
- **Not tested:** an absurd `dpi`; Windows; whether GitHub's runners have `pdftotext` (they do not: S71); the site build
  locally (pkgdown is not installed in renv's library: GitHub's pkgdown job builds it); whether a larger `dpi` makes a
  colony's PNG readable (the id height is 0.893 px x dpi / 96 by arithmetic, run at 96 and 300 dpi only).
- **Run the DONE check the way GitHub does** (gaps plan dragon 93): `bash tools/checkExamples.sh` (30 s; gate
  `examples-no-open-connections`) and `R CMD check --as-cran` with `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true`
  from a scratch folder (S72's: 594 s, 0 errors, 0 warnings, 1 NOTE for the new submission, `[ FAIL 0 | WARN 0 | SKIP 6 |
  PASS 16306 ]`). An example or vignette chunk that starts Chrome is guarded with `interactive()` (chromote leaves two pipes
  open; never call `processx::supervisor_kill()`).
- **The Linux box:** `tools/linux/runTests.sh [filter]` (Docker Desktop must run; the image `pedkindraw-linux` is built;
  Ubuntu 26.04 arm64, R 4.6.1, Google Chrome 158; the filter is a regular expression: `'savePedigreeDiagram(Colony|Docs)'`);
  it has `pdftotext`, not kinship2 or Pedixplorer. Run it from another tree's copy to test a reference: it copies the tree the
  script is in.
- **zsh does not split an unquoted `$var`** (use `bash -c '...'` for any loop over words); `rm -rf name*` with no match
  aborts a zsh `&&` chain; a `cd` into `methodology/` persists (run the ratchet in a subshell); BSD `sed -i` needs an
  argument (use python for edits in a script).
- **The photograph's window** (the plans' dragons 15 and 90): a screenshot is blank beyond the window, in height as in
  width; `.saveInkDiff()` (`helper-savePedigreeDiagram.R:306`) photographs an `.svg` or a `.png`.
- **chromote 0.5.1:** the function raises `default_timeout` to 60 s and polls against one deadline; `Page$navigate()`
  waits 10 s on a server that never answers; the stderr line `[warning] got non-close frame while closing` is the
  websocket package logging, not an R warning.
- **Carried:** both references fail where pedkindraw does not (kinship2's `plot()` on fewer than 3 animals and on
  `twoChildless`, Pedixplorer's `align()` on both; count the cases compared with `expect_gte()`); run Rscript from the root
  (dragon 83) and a scratch copy from its root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to renv's
  library (dragons 83-84); guard every variable in a removal path (dragon 85); dry-run every edit script on a `git archive`
  copy; the 5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, 7.5-9 min; S72:
  536 s); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; the
  stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:210`); `NOT_CRAN=true` for the browser tests; do not write to
  `/tmp` (the scratchpad is for scratch files).
- **Ledger sizes** (S72's close-out 2): `CHANGELOG.md` 188,588 B; `HANDOFFS.md` 165,993 B, both under their 196,608 B
  archive threshold (about 8 KB of room in CHANGELOG.md: one session; archive it with `methodology_trim.py` when it passes
  the threshold). This file 42,856 B (S69's entry removed, FM #28).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/c7775ebd-2ec0-426e-8a54-8cf339a7a799/scratchpad/g16c/`,
  may be gone): `measure1-4.R`, `fullsuite.R`, `check72.sh` (the full check), `words.R` (the before-and-after of the
  REFACTOR), `ref-real/`, `ref-drop/`, `ref-big/` (the throwaway trees). The three measures that matter are committed in
  `docs/planning/picture-files-prototype/g16cMeasure1-3.R`.
- **Times** (S72's): the full suite 536 s; `R CMD check --as-cran` 594 s; the colony file 20.7 s on the Mac; the 375
  animals on 14 x 7 in: SVG 1.4 s, PDF 2.4-3.4 s, PNG 2.4 s.

### Key files
- G16: `docs/planning/picture-files-plan.md` (`:301` G16c, `:773` section 14, `:921` section 15 what G16c delivered, `:975`
  dragons 38-41); `docs/planning/standalone-pedigree-package-plan.md` (`:310` R147, `:96` Next);
  `docs/planning/gaps-and-shared-code-plan.md` (`:386` the G17 row, `:22` Next); `methodology/BACKLOG.md:11` (Windows),
  `:48` (G15-G17), `:120` (ids under a point), `:270` (label counts), `:281` (poppler in CI).
- The code (unchanged by S72 but two help sentences): `R/savePedigreeDiagram.R:88` (the function), `:157`
  (`.recordDiagramSvg()`), `:257` (`.checkDpi()`), `:290` (`.renderPicture()`), `:352` (`.stopTooSlow()`);
  `inst/js/recordCanvas.js:102` (`dashStrokes()`), `:374` (`window.__svg`); `tools/gapCases.R:247` (`largeIds`, its
  pedkindraw files probe from `:275`), `:344` (`cases$app`, G17's probe).
- The tests: `tests/testthat/test_savePedigreeDiagram.R` (31 tests, 217 expectations);
  `tests/testthat/test_savePedigreeDiagramColony.R` (`:29` the SVG, `:44` the PDF on 14 x 7 in and letter paper, `:71` the PNG, `:98` the rule
  `.pngHoldsIds()`; 31 expectations); `tests/testthat/test_savePedigreeDiagramDocs.R` (`:52` README, `:62` "Saving a drawing", `:75` the colony
  section, `:85`, `:90` help, `:98` NEWS; 27 expectations); `tests/testthat/helper-savePedigreeDiagram.R:22` (`.saveTmp`),
  `:29` (`.skipUnlessBrowser(pdftotext)`), `:421` (`.saveSvgIdBoxes`), `:461` (`.saveOverlapped`), `:478` (`.savePngIdInk`), `:540` (`.pngHoldsIds`).
- The documents: `vignettes/drawing.Rmd:630` ("Saving a drawing", `:651` the guarded chunk), `:714` ("A colony-size
  drawing", `:750` its guarded chunk); `README.Rmd`; `NEWS.md` (the "New" item after `savePedigreeDiagram()`'s).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 72 Did
**Deliverable:** Phase G16c, the whole large pedigree on one page and the documents (the `largeIds` case,
`docs/planning/picture-files-plan.md` section 7, G16c), strict TDD. DONE.
**Started:** 2026-11-22 06:40 CST · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all the recommended
option):** "G16c (Recommended)" (orient); the three pre-RED picks in one picker (R147: "SVG in Chrome + pdftotext", "Pixel
floor + dpi advice", "Guarded example, checks in tests"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, proceed to
REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `8cada92`; measures and picks `ea1eeb0`; RED `3fd1caf`; GREEN `c1836a1` (help and NEWS; its message
amended once before any push: it said "6 fail" for 21), `61370be` (README and the two vignettes), `1187457` (the `largeIds`
probe); REFACTOR `6dcbf76`; close-out 1 `fc73f5b` (the plans), 1b `c145726` (roadmap, backlog); close-out 2 (these notes, the
receipt, the ledger), pushed after it; then, found by that push, the Windows test repair (Mark's pick, strict TDD, test files only):
RED `7e7d36d`, GREEN `3872a21`, REFACTOR `30d5555`, close-out 1c `383eb05`, the notes and the push entries after it.
**Measured first** (`docs/planning/picture-files-prototype/g16cMeasure1-3.R`; plan section 15.1): the 375 animals on 14 x 7
in, letter landscape, letter portrait and 7 x 5 in: every PDF 567 words, 545 id words, 375 distinct, 0 overlapping; an id's
box 0.75, 0.59, 0.45, 0.37 pt high; the SVG in Chrome 545 / 375 / 0 overlapping; the PNG at 300 dpi 4200 x 2100 with 347
ink pixels that are the ids (0 at 96 dpi); `pdftools` 3.9.1 counts the same but its boxes are whole numbers.
**Built** (no code under `R/` but two help sentences): RED `test_savePedigreeDiagramDocs.R` (6 tests, 27 expectations, 25
failed) and `test_savePedigreeDiagramColony.R` (3 Chrome tests, 22 expectations, passing: they lock G16b's function; each
failed on a throwaway copy with the ids dropped, 12 of 22, and with the ids 30 times larger, 9 of 22) and four helpers;
GREEN the help's `@seealso`, the package help, NEWS, the drawing vignette's "Saving a drawing" and colony section (guarded
example chunks, hidden checks for 170 repeat nodes and 545 ids written), `vignettes/pedkindraw.Rmd`, README.Rmd and README.md
(rendered in a scratch copy), the `largeIds` probe; REFACTOR `.saveTmp()` and `.skipUnlessBrowser(pdftotext)` moved into the
helper and `.savePdfWords()` read through `.savePdfBoxes()` (identical words on two PDFs, 26 and 567).
**Verified:** the full suite at `1187457` 85 files, 1,063 tests, 16,333 expectations, 0 failed, SKIP 0, WARN 0 (536 s);
`R CMD check --as-cran` (scratch folder, `NOT_CRAN=true`, connections check on): 0 errors, 0 warnings, 1 NOTE (the new
submission), `SKIP 6 PASS 16306` (594 s); `checkExamples.sh` OK; after the REFACTOR the three files 40 tests, 266 expectations,
0 failed on the Mac and in the Linux box; lint 0; roxygen no change; drift 91 / 23 / 0.
**Found:** the first PNG helper read 25,188 differing pixels on every copy, the code's or not (a 1344 px page in a 1200 px
window: dragon 38); 8 of the docs test's 27 expectations passed before any edit through a badge's `.svg` and a picture's
`.png` (dragon 40); `largeIds` prints kinship2 520 / Pedixplorer 473 labels, not the plan's 517 / 472 (backlog `:270`); the
plan's "PNG ids drawn at 6,200 px" is the live-widget route, not this function; each id is under a point high (dragon 41,
backlog `:120`).
**After close-out 2 (found by its push, run 45038005488, plan section 15.5):** pkgdown `success` (the site builds); Ubuntu release
and oldrel-1 `SKIP 11 PASS 16279`, macOS `SKIP 9 PASS 16290` (the handoff's guesses held); Ubuntu R-devel red in
"setup-r-dependencies" (S4Vectors, known); **Windows `FAIL 1 WARN 0 SKIP 11 PASS 16287`**: my PNG test's floor of 100 (the
drawing without its ids differs from the PNG in 27 pixels there, 347 on the Mac, 573 in the Linux box); the hang a fifth time,
R exiting with an error and the step still not ending (cancelled at 40 minutes). **The repair:** RED a no-browser test of the
rule `.pngHoldsIds(ink)` on typed counts (and the committed test failing on a Mac copy with the ids in `#6a6a6a`, 42 pixels, at
the same line), GREEN the rule (an id taken out, more differing pixels than the drawing as written) in the helper and the PNG
test calling it, REFACTOR the counts in one comment; the colony file 4 tests, 31 expectations, 0 failed on the Mac and on the
lighter-ids copy, 12 failed on the ids-dropped copy, the three files in the Linux box 41 tests, 275 expectations, 0 failed.
**Not verified:** the repair on Windows (push 2); a larger `dpi`'s effect beyond 96 and 300.


**Quality gates:** see the receipt in `HANDOFFS.md` (S72).

#### Session 71 Handoff Evaluation (by Session 72)
**Score: 9/10.** ROI high: the handoff saved the orientation and the planning of G16c.
- **What helped:** the orient picker's 24 titles at their cited lines (24 of 24 held); drift 91/23/0 and nprcgenekeepr's 4
  commits at `3e06730c5` exactly; the plan's measure-before-picker list for G16c (the four measures were the picker's
  content); `.savePdfWords()` already counting 545 and 375, which made the pdftotext side a one-hour extension; "run each RED
  test on a throwaway reference first" (the idea behind this session's two mutant copies); the Windows gotchas ("a tool's
  existing is not its working", cancel at 40 minutes); the Linux box command and its image details; `NOT_CRAN=true`; the
  `captureBeyondViewport` and photograph-window notes (they named the fault behind the 25,188 pixels once I looked).
- **What was missing:** that G16c's tests would lock code that already exists, so RED has no failing code (the plan's
  "Measure before the pre-RED picker" did not say the colony tests pass at once); that the plan's "PNG ids at 6,200 px" is the
  other route; that `.saveTmp()` and `.skipUnlessBrowser()` are local to one test file (a new file cannot see them).
- **What was wrong:** nothing found in the notes. The plan's kinship2 517 and Pedixplorer 472 (section 7) are 520 and 473 in
  today's probe (not the handoff's claim; the handoff did not repeat them).
- **ROI:** high.

**Self-assessment: 7/10** (8 before the push; lowered by the Windows failure).
+ Measured before the picker, and the picker stated counts (545, 375, 0, the sizes, the pdftools comparison), so Mark's three
  picks were each the recommended one at once; said at the RED gate that the colony tests would pass and proved each able to fail
  on two broken copies; found the helper's blank-window fault from a constant and fixed it before RED's commit; tightened the
  docs test after the first run showed 8 of 27 passing for the wrong reason; every number in the plans was re-read from the run
  that made it; REFACTOR proved identical (`identical()` on the words of two PDFs); the check was run the way GitHub does.
- **The slip that cost the point:** the PNG test's floor of 100 was the Mac's number, and S71's own lesson (a platform differs) and
  the test file's own header (dragon 12: one machine's numbers, bounds) were in front of me; I ran the Mac and the Linux box and
  did not ask what text does on Windows. GitHub's Windows job failed it (27 pixels against 347 and 573); repaired in the session
  by Mark's pick in strict TDD, and the lesson is in the plan (dragons 42-43).
- Other slips, each caught before it cost anything: GREEN 1's message said "6 fail (was 25)" for 21 (amended before any push);
  section 15.3 first said the full suite ran at the REFACTOR's tree (it ran at GREEN 3; corrected on re-read); I wrote one
  scratch file to `/tmp` (removed at once); three long silent stretches in tool work drew the harness's "say what you are
  doing" reminder; my first CI watcher used BSD `date -j` on a GNU `date` (the notes warned of the trap) and ended at once.
- The documents' tests are text-presence tests: they hold a statement's key words, not its truth; the truth is the colony
  tests' and the hidden chunks'. That split was Mark's pick, and its weakness is named in the notes (dragon 40).
- Not done in the session: the repair's reading on Windows (push 2).

### What Session 71 Did
**Deliverable:** Phase G16b, the PDF and the PNG file for `savePedigreeDiagram()` (gaps A1 and A2,
`docs/planning/picture-files-plan.md` section 7, G16b), strict TDD. DONE.
**Started:** 2026-11-22 00:47 CST · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all the recommended
option):** "G16b: PDF and PNG files (Recommended)" (orient); "Yes, proceed to RED"; "Cancel it and read its log" (S70's
Windows run, at 40 minutes); "Go on with G16b" (when that run was found to have hung again; I had said in the orient
picker that I would stop and ask); R146's decoder, "jsonlite in Suggests", with "Yes, proceed to GREEN" (one picker, two
questions); "Yes, proceed to REFACTOR"; then, after the push, "Fix it now (Recommended)" for the Windows word tests,
"Yes, proceed to GREEN" and "Yes, proceed to REFACTOR" again. No correction and no tool use declined.
**Commits:** claim `fd207de`; RED `3ed03b8`; GREEN `42e090b` (function, recording layer, `DESCRIPTION`), `fc8df0c` (help,
NEWS), `8cb2b8c` (contract row, the `files` case); REFACTOR `057a2e2`; close-out 1 `2bfd5b7`, `10da9bd`; close-out 2
`6cd865d` (pushed). Then, found by that push, the Windows word tests' repair: RED `bbb26b8`, GREEN `fd9c7e2`, REFACTOR
`048a100` (amended once: its message first claimed a clean Linux run it had not read), close-out 1c `1c0fbe8`, 1d
`a57246b` (pushed); close-out 2b (these notes, the receipt, the ledger), pushed last.
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
**After close-out 2 (found by its push, run 45000649737):** Ubuntu release and oldrel-1 `FAIL 0 WARN 0 SKIP 4 PASS
16268`, macOS `SKIP 2 PASS 16279` (GitHub's Ubuntu and macOS have no `pdftotext`: the two word tests skip); R-devel red
in "setup-r-dependencies"; **Windows `FAIL 4 WARN 2`**: Git for Windows' `pdftotext` exists and exits 99 on a PDF, so my
`.skipUnlessPdftotext()` (existence only) let the two word tests run and fail; every other test passed there. Mark's pick:
repair it now. **The repair (test helper only, strict TDD):** RED a test with a stand-in `pdftotext` exiting 99 first on the
path expects a skip (failed on the old helper); GREEN the helper tries the tool on a PDF R writes and skips when it fails;
REFACTOR one function runs the command (the words of both PDFs and the probe's three outcomes byte-identical, `cmp`, 6,128
bytes). 31 tests, 217 expectations, 0 failed on the Mac; the full suite at the REFACTOR 83 files, 1,054 tests, 16,284
expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (518 s); lint 0; roxygen no change. **The repair's push (run
45011132429, `a57246b`):** Ubuntu `SKIP 4 PASS 16269`, macOS `SKIP 2 PASS 16280`, **Windows `FAIL 0 WARN 0 SKIP 4 PASS
16278`, `proc.time()` 1,041 s**, and the hang again with every test passing (cancelled at 40 minutes, 10:50 UTC): the
fourth run in a row, so it is probably at R's exit, not in a test (plan dragon 37). **One unexplained error:** the Linux
box read `214 expectations, 1 error` in 2 of 10 runs of the file (the others 217 and 0), through `runTests.sh`, which hides
the text; not on the Mac or GitHub's Ubuntu.
**Not verified:** an absurd `dpi`; the Linux box's intermittent error (cause unknown).
**Quality gates:** quality_ratchet: 5/6 pass · 0 fail · 1 unmeasured · results 534fea217641 · manifest f447be95addb; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: the full suite on `048a100` (the repair's REFACTOR), 83 files, 1,054 tests, 16,284 expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (518 s)

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

**Self-assessment: 7/10.**
+ Followed the handoff's order (read the push job by job, the picks not re-asked), kept the promise made in the orient
  picker (stopped and asked when Windows hung again, then asked before cancelling a run), ran every RED value on a
  throwaway reference on two platforms before committing (one idea, a PDF pixel comparison, failed there and was
  dropped with its helper before it reached a commit), GREEN passed on its first run on both surfaces, the REFACTOR was
  proved byte-identical, the check was run the way GitHub does, and every figure in the plans was re-measured on the
  real code (the 375 animals' PDF 1,025,352 B against the reference's 1,025,349) before the close-out committed it.
- **The slip that cost the score:** my two PDF word tests broke the Windows job. They skipped only where `pdftotext` is
  missing, and S70's own lesson (a photograph, a platform's text) pointed at the same class of fault: a tool can exist
  and not work. The tests had run only on the Mac and in the Linux box, both of which have a working one; I did not ask
  which tool GitHub's runners would find. Repaired in the session, by Mark's pick, in strict TDD. Also: the REFACTOR's
  commit message said the Linux box read 217 and 0 before I had read that run (it read 214 and an error): found, and the
  unpushed commit amended; a monitor's clock parsed with BSD `date -j` warned at once, falsely (nothing was cancelled on
  it); the gate said "218 expectations" (it is 217); the Linux box's intermittent error left unexplained because the
  script hides the text.
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

*S1-S69's entries were removed in S3-S72 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*
