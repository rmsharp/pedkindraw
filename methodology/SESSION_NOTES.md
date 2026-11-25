# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17j DONE (S33-S88); the gap
phases G1-G17 DONE (S42-S77). **17j DONE (S87-S88, R161-R162):** covr (`type = "tests"`, `NOT_CRAN=true`) reads 7 of
3,772 statements never run at `4955fa5` (99.81%), each recorded unreachable with its reason (the cran plan's 17j note,
`:826`; R162 at `docs/planning/standalone-pedigree-package-plan.md:341`). S88 added 4 test files (13 tests, 47
expectations) and a helper; no `R/` file changed. **Found by S88, open:** `makePedigreeMatingLayout()` stops with R's
or an internal message on a pedigree with a parent id that has no row (430 of 1,171 random ones; one animal whose
sire has no row and whose dam is unknown is enough), and on a repeated id; nprcgenekeepr the same
(`methodology/BACKLOG.md:11`, DECISION NEEDED, before 17k by Mark's pick). Also open: the Windows job that does not
end (`:30`).
**Next, recommended: the crash item (`:11`)**, a picker first: stop at once with a clear message naming the ids (and
pointing to `addParents()`), or add the missing parents as the app does (`R/pedigreeApp.R:203`); refuse a repeated
id; tell nprcgenekeepr or not. Measure each option's effect on the 2,000-pedigree search before the picker (Learning
17; the search's method is in dragon 32, the scripts are gone). A code change to copied code: a `DIVERGENCE.md` row
(drift rule). Then 17k (one win-builder reading; Mark approves the upload).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** the crash item (recommended), 17k, or the Windows item (`:30`). Also, from
`methodology/BACKLOG.md` (31 items, each at its line by `grep -n '^- \[ \]'` after S88's close-out; S88 added `:11`
and removed the 17j item, so the items from `:30` to `:132` moved down 19 lines and the rest kept theirs): READY,
rewording `DIVERGENCE.md`'s older rows (`:55`), the legend's labels in a narrow drawing (`:73`), the drawing
vignette's measured trait (`:83`), a twins table with no rows (`:89`), `savePedigreeDiagram()` and a `CHROMOTE_CHROME`
naming no file (`:99`), the `smallPed` fixture (`:132`), `findPedigreeNumber()`'s speed (`:275`), poppler in CI
(`:291`), the label counts in `largeIds` (`:258`), and the nine "Ready, small" items (`:186` the suite gate's time
limit, `:198` the stale pedkindraw 0.0.1, `:205` the drift tool and copied constants, `:214` the context-budget tool,
`:224` CI notices, `:241` report a vacuous test, `:247` tell nprcgenekeepr's edition-3 conversion, `:263` the gaps
plan's stale cells, `:310` tell nprcgenekeepr its timing rows' `started`); NEEDS DECISION, Pedixplorer's `avail`
(`:108`), long names at the edges (`:116`), a colony's ids under a point high (`:125`), `findGeneration(alignMates =
TRUE)`'s speed (`:281`), `HANDOFFS.md`'s growth past its trimmer (`:301`); "Waiting on Mark", the dashboard and
`methodology/BACKLOG.md` (`:149`), copying the colony overview (`:156`), the app's features left for later (`:163`),
an animal with two mates drawn once (`:175`). BLOCKED, so not offered: `:64` (retire the drift tools), `:143` (N3).
Name every item in the picker (memory "Picker sets: name items, include all"; at most 4 options, so group them and
name each in a preview).
**Session boundary:** one session (the crash item, or 17k), then close out.
**Priority:** HIGH (the crash item, then 17k-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S88 changed tests only; `git diff c48cde4
   HEAD -- R/` is empty); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr at
   `3e06730c5`, tree clean, through S88.
2. **S88's push was read** (the CHANGELOG's S88 push entry): pkgdown `success`; R-CMD-check Ubuntu release and
   oldrel-1 OK `[ FAIL 0 | WARN 0 | SKIP 34 | PASS 16847 ]` (S87's plus 47), macOS OK `PASS 16858`, Windows `FAIL 0 |
   PASS 16856` then the hang (cancelled at 40 min, `:30`), Ubuntu devel failed loading S4Vectors (`:224`). Nothing to
   read at Orient beyond `gh run list`.
3. **The crash item, if picked:** read `:11`, R162 and dragons 31-32 (`docs/planning/cran-submission-plan.md:1083`,
   `:1092`). The stops: `R/orderRootSubtrees.R:62` (no roots: every animal of a component has a parent edge or is a
   mate drawn beside its partner), `R/makePedigreeDiagramData.R:1689` (`.penaltyMatrix()`, after `:1529` skips an
   anchor tier 1 never placed), "subscript out of bounds" (22, not traced), `node stack overflow` (a repeated id).
   `makePedigreeMatingLayout()`'s checks are at `R/makePedigreeDiagramData.R:2236`-`:2265`; `@param ped` at `:1843`.
   Rebuild the search (dragon 32: a copy with `.hit("<line>")` on the line itself; seeded pedigrees whose parents come
   from earlier rows and whose `gen` is their depth; a share with sires `X1`-`X3` and dams `Y1`-`Y3` that have no
   row; tally the stops by message) and measure each option on it before the pre-RED picker.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **A break no test catches** (dragon 31): read each one. Removing `:3022`'s `next` or `:3427`'s early return
  changes no output (recorded); 3 other misses in S88's drafts were inputs where the right and wrong answers agreed.
- **`testthat::test_file()` leaves `tests/testthat/_problems/`** when a test fails; S88 saw it in a scratch copy.
  Never commit it.
- **R's `grepl("\\b...")` needs `perl = TRUE`**: without it S88's first tally read 0 for a line reached 67 times.
- **The random search's `kinship()` refusals** ("pdepth must be greater ...") are its designed check, not a crash:
  made-up `gen` values. Count them apart.
- **A count's denominator:** S88's picker said "430 of 1,135", which left out 36 refusals; R162, the plan and the
  backlog say 1,171. State what each count includes.
- **covr reach checks are fast here:** `covr::package_coverage(type = "none", code = <the test files>)` on four small
  files took 8 s; `covr::function_coverage(fn, env = asNamespace("pedkindraw"), code = ...)` a few seconds a case.
  The whole-suite run took 12.4-13.1 min.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to renv's library; the
  5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, about 10 min, on a
  `git archive` copy); `CLAUDE.md` is over its budget (learnings go to the plans' dragons; the cran plan's section 9
  now ends at 32); `pedkindraw.Rproj` untracked, Mark's; `methodology/HANDOFFS.md` past its trimmer (`:301`): keep
  the receipt short; the browser tests print `got non-close frame while closing` on stderr (not a warning); a push
  whose head commit's message holds the skip marker anywhere runs no workflow (write it in words); the app's browser
  test can time out once on the macOS runner (S87).
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17j2's tests: `tests/testthat/test_packComponentsSeparateRows.R` (`:27`, `:37`),
  `tests/testthat/test_addRectilinearWaypointsDogleg.R` (`:31`-`:88`),
  `tests/testthat/test_addRectilinearWaypointsInputs.R` (`:20`, `:30`, `:50`, `:71`),
  `tests/testthat/test_resolveEdgeNodeCollisionsCases.R` (`:18`, `:27`, `:41`);
  `tests/testthat/helper-addRectilinearWaypoints.R:11` (`.directStyleInputs()`, S88's REFACTOR).
- The crash: `R/orderRootSubtrees.R:62`; `R/makePedigreeDiagramData.R:1529` (the skip), `:1671` (`.penaltyMatrix()`),
  `:1689` (the stop), `:2222` (`makePedigreeMatingLayout()`), `:2236`-`:2265` (its checks), `:1843` (`@param ped`);
  `R/pedigreeApp.R:203` (`addParents()` before the layout).
- The plans: `docs/planning/cran-submission-plan.md:826` (17j2's note), `:857` (17k), `:1083`, `:1092` (dragons
  31-32); R162 at `docs/planning/standalone-pedigree-package-plan.md:341`; backlog `:11`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 89 Did
**Deliverable:** backlog `:11` (R162, before 17k), strict TDD: `makePedigreeMatingLayout()` stops with R's or an
internal message on a pedigree with a parent id that has no row, and on a repeated id. (IN PROGRESS)
**Started:** 2026-11-24 22:30 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Fix the layout crash
(Recommended)" (orient picker).
**Status:** Session claimed. Work beginning: the 2,000-pedigree search rebuilt (dragon 32), each fix measured on it,
then the pre-RED picker (Learning 17).
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.
Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### What Session 88 Did
**Deliverable:** Phase 17j2 (R161's split of 17j, `docs/planning/cran-submission-plan.md:826`), strict TDD: the 29
statements of `R/makePedigreeDiagramData.R` no test ran, each reached by a test or recorded unreachable. DONE, so 17j
DONE.
**Started:** 2026-11-24 20:38 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "17j2: layout coverage (Recommended)" (orient); R162's three in one picker ("Test by direct
calls", "Keep as copied, record why", "Backlog, before 17k"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes,
REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `c48cde4`; R162 `7464409`; RED `4955fa5`; GREEN `cd7b162` (empty: the measurements); REFACTOR
`ee637d0`; close-out 1 `bade5c8` (the plans, roadmap, dragons 31-32); close-out 2 (the count corrected in R162 and the
plan, the backlog, these notes, the receipt, the ledger), pushed after it (`d09b672..c03c96b`); close-out 2b (the push
entry; these notes and the receipt to CI's results).
**Measured first:** covr on a `git archive` of `c48cde4` (31 of 3,772, 13.1 min, each with its column); each of the 29
read beside its comment and its input tried in a scratch copy (`covr::function_coverage()` per function); a copy
counting each target line run over 2,000 seeded random pedigrees (the 5 never reached but `:1529`, always followed
by a stop; the crash found and tallied, and checked on nprcgenekeepr's HEAD); the drafts' expected values computed
first; the drafts broken 72 ways (5 uncaught at first: 3 inputs tightened, 2 removals that change no output); covr
on the drafts alone (24 of 24 reached); CRAN-mode time; then the pickers.
**Verified:** RED's four files 13 tests, 47 expectations, 0 failed, 0 skipped, WARN 0; 70 of 72 broken copies of the
RED tree failing; covr on `4955fa5` 7 of 3,772 (99.81%), the 24 reached; the full suite on a `git archive` of
`4955fa5` (`NOT_CRAN=true`) 101 files, 1,182 tests, 17,073 expectations, 0 failed, 0 skipped, WARN 0 (10.0 min); `R
CMD check --as-cran` on `4955fa5` Status 1 NOTE (R16's), tests 197 s in CRAN mode; the new files 0.78-0.83 s in CRAN
mode; REFACTOR per-test identical, 70 of 72 still; lint 0; roxygen unchanged; no saved expect condition; drift 91 / 23
/ 0; quality_ratchet at close-out 2 (the receipt).

#### Session 87 Handoff Evaluation (by Session 88)
**Score: 9/10.** ROI high: 17j2 ran from its notes, and every cited line and count was where it said.
- **What helped:** What You Must Do 1 (drift 91/23/0, nprcgenekeepr's 4 commits and `3e06730c5`, each as stated); 3's
  methods in words (the whole-suite covr command, the quick reach check, the broken-copy recipe) and "break each
  statement three ways" (dragon 29), which found the three weak test inputs; the key files by line (`:656`, `:986`,
  `:1109`, the comment `:1515`-`:1521`, `:2911`, the dogleg `:3017`-`:3062`, `:3257`, `:3393`), all exact; the
  backlog item's 29 by line and function; "16 ... not proved", labelled as a reading, which it was.
- **What was missing:** that `makePedigreeMatingLayout()` takes the caller's `gen`, the key to `:996`; that a mating
  with both parents missing reaches `:3022` through a drawing; that some statements' removal changes no output, so
  dragon 29's three breaks cannot all fail. Each found by reading or measuring, none costly.
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 7/10.**
+ Orient in full, the claim before any work; every reach measured, every "unreachable" read and then checked over
  2,000 random pedigrees, every expected value computed and every test broken before the first picker (Learnings
  17-20, dragon 29); R162 recorded in its session; GREEN's counts as predicted (7 of 3,772, 17,073); the crash found
  by the search, tallied by kind and checked on nprcgenekeepr; the REFACTOR measured before its gate.
- **A slip that reached Mark:** the R162 picker said the crash hit "430 of 1,135" pedigrees with a missing parent;
  1,135 left out 36 refused by `kinship()`'s check, while the "739" beside it counted its refusals. Found re-reading
  the table at close-out; R162 (`7464409`) and the cran plan corrected in close-out 2, which says so.
- **Slips caught before a commit:** a draft test expected `150` where the function gives `150L`; three draft inputs
  where right and wrong answers agreed (dragon 31); the first random generator mostly made invalid pedigrees; a
  `\\b` pattern without `perl = TRUE` read 0 for 67; plan text said 66 stops were in `.penaltyMatrix()` (traced for
  2) and that the search took "3 minutes" (not timed).

### What Session 87 Did
**Deliverable:** Phase 17j1 (R161's split of 17j, `docs/planning/cran-submission-plan.md:793`), strict TDD: tests for
the statements no test ran outside `R/makePedigreeDiagramData.R`. DONE.
**Started:** 2026-11-24 15:52 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "17j: coverage tests (Recommended)" (orient); "5 small files now (Recommended)" (scope); R161's
three in one picker ("Prove on broken copies", "Keep, record why", "Hand-edited layout test"); "Yes, proceed to
RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `a423bcf`; R161 `5bb45cb`; RED `af4f23b`; GREEN `b93f508` (empty: the measurements); REFACTOR
`d1414b9`; close-out 1 `0564a34` (the plans, roadmap, dragons 29-30); close-out 2 (the backlog, these notes, the
receipt, the ledger), pushed after it (`0a98b69..3e600c9`); close-out 2b (the push entry; these notes and the
receipt corrected to CI's results).
**Measured first:** covr on a `git archive` of `a423bcf` (40 of 3,772, 12.3 min); each of the 40 read and sorted;
for the 11 in scope, each input tried in a scratch copy, the reach confirmed by covr running only the drafts, and each
draft broken three ways where it mattered (`:338`'s first draft passed with the error swallowed, so it was tightened
before the gate); `:118` and `:131` proved unreachable by reading, by the suite's counts and, for `:131`, a scratch
call with a `childrenOf` that changes its answers (it reaches `:131`; an honest one does not). Then the pickers.
**Verified:** RED's four files 39 tests, 250 expectations, 0 failed, 0 skipped, WARN 0, and 11 of 11 broken copies of
the RED tree failing, each one line apart from it; covr on `af4f23b` 31 of 3,772 (99.18%), the 9 reached; the full
suite on a `git archive` of `af4f23b` (`NOT_CRAN=true`) 97 files, 1,169 tests, 17,026 expectations, 0 failed, 0
skipped, WARN 0 (594 s); `R CMD check --as-cran` on `af4f23b` Status 1 NOTE (R16's), tests 190 s in CRAN mode,
installed size OK; CRAN mode, the new tests about 0.2 s; REFACTOR's stubs `identical()` to the old ones, the file 32
tests and 222 expectations as at GREEN, the three `:338` copies still failing; lint 0; no saved expect condition;
drift and `R/` unchanged; quality_ratchet 5/6 pass, 0 fail, 1 unmeasured (the suite gate's 300 s; the suite by hand
above).

#### Session 86 Handoff Evaluation (by Session 87)
**Score: 9/10.** ROI high: 17j1 ran from its notes, and every cited line and count was where it said.
- **What helped:** What You Must Do 1 (drift 91/23/0, nprcgenekeepr's 4 commits and `3e06730c5`, each as stated);
  3's "re-measure first" with the command, "a guess of 15-30" min labelled as one (covr took 12.3), "new tests go in
  pedkindraw's own test files" and the gotcha "17j's statements are in copied files", which set the test files'
  place before any picker; the orient picker's 30 items, each at its line; the `Rscript --no-init-file` gotcha, used
  in every run.
- **What was missing:** whether S24 ran covr with `NOT_CRAN=true` (not recorded, so the 43 is compared, not matched);
  how RED applies when the tests reach code already written (found by search: dragon 39 of the picture plan); that
  the copied layout code labels its own branches "structurally unreachable" (`:1517`), which shaped the split.
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; covr before the first picker, and the scope picker with counts; each
  input tried, each reach confirmed by covr and each test proved on broken copies before RED (Learnings 17-18, dragon
  39); R161 recorded in its session; GREEN's suite read 17,026 as predicted; the REFACTOR measured before its gate;
  the backlog item cut from 28 lines to 18 (FM #28).
- **Slips, none reaching a commit:** the first `:338` draft could not tell Chrome's error from a later one (caught by
  my own broken copy; dragon 29); a draft comment named Chrome 158 where this Mac has 157; the RED gate's preview
  said the headers name R161 when the drafts did not (fixed before the copy); a first layout trial left out the `gen`
  column; `as.data.frame()` of a saved covr result without `library(covr)`.

### What Session 86 Did
**Deliverable:** Phase 17i2 (`docs/planning/pedkindraw-timing-plan.md:633`, R159), strict TDD: the pointers to
`vignette("speed")`, T5's section in `?drawPedigreeDiagram`, the API contract's sections 7 and 8. DONE, so 17i DONE.
**Started:** 2026-11-24 14:30 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "17i2: point to speed page (Recommended)" (orient); R160's four in one picker ("Own section",
"Keep it, add ours", "New last column", "Add one sentence"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes,
REFACTOR (Recommended)". No correction and no tool use declined. Mark asked mid-session why the installed size
(4,736 KB) differs from the tarball (1.6 MB): answered from measurements (dragon 42).
**Commits:** claim `88ce5b5`; R160 `271e10f`; RED `f8bdbe3`; GREEN `4940df9` (help), `6931e95` (vignettes, NEWS); the
contract `0c537c8`; REFACTOR `5ad8294`; close-out 1 `113572b` (the plans, roadmap, dragons 41-42); close-out 2 (the
backlog, these notes, the receipt, the ledger), pushed after it.
**Measured first:** every word drafted in a scratch copy (`git archive HEAD`), roxygen run there, the 6 new tests
run on `dfbd587`'s files (6 of 6 failing, 0 skipped) and on the drafts (6 of 6 passing), the 27 existing docs tests
passing, lint 0; then the pre-RED picker. The REFACTOR the same way before its gate.
**Verified:** RED 6 of 6 failing, 0 skipped, each on its missing words; GREEN 46 expectations passing; the full suite
on a `git archive` of `6931e95` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16993 ]` (597 s); `R CMD check
--as-cran` on `6931e95` Status 1 NOTE (R16's), installed 4,736 KB, the built `drawing.html` holding the pointer;
`drawPedigreeDiagram.R`'s parsed code identical to before; `tools::checkRd()` clean, the section rendered by
`Rd2txt()`; roxygen unchanged; lint 0; drift 91 / 23 / 0; `tools/checkSpeedTables.R` 0 problems; the contract's 30
figures each equal to its cell; REFACTOR's 33 docs tests identical per test (212 expectations); quality_ratchet 5/6
pass, 0 fail, 1 unmeasured (the suite gate's 300 s; the suite by hand above).
**CI (close-out 2b):** pushed `dfbd587..58aa09e`; pkgdown `success`, the site's three articles and every new word on
it; R-CMD-check Ubuntu release, oldrel-1 and macOS Status OK, `FAIL 0 | WARN 0` (SKIP 15 more than S77's run: the
speed docs tests, which skip without `vignettes/`); Windows's tests `FAIL 0` then the hang (cancelled at 40 min);
Ubuntu devel failed installing S4Vectors on R-devel, before pedkindraw (backlog `:234`, as since S48).

#### Session 85 Handoff Evaluation (by Session 86)
**Score: 9/10.** ROI high: 17i2 ran from its notes, and every cited line was where it said.
- **What helped:** What You Must Do 1 (drift 91/23/0 and nprcgenekeepr's 4 commits, each as stated); 3's reading
  list by line (4.3 `:310`, 4.4 `:324`, 17i `:633`, T5 `:683`, dragons `:795`) and the pointer places by line
  (`R/pedkindraw-package.R:52`, `vignettes/pedkindraw.Rmd:407`, `vignettes/drawing.Rmd:794` and `:808`, the contract
  `:323` and `:343`), all exact; "measure before the RED gate, S85's way", which became R160's picker; the gotchas
  "the help sentence moves `R/`'s tree" (17n's amendment) and the skip marker (applied at the push).
- **What was missing:** that `test_runPedigreeAppDocs.R` already holds the drawing vignette's "How large a drawing
  can be" and forbids "about 16 seconds" there (a pointer quoting the speed page's 16 s that way would fail it); that
  `.docsRdSection()` lived in a test file, not `helper-docs.R`; that the cran plan's status still read "Next: 17i".
  Each found by grep, none costly.
- **What was wrong:** nothing found ("a new paragraph before `@return`" was labelled a guess; a section before
  `@param` was chosen).
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every word and test drafted and run both ways in a scratch copy before
  the first picker (Learning 17), so RED, GREEN and REFACTOR each came out as predicted; R160 recorded in its
  session; the help's numbers held to the page by the test, not typed; the contract's figures proved cell by cell;
  the full suite and `R CMD check` on the GREEN commit; Mark's size question answered from measurements, not memory.
- **Slips, none reaching a commit:** a draft edit joined two roxygen lines into one of 119 columns (caught by a
  length check in the scratch copy); the first contract script asserted on a separator that is not unique (it wrote
  nothing; rerun); my failure-reason script stopped on passing tests; one `Rscript --no-init-file` run without renv's
  library; the first check of the contract's numbers (each anywhere in the tables) was too weak, replaced by a
  cell-keyed check before the commit; the REFACTOR's rename misaligned continuation lines (fixed in the scratch copy).
