# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17e DONE (S33-S39); **17f
DONE (S40)**: the gaps document, `docs/research/pedkindraw-gaps-2026-11-18.md`. D4 (which gaps close before the
release) was not answered at its picker: Mark asked two questions, then directed a **planning session** (R96). Next:
**Phase 17f2, the plan for closing the gaps in both repositories and coordinating them** (plan `:519`;
`methodology/BACKLOG.md:58`; ruling R96, standalone plan `:220`).
**Mark's direction (S40), his words, the plan's brief:** "For the next session, create a plan to eventually close
the gaps, where possible, in nprcgenekeepr and pedkindraw such that (1) the first version of pedkindraw for
submission to CRAN is as complete as we decide during the planning session; (2) we discuss refactoring
nprcgenekeepr to use function calls as if we were dependent on pedkindraw; (3) decide if we want pedkindraw functions
in nprcgenekeepr with the intent of replacing them with a dependency on pedkindraw once pedkindraw is accepted by
CRAN (not a certain outcome).(4) figure out how to best coordinate work between nprcgenekeepr and pedkindraw
repositories. (5) Acknowledging that nprcgenekeepr will not necessarily need all of the functionality provided by
pedkindraw." And, mid-close-out: "Pausing development of one repository while waiting on progress in the other is an
acceptable option."
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17f2 (recommended: R96 names it next). A planning session: `methodology/SESSION_RUNNER.md`
"Planning Sessions" (deepest reasoning; evidence-based inventory; each phase's DONE, commands and SURFACE; plan only,
no code). TDD phase none. Each of Mark's points is a decision for him by picker (Learning 1-2), recorded as rulings.
**Session boundary:** one deliverable, the plan under `docs/planning/` with its rulings. Implementing any of it is
later sessions; anything in nprcgenekeepr is a session there that Mark starts (R8 stands until he rules otherwise).
**Priority:** HIGH (17g waits on it).

### What You Must Do
1. Orient; drift tool (expect 91 functions, 14 differ, 0 without a row); nprcgenekeepr's log on the copied files,
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits at S40's close (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr moved during S40 (`acb5d6e16` to `d211606b6`, its
   S1187), none on a copied file.
2. Check S40's last push finished (both workflows run: `docs/planning/` changed).
3. **17f2, research first.** Read the gaps document whole (sections 1, 1.1, 6, 9 and 10 carry the decision's
   evidence); R8, R96 and section 4's "Later, optional" (standalone plan `:979`) and section 5 (the drift rule);
   `DIVERGENCE.md` (14 rows) and the three BLOCKED port items (`methodology/BACKLOG.md:26`, `:37`, `:47`). Then the
   inventory the plan needs, by `grep` in nprcgenekeepr (Learning 6: by name and by citation): every call nprcgenekeepr
   makes to the 91 copied functions (which of its files would call pedkindraw: points 2, 3, 5), and which of
   pedkindraw's 31 exports nprcgenekeepr has no use for (point 5). Measure, don't guess (Learnings 17-19): e.g.
   whether nprcgenekeepr's tests still pass with its copied functions replaced by calls into pedkindraw is a scratch
   measurement, not a plan claim, unless run.
4. Before filling the plan, a framing picker on its outline (memory "framing before filling"); then one picker per
   decision in plain words, at most four options each: D4 (which of the 16 gaps close before the release, each
   then a phase before 17g); whether nprcgenekeepr calls pedkindraw's functions (point 2), carries copies until
   CRAN acceptance (point 3) or neither; the order of work between the repositories, pausing one allowed (point 4);
   which of pedkindraw's functions nprcgenekeepr needs (point 5).

### Gotchas
- **R8 is in play.** Points 2 and 3 propose changing nprcgenekeepr, which R8 has kept unchanged by pedkindraw's work
  ("until Mark later decides"). The plan proposes; Mark rules; nothing is changed in nprcgenekeepr from pedkindraw's
  session. nprcgenekeepr runs its own sessions beside these (S1187 committed during S40).
- **"Dependent on pedkindraw" has a CRAN catch:** a CRAN package may not Import a package that is not on CRAN or
  Bioconductor, so nprcgenekeepr cannot depend on pedkindraw before pedkindraw is accepted (that is why Mark's point
  3 says "once pedkindraw is accepted by CRAN (not a certain outcome)"). A `Suggests` or a vendored copy are the
  in-between shapes; check CRAN's policy text before the plan states it (not checked in S40).
- **Gap facts are measured on stated commits:** pedkindraw `2626c16`, kinship2 1.9.6.2, Pedixplorer 1.8.0,
  nprcgenekeepr `ae3491dff`. Rerun `Rscript tools/gapCases.R` (82 s) and the nprcgenekeepr script (its header has the
  commands) before quoting a number that may have moved.
- **The sizes in the gaps document are guesses** (S, M, L); a plan that schedules a gap should size it from the code
  it touches (an inventory), not from those letters.
- **Found on the way, not decided:** a numeric condition column is drawn affected wherever it is not 0, silently, in
  both packages (`methodology/BACKLOG.md:71`); the plan should place it, since fixing it after the release changes
  behaviour.
- **Suite and gates:** the suite takes about 275-300 s here; `quality_ratchet.py --run` read 5/5 at S40's close (0
  unmeasured), but can read the suite gate unmeasured if one run passes 300 s (`methodology/BACKLOG.md:125`). A planning
  session changes no code, but its close-out still cites a gate run.
- **Probing traps (plan dragons 27-28):** load kinship2, Pedixplorer and pedkindraw together and an unqualified
  `kinship()` is not pedkindraw's (call through `::`); Pedixplorer writes `Rplots.pdf` into the working folder
  unless a `pdf(NULL)` device is open. To run nprcgenekeepr's code: `git archive <commit> DESCRIPTION NAMESPACE R
  data inst` into the scratchpad, then from a shell (not from R inside pedkindraw's renv, Learning 5) `cd
  ../nprcgenekeepr && Rscript <script> <archive> <commit>`.
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (learnings go to the plan's dragons and these notes);
  `methodology/HANDOFFS.md` 184,664 B after S40's receipt against its 196,608 B trim trigger (an estimate: about
  two more sessions; `python3 methodology/methodology_trim.py --file methodology/HANDOFFS.md --check`); shell traps:
  `rm -rf` with shell variables is refused (use `"${S:?}"`), never pipe chromote into `head`, zsh's `time` prints
  `total`; `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/cran-submission-plan.md:6` (status), `:497` (17f), `:505` (17f's Done), `:519` (17f2, Mark's words),
  `:541` (17g), `:653` (D4), `:675` (session map's 17f2 row), `:777`-`:782` (dragons 27-28).
- `docs/planning/standalone-pedigree-package-plan.md:59` (Next), `:220` (R96), `:970` (Done 17f), `:979` ("Later,
  optional"), and R8 in its rulings table (`grep -n '^| R8 '`).
- `docs/research/pedkindraw-gaps-2026-11-18.md:30` (summary), `:61` (1.1, effect on use), `:339` (6, ruled and not
  gaps), `:417` (9, found on the way), `:435` (10, nprcgenekeepr); its two records beside it (`-cases.txt`,
  `-nprcgenekeepr.txt`).
- `tools/gapCases.R:22` (time limits), `:762` (`runOne()`, the `pdf(NULL)` device), `:776` (`runAll()`);
  `tools/gapCasesNprcgenekeepr.R` (header: how to run it on an archive of a commit).
- `methodology/BACKLOG.md:58` (17f2, Mark's words), `:71` (numeric condition column), `:26`/`:37`/`:47` (the R81,
  R94, R95 ports, BLOCKED on nprcgenekeepr); `DIVERGENCE.md`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S39's entries were removed in S3-S40 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 41 Did
**Deliverable:** Phase 17f2, the plan for closing the gaps in pedkindraw and nprcgenekeepr and coordinating the two
repositories (`docs/planning/cran-submission-plan.md:519`; R96; `methodology/BACKLOG.md:58`): a plan under
`docs/planning/`, each of Mark's decisions by picker recorded as a ruling; a framing picker on its outline first.
A planning session, TDD phase none, no package code; nprcgenekeepr read, not changed (R8) (IN PROGRESS)
**Started:** 2026-11-18 11:14 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Plan 17f2 (Recommended)"
(orient picker)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 39 Handoff Evaluation (by Session 40)
**Score: 9/10.**
- **What helped:** every count and starting point held: the drift tool (91/14/0), nprcgenekeepr's log (the same 4
  commits), pedkindraw's 31 exports, the kinship2 gap table and the comparison study's section 10 as starting points,
  Learning 19's one-process-per-case recipe (used as written: GNU `timeout` is on this Mac), the shell traps (no
  `rm -rf` with variables needed), and "nothing of S39's left running" (its last runs were all `success`).
- **What was missing:** nothing a reader could have known; that pedkindraw's `kinship()` fills a dense matrix before
  making it sparse (R3's cost) and that Pedixplorer writes `Rplots.pdf` were found in S40.
- **What was wrong:** nothing found.
- **ROI:** high.

### What Session 40 Did
**Deliverable:** Phase 17f, the gaps document, DONE; D4 put to a planning session by Mark (R96).
**Started:** 2026-11-17 23:58 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Write the gaps list
(Recommended)" (orient); "Full outline + case script (Recommended)" (framing); at the D4 picker he asked to clarify,
asked "where can I see the gaps you found and their implications to use?" and "which of these gaps are in
nprcgenekeepr?", then directed the planning session (R96, his words above) and added that pausing one repository is
acceptable.
**Commits:** claim `2626c16` (pushed with S39's close-out 1 and 2: CI `44247956305` 5/5 `success`, site
`44247956292`, Pages `44248288466`); the document, `tools/gapCases.R` and its record `c267ffd`; sections 1.1 (effect
on use) and 10 (nprcgenekeepr), `tools/gapCasesNprcgenekeepr.R` and its record `210a901`; close-out 1 `24d3306`
(R96, Phase 17f2, D4, the session map, dragons 27-28, ROADMAP, BACKLOG); close-out 2 (these notes, the receipt, the
ledger). The last four pushed together at close.
**Measured:** 20 cases, each in its own R process under GNU `timeout`, all exit 0 in 82 s (load 6.7), every value the
document quotes checked against the record by machine; nprcgenekeepr's side on its own code and renv (`ae3491dff`,
24 checks); the drift tool 91/14/0.
**Self-assessment: 8/10.**
+ Every claim in the document is a measured value on a stated commit, with the script and record committed; the
  framing picker was answered at once; the claim-to-source audit was mechanical; the run was repeated after the
  device fix and compared line for line.
- A scratch probe that attached all three packages called the wrong `kinship()`, and its false "removing animals is
  not a gap" reached the framing picker's outline; the case script caught it before the document (dragon 27). A run
  left `Rplots.pdf` in the tree (caught before any commit; dragon 28). A commit message said 26 checks for 24
  (amended before the push). The D4 picker came before the document said what each gap means for a user and whether
  nprcgenekeepr shares it; Mark needed both to decide (a feedback memory now records it).
**Learnings:** plan dragons 27-28; a feedback memory (decision documents carry the effect on users and
nprcgenekeepr's side); no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S40 entries (the session, D4's direction, push 1, push 2).
