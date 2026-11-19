# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G6 DONE (S42-S47).
**G7 DONE (S48)**: a new export, `removeAnimals(ped, ids)`, removes the listed animals' rows and sets to `NA` each
sire or dam entry naming one of them, the offspring keeping its other parent; an id found nowhere is ignored; listed
under "Trimming and shrinking" (R120-R122).
**Next: Phase G8**, aligned generations in `findGeneration()` (gap C2; G8's row at
`docs/planning/gaps-and-shared-code-plan.md:363`; gaps document `docs/research/pedkindraw-gaps-2026-11-18.md:275`;
`methodology/BACKLOG.md:26`). Strict TDD. **Unlike G5-G7, it changes copied code** (`R/findGeneration.R`, copied
unchanged but for help text), so the drift rule applies (Gotchas).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G8 (recommended: R97's order). Also READY: the `smallPed` fixture (`methodology/BACKLOG.md:53`),
rewording `DIVERGENCE.md`'s 14 older rows to "at the switch" (`methodology/BACKLOG.md:35`, documentation only) and the
"Ready, small" items (list all seven by name in the picker's fourth option, as S48 did).
**Session boundary:** G8 only (1 session, a guess). Close out when its DONE (plan section 5.1, "Every G phase" and
G8's row) is met.
**Priority:** HIGH (G9-G17 and 17g follow it).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 20 differ, 0 without a row**: G7 copied nothing); nprcgenekeepr's log
   on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S48; a new
   commit there to a copied file departs from R101: report it to Mark.
2. Check S48's push finished: both workflows (`R/`, `man/`, `tests/`, `NEWS.md`, `README.md`, `_pkgdown.yml`
   and `tools/` changed; the site workflow is the first real `pkgdown` check of the `removeAnimals` entry).
3. **G8, measure before the pre-RED picker (Learning 17):** (a) `Rscript tools/gapCases.R alignedDepth`
   (`tools/gapCases.R:555`; S48 read: kinship2's `kindepth(align = TRUE)` differs from plain in 6 of 41 animals of
   sample family 1, and `findGeneration()` equals kinship2's plain numbers in 41 of 41); (b) R11
   (`docs/planning/standalone-pedigree-package-plan.md:146`): the aligned numbers are written from the method
   kinship2 **describes** (its help and documentation), not from its code (kinship2 is GPL); read
   `?kinship2::kindepth` (arguments `id`, `dad.id`, `mom.id`, `align`) and Pedixplorer 1.8.0's `kindepth()`
   (`align_parents = FALSE`; methods on `Pedigree`, `Ped` and `character_OR_integer`, the last taking `obj`,
   `dadid`, `momid`); (c) a prototype run against kinship2's
   `kindepth(align = TRUE)` on sample family 1, the fixture pedigrees and seeded random ones, each in `tryCatch()`
   under a time limit (Learning 19), with a slow version from the described rule if one can be written (Learning
   20); kinship2 refuses one-parent pedigrees and `lacy1989Ped` (dragon 23), so floors on the number compared;
   (d) the picker: the argument's name (`align = FALSE` is kinship2's), and anything the measures find that the
   method leaves open.
4. RED, GREEN, REFACTOR by the gates. DONE also needs, being copied code: a `DIVERGENCE.md` row for
   `findGeneration()` marked "at the switch" (R98), the drift tool then **91/21/0**, and fidelity **600 of 600**
   with the default unchanged. `R CMD check --as-cran` from a scratch folder after the last change.

### Gotchas
- **G8 changes a copied file**: `R/findGeneration.R:48`, its header says "help text only; the function's code is
  unchanged", which GREEN must rewrite to name the change (as `R/trimPedigree.R`'s header does); a `DIVERGENCE.md`
  row (`DIVERGENCE.md:12` is the table head; rows name the pedkindraw and nprcgenekeepr commits and why). The
  copied tests `tests/testthat/test_findGeneration.R` stay as copied; new tests go in a new file or in a section
  the header lists (Learning 13). `findGeneration()` feeds the layout, `kinship()` callers and the vignettes, so
  its default must stay exactly as it is (fidelity 600 of 600 is the check).
- **An added argument is named in fewer places than a new export**: its help page, NEWS, the contract's row
  (`docs/planning/pedkindraw-api-contract.md:117`, section 4.1, copied exports), `?pedkindraw` only if its
  sentence (`R/pedkindraw-package.R:19`) should say so; README (`README.Rmd:161`) only if its bullet changes
  (render from a scratch copy, dragon 19, which worked as written in S48).
- **kinship2 and Pedixplorer refuse input in their own ways** (dragons 23-24, new in S48): kinship2's
  `pedigree()` stops on one known parent and wants one sex value per animal (`sexNumbers(ped)` in
  `tests/testthat/helper-removeAnimals.R:136` gives 3 for a pedigree without `sex`); Pedixplorer's `Pedigree()`
  returns a data frame with an `error` column instead of stopping, with a warning: check `is.data.frame()`, and
  muffle only named warnings (`quietPedixplorer()`, `helper-removeAnimals.R:148`).
- **Pass an environment variable to Rscript before it** (`S="$S" Rscript -e ...`): S48 still lost one run to the
  form after the script, which R reads as an argument.
- **Source the test helpers with `TESTTHAT` set and stay in `tests/testthat`** (dragon 21): S48's first measuring
  run stopped because it `setwd()` back before calling `qcdRhesusPed()`, which reads its fixture by a relative
  path.
- **Run the draft tests on the prototype before RED**: S48's four draft faults all showed there, none in the
  repository (an `ifelse(..., NA)` returning logical where text was compared, `rbind()` giving character row
  names, one sex value for kinship2, Pedixplorer's warnings).
- **pkgdown is not in renv's library**: compare the help topics with `_pkgdown.yml`'s entries, both ways empty:
  `comm -3 <(grep -h '^\\name{' man/*.Rd | sed 's/\\name{\(.*\)}/\1/' | sort) <(sed -n '/^reference:/,$p'
  _pkgdown.yml | grep '^  - ' | sed 's/^  - //' | sort)`.
- **Scratch copies:** `git archive HEAD | tar -x -C <dir>` (or `git ls-files -z | xargs -0 tar -cf - | tar -xf - -C
  <dir>` to include uncommitted edits), then `rm -f "${S:?}/<dir>/.Rprofile"`; run with `env -u RENV_PROJECT
  R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`. Do not edit a tree while its suite or check runs (FM #29).
- **Times** (S48's measures): the suite 4.4-4.7 min, alone or beside the fidelity tool and `R CMD check`; the
  fidelity tool 210 s; `R CMD build` and `check --as-cran` together about 200 s (S46's "about 8 min" no longer
  holds); covr on one test file about 1 min; `quality_ratchet.py --run` about 5 min; the drift tool 1 s.
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (learnings go to the plans' dragons and these notes); never
  pipe chromote or an R script that saves a file into `head`; the shell is zsh (`pipestatus`), and the harness
  blocks `sleep N; cmd`; `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:363` (G8's row), `:536`, `:545` (dragons 23-24, new in S48).
- `docs/research/pedkindraw-gaps-2026-11-18.md:275` (C2); `tools/gapCases.R:555` (case `alignedDepth`).
- `R/findGeneration.R:48` (`findGeneration()`, copied); `docs/planning/pedkindraw-api-contract.md:117` (its row).
- `docs/planning/standalone-pedigree-package-plan.md:69` (Next), `:146` (R11), `:256`-`:258` (R120-R122), `:1080`
  (Done G7).
- `docs/planning/cran-submission-plan.md:591` (Done G7).
- G7's code: `R/removeAnimals.R:57` (`removeAnimals()`), `R/checkPedigree.R:149` (`.checkIds()`, shared with
  `countOffspring()`); `tests/testthat/helper-removeAnimals.R:72` (`removeCheckPeds()`, 7 fixture and 100 seeded
  pedigrees with both parents or neither), `:101` (`withMates()`).
- `methodology/BACKLOG.md:26` (G8-G17), `:35` (rewording `DIVERGENCE.md`), `:53` (smallPed fixture).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S47's entries were removed in S3-S48 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 47 Handoff Evaluation (by Session 48)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(d) for G7 was the session's plan, and its picker items (one link or
  both, the name, what it returns, the section) became the pre-RED picker's four; every cited line held at
  `2ab6f0f` (`R/removeUnknownAnimals.R:32`, `R/trimPedigree.R:60`, `R/addParents.R:34`, `R/pedkindraw-package.R:18`
  and `:33`, `R/getMatings.R:40`, the helper's `:63`, the backlog's `:26`, `:35`, `:53`, the contract's
  `:184`-`:186`, the plan's `:68` and `:1065`); the drift and nprcgenekeepr predictions were exact (91/20/0, the
  same 4 commits); "six places", dragon 19's README recipe, dragon 21's helper recipe and the `comm` check worked as
  written; the gap case's predicted 0.125 was exact.
- **What was missing:** that pedkindraw's `removeUninformativeFounders()` and nprcgenekeepr's `removeAutoGenIds()`
  already clear only the one link (the picker's strongest evidence, found by grep); that kinship2's
  `pedigree.trim()` stops on nearly every random removal, so its comparison needs removals closed under mates.
- **What was wrong:** "`R CMD check --as-cran` about 8 min" (S46's measure, carried): S48's two runs took 199 s and
  201 s with the build.
- **ROI:** high.

### What Session 48 Did
**Deliverable:** Phase G7 DONE: the new export `removeAnimals(ped, ids)` removes listed animals and clears their
offspring's links to them, each offspring keeping its other parent (R120-R122).
**Started:** 2026-11-19 00:52 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each Claude's recommendation):**
"Phase G7 (Recommended)" (orient); "Clear that parent only (Recommended)", "removeAnimals(ped, ids)
(Recommended)", "Ignore it quietly (Recommended)", "Trimming and shrinking (Recommended)" (pre-RED); "Yes, proceed
to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No corrections.
**Commits:** claim `492ccac`; RED `36c5b4a`; GREEN 1a `afe6554` (code, help, NAMESPACE); GREEN 1b `bca6962`
(`?pedkindraw`, `_pkgdown.yml`); GREEN 2 `3a3e673` (NEWS, README, contract, gap case); REFACTOR `c223f09`
(`.checkIds()`, shared with `countOffspring()`; the tests' `sexNumbers(ped)`); close-out 1 `31ce80a`; close-out 2
(these notes, the receipt, the ledger). All pushed at close.
**Measured:** a prototype of both rules and a slow row-by-row version on 307 pedigrees (the gap case, 7 fixture, 300
seeded random): the slow version agreed with both on 307 of 307, the rules differed on 297; with one link cleared,
no link to a removed animal and no new rowless parent (307 of 307), `kinship()` computes (306 of 306); kinship2
1.9.6.2 built 156 and its `pedigree.trim()` returned on 5 (equal to both rules), stopping on 151; Pedixplorer 1.8.0
refused the 150 one-parent pedigrees and its `del_parents = "one"` equalled the both-cleared rule on 157 of 157;
kinship2's `pedigree.trim("Z")` returns a one-animal `NA` pedigree that is its own parent; 0.014 s for 100,000
animals. The drafts: 13 tests, 668 checks, 0 failed, 0 warnings on the prototype (11 s); RED 13 of 13 error on the
missing function, suite 800 tests 13 failed. Final, after the REFACTOR: suite 65 files, 800 tests, 0 failed, 0
skipped, 0 warnings (4.7 min); lint 0; roxygen stable; covr 7 of 7 (`R/removeAnimals.R`), 10 of 10
(`R/countOffspring.R`), both `.checkIds()` statements; drift 91/20/0; fidelity 600 of 600, kinship difference 0;
`R CMD check --as-cran` 1 NOTE (R16's); the REFACTOR's before/after record `identical()`.
**Self-assessment: 8/10.**
+ Every pick and gate came first time with no correction; each picker option carried measured counts, and the
  existing one-link rule in `removeUninformativeFounders()` and nprcgenekeepr was found and put in the picker;
  kinship2's and Pedixplorer's behaviour was measured on every case before a picker, help page or ruling stated it,
  and two faults recorded (dragons 23-24); the code and help reached the repository byte-identical to the proven
  prototype; every DONE check ran on the final tree; the REFACTOR was proven by a before/after record.
- Four draft faults, all caught on the prototype before RED but each a rerun; the first measuring run stopped on
  dragon 21's own trap (leaving `tests/testthat` before calling a fixture helper); one comparison run was lost to
  the environment-variable-after-the-script trap S47's notes had warned of; dragon 23 needed a correcting edit
  before commit ("seeded" where fixture pedigrees were included) and one claim checked after it was written.
**Learnings:** the gaps plan's dragons 23-24; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S48 entries (the session, the rulings, push 1).
