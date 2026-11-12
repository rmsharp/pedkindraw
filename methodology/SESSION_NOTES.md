# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 10, shrink**: `shrinkPedigree()`, the last copy slice (`methodology/BACKLOG.md:11`; plan row
`docs/planning/standalone-pedigree-package-plan.md:380`). It is the only READY item; the orient picker still asks
Mark (go / hold).
**Status:** READY. The R37 port is DONE (S12): `drawPedigreeDiagram()` matches nprcgenekeepr `4283e3502`,
`DIVERGENCE.md` has no row; suite 481 tests, 0 failed, WARN 0; `R CMD check --as-cran` R16's NOTE only; results tool
540 of 540 identical against nprcgenekeepr `45e0d8bfe`; drift tool exit 0, 85 functions, 0 differ; **pushed through
`11b62cd`** (CI run `43306885895` 5/5 `Status: OK`); S12's two close-out commits are not pushed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:33` (Next), `:380` (row 10), `:436` ("Done 9", the model
for "Done 10").
**Session boundary:** one session (an estimate: 303 source lines and 24 tests, against Phase 9's ~1,100 lines).
**Priority:** HIGH.

### What You Must Do
1. Orient, then check nprcgenekeepr (Learning 15): `git -C ../nprcgenekeepr log --oneline 45e0d8bfe..HEAD --
   R/shrinkPedigree.R tests/testthat/test_shrinkPedigree.R R/drawPedigreeDiagram.R` and
   `git -C ../nprcgenekeepr status --short`. At `45e0d8bfe` both shrink files are unchanged since `baef1e12c`
   (measured S12). Repeat both at every phase gate.
2. Survey (Learning 9): `codetools::findGlobals()` on each of the file's 5 functions (`shrinkPedigree()` exported;
   `.checkShrinkInput()`, `.removalPass()`, `.isParent()`, `.bitSize()`), and grep for `::` (S11: none in the code;
   the help names `kinship2::pedigree.shrink()` at `:121`, the example loads `nprcgenekeepr::examplePedigree` at
   `:210`, so the example types its own pedigree, R21).
3. The pre-RED picker, plain words (Learnings 1-2), two questions: (a) which of the 3 nprcgenekeepr-only test files
   that name `shrinkPedigree()` to leave out (`test_cleanroomProvenance.R:30-33`, `test_inventoryTutorialSections.R:108`,
   `test_snapshotTutorialSection.R:11`; each reads nprcgenekeepr's own records or tutorial, so likely out, as R35);
   (b) when the stand-in goes (gotcha below).
4. RED copies `test_shrinkPedigree.R` (455 lines, 24 tests); GREEN copies `R/shrinkPedigree.R` (its example typing its
   own pedigree) and deletes `tests/testthat/helper-shrinkPedigreeStandIn.R`; fidelity cases in `runCases()`
   (Learning 11: read covr's uncovered lines over the cases and over the tests); push; CI; "Done 10" in the plan.

### Gotchas
- **The stand-in shapes RED.** `tests/testthat/helper-shrinkPedigreeStandIn.R` defines `shrinkPedigree()` for every
  test file: it returns nprcgenekeepr's saved result for the two Track B calls and `stop()`s on anything else. So if
  RED keeps it, the 24 copied tests fail on the stand-in's error, not on a missing function. Deleting it in RED
  instead makes the 3 Track B call sites fail too (`test_orderRootSubtrees.R:182`, `test_solveJointQP.R:65`,
  `test_positionMatingUnitForest.R:2394`), for the right reason. Mark's pick. Once the stand-in goes, `tests/testthat/fixtures/trackBShrunk.rds` and `tools/makeComputedTestFixtures.R:19`,
  `:73-74` have no reader: delete them or keep them as a check, also a pick.
- **`patch -p1 -F0`** applies a nprcgenekeepr diff exactly (Learning 16). Phase 10 is a fresh copy, not a port, so
  Learning 13's copy-script recipe applies: assert each replaced line, `diff source copy` lists only the planned
  hunks, `identical(parse(a, keep.source = FALSE), parse(b, keep.source = FALSE))`.
- **R CMD check outside the project folder** (the scratchpad, to keep the tree clean while another tool runs) finds no
  renv library and fails "Package required but not available: 'quadprog'". Set both `R_LIBS` and `R_LIBS_USER` to
  the library `Rscript -e 'cat(.libPaths()[1])'` prints from the project root.
- **zsh:** `rm -rf pedkindraw_*` with nothing to match stops an `&&` chain ("no matches found"); `tail -N` on a suite
  run can cut its summary line (S12 re-ran one); use script files for `Rscript` code with backslashes.
- **The results tool**: name a commit (`Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr <commit>`)
  when nprcgenekeepr's session may be editing; about 100 s per package. Whole widgets compare equal only while both
  renv libraries link one cache entry of visNetwork 2.1.4.
- **Learning 12's baseline run** worked first time in S12: `git archive <commit> DESCRIPTION NAMESPACE R data inst
  tests` into the scratchpad, then `cd ../nprcgenekeepr && env -u RENV_PROJECT -u R_LIBS_USER Rscript <script>` with
  `pkgload::load_all(<archive>)` and `test_file(..., package = "nprcgenekeepr", load_package = "none")`; compare `nb`
  per test by name.

### Key files
- `tests/testthat/helper-shrinkPedigreeStandIn.R:13-23` (the stand-in); `tests/testthat/fixtures/trackBShrunk.rds`;
  `tools/makeComputedTestFixtures.R:19`, `:73-74`.
- The stand-in's callers: `tests/testthat/test_orderRootSubtrees.R:6` (header), `:182`; `test_solveJointQP.R:4`
  (header), `:65`, `:145`; `test_positionMatingUnitForest.R:1333`, `:2394`. (`test_comparePedigreeStructure.R:759`
  only names it in a comment.)
- `tools/compareResultsWithNprcgenekeepr.R:41` (`runCases()`), `:201` (the `cases` list), `:302`
  (`kinshipFounders`, a made-up variant, the model for shrink cases).
- `methodology/BACKLOG.md:11` (the Phase 10 item); `CLAUDE.md:169-171` (Learnings 14-16).
- `R/drawPedigreeDiagram.R:3-5` (header: copied at `4283e3502`); `DIVERGENCE.md:12-19` (empty table).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S11's entries were removed in S3-S12 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 11 Handoff Evaluation (by Session 12)
**Score: 8/10.**
- **What helped:** the nprcgenekeepr check command, which found the commit the handoff could not know; the port's
  three test lines (`:89`, `:118`, `:127`) and the code lines (`:154-162`), both right; `.affectedColor()` at
  `R/makePedigreeDiagramData.R:199`; the results tool's commit argument (used); whole-widget identity (it held); the
  baseline-run recipe (worked first time); the copy proofs (parse identical, planned hunks only).
- **What was missing:** that the stand-in for `shrinkPedigree()` shapes Phase 10's RED (found in S12's close-out, now
  a gotcha).
- **What was wrong:** "3 tests should fail": 2 tests fail, with 6 expectations (the three checks sit in two tests).
  "One code hunk" was true when written; nprcgenekeepr's REFACTOR `4283e3502` came after. Its key files list
  `test_comparePedigreeStructure.R:759` among "the calls it stands in for": that line is a comment.
- **ROI:** high.

### What Session 12 Did
**Deliverable:** port nprcgenekeepr S1159's legend fill into `drawPedigreeDiagram()` (plan R37), test-first in its
three steps; `DIVERGENCE.md`'s row deleted; push, CI (DONE)
**Started:** 2026-11-12 · **Model:** Claude Opus 5.5 · **Mark's picks:** "Port the legend fix" (orient); the README
stays "At Phase 16 as planned" (asked mid-session; nothing changed); the PRE-RED, RED and GREEN gates "Yes".
Mark also asked when `BACKLOG.md` would be added: it is at `methodology/BACKLOG.md` since S6 (`96f9e4b`), on GitHub.
**Commits:** claim `c93a465`; RED `81faeb6`; GREEN `fa06297`; REFACTOR `11b62cd` (with the row's deletion); pushed
once (6 commits, `d97ccfa..11b62cd`); close-out `94afb07` and close-out 2 (these notes, the receipt, the ledger, the
backlog). Close-out commits not pushed.
**Verified:** each phase applied with `patch -F0` and proven (parsed code identical to nprcgenekeepr's at the commit;
diffs of header and help hunks only); RED 2 tests, 6 expectations, as nprcgenekeepr's own RED; GREEN 12 tests with
nprcgenekeepr's 69 expectations test for test; REFACTOR 16 of 16 widgets identical to GREEN's; suite 481 tests,
0 failed, WARN 0, SKIP 0; lint 0; roxygen idempotent; drift tool exit 0, 0 differ; results tool 540 of 540 identical
against `45e0d8bfe`; `R CMD check --as-cran` 1 NOTE (the allowed one), PASS 2079 SKIP 3; coverage 97.11%, the file
91 of 91 lines; headless Chrome read the drawn colours (before: sex rows `#97C2FC`, Affected outline `#a3507e`;
after: sex rows `#FFFFFF` / `#2B7CE9` as the unaffected animals, Affected `#CC79A7` / `#2B7CE9` as the affected one);
CI run `43306885895` 5/5 `Status: OK`, first attempt; `quality_ratchet` 4/4.
**Self-assessment: 8/10.**
+ Orient found the commit the handoff could not know, before any planning; every phase was nprcgenekeepr's own
  commit, applied exactly and proven by machine; the drawn colours read before and after, not assumed; Mark's two
  mid-session questions answered with a picker and a plain answer, no scope change.
- Slips, each caught: a diff check compared misaligned lines (said so, re-proven); `R CMD check` first ran without the
  renv library; a zsh glob stopped a chain; a `tail` cut the suite's summary (re-ran 83 s). The legend sits about
  30 px further left in the second screenshot than the first; the widget data are identical, and I did not find why.
**Ledger:** `CHANGELOG.md` S12 entries (the session and the push).
