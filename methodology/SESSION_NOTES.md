# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission, is under way (`docs/planning/cran-submission-plan.md`). 17a-17b DONE
(S33-S34); 17c DONE in three sessions: 17c1 (S35, `kinship(id, sire, dam, pdepth, ...)`), 17c2 (S36, the pedigree
argument is `ped`), 17c3 (S37: the pedigree first in `getProbandPedigree(ped, probands)`,
`getDescendantPedigree(ped, probands)`, `trimPedigree(ped, probands, ...)`, `hasBothParents(ped, id)`). Next:
**Phase 17d or 17e, a drawing fix in copied code, strict TDD, either order** (plan section 8, `:608`):
17d "Select by id" leaves out the routing points (`docs/planning/cran-submission-plan.md:451`;
`methodology/BACKLOG.md:26`); 17e the legend's "Same animal, again" label fits (`:459`; `methodology/BACKLOG.md:36`).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker** (4 options at most, "Other" for hold): 17d (recommended: one filter, testable without a
browser for its core, Effort S) or 17e (needs a measurement in headless Chrome at two widths before any choice).
**Session boundary:** one deliverable. **Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 91 functions, **14** differ, all with rows: S37 added `getProbandPedigree()`,
   `getDescendantPedigree()`, `trimPedigree()`, `hasBothParents()`); nprcgenekeepr's log on every copied file,
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R)`: exactly 4 commits at S37's close (`4283e3502`, `a85311021`, `392dd347e`, `471589138`, all
   already in the copy). nprcgenekeepr moved 6 times during S37 (`0b7afae51` to `2eb3920b0`, its S1183 close-out and
   S1184 on the Combined ranking), none on a copied file.
2. Push S37's close-out commits (`758e528` and close-out 2) with the session's first push: they touch
   `docs/planning/`, so both workflows run.
3. **For 17d** (Learnings 15, 17): the drift choice D3 (plan `:588`) at the pre-RED picker: fix nprcgenekeepr too, in
   a session there that Mark starts, or a `DIVERGENCE.md` row for `drawPedigreeDiagram()` (its row exists, `:17`,
   for R81; a second reason joins it). **Measured S37, and it shapes that picker:** the fidelity tool compares
   drawings whole (`tools/compareResultsWithNprcgenekeepr.R:450`), and the rectilinear drawings of 11 of its 12
   pedigrees have `__jog_` entries in their select box (rhesus375 190, synthetic_300 436, smallPed 2; only
   lacy1989Ped none; the direct-edge drawings none). So the fix makes those cases differ from nprcgenekeepr's until
   it has the same fix: the tool needs an allowance like R81's `withoutConditionSymbols()` (`:723`), named in the
   picker. Draft the filter in a scratch copy, run the whole suite there (dragon 18), then RED: a test reads
   `drawPedigreeDiagram(layout)$x$idselection$values` on a layout with jogs (smallPed's rectilinear layout has 2).
   DONE (plan `:451`): the colony drawing's box lists its 375 animals only, checked in headless Chrome.
4. **For 17e:** measure first (plan `:459`): a shorter label (`R/drawPedigreeDiagram.R:119`) or a wider legend
   column, at the website's 776 px widget and the vignette's 700 px column; then D3.

### Gotchas
- **The select box's count depends on the drawing (S37):** the backlog's "571 entries, 196 `__jog_`" is the drawing
  vignette's colony drawing; `drawPedigreeDiagram(makePedigreeMatingLayout(rhesus375))` with the defaults gives 565
  entries, 190 `__jog_` (375 animals either way). The backlog's "the small drawings have no `__jog_` point" holds for
  the vignettes' small drawings, not smallPed's rectilinear layout (2). Measure on the drawing a test uses.
- **Copied code, drift rule (plan section 5, D3):** nprcgenekeepr has the same filter (`R/drawPedigreeDiagram.R:252`
  at `2eb3920b0`; pedkindraw's `:292`) and the same label (`:90` there, `:119` here). pedkindraw's sessions never
  change nprcgenekeepr (R8).
- **RED by file as well as by block (plan dragon 21, S37):** a test file whose calls run outside `test_that()` fails
  RED as one file error; the picker should say which files will.
- **The fidelity tool runs from the repository (plan dragon 22, S37):** from a scratch copy outside renv's project its
  nprcgenekeepr process inherits pedkindraw's library and stops ("openxlsx is required"). Run it at GREEN against
  a commit: `Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr $(git -C ../nprcgenekeepr rev-parse
  --short HEAD)`.
- **A scratch copy for the suite and the drafts:** `git archive HEAD | tar -x -C <scratch>`, then from it
  `env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib> NOT_CRAN=true RENV_CONFIG_AUTOLOADER_ENABLED=false Rscript
  --no-init-file ...` (`<lib>` is `renv::paths$library()`). S37 drafted RED and GREEN as two shell scripts applied
  to scratch copies, measured both RED variants, then applied the same script to the repository and proved the
  files byte-identical (`cmp`).
- **A transient URL in the check (plan dragon 10):** a GitHub link read 503 once in S37; `tools:::check_url_db(
  tools:::url_db_from_package_sources("."))` re-checks the 17 URLs in seconds. Re-run before acting.
- **`Rscript -e` with a backslash in a regular expression** stopped "'\.' is an unrecognized escape" in S37; put such
  code in a script file, or write `[.]`.
- **`quality_ratchet.py`** runs as `python3 methodology/quality_ratchet.py --run` from the root; its results file is
  git-ignored; a gate's key is `name`, not `id`.
- **Carried:** `smallPed`'s stored `gen` is wrong in 8 of 17 animals (only `test_maleLeftDuplicateMate.R` computes
  it); `kinship()` stops on generation numbers out of order, so `makePedigreeMatingLayout()` does too unless given a
  `kinshipMatrix`; render the README after `R CMD INSTALL -l <lib> .`, and count exports on `pkgload::load_all()`;
  the sire/dam words gate reads `R/`, `man/`, README, NEWS and vignettes; `CLAUDE.md` is over its 28,000 B budget
  (S23-S37 added nothing: learnings go here and in the plan's dragons, 21-22 from S37); no English hunspell
  dictionary on this Mac; R's own library holds 7 of the 9 Suggests; 79 copied files; the suite gate counts
  warnings, not failures (tally "0 failed" by hand); `pedkindraw.Rproj` untracked, Mark's.
- **`methodology/HANDOFFS.md` nears its trim trigger:** about 169 KB against 196,608 B after S37's receipt
  (`python3 methodology/methodology_trim.py --file methodology/HANDOFFS.md --check`); receipts add about 5-6 KB, so
  about 5 more sessions before it fires (an estimate).
- **Times on this Mac (S37):** suite 250-258 s; `R CMD build` plus `check --as-cran` 178-188 s; the fidelity tool
  about 200 s plus loading (102 s nprcgenekeepr, 98 s pedkindraw); CI 14-20 min; the site workflow 3 min.

### Key files
- `docs/planning/cran-submission-plan.md:6` (status), `:389` (17c; 17c3 `:429`, its Done `:434`), `:451` (17d), `:459`
  (17e), `:588` (D3), `:599` (8, session map), `:631` (9, dragons; 10 `:656`, 21 `:685`, 22 `:689`).
- `docs/planning/standalone-pedigree-package-plan.md:56` (Next), `:938` (Done 17c3).
- `R/drawPedigreeDiagram.R:119` (the label), `:290` (`nodesIdSelection`), `:292` (the filter);
  `tools/compareResultsWithNprcgenekeepr.R:450` (the drawing case), `:723` (`withoutConditionSymbols()`, R81's
  allowance); `vignettes/drawing.Rmd:626` (the colony drawing); `DIVERGENCE.md:17` (`drawPedigreeDiagram()`'s row);
  `methodology/BACKLOG.md:26` (17d), `:36` (17e); `tests/testthat/test_drawPedigreeDiagram.R`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S36's entries were removed in S3-S37 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 36 Handoff Evaluation (by Session 37)
**Score: 9/10.**
- **What helped:** every count and citation held: the drift tool (91/10/0), nprcgenekeepr's log (the same 4
  commits), the parse's 65 calls with 42 unchanged and 23 to rewrite, every cited line (`R/trimPedigree.R:50`-`:51`,
  `:57`, `:59`; `R/hasBothParents.R:28`, `:30`, `:31`; `R/addBackSecondParents.R:49`; `vignettes/pedkindraw.Rmd:152`,
  `:163`, `:302`; the tool's `:104`, `:124`, `:157`, `:227`, `:228`, `:291`, `:268`; `R/getParents.R:14`-`:16`;
  `NEWS.md:47`), and the error message R89 predicted, in all four. Its three pre-RED questions were the right ones,
  and the scratch-copy recipe ran verbatim.
- **What was missing:** that `test_trimPedigree.R`'s calls run outside `test_that()`, so rewriting them in RED fails
  the file whole (found by measuring both variants before the picker; dragon 21); and that the fidelity tool cannot
  run from a scratch copy (dragon 22). Neither changed the outcome.
- **What was wrong:** nothing found. "About 16 files" was 21 with the tests; it said "about".
- **ROI:** high.

### What Session 37 Did
**Deliverable:** Phase 17c3, the pedigree first (R89), strict TDD: `getProbandPedigree(ped, probands)`,
`getDescendantPedigree(ped, probands)`, `trimPedigree(ped, probands, ...)`, `hasBothParents(ped, id)`, and the 23
calls that passed both by position. DONE.
**Started:** 2026-11-17 17:55 CST · **Model:** Claude Opus 5.5 · **Mark's picks**, each Claude's recommendation at
the first asking: "17c3: pedigree first (Recommended)" (orient); pre-RED: the 8 old-order test calls "In RED",
`hasBothParents()`'s tests in "A new file", "Drop the sentence" (`getParents()`'s), "A new bullet" (NEWS); the gates
"Yes, proceed to RED", "Yes, proceed to GREEN"; "Skip REFACTOR".
**Commits:** claim `e241cd0` (pushed with S36's close-out 1 and 2: CI `44203608487` 5/5, site `44203608587`); RED
`374f970`; GREEN 1 `8f921d5` (`getProbandPedigree()`, `trimPedigree()`, pages, the vignette's 3 calls); GREEN 2
`6a2caf9` (`getDescendantPedigree()`, `hasBothParents()`, `addBackSecondParents()`'s call, pages); GREEN 3 `4602b7c`
(the fidelity tool names both arguments; 4 `DIVERGENCE.md` rows); GREEN 4 `2b6ef7a` (`getParents()`'s sentence, NEWS);
these five pushed (CI `44212240619` 5/5 `success` at the first attempt, 16 min; site `44212240622` `success`); close-out 1 `758e528` (both plans, the contract,
ROADMAP, BACKLOG; dragons 21-22; R89's citation now `:50`) and close-out 2 (these notes, the receipt, the ledger),
neither pushed.
**Measured before RED** (scratch copies): the parse of every call (65, as R89); both RED variants on HEAD (the 8
calls in RED: 7 failures, `test_trimPedigree.R` whole; in GREEN: exactly the 5 new blocks); the whole suite with the
change drafted, 703 blocks, 0 failed, WARN 0; the help examples and the vignette's code; the regenerated pages
(later byte-identical in the repository); every expected value; nprcgenekeepr's 6 callers of the four.
**Verified:** RED 7 failures exactly where measured, WARN 0; GREEN suite 56 files, 703 blocks, 0 failed, 0 errors,
WARN 0 (258 s); lint 0; roxygen unchanged on a re-run; the five changed files' lines all reached by their tests
(`covr::file_coverage`, 100%); drift tool 91, 14 differ, 0 without a row; fidelity tool exit 0 against nprcgenekeepr
at `8ebd33d39`, 600 of 600, 132 matrices, largest difference 0; `R CMD check --as-cran` R16's NOTE only (second run;
the first also listed a GitHub link at 503, 200 a minute later); a final parse: every positional call in the new
order but the 4 deliberate old-order calls inside `expect_error()`; gate `user-facing-sire-dam-words` 0.
**Self-assessment: 9/10.**
+ Every picker stated measured results: both RED variants, the whole suite on the draft, the expected values. The
  repository's changes were the measured drafts, proved byte-identical. A stale citation my own GREEN 2 made
  (`:49` to `:50`) was fixed (Learning 7); a transient NOTE was re-checked rather than accepted or acted on. For S38,
  the jog counts per pedigree were computed, not guessed. Every pick at the first asking.
- Slips, none left in a pushed commit: a fidelity run from the scratch copy failed (dragon 22); an `Rscript -e` with
  `"\\."` failed (rewritten as a file); one comparison used a wrong line offset (redone by pattern); close-out 1's
  message named the contract's section 9 for section 10 (amended before any push).
**Learnings:** no `CLAUDE.md` row (over budget); the plan's dragons 21-22 and dragon 10's sentence; the Gotchas
above.
**Ledger:** `CHANGELOG.md` S37 entries (the session, push 1, push 2).
