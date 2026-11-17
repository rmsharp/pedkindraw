# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission, is under way (`docs/planning/cran-submission-plan.md`). 17a DONE (S33),
17b DONE (S34), 17c1 DONE (S35: `kinship(id, sire, dam, pdepth, ...)` and its `pdepth` check). Next: **Phase
17c2, the pedigree argument is `ped`, strict TDD** (`docs/planning/cran-submission-plan.md:416`; R88 at `:205`;
`methodology/BACKLOG.md:11`): `getParents(ped, ids)` and `getOffspring(ped, ids)` (were `pedSourceDf`),
`getIdsWithOneParent(ped)` (was `uPed`), `addBackSecondParents(trimmedPed, ped)` (was `uPed`). Names only; the
positions stay, so no caller changes (S34: 24 calls, none by name). Four `DIVERGENCE.md` rows. 17c3 (the pedigree
first, R89) follows (R93).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker** (4 options at most, "Other" for hold): 17c2 (recommended: the plan's order, R93); 17d or 17e,
the drawing fixes, which need 17b only (none of the R87-R89 functions is in `R/drawPedigreeDiagram.R`).
**Session boundary:** one deliverable. **Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 91 functions, **6** differ, all with rows: `kinship()` is the 6th); nprcgenekeepr's
   log on every copied file: `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R)` printed exactly 4 commits at S35 (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`, all already in the copy; nprcgenekeepr at `7806ae72e`). Any other line is a change to
   a copied file: plan section 4.4 and R37.
2. Push S35's two close-out commits (`94024bc` and close-out 2) with the session's first push. They touch
   `docs/planning/`, so **both workflows run** (S34's handoff said a close-out push starts none; its close-out 2 had
   edited the plan).
3. 17c2 before RED (Learnings 15, 17, 18): `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- R/getParents.R
   R/getOffspring.R R/getIdsWithOneParent.R R/addBackSecondParents.R` and their test files (0 lines at S35);
   re-parse the calls to the four (recipe in Gotchas; S34: 24 calls, none naming `pedSourceDf` or `uPed`);
   `git grep -n -w -e pedSourceDf -e uPed -- R man tests tools vignettes README.Rmd` (35 lines in 8 files at S35:
   the 4 R files and their 4 pages, none in tests). **Then run the whole suite against a scratch copy with the
   renames applied** (dragon 18: S35's draft found a test no inventory named). Pre-RED picker: where the
   `expect_named(formals(getIdsWithOneParent), "ped")` test goes, since there is no `test_getIdsWithOneParent.R`
   (in `test_addBackSecondParents.R`, which reaches it, or a new file).
4. RED: in `test_getParents.R`, `test_getOffspring.R`, `test_addBackSecondParents.R` (and the chosen home for
   `getIdsWithOneParent()`), `expect_named(formals(f), ...)` and a call that names the new argument, each equal to
   the call by position; each copied test file's header names the change (Learning 10). GREEN, at most 5 files a
   commit: e.g. GREEN 1 `R/getParents.R` (`:11` `@param`, `:28`-`:33`), `R/getOffspring.R` (`:24`-`:29`; its
   `@param` comes from `@inheritParams getParents`, `:10`), their two pages and two `DIVERGENCE.md` rows; GREEN 2
   `R/getIdsWithOneParent.R` (`:10`, `:27`-`:29`), `R/addBackSecondParents.R` (`:11`-`:16`, `:38`-`:55`; its call
   `getIdsWithOneParent(uPed)` by position stays one), their pages and two rows. Each file's header `:4` ("Changes:
   help text only") is rewritten. Then 17c's DONE list (plan `:420`), the fidelity tool and `R CMD check` included.

### Gotchas
- **Count what a change breaks by parsing (plan dragon 16).** Parse `R/`, `tests/`, `tools/`; `tools::Rd2ex()` each
  `man/*.Rd`; `knitr::purl(documentation = 0)` the README and vignettes. Walk each tree by index and skip the empty
  argument, or R stops "argument is missing" (S35 hit it again): `x <- as.list(e); for (k in seq_along(x)) { if
  (is.name(x[[k]]) && !nzchar(as.character(x[[k]]))) next; walk(x[[k]]) }`. Record `pkg::` before stripping it;
  read the fidelity tool's `fn("name")(...)` calls by hand
  (`grep -n 'fn("' tools/compareResultsWithNprcgenekeepr.R`).
- **A scratch copy runs without touching renv's project:** `git archive HEAD | tar -x -C <scratch>`, then from the
  scratch folder `env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib> Rscript --no-init-file ...` (`<lib>` is
  `renv::paths$library()`; `--no-init-file` skips the copy's `.Rprofile`, which would start renv there). S35 ran
  the whole suite this way against the drafted check (4 min) and found `test_maleLeftDuplicateMate.R`.
- **Old fixtures can be wrong:** `tests/testthat/fixtures/smallPed.rds`'s `gen` is wrong in 8 of 17 animals
  (founders B, E, J, K, N at 1 and O at 2, not 0; L and M in their sire's generation). Only
  `test_maleLeftDuplicateMate.R` now computes it; 12 other test and helper files name `smallPed`, and with the
  check in place none of them stops (S35's suite). A port of R92 to nprcgenekeepr needs the same line there.
- **Render the README after installing the tree** (the README's own comment): `R CMD INSTALL -l <lib> .`, then
  `rmarkdown::render("README.Rmd")`; renv's installed copy predated `checkPedigree()` and the render stopped. Count
  exports on `pkgload::load_all()`, not on the installed copy (it reported 1 name shared with kinship2, not 6).
- **`kinship()` now stops what was silently wrong before:** kinship2's call form with numeric sex codes, an `NA`
  id (every unknown parent matched it), a character `pdepth` past 9 ("10" < "9" as text). A factor `pdepth` stops
  as before ("'max' not meaningful for factors") but now warns twice first. `makePedigreeMatingLayout()` stops the
  same way on a `gen` column out of order, unless given a `kinshipMatrix`.
- **The sire/dam words gate** (`user-facing-sire-dam-words`) reads `R/`, `man/`, the README, NEWS and vignettes for
  husband/wife. "father"/"mother" are outside it, but S23's ruling covers them: `R/kinship.R:66`'s copied help
  still says a male's X comes "from his mother"; `kinship()`'s locals `father`/`mother` stay (Mark's S35 REFACTOR
  pick: smaller port).
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (S23-S35 added nothing: learnings go here and in the plan's
  dragons, 18-19 from S35); no English hunspell dictionary on this Mac; R's own library holds 7 of the 9 Suggests;
  count copied files by the header's capitalized "Copied from nprcgenekeepr" (79); the suite gate's 300 s limit
  fails under load and counts warnings, not failures (tally "0 failed" by hand); the copied
  `test_positionMatingUnitForest.R` prints three `message()` lines (17l); `pedkindraw.Rproj` untracked, Mark's.
- **Times on this Mac (S35):** suite 248-258 s; `R CMD build` plus `check --as-cran` 184 s (tests 111 s); the
  fidelity tool 213 s; `quality_ratchet.py --run` about 5 min; CI 15-20 min; the site workflow 3 min.

### Key files
- `docs/planning/cran-submission-plan.md:6` (status), `:168` (2.4), `:194` ("Decided"; table `:202`, R88 `:205`),
  `:212` (the 9 `DIVERGENCE.md` rows), `:387` (17c; 17c1 `:395`, its Done `:404`, 17c2 `:416`, 17c3 `:418`, DONE
  `:420`), `:573` (8, session map; 17c2 `:580`), `:605` (9, dragons; 18 `:646`, 19 `:649`).
- `docs/planning/standalone-pedigree-package-plan.md:54` (Next), `:207` (R88), `:884` (17c2 row), `:922` (Done
  17c1).
- `docs/planning/pedkindraw-api-contract.md:119`, `:120`, `:124`, `:126` (the four 17c2 signatures, old names
  beside them), `:289` (section 6, S34).
- `R/getParents.R:4`, `:11`, `:28`; `R/getOffspring.R:4`, `:10`, `:24`; `R/getIdsWithOneParent.R:4`, `:10`, `:27`;
  `R/addBackSecondParents.R:4`, `:16`, `:38`, `:40`; `tests/testthat/test_getParents.R`, `test_getOffspring.R`,
  `test_addBackSecondParents.R`; `DIVERGENCE.md:19` (the `kinship()` row, the newest); `methodology/BACKLOG.md:11`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S34's entries were removed in S3-S35 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 34 Handoff Evaluation (by Session 35)
**Score: 8/10.**
- **What helped:** steps 1 and 3 ran as written: the drift tool (91/5/0), nprcgenekeepr's log (the same 4
  commits), the `kinship(` parse (43 calls, 1 by name, exactly). Its RED and GREEN line citations were right at
  `2fd19e9` (`R/kinship.R:101`, `:115`, `:134`-`:136`, `:144`; `test_kinshipMemoryEquivalence.R:74`-`:76`;
  `DIVERGENCE.md:12`). The two placement facts held: the check after every input check kept the fidelity tool's
  `kinshipErrors` identical, and every other fidelity case passes `findGeneration()`'s numbers. The typed-case list
  was the right list, and "time the kinship2 cases" turned a feared cost into a measured 0.19 s.
- **What was missing:** that `makePedigreeMatingLayout()` passes its own `gen` to `kinship()`
  (`R/makePedigreeDiagramData.R:1863`), so the check reaches the layout's tests: S34's parse counted that call but
  not what it passes, and `smallPed`'s wrong `gen` stopped `test_maleLeftDuplicateMate.R`, a 10th file. Also that
  `minnbreast`'s `sex` is the text "M"/"F", which must become 1/2 before the silent wrong answer shows (the note
  said only to code the `NA` as 3; S35's first run passed text, which HEAD already refuses).
- **What was wrong:** "push S34's close-out 2 (methodology only: no run starts)": that commit edited
  `docs/planning/cran-submission-plan.md`, so CI and the site ran (both passed).
- **ROI:** high.

### What Session 35 Did
**Deliverable:** Phase 17c1, `kinship()` takes `sire` and `dam` and refuses generation numbers out of order (R87,
R91, R92), strict TDD.
**Started:** 2026-11-17 14:21 CST · **Model:** Claude Opus 5.5 · **Mark's picks**, each Claude's recommendation at
the first asking: "17c1: kinship() (Recommended)" (orient); pre-RED: the message "With the hint", "Compute them"
(`smallPed`'s `gen` in the one layout test), "Add it now" (NEWS); the gates "Yes, proceed to RED", "Yes, proceed to
GREEN"; "Skip REFACTOR".
**Commits:** claim `4fc0e1a` (pushed with S34's close-out 2: CI `44168447176` 5/5, site success); RED `3faf597`;
GREEN 1 `9e72121` (`R/kinship.R`, `man/kinship.Rd`, `DIVERGENCE.md`); GREEN 2 `5adcba9` (README, NEWS); these three
pushed (CI `44178145615` 5/5 `success` at the first attempt, 16 min; site `44178145626` `success`); close-out 1
`94024bc` (both plans, the contract, ROADMAP, BACKLOG) and close-out 2 (these notes, the receipt, the ledger),
neither pushed.
**Measured before RED** (scratch copy with a drafted check): every expected value; HEAD silently wrong in 425 of
`minnbreast`'s 426 families and both `sample.ped` families, the draft stopping all 428 and passing
`findGeneration()`'s numbers in all 428 (0.19 s); the 12 fidelity pedigrees pass in every `kinship()` form the tool
uses; the whole suite against the draft: one file errored (`smallPed`); 300 random shuffled pedigrees pass with
`findGeneration()`'s numbers; a cycle never reaches the check (`findGeneration()` leaves it `NA`).
**Verified:** RED 9 blocks failing, exactly the planned, WARN 0; GREEN suite 54 files, 693 blocks, 0 failed, 0
errors, WARN 0; lint 0; roxygen unchanged on a re-run; the new check's 10 statements all reached (`R/kinship.R` 97
of 98); drift tool 91, 6 differ, 0 without a row; fidelity tool exit 0, 600 of 600 identical, 132 matrices, largest
difference 0; `R CMD check --as-cran` 1 NOTE, R16's (Maintainer, New submission); README rendered twice the same;
`quality_ratchet.py --run` 5/5 pass, 0 fail, 0 unmeasured, results `5ddbb5b1aeb3`, manifest `01151c525b8a`; the 43
`file:line` citations in these notes and the receipt checked by machine against their text after the last edit.
**Self-assessment: 8/10.**
+ Measured before each gate, and the whole-suite run against a draft found what no inventory named (a wrong
  fixture reaching `kinship()` through the layout), before RED rather than in GREEN. Running the drafted tests
  against both the draft and HEAD caught one wrong expected value (a "founders" case that kept a dam). Read
  kinship2's and Pedixplorer's methods before the help described them: R91's wording was half the story. Every
  pick at the first asking.
- Three slips, each caught before a commit: the first `minnbreast` run passed the text sex codes; the first GREEN
  help said `asPedFrame()` returns the data frame (it returns a list), fixed while the suite ran (a roxygen comment
  only; the slice's tests re-run after); the plan's Done line first said "9 files" and listed 10. The parse hit the
  empty-argument trap the handoff had named.
**Learnings:** no `CLAUDE.md` row (over budget); the plan's dragons 18 (run the suite against a draft of a new
check) and 19 (read the other package's methods; count exports on the loaded source); the Gotchas above.
**Ledger:** `CHANGELOG.md` S35 entries (the session, push 1, push 2).
