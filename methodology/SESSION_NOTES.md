# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17j DONE (S33-S88); the gap
phases G1-G17 DONE (S42-S77). **The crash item before 17k DONE (S89, R163,
`docs/planning/standalone-pedigree-package-plan.md:343`):** `makePedigreeMatingLayout()` draws a pedigree with a
parent id that has no row, without that parent (an animal whose other parent is unknown drawn with no line up, as a
founder), where 676 of 1,181 random such pedigrees stopped with R's messages; the 505 that drew are unchanged in the
rectilinear style; a repeated id stops before any other check, naming it. Code `22fa0a4`, REFACTOR `89f39e7`; 9 new
tests; one existing test's input changed (`40436a1`, Mark's pick); `DIVERGENCE.md` rows; NEWS; the contract.
**Next, recommended: 17k** (`docs/planning/cran-submission-plan.md:857`): one win-builder R-devel reading of the tree
(Mark approves the upload; R86; S33 uploaded by FTP, D1), its tests' elapsed time against 540 s (R85). Nothing is
skipped if it reads 540 s or less.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). Pushed at close-out 2.
**The orient picker:** 17k (recommended), or the Windows item (`methodology/BACKLOG.md:11`). Also (32 items, each at
its line by `grep -n '^- \[ \]'` after S89's close-out; S89 removed the crash item, so the items from `:30` to `:132`
moved up 19 lines, added `:119` and `:130`, and the items after `:132` moved up 2): READY, rewording `DIVERGENCE.md`'s
older rows (`:36`), the legend's labels in a narrow drawing (`:54`), the drawing vignette's measured trait (`:64`), a
twins table with no rows (`:70`), `savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:80`), the
`smallPed` fixture (`:113`), the label counts in `largeIds` (`:256`), `findPedigreeNumber()`'s speed (`:273`), poppler
in CI (`:289`), and the nine "Ready, small" items (`:184` the suite gate's time limit, `:196` the stale pedkindraw
0.0.1, `:203` the drift tool and copied constants, `:212` the context-budget tool, `:222` CI notices, `:239` report a
vacuous test, `:245` tell nprcgenekeepr's edition-3 conversion, `:261` the gaps plan's stale cells, `:308` tell
nprcgenekeepr its timing rows' `started`); NEEDS DECISION, Pedixplorer's `avail` (`:89`), long names at the edges
(`:97`), a colony's ids under a point high (`:106`), **new:** `makePedigreeDiagramData()`'s two nodes for a repeated
id (`:119`), `findGeneration(alignMates = TRUE)`'s speed (`:279`), `HANDOFFS.md`'s growth past its trimmer (`:299`);
"Waiting on Mark", the dashboard and `methodology/BACKLOG.md` (`:147`), copying the colony overview (`:154`), the
app's features left for later (`:161`), an animal with two mates drawn once (`:173`). Not offered: `:130` (**new**,
tell nprcgenekeepr of R163's crash, a session Mark starts there), `:45` and `:141` (BLOCKED). Name every item in the
picker (memory "Picker sets: name items, include all"; at most 4 options, so group them and name each in a preview).
**Session boundary:** one session (17k, or one backlog item), then close out.
**Priority:** HIGH (17k-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S89 changed three functions that already
   had rows); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4
   commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr at `3e06730c5`, tree clean, through
   S89. The fidelity tool read 600 of 600 identical on `22fa0a4`'s code.
2. **S89's push was read** (the CHANGELOG's S89 push entry): pkgdown `success`; R-CMD-check run 45562065295: oldrel-1
   OK `[ FAIL 0 | WARN 0 | SKIP 36 | PASS 16994 ]`, macOS OK `SKIP 34 | PASS 17005`, Windows `FAIL 0 | PASS 17003`
   then the hang (cancelled at 40 min, `:11`), each S88's count plus 147 (S89's 157 less the docs tests' 10, which
   skip on CI: no `man/` or NEWS in an installed package, so SKIP is 2 more); Ubuntu release failed once, Chrome's
   debugging port not open after 10 s in `test_savePedigreeDiagram.R:458`, and its rerun read OK `PASS 16994`; Ubuntu
   devel failed loading S4Vectors (`:222`). Nothing to read at Orient beyond `gh run list`.
3. **17k, if picked:** read `:857`, R85, R86 and section 2.1. Build the tarball as CLAUDE.md's full check does, then
   ask Mark (picker) before any upload. S88 measured the CRAN-mode time of 17j's files (0.78-0.83 s); S89's new files
   take 0.8 s in CRAN mode (the random test skips). `R CMD check --as-cran` on `40436a1` ran its tests in 202 s here.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **A prototype carrying two changes** (dragon 33, S89): the picker and R163 said the repeated-id stop broke no test,
  because the suite that measured the repair ran without it and the two other prototypes' failure of
  `test_infertileMark.R` was put down to their parent change unread. Run the whole suite on the exact change the gate
  commits before a picker gives a count, and read each failure's message.
- **A test that builds its input by repeating rows** now stops at `makePedigreeMatingLayout()`'s repeated-id check
  (`R/makePedigreeDiagramData.R:2266`), before every other check: give the repeated value to distinct animals.
- **The layout's warning "edge-node collision(s) could not be fully resolved"** comes from random layouts; S89's
  random test muffles that warning alone (`test_makePedigreeMatingLayoutNoRowParent.R:131`-`:141`). WARN must stay 0.
- **`rm -rf "$VAR/..."` is refused** by Claude Code's safety check: write `"${VAR:?}"` or a literal path, or make new
  folders instead.
- **A backslash in `Rscript -e '...'`:** R read the `"\\s"` and `"\\("` S89 typed there as `"\s"` and `"\("`
  ("unrecognized escape", twice). Put such code in a file.
- **The fidelity and drift tools run from the repository root** (renv sets up both libraries, Learning 5), not from a
  scratch copy: there nprcgenekeepr's child stops on "openxlsx is required".
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to renv's library; the
  5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, about 10 min, on a
  `git archive` copy); `testthat::test_file()` can leave `tests/testthat/_problems/` (never commit it); `CLAUDE.md` is
  over its budget (learnings go to the plans' dragons; the cran plan's section 9 now ends at 33);
  `pedkindraw.Rproj` untracked, Mark's; `methodology/HANDOFFS.md` past its trimmer (`:299`): keep the receipt
  short; the browser tests print `got non-close frame while closing` on stderr (not a warning); a push whose head
  commit's message holds the skip marker anywhere runs no workflow (write it in words); state what a count's
  denominator includes; a browser test can fail once on a runner when Chrome's port is not open within 10 s (S87
  macOS, S89 Ubuntu release): rerun that job once (`gh run rerun <run> --job <job>`) before reading it as a defect.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- The repair: `R/makePedigreeDiagramData.R:865` (`knownParent`; no line from a parent with no row), `:1272`
  (`noLineInIds`, the roots), `:2266` (the repeated-id stop), `:1855` (`@param ped`), `:115`-`:120` (the header);
  `man/makePedigreeMatingLayout.Rd`; NEWS.md's Drawing section (the last "New:" line).
- The tests: `tests/testthat/test_makePedigreeMatingLayoutNoRowParent.R` (`:27`, `:37`, `:51`, `:69`, `:80`, `:93` the
  random one, `:158` the repeated id), `tests/testthat/test_makePedigreeMatingLayoutNoRowParentDocs.R` (`:10`, `:24`),
  `tests/testthat/test_infertileMark.R:232`-`:238` (the input changed).
- The records: R163 at `docs/planning/standalone-pedigree-package-plan.md:343`; `DIVERGENCE.md` (the rows of
  `makePedigreeMatingLayout()`, `.positionMatingUnitForest()`, `.buildMatingUnitForest()`); the contract's row for
  `makePedigreeMatingLayout()` (`docs/planning/pedkindraw-api-contract.md:135`); dragon 33 at
  `docs/planning/cran-submission-plan.md:1100`; 17k at `:857`; backlog `:119`, `:130`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 90 Did
**Deliverable:** Phase 17k (`docs/planning/cran-submission-plan.md:857`; R85, R86): one win-builder R-devel reading
of the tree after 17j, its tests' elapsed time against 540 s. (IN PROGRESS)
**Started:** 2026-11-25 06:13 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "17k: time tests on win-builder
(Recommended)" (orient picker).
**Status:** Session claimed. Work beginning: build the tarball, then a picker before any upload.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest.

### What Session 89 Did
**Deliverable:** backlog item "`makePedigreeMatingLayout()` stops on a pedigree with a parent id that has no row"
(R162, before 17k), strict TDD. DONE (R163).
**Started:** 2026-11-24 22:30 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "Fix the layout crash (Recommended)" (orient); R163's three in one picker ("Repair the layout",
"Stop, naming the ids", "Tell it: a backlog item"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; in GREEN, after
the repeated-id stop broke an existing test, "Change that test's input"; "Yes, REFACTOR". No tool use declined; one
`rm -rf` on shell variables was refused by Claude Code's safety check (new folders made instead).
**Commits:** claim `c5053b7`; R163 `413b075`; RED `63f072f`; GREEN 1 `22fa0a4` (code, help, NEWS); GREEN 2 `d13fa62`
(`DIVERGENCE.md`, the contract); GREEN 3 `40436a1` (`test_infertileMark.R`'s input); R163 corrected `c1631d2`;
REFACTOR `89f39e7`; close-out 1 `0ca28d3` (the plans, roadmap, dragon 33); close-out 2 `0328615` (the backlog, these
notes, the receipt, the ledger), pushed after it (`5c5914d..0328615`); close-out 2b (the push entry; these notes and
the receipt to CI's results).
**Measured first:** the search rebuilt (2,000 seeded pedigrees; another generator than S88's): 676 of 1,181 with a
parent that has no row stopped, 78 of 81 with a repeated id; the stops traced to one cause (an animal whose only
recorded parent has no row is never reached, and gets a line from no node); three prototypes (repair, add the
parents, stop at once), each run on the search and through the whole suite; every repaired layout compared with
today's in both line styles and drawn by `drawPedigreeDiagram()`; kinship2's and Pedixplorer's handling; the drafts'
expected values computed on a GREEN prototype and the drafts run on three broken copies.
**Verified:** RED 9 of 9 failing on the tree, 0 skipped, WARN 0; GREEN on `40436a1`: the full suite (`NOT_CRAN=true`)
103 files, 1,191 tests, 17,230 expectations, 0 failed, 0 skipped, WARN 0 (612 s); `R CMD check --as-cran` Status 1
NOTE (R16's), its tests `[ FAIL 0 | WARN 0 | SKIP 94 | PASS 13836 ]` in 202 s; the fidelity tool 600 of 600 identical;
drift 91 / 23 / 0; lint 0; roxygen unchanged; REFACTOR: 2,000 of 2,000 forests and layouts identical, the 16 layout
test files identical test by test; two repaired drawings saved as PNG through Chrome and looked at (both styles);
quality_ratchet 5/6 pass, 0 fail, 1 unmeasured (the suite gate's 300 s; the suite by hand above).

#### Session 88 Handoff Evaluation (by Session 89)
**Score: 9/10.** ROI high: the crash item ran from its notes, and every cited line was where it said.
- **What helped:** What You Must Do 3, the stops by line (`R/orderRootSubtrees.R:62`, `:1529`, `:1689`, the checks
  `:2236`-`:2265`, `@param ped` `:1843`, `R/pedigreeApp.R:203`), all exact; the search's method in words (dragon 32),
  rebuilt in minutes; the backlog item's smallest inputs, which became the trace's and the tests' cases; "the code's
  comments treat a missing parent as supported", which pointed to a third option; the gotchas on a count's
  denominator and on `kinship()`'s refusals.
- **What was missing:** that the three stops of a missing parent share one cause (S88 traced 2 of the kinds;
  "subscript out of bounds" was "not traced"); that repairing the layout was an option beside stopping and adding
  the parents. Both found by tracing, not costly.
- **What was wrong:** nothing found (S89's counts differ from S88's because its generator differs, as R163 says).
- **ROI:** high.

**Self-assessment: 6/10.**
+ Orient in full, the claim before any work; the cause traced to two lines of copied code before any picker; a third
  option found and measured beside the two the handoff named; each option run through the search and the suite;
  every repaired layout compared with today's and drawn; the drafts proved on broken copies; R163 recorded in its
  session; the drawings looked at in Chrome.
- **A slip that reached Mark twice:** the R163 picker said the repeated-id stop changed no existing test, and the
  GREEN gate expected 17,073 + 157 expectations. The suite that measured the repair ran without the stop, and the two
  other prototypes' failure of `test_infertileMark.R` was put down to their parent change without reading it. `R CMD
  check` on GREEN 1 found it; it cost Mark one more picker, GREEN 3 and a correcting commit (`c1631d2`); dragon 33.
- **Slips caught before a commit:** a draft drew a parent with `sample(m, 1L)`, which samples `1:m` when `m` is one
  number; a draft raised 5 warnings (the layout's collision warning, now muffled alone); two `Rscript -e` escapes; a
  monitor that fired on any log line; an `rm -rf` the safety check refused.

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
