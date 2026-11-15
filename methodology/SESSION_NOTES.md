# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 15b: the `spouse` layout hint**, strict TDD (`methodology/BACKLOG.md:11`; the design
`docs/planning/layout-hints-design.md`; rulings R60-R69 at `docs/planning/standalone-pedigree-package-plan.md:167`-
`:176`; row 15 at `:530`). The orient picker asks Mark: this, **tests for full coverage**
(`methodology/BACKLOG.md:28`, 43 of 2,341 statements missed), or hold.
**Status:** READY. Phase 15a DONE (S22: RED `0ab1230`, GREEN `b598bcd`, rows `a992463`, REFACTOR `b9567bd`); suite
655 tests, 0 failed, WARN 0, SKIP 0, 5,066 expectations; drift tool 2 differ, both with rows; pushed through
`b9567bd`, CI run `43732712028` 5/5 at the first attempt; S22's close-out commits are not pushed.
**Plan:** the design's section 7.2 (`:127`, what `spouse` does: `left` drawn left of `right`, `anchor` picks the
partner the children hang under), 7.3 (`:147`), 9 (`:227`, 15b's DONE criteria), 10 (D6 `:258`, D7 `:259`, D9
`:261`), Appendix B (`:337`, the prototype lines, their numbers at `7846b2c`).
**Session boundary:** one session, 15b only; 15c (converters) is the next (`methodology/BACKLOG.md:22`).
**Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 2 differ, 0 without a row); `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   R/makePedigreeDiagramData.R R/orderRootSubtrees.R R/positionTreeApportion.R` (Learning 15), again at each gate.
2. Read the design's sections 7.2-7.3, 9 and 10 (D6, D7, D9) and Appendix B, then the engine where 15b changes it
   (Key files): the anchor rule and `anchorOf[u] <- winner`, the S666 pass's `sign`, the seeding loop's `side`.
3. Measure D6, D7, D9 before the pre-RED picker (Learnings 17-19): validation of `spouse`; an anchor hint across
   generations; print one of M7's 8 unexamined matings. Compare with kinship2's `align.pedigree(hints = list(spouse =
   ))` and Pedixplorer's `Hints(spouse = )` on typed cases (M6's `B A` and `C F D E` on the 8-animal case).
4. Prototype in a scratch tree (recipe in Gotchas), draft `test_layoutHintsSpouse.R` against it, every expected value
   computed, then run the drafts against an unchanged HEAD tree for the RED proof.
5. RED, GREEN, REFACTOR, each gate an `AskUserQuestion`; `.checkLayoutHints()` accepts `spouse` (R68 stops on it
   today); a `DIVERGENCE.md` row for `.buildMatingUnitForest()`, the two S22 rows updated; the help sentence "It
   cannot be turned off" amended; contract 4.1's row; the checks (fidelity tool: no hint gives nprcgenekeepr's
   results); push; CI; "Done 15b" in the plan.

### Gotchas
- **A later layout pass can move a whole founder line** after the roots are ordered: seed 28 with the anchor's
  number had roots `I2, I1` and drew I1's family first. So test founder order on the drawing's x, not on `rootIds`;
  a spouse hint that flips sides may meet the same pass (the S666 conditional shift).
- **kinship2 refuses a child with one known parent** ("Subjects must have both a father and mother, or have
  neither"); the design's generator makes such children (about 1 in 12 dams NA). To compare with kinship2 on random
  pedigrees, give each such child a founder row for the missing parent, and draw that same completed pedigree in
  both. Even then kinship2's rows agree with pedkindraw's rarely, with or without hints (no hint: top row 9 of 135),
  so compare with kinship2 on typed cases (R69).
- **Pedixplorer ignores what it cannot use:** an `horder` naming only some animals is ignored whole, unknown names
  are dropped, a repeated name keeps its first; with twins present it drew `C D E F` for every order. Its `Hints()`
  refuses `NA`. Check what it does with a `spouse` data frame before citing it.
- **zsh does not split an unquoted `$var` into words:** `for a in "1 25"; do run.sh $a` passes one argument "1 25".
  Pass two variables (`$lo $hi`).
- **Rectilinear edges route a line around a node in its way**: the twin edge C to E became `C -> __jog_1_a ->
  __jog_1_b -> E`. Check an edge by `edgeStyle = "direct"` or by its label.
- **The scratch-tree recipe:** `git archive HEAD | tar -x -C <tree>`, edit there, then `env -u RENV_PROJECT
  R_LIBS=<lib> R_LIBS_USER=<lib> NOT_CRAN=true Rscript --no-init-file ...` from `<tree>`; `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'`. Patch a copied file with a script that `stopifnot()`s each line's text
  before changing it; prove the GREEN code equals the prototype (`deparse()` of each function after `sys.source()`).
- **`R CMD check --as-cran` from the root stops at "CRAN incoming feasibility"**: run it from a scratch folder
  (`CLAUDE.md`'s table).
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S22 added nothing); the reduction is the context-budget
  item's own session (`methodology/BACKLOG.md`, "Point the context-budget tool").
- **Left outside the repository for Mark:** `~/Library/Caches/org.R-project.R/R/renv/library/tree-86aa6c47` (S19's,
  harmless).
- **Times on this Mac (S22):** `test_layoutHintsOrder.R` ~43 s (its 100 random pedigrees ~40 s, `skip_on_cran()`);
  suite ~2 min; fidelity tool ~4 min; `covr` ~4 min; `R CMD check --as-cran` ~4 min; 25 random pedigrees x 3
  variants with kinship2 ~3 min per process (4 run in parallel).

### Key files
- `docs/planning/layout-hints-design.md` (the design; section lines above).
- `R/layoutHints.R`: `:19` `.checkLayoutHints()` (`:36` the known elements, `order` only), `:84`
  `.layoutHintPlaces()`, `:102` `.layoutHintRows()`, `:116` `.layoutHintKeepsRoots()`, `:137` `.layoutHintRoots()`.
- `R/makePedigreeDiagramData.R`: `:430` `.buildMatingUnitForest()`, `:486` `preferAnchor()`, `:524`
  `anchorOf[u] <- winner`, `:863` `.positionMatingUnitForest()`'s `@param hints`, `:915` hints to the per-family
  call, `:1032` the founder-step branch, `:1126` the S666 pass's `sign`, `:1298` `sexSide`, `:1304` `side`, `:1593`
  "It cannot be turned off", `:1629` `makePedigreeMatingLayout()`'s `@param hints`, `:1722` the check, `:1746` the
  row reorder, `:1786` hints to `.positionMatingUnitForest()`.
- `tests/testthat/test_layoutHintsOrder.R` and `helper-layoutHints.R` (the generator `layoutHintsFamilies()`, the
  checkers, `layoutHintsKinship2Rows()`, `layoutHintsRowsAgree()`): 15b's file reuses the helper.
- `DIVERGENCE.md:14`-`:15` (S22's rows); `docs/planning/pedkindraw-api-contract.md:129` (4.1's row), `:229` (4.6).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S21's entries were removed in S3-S22 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 21 Handoff Evaluation (by Session 22)
**Score: 9/10.**
- **What helped:** the five ordered steps became this session's sequence exactly; every engine line cited
  (`:452`, `:620`, `:904`-`:909`, `:927`-`:937`, `:993`-`:1023`, `:1714`-`:1754`, `:519`, `:1112`, `:1290`,
  `:1579`) was right at `8ee4922`; the gotcha that `makePedigreeMatingLayout()` lives in
  `R/makePedigreeDiagramData.R`; the scratch-tree recipe and "R CMD check from a scratch folder", used as written;
  D1-D5 named with what to measure, which made both pickers answerable at once.
- **What was missing:** that kinship2 refuses the generator's one-parent children (2 of 100 random comparisons
  returned until each such child got a founder row); that kinship2's rows differ from pedkindraw's on random
  pedigrees even without hints (top row 9 of 135), which decides where a kinship2 comparison can mean anything.
- **What was wrong:** nothing found. The design's DONE criterion 3 ("each row equal to kinship2's wherever their
  rows hold the same animals") could not hold for the 13-animal case's bottom row; Mark ruled its reading (R69).
- **ROI:** high.

### What Session 22 Did
**Deliverable:** plan Phase 15a, the `order` layout hint: `makePedigreeMatingLayout(..., hints = list(order = ))`,
strict TDD; rulings R64-R69.
**Started:** 2026-11-14 20:52 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 15a: order hint
(Recommended)" (orient); "They keep their rows", "The female's", "Where it names a founder", "Draw it as ordered",
"Strict", "Top two rows there" (pre-RED, each the recommended option); "Yes, proceed" at RED, GREEN, REFACTOR.
**Commits:** claim `8ee4922`; RED `0ab1230`; GREEN `b598bcd`; divergence rows and contract `a992463`; REFACTOR
`b9567bd`; pushed (with S20's and S21's close-out commits); close-out after, not pushed.
**Verified:** D1-D5 measured on a scratch prototype against kinship2 and Pedixplorer (99 and 200 random pedigrees, a
13-animal case over all 720 founder orders, a no-hint baseline); the test drafts run against the prototype (12 of
12) and against unchanged HEAD (12 of 12 failing) before RED; GREEN's code proven equal to the prototype; suite 655
tests, 0 failed, WARN 0, SKIP 0; lint 0; roxygen changed `man/makePedigreeMatingLayout.Rd` only; fidelity 600 of 600
identical (no hint); coverage `R/layoutHints.R` 52 of 52; `R CMD check --as-cran` R16's NOTE only; a hinted layout
drawn by `drawPedigreeDiagram()` keeps its x (runtime check); CI `43732712028` 5/5 `Status: OK` at the first attempt, `FAIL 0 |
WARN 0` on each.
**Self-assessment: 8/10.**
+ Every picker option stated a measured count, both pickers answered at the first try, and the tests' expected
  values came from the prototype; a draft expectation (M1's kinship2 top row) and two prototype bugs (`[[` on an
  unnamed founder, `vapply()` on an integer order) were caught before RED.
- Slips: the first parallel run lost to zsh word splitting; a first side-effect measure too blunt and a tie artifact
  in a checker, each re-measured before the picker; two lint hits fixed in GREEN; one temporary file written to
  `/tmp` instead of the scratchpad.
**Learnings:** no `CLAUDE.md` row added (over its budget); the reusable traps are in the Gotchas above.
**Ledger:** `CHANGELOG.md` S22 entries.
