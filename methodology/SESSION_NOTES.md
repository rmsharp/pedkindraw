# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 15c: the converters pass hints on**, strict TDD (`methodology/BACKLOG.md:11`; the design
`docs/planning/layout-hints-design.md` section 7.4 `:178`, 15c's DONE criteria `:241`, D8 `:263`; rulings R62 at
`docs/planning/standalone-pedigree-package-plan.md:170` and R73 at `:181`; row 15 at `:535`). The orient picker
asks Mark: this, **tests for full coverage** (`methodology/BACKLOG.md:23`, 43 of 2,445 statements missed), or hold.
**Status:** READY. Phase 15b DONE (S23: RED `034ac3c`, GREEN `7889ec8`, rows `9c1e209`, REFACTOR `ffe042f`); suite
664 tests, 0 failed, WARN 0, SKIP 0, 5,144 expectations; drift tool 3 differ, all with rows; pushed through
`ffe042f` (with S22's two close-out commits), CI run `43771237000` 5/5 at the first attempt; S23's close-out
commits are not pushed.
**Plan:** `asPedFrame()` returns `list(ped, twinRelations, hints)`, `hints` in `makePedigreeMatingLayout()`'s form,
`list(order = , mate = )`, or `NULL` (R62; the element is `mate`, not `spouse`, R73).
**Session boundary:** one session, 15c only; then Phase 15 is DONE and Phase 16 (documentation) is next.
**Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 3 differ, 0 without a row); `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   R/makePedigreeDiagramData.R R/orderRootSubtrees.R R/positionTreeApportion.R` (Learning 15); nprcgenekeepr's
   converters are not copied, so only those three files matter for drift.
2. Read the design's 7.4 and 15c's DONE criteria, R62 and R73, contract 4.5 (`docs/planning/pedkindraw-api-contract.md:202`)
   and `R/asPedFrame.R` (Key files).
3. Measure before the pre-RED picker (Learnings 17-19): what kinship2 objects (`pedigree`, `pedigreeList`, D8) and
   Pedixplorer `Pedigree` objects hold in their hints, set by a user and by `autohint()` / `auto_hint()`; whether a
   converted hint can break R70-R71 (a pair with no offspring together, an anchor on the earlier-generation partner)
   and so stop `makePedigreeMatingLayout(x$ped, hints = x$hints)`; the 9 converter tests that compare the whole
   returned list (M8). Picker questions likely: a hint `makePedigreeMatingLayout()` would refuse (pass it on, drop
   it, or stop), and `pedigreeList` hints (D8). This list is a guess; the measurements decide.
4. Prototype in a scratch tree, draft tests against it, run the drafts against unchanged HEAD for the RED proof.
5. RED, GREEN, REFACTOR, each gate an `AskUserQuestion`; contract 4.5's row and R58's return; the checks (fidelity
   tool, `R CMD check --as-cran` from a scratch folder, coverage of `R/asPedFrame.R`); push; CI; "Done 15c" and
   Phase 15 DONE in the plan.

### Gotchas
- **Words:** user-facing documentation and code say sire, dam, mate, mating, never husband or wife (Mark, S23;
  gate `user-facing-sire-dam-words` counts them in `R/` and `man/`). kinship2's and Pedixplorer's help pages say
  spouse and marriage: translate before writing. pedkindraw's element is `hints$mate` (R73).
- **Pedixplorer's `Hints()`:** a spouse data frame needs a non-empty `horder` whose names include every `idl` and
  `idr` ("horder slot should be non empty if spouse slot is non empty"); `anchor` is stored as an ordered factor
  (`left`, `right`, `either`) and accepts `0`/`1`/`2` too; it refuses a repeated pair, the same id twice and an
  unknown id; ids are family-prefixed (`1_A`, R58).
- **kinship2's spouse hint:** `hints$spouse` is a matrix (left index, right index, anchor 1/2/0) and
  `align.pedigree()` needs `hints$order` with it (start from `autohint()`, as `layoutHintsKinship2MateRows()` does);
  an anchor on a founder whose mate has parents makes its quadratic program fail ("constraints are inconsistent").
- **A row text hides repeat nodes:** `layoutHintsRowText()` drops `__dup_` nodes, so a hint on an animal drawn twice
  looks ignored; use `layoutHintsRowTextAll()`. Compare kinship2's offspring row as well as the mates' row: S23 found
  the families-follow-mates rule only there.
- **zsh:** `( a; b & )` runs `a` in the foreground; put `&` on each command and `wait`. Keep each shell command to
  one check: Mark rejected one compound command (a background job plus several `Rscript`s) mid-RED.
- **Another Claude session may run R checks at the same time** (S23: nprcgenekeepr's `devtools::check()` in a temp
  folder): runs go slow; `ps` and `lsof -d cwd` show whose they are before blaming the code.
- **The scratch-tree recipe:** `git archive HEAD | tar -x -C <tree>`, edit there, then `env -u RENV_PROJECT
  R_LIBS=<lib> R_LIBS_USER=<lib> NOT_CRAN=true Rscript --no-init-file ...` from `<tree>`; `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'`. One script per tree: loading two trees in one R session is awkward.
  Prove GREEN equals the prototype by `deparse()` of each function after `sys.source()`.
- **`R CMD check --as-cran` from the root stops at "CRAN incoming feasibility"**: run it from a scratch folder.
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S23 added nothing; the vocabulary rule is a gate instead).
- **Left outside the repository for Mark:** `~/Library/Caches/org.R-project.R/R/renv/library/tree-86aa6c47` (S19's,
  harmless).
- **Times on this Mac (S23, with another session's check running beside it):** `test_layoutHintsMate.R` ~70 s (its
  100 random pedigrees ~60 s, `skip_on_cran()`); `test_layoutHintsOrder.R` ~43 s; suite ~3 min; fidelity tool
  ~4 min; `covr` ~5 min; `R CMD check --as-cran` ~5 min.

### Key files
- `R/asPedFrame.R`: `:137` the generic, `:143` default, `:152` `pedigree`, `:158` `pedigreeList`, `:164`
  `Pedigree`, `:215` `.asPedFrameConditions()`, `:235` `.asPedFrameText()`, `:247` `.asPedFrameTwins()`.
- `tests/testthat/test_asPedFrame.R`, `test_asPedFramePedixplorer.R`, their helpers `helper-asPedFrame.R`,
  `helper-asPedFramePedixplorer.R`.
- `R/layoutHints.R`: `:23` `.checkLayoutHints()`, `:60` `.checkLayoutHintOrder()`, `:109` `.checkLayoutHintMate()`
  (the shape a converted hint must have), `:271` `.layoutHintMateRow()`, `:284` `.layoutHintAnchor()`, `:309`
  `.layoutHintMatingSides()`, `:337` `.layoutHintSides()`, `:378` `.layoutHintFamilies()`.
- `tests/testthat/helper-layoutHints.R`: `:192` `layoutHintsMate()`, `:200` `layoutHintsRowTextAll()`, `:223`
  `layoutHintsMatings()`, `:278` `layoutHintsKinship2MateRows()`.
- `docs/planning/pedkindraw-api-contract.md:202` (4.5's `asPedFrame()` row), `:232` (4.6).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S22's entries were removed in S3-S23 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 24 Did
**Deliverable:** plan Phase 15c: the converters pass hints on, `asPedFrame()` returning `hints` in
`makePedigreeMatingLayout()`'s form, `list(order = , mate = )`, or `NULL` (R62, R73), strict TDD (IN PROGRESS)
**Started:** 2026-11-15 17:14 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Phase 15c: converters
(Recommended)" (orient)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 22 Handoff Evaluation (by Session 23)
**Score: 9/10.**
- **What helped:** the five ordered steps became this session's sequence; every engine line cited (`:430`, `:486`,
  `:524`, `:1126`, `:1298`, `:1304`, `:1593`, `:1722`, `:1746`, `:1786`; `R/layoutHints.R:19`, `:36`) was right at
  `a26f46f`; the scratch-tree recipe and "prove GREEN equal to the prototype", used as written; "check what Pedixplorer
  does with a spouse data frame before citing it" (it needs an `horder`); the zsh word-splitting gotcha.
- **What was missing:** that the 15a row-reorder line (`if (!is.null(hints)) ped <- .layoutHintRows(ped,
  hints$order)`) empties `ped` for a hint without an order, which 15b had to guard; that the engine places an
  animal's families before it sets its mates' sides, so a side hint alone crosses family lines (a design gap more
  than a handoff gap; found by measuring).
- **What was wrong:** nothing found.
- **ROI:** high.

### What Session 23 Did
**Deliverable:** plan Phase 15b, the mate layout hint: `makePedigreeMatingLayout(..., hints = list(mate = ))`,
strict TDD; rulings R70-R73.
**Started:** 2026-11-15 12:27 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 15b: spouse hint
(Recommended)" (orient); "Strict: stop", "Stop", "kinship2's way", "Rename to hints$mate" (pre-RED, each the
recommended option); "Yes, proceed" at RED, GREEN, REFACTOR. Mid-session Mark corrected my wording ("why has dam
changed to wife and sire to husband?") and ruled "I want user facing documentation and code to use sire and dam.
Older hidden commits with husband or wife can remain."
**Commits:** claim `5e1b84e`; RED `034ac3c`; GREEN `7889ec8`; divergence rows and contract `9c1e209`; REFACTOR
`ffe042f`; pushed (with S22's close-out commits); close-out after, not pushed.
**Verified:** D6, D7, D9 measured on four scratch prototypes against kinship2 and Pedixplorer (the design's M6
reproduced; 1,090 of 1,090 hinted sides and the anchor flips by generation on 100 random pedigrees; a sire with 2 or
3 dams, 18 hints, under three prototypes; validation cases); test drafts run against the final prototype (9 of 9)
and against unchanged HEAD (9 of 9 failing) before RED; GREEN's code proven equal to the prototype; suite 664
tests, 0 failed, WARN 0, SKIP 0; lint 0; roxygen changed `man/makePedigreeMatingLayout.Rd` only; fidelity 600 of
600 identical (no hint); coverage `R/layoutHints.R` 174 of 174 lines; `R CMD check --as-cran` R16's NOTE only; an
order and mate hinted layout drawn by `drawPedigreeDiagram()` keeps its x (20 of 20 nodes; saved to HTML, not viewed
in a browser); CI `43771237000` 5/5 `Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each.
**Self-assessment: 8/10.**
+ Every pre-RED option stated measured counts, and all four were answered at the first try; comparing kinship2's
  offspring row as well as the mates' row found the crossing families and led to R72 (18 of 18 typed cases, 0 of
  197 crossings); the tests' expected values all came from the prototype.
- Slips: kinship2's human wording (husband, wife) in my messages until Mark corrected it; one picker phrase
  overstated Pedixplorer ("invents a mating"), corrected in R70's text; a zsh `( a; b & )` that serialized a
  background run; a crossing counter that first read 0 animals (caught by the zero); one compound command Mark
  rejected; a typed row text that hid repeat nodes, misread for one message before I redrew with them.
**Learnings:** no `CLAUDE.md` row (over its budget); the vocabulary rule became the gate
`user-facing-sire-dam-words`; the reusable traps are in the Gotchas above.
**Ledger:** `CHANGELOG.md` S23 entries.
