# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17o DONE (S33-S102); the gap
phases G1-G17 DONE (S42-S77); the hand test DONE (S103, R175), its four findings to fix before the upload, H1-H4
(plan `:1167`; backlog `:9`). **S104: H1 DONE (R176):** a tie the founder couples' centring leaves keeps the order
the row had before it; ED5PDV's drawing has no crossing lines; every order hint of its founder dams is followed.
**Next: one of H2-H4** (Mark picks; suggested order H2, H3, H4, plan `:1220`):
H2 the Chrome timeout message in RStudio's test run (plan `:1202`, backlog `:16`); H3 the speed page's table
headings (`:1208`, `:23`); H4 saying how to move around a drawing (`:1213`, `:29`). After all three: 17n's gate and
17o's runs again on a new tarball, then 17p. **`abb78758…` will not be submitted.**
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). H1's code pushed through
`aa62798` and checked by CI run 46124789964 (5/5 Status OK, first attempt, `FAIL 0 | WARN 0`, PASS 17,109-17,121;
pkgdown OK); the close-out pushed after it with the skip marker.
**The orient picker:** "(Recommended)" on H2 (the suggested order; Mark picked fixing all four); H3, H4 the other
options. Name the rest of the backlog in the question (40 items, `grep -n '^- \[ \]' methodology/BACKLOG.md`):
outside the shipped files READY `:38`, `:186`, `:195`, `:205`, `:220`, `:273`, `:280` (new: tell nprcgenekeepr
of H1's tie), `:289`, `:295`, `:309`, `:314`, `:365`, `:384`; changing shipped files (only by Mark's pick, R175
named four) `:56`, `:66`, `:72`, `:82`, `:115`, `:349`, `:226`; after acceptance `:326`, `:335`; NEEDS DECISION
`:91`, `:99`, `:108`, `:121`, `:248`, `:266`, `:355`, `:375`; "Waiting on Mark" `:149`, `:156`, `:163`, `:175`.
Not offered: `:132` (an nprcgenekeepr session, R101), `:47` and `:143` (BLOCKED on acceptance).
**Session boundary:** one H item per session, under strict TDD's gates, then close out.
**Priority:** HIGH (the release waits on H2-H4).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**); nprcgenekeepr's log on the copied files,
   `files=($(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#'));
   git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- "${files[@]}"`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`), nprcgenekeepr at `3e06730c5` (S104's Orient and each of its phase gates).
2. **H2:** reproduce first. `Rscript -e 'devtools::test()'` with `NOT_CRAN=true` (RStudio's Test Package runs
   that). S104's runs of `testthat::test_local()` printed a related websocket line, "[warning] got non-close frame
   while closing", 4 times in the GREEN suite, 9 in candidate A's, once in a single `savePedigreeDiagram()` PNG
   save; never the Browser.close timeout. Find which test prints each; `R/savePedigreeDiagram.R:401`
   (`.closeChrome()`, `chrome$close()` `:407`). RStudio's 17,354 vs S100's 17,353: S104's `test_local()` with
   `NOT_CRAN=true` on a scratch copy of `8fb67c1`'s tests with H1's rule read 17,354 (H1 changed 2 checks' values,
   not their number), so the one more is not RStudio's; the tree now reads 17,376 (H1's 22 added).
3. **H3, H4:** a picker on the words first (framing before filling). H4's README line ships: ask before changing it.
4. Every H session: the TDD gates by picker; suite WARN 0, lint 0, roxygen unchanged; a changed copied function gets
   a `DIVERGENCE.md` row (R98, "at the switch"); NEWS: no line for a fix to behaviour no release had (R171's
   reasoning). The fidelity tool now takes about 5.5 min (three runs of about 100 s each).
5. After H4: 17n again (plan `:1053`'s list; a new tarball and SHA-256; H1 changed code inside timed calls, so the
   speed page's changed cells are timed A/B as S100 did), then 17o again (runbook sections 1-7, the new SHA-256;
   `cran-comments.md`'s results lines), then 17p.
6. **CI on every push:** five jobs, without renv. Known flakes `:226`, `:248`, `:266` (rerun a failed job once).

### Gotchas
- **The tree is open again only for H1-H4 (R175).** R172's freeze returns at 17n again; any other shipped-file item
  needs Mark's pick first.
- **Don't rebuild the tarball before 17n again;** then the new SHA-256 replaces `abb78758…` in runbook section 2
  (`:43`) and `cran-comments.md`'s results lines are refilled from 17o's new runs.
- **The fidelity tool's sixth set-aside (S104):** `putBackNprcgenekeeprTie()` (`tools/compareResultsWithNprcgenekeepr.R:620`)
  swaps one call in the loaded namespace; a later edit of `sweepMinSepBackstop()`'s `order()` call
  (`R/makePedigreeDiagramData.R:1337`) must keep that call's text, or the tool stops ("found ... 0 times"). Expect
  "results pedkindraw's tie rule changes: 24".
- **A scratch copy of the tree (`git archive HEAD | tar -x -C <dir>`) runs only with renv's library and no
  `.Rprofile`:** `env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib> Rscript --no-init-file ...`, `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'`; with the `.Rprofile`, renv starts a new empty library there.
- **The fidelity tool's child mode saves one package's results** for comparing two trees:
  `Rscript tools/compareResultsWithNprcgenekeepr.R --child . ../nprcgenekeepr/tools/pedigreeComparison/data <out.rds>`
  (S104 compared HEAD with a candidate, and REFACTOR with GREEN, this way).
- **RStudio cannot open a file in Claude's scratchpad** (`/private/tmp/claude-501/...`): a script Mark runs goes
  under his home folder (dragon 48).
- **While Mark tests or asks, answer each question; no close-out picker until he says he has finished** (memory,
  S103). **Offer fixing first plainly** (memory, S103).
- **The rulings table's R172 and R173 rows have 2 of its 4 cells** (`docs/planning/standalone-pedigree-package-plan.md`
  `:357`-`:358`), left as found; R174-R176 (`:359`-`:361`) have all 4.
- **Seen, not acted on (S104):** in ED5PDV's drawing the dashed "same animal" line from 5LDNWE runs through
  D1WP48's label and across D1WP48's line down to YPHFHF, before H1 and after (the crossing counter leaves dashed
  lines out, as S103's did). Not a backlog item; say so to Mark if a drawing item comes up.
- **Say why before running a check the plan does not list** (S100).
- **Carried:** `"${VAR:?}"` in `rm -rf`; zsh does not split an unquoted variable (use an array); local runs use
  renv's lock (Bioconductor 3.23), CI does not; a Chrome test can error under load, so run the full suite alone
  (now about 11 min); backslashes in `Rscript -e` go in a file; the 5-file cap splits commits; `CLAUDE.md` is over
  its budget (learnings go to the cran plan's dragons, now 49); `methodology/HANDOFFS.md` about 252 KB, under the
  262,144 B where a default read returns nothing (backlog `:375`): keep the receipt short; the ratchet's run takes
  about 12 min.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- The CRAN plan `docs/planning/cran-submission-plan.md`: status `:39`; 17n `:1053`; "Phases H1-H4" `:1167` (H1
  `:1174` with its DONE paragraph, H2 `:1202`, H3 `:1208`, H4 `:1213`, order `:1220`, then `:1223`); 17p `:1230`;
  dragons 48 `:1545`, 49 `:1557`.
- `docs/planning/cran-submission-runbook.md`: section 2 `:43`; the record `:144`, the hand test `:168`.
- `docs/planning/standalone-pedigree-package-plan.md`: Next `:118`; R176 `:361`. `methodology/ROADMAP.md:120`.
  `methodology/BACKLOG.md:9` (H2 `:16`, H3 `:23`, H4 `:29`).
- H1's code: `R/makePedigreeDiagramData.R:1332` (`sweepMinSepBackstop(tieX)`), `:1347` and `:1425` (its two
  calls); `tests/testthat/test_layoutTieOrder.R:44`-`:85`; `tests/testthat/helper-crossings.R:12`
  (`solidLineCrossings()`); `tools/compareResultsWithNprcgenekeepr.R:620`, `:771`, `:787`; `DIVERGENCE.md:17`.
- H2: `R/savePedigreeDiagram.R:401`, `:407`. H3: `vignettes/speed.Rmd:71` and `:137` (the headings), `:104` and
  `:174` (the tables); `tools/checkSpeedTables.R`. H4: `R/pedigreeApp.R:860` (the Diagram tab);
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
**Deliverable:** H1 (R175; plan "Phases H1-H4"), the ED5PDV drawing's 2 avoidable crossings and the order hint a
tie overrode, fixed under strict TDD. DONE (R176).
**Started:** 2026-11-28 00:01 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"H1: drawing crossings" (orient); "Order before the shift", "Turn the tie back", all four RED tests (pre-RED);
"Yes, proceed to RED", "Yes, proceed to GREEN", "Yes, proceed to REFACTOR".
**Commits:** claim `6c63a84`; RED `7cc5eaf`; GREEN 1 `6157bec` (the rule); GREEN 2 `ac2020d` (the fidelity tool's
second run, `DIVERGENCE.md`); REFACTOR `aa62798` (`sweepMinSepBackstop(tieX)`); close-out 1 `34b8a70` (plans,
R176, dragon 49, roadmap, backlog); close-out 2 (these notes, the receipt, the ledger), pushed after.
**Measured:** the cause, traced in a scratch copy with print lines: the tree pass orders ED5PDV's founder couples
RKBTHH 0, 5A6DFT 1, MY1AEU 2; the S666 centring step moves RKBTHH and 5A6DFT to 0.5 (and YPHFHF/WFGRY3,
H16XSK/81MJXH to 1.5 below); the second sweep put each pair in id order. Two candidate rules on 12 cases (6 row
orders, 6 hint orders): the order before the shift, 0 crossings in all 12 and every hint followed; the tree pass's
listing order, 1 crossing left in 5. With the rule picked: suite 2 of 17,354 expectations moved (the 375 sample's
1,412/142 to 1,410/140); 24 of 600 fidelity results moved, each of the 21 layouts in them with fewer crossings; a
7-animal pedigree with the same tie (1 crossing at HEAD, 0). RED failed exactly as predicted (14 + 2). Gates at the
end: suite 17,376, 0 failed, WARN 0 (11.1 min); lint 0; roxygen unchanged; drift 91 / 23 / 0; the fidelity tool exit
0 (24 changed by the rule; 600 of 600 with nprcgenekeepr's rule put back); its put-back controlled on both sides;
REFACTOR's 600 results identical to GREEN's; PNG of ED5PDV's drawing before and after read.

#### Session 103 Handoff Evaluation (by Session 104)
**Score: 9/10.** ROI high: Orient, the orient picker and H1's whole pre-RED measurement ran from its notes.
- **What helped:** What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`), exact; 2's H1 list (run the
  crossing counter after `pkgload::load_all()`; measure the tie rule in a scratch copy: which test files fail, how
  many fidelity cases move, C1 with and without the hint), which was the pre-RED picker's content; the gotchas that
  H1 changes a copied function, that the fidelity tool compares layouts by `identical()` so a set-aside is needed,
  and that no test counts crossings; every code line cited (`:1318`, `:1322`, `:1400`) exact; the 40 backlog items,
  each at its line.
- **What was missing:** that "the tree pass's order" can mean two things (the order the tree pass listed the
  animals in, or their left-to-right order before the shift), which give different results (S104 measured both);
  that a `git archive` copy's `.Rprofile` starts renv on an empty library (`--no-init-file` and renv's library
  needed); that no earlier set-aside handled moved positions (every earlier layout change left the fidelity cases
  unmoved), so the set-aside had to be designed.
- **What was wrong:** nothing found. (`R/layoutHints.R:258`, cited with the help's sentence, is an internal note
  on `.layoutHintPlaces()`, not the user help; the help's sentence is at `R/makePedigreeDiagramData.R:1974`, as
  cited.)
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; the cause traced to the line with the positions printed; two candidate
  rules measured on 12 cases, the suite, the 600 fidelity results and the 375 sample before the picker, its options
  stating counts; every expected test value computed with the prototype, and RED's 9 of 12 predicted from HEAD's 4
  hints not followed and 5 crossings; the put-back controlled both ways; REFACTOR proved by 600 of 600 identical;
  the drawing read as a picture.
- **Slips caught before commit:** a scratch run without renv's library; the 7-animal script without `gen`; the
  crossing comparison assuming one layout per case; a reflowed help line of 90 characters (twice) and a brace lint
  in the tool, each found by lint, the tool rerun after its fix; a draft handoff line with a guessed time.
- **Corrections by Mark:** none; every pick first try.

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

