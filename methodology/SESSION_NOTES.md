# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** plan Phase 9, the renderer: copy `drawPedigreeDiagram()` (exported, a `visNetwork` widget),
`R/deceasedSlash.R` and `R/affectedConditions.R`'s lines 77-201 test-first from nprcgenekeepr, with
`test_drawPedigreeDiagram.R`, `helper-live-render-positions.R` and the 3 Chrome tests R31 deferred; fidelity cases,
push, CI, Phase 9 DONE.
**Status:** READY, with two picks for Mark first (below). Phase 8 is DONE (S9-S10): suite 466 tests, 0 failed, WARN
0; `R CMD check --as-cran` R16's NOTE only; results tool 468 of 468 identical; **everything is pushed** (`6db58ca`;
CI run `43260600901` 5/5 `Status: OK`); S10's two close-out commits are not.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:373` (row 9), `:126-127` (R31, R32), `:416` ("Done 8",
the model for "Done 9"), `:30-31` (status block). Contract: `docs/planning/pedkindraw-api-contract.md:130`
(`drawPedigreeDiagram(layout, edgeStyle, onClick)`). Backlog: `methodology/BACKLOG.md:11` (the item, with S10's
measurements).
**Session boundary:** one session (an estimate: about 1,100 source and test lines, against the 1,745 S10 copied).
**Priority:** HIGH.

### What You Must Do
1. Orient. nprcgenekeepr is busy (HEAD moved `e7e3350ca` -> `50506369e` -> `4375e2715` during S10). Check what
   changed since `baef1e12c`: `git -C ../nprcgenekeepr diff --stat baef1e12c HEAD -- R/drawPedigreeDiagram.R
   R/deceasedSlash.R R/affectedConditions.R tests/testthat/test_drawPedigreeDiagram.R
   tests/testthat/helper-live-render-positions.R tests/testthat/test_positionMatingUnitForest.R
   tests/testthat/test_drawPedigreeDiagramDocs.R`. In S10 only `R/drawPedigreeDiagram.R` had changed (+23/-5,
   nprcgenekeepr `471589138`, its S1153: the `onClick` check moved into a new `.checkOnClick()` it shares with its
   `drawColonyOverview()`). Also confirm Phase 8's copied files are still unchanged (the results tool refuses
   otherwise).
2. Survey (Learning 9): `codetools::findGlobals()` on each function to copy, both `$functions` and `$variables`, and
   grep each file for `::` (S10's grep: `drawPedigreeDiagram.R` 8 `visNetwork::`; `deceasedSlash.R` 1 `utils::`;
   `affectedConditions.R` 1 `stats::`; the test file 2 `shiny::` and 2 `visNetwork::`; the helper `chromote::`,
   `htmlwidgets::`, `withr::`, `visNetwork::`).
3. Pre-RED picker (Learnings 1-2, plain words): (a) copy `R/drawPedigreeDiagram.R` at `baef1e12c` and record
   `.checkOnClick()` in `DIVERGENCE.md`, or copy it at a later commit; (b) `test_drawPedigreeDiagramDocs.R` (110 lines)
   checks nprcgenekeepr's own vignette text, so leave it in nprcgenekeepr (as R31 did) or not; (c) whatever the survey
   finds. Record the picks as plan rulings (R34 on). Then the `TDD: PRE-RED→RED` gate (`CLAUDE.md:89`).
4. RED: Suggests `chromote`, `htmlwidgets`, `shiny` (S8 added Suggests in RED); copy the test file, the helper, and
   the 3 Chrome tests back into `tests/testthat/test_positionMatingUnitForest.R` (its header `:8-11` names their
   source lines 1996-2018, 2562-2601 and 2603-2642; update the header). Run nprcgenekeepr's own files first (Learning 12).
5. GREEN: `Imports: visNetwork`; the R files; delete `DIVERGENCE.md`'s 3 rows (`:14-16`); help text rewritten (R21,
   the example types its own pedigree); then the fidelity cases.
6. REFACTOR gate, push once, read each CI job's `Status:` line and skip reasons; Phase 9's DONE close-out.

### Gotchas
- **Installing packages:** none of `visNetwork`, `chromote`, `htmlwidgets` or `shiny` is in pedkindraw's library
  (checked S10). renv's dated repository is `https://packagemanager.posit.co/cran/2026-10-31` (`renv.lock:7`); set it
  before `renv::install()`, install with `rebuild = TRUE` and their dependencies by name, snapshot with
  `renv::snapshot(dev = TRUE)` (`renv/settings.json`: `snapshot.type` explicit), then run the gate `renv-lock-no-latest-repository`
  (Learning 3; S8 locked 5 dependencies "latest" by forgetting the names).
- **Chrome:** Google Chrome is installed on this Mac (`/Applications/Google Chrome.app`), so the 3 Chrome tests and
  the live-render helper can run here. Whether CI's runners have Chrome for chromote is not measured.
- **Fidelity cases for a widget:** `drawPedigreeDiagram()` returns an htmlwidget. Whether two runs give `identical()`
  widgets (an element id or dependency paths could differ between the two library folders) is not measured: a guess.
  If they differ, compare the widget's data (`$x`) and say so in the tool.
- **The layout's message:** `makePedigreeMatingLayout()` prints a message naming the animals it leaves out (10 of the
  12 Phase 1 pedigrees). The results tool now records and compares messages (S10), so a case that calls the layout
  needs nothing extra.
- **CI skips by design:** `test_diagramSolverEquivalence.R:318` skips without R's own BLAS (Ubuntu, Windows) and
  `:221` where the math library sums in another order (Ubuntu). macOS runs both. These are the copied tests' guards,
  not failures (S10's run: Ubuntu PASS 1999 SKIP 2, Windows 2009 SKIP 1, macOS 2010).
- **Test time:** the suite took 110 s in S10 with nprcgenekeepr's session running beside it (66 s in RED); `R CMD
  check`'s tests 74 s here and 120-150 s on CI.
- **zsh traps** (S10 hit all of them, though the handoff named the first two): `echo ===` is a command lookup (quote
  it); `Rscript -e` with a backslash in a regex fails (use a script file); `$C:tests/...` applies zsh's `:t` modifier
  to `$C` (write `${C}:tests/...`); `cmd | tail; echo $?` gives tail's status, not cmd's (redirect instead).
- **Scratch scripts:** S10's first RED run saved a file three folders up through a relative path; keep every output
  path in the scratchpad, written out in full.

### Key files
- `tools/compareResultsWithNprcgenekeepr.R:28` (`runCases()`), `:134-179` (Phase 8's inputs: `lay`, the made-up
  columns, `bothStyles()`), `:331-403` (Phase 8's 9 cases), `:180` (the `cases` list).
- `tests/testthat/test_positionMatingUnitForest.R:3-13` (its header: what R31 left out);
  `tests/testthat/test_comparePedigreeStructure.R:3-10` and `helper-comparePedigreeStructure.R:3-9` (S10's headers,
  the model for Phase 9's).
- `makePedigreeMatingLayout()` is at `R/makePedigreeDiagramData.R:1670`; `R/affectedConditions.R:3-9` (header:
  lines 1-75 only, R32); `DIVERGENCE.md:14-16`.
- `methodology/.quality-gates.json` (4 gates); `CLAUDE.md:89` (phase gates), `:158` (Learning 3), `:164-168`
  (Learnings 9-13).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S9's entries were removed in S3-S10 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 11 Did
**Deliverable:** plan Phase 9, the renderer: `drawPedigreeDiagram()`, `R/deceasedSlash.R` and `R/affectedConditions.R`'s
lines 77-201 copied test-first from nprcgenekeepr, fidelity cases, push, CI, Phase 9 DONE (IN PROGRESS)
**Started:** 2026-11-12 · **Model:** Claude Opus 5.5 · Mark picked "Start Phase 9" at the orient picker.
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 9 Handoff Evaluation (by Session 10)
**Score: 9/10.**
- **What helped:** every line number it cited was right (the 15 calls and 2 reads at `baef1e12c`, the tool's `:26`,
  `:128`, `:94-103`); the nprcgenekeepr diff command (empty, as said); the copy-script recipe (assert each line, then
  diff), used as written; nprcgenekeepr's own-run recipe, which worked first time (38 tests, 132 expectations); the
  measured layout times, which sized the cases; the warning to read the Ubuntu jobs closely (the math-library skips
  were there).
- **What was missing:** that the layout prints a message the results tool did not record (found by timing it); that 3
  of the 38 copied tests pass in RED (they test the helper and kinship2, not package code).
- **What was wrong:** "16 `nprcgenekeepr:::` calls": 15 calls and one comment (`helper-comparePedigreeStructure.R:23`).
  Harmless: the copy script asserted each line.
- **ROI:** high.

### What Session 10 Did
**Deliverable:** plan Phase 8, second of its two sessions (R30): `R/comparePedigreeStructure.R` test-first, the
layout's fidelity cases, push, CI, Phase 8 DONE (DONE)
**Started:** 2026-11-11 23:05 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Finish Phase 8"; case size "Whole
to 400, else 20"; "Compare messages too"; extra cases: made-up columns, comparison functions, error stops; the three
gates "Yes"; REFACTOR "Yes, fix the comment". No picker needed clarifying.
**Commits:** claim `a0b9eff`; RED `fd101dc`; GREEN `a7a7ffb` (the code), `7428d12` (the tool's 9 cases); REFACTOR
`6db58ca`; pushed once (23 commits, `16a8799..6db58ca`); close-out `f39372d` and close-out 2 (these notes, the
receipt, the ledger). Close-out commits not pushed.
**Verified:** suite 466 tests, 0 failed, WARN 0; the 38 new tests check as many expectations each as nprcgenekeepr's
own run (132); lint 0 (package and 5 tools); roxygen leaves `NAMESPACE` and `man/` unchanged; `R CMD check
--as-cran` Status 1 NOTE (Maintainer, New submission), tests PASS 2010; coverage 96.84%, the new file 99.30%; drift
tool exit 0 (81 copied functions, 3 recorded); results tool exit 0, 468 of 468 identical (27 with warnings, 60 with
messages), kinship 132 matrices, largest difference 0; CI run `43260600901` 5/5 `Status: OK`, first attempt;
`quality_ratchet` 4/4.
**Self-assessment: 8/10.**
+ Measured before each picker (subset sizes and layout times at 20 and 40 animals, the message no record caught);
  all four pickers answered at once; the copy proven by machine (asserted lines, diff of only the planned hunks);
  covr run over the tests and over the cases, and a variant added for the gap it showed; CI read per job down to the
  skip reasons; Phase 9 measured for the next session, which found the changed source file and the docs test.
- Careless slips, each caught within a minute: a scratch script wrote a results file outside the project (deleted),
  a build log went to `/tmp` (deleted), `tail`'s exit status read as the drift tool's (re-run), and the `===`,
  `Rscript -e` and `$C:t` zsh traps, the first two of which the handoff had named.
**Ledger:** `CHANGELOG.md` S10 entries (the session and the push).
