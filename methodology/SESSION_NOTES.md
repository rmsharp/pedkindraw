# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G7 DONE (S42-S48).
**G8 DONE (S49)**: `findGeneration(id, sire, dam, alignMates = FALSE)`; when `TRUE`, `.alignGenerations()` aligns
the generations by a rule measured from kinship2's `kindepth(align = TRUE)`, ties broken by id so row order never
changes the answer (R123-R124; copied code changed, a `DIVERGENCE.md` row at the switch).
**Next: Phase G9**, a documented example: the drawing with the animals `shrinkPedigree()` removed marked, from
`idTrimmed` (gap B7; G9's row at `docs/planning/gaps-and-shared-code-plan.md:365`; gaps document
`docs/research/pedkindraw-gaps-2026-11-18.md:248`; `methodology/BACKLOG.md:26`). Its pre-RED choice: a help example
or a vignette section. Documentation, but strict TDD still governs (`CLAUDE.md`): what test the example gets is
part of the pre-RED picker (Gotchas).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G9 (recommended: R97's order). Also READY: the `smallPed` fixture (`methodology/BACKLOG.md:54`),
rewording `DIVERGENCE.md`'s 14 older rows to "at the switch" (`methodology/BACKLOG.md:36`, documentation only) and the
"Ready, small" items (list all seven by name in the picker's fourth option, as S48 and S49 did).
**Session boundary:** G9 only (1 session, a guess). Close out when its DONE (plan section 5.1, "Every G phase" and
G9's row) is met.
**Priority:** HIGH (G10-G17 and 17g follow it).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G8 added `findGeneration()`'s row);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all
   of S49; a new commit there to a copied file departs from R101: report it to Mark.
2. Check S49's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md` and `tools/` changed). Expect the
   Ubuntu R-devel job to fail again installing Bioconductor's S4Vectors (S48's run did, `44481480808`; the
   backlog's CI item, `methodology/BACKLOG.md:152`): not pedkindraw's code. Any other failure is real.
3. **G9, measure before the pre-RED picker (Learning 17):** (a) `Rscript tools/gapCases.R shrinkPicture`
   (`tools/gapCases.R:508`: kinship2's `plot.pedigree.shrink()` on sample family 1 shrunk to 16 bits); (b) what
   `shrinkPedigree()` returns (`R/shrinkPedigree.R:234`; its example at `:218`; `idTrimmed` the ids removed) and
   how a drawing marks animals today: a condition column read by `makePedigreeMatingLayout()` and drawn by
   `drawPedigreeDiagram()` (G1, R102-R105: a condition column must be `TRUE`, `FALSE` or `NA`, 0/1 accepted);
   (c) where an example would live: `?shrinkPedigree`'s example, or a section of `vignettes/pedkindraw.Rmd`
   (`:191`-`:209` already shrink a pedigree); (d) what "the removed animals are marked in the drawing" is checked
   by: headless Chrome reading vis.js (plan dragon 25 of `docs/planning/cran-submission-plan.md`), a test on the
   layout's nodes, or the example only running; time each option; (e) the picker: help example or vignette
   section, and the test it gets.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase"): suite 0 failed, WARN 0; lint 0;
   roxygen stable; covr on any new statement; `R CMD check --as-cran` R16's NOTE only (a vignette section adds
   build time: dragon 4, check time); a NEWS bullet; no copied code is expected to change (drift stays 91/21/0),
   fidelity 600 of 600.

### Gotchas
- **A vignette or example that draws needs chromote only where it is read in a browser**; `R CMD check` runs
  examples and builds vignettes without Chrome. Keep any browser check in the tests, with `skip_on_cran()` and
  `skip_if_no_chrome()` (`tests/testthat/helper-live-render-positions.R:190`), as
  `tests/testthat/test_unknownAffected.R:281`-`:285` does.
- **G8's measuring took most of S49**: a one-sentence description left the whole rule to measure (ten candidate
  rules). G9 has no rule to find, but the same habit applies: run the example and any test on a scratch copy
  first, time them, then picker.
- **Helpers load alphabetically and a later one with the same name wins** (dragon 26): grep
  `'^<name> <- ' tests/testthat/*.R` before naming a helper. `kinship2SampleFamily()` (in
  `helper-findUnrelated.R`) returns a list; take `$ped`.
- **Time a slow or reference version on every fixture before RED** (dragon 27): S49's first draft-test run hit a
  10-minute limit on examplePedigree.
- **Sort text with `method = "radix"`** where the order changes a result (dragon 27): the default follows the
  locale.
- **Pass an environment variable to Rscript before it** (`S="$S" Rscript ...`), and source the test helpers with
  `TESTTHAT` set from inside `tests/testthat` (dragon 21).
- **Run the draft tests on the prototype before RED**: S49's two draft faults showed there (`lacy1989Ped$gen` is
  double, so `expect_identical()` with an integer fails; the helper name clash).
- **Scratch copies:** `git archive HEAD | tar -x -C <dir>`, then `rm -f "${S:?}/<dir>/.Rprofile"`; run with `env -u
  RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`. Do not edit a tree while its suite or check runs (FM
  #29); docs may be edited once `R CMD build` has made the tarball.
- **covr on one test file** (S49's form, about 1 min): `covr::package_coverage(".", type = "none", code =
  'testthat::test_dir("<abs>/tests/testthat", filter = "<name>", package = "pedkindraw", load_package =
  "installed", reporter = "silent")')`, then `as.data.frame()` and count by `filename`.
- **Times** (S49's measures): the suite 4.6-5.0 min; the fidelity tool about 210 s; `R CMD build` and `check
  --as-cran` about 200 s; `quality_ratchet.py --run` about 5 min; the drift tool 1 s.
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (30,795 B; learnings go to the plans' dragons and these
  notes); never pipe chromote or an R script that saves a file into `head`; the shell is zsh (`pipestatus`), and
  the harness blocks `sleep N; cmd`; `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:365` (G9's row), `:364` (G8's, DONE amended by R123), `:553`,
  `:563`, `:568` (dragons 25-27, new in S49).
- `docs/research/pedkindraw-gaps-2026-11-18.md:248` (B7); `tools/gapCases.R:508` (case `shrinkPicture`).
- `R/shrinkPedigree.R:234` (`shrinkPedigree()`), `:218` (its example); `vignettes/pedkindraw.Rmd:191` (shrinking).
- `docs/planning/standalone-pedigree-package-plan.md:70` (Next), `:260`-`:261` (R123-R124), `:1094` (Done G8).
- `docs/planning/cran-submission-plan.md:595` (Done G8).
- G8's code: `R/alignGenerations.R:26` (`.alignGenerations()`), `:68` (`afterParents()`), `:71` (`related()`);
  `R/findGeneration.R:92` (the copied function), `:131` (the call); `DIVERGENCE.md:34` (its row).
- G8's tests: `tests/testthat/test_findGenerationAligned.R`; `tests/testthat/helper-findGenerationAligned.R:14`
  (`alignedGenerationsSlow()`), `:152` (`alignedTypedPeds()`), `:198` (`alignedCheckPeds()`), `:214`
  (`kinship2Aligned()`).
- `methodology/BACKLOG.md:26` (G9-G17), `:36` (rewording `DIVERGENCE.md`), `:54` (smallPed fixture), `:152` (CI).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S48's entries were removed in S3-S49 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 50 Did
**Deliverable:** Phase G9, a documented example marking the animals `shrinkPedigree()` removed (gap B7;
`docs/planning/gaps-and-shared-code-plan.md:365`) (IN PROGRESS)
**Started:** 2026-11-19 09:50 CST · **Model:** Claude Opus 5.5 · Mark's pick "Phase G9 (Recommended)" at the orient picker.
**Status:** Session claimed. Work beginning: measure first (Learning 17), then the pre-RED picker.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 48 Handoff Evaluation (by Session 49)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(d) for G8 was the session's opening plan; every prediction held
  (drift 91/20/0, then 91/21/0 after G8; the same 4 nprcgenekeepr commits; `alignedDepth`'s 6 of 41 and 41 of 41);
  the gotchas on the copied file (its header to rewrite, the `DIVERGENCE.md` row, the fidelity check of the
  default) and on where an added argument is named (help, NEWS, the contract's `:117`; `?pedkindraw` and README
  only if needed) were each right and used as written; the scratch-copy recipe, "run the drafts on the prototype"
  and "environment variable before Rscript" saved reruns. Every cited line held at `fb3c80a`.
- **What was missing:** that kinship2 describes the aligned method in one sentence, with no vignette, so the whole
  rule had to be measured (most of S49); not knowable without reading its help, which the handoff did point to.
  That `kinship2SampleFamily()` already exists as a helper.
- **What was wrong:** "kinship2 refuses one-parent pedigrees and `lacy1989Ped` (dragon 23)": that is its
  `pedigree()`; `kindepth()` on vectors returned on all 8 fixture pedigrees and 96 of 100 one-parent random ones.
- **ROI:** high.

### What Session 49 Did
**Deliverable:** Phase G8 DONE: `findGeneration(id, sire, dam, alignMates = FALSE)` aligns the generations when
`TRUE`, by a rule measured from kinship2's `kindepth(align = TRUE)`, row order never changing the answer
(R123-R124).
**Started:** 2026-11-19 02:07 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each Claude's recommendation):**
"Phase G8 (Recommended)" (orient); "Measured rule, ignores row order (Recommended)", "alignMates (Recommended)"
(pre-RED); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No corrections.
**Commits:** claim `e8e8e63`; RED `2f8751f`; GREEN 1 `22e693b` (code, help, man, `DIVERGENCE.md`); GREEN 2
`b40fd85` (NEWS, contract, gap case); REFACTOR `a0b6956`; close-out 1 `0842b8f`; close-out 2 (these notes, the
receipt, the ledger). All pushed at close.
**Measured:** kinship2's help states the aim only, so its rule was found from its results (code never read, R11):
26 small pedigrees built and the fixtures' differences shrunk mechanically, through ten candidate rules. The rule
picked: equal to kinship2 on `sample.ped` families 1 and 2, lacy1989Ped, smallPed, 7 of 8 typed pedigrees, 73 of
100 seeded random ones; 93 of 5,004 animals different on the five larger fixtures; matings left unaligned 721
(kinship2 716, plain 2,036). kinship2's own answer changes with row order on 4 of 8 fixture pedigrees and 54 of 96
one-parent random ones, where it also puts offspring level with or above a parent 443 times and stops on 4.
Speed: 0.14 s on examplePedigree; 0.5, 3.1, 28.3 s on 3,694, 10,000, 30,000 random animals (kinship2 12.7 s,
254 s, over 300 s). Drafts on the prototype: 16 tests, 1,093 checks, 0 failed (two draft faults fixed there).
RED 16 of 16 fail on "unused argument". Final, after the REFACTOR: suite 66 files, 816 tests, 0 failed, 0
skipped, 0 warnings (4.9 min); lint 0; roxygen stable; covr 103 of 103 (`R/alignGenerations.R`), 23 of 23
(`R/findGeneration.R`); drift 91/21/0; fidelity 600 of 600, kinship difference 0; `R CMD check --as-cran` 1
NOTE (R16's); the REFACTOR's before/after record `identical()` on 215 pedigrees.
**Self-assessment: 8/10.**
+ Every pick and gate came first time with no correction; each picker carried measured counts, including where
  kinship2 itself is flawed (row order, one-parent offspring, its own stop message); the code is checked against
  an independent slow version and kinship2 and is 25 to 80 times faster than kinship2 on large random pedigrees;
  every DONE check ran on the final tree; two claims were corrected before commit (5,069 to 5,004 animals; the
  wider ancestor block was replaced after a constructed case, E-k, showed kinship2 moves only mates without
  parents).
- The measuring phase was long: ten candidate rules, two shrinks that landed on side discrepancies, and a speed
  run of the slow prototype that blocked for 15 minutes; the first draft-test run hit a 10-minute limit because the
  slow version was not timed on examplePedigree first; a sort-key bug in the production prototype (caught by
  comparison with the slow rule) and two draft-test faults, all before RED; one duplicate background watcher.
**Learnings:** the gaps plan's dragons 25-27; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S49 entries (the session, push 1).
