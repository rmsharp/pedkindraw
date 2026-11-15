# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 15a: the `order` layout hint**, strict TDD (`methodology/BACKLOG.md:11`; the design
`docs/planning/layout-hints-design.md`; rulings R60-R63 at `docs/planning/standalone-pedigree-package-plan.md:166`-
`:169`; row 15 at `:523`). The orient picker asks Mark: this, **tests for full coverage**
(`methodology/BACKLOG.md:34`, 43 of 2,284 statements missed, `R/` unchanged since `ccc12ca`), or hold.
**Status:** READY. Phase 15's design DONE (S21, `2272b3e`); no code changed since S20 (suite 643 tests, 0 failed,
WARN 0, SKIP 0, 4991 expectations at `ccc12ca`); drift tool 90 functions, 0 differ; pushed through `ccc12ca`; S20's
two close-out commits and S21's three are not pushed.
**Plan:** the design's section 7.1 (`:109`, the interface), 7.2 (`:127`, what `order` does), 7.3 (`:147`, the
code changes), 9 (`:212`, 15a's DONE criteria), 10 (`:249`, open details D1-D5), Appendix A (`:274`, the random
family generator).
**Session boundary:** one session, 15a only; 15b (`spouse`) and 15c (converters) are later sessions
(`methodology/BACKLOG.md:22`, `:28`).
**Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient, run the drift tool (`Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`) and check nprcgenekeepr
   for changes to the three files the build touches since the copy's commit:
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- R/makePedigreeDiagramData.R R/orderRootSubtrees.R
   R/positionTreeApportion.R` (Learning 15).
2. Read the design's sections 4, 7 and 9-10 whole, and the engine lines it cites (`R/makePedigreeDiagramData.R:452`,
   `:620`, `:904`-`:909`, `:927`-`:937`, `:993`-`:1023`, `:1714`-`:1754`; `R/orderRootSubtrees.R:59`).
3. Measure D1-D5 before the pre-RED picker (Learnings 17-19): unnamed animals and ties; which founder's number orders
   a founder couple (kinship2 and Pedixplorer use the female's, M5); when to skip `.orderRootSubtrees()`; the
   validation errors; an order that separates twins (what kinship2 and Pedixplorer draw).
4. A scratch prototype of `R/layoutHints.R` and the call-site lines, the drafts of `test_layoutHintsOrder.R` and
   `helper-layoutHints.R` run against it in a scratch tree before RED (Learning 18), every expected value computed.
5. RED, GREEN, REFACTOR, each gate an `AskUserQuestion`; `DIVERGENCE.md` rows for `makePedigreeMatingLayout()` and
   `.positionMatingUnitForest()`, the file header's change list, contract 4.1's row; the checks of the design's
   section 9 (the fidelity tool too: no hint must give nprcgenekeepr's results); push; CI; "Done 15a" in the plan.

### Gotchas
- **`makePedigreeMatingLayout()` is in `R/makePedigreeDiagramData.R:1670`**, not a file of its own (S20's handoff
  and backlog item named `R/makePedigreeMatingLayout.R`, which does not exist).
- **nprcgenekeepr's layout design documents quote kinship2's source** (e.g. its
  `docs/planning/pedigree-diagram-option2-layout-design-plan.md`, `besthint.R`/`autohint.R` lines). pedkindraw's new
  code is written from help pages only (R14): read their measurements, not their source excerpts. Its
  `docs/planning/pedigree-diagram-sibling-order-appetite-evidence.md` (S686) is safe and was the best single source:
  "every sibling-order lever is ped ROW order".
- **Prototyping a change to a copied function in memory** (the design's Appendix B): read its lines from `R/`, insert
  lines, `eval(parse(text = ...))` in a `new.env(parent = asNamespace("pedkindraw"))`, set the function's environment
  to that env, then `unlockBinding()` and `assign()` it into the namespace; the recursive per-family call then
  reaches the patched copy. `stopifnot()` the line text at each insertion point: S21's first try was one line off.
- **The fixture helpers need the working folder `tests/testthat`** while `asPedFrameFixtures()` runs (it calls
  `test_path()`), not only while the helpers are sourced; wrap `source_test_helpers()` in `invisible()` or it
  prints every helper. Several fixtures name parents with no row of their own: add `M`/`F` rows for them before
  `findGeneration()`, or `makePedigreeMatingLayout()` stops in `preferAnchor()` on an `NA` generation.
- **macOS file names ignore case:** help topics `Hints` and `hints` saved as `Pedixplorer_Hints.txt` and
  `Pedixplorer_hints.txt` are one file; the second overwrote the first (read `Hints-class` instead).
- **`R CMD check --as-cran` from the project root stops at "CRAN incoming feasibility"**: run it from a scratch folder
  with `R_LIBS` and `R_LIBS_USER` set to renv's library and `RENV_PROJECT` unset (`CLAUDE.md`'s table).
- **The scratch-tree recipe:** `git archive HEAD | tar -x -C <tree>`, then `env -u RENV_PROJECT R_LIBS=<lib>
  R_LIBS_USER=<lib> NOT_CRAN=true Rscript --no-init-file ...` from `<tree>`; `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'`.
- **A predicted count is a prediction** until counted (S20's "about 4 lines" was +1; S21's "about 6 lines in 3
  functions" for the whole build is a guess from the prototypes: 4 lines for the side, 1 for the anchor, plus the
  argument plumbing not prototyped).
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S21 added nothing); the reduction is the context-budget
  item's own session (`methodology/BACKLOG.md:84`, R18).
- **Left outside the repository for Mark:** `~/Library/Caches/org.R-project.R/R/renv/library/tree-86aa6c47` (S19's,
  harmless).
- **Times on this Mac (S21):** 200 random family layouts (9-1,776 animals) ~85 s; the 8 fixtures x 5 hints ~31 s;
  the two converter test files ~26 s; suite ~3.5 min; `R CMD check --as-cran` ~3 min.

### Key files
- `docs/planning/layout-hints-design.md` (the design; section lines above).
- `R/makePedigreeDiagramData.R`: `:425` `.buildMatingUnitForest()`, `:452` matings by row, `:481` `preferAnchor()`,
  `:519` `anchorOf[u] <- winner`, `:620` `childEdges`, `:863` `.positionMatingUnitForest()`, `:904` its per-family
  call, `:937` `childrenOf()`, `:1023` the `.orderRootSubtrees()` call, `:1112` the S666 `sign`, `:1290` the
  seeding `side`, `:1576`-`:1579` the male-left help sentence, `:1670` `makePedigreeMatingLayout()`, `:1714` isolated
  rows dropped, `:1753`-`:1754` the forest calls.
- `R/orderRootSubtrees.R:59`; `R/asPedFrame.R:209`, `:311` (the two return sites, for 15c).
- `docs/planning/pedkindraw-api-contract.md:227` (4.6, the pointer to the design); `DIVERGENCE.md` (no rows yet).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S20's entries were removed in S3-S21 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 20 Handoff Evaluation (by Session 21)
**Score: 9/10.**
- **What helped:** the ordered steps became this session's sequence: the drift tool; the backlog item and its
  citations (the gap analysis's `:92`/`:146`, the comparison's `:284`, the plan's `:517`/`:106`, the contract's
  `:229`, all right at Orient); the help-page recipe `tools::Rd2txt(utils:::.getHelpFile(help(t, package = p)))`,
  used as written; "measure before the pickers", which became M1-M8 and made all four pickers answerable at once;
  the open-question list, which became the three design pickers and the DONE-criteria picker. The scratch-tree
  recipe served M8 unchanged.
- **What was missing:** that nprcgenekeepr's S686 study had already shown every ordering lever is the row order of
  `ped` (found after reading the engine); that several fixtures name parents with no row, which the layout cannot
  take.
- **What was wrong:** `R/makePedigreeMatingLayout.R` (step 3 and the backlog item) does not exist; the function is
  in `R/makePedigreeDiagramData.R`. The question "new arguments on `drawPedigreeDiagram()` and
  `makePedigreeDiagramData()`" was framed as open, but neither places animals.
- **ROI:** high.

### What Session 21 Did
**Deliverable:** plan Phase 15's design session: `docs/planning/layout-hints-design.md`, user-suppliable layout
hints (R3), no code; rulings R60-R63.
**Started:** 2026-11-14 17:48 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Layout-hints design
(Recommended)" (orient); "Order + mate placement (Recommended)", "hints argument (Recommended)", "Yes, a third
element (Recommended)" (design); "Approve 3 sessions (Recommended)" (the build plan).
**Commits:** claim `7846b2c`; design, rulings and contract pointer `2272b3e`; close-out after; not pushed.
**Verified:** kinship2's and Pedixplorer's help pages read (`align.pedigree`, `autohint`, `Hints`, `align`,
`auto_hint`, `best_hint`); the engine read where it orders animals; M1-M8 measured (the design's section 5): sorting
rows by a random hint put 190 of 190 fixture and 9,840 of 9,840 random sibships in hinted order; the
founder-reordering step changed 216 of 243 hinted founder orders, 243 of 243 held with it skipped; 71% of random
matings male-left by a fixed rule; scratch prototypes of the side hint (1,090 of 1,090) and the anchor hint (1,936
flipped, 0 errors); a third `asPedFrame()` element fails 9 of 29 converter tests. Every cited line re-read after the
last edit; six errors in the draft corrected before its commit. `quality_ratchet --run` (see the receipt).
**Self-assessment: 8/10.**
+ Every picker option stated a measured result, both spouse-hint halves prototyped rather than guessed, and Mark
  answered all five pickers at the first try; the design names its surface, its checks and its open details.
- Slips: the fixture script failed three times on known traps (the working folder, printed helpers, parents without
  rows); a prototype insertion point one line off; a help file overwritten by a case-insensitive name; M7's 8
  unexamined matings left as D9 rather than resolved; S686's study read after the engine, not before.
**Learnings:** no `CLAUDE.md` row added (over its budget); the one reusable pattern, prototyping a copied function in
memory, is in the design's Appendix B and the gotchas above.
**Ledger:** `CHANGELOG.md` S21 entry.
