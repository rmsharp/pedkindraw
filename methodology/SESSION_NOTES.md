# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission, is under way (`docs/planning/cran-submission-plan.md`). 17a DONE (S33),
17b DONE (S34: seven rulings, R87-R93, no code changed). Next: **Phase 17c1, `kinship()`, strict TDD**
(`docs/planning/cran-submission-plan.md:394`; inventory section 2.4, its "Decided" table at `:193`;
`methodology/BACKLOG.md:11`): rename `fatherId`/`motherId` to `sire`/`dam` in the same positions (R87); stop with
a plain message when a known parent's `pdepth` is not below its offspring's (R92); the help says the 4th argument is
`pdepth`, not kinship2's `sex`, and the help and the README say which names kinship2 and Pedixplorer share (R91).
One `DIVERGENCE.md` row. 17c2 (the pedigree argument's name, R88) and 17c3 (the pedigree first, R89) follow, in
that order (R93).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker** (4 options at most, "Other" for hold): 17c1 (recommended: the plan's order, R93); 17d or 17e,
the drawing fixes, which need 17b only (none of the functions R87-R89 change is in `R/drawPedigreeDiagram.R`; the
session map's S34 paragraph, `docs/planning/cran-submission-plan.md:586`).
**Session boundary:** one deliverable. **Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 91 functions, 5 differ, all with rows); nprcgenekeepr's log on every copied file:
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R)` printed exactly 4 commits at S34 (`4283e3502`, `a85311021`, `392dd347e`, `471589138`, all
   already in the copy; nprcgenekeepr at `366899961`). Any other line is a change to a copied file: plan section
   4.4 and R37.
2. Push S34's close-out 2 commit with the session's first push (methodology only: no run starts).
3. 17c1 before RED (Learnings 15, 17, 18): `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- R/kinship.R
   tests/testthat/test_kinship.R tests/testthat/test_kinshipMemoryEquivalence.R`; re-run the parse of `kinship(`
   calls (recipe in Gotchas; expect 43 calls, 1 naming `fatherId`/`motherId`, the copied C13 test). Draft the
   check and its typed cases in a scratch copy and run them before RED: a dam at the same `pdepth` as its
   offspring; a sire above; founders at 0; a parent named but not in `id` (ignored: `match()` gives `NA`); MZ twins
   (same parents, same depth: must pass); X chromosome with `sex`. Time the kinship2 cases: the sex-codes call
   stops cheaply, but `findGeneration()` plus `kinship()` on all 426 `minnbreast` families costs more, and CRAN's
   test time matters (R86); put a subset or `skip_on_cran()` in the pre-RED picker with the measured seconds.
   Also a scope question for that picker: a NEWS line now, or in 17m.
4. RED: the copied C13 test (`tests/testthat/test_kinship.R:238`-`:252`) asks for `sire` and `dam` (its file
   header names the change, as Learning 10 does); the three expected messages
   (`tests/testthat/test_kinshipMemoryEquivalence.R:74`-`:76`); the new check's tests. GREEN: `R/kinship.R` (the
   signature `:101`, `@param` `:27`/`:29`, the length check and its message `:113`-`:116`, `match()` `:144`-`:145`,
   the new check after the MZ twins' check `:134`-`:136`), its header `:3`-`:6` (no longer "help text only"),
   `roxygen2::roxygenise()`, `README.Rmd` then `rmarkdown::render("README.Rmd")`, a `DIVERGENCE.md` row (columns at
   `DIVERGENCE.md:12`; nprcgenekeepr commit `baef1e12c`). Then 17c's DONE list (plan `:407`), the fidelity tool
   included: its `kinship()` calls pass the parents by position and `findGeneration()`'s numbers (or founders at
   0), so it should stay exit 0.

### Gotchas
- **Count what a change breaks by parsing, not by text (S34; plan dragon 16).** Recipe: parse each file in `R/`,
  `tests/`, `tools/`; `tools::Rd2ex()` each `man/*.Rd` for the examples; `knitr::purl(documentation = 0)` the README
  and each vignette; walk each parse tree and, for each call to the function, record which arguments pass by
  position (skip the empty symbol before recursing, or R errors "argument is missing"). Two traps: record the
  `pkg::` prefix before stripping it (S34's first count took kinship2's 3 `kinship()` calls for pedkindraw's: the
  picker said 45 of 46, the record says 42 of 43), and the fidelity tool calls through `fn("name")(...)`, which a
  parse for the name does not see: `grep -n 'fn("' tools/compareResultsWithNprcgenekeepr.R` (`:268` passes
  `hasBothParents` bare to `lapply()`, naming `ped`).
- **zsh does not split an unquoted variable:** `P="R tests"; git grep x -- $P` searches one path named "R tests"
  and finds nothing (S34's first inventory read 0 everywhere). Use `bash -c '...'` or write the paths out.
  `$(...)` is split, so step 1's command works as written.
- **`kinship()`'s silent wrong answer is live until 17c1 (R92):** kinship2's positional `kinship(id, dadid, momid,
  sex)` takes `sex` as `pdepth`. `minnbreast`'s `sex` has 1,761 `NA`: code them 3 (kinship2's unknown), or the call
  stops on "pdepth must not be missing for any animal" before the new check. kinship2 is a Suggests:
  `skip_if_not_installed("kinship2")`.
- **The fidelity tool's `kinshipErrors` cases** compare error messages with nprcgenekeepr's: the new check must come
  after every existing input check (plan `:398`), or a case that now stops earlier changes its message.
- **The sire/dam words gate** (`user-facing-sire-dam-words`) reads `R/`, `man/`, the README, NEWS and vignettes for
  husband/wife; R87's text keeps to sire, dam, mate, mating. "father"/"mother" are not in the gate, but S23's
  vocabulary ruling covers them too.
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (30,795 B; S23-S34 added nothing: learnings go here and in
  the plan's dragons); no English hunspell dictionary on this Mac; R's own library holds 7 of the 9 Suggests; count
  copied files by the header's capitalized "Copied from nprcgenekeepr" (79); the suite gate's 300 s limit fails
  under load and counts warnings, not failures (tally "0 failed" by hand); both workflows run on any push beyond
  `CLAUDE.md` and `methodology/**`; the copied `test_positionMatingUnitForest.R` prints three `message()` lines
  (17l); `pedkindraw.Rproj` untracked, left for Mark.
- **Times on this Mac:** `R CMD build` 18 s; `R CMD check --as-cran` 181-208 s under load; suite 4.3 min;
  `quality_ratchet.py --run` about 5 min; CI 15-20 min; the site workflow 3 min. The scratch build and check
  recipe is in the plan's section 2.1 and S33's receipt.

### Key files
- `docs/planning/cran-submission-plan.md:6` (status), `:167` (2.4), `:193` ("Decided", the inventory table at
  `:201`), `:211` (the 9 `DIVERGENCE.md` rows), `:368` (17b, Done `:378`), `:386` (17c; 17c1 `:394`, 17c2 `:403`,
  17c3 `:405`, DONE `:407`), `:548` (D2), `:560` (8, session map; 17c1 `:566`), `:592` (9, dragons 16-17 at the end).
- `docs/planning/standalone-pedigree-package-plan.md:53` (Next), `:205`-`:211` (R87-R93), `:882` (17c1-17c3 rows),
  `:914` (Done 17b).
- `docs/planning/pedkindraw-api-contract.md:106` (section 4's review paragraph), `:118`-`:129` (4.1's new
  signatures), `:145` (`kinship()`, 4.2), `:288` (section 6, S34), `:351` (10, item 4).
- `R/kinship.R:3` (header), `:101` (signature), `:115` (the message), `:118`-`:136` (input checks), `:144`
  (`match()`), `:165` (the generation loop that makes `pdepth`'s order matter);
  `tests/testthat/test_kinship.R:241`; `tests/testthat/test_kinshipMemoryEquivalence.R:74`; `README.Rmd:84`, `:145`;
  `DIVERGENCE.md:12`; `methodology/BACKLOG.md:11` (17c1), `:19` (17c2), `:23` (17c3).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S33's entries were removed in S3-S34 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 35 Did
**Deliverable:** Phase 17c1, `kinship()` (`docs/planning/cran-submission-plan.md:394`; R87, R91, R92): `sire` and
`dam` for `fatherId` and `motherId`, a stop when a known parent's `pdepth` is not below its offspring's, the help
and the README on the 4th argument and the shared names; one `DIVERGENCE.md` row; strict TDD (IN PROGRESS)
**Started:** 2026-11-17 14:21 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "17c1: kinship() (Recommended)"
(orient picker)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 33 Handoff Evaluation (by Session 34)
**Score: 9/10.**
- **What helped:** every step ran as written: the drift tool (91/5/0) and nprcgenekeepr's log (the same 4 commits)
  gave the expected output; the push went first. Step 3 was the right order: re-run section 2.4's inventory before
  any picker (the five name counts held exactly) and read C13 first, which showed `fatherId`/`motherId` only took
  the dots out of the old names, the fact that framed R87. The five items, the two-picker note and the sire/dam
  gate gotcha were all used. Its line citations (`cran-submission-plan.md:341`, `:165`; contract `:102`, `:146`;
  standalone plan `:544`; `BACKLOG.md:11`) were right at `15c7627`.
- **What was missing:** that section 2.4's call counts are text matches, which do not say what an order change
  breaks (S34 parsed every call instead), and that the fidelity tool calls through `fn("name")(...)`. Neither is
  a fault of the handoff so much as of 2.4's method.
- **What was wrong:** one small thing: it repeated the plan's reason for putting 17d and 17e after 17c ("a rename
  would touch the same files"); measured, no renamed function is in their file.
- **ROI:** high.

### What Session 34 Did
**Deliverable:** Phase 17b, the argument-name review: seven rulings (R87-R93), no code changed.
**Started:** 2026-11-17 13:29 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "17b: name review
(Recommended)" (orient); then, each Claude's recommendation and each at the first asking: "Rename to sire, dam"
(R87), "Rename all four" (R88), "Pedigree first, all four" (R89), "Keep it internal" (R90), "Keep, and say so in
help" (R91), "Add the check in 17c" (R92), "Three sessions" (R93).
**Commits:** claim `5525edd` (pushed with S33's close-out 2, methodology only, no run); the record `92333c3` (both
plans and the contract: section 2.4's Decided table, 17b's Done line, 17c rewritten as 17c1-17c3, D2, the session
map, R87-R93, the new signatures); close-out 1 `44bef08` (ROADMAP, BACKLOG: 17b removed, 17c1-17c3 added; the
contract's open item 4), pushed with the record (CI and site runs under Verified); close-out 2 (these notes, the
receipt, the ledger, dragons 16-17, a roadmap line re-wrapped), not pushed.
**Measured** (at `5525edd`; nprcgenekeepr `366899961`): section 2.4's name counts held exactly; a parse of every
call (`R/`, tests, `tools/`, help examples, README, vignettes): R87 43 calls to pedkindraw's `kinship()`, 1 by
name; R88 24 calls, none by name; R89 65 calls, 42 survive the order change, 23 rewritten (listed by line in 2.4);
an old-order call stops with "$ operator is invalid for atomic vectors", never a wrong answer. Shared names: 22 of
31 with nprcgenekeepr (240 exports), 6 with kinship2 1.9.6.2, 1 with Pedixplorer 1.8.0. kinship2's `kinship(id,
dadid, momid, sex)` on pedkindraw's `kinship()`: wrong in 425 of `minnbreast`'s 426 families (28,081 animals) and
414 of 1,681 values in `sample.ped` family 1, with no error; the check "each known parent's `pdepth` below its
offspring's" stopped it in all 426 and passed `findGeneration()`'s numbers in all 426. 17c touches about 31 files.
**Verified:** drift tool 91, 5 differ, 0 without a row; nprcgenekeepr's log on the 79 copied files the same 4
commits; 18 `file:line` citations in the record checked by machine at `92333c3`; `quality_ratchet.py --run` 5/5 pass, 0 fail, 0 unmeasured, results `5ddbb5b1aeb3`, manifest `01151c525b8a` (load 3.7-5.6); site run `44162711010` `success`; CI `44162710948` 5/5 `success` at the first attempt (16 min).
**Self-assessment: 8/10.**
+ Measured before every picker, by parse rather than text, and found what text counts hide: which calls an order
  change breaks (23 of 65), and a silent wrong answer behind a shared name (R92), checked on 426 families before
  the picker claimed it. All eight picks came at the first asking. The record names the old signature beside each
  new one, so 17c and readers of the contract see both.
- Two counts in the pickers were off and corrected only in the record: "45 of the 46 calls" (kinship2's 3 counted;
  42 of 43) and "5 `DIVERGENCE.md` rows" for R89 (4 once R88 also passed, sharing `addBackSecondParents()`'s row).
  Neither changed a decision. The first inventory read 0 everywhere (zsh), caught at once. Three wrapping slips
  (two long lines in `92333c3`, one made by close-out 1's own fix) needed later commits.
**Learnings:** no `CLAUDE.md` row (over its budget). The plan's dragons 16 (parse, and record `pkg::` first) and 17
(call a shared name the other package's way); in the Gotchas above: the parse recipe, zsh's unsplit variables.
**Ledger:** `CHANGELOG.md` S34 entries (the session, push 1, push 2).
