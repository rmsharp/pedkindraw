# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f DONE (S33-S40); **17f2
DONE (S41)**: `docs/planning/gaps-and-shared-code-plan.md`, rulings R97-R101. Mark's picks: **every gap closes before
the first release** (R97, phases G1-G17, before 17g); nprcgenekeepr names its calls now and imports pedkindraw after
CRAN accepts it (R98, R100); nprcgenekeepr's two faults are its next work (R99); until then changes to the 91 copied
functions start in pedkindraw (R101).
**Next: Phase G1**, a number in a condition column reported, not drawn as affected in silence (plan section 5.1, its
first row; `methodology/BACKLOG.md:26`). Strict TDD, copied code.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G1 (recommended: R97's order puts N first, and G12 builds on it). nprcgenekeepr's N1 and N2 are
sessions Mark starts there (`methodology/BACKLOG.md:83`); a pedkindraw session does not make them (R8).
**Session boundary:** G1 only. Close out when its DONE (plan section 5.1, "Every G phase" and G1's row) is met.
**Priority:** HIGH (G2-G17 and 17g follow it).

### What You Must Do
1. Orient; drift tool (expect 91 functions, 14 differ, 0 without a row); nprcgenekeepr's log on the copied files,
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits at S41's close (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`). **New with R101:** a later nprcgenekeepr commit to a copied file is a
   departure from R101; report it to Mark, R37 until he rules. nprcgenekeepr was at `ee05e020c` (its S1188 RED) at
   S41's close.
2. Check S41's push finished (both workflows run: `docs/planning/` changed).
3. **G1, measure before the pre-RED picker (Learning 17):** (a) which of the fidelity tool's 600 cases and which test
   files give a condition column that is not logical (no fixture in `tests/testthat/fixtures/` or `inst/extdata/` has
   a column starting `affected`, measured S41; 19 test files mention `affected`); (b) what `asPedFrame()` writes for
   kinship2's and Pedixplorer's conditions (kinship2's 0/1 pass through unchanged, `R/asPedFrame.R:255-262`); (c) on
   a scratch copy, a draft check at both reading sites with the whole suite run, reading every failure (dragon 18 of
   the CRAN plan). Then the picker: a warning or a stop, and which values count (0/1 must, by (b)).
4. RED, GREEN, REFACTOR by the gates; `DIVERGENCE.md` rows for `makePedigreeDiagramData()` and
   `makePedigreeMatingLayout()` marked "at the switch" (R98); fidelity tool 600 of 600 identical (logical columns
   unchanged); NEWS bullet; `R CMD check --as-cran` from a scratch folder.

### Gotchas
- **The `as.logical()` reading is deliberate** (nprcgenekeepr issue #133, the comments at
  `R/makePedigreeDiagramData.R:109-115` and `:1903-1907`): text "TRUE"/"FALSE" from a CSV must keep working, and
  "anything that doesn't parse becomes NA, matching kinship2's own NA-tolerant contract rather than erroring". G1
  narrows only what is silently wrong (numbers other than 0 and 1), unless Mark picks otherwise.
- **R98 changes the drift rule until the switch:** pedkindraw's changes to copied functions are `DIVERGENCE.md` rows
  marked "at the switch", not ported (plan section 6; standalone plan section 5's new paragraph). The three old port
  items are now one BLOCKED item, P1 (`methodology/BACKLOG.md:40`).
- **Additions must leave the fidelity tool's 600 cases identical** (plan dragon 1); G1 is a change only for numbers.
- **nprcgenekeepr's faults (plan section 3.4) are not pedkindraw's to fix** (R8, R99): its simulation and its
  `smallPed`. pedkindraw's own fixture `tests/testthat/fixtures/smallPed.rds` has the same 8 of 17 wrong generations
  (BLOCKED item `methodology/BACKLOG.md:49`, after nprcgenekeepr's N1).
- **Running nprcgenekeepr's suite from scratch** (plan section 3.3): its renv library is
  `~/Library/Caches/org.R-project.R/R/renv/library/nprcgenekeepr-e7e04aee/...` (its folder is only read); start
  Rscript from its folder with `env -u RENV_PROJECT -u R_LIBS_USER` (Learning 5); its whole suite takes 6-9 min;
  install pedkindraw into a scratch library with `R CMD INSTALL --library=` and `R_LIBS` set to that renv library.
  Edit a copy's `DESCRIPTION` as text (dragon 8). Never pipe an R script that saves a file into `head` (S41 lost an
  `.rds` that way).
- **Suite and gates:** the suite takes about 275-300 s; `quality_ratchet.py --run` can read the suite gate unmeasured
  past 300 s (`methodology/BACKLOG.md:122`).
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (learnings go to the plans' dragons and these notes);
  `methodology/HANDOFFS.md` 189,965 B after S41's receipt against its 196,608 B trim trigger (an estimate: one
  more session; `python3 methodology/methodology_trim.py --file methodology/HANDOFFS.md --check`, and plan the trim
  if it fires); `rm -rf` with shell variables is refused (use `"${S:?}"`); never pipe chromote into `head`;
  `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:84` (3, measured; 3.1 `:86` the gap table, 3.3 `:159` the
  substitution run, 3.4 `:222` the two faults), `:298` (4, rulings), `:329` (5.1, G1-G17), `:375` (5.2, N1-N3),
  `:401` (6, coordination), `:424` (7.1 order), `:441` (7.2 dragons).
- `docs/planning/cran-submission-plan.md:6` (status), `:545` (17f2's Done), `:556` (Phases G1-G17), `:677` (D4),
  `:700` (session map), `:721` (dragons).
- `docs/planning/standalone-pedigree-package-plan.md:61` (Next), `:223`-`:227` (R97-R101), `:986` (Done 17f2),
  `:994` ("Later, optional", decided), `:1010` (the drift rule until the switch).
- `R/makePedigreeDiagramData.R:117` and `:1913` (the two `as.logical()` reads), `:215` (`.affectedColor()`);
  `R/asPedFrame.R:255` (`.asPedFrameConditions()`); `tools/gapCases.R:377` (case `measuredTrait`).
- `methodology/BACKLOG.md:26` (G1), `:33` (G2-G17), `:40` (P1), `:49` (fixture), `:83` (nprcgenekeepr's N1-N3).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S40's entries were removed in S3-S41 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 42 Did
**Deliverable:** Phase G1, a number in a condition column reported, not drawn as affected in silence
(`docs/planning/gaps-and-shared-code-plan.md:354`; R97; `methodology/BACKLOG.md:26`): measure first (Learning 17),
a pre-RED picker (a warning or a stop; which values count), then RED, GREEN and REFACTOR by the gates; strict TDD,
copied code, a `DIVERGENCE.md` row marked "at the switch" (R98) (IN PROGRESS)
**Started:** 2026-11-18 14:07 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Phase G1 (Recommended)" (orient
picker)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 40 Handoff Evaluation (by Session 41)
**Score: 9/10.**
- **What helped:** Mark's five points verbatim, so the plan could answer each; every count held (drift tool 91/14/0,
  the same 4 commits, 31 exports); the CRAN gotcha ("a CRAN package may not Import a package that is not on CRAN",
  with "check the policy text"), which the policy confirmed word for word; "whether nprcgenekeepr's tests still pass
  with its copied functions replaced by calls into pedkindraw is a scratch measurement", which became section 3.3 and
  found nprcgenekeepr's two faults; the archive recipe for running nprcgenekeepr's code; every key-file line number
  checked held.
- **What was missing:** that nprcgenekeepr's renv library lives in the user cache, not its folder (found at once), and
  that its suite takes 6-9 minutes; nothing a reader could have known about the faults.
- **What was wrong:** nothing found.
- **ROI:** high.

### What Session 41 Did
**Deliverable:** Phase 17f2, the plan for closing the gaps in both repositories and coordinating them, DONE:
`docs/planning/gaps-and-shared-code-plan.md`, rulings R97-R101.
**Started:** 2026-11-18 11:14 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Plan 17f2 (Recommended)"
(orient); "This outline (Recommended)" (framing); D4 after two clarifications ("I do not see how this picker's options
map to the maps-and-shared-code-plan. Clarify"; "The last four rows do not seem to be covered. I have not seen a
reason to not close all gaps."): "All before release (Recommended)"; "Name calls now, switch later (Recommended)";
"Next nprcgenekeepr session (Recommended)"; "Re-export all 22 (Recommended)"; "pedkindraw leads shared code
(Recommended)".
**Commits:** claim `f709b00`; evidence `5bebd3c`; decisions and phases `da69a34`; close-out 1 `2e8e6e1` (the CRAN
plan, the standalone plan's R97-R101, ROADMAP, BACKLOG); close-out 2 (these notes, the receipt, the ledger, the plan's
G1 finding and dragon 9). All pushed at close.
**Measured:** nprcgenekeepr at `eafd54851` parsed (57 calls from 24 files to 20 copied functions); its whole suite on
scratch copies, unchanged (510 files, 4,827 blocks, 0 failed, 0 errors), with pedkindraw's functions in place of its
copies (55 of its 467 own test files failing) and with its 4 out-of-order calls rewritten (31, each classified); its
kinship simulation against kinship2 (200 of 200 draws wrong with its stale generations, 0 of 200 recomputed) and its
`smallPed`; CRAN policy revision 6985 read; drift tool 91/14/0.
**Self-assessment: 7/10.**
+ The central claim of the plan (nprcgenekeepr can take pedkindraw's functions) is a measured suite run, not a
  reading, and it found two real faults in nprcgenekeepr 3.0.0, each checked against kinship2; the evidence was
  committed before the decision pickers, and every citation was checked against its line.
- The D4 picker failed twice: its options were sets described in words that did not map to the plan's table, left
  six rows in no option, and offered no "close all", because I had pre-filtered by my own recommendation; Mark had
  to ask. The third, with each option's rows and the measured pace, was answered at once (a feedback memory now
  records it). The first simulation comparison gave kinship2 rows for parents nprcgenekeepr reads as unknown, and
  looked like a fault in the recomputed values too, until one cell was printed (dragon 9). A scratch `write.dcf()`
  made one false failure (dragon 8). G1's 0/1 constraint (`asPedFrame()`) was found at close-out, not in the
  inventory.
**Learnings:** the plan's dragons 8-9; a feedback memory (picker options that choose items name them, cover every
item and offer "all"); no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S41 entries (the session, the rulings, push 1).
