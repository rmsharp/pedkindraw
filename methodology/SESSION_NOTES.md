# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G5 DONE (S42-S46).
**G6 DONE (S47)**: two new exports, `countOffspring(ped, ids = ped$id)` (each animal's offspring, the animals naming
it as sire or dam, each once) and `getMatings(ped)` (one row per sire and dam with an offspring recorded with both:
`sire`, `dam`, `offspring`), listed under "Pedigree structure" (R117-R119).
**Next: Phase G7**, a function that removes listed animals and clears their offspring's links to them (gap C6; G7's
row at `docs/planning/gaps-and-shared-code-plan.md:362`; gaps document `docs/research/pedkindraw-gaps-2026-11-18.md:322`;
`methodology/BACKLOG.md:26`). Strict TDD. A new export, so the same six places as G5 and G6 (Gotchas).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G7 (recommended: R97's order). Also READY: the `smallPed` fixture (`methodology/BACKLOG.md:53`),
rewording `DIVERGENCE.md`'s 14 older rows to "at the switch" (`methodology/BACKLOG.md:35`, documentation only) and the
"Ready, small" items (list them in the picker's fourth option, as S47 did).
**Session boundary:** G7 only (1 session, a guess). Close out when its DONE (plan section 5.1, "Every G phase" and
G7's row) is met.
**Priority:** HIGH (G8-G17 and 17g follow it).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 20 differ, 0 without a row**: G6 copied nothing); nprcgenekeepr's log
   on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S47; a new
   commit there to a copied file departs from R101: report it to Mark.
2. Check S47's push finished: both workflows (`R/`, `man/`, `tests/`, `NEWS.md`, `README.md`, `_pkgdown.yml`
   changed; the site workflow is the first real `pkgdown` check of the two new reference entries).
3. **G7, measure before the pre-RED picker (Learning 17):** (a) `Rscript tools/gapCases.R removeAnimals`
   (`tools/gapCases.R:714`: A x B -> C, D; C x E -> F, G; D x H -> I; removing C); (b) what pedkindraw already has:
   `removeUnknownAnimals()` (`R/removeUnknownAnimals.R:32`), `trimPedigree()` (`R/trimPedigree.R:60`),
   `addParents()` (`R/addParents.R:34`, puts a removed parent back as a founder) and `checkPedigree()`'s
   `rowlessParents`; (c) Pedixplorer's `subset(del_parents = NULL / "one" / "both")` and kinship2's
   `pedigree.trim()`, each in `tryCatch()` under a time limit (Learning 19), on the typed case, the fixture
   pedigrees and seeded random ones; write a slow version from the definition first and tally against it
   (Learning 20); (d) the picker's choices: G7's row names "clear the one link, or both as Pedixplorer does"
   (pedkindraw allows one known parent; Pedixplorer does not), plus the name, what it returns, and the
   `_pkgdown.yml`/`?pedkindraw` section ("Trimming and shrinking", beside `removeUnknownAnimals()`,
   `R/pedkindraw-package.R:33`, is the likely one). Put each option's measured effect in the picker (kinship of F
   and G: 0.125 with one link cleared, per the gaps document).
4. RED, GREEN, REFACTOR by the gates; then `R CMD check --as-cran` from a scratch folder after the last change;
   fidelity 600 of 600 (a new function changes no case).

### Gotchas
- **A new export is named in six places**: its help page with an example; `_pkgdown.yml`'s reference list;
  `?pedkindraw`'s section; `README.Rmd`'s list and `README.md` re-rendered (the README names all **34** exports now;
  render from a scratch copy, dragon 19, which worked as written in S47); NEWS; the contract's section 4 (G5's and
  G6's rows are in 4.4, `docs/planning/pedkindraw-api-contract.md:184`-`:186`).
- **S46's helper recipe was wrong** (dragon 21): `withr::with_dir("tests/testthat", source_test_helpers("."))` stops
  with "Can't find tests/testthat". Set `Sys.setenv(TESTTHAT = "true")`, `setwd("tests/testthat")`, then
  `testthat::source_test_helpers(".", env = globalenv())`.
- **Pass an environment variable to Rscript before it** (`S="$S" Rscript -e ...`), not after the script: S47 lost
  two runs to `Rscript -e '...' S="$S"`, which R reads as an argument, so `Sys.getenv("S")` was empty.
- **Pedixplorer's counts are doubles and its `num_child()` has faults** (dragon 20); **`$` partially matches** a
  list's names in a scratch tally (dragon 22: it produced a false "failed in 300 of 300" in S47).
- **pkgdown is not in renv's library**: compare the help topics with `_pkgdown.yml`'s entries, both ways empty:
  `comm -3 <(grep -h '^\\name{' man/*.Rd | sed 's/\\name{\(.*\)}/\1/' | sort) <(sed -n '/^reference:/,$p'
  _pkgdown.yml | grep '^  - ' | sed 's/^  - //' | sort)`; the site workflow checks it after the push.
- **A pedigree's sex is often a factor** (dragon 18): 5 of the 6 fixture pedigrees with a `sex` column.
- **Run the draft tests on the prototype before RED**: S47's one draft fault (an integer compared with Pedixplorer's
  doubles) showed there, not in the repository.
- **Scratch copies:** `git archive HEAD | tar -x -C <dir>` (or `git ls-files -z | xargs -0 tar -cf - | tar -xf - -C
  <dir>` to include uncommitted edits), then `rm -f "${S:?}/<dir>/.Rprofile"`; run with `env -u RENV_PROJECT
  R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`. Do not edit a tree while its suite or check runs (FM #29).
- **The shell is zsh** (`pipestatus`); the harness blocks `sleep N; cmd`: use a background command's own notice.
- **Times** (S46's measures; S47 did not time its runs): the suite about 4.5 min alone, about 15 min beside the
  fidelity tool and `R CMD check`; the fidelity tool about 3.5 min; `R CMD check --as-cran` about 8 min;
  `quality_ratchet.py --run` about 5 min; the drift tool 1 s (S47).
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (learnings go to the plans' dragons and these notes); never
  pipe chromote or an R script that saves a file into `head`; `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:362` (G7's row), `:520`, `:527`, `:533` (dragons 20-22, new in S47).
- `docs/research/pedkindraw-gaps-2026-11-18.md:322` (C6); `tools/gapCases.R:714` (case `removeAnimals`).
- `docs/planning/standalone-pedigree-package-plan.md:68` (Next), `:252`-`:254` (R117-R119), `:1065` (Done G6).
- `docs/planning/cran-submission-plan.md:587` (Done G6).
- G6's code: `R/countOffspring.R:42` (`countOffspring()`), `R/getMatings.R:40` (`getMatings()`);
  `tests/testthat/helper-offspringAndMatings.R:63` (`matingCheckPeds()`, the 107 pedigrees the agreement tests use).
- `R/pedkindraw-package.R:18` (Pedigree structure), `:33` (Trimming and shrinking).
- `methodology/BACKLOG.md:26` (G7-G17), `:35` (rewording `DIVERGENCE.md`), `:53` (smallPed fixture).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S46's entries were removed in S3-S47 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 46 Handoff Evaluation (by Session 47)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(d) for G6 was the session's plan, and its picker questions (the names,
  one function or two, what a count counts, the mates' shape, the section) became the pre-RED picker's three; every
  cited line held at `0eda5c1` (`R/getOffspring.R:26`, `R/getParents.R:30`, `R/makePedigreeDiagramData.R:539`,
  `tools/gapCases.R:646`, `R/pedkindraw-package.R:24`, the contract's `:184`, the backlog's `:26`, `:34`, `:52`);
  the drift and nprcgenekeepr predictions were exact (91/20/0, the same 4 commits); "six places" and dragon 19's
  README recipe worked as written; asking which Pedixplorer column the case meant led straight to its faults.
- **What was missing:** that nprcgenekeepr already has `offspringCounts()` and `findOffspring()` (the gaps
  document's line 458 says so; the copy option needed it); that Pedixplorer's `spouse()` reads drawing hints, not
  matings.
- **What was wrong:** the helper recipe, `withr::with_dir("tests/testthat", testthat::source_test_helpers("."))`,
  stops with "Can't find tests/testthat" unless `TESTTHAT` is `"true"` (dragon 21).
- **ROI:** high.

### What Session 47 Did
**Deliverable:** Phase G6 DONE: the new exports `countOffspring()` and `getMatings()` give each animal's offspring
count and the matings (R117-R119).
**Started:** 2026-11-18 23:59 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each Claude's recommendation):**
"Phase G6 (Recommended)" (orient); "countOffspring()+getMatings() (Recommended)", "Its own offspring
(Recommended)", "Pedigree structure (Recommended)" (pre-RED); "Yes, proceed to RED"; "Yes, proceed to GREEN";
"Yes, REFACTOR (Recommended)". No corrections.
**Commits:** claim `a7bb1ed`; RED `8db2330`; GREEN 1a `01c521b` (code, help, NAMESPACE); GREEN 1b `a335745`
(`?pedkindraw`, `_pkgdown.yml`); GREEN 2 `5c426d6` (NEWS, README, contract, gap case); REFACTOR `c42c9ae`
(`matingCheckPeds()`, tests only); close-out 1 `3ef880c`; close-out 2 (these notes, the receipt, the ledger). All
pushed at close.
**Measured:** Pedixplorer 1.8.0's `num_child()` on 311 pedigrees (4 typed, 7 fixture, 300 seeded random), every
call returning: `num_child_dir` the animal's own offspring except in the 4 random pedigrees with no mating (0 for
all), `num_child_tot` the animal's and its mates' offspring (0 with no mate; a negative `num_child_ind` in 286 of
300); kinship2 has no such lookup; nprcgenekeepr's `findOffspring()` counts one kind for an animal recorded as both
sire and dam; the (sire, dam) pairs equal the layout's matings on 307 of 307. A scratch prototype: its slow versions
agreed on 311 of 311; under 0.1 s for 100,000 animals; lint 0; the drafts 20 of 20 pass there (571 checks) and fail
on `HEAD`, each a missing function; its whole suite 787 tests 0 failed. Final, after the REFACTOR: suite 64 files,
787 tests, 0 failed, 0 skipped, 0 warnings; lint 0; roxygen stable; covr 11 of 11 and 8 of 8 statements; drift
91/20/0; fidelity 600 of 600, kinship difference 0; `R CMD check --as-cran` 1 NOTE (R16's); the REFACTOR's 107
pedigrees `identical()` before and after, each test's check count unchanged.
**Self-assessment: 8/10.**
+ Every pick and gate came first time with no correction; each picker option carried measured counts, and
  Pedixplorer's two faults were checked on every case before a picker or ruling stated them (Learning 19); every
  RED value ran on the prototype first; the code, help and NAMESPACE reached the repository byte-identical to the
  proven prototype; every DONE check ran on the final tree; the REFACTOR was proven by a before/after record.
- A scratch tally's `$` partial match gave a false "failed in 300 of 300" (caught by reading it against the counts
  beside it); one draft compared integers with Pedixplorer's doubles (caught on the prototype); the REFACTOR's
  before-record took three runs (an environment variable passed as an argument, twice, and S46's helper recipe).
**Learnings:** the gaps plan's dragons 20-22; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S47 entries (the session, the rulings, push 1).
