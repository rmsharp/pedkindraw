# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17j DONE (S33-S88); the gap
phases G1-G17 DONE (S42-S77); the crash item before 17k DONE (S89, R163). **17k IN PROGRESS (S90):** the tarball (the
package as at `89f39e7`, built from `ad23242`, SHA-256 `323e6a8b...4505cfdf46`) was checked here (`Status: 1 NOTE`,
R16's; tests 188 s) and uploaded by FTP to win-builder R-devel at 14:17 UTC on 2026-11-25 (Mark's pick). At 16:13 UTC
it still sat in win-builder's R-devel queue, 15 packages ahead, the oldest there since 11:34 UTC (dragon 34), so no
email had come. Mark closed S90 to wait.
**Next, by Mark's pick ("Close; next: Windows hang (Recommended)"):** if win-builder's email has reached Mark, finish
17k first: its results folder is removed about 72 hours after the check. Otherwise the Windows CI hang
(`methodology/BACKLOG.md:11`): 17l's and 17n's DONE need all five CI jobs passing.
**Status:** 17k waits on win-builder; no other work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's).
Pushed at close-out 2.
**The orient picker:** ask first whether the email has come (and list the queue, What You Must Do 2). Then: finish 17k
(if the email is in), the Windows item `:11` (recommended otherwise), and the rest grouped and named as S89's notes
did (32 items, each at its line by `grep -n '^- \[ \]'`; S90 changed no backlog line): READY `:36`, `:54`, `:64`,
`:70`, `:80`, `:113`, `:256`, `:273`, `:289`, and the nine small ones `:184`, `:196`, `:203`, `:212`, `:222`, `:239`,
`:245`, `:261`, `:308`; NEEDS DECISION `:89`, `:97`, `:106`, `:119`, `:279`, `:299`; "Waiting on Mark" `:147`, `:154`,
`:161`, `:173`. Not offered: `:130` (a session Mark starts in nprcgenekeepr), `:45` and `:141` (BLOCKED). Name every
item (memory "Picker sets: name items, include all").
**Session boundary:** one session (finishing 17k, or one backlog item), then close out. A session running when the
email arrives does not take 17k on as a second deliverable.
**Priority:** HIGH (17k-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**); nprcgenekeepr's log on the copied files,
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`); nprcgenekeepr at `3e06730c5`, tree clean (both rechecked at S90's close-out).
2. **Where 17k's upload is:** `curl -sS ftp://win-builder.r-project.org/R-devel/` lists the files not yet started
   (server clock UTC+1; ours `pedkindraw_0.0.1.tar.gz`, 1,697,606 B, listed "03:17PM"). Gone from the list means the
   check started; Mark's email follows it, carrying the results link and "Check time in seconds".
3. **Finishing 17k (if the email is in):** read `:857`-`:883` (17k, what its 540 s is, the In progress note), dragon 8,
   section 2.1's 17a table (`:130`). Fetch the results folder's logs into the scratchpad (`00check.log`,
   `examples_and_tests/tests/testthat.Rout` for `proc.time()`); record the check time, each step's time, the tests'
   elapsed against CPU and the NOTEs beside 17a's; decide against 540 s. A reading near 540 s is uploaded again before
   it decides anything (dragon 8); over 540 s, a picker on the test files to skip on CRAN (section 2.1's table,
   re-measured), in TDD. If the folder is gone or no email came, rebuild and upload again (Mark approves).
4. **The Windows item (otherwise):** read `:11` (eleven readings); `.github/workflows/R-CMD-check.yaml` (107 lines; the
   matrix `:27`-`:33`, the Chrome steps `:55`-`:102`, the check step `:104`); `tests/testthat/helper-savePedigreeDiagram.R:262`-`:276`
   (`.saveChrome`, the shared Chrome). One change per push (no Windows machine here), each run cancelled at 40 min if
   it hangs (`gh run cancel`). CI runs on a push to master or a pull request, not on a push that changes only
   `methodology/**` or `CLAUDE.md`.
5. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **win-builder's R-devel queue can hold an upload for hours** (dragon 34): no email means the check has not run, not
  that the upload failed. List the queue first.
- **A rebuilt tarball is a new file:** `R CMD build` writes the build time into DESCRIPTION's `Packaged` field, so
  its SHA-256 differs from `323e6a8b...` (R's behaviour, not measured here). S90's tarball sits at
  `/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/6466c3d5-e987-43b3-b126-a66136537018/scratchpad/b17k/build/pedkindraw_0.0.1.tar.gz`
  until the scratchpad is cleared.
- **Picker labels in Mark's voice:** S90's "You upload it by FTP" beside "I upload it myself" meant Claude uploads;
  S33's "I upload it via FTP" meant the same in Claude's voice. Say who acts in the description too.
- **"In a new session" means after close-out** (Mark, S90): when he asks what a new session could do while waiting,
  answer with the next session's work, not a parallel session or worktree.
- **The 540 s is the email's check time** (R85), not the tests' time; the tests' elapsed against CPU says whether
  win-builder was busy (17k, `:868`). S89's notes and S90's claim said "its tests' elapsed time against 540 s".
- **Carried:** a test that repeats rows now stops at the repeated-id check (`R/makePedigreeDiagramData.R:2266`); the
  layout's collision warning comes from random layouts (S89's random test muffles it alone); `rm -rf "$VAR/..."` is
  refused (write `"${VAR:?}"` or make new folders); backslashes in `Rscript -e` (put such code in a file); the
  fidelity and drift tools run from the repository root; one-off scripts as `Rscript --no-init-file` with `R_LIBS` and
  `R_LIBS_USER` set to renv's library; the 5-file cap splits commits; the ratchet's suite gate times out at 300 s;
  `testthat::test_file()` can leave `tests/testthat/_problems/` (never commit it); `CLAUDE.md` is over its budget
  (learnings go to the plans' dragons; the cran plan's section 9 now ends at 34); `methodology/HANDOFFS.md` past its
  trimmer (`:299`): keep the receipt short; a push whose head commit's message holds the skip marker anywhere runs no
  workflow (write it in words); a browser test can fail once when Chrome's port is not open within 10 s: rerun that
  job once before reading it as a defect.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17k: `docs/planning/cran-submission-plan.md:857` (the phase), `:868` (what the 540 s is), `:871` (S90's In progress
  note: the tarball, the local check, the upload, the queue), `:130` (17a's win-builder table, where the reading goes
  beside it), `:1124` (dragon 34); R85 and R86 at `docs/planning/standalone-pedigree-package-plan.md:265`-`:266`.
- The Windows item: `methodology/BACKLOG.md:11`; `.github/workflows/R-CMD-check.yaml`;
  `tests/testthat/helper-savePedigreeDiagram.R:262`.
- S33's win-builder notes (the upload command, the email, the result folder): `git show
  15c7627:methodology/SESSION_NOTES.md`, its Gotchas.

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
**Deliverable:** Phase 17k (`docs/planning/cran-submission-plan.md:857`; R85, R86): one win-builder R-devel reading of
the tree after 17j against 540 s. IN PROGRESS: uploaded, the reading waiting in win-builder's queue.
**Started:** 2026-11-25 06:13 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "17k: time tests on win-builder (Recommended)" (orient); "You upload it by FTP (Recommended)"
(the upload); "Keep waiting (Recommended)" (the queue); "Close; next: Windows hang (Recommended)". One picker
rejected so Mark could clarify: it offered parallel sessions, and he meant closing this one ("I am not talking about
parallel sessions. I am talking about closing this session and starting a new one.").
**Commits:** claim `ad23242`; close-out 1 `7b38852` (the plans, roadmap, dragon 34); close-out 2 (these notes, the
receipt, the ledger), pushed after it; close-out 2b (the push entry).
**Measured:** the tarball built from a `git archive` of `ad23242` (package files unchanged since `89f39e7`, by `git
diff`), 1,697,606 B, SHA-256 `323e6a8b1c1bda434b48cae036505b95f74f8091355d627fc8ae2a4505cfdf46`; its files the 265
tracked ones `.Rbuildignore` keeps, less `.Rbuildignore`, plus 9 built, compared by script; `R CMD check --as-cran
--timings` on it here `Status: 1 NOTE` (R16's lines only), tests `[ FAIL 0 | WARN 0 | SKIP 94 | PASS 13836 ]` 188 s
elapsed for 187.7 s CPU, 258 s on the clock, load 8.1 to 6.8; win-builder's upload page (200) and FTP server answered;
the upload at 14:17 UTC (reply 226); the R-devel queue listed at 16:07-16:13 UTC (19 files, 15 of them ahead of ours,
none leaving in 5 minutes) beside R-release's (3) and R-oldrelease's (0); drift 91 / 23 / 0 and nprcgenekeepr's log
at Orient and close-out; quality_ratchet at close-out (the receipt).

#### Session 89 Handoff Evaluation (by Session 90)
**Score: 8/10.** ROI high: Orient and the 17k build ran from its notes, and every cited line was where it said.
- **What helped:** What You Must Do 1 (drift 91 / 23 / 0, the 4 commits, `3e06730c5`, each as stated); 3's pointers
  (`:857`, R85, R86, section 2.1, "build the tarball as CLAUDE.md's full check does, then ask Mark"); the 32 backlog
  items, each at its stated line; "S33 uploaded by FTP, D1", which led to S33's committed notes.
- **What was missing:** the upload command and "the email carries the check time" (in S33's notes, `15c7627`, not
  carried; found in minutes); that the result comes to Mark's email only, so the session waits on him.
- **What was wrong:** "its tests' elapsed time against 540 s (R85)": R85's 540 s is win-builder's check time; the
  tests' elapsed against CPU says whether the machine was busy (17k's own text). Caught from the plan before any
  reading; S90's claim had copied it.
- **ROI:** high.

**Self-assessment: 6/10.**
+ Orient in full, the claim before any work; the tarball's contents proved by script and checked here before the
  upload picker, so the picker stated measured facts; when the email did not come, the queue was listed rather than
  waited on, and R-release's queue beside it showed the stall was R-devel's; dragon 34 recorded.
- **The deliverable is not done:** the reading waits on win-builder's queue, outside the session's reach.
- **Slips that reached Mark:** a picker offering parallel sessions when he asked about the next one (rejected, one
  more picker); an upload label, "You upload it by FTP", whose voice differed from the option beside it; the claim
  copied the handoff's "tests' elapsed time against 540 s" (corrected here and in the plan). Not reaching Mark: a
  useless placeholder tool call while the check ran.

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
