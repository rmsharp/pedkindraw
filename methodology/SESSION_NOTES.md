# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17k DONE (S33-S94); the gap
phases G1-G17 DONE (S42-S77); the crash item DONE (S89, R163); the Windows CI hang DONE (S91, R164). **17k DONE
(S94):** win-builder R-devel's second reading, of the package as at `23a6186` (R165's cut: a CRAN check runs 21
of the 105 test files), read **321 s**, 219 s under 540 s (`ZYsFyCy5GM5z`). The CI Chrome start item (backlog
`:214`, R166) stays open, READY for a diagnostic.
**Next, by Mark's pick:** Phase 17l, static hygiene and noSuggests (`docs/planning/cran-submission-plan.md:970`;
Mark's pick at S94's close, "Phase 17l next (Recommended)", over the Chrome diagnostic first).
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed at close-out 2 (documents
only, no CI run). CI on master is red as S93 left it: REFACTOR `b0b9556`, run 45737321097: Windows and Ubuntu
oldrel-1 OK; Ubuntu release failed both attempts on a hung Chrome start (`:214`), macOS both on the app's click
test (`:238`); Ubuntu devel S4Vectors (`:197`).
**The orient picker:** "(Recommended)" on 17l (Mark's pick; it holds the three small items `:159`, `:171`, `:197`);
the Chrome diagnostic `:214` beside it; the rest grouped and named (34 items, lines unchanged by S94, `grep -n
'^- \[ \]' methodology/BACKLOG.md`): READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:260`, `:277`, `:293`, and
the small ones `:178`, `:187`, `:243`, `:249`, `:265`, `:312`; NEEDS DECISION `:64`, `:72`, `:81`, `:94`, `:228`,
`:238`, `:283`, `:303`; "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not offered: `:105` (a session Mark
starts in nprcgenekeepr), `:20` and `:116` (BLOCKED). Name every item (memory "Picker sets: name items, include all").
**Session boundary:** one session (17l), then close out.
**Priority:** HIGH (17l-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S94 changed no code); nprcgenekeepr's
   log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); S92's copies, `git -C ../nprcgenekeepr log --oneline
   3e06730c5..HEAD -- tests/testthat/test_slowTestFiles.R tests/testthat/helper-slowTestFiles.R tests/testthat.R`:
   nothing; nprcgenekeepr at `3e06730c5`, tree clean.
2. **17l** (`docs/planning/cran-submission-plan.md:970`): read it, D7 (`:1041`: `Language` and spelling, the
   `Depends: R` floor, a DOI in `Description`; a pre-RED picker), sections 2.2 (`:192`) and 2.3 (`:210`), dragon 6
   (`:1096`), and the three backlog items it holds: `:159` (the suite gate's 300 s, `methodology/.quality-gates.json:43`;
   raising `timeout_seconds` is not a loosening, the threshold stays 0: its own commit, the reason in the ledger),
   `:171` (a stale pedkindraw 0.0.1 in renv's library), `:197` (CI notices). **Sections 2.2 and 2.3 are S32's counts
   (2026-11-16), now out of date** (measured S94): `Suggests` is 13 packages, not 9 (`DESCRIPTION:27`: callr,
   chromote, jsonlite, kinship2, knitr, mockery, Pedixplorer, pkgload, ps, rmarkdown, shiny, testthat, withr);
   `mockery::` is in 7 test files (2.3: 4), `withr::` in 51 (2.3: up to 19); there is no `inst/WORDLIST`; spelling
   2.3.2 is in R's own library, not renv's. Re-measure each before the picker (Learnings 8, 17). 17l's DONE names
   kinship2, Pedixplorer, mockery and withr absent; which packages CRAN's no-Suggests check leaves out (testthat is
   a Suggests too) is not measured here: find it in CRAN's documentation before the picker. R's own library holds
   most Suggests, so the check needs a scratch library with only the Imports and their dependencies (dragon 6).
   DONE also asks `quality_ratchet.py --run` "5/5" (the manifest now has 6 gates) with the suite gate measured, and
   CI 5/5 or each failure explained (master is red: `:214`, `:238`, Ubuntu devel). Strict TDD where tests change.
3. **The Chrome diagnostic (`:214`), if Mark picks it instead:** its design is in the item and in S93's notes
   (`git show 6cea441:methodology/SESSION_NOTES.md`, What You Must Do 4): a `ci:` push modelled on `89e28f1`, Chrome
   started with processx to keep a hung start's handle and stderr.
4. **CI on every push:** five jobs. Ubuntu devel fails loading S4Vectors before pedkindraw is checked
   (`methodology/BACKLOG.md:197`). Known flakes: `:214` (a hung start, Ubuntu release), `:228` (a blank PDF,
   Windows once), `:238` (the app's click, macOS). Rerun a failed job once (`gh run rerun <run> --job <id>`, after
   the run ends; `--failed` reruns Ubuntu devel too). `gh run watch` can return before a rerun's job starts: wait on
   the job (`gh api repos/rmsharp/pedkindraw/actions/jobs/<id> -q .status`). Read each job's lines through the jobs
   API (`curl -sSL -H "Authorization: Bearer $(gh auth token)"
   https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`); after a rerun, list jobs by attempt
   (`.../runs/<run>/attempts/<n>/jobs`).
5. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **A plan's section can be older than its phase:** 17l rests on sections 2.2 and 2.3, measured at S32; three of
  their counts no longer hold (What You Must Do 2). And a plan's "record here and in section 2.1" can be half done:
  S92 recorded the first 17k reading in 17k only; S94 added both readings to section 2.1.
- **renv installs** (if 17l adds spelling or another package): the dated repository before `renv::install()`,
  `rebuild = TRUE` for each package and its dependencies by name, `renv::snapshot(dev = TRUE)`, then the gate
  `renv-lock-no-latest-repository` (Learning 3).
- **A CRAN check runs only 21 test files** (R165): a new test file runs on CRAN until it is listed in
  `tests/testthat/slowTestFiles.txt`; `test_slowTestFilesExports.R` fails if no CRAN-run file's own code calls an
  export. **The 540 s is the email's check time** (R85); 17o's reading still gates the submission (R86); win-builder's
  speed against this Mac changes (dragon 36: 1.9×, 3.3×, 3.2× for the whole check).
- **The Chrome start hang** (`:214`, dragon 37): a CI-flake fix is a guess until CI runs it; chromote 0.5.1's port
  wait is `chromote.timeout`, not `default_timeout`; S93's two slow-Chrome tests take about 27 s and skip on Windows
  and CRAN.
- **Picker labels:** "(Recommended)" on the orient picker follows Mark's recorded next pick and its condition
  (memory); measure outside material against pedkindraw before answering it.
- **Carried:** on Windows, R CMD check waits for every process the tests start (dragon 35); Rscript started inside
  `tests/testthat/` does not load the project's renv (run from the root); a test that repeats rows stops at the
  repeated-id check; `rm -rf "$VAR/..."` is refused (write `"${VAR:?}"`); backslashes in `Rscript -e` (put such
  code in a file); a shell command file must hold its file list on one line; one-off scripts as `Rscript
  --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to renv's library; the 5-file cap splits commits; the
  ratchet's suite gate times out at 300 s (the full suite takes 10-11 min; `:159`); `testthat::test_file()` can
  leave `tests/testthat/_problems/` (never commit it); `CLAUDE.md` is over its budget (learnings go to the plans'
  dragons; the cran plan's section 9 now ends at 37); `methodology/HANDOFFS.md` 234,522 B at S94's claim, 27,622 B
  under the 262,144 B size where a default read returns nothing; at 1.8-2.7 KB a receipt, about 10-14 more
  sessions (backlog `:303`, NEEDS DECISION): keep the receipt short; lint forbids `options()` (`nolint` with the reason,
  as `.startChrome()` has: withr is only in Suggests); a push whose head commit's message holds the skip marker
  anywhere runs no workflow (write it in words).
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17l: `docs/planning/cran-submission-plan.md:970` (17l), `:1041` (D7), `:192` (2.2, spelling, `Depends`), `:210`
  (2.3, the Suggests in the tests), `:289` (section 3), `:1096` (dragon 6); `DESCRIPTION:15` (`Depends`), `:27`
  (`Suggests`), `:43` (`Language`); `methodology/.quality-gates.json:37` (the suite gate, its limit `:43`);
  `methodology/BACKLOG.md:159`, `:171`, `:197`; `.github/workflows/R-CMD-check.yaml:27`-`:33` (the matrix), `:110`
  (the check step).
- 17k (DONE): `docs/planning/cran-submission-plan.md:880` (17k), `:949` (S94's reading), `:169` (section 2.1's 17k
  table), `:1224` (dragon 36); R165 `docs/planning/standalone-pedigree-package-plan.md:346`; the cut
  `tests/testthat.R:4`-`:8`, `tests/testthat/slowTestFiles.txt`.
- The Chrome item (`:214`): `R/savePedigreeDiagram.R:367` (`.startChrome()`), `:290` (`.renderPicture()`, every CI
  start failure), `:392` (`.closeChrome()`); R166 `docs/planning/standalone-pedigree-package-plan.md:347`; dragon 37
  `docs/planning/cran-submission-plan.md:1235`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 95 Did
**Deliverable:** Phase 17l (`docs/planning/cran-submission-plan.md:970`): static hygiene and noSuggests (spelling,
`Depends: R`, the DOI, `.Rbuildignore`; the depends-only check without kinship2, Pedixplorer, mockery and withr;
backlog `:159`, `:171`, `:197`). Strict TDD where tests change. (IN PROGRESS)
**Started:** 2026-11-25 21:59 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Phase 17l (Recommended)"
(orient picker).
**Status:** Session claimed. Re-measuring sections 2.2 and 2.3 before D7's picker.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### What Session 94 Did
**Deliverable:** finish Phase 17k (`docs/planning/cran-submission-plan.md:880`; R85, R86). DONE: win-builder
R-devel's second reading, of the package as at `23a6186` (R165's cut), read 321 s, 219 s under 540 s.
**Started:** 2026-11-25 21:35 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option where
one was):** the email "Yes, it came" (then pasted: `ZYsFyCy5GM5z`, installation 19 s, check 321 s, Status 1
NOTE); "S93's pick, by the email (Recommended)"; at the close, "Phase 17l next (Recommended)".
**Commits:** claim `5bd91b8`; the reading `d77c569` (the cran plan's 17k, section 2.1, dragon 36 and status line;
the standalone plan's status block and Next; the roadmap); close-out 2 (these notes, the receipt, the ledger),
pushed after it; close-out 2b (the push entry). No package code; no CI run (documents only, the skip marker).
**Measured:** the folder's logs, each in its own scratchpad folder: the check started 23:11:00 UTC (1 h 35 min after
the upload); incoming 10 s, R code 35 s, examples 17 s, tests 126 s, vignettes 30 s, PDF manual 29 s, the untimed
steps about 56 s; the tests' `proc.time()` 125.4 s elapsed for 124.2 s CPU; `[ FAIL 0 | WARN 0 | SKIP 25 | PASS
2694 ]` (here 24 and 2,695: `test_savePedigreeDiagram.R:499`, one expectation, skips on Windows). Against S92's check
of the same package here (100 s, tests 29.8 s): 3.2× and 4.2×; R165's estimate 312 s, 3% under. The cut took 663 s
off the tests; the rest of the check 196 s (192 s at the first reading). The margin: a check 1.68× this one reaches
540 s; nprcgenekeepr's slower day would read about 381-389 s. HEAD's package differs from `23a6186`'s by S93's 5
files (the changed files against `.Rbuildignore`); the list of 84 slow files unchanged. For 17l: `Suggests` 13
packages (the plan says 9), `mockery::` in 7 test files, `withr::` in 51, no `inst/WORDLIST`.
**Verified:** at HEAD, `test_slowTestFiles.R` 7 tests, 19 expectations and `test_slowTestFilesExports.R` 3 tests, 6
expectations, 0 failed; every number in the plan computed by a script; drift 91 / 23 / 0. quality_ratchet at
close-out (the receipt).

#### Session 93 Handoff Evaluation (by Session 94)
**Score: 9/10.** ROI high: Orient and the reading ran from its notes, and every cited line was where it said.
- **What helped:** "ask Mark first whether the email has come" with the pick under each answer (the orient picker
  followed it); What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each exact); 3, the folder's files by
  name, the five plan lines (each exact at `f3f2009`), the guess at the counts (SKIP 25 exact), HEAD's CRAN-mode
  figures beside `23a6186`'s, and "540 s or less: 17k DONE"; the 34 items at their stated lines.
- **What was missing:** that S92 recorded the first reading in 17k but not in section 2.1, which the plan's "Left"
  asked for; and where S92's local check of `23a6186` was recorded (100 s, 29.8 s, load 6.6-5.5: in GREEN's commit
  message only). Each found in minutes.
- **What was wrong:** nothing; the guess PASS 2693 read 2694 (labelled a guess).
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; the reading fetched and recorded with every derived number computed
  by a script, beside both earlier readings; DONE's other two parts checked at HEAD by running them, not assumed;
  S92's missing section 2.1 record added; the inputs 17l rests on re-measured for the handoff (three stale counts);
  the next session's task put to Mark at the close (answered first try).
- **Slips caught before commit:** "HEAD differs only by S93's start wait" first named 3 of the 5 changed package
  files (`NEWS.md` and a helper missed by a `git diff` over named folders); and the first `.Rbuildignore` filter
  matched each file, not each folder, so it listed `docs/` and `methodology/` as shipped. Both corrected from a
  second listing before `d77c569`.
- The orient picker asked for the email in the notes box; the answer came without it and Mark pasted it separately.

### What Session 93 Did
**Deliverable:** the backlog item "A CI job fails now and then while Chrome starts" (`methodology/BACKLOG.md:214`),
strict TDD. NOT DONE: the fix Mark picked (a 60 s start wait, R166) is in and tested, but CI then showed the
failures are hangs it does not cure; the item stays open, rewritten, READY for a diagnostic by Mark's pick.
**Started:** 2026-11-25 16:40 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"Chrome start-up failures (Recommended)" (orient; the email could not have come: the upload was still in the
queue); "Wait 60 s for the start (Recommended)"; "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR";
after the REFACTOR push's Ubuntu job hung past 60 s, "Close out; measure on CI next (Recommended)".
**Commits:** claim `fc3dc5c`; RED `9fbfb3a`; GREEN `d79dbed` (pushed with RED: run 45721768010, its Windows job rerun
once); REFACTOR `b0b9556` (pushed: run 45737321097, its failed jobs rerun once); close-out 1 `3093e82` (R166, dragon
37, the picture plan's dragon 11, the roadmap); close-out 2 (the backlog, these notes, the receipt, the ledger),
pushed after it; close-out 2b (the push entry).
**Measured:** every R-CMD-check run (91 runs, 480 jobs by attempt) and every failed check step's log: 3 start
failures in the 80 jobs since S71, all at `.renderPicture()`'s start; a trace of the 21 Chrome-starting test files
here (109 starts: 61 the recording's, 27 the picture's, 18 the app's and legends', 3 helpers'; slowest 0.84 s);
chromote 0.5.1's start code; nprcgenekeepr's history of the same message (it pinned Chrome in CI, never waited
longer); a stand-in Chrome in scratch copies (HEAD: the CI error at either start, 10.2 s and 11.6 s, 11 processes
left until `gc()`; with a 60 s wait: saved in 12.6 s and 14.0 s; one that never opens its port: 10.2 s against 60.1
s); the drafts before RED (4-6 failed on HEAD, all passed on the prototype, 27.5 s) and the REFACTOR draft (lint 0,
235 expectations passed); chromote's vignette on `Page$navigate()`.
**Verified:** RED: the file 35 tests, 235 expectations, 5 failed, all in the two new tests, WARN 0, lint 0. GREEN: the
file 0 failed; the full suite (`NOT_CRAN=true`) 105 files, 1,204 tests, 17,268 expectations, 0 failed, 0 skipped,
WARN 0 (10.7 min); lint 0; roxygen unchanged; `R CMD check --as-cran` Status 1 NOTE (R16's), CRAN-mode tests
`[ FAIL 0 | WARN 0 | SKIP 26 | PASS 2695 ]` 28.5 s, the check 116 s; CI run 45721768010: macOS OK `PASS 17043`,
Ubuntu release and oldrel-1 OK `PASS 17032` (S92's plus the new tests' 10), Windows failed once at
`test_savePedigreeDiagram.R:525` (a blank first PDF; backlog `:228`), rerun OK `PASS 17031`; Ubuntu devel
S4Vectors. REFACTOR: the same suite counts (10.5 min) and check (29.2 s, 116 s); CI run 45737321097: Windows OK
`PASS 17031`, oldrel-1 OK `PASS 17032`; Ubuntu release failed at `:366` and, rerun, at `:653`, "port not open after
60 seconds", each with a detritus NOTE; macOS failed at `test_pedigreeAppBrowser.R:103` both times (`:238`). Drift 91
/ 23 / 0 at Orient and close. quality_ratchet at close-out (the receipt).

#### Session 92 Handoff Evaluation (by Session 93)
**Score: 9/10.** ROI high: Orient and the item's research ran from its notes, and every cited line was where it said.
- **What helped:** the ACTIVE TASK's "ask Mark first whether the email has come" with What You Must Do 2's queue
  command, which answered it by measurement (the upload still first in the queue at 22:35 UTC); What You Must Do 1
  (91 / 23 / 0, the 4 commits, S92's copies, `3e06730c5`, each exact); 4's jobs-API and rerun commands, used four
  times; the backlog item's three failures with their runs and the S92 site, and its three choices, which framed the
  approach picker; the gotcha on the 21 CRAN-run files; the 32 items at their stated lines.
- **What was missing:** that S89's failure was at the same start as S92's (`R/savePedigreeDiagram.R:301` then, `:302`
  at S92): the item named the site for S92's only. Reading every failed log showed all three at one start.
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 5/10.**
+ Orient in full, the claim before any work; the whole CI history read and the starts traced before the approach
  picker; the CI error reproduced with a stand-in and each option measured; the drafts run in scratch copies before
  each gate, so each gate stated counts; RED, GREEN and REFACTOR each verified here (suite, lint, check) and on CI;
  GREEN's Windows failure read and kept out of scope (backlog `:228`, with chromote's own vignette); when CI disproved
  the fix, Mark had the facts and a picker at once, not a second fix.
- **The deliverable is not done, and the fix I recommended did not work.** My own counts (all three failures at one
  start, one of them a hang) pointed at a hang at that start, yet the approach picker recommended a longer wait that
  rested on "if Chrome was only slow", which no log could show; dragon 35 (read it on the runner) was already in
  this repository. A diagnostic push first would have cost one CI run, not two TDD cycles' CI.
- **Slips not reaching Mark:** the trace's first run lost 20 of 21 files to a line break in a command file (rerun);
  one command wrote a stray file outside the scratchpad (removed); a `gh run watch` returned before the rerun's job
  started (watched the job instead).

### What Session 92 Did
**Deliverable:** finish Phase 17k (`docs/planning/cran-submission-plan.md:857`; R85, R86). IN PROGRESS: the first
reading read 980 s, so the cut was made (R165) and the second reading uploaded; it waits in win-builder's queue.
**Started:** 2026-11-25 14:45 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):** "It
came: finish 17k" (he pasted the email); after stopping the first cut picker to ask whether a r-package-devel report
(secr's Windows check time) helped, "Only what each export needs" and "One list, copied from nprcgenekeepr"; "Yes,
proceed to RED"; "Yes, proceed to GREEN"; "Skip REFACTOR"; "Claude uploads it now". He also asked how to watch
win-builder's queue (answered: the FTP listing, What You Must Do 2).
**Commits:** claim `a657d3a`; the reading `80c3d86`; R165 `9985f92`; RED `e2cd4a2`; GREEN `23a6186` (pushed with the
others: run 45705867740); close-out 1 `f23d00c` (the plans, roadmap, dragon 36, the backlog item `:214`); close-out 2 (these
notes, the receipt, the ledger), pushed after it; close-out 2b (the push entry).
**Measured:** the folder's logs (check 980 s: tests 788.1 s elapsed for 784.2 s CPU; R code 34 s, vignettes 30 s,
PDF 29 s, examples 16 s, incoming 10 s; installation 18 s); the same check here (295 s, tests 219 s); the CRAN-mode
tests file by file here (103 files, 197.0 s); the secr report's two points (installation 18 s; pedkindraw loads in
0.39 s here, `Matrix` 0.37 s of it); a trace of the 38 exports over the CRAN-mode tests (0 failures; 19 files by
"own code calls it", 12 by any call); the drafts in a scratch copy (RED: 7 + 1 failing for the planned reasons) and
a GREEN prototype (passing; the export check failing with the 12-file list); the upload tarball against the checked
one (the same files but the `Packaged:` line and two vignettes' widget ids).
**Verified:** RED: `test_slowTestFiles.R` 7 of 7 failing, `test_slowTestFilesExports.R` 1 of 3 (the reader's 2
pass), WARN 0, lint 0. GREEN: the two files 25 expectations, 0 failed; the full suite (`NOT_CRAN=true`) 105 files,
1,202 tests, 17,258 expectations, 0 failed, 0 skipped, WARN 0 (10.2 min); `R CMD check --as-cran` Status 1 NOTE
(R16's), CRAN-mode tests `[ FAIL 0 | WARN 0 | SKIP 24 | PASS 2695 ]` 29.8 s, the check 100 s; lint 0; roxygen
unchanged; CI run 45705867740: Windows OK `PASS 17031`, macOS OK `PASS 17033`, Ubuntu oldrel-1 OK `PASS 17022`
(each S91's plus 25), Ubuntu release failed once on Chrome's start-up (`test_savePedigreeDiagram.R:426`), rerun:
OK `PASS 17022`; Ubuntu devel S4Vectors. Uploaded 21:36:03 UTC (226). Drift 91 / 23 / 0. quality_ratchet at close-out
(the receipt).

#### Session 91 Handoff Evaluation (by Session 92)
**Score: 9/10.** ROI high: Orient and the reading ran from its notes, and every cited line was where it said.
- **What helped:** the ACTIVE TASK's "ask Mark first whether the email has come" with the pick's condition (the
  orient picker followed it); What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each exact); 3, the
  folder's files by name (`00check.log`, `examples_and_tests/tests/testthat.Rout`), the 17k lines `:857`-`:883`,
  dragon 8, section 2.1, and "over: a picker on the test files to skip on CRAN, re-measured, in TDD", which was the
  session's path; the gotcha "the 540 s is the email's check time".
- **What was missing:** where nprcgenekeepr's slow-file list and its S1095 trace rule are (D6 named the list; found
  in nprcgenekeepr's plan section 3.5 in minutes).
- **What was wrong:** "S91 found it gone from the R-devel queue at 16:49 UTC ... so its check ran then": the check
  began at 18:03:51 UTC (`00check.log`), 1 h 14 min after it left the list. Leaving the list is not the start.
- **ROI:** high.

**Self-assessment: 7/10.**
+ Orient in full, the claim before any work; the reading recorded and committed before any picker; every option
  measured first (per file and per step here, the trace two ways, the secr report's points against pedkindraw);
  the drafts and a GREEN prototype run in scratch before each gate, so each gate stated counts; RED's failures read
  for their reasons; the export check shown to fail on the looser list; the upload tarball proved against the one
  checked; CI read job by job, the start-up failure matched to the gotcha and rerun.
- **The deliverable is not done:** the second reading waits in win-builder's queue, outside the session's reach.
- **Slips:** the first cut picker called 25 Nov a slow day from two readings ("a 1.7x spread"); Mark stopped it to
  bring the secr report, which pointed the other way (his load 3.8x), and the picker was rewritten (one more
  picker). Not reaching Mark: the first timing script called testthat functions that are not exported, and one run
  started in `tests/testthat/` without renv (two reruns).
