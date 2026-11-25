# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17j DONE (S33-S88); the gap
phases G1-G17 DONE (S42-S77); the crash item DONE (S89, R163); the Windows CI hang DONE (S91, R164). **17k IN
PROGRESS (S90, S92):** the first reading (the package as at `89f39e7`) read **980 s** on win-builder R-devel
(results `9ObRnQYtbA8V`, its tests 788 s), over 540 s, so S92 made the cut (R165): a CRAN check now runs 21 of the
105 test files (`tests/testthat/slowTestFiles.txt` lists the other 84), its tests 29.8 s here instead of 219 s,
about 312 s estimated for the whole check on win-builder. The second reading's tarball (the package as at
`23a6186`) was uploaded at 21:36:03 UTC on 2026-11-25, first in win-builder's R-devel queue; at S92's close-out
(22:22 UTC) it was still there, with four newer uploads behind it (see What You Must Do 2). The email goes to Mark; win-builder keeps the folder about 72 hours.
**Next:** ask Mark first whether win-builder's second email has come. If it has, finish 17k (What You Must Do 3).
If not, Mark has picked no next item: offer the backlog (32 items, listed below) in the orient picker. Claude's
suggestion, not Mark's pick: `:214` (CI jobs failing while Chrome starts; DECISION NEEDED, Effort S; three times in
four sessions, each a rerun).
**Status:** no work in progress but 17k's wait. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed at
close-out 2.
**The orient picker:** the email first; then finish 17k (if the email is in) and the rest grouped and named (32
items, each at its line by `grep -n '^- \[ \]' methodology/BACKLOG.md`; S92 added `:214`, so every line from `:214`
down moved 9): READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:240`, `:257`, `:273`, and the nine small ones
`:159`, `:171`, `:178`, `:187`, `:197`, `:223`, `:229`, `:245`, `:292`; NEEDS DECISION `:64`, `:72`, `:81`, `:94`,
`:214`, `:263`, `:283`; "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not offered: `:105` (a session Mark starts
in nprcgenekeepr), `:20` and `:116` (BLOCKED). Name every item (memory "Picker sets: name items, include all"); put
"(Recommended)" where the condition Mark set says (memory "Orient picker follows the handoff pick").
**Session boundary:** one session (finishing 17k, or one backlog item), then close out.
**Priority:** HIGH (17k-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S92 changed no `R/` file); nprcgenekeepr's
   log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`; S92's two new copies are older there than `baef1e12c`); and for S92's
   copies, `git -C ../nprcgenekeepr log --oneline 3e06730c5..HEAD -- tests/testthat/test_slowTestFiles.R
   tests/testthat/helper-slowTestFiles.R tests/testthat.R`: nothing; nprcgenekeepr at `3e06730c5`, tree clean.
2. **The email:** ask Mark (it carries the results link and "Check time in seconds"; only he has it).
   `curl -sS ftp://win-builder.r-project.org/R-devel/` lists uploads not yet started (the server's clock is UTC+1);
   leaving that list is not the check's start: S90's upload left it by 16:49 UTC and its check began 18:03:51 UTC
   (`00check.log`'s "current time").
3. **Finishing 17k (if the email is in):** read `docs/planning/cran-submission-plan.md:857` (17k), `:884` (the first
   reading), `:906` (the cut and the second upload), dragons 8 and 36 (`:1183`). Fetch the folder's logs into the
   scratchpad, each in its own new folder (`00check.log`, `00install.out`,
   `examples_and_tests/tests/testthat.Rout` for `proc.time()` and the counts); a guess at the tests:
   `[ FAIL 0 | WARN 0 | SKIP 25 | PASS 2693 ]` (here SKIP 24, PASS 2695; the first reading on Windows skipped
   `test_savePedigreeDiagram.R:499` too and passed 2 fewer, and that file still runs on CRAN). Record the check time, each
   step's time and the tests' elapsed against CPU beside the first reading's; 540 s or less: 17k DONE (its DONE's
   list of skipped files and its export check are in place: `tests/testthat/slowTestFiles.txt`,
   `tests/testthat/test_slowTestFilesExports.R`). Over 540 s (estimated about 312 s): a picker on cutting more, in
   TDD. Folder gone or no email by the 28th: rebuild from HEAD and upload again (Mark approves).
4. **CI on every push:** five jobs. Ubuntu devel fails loading S4Vectors before pedkindraw is checked
   (`methodology/BACKLOG.md:197`); a browser test can fail once while Chrome starts (`:214`): rerun that job once
   (`gh run rerun <run> --job <id>`, after the run ends). Read each job's lines through the jobs API (`curl -sSL -H
   "Authorization: Bearer $(gh auth token)" https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`);
   after a rerun, list jobs by attempt (`.../runs/<run>/attempts/<n>/jobs`).
5. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **A CRAN check now runs only 21 test files** (R165): a new test file runs on CRAN until it is listed in
  `tests/testthat/slowTestFiles.txt`; list it unless a CRAN-run file is the only test of some export.
  `test_slowTestFilesExports.R` fails if no CRAN-run file's own code calls an export (it reads code: a call inside
  a `test_that()` block with `skip_on_cran()` does not count). Local CRAN-mode timing: one `test_dir()` on the
  installed package with a reporter timing each file (dragon 36).
- **win-builder's speed against this Mac changes** (dragon 36): 1.9× at 17a, 3.3× at S92 for the same tarball, both
  with elapsed equal to CPU. The check time also holds the installation and the untimed short steps (about 73 s at S92).
- **Picker labels:** "(Recommended)" on the orient picker follows Mark's recorded next pick and its condition
  (memory). Mark may bring outside material before a picker (S92: a r-package-devel report): measure its points
  against pedkindraw before answering.
- **The 540 s is the email's check time** (R85), not the tests' time.
- **Carried:** on Windows, R CMD check waits for every process the tests start (dragon 35; the diagnostic step is
  at `89e28f1`); Rscript started inside `tests/testthat/` does not load the project's renv (run from the root);
  `testthat`'s `expectation_success()` and friends are not exported (test a result's class); a test that repeats
  rows stops at the repeated-id check (`R/makePedigreeDiagramData.R:2266`); `rm -rf "$VAR/..."` is refused (write
  `"${VAR:?}"`); backslashes in `Rscript -e` (put such code in a file); one-off scripts as `Rscript --no-init-file`
  with `R_LIBS` and `R_LIBS_USER` set to renv's library; the 5-file cap splits commits; the ratchet's suite gate
  times out at 300 s (the full suite takes 10-12 min); `testthat::test_file()` can leave `tests/testthat/_problems/`
  (never commit it); `CLAUDE.md` is over its budget (learnings go to the plans' dragons; the cran plan's section 9
  now ends at 36); `methodology/HANDOFFS.md` 32 KB under its hard limit (backlog `:283`): keep the receipt short; a
  push whose head commit's message holds the skip marker anywhere runs no workflow (write it in words).
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17k: `docs/planning/cran-submission-plan.md:857` (the phase), `:884` (the first reading), `:906` (the cut, the
  second upload), `:130` (17a's table), `:999` (D6), `:1168` (dragon 34), `:1183` (dragon 36); R165 at
  `docs/planning/standalone-pedigree-package-plan.md:345`.
- The cut: `tests/testthat.R:4`-`:8`; `tests/testthat/slowTestFiles.txt` (header `:1`-`:12`, 84 names);
  `tests/testthat/helper-slowTestFiles.R` (copied); `tests/testthat/test_slowTestFiles.R` (copied, 7 blocks);
  `tests/testthat/test_slowTestFilesExports.R:17` (`cranCalls()`), `:65` (the export check).
- nprcgenekeepr's method: its `docs/planning/cran-3.0.0-submission-plan.md` section 3.5 (S1095's trace rule).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 93 Did
**Deliverable:** the backlog item "A CI job fails now and then while Chrome starts" (`methodology/BACKLOG.md:214`;
found S89, S91, S92), strict TDD. (IN PROGRESS)
**Started:** 2026-11-25 16:40 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Chrome start-up failures
(Recommended)" (orient picker; S92's suggestion). 17k waits: S92's second upload was still first in win-builder's
R-devel queue at 22:35 UTC, so its check had not begun.
**Status:** Session claimed. Measuring the failures before the approach picker.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

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

### What Session 91 Did
**Deliverable:** the backlog item "A Windows job that does not end after its tests finish" (S69-S90), strict TDD.
DONE (R164): the Windows job ends, Status OK, twice.
**Started:** 2026-11-25 10:57 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** the orient picker's "Finish 17k
(Recommended)" with the email "Not yet"; Mark then stopped the next picker ("We discussed this at the end of the last
session and agreed to work on the Windows hang problem this session"), and the claim was corrected (`f252d2d`); then,
each the recommended option: "Find where R stops"; "In savePedigreeDiagram"; "Yes, proceed to RED"; "Yes, proceed to
GREEN"; "Yes, REFACTOR".
**Commits:** claim `61e4796`; claim corrected `f252d2d`; diagnostics `89e28f1` (pushed: run 45667512215); RED
`487657b`; GREEN `3adbd4e` (pushed with RED: run 45680687657, its macOS job rerun once); REFACTOR `e6e2e1a` (pushed:
run 45687837833); close-out 1 `ee9a4d9` (R164, the plans, roadmap, dragons 30 and 35); close-out 2 (the backlog, these
notes, the receipt, the ledger), pushed after it; close-out 2b (the push entry).
**Measured first:** S89's Windows log (the tests ended 14 minutes before the cancel); the websocket and processx code
(the suspects named in the approach picker, all three disproved by the diagnostics); the diagnostic run: R CMD check's
test runner (`Rterm` 7952, no package DLL loaded) waiting in `runcmd_timeout` on Windows' job wait, the test process
gone, six Chrome renderers and crash reporters of the three stuck-page browsers alive, their browsers dead; on this
Mac the stuck page leaves no Chrome process; processx's marker reaches none of Chrome's 12 children, `ps_children()`
by parent all 12; the draft test in three scratch copies (missing: error; plain close: passes; the repair: passes).
**Verified:** RED: the file 33 tests, 223 expectations, 1 error (the missing function), WARN 0. GREEN: the file 225
expectations, 0 failed, WARN 0; the full suite (`NOT_CRAN=true`) 103 files, 1,192 tests, 17,233 expectations, 0
failed, 0 skipped, WARN 0 (12.2 min); lint 0; roxygen unchanged; `R CMD check --as-cran` Status 1 NOTE (R16's), tests
`[ FAIL 0 | WARN 0 | SKIP 95 | PASS 13836 ]` 197 s; CI run 45680687657: Windows Status OK `PASS 17006` (S89's 17,003
plus 3), check step 14.6 min, no process left; Ubuntu release and oldrel-1 OK `PASS 16997`; macOS failed once on
Chrome's start-up, its rerun OK `PASS 17008`; Ubuntu devel S4Vectors. REFACTOR: run 45687837833 the same counts,
Windows 18.9 min, macOS OK at the first attempt. Drift 91 / 23 / 0. quality_ratchet at close-out (the receipt).

#### Session 90 Handoff Evaluation (by Session 91)
**Score: 9/10.** ROI high: Orient and the Windows item ran from its notes, and every cited line was where it said.
- **What helped:** the ACTIVE TASK's "Next, by Mark's pick" with its condition (the email), which was right and
  which S91's orient picker failed to follow; What You Must Do 2 (the queue command, which showed the check had
  started); 4 (the Windows item's files by line, the matrix `:27`-`:33`, the Chrome steps, the check step `:104`,
  `.saveChrome` at `:262`; "one change per push", "cancel at 40 min"); the gotcha on rerunning a browser test's job
  once, used on macOS.
- **What was missing:** nothing S90 could have known; the backlog item's own inference ("probably at R's exit") was
  wrong, which the diagnostics, not a handoff, could show.
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 7/10.**
+ Orient in full, the claim before any work; one diagnostic push found what eleven readings over 22 sessions had
  only guessed at, by reading the runner (process list, thread stacks) rather than the code; each picker stated
  measured facts (the macOS leaves-none run, the marker and parent counts, the draft in three copies); the repair in
  the function, so users on Windows gain too; GREEN and REFACTOR read on all five jobs; a second Windows reading.
- **A slip that reached Mark:** the orient picker put "(Recommended)" on 17k against the handoff's recorded pick,
  while the email was "Not yet"; it cost Mark a rejected picker and a correcting claim commit (memory saved).
- **Limits stated, not hidden:** RED could show only the missing function on this Mac (Chrome cleans up here); the
  behaviour was shown on Windows CI. The approach picker's three suspects were each wrong; the diagnostic step was
  the option that did not depend on them. macOS failed once on Chrome's start-up (rerun passed).

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
