# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17j DONE (S33-S88); the gap
phases G1-G17 DONE (S42-S77); the crash item DONE (S89, R163); the Windows CI hang DONE (S91, R164). **17k IN
PROGRESS (S90, S92):** the first reading read 980 s, so S92 made the cut (R165: a CRAN check runs 21 of the 105
test files). The second reading's tarball (the package as at `23a6186`) was uploaded at 21:36:03 UTC on
2026-11-25; it was still first in win-builder's R-devel queue at 22:35 UTC and gone from the list by 23:16 UTC
(leaving the list is not the check's start). The email goes to Mark; win-builder keeps the folder about 72 hours.
**S93** (backlog `:214`, R166) added a 60 s Chrome start wait to `savePedigreeDiagram()` (`.startChrome()`); CI
then showed the start failures are hangs it does not cure, so the item stays open, READY for a diagnostic.
**Next, by Mark's pick:** ask Mark first whether win-builder's second email has come. If it has, finish 17k (What
You Must Do 3). If not, the Chrome start diagnostic (`methodology/BACKLOG.md:214`; What You Must Do 4): Mark's pick
at S93's close, "Close out; measure on CI next (Recommended)".
**Status:** no work in progress but 17k's wait. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed at
close-out 2. CI on master is red: REFACTOR `b0b9556`, run 45737321097, two attempts: Windows and Ubuntu oldrel-1
OK; Ubuntu release failed both times on a hung start (`:214`), macOS both times on the app's click test (`:238`);
Ubuntu devel S4Vectors. GREEN `d79dbed` (the same behaviour) passed on macOS and both Ubuntus.
**The orient picker:** the email first; "(Recommended)" on finishing 17k if the email is in, else on the
diagnostic (`:214`); the rest grouped and named (34 items, each at its line by `grep -n '^- \[ \]'
methodology/BACKLOG.md`; S93 rewrote `:214` and added `:228` and `:238`, so every line from `:243` down moved 20):
READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:260`, `:277`, `:293`, and the nine small ones `:159`, `:171`,
`:178`, `:187`, `:197`, `:243`, `:249`, `:265`, `:312`; NEEDS DECISION `:64`, `:72`, `:81`, `:94`, `:228`, `:238`,
`:283`, `:303`; "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not offered: `:105` (a session Mark starts in
nprcgenekeepr), `:20` and `:116` (BLOCKED). Name every item (memory "Picker sets: name items, include all").
**Session boundary:** one session (finishing 17k, or the diagnostic), then close out.
**Priority:** HIGH (17k-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S93 changed only pedkindraw's own
   `R/savePedigreeDiagram.R`); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); S92's copies, `git -C
   ../nprcgenekeepr log --oneline 3e06730c5..HEAD -- tests/testthat/test_slowTestFiles.R
   tests/testthat/helper-slowTestFiles.R tests/testthat.R`: nothing; nprcgenekeepr at `3e06730c5`, tree clean.
2. **The email:** ask Mark (it carries the results link and "Check time in seconds"; only he has it).
   `curl -sS ftp://win-builder.r-project.org/R-devel/` lists uploads not yet started (the server's clock is UTC+1).
3. **Finishing 17k (if the email is in):** read `docs/planning/cran-submission-plan.md:857` (17k), `:884` (the first
   reading), `:906` (the cut and the second upload), dragons 8 (`:1057`) and 36 (`:1183`). Fetch the folder's logs
   into the scratchpad, each in its own new folder (`00check.log`, `00install.out`,
   `examples_and_tests/tests/testthat.Rout` for `proc.time()` and the counts); a guess at the tests:
   `[ FAIL 0 | WARN 0 | SKIP 25 | PASS 2693 ]` (23a6186 here: SKIP 24, PASS 2695). The reading is of `23a6186`'s
   package; HEAD's CRAN-mode tests here read SKIP 26, PASS 2695, 29.2 s (S93's two tests skip on CRAN). Record the
   check time, each step's time and the tests' elapsed against CPU beside the first reading's; 540 s or less: 17k
   DONE. Over 540 s (estimated about 312 s): a picker on cutting more, in TDD. Folder gone or no email by the 28th:
   rebuild from HEAD and upload again (Mark approves).
4. **The diagnostic (`:214`, if no email):** read the item, R166 (`docs/planning/standalone-pedigree-package-plan.md:346`)
   and dragons 35 and 37 (`docs/planning/cran-submission-plan.md:1175`, `:1192`). Model it on S91's diagnostic
   push (`89e28f1`): a `ci:` commit, no package code, one change per push. On Ubuntu release and oldrel-1 (and
   macOS), many starts of each kind: chromote's arguments against `--disable-lcd-text`'s, right after a close
   against alone; count the starts that do not open the port within 60 s and keep each one's stderr. chromote
   loses a hung start's process inside `launch_chrome_impl()`, so start Chrome with processx yourself, with
   chromote's arguments (`chromote:::chrome_headless_mode()`, `--remote-debugging-port=`, the args), to keep its
   handle and its stderr file. Then a picker on the fix (one browser per save, a retry, or the arguments the count
   points to), in TDD.
5. **CI on every push:** five jobs. Ubuntu devel fails loading S4Vectors before pedkindraw is checked
   (`methodology/BACKLOG.md:197`). Known flakes: `:214` (a hung start, Ubuntu release), `:228` (a blank PDF,
   Windows once), `:238` (the app's click, macOS). Rerun a failed job once (`gh run rerun <run> --job <id>`, after
   the run ends; `--failed` reruns Ubuntu devel too). `gh run watch` can return before a rerun's job starts: wait on
   the job (`gh api repos/rmsharp/pedkindraw/actions/jobs/<id> -q .status`). Read each job's lines through the jobs
   API (`curl -sSL -H "Authorization: Bearer $(gh auth token)"
   https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`); after a rerun, list jobs by attempt
   (`.../runs/<run>/attempts/<n>/jobs`).
6. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **A fix for a CI flake is a guess until CI runs it** (dragon 37): S93's 60 s wait passed an 11-s-slow stand-in here
  and on Linux CI, then met "port not open after 60 seconds" on both attempts of the next push. Where each failure
  happened is evidence: all 5 are at `.renderPicture()`'s start, 27 of the 109 starts the tests make.
- **chromote 0.5.1:** Chrome's port wait is `getOption("chromote.timeout", 10)` (the port search and the WebSocket
  wait), not `default_timeout` (commands); a failed port search tries no second port and leaves that Chrome running
  until R's garbage collector ends it (on Linux its `org.chromium.Chromium.*` folder stays: a detritus NOTE);
  `Page$navigate()` does not wait for the load (its vignette `commands-and-events.Rmd:67`).
- **S93's two tests** (`tests/testthat/test_savePedigreeDiagram.R:671`, `:689`) take about 27 s (an 11 s stand-in
  each) and skip on Windows and CRAN; `.saveSlowChrome()` (`tests/testthat/helper-savePedigreeDiagram.R:563`) makes
  a stand-in slow at a chosen start, and `.saveRunningChildren()` (`:580`) lists R's live child processes.
- **A CRAN check runs only 21 test files** (R165): a new test file runs on CRAN until it is listed in
  `tests/testthat/slowTestFiles.txt`; `test_slowTestFilesExports.R` fails if no CRAN-run file's own code calls an
  export. **win-builder's speed against this Mac changes** (dragon 36). **The 540 s is the email's check time** (R85).
- **Picker labels:** "(Recommended)" on the orient picker follows Mark's recorded next pick and its condition
  (memory); measure outside material against pedkindraw before answering it.
- **Carried:** on Windows, R CMD check waits for every process the tests start (dragon 35); Rscript started inside
  `tests/testthat/` does not load the project's renv (run from the root); a test that repeats rows stops at the
  repeated-id check; `rm -rf "$VAR/..."` is refused (write `"${VAR:?}"`); backslashes in `Rscript -e` (put such
  code in a file); a shell command file must hold its file list on one line; one-off scripts as `Rscript
  --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to renv's library; the 5-file cap splits commits; the
  ratchet's suite gate times out at 300 s (the full suite takes 10-11 min; `:159`); `testthat::test_file()` can
  leave `tests/testthat/_problems/` (never commit it); `CLAUDE.md` is over its budget (learnings go to the plans'
  dragons; the cran plan's section 9 now ends at 37); `methodology/HANDOFFS.md` 232 KB, its trim trigger firing
  against 196,608 B (backlog `:303`): keep the receipt short; lint forbids `options()` (`nolint` with the reason,
  as `.startChrome()` has: withr is only in Suggests); a push whose head commit's message holds the skip marker
  anywhere runs no workflow (write it in words).
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- The starts: `R/savePedigreeDiagram.R:367` (`.startChrome()`), `:176` (the recording's start), `:301` (the
  picture's, LCD text off: every CI start failure), `:312` (`Page$navigate()`, then two frames: `:228`'s race),
  `:392` (`.closeChrome()`); R166 `docs/planning/standalone-pedigree-package-plan.md:346`; dragon 37
  `docs/planning/cran-submission-plan.md:1192`; the picture plan's dragon 11 `docs/planning/picture-files-plan.md:356`.
- CI: `.github/workflows/R-CMD-check.yaml:27`-`:33` (the matrix), `:110` (the check step); S91's diagnostic step at
  `89e28f1`.
- 17k: `docs/planning/cran-submission-plan.md:857`, `:884`, `:906`, `:130` (17a's table), `:999` (D6), `:1168` (dragon
  34), `:1183` (dragon 36); R165 at `docs/planning/standalone-pedigree-package-plan.md:345`; the cut:
  `tests/testthat.R:4`-`:8`, `tests/testthat/slowTestFiles.txt`.

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
