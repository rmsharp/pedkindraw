# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17o DONE (S33-S102); the gap
phases G1-G17 DONE (S42-S77). **S103: the hand test DONE (R175).** Mark ran the 1.0.0 tarball (`abb78758…22dcfe3c`),
installed outside the project into a library of its own, in RStudio: every part of
`docs/planning/cran-handtest-1.0.0.R`. It found four things, and Mark picked "Fix all four first" (Claude had
recommended "Upload as is"). So the frozen tree opens again for **H1-H4** (plan `:1167`; backlog `:9`), each its own
strict-TDD session; then 17n's gate and 17o's runs again on a new tarball; then 17p. **`abb78758…` will not be
submitted.**
**Next: one of H1-H4** (Mark picks; suggested order H1, H2, H3, H4, plan `:1204`):
H1 the ED5PDV drawing's 2 avoidable crossings, and the order hint a tie overrides (plan `:1174`, backlog `:16`);
H2 the Chrome timeout message in RStudio's test run (`:1186`, `:25`); H3 the speed page's table headings (`:1192`,
`:32`); H4 saying how to move around a drawing (`:1197`, `:38`).
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's); the tarball at the root is
git-ignored. Pushed through close-out 2 with the skip marker: no CI run since S100's (run 46043167677, 5/5 OK).
**The orient picker:** "(Recommended)" on H1, because Mark picked fixing all four and H1 alone changes drawings, so
its effect on the tests, the fidelity tool and the speed page is known first (plan `:1204`); H2, H3, H4 the other
options. Name the rest of the backlog in the question (40 items, `grep -n '^- \[ \]' methodology/BACKLOG.md`):
outside the shipped files READY `:47`, `:195`, `:204`, `:214`, `:229`, `:282`, `:289`, `:295`, `:309`, `:314`,
`:365`, `:384`; changing shipped files `:65`, `:75`, `:81`, `:91`, `:124`, `:349`, `:235` (the tree is open again,
so one could join before 17n, but only by Mark's pick: R175 named four); after acceptance `:326`, `:335`; NEEDS
DECISION `:100`, `:108`, `:117`, `:130`, `:257`, `:275`, `:355`, `:375`; "Waiting on Mark" `:158`, `:165`, `:172`,
`:184`. Not offered: `:141` (an nprcgenekeepr session, R101), `:56` and `:152` (BLOCKED on acceptance).
**Session boundary:** one H item per session, under strict TDD's gates, then close out.
**Priority:** HIGH (the release waits on H1-H4).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**); nprcgenekeepr's log on the copied files,
   `files=($(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#'));
   git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- "${files[@]}"`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`), nprcgenekeepr at `3e06730c5` (S103's Orient).
2. **H1:** read plan `:1174` and the runbook's record (`docs/planning/cran-submission-runbook.md:168`). Run
   `docs/planning/cran-handtest-crossings.R` after `pkgload::load_all()` (S103's close: A 2 crossings; 3 of the 6
   orders 0). Pre-RED, measure (Learning 17): the tie kept in the tree pass's order instead of the id, in a scratch
   copy (`git archive HEAD | tar -x -C <scratch>`): which test files fail, how many fidelity cases move, C1's
   crossings with no hint and with `order = c(RKBTHH = 1, I8ABQE = 2, ZK6NM2 = 3)`. Then the pre-RED picker.
3. **H2:** reproduce first. Try `Rscript -e 'devtools::test()'` with `NOT_CRAN=true`. If it doesn't print the
   message, Mark runs Test Package in RStudio and pastes it. Find which test prints it, and trace the 17,354 vs
   S100's 17,353 in the same run.
4. **H3, H4:** a picker on the words first (framing before filling). H4's README line ships: ask before changing it.
5. Every H session: the TDD gates by picker; suite WARN 0, lint 0, roxygen unchanged; a changed copied function gets
   a `DIVERGENCE.md` row (R98, "at the switch"); NEWS: no line for a fix to behaviour no release had (R171's
   reasoning), unless the session finds a NEWS item that describes the old behaviour.
6. After the last H item: 17n again (plan `:1053`'s list; a new tarball and SHA-256; H1's timed cells A/B as S100),
   then 17o again (runbook sections 1-7, the new SHA-256; `cran-comments.md`'s results lines), then 17p.
7. **CI on every push:** five jobs, without renv. Known flakes `:235`, `:257`, `:275` (rerun a failed job once).

### Gotchas
- **The tree is open again only for H1-H4 (R175).** R172's freeze returns at 17n again; any other shipped-file item
  needs Mark's pick first.
- **Don't rebuild the tarball before 17n again;** then the new SHA-256 replaces `abb78758…` in runbook section 2
  (`:43`) and `cran-comments.md`'s results lines are refilled from 17o's new runs.
- **H1 changes a copied function:** `sweepMinSepBackstop()` is a local function of `.positionMatingUnitForest()`
  (`R/makePedigreeDiagramData.R:1123`). The fidelity tool compares layouts with nprcgenekeepr's by `identical()`,
  so the cases that move need a set-aside (as `withoutJogSelections()`), and the drift tool needs a row. The help's
  sentence is in roxygen at `R/makePedigreeDiagramData.R:1974` and `R/layoutHints.R:258`, not only in `man/`.
- **A crossing counter is not in the tests yet:** `docs/planning/cran-handtest-crossings.R` counts solid-line
  crossings, skipping shared endpoints; the dashed duplicate connectors are left out. A test needs its own.
- **RStudio cannot open a file in Claude's scratchpad** (`/private/tmp/claude-501/...`): a script Mark runs goes
  under his home folder (dragon 48). His hand-test folder `~/pedkindraw-handtest` (lib, out, `handTest.R`) is his
  to delete. A re-test on the new tarball can reuse it, with its "should show" lines measured again.
- **While Mark tests or asks, answer each question; no close-out picker until he says he has finished** (memory,
  S103). **Offer fixing first plainly; don't recommend deferring only because the gate is frozen** (memory, S103).
- **The rulings table's R172 and R173 rows have 2 of its 4 cells** (`docs/planning/standalone-pedigree-package-plan.md`
  `:357`-`:358`), left as found; R174 and R175 (`:359`-`:360`) have all 4.
- **Say why before running a check the plan does not list** (S100).
- **Carried:** `"${VAR:?}"` in `rm -rf`; zsh does not split an unquoted variable (use an array); local runs use
  renv's lock (Bioconductor 3.23), CI does not; a Chrome test can error under load, so run the full suite alone;
  backslashes in `Rscript -e` go in a file; the 5-file cap splits commits; `CLAUDE.md` is over its budget (learnings
  go to the cran plan's dragons, now 48); `methodology/HANDOFFS.md` about 250 KB, under the 262,144 B where a default
  read returns nothing (backlog `:375`): keep the receipt short; the ratchet's run takes about 12 min.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- The CRAN plan `docs/planning/cran-submission-plan.md`: status `:39`; 17n `:1053`; 17o's Next superseded `:1164`;
  "Phases H1-H4" `:1167` (H1 `:1174`, H2 `:1186`, H3 `:1192`, H4 `:1197`, order `:1204`, then `:1207`); 17p `:1214`;
  dragon 48 `:1529`.
- `docs/planning/cran-submission-runbook.md`: header `:16`; section 1 `:30`; section 2 `:43`; section 8 `:136`; the
  record `:144`, the hand test `:168`.
- `docs/planning/standalone-pedigree-package-plan.md`: Next `:118`; R175 `:360`. `methodology/ROADMAP.md:120`.
  `methodology/BACKLOG.md:9` (H1 `:16`, H2 `:25`, H3 `:32`, H4 `:38`).
- `docs/planning/cran-handtest-1.0.0.R` (the script Mark ran, as run); `docs/planning/cran-handtest-crossings.R`.
- Code: `R/makePedigreeDiagramData.R:1318` (`sweepMinSepBackstop()`; the tie-break `:1322`), `:1400` (the
  couple-centring shift), `:1974` (the hints help); `R/layoutHints.R:317` (`.layoutHintRoots()`), `:258`;
  `R/orderRootSubtrees.R:21`; `R/savePedigreeDiagram.R:401` (`.closeChrome()`, `chrome$close()` `:407`);
  `vignettes/speed.Rmd:104` (the study's table), `:174` (the paired table); `R/pedigreeApp.R:860` (the Diagram tab);
  `vignettes/drawing.Rmd:20`; `README.md:125`; `vignettes/pedkindraw.Rmd:185`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 104 Did
**Deliverable:** H1 (R175; plan "Phases H1-H4"): the ED5PDV drawing's 2 avoidable crossings, and the order hint a
tie overrides, fixed under strict TDD (IN PROGRESS). Measure first in a scratch copy what the fix changes (tests,
fidelity cases, C1's crossings with and without the hint), then the pre-RED picker.
**Started:** 2026-11-28 00:01 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "H1: drawing crossings
(Recommended)" (orient picker).
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### What Session 103 Did
**Deliverable:** Hand testing before the CRAN upload (Mark's request, ahead of 17p). DONE (R175): Mark ran the
installed tarball in RStudio, every part of the script; four findings, which he chose to fix before the upload (H1-H4).
**Started:** 2026-11-27 14:37 CST · **Model:** Claude Opus 5.5 · **Mark's words:** "prior to the upload I want to do
some manaual testing with your help." **Mark's picks:** all four areas; "A separate test folder", "You type, I read",
"The runbook's record" (each the recommended option); "Fix all four first" (not the recommended "Upload as is"); the
parts he ran: 0, A and B, C, D, E.
**Commits:** claim `58a9cc9`; close-out 1 `7fd8ac0` (runbook, CRAN plan, R175, roadmap, backlog); close-out 2 (the
script and the crossing counter in `docs/planning/`, these notes, the receipt, the ledger), pushed after.
**Measured:** RStudio's Test Package `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 17354 ]`, with chromote's Browser.close
timeout printed twice. Each "should show" line came from Claude's run of the same calls on the same tarball,
installed the same way in a scratch library (18:54-18:56 CST). The app was run headless (`callr::r_bg()` with
`chromote`) for E3: the 72-collision warning is on the line under "375 animals drawn". Mark reported no value
different from its line, and his six saved files (20:33) have the measured sizes to the byte. Finding 3 was traced to
`sweepMinSepBackstop()`'s tie-break by id (`R/makePedigreeDiagramData.R:1322`). The crossing counter gives 2
crossings as drawn and 0 for 3 of the 6 row orders, both on the tarball and on the tree at `7fd8ac0`. Finding 2: the
speed page's numbers are right, but its headings mislead. Finding 4: the drawing sets no `visInteraction()`, so
visNetwork's defaults apply. Questions answered: the test output; why `bitSize()` is in the speed page's second
table; `twins` after `checkTwinRelations()`; C1's crossed line; where E3's warning shows; how to choose the animals
to draw; how to move around a drawing.

#### Session 102 Handoff Evaluation (by Session 103)
**Score: 9/10.** ROI high: Orient and every frozen-tree fact the hand test relied on came from its notes.
- **What helped:** the tarball's SHA-256 and "never rebuild it"; the freeze (a shipped-path change reopens 17n, about
  1.5 h, and needs a new tarball), which set what each finding would cost and shaped Mark's upload picker; What You
  Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`), exact; the orient picker's 36 items, each at its line; the
  runbook's record as the place for results, which Mark then picked for the hand test.
- **What was missing:** nothing a hand test needed could have been foreseen. The notes planned only for "submitted"
  or "not submitted", so the hand test was framed from scratch (four pickers' worth).
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 7/10.**
+ Every "should show" line measured on the same tarball before Mark ran it, labelled (measured) or (vignette).
  Finding 3 traced to the line and a working hint found the same evening. E3 measured headless when Mark could not
  find the warning. Each finding stated what it means for users, and whether nprcgenekeepr shares it.
- **Posted close-out pickers twice while Mark was still testing.** He answered the second with "Stop asking questions
  until you answer my questions." Saved as memory (answer-before-asking).
- **Script slips Mark met:** the header time (14:55 for 18:54); B2's comment read as "twins empty"; E3 said "likely"
  before it was measured; the first script sat in the scratchpad, which RStudio cannot open. Each was corrected
  while he ran it.
- **Recommended "Upload as is"; Mark chose to fix all four.** The cost was stated plainly; saved as memory
  (fix-before-release).

### What Session 102 Did
**Deliverable:** Phase 17o's second session: the cross-platform results folded into `cran-comments.md` and the plan.
DONE, so 17o DONE (R174).
**Started:** 2026-11-27 14:06 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"Fold in 17o results" (orient); "Drop its line" (the macOS builder). Mark pasted win-builder's three emails as they
came (R-release, R-devel, R-oldrelease) and asked whether Claude had seen the first: no, Claude cannot read his mail.
**Commits:** claim `f243562`; work `1aca927` (`cran-comments.md`); close-out 1 `f06b896` (CRAN plan, runbook,
standalone plan R174, roadmap); close-out 2 (these notes, the receipt, the ledger, dragon 47), pushed after.
**Measured:** the 11 shipped paths unchanged since `2456253` at HEAD and on GitHub (control from `5347bb3`: S99's 3
files); the tarball `abb78758…22dcfe3c`; each win-builder folder's `00check.log` (1 NOTE, the incoming check's
Maintainer line and "New submission" alone; the three logs the same but for timings) and
`examples_and_tests/tests/testthat.Rout` (`SKIP 27 | PASS 2696`, elapsed = CPU); R-hub's three job logs
(`Status: OK`; Ubuntu 26.04.1 and Intel macOS 15.7.9 on r90998, Windows on r90926); the macOS builder 502 at 20:07:45
UTC (`/v1/` 502, form page 200); `NeedsCompilation: no` in the tarball; drift 91 / 23 / 0 and nprcgenekeepr
`3e06730c5` with the same 4 commits at Orient and at 20:10 UTC. quality_ratchet: 7/7 pass · 0 fail · 0 unmeasured · results dd3bb45ce615 · manifest 4127d978ffc1 (at `f06b896`, 20:23 UTC)

#### Session 101 Handoff Evaluation (by Session 102)
**Score: 9/10.** ROI high: Orient, the orient picker and the whole fold-in ran from its notes.
- **What helped:** What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, the zsh array), each exact; 2's
  reading list (runbook section 1 first; the spelling words and dragon 39; dragon 10's URL; `proc.time()` and dragon
  8; R-devel's 540; R-hub through the jobs API; the macOS builder picker with nprcgenekeepr's S1105 precedent); the 7
  marker lines and every plan line (`:39`, `:1111`, `:1116`, `:1146`, `:118`, `:120`) exact at `1ea0d0a`; the orient
  picker's 36 items each at its line; win-builder's queue `curl`, which showed all three checks had started.
- **What was missing:** that `gh api .../jobs/<id>/logs` needs `--allow-escape-sequences` for R-hub's logs (one
  retry); which commit gives runbook section 1 a control that can fail (S101 wrote "a control diff lists changes"
  without naming it; `2456253^` is vacuous, dragon 47).
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 9/10.**
+ Orient in full, the claim before any work; each folder read from its files, not from the emails' summaries, and the
  three logs compared by `diff`; R-hub's facts carried from S101's paragraph re-read in its job logs (Learning 8);
  the macOS picker stated the coverage left, the missing setup, `NeedsCompilation: no` and the precedent; every item
  of 17o's DONE list met and recorded; drift and nprcgenekeepr read twice.
- **Slips caught before recording:** the first control (`2456253^`) printed nothing and proved nothing (replaced,
  dragon 47); R-hub's log download printed one refusal line (retried with the flag).
- **Left as found:** the rulings table's R172 and R173 rows have 2 of 4 cells (Gotchas).

### What Session 101 Did
**Deliverable:** Phase 17o's first session: `cran-comments.md`, the run list, R-hub's workflow, and D9. DONE
(R173); the runs started by Claude on Mark's D9 pick (the macOS builder answered 502 and has not run).
**Started:** 2026-11-27 12:51 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"17o: CRAN notes and run list" (orient); "Say it up front", "In the runbook and plan", "Add the file, renv off"
(framing); "Claude starts them now" (D9). **Mark's requests:** a backlog item to copy nprcgenekeepr's README badges
that fit (`:299`), then "hold off making changes until after acceptance by CRAN" added to it. He asked whether R-hub's
macOS job taking about 10 times as long was unusual: answered from the logs (Intel macOS builds 116 of 119 packages
from source; nprcgenekeepr's macOS job was its slowest too, 34 min).
**Commits:** claim `47c5f86`; work `1d04ba0` (pushed mid-session, the skip marker, so R-hub's workflow was on GitHub;
no CI run); close-out 1 (plans, runbook, roadmap, backlog); close-out 2 (these notes, the receipt, the ledger),
pushed after.
**Measured:** 17n's tarball (`abb78758…22dcfe3c`) against HEAD: the 276 tracked files the build keeps all in it, 275
byte-identical, `DESCRIPTION` equal field by field, plus 10 built; the 11 shipped paths unchanged since `2456253` (a
control diff lists changes); 22 of the 38 exports share nprcgenekeepr's names (both `NAMESPACE`s); the CI guard
flags 0 jobs in R-hub's published file (its `setup-deps` calls r-lib's `setup-r-dependencies`); pkgdown's source
skips `cran-comments.md`; the macOS builder's form offers R-devel only. **Runs:** win-builder x3 by FTP, reply 226,
19:11:52-19:12:05 UTC; R-hub run 46055056615 `Status: OK` x3, renv off in each (the install step's no-renv branch);
the macOS builder 502 at 19:12:25 and 19:58:51 UTC. quality_ratchet 7/7 at `1d04ba0` (results `dd3bb45ce615`), 11
min, load 2.0-11.1.

#### Session 100 Handoff Evaluation (by Session 101)
**Score: 9/10.** ROI high: Orient, the orient picker and 17o's reading ran from its notes.
- **What helped:** What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each exact); the orient picker's 34
  items, each at its line; 2's reading list: 17o `:1104`, 17n's DONE paragraph `:1062` (the results
  `cran-comments.md` states), section 4.4, dragons 8, 10, 11 and 34-36 (34's queue warning made D9's "start them
  now" the recommendation), D9; nprcgenekeepr's `cran-comments.md` with "an update, not new"; "build the tarball from
  a `git archive`" pointed at 17n's recipe, and so at 17n's own tarball, still in S100's scratchpad.
- **What was missing:** that pedkindraw has no R-hub workflow and that R-hub's install step would start renv (S98's
  failure), found by reading R-hub's actions; nprcgenekeepr's Phase 8 runbook
  (`docs/planning/cran-3.0.0-phase8-runbook.md`), the closest model for the run list; that section 4.4's "for the
  record (not for CRAN)" conflicts with sending the whole file to CRAN (R173's second ruling).
- **What was wrong:** nothing found; every cited line was exact at `e2c63e4`.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; a framing picker before filling, its options stating measured facts
  (22 shared exports, the guard's 0, the tarball proved by machine); R-hub's renv trap found by reading the actions at
  their pinned refs before any run, and R-hub's run then showed renv off in all three jobs; the runs started early
  (dragon 34) on Mark's D9 pick, each recorded with its time and reply.
- **Slips caught before commit:** the 3.24 line first said "the same tarball" (17n built that one separately); two
  markers wrapped across lines (`grep -c` read 6 of 7); a zsh unsplit variable gave an empty `git diff` that proved
  nothing (redone with an array and a control); dragon 46 first gave an inferred count, and "would start renv" read
  as measured (reworded as read).
- **Not reached:** the macOS builder (502 throughout).
