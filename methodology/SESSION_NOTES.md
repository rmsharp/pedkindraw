# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G9 DONE (S42-S50).
**G10 DONE (S51)**: `makePedigreeMatingLayout()` returns the hints it used as its last element, `hints`: `order` by
row (a founder only where an order hint named it), `mate` the given rows, then the layout's own row for each other
mating of an animal with one or two matings the given rows do not place; passed back, the same layout (R127-R128).
One session, not the plan's 2-3.
**Next: Phase G11**, gap C1: a new function that keeps the relatives within k steps of chosen animals, its rule
written from Pedixplorer's help and measured results, as `findUnrelated()`'s was (R52)
(`docs/planning/gaps-and-shared-code-plan.md:369`; gaps document `docs/research/pedkindraw-gaps-2026-11-18.md:262`;
`methodology/BACKLOG.md:26`). Its DONE: case `distanceSubset` keeps 14, 30 and 33 of 41 for k = 1, 2, 3, as
Pedixplorer's `useful_inds()`, or a measured, stated difference; seeded random cases compared (Learnings 19-21).
Pre-RED choices (the row): its name; what "informative" means by default. New code, pedkindraw's own (Pedixplorer's
source not read, R11/R14): no `DIVERGENCE.md` row, the fidelity tool 600 of 600 with no set-aside (an addition), and
the contract's section 4 gains the export. The plan says 2-3 sessions (a guess; G10 took 1).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G11 (recommended: R97's order). Also READY: the `smallPed` fixture (`methodology/BACKLOG.md:52`),
rewording `DIVERGENCE.md`'s older rows to "at the switch" (`methodology/BACKLOG.md:34`, documentation only) and the
"Ready, small" items (`methodology/BACKLOG.md:112`; name all seven in the picker's fourth option, as S48-S51 did).
**Session boundary:** one session of G11 (it may take 2-3). Close out at a clean phase boundary (after RED, or after
GREEN and its checks), never mid-phase.
**Priority:** HIGH (G12-G17 and 17g follow it).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G10's helpers are pedkindraw's own);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of
   S51; a new commit there to a copied file departs from R101: report it to Mark.
2. Check S51's push: both workflows run (`R/`, `man/`, `tests/`, `vignettes/`, `NEWS.md` and `tools/` changed).
   Expect the Ubuntu R-devel job to fail again installing Bioconductor's S4Vectors 0.50.3 (S50's run `44565557027`
   did, as S49's: `conformMethod` error, "lazy loading failed"; `methodology/BACKLOG.md:152`): not pedkindraw's code.
   Any other failure is real.
3. **G11, measure before the pre-RED picker (Learnings 17, 19-21):** (a) `Rscript tools/gapCases.R distanceSubset`
   (`tools/gapCases.R:549`; today: 41 animals, 7 informative (available and affected), `useful_inds()` keeps 14, 30
   and 33 for `max_dist` 1-3; `trimPedigree()` keeps 18, 13 with `removeUninformative = TRUE`); (b) Pedixplorer's help
   pages for `useful_inds()`, `is_informative()` and `min_dist_inf()` (help and results only, not its source); (c)
   `useful_inds()` on typed, fixture and seeded random pedigrees, one process per case under `timeout`, each in
   `tryCatch()`, tallying where it returns, stops or hangs (Learning 19); shrink a case where a prototype differs
   until it is hand-sized (Learning 21); (d) the neighbours a new function sits beside: `trimPedigree()`
   (`R/trimPedigree.R:60`), `getProbandPedigree()`, `getDescendantPedigree()`, and `findUnrelated()`, R52's rule
   written from measurements (`docs/planning/standalone-pedigree-package-plan.md:192`); (e) the picker: the name and
   what "informative" means by default, each option with measured counts.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:336`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4 row for the new export; fidelity 600 of 600 (an addition, no set-aside).

### Gotchas
- **Run the prototype through `R CMD build`, not only the suite, before the RED-to-GREEN gate** (dragon 31, new):
  vignettes check their own words as they are built (`stopifnot()` in hidden chunks); S51 found 4 such checks in
  `vignettes/drawing.Rmd` only at GREEN's `R CMD check`, and needed a picker and a GREEN 3. A scratch copy's
  `R CMD build` takes 15 s. Also run the whole suite on the prototype (it found 3 checks in
  `tests/testthat/test_layoutHintsMate.R`, made RED 2), and grep `vignettes/` as well as `tests/` for the object you
  change.
- **A round trip passes in silence when the thing passed back is missing** (dragon 30, new): assert it first.
- **A floor in a draft test is a guess until run** (S51 wrote 600; the measures were 429 and 447): run the drafts on
  the prototype and on a copy of HEAD before RED, and read RED's errors and warnings too (S51's first HEAD run had
  one of each, from the test's own `seq_len(nrow(NULL))`).
- **zsh stops a script on a glob that matches nothing** (S51): `rm -rf dir/*` on an empty folder ended a launch with
  "no matches found" before anything ran; use `rm -rf dir; mkdir -p dir`.
- **Pedixplorer may need packages renv's library lacks** (`best_hint()` stops for R.utils): run each call in
  `tryCatch()`, and say "stops" in the picker rather than drop it.
- **Carried:** helpers load alphabetically, a later one wins (dragon 26; grep `'^<name> <- '`); time slow versions
  first (dragon 27); wait on a run's own end (dragon 29: `grep -q "cpu .* total$"`); pass an environment variable to
  Rscript before it (dragon 21); integers and doubles; a test of a help example reads it where the help is (dragon
  28). Scratch copies: `git archive HEAD | tar -x -C <dir>`, `rm -f "${S:?}/<dir>/.Rprofile"`, run with
  `env -u RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`; from `tests/testthat` in the repo too (no
  `.Rprofile` there). Do not edit a tree while its suite or check runs (FM #29); docs may be edited once
  `R CMD build` has made the tarball.
- **Times** (S51's measures): the suite 5.0-5.2 min; the fidelity tool 3.5 min; `R CMD build` and `check --as-cran`
  3.7 min; covr (`type = "tests"`) 3.3 min; `quality_ratchet.py --run` 5.4 min; all four at once about 5.5 min; the
  drift tool 1 s; a gap case 3-5 s.
- **The ratchet's suite gate times out** (300 s; the suite 300-317 s): `--run` reads 4/5 with it unmeasured. Name it
  in the receipt as `unmeasured: test-suite-warnings-zero -- by hand: <your suite run>`; raising the limit is the
  backlog's "Ready, small" item (`methodology/BACKLOG.md:114`), a commit of its own.
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (learnings go to the plans' dragons and these notes); never
  pipe chromote or an R script that saves a file into `head`; the shell is zsh (`pipestatus`), and the harness
  blocks `sleep N; cmd`; `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:369` (G11's row), `:368` (G10's, with S51's measure), `:336`
  ("Every G phase"), `:586`, `:590` (dragons 30-31, new in S51).
- `docs/research/pedkindraw-gaps-2026-11-18.md:262` (C1); `tools/gapCases.R:549` (case `distanceSubset`), `:592`
  (`ownHints`, G10's probes).
- `R/trimPedigree.R:60` (`trimPedigree()`); `docs/planning/standalone-pedigree-package-plan.md:192` (R52).
- `docs/planning/standalone-pedigree-package-plan.md:73` (Next), `:267`-`:268` (R127-R128), `:1120` (Done G10);
  `docs/planning/cran-submission-plan.md:605` (Done G10); `docs/planning/pedkindraw-api-contract.md` section 4.
- G10's work: `R/layoutHints.R:450` (`.layoutHintsUsed()`), `:466` (`.layoutHintsUsedOrder()`), `:489`
  (`.layoutHintsUsedMate()`); `R/makePedigreeDiagramData.R` (the two returns, `hints = .layoutHintsUsed(`; the help's
  return value and example); `tests/testthat/test_layoutHintsReturned.R`; `vignettes/drawing.Rmd` (section "Layout
  hints", chunk `ownHints`); `tools/compareResultsWithNprcgenekeepr.R` (`withoutLayoutHints()`); `NEWS.md:73`;
  `DIVERGENCE.md:14` (the layout's row, G10's sentence).
- `methodology/BACKLOG.md:26` (G11-G17), `:34` (rewording `DIVERGENCE.md`), `:52` (smallPed fixture), `:112`
  ("Ready, small"), `:114` (the suite gate's time limit), `:152` (CI).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S50's entries were removed in S3-S51 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 52 Did
**Deliverable:** Phase G11, a new function keeping the relatives within k steps of chosen animals (gap C1;
`docs/planning/gaps-and-shared-code-plan.md:369`) (IN PROGRESS)
**Started:** 2026-11-19 13:12 CST · **Model:** Claude Opus 5.5 · Mark's pick "Phase G11 (Recommended)" at the orient picker.
**Status:** Session claimed. Work beginning: measure first (Learnings 17, 19-21), then the pre-RED picker.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 50 Handoff Evaluation (by Session 51)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(f) for G10 was the session's plan, item for item: the gap case, where
  the layout settles its order (`:1904`, `:1941`, `:1980`-`:1981` and the returned list at `:2363` all held at
  `84818f5`), the round trip measured on the fixtures and seeded random pedigrees, each timed, and the set-aside
  pattern (`:835`, `:867`, `:895`). Every prediction held: drift 91/21/0, the same 4 nprcgenekeepr commits, the
  R-devel job failing on S4Vectors, the suite's 5 min and the ratchet's unmeasured suite gate. The scratch-copy
  recipe and "run the drafts on the prototype before RED" were used as written.
- **What was missing:** that existing tests and the drawing vignette compare whole layouts with `identical()` (3
  checks in `test_layoutHintsMate.R`, 4 in `vignettes/drawing.Rmd`), which any new list element breaks; a grep for
  `identical(.*[Ll]ayout` finds both.
- **What was wrong:** "A new element in the layout's list changes every drawing case the fidelity tool compares (600
  results)": a drawing holds no layout list; the element changed 72 of the 600 results, every one a layout result.
  Harmless, since the measure found it.
- **ROI:** high.

### What Session 51 Did
**Deliverable:** Phase G10 DONE: `makePedigreeMatingLayout()` returns the hints it used as `hints`, in the form its
`hints` argument takes; passed back, the same layout (R127-R128).
**Started:** 2026-11-19 10:27 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each Claude's recommendation):**
"Phase G10 (Recommended)" (orient); "hints (Recommended)", "Order and mate rows (Recommended)" (pre-RED); "Yes,
proceed to RED"; "Yes, proceed to GREEN"; "Fix and describe (Recommended)" (the vignette, mid-GREEN); "Yes, REFACTOR
(Recommended)". No corrections.
**Commits:** claim `532fcf8`; RED `932db0c`; RED 2 `4cea006` (3 mate-hint checks compare drawings); GREEN 1
`8cf7429` (code, help, `DIVERGENCE.md`); GREEN 2 `7e7905c` (NEWS, contract, gap case, fidelity set-aside); GREEN 3
`ab09d71` (the drawing vignette); REFACTOR `aef7f7b` (one `match()`); close-out 1 `5d5de21`; close-out 2 (these
notes, the receipt, the ledger). All pushed at close.
**Measured:** on a prototype in a scratch copy, passed back, the same layout (identical to the last digit) for the
order by row with founders left out and mate rows for animals with one or two matings: 10 fixture pedigrees, the
twins pedigree in both line styles, 200 + 3 x 100 seeded random family pedigrees (no hints, a random order, half of
one, some mate rows) and 15 colony cases with given mate rows. Not so: numbers from where animals are drawn (35 of
200), every animal by row (20 of 200), founders by where drawn (34 of 60), a row for every mating (6 of 12 fixture
runs). Cause found by shrinking: re-sorting rows changes which of an animal's matings gets its own node (seed 3's
I17); naming a founder skips `.orderRootSubtrees()`; hinting an animal's 3+ matings changes `.layoutHintSides()`'s
distances. RED: the new file 12 of 12 failing, the copied names check 1; GREEN's suite on the prototype found 3 more
checks (RED 2), and its `R CMD check` the vignette's 4 (GREEN 3). Final, on `aef7f7b`: suite 68 files, 832 tests, 0
failed, 0 skipped, 0 warnings (5.0 min); lint 0; roxygen stable; covr 26 of 26 new statements; drift 91/21/0;
fidelity 600 of 600, 72 results (156 layouts) set aside, kinship difference 0; `R CMD check --as-cran` 1 NOTE
(R16's); the REFACTOR's hints identical on 110 cases (6,214 mate rows); `quality_ratchet.py --run` 4/5 pass,
`test-suite-warnings-zero` unmeasured (its 300 s limit), results `42b564bc4c70`.
**Self-assessment: 8/10.**
+ Every pick and gate came first time with no correction; each picker option carried measured counts, and the
  measure turned up the cause of every failing form before Mark chose; RED was made unable to pass in silence; the
  prototype's whole suite found the 3 other checks before GREEN; the REFACTOR was proved on 110 cases.
- The vignette's build-time checks were found only at GREEN's `R CMD check`, so GREEN gained a file the gate had not
  named and needed a mid-phase picker (dragon 31); the first parallel launch was lost to a zsh glob; two draft floors
  were guesses (600) until run, and the first HEAD run of the draft had an error and a warning from the test itself.
**Learnings:** the gaps plan's dragons 30-31; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S51 entries (the session, the rulings, push 1).
