# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission, is under way (`docs/planning/cran-submission-plan.md`). 17a-17b DONE
(S33-S34), 17c1 DONE (S35: `kinship(id, sire, dam, pdepth, ...)`), 17c2 DONE (S36: the pedigree argument is `ped`
in `getParents()`, `getOffspring()`, `getIdsWithOneParent()`, and `addBackSecondParents(trimmedPed, ped)`). Next:
**Phase 17c3, the pedigree first, strict TDD** (`docs/planning/cran-submission-plan.md:428`; R89 at `:207`;
`methodology/BACKLOG.md:11`): `getProbandPedigree(ped, probands)`, `getDescendantPedigree(ped, probands)`,
`trimPedigree(ped, probands, removeUninformative = FALSE, addBackParents = FALSE)`, `hasBothParents(ped, id)`, and
the 23 calls that pass both arguments by position (section 2.4's R89 row lists them by line). Four `DIVERGENCE.md`
rows; `addBackSecondParents()`'s row (`DIVERGENCE.md:23`) gains its `hasBothParents()` call. About 16 files.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker** (4 options at most, "Other" for hold): 17c3 (recommended: the plan's order, R93); 17d or 17e,
the drawing fixes, which need 17b only.
**Session boundary:** one deliverable. **Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 91 functions, **10** differ, all with rows: S36 added `getParents()`,
   `getOffspring()`, `getIdsWithOneParent()`, `addBackSecondParents()`); nprcgenekeepr's log on every copied file:
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R)` printed exactly 4 commits at S36's close (`4283e3502`, `a85311021`, `392dd347e`,
   `471589138`, all already in the copy). nprcgenekeepr moved 4 times during S36 (its S1183's claim, a ruling, RED
   and GREEN, on a tutorial; at `0b7afae51` for the fidelity run and at S36's close), none on a copied file.
2. Push S36's close-out commits (`26076c3` and close-out 2) with the session's first push: they touch
   `docs/planning/`, so both workflows run.
3. 17c3 before RED (Learnings 15, 17, 18): nprcgenekeepr's log on `R/getProbandPedigree.R`,
   `R/getDescendantPedigree.R`, `R/trimPedigree.R`, `R/hasBothParents.R` and their test files; re-parse every call
   to the four (section 2.4 at `5525edd`: 65 calls, 42 naming `probands =` or `ped =`, 23 by position), and read the
   fidelity tool's `fn("...")` calls by hand (`tools/compareResultsWithNprcgenekeepr.R:104`, `:124`, `:157`, `:227`,
   `:228`, `:291`; `:268` names `ped`), which must name their arguments to run on both packages (R89). Then run the
   whole suite on a scratch copy with the order swapped and the 23 calls rewritten (dragon 18). Pre-RED picker:
   where `hasBothParents()`'s names test goes (there is no `test_hasBothParents.R`; its tests are in the copied
   `test_kinshipHasBothParentsHelp.R`, S36's same question gave `getIdsWithOneParent()` a file of its own); whether
   the 8 positional test calls (`test_trimPedigree.R` 4, `test_kinshipHasBothParentsHelp.R` 4) are rewritten in RED
   or GREEN; the NEWS wording (extend S36's bullet, `NEWS.md:47`).
4. RED: `expect_named(formals(f), ...)` for each of the four (dragon 20), and a call in the new order equal to a
   call by name. GREEN at most 5 files a commit, each commit changing a function together with its callers so the
   suite stays whole between commits: the four `R/` files and pages; `R/trimPedigree.R:59` and
   `R/addBackSecondParents.R:49` (calls); the help examples `R/trimPedigree.R:50`-`:51`, `R/hasBothParents.R:28`,
   `:30`; `vignettes/pedkindraw.Rmd:152`, `:163`, `:302`; the fidelity tool; `getParents()`'s help sentence on the
   order, `R/getParents.R:14`-`:16` ("unlike getProbandPedigree() and getDescendantPedigree(), which take the animal
   ids first"), which 17c3 makes false and `man/getOffspring.Rd` inherits; each header `:4` ("Changes: help text
   only"); `DIVERGENCE.md` rows; NEWS. Then 17c's DONE list (plan `:433`).

### Gotchas
- **A rename's RED and partial matching (plan dragon 20, S36):** R matches `ped =` to `pedSourceDf` (a prefix), so a
  call naming the new name passed on the old code; only `expect_named(formals(f))` failed. For 17c3's order change
  the named calls keep working and the positional ones break: an old-order call stops with "$ operator is invalid
  for atomic vectors" in each of the four (R89, a scratch run at S34).
- **Count what a change breaks by parsing (plan dragon 16).** Parse `R/`, `tests/`, `tools/`; `tools::Rd2ex()` each
  `man/*.Rd`; `knitr::purl(documentation = 0)` the README and vignettes. Walk each tree by index and skip the empty
  argument, or R stops "argument is missing": `x <- as.list(e); for (k in seq_along(x)) { if (is.name(x[[k]]) &&
  !nzchar(as.character(x[[k]]))) next; walk(x[[k]]) }`. Record `pkg::` before stripping it; read the fidelity
  tool's `fn("name")(...)` calls by hand (`grep -n 'fn("' tools/compareResultsWithNprcgenekeepr.R`). S36's walker
  (each call's named arguments, by file) ran in seconds.
- **A scratch copy runs without touching renv's project:** `git archive HEAD | tar -x -C <scratch>`, then from the
  scratch folder `env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib> Rscript --no-init-file ...` (`<lib>` is
  `renv::paths$library()`). Drafting the change there and running the drafted RED tests on both the draft and the
  repo (HEAD's code) shows which blocks fail and why before RED is committed (S36 found the partial matching so).
- **nprcgenekeepr runs sessions beside this one** (Learning 15): read it at a commit for the fidelity tool,
  `Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr $(git -C ../nprcgenekeepr rev-parse --short
  HEAD)`, and re-run its log on the slice's files at each gate.
- **`quality_ratchet.py`** runs as `python3 methodology/quality_ratchet.py --run` from the root; its results file is
  git-ignored; a gate's key is `name`, not `id`.
- **Carried:** `smallPed`'s stored `gen` is wrong in 8 of 17 animals (only `test_maleLeftDuplicateMate.R` computes
  it); `kinship()` stops on generation numbers out of order, so `makePedigreeMatingLayout()` does too unless given a
  `kinshipMatrix`; render the README after `R CMD INSTALL -l <lib> .`, and count exports on `pkgload::load_all()`;
  the sire/dam words gate reads `R/`, `man/`, README, NEWS and vignettes; `CLAUDE.md` is over its 28,000 B budget
  (S23-S36 added nothing: learnings go here and in the plan's dragons, 20 from S36); no English hunspell dictionary
  on this Mac; R's own library holds 7 of the 9 Suggests; 79 copied files ("Copied from nprcgenekeepr"); the suite
  gate counts warnings, not failures (tally "0 failed" by hand); `pedkindraw.Rproj` untracked, Mark's.
- **`methodology/HANDOFFS.md` nears its trim trigger:** 163,822 B against 196,608 B at S36's close-out
  (`python3 methodology/methodology_trim.py --file methodology/HANDOFFS.md --check`); S35's and S36's receipts
  added 5.6 and 5.1 KB, so about 6 more sessions before it fires (an estimate). `CHANGELOG.md` 117,295 B.
- **Times on this Mac (S36):** suite 249 s; `R CMD build` plus `check --as-cran` 186 s; the fidelity tool 211 s;
  `quality_ratchet.py --run` 4 min 35 s; CI 16-20 min; the site workflow 3 min (24 min on S36's push 2, still `success`).

### Key files
- `docs/planning/cran-submission-plan.md:6` (status), `:169` (2.4), `:195` ("Decided"), `:207` (R89, the 23 calls
  by line), `:388` (17c; 17c2's Done `:419`, 17c3 `:428`, DONE `:433`), `:586` (8, session map; 17c3 `:594`),
  `:618` (9, dragons; 16 `:651`, 20 `:666`).
- `docs/planning/standalone-pedigree-package-plan.md:55` (Next), `:209` (R89), `:886` (17c3 row), `:931` (Done
  17c2).
- `docs/planning/pedkindraw-api-contract.md:123`, `:128`, `:129`, `:130` (the four 17c3 signatures, old order beside
  them).
- `R/getProbandPedigree.R:4`, `:33`; `R/getDescendantPedigree.R:4`, `:34`; `R/trimPedigree.R:4`, `:50`, `:57`,
  `:59`; `R/hasBothParents.R:4`, `:28`, `:31`; `R/addBackSecondParents.R:49`; `R/getParents.R:14`;
  `vignettes/pedkindraw.Rmd:152`; `tests/testthat/test_trimPedigree.R`, `test_kinshipHasBothParentsHelp.R`,
  `test_getProbandPedigree.R`, `test_getDescendantPedigree.R`; `DIVERGENCE.md:23`; `NEWS.md:47`;
  `methodology/BACKLOG.md:11`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S35's entries were removed in S3-S36 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 35 Handoff Evaluation (by Session 36)
**Score: 9/10.**
- **What helped:** every step ran as written and every count held: the drift tool (91/6/0), nprcgenekeepr's log
  (the same 4 commits), 0 commits on the four files, `git grep` 35 lines in 8 files, the parse's 24 calls with none
  naming `pedSourceDf` or `uPed`. Its RED and GREEN line citations were right (`R/getParents.R:11`, `:28`;
  `R/getOffspring.R:10`, `:24`; `R/getIdsWithOneParent.R:10`, `:27`; `R/addBackSecondParents.R:11`-`:16`, `:38`),
  and its GREEN split (two commits of 5 files) was the one used. The scratch-copy recipe and the parse loop ran
  verbatim; "push both close-outs, both workflows run" was right (CI `44185838926` passed); the times held (suite 249
  s against 248-258). The pre-RED question it named was the right one.
- **What was missing:** that a new name which is a prefix of the old one (`ped`, `pedSourceDf`) passes a named call
  on the old code, so step 4's "a call that names the new argument" does not fail RED for two of the four (found by
  running the drafts on HEAD); and that a NEWS line would be a pre-RED question again, as in S35. Neither could
  change the plan's outcome.
- **What was wrong:** nothing found.
- **ROI:** high.

### What Session 36 Did
**Deliverable:** Phase 17c2, the pedigree argument is `ped` (R88), strict TDD: `getParents(ped, ids)`,
`getOffspring(ped, ids)`, `getIdsWithOneParent(ped)`, `addBackSecondParents(trimmedPed, ped)`.
**Started:** 2026-11-17 16:00 CST · **Model:** Claude Opus 5.5 · **Mark's picks**, each Claude's recommendation at
the first asking: "17c2: rename to ped (Recommended)" (orient); pre-RED: "A new file" (`test_getIdsWithOneParent.R`),
"Add it now" (NEWS); the gates "Yes, proceed to RED", "Yes, proceed to GREEN"; "Skip REFACTOR".
**Commits:** claim `a78de5b` (pushed with S35's close-out 1 and 2: CI `44185838926` 5/5, 20 min); RED `ef101e8`;
GREEN 1 `91f65e5` (`getParents()`, `getOffspring()`, pages, 2 rows); GREEN 2 `858cfc9` (`getIdsWithOneParent()`,
`addBackSecondParents()`, pages, 2 rows); GREEN 3 `7d4de5d` (NEWS); these four pushed (CI `44191349985` 5/5 `success` at the first attempt, 17 min; site `44191349596` `success`, 24
min); close-out 1
`26076c3` (both plans, the contract, ROADMAP, BACKLOG) and close-out 2 (these notes, the receipt, the ledger, the
plan's R89 citation `R/addBackSecondParents.R:45`, now `:49` after GREEN 2's header), neither pushed.
**Measured before RED** (scratch copy with the four renames drafted): the whole suite 697 blocks, 0 failed, WARN 0;
the drafted RED blocks 8 of 8 passing there, and on HEAD the 5 new ones failing, 2 of them on the names check alone
(partial matching); every expected value of the new file (`c("D", "E")`, `character(0)`).
**Verified:** RED exactly the 5 new blocks failing, WARN 0; GREEN suite 55 files, 698 blocks, 0 failed, 0 errors,
WARN 0 (249 s); lint 0; roxygen unchanged on a re-run; every statement of the four functions reached by their own
tests (`covr::file_coverage`: 10 of 10, 1, 1, 1); drift tool 91, 10 differ, 0 without a row; fidelity tool exit 0
against nprcgenekeepr at `0b7afae51`, 600 of 600 identical, 132 matrices, largest difference 0; `R CMD check
--as-cran` 1 NOTE, R16's (Maintainer, New submission); the old names only in headers, `DIVERGENCE.md`, NEWS and test
comments; gate `user-facing-sire-dam-words` 0; `quality_ratchet.py --run` 5/5 pass, 0 fail, 0 unmeasured, results
`5ddbb5b1aeb3`, manifest `01151c525b8a` (the same fingerprint as S35's: every gate measured 0 again); the
`file:line` citations in these notes and the receipt checked by machine against their text after the last edit.
**Self-assessment: 9/10.**
+ Every gate was measured before it was put: the drafted tests run on both the draft and HEAD showed which RED
  blocks fail and why, so the RED commit could state it, and dragon 20 records it for 17c3. Coverage measured, not
  assumed. nprcgenekeepr checked at each gate (it moved four times). Found and fixed a stale citation my own GREEN 2
  made (R89's `:45`, Learning 7) and a 17c3 help sentence no plan named. Every pick at the first asking.
- Small slips, none in a commit: a `sed -i` with `\b` (a no-op on this Mac's sed; `perl` did the scratch rename); a
  gate lookup by `id` (the key is `name`); one throwaway file written to `/tmp` instead of the scratchpad, removed;
  a backlog line past the file's width, fixed before close-out 1.
**Learnings:** no `CLAUDE.md` row (over budget); the plan's dragon 20 (R matches a shortened argument name to the
old one); the Gotchas above.
**Ledger:** `CHANGELOG.md` S36 entries (the session, push 1, push 2).
