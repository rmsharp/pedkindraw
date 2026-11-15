# Layout hints: design (plan Phase 15)

**Date:** 2026-11-14 · **Session:** pedkindraw S21 · **Type:** design session
(`methodology/workstreams/DESIGN_WORKSTREAM.md`), the "design session first (engine-surface design)" of plan row 15
(`docs/planning/standalone-pedigree-package-plan.md`, "| 15 | User-suppliable layout hints"). No package code was
written or changed; the measurements ran on scratch copies in this session's scratchpad. **Status:** rulings R60-R63
made (Mark's picks, section 6); the build is three sessions, 15a-15c (section 9), each its own session under strict
TDD. **Measured at:** `7846b2c` (S21's claim; `R/` identical to `ccc12ca`), kinship2 1.9.6.2, Pedixplorer 1.8.0,
R 4.6.2, this Mac.

---

## 1. What R3 asks

Ruling R3 (plan section 2, Mark S742) puts "user-suppliable layout hints" in the package. The gap it closes is the
kinship2 gap analysis's `autohint` row: "Automatic ordering is built into the layout engine, but there is **no
user-suppliable hint mechanism**: `makePedigreeMatingLayout(ped, edgeStyle, twinRelations)` exposes no
ordering-override argument" (`docs/research/kinship2-feature-gap-analysis-2026-09-20.md`, row 5, and Finding #2:
"the engine auto-orders but accepts no override"). The package comparison lists what the others offer
(`docs/research/pedigree-package-comparison-2026-11.md`, the "Layout (Phase 2)" row): kinship2's
`align.pedigree(ped, packed, width, align, hints)` and `autohint()`, Pedixplorer's `align(obj, ..., hints, ...)`,
`auto_hint()` and `best_hint()`. The contract left the interface to this session
(`docs/planning/pedkindraw-api-contract.md` section 4.6: "Layout hints (R3) are Phase 15, whose design session comes
first").

## 2. Who uses it

- A kinship2 or Pedixplorer user who has tuned a drawing with hints and wants the same drawing here: siblings in a
  chosen order, one family left of another, a husband and wife the other way round.
- A data-frame user (pedkindraw's own input, R7) who wants "put this sibling first" or "draw this dam on the left"
  without learning the engine's rules.
- A user converting an object with `asPedFrame()` whose hints should come across with it.

What they do not need: an automatic search for a better order (the engine already orders by itself, section 8), or
hints for the two functions that place nothing (`makePedigreeDiagramData()` sets no x positions, only a generation
`level`; `drawPedigreeDiagram()` draws a finished layout at its fixed positions, `visNodes(physics = FALSE)`,
`R/drawPedigreeDiagram.R:163`). Only `makePedigreeMatingLayout()` places animals.

## 3. What kinship2 and Pedixplorer offer (their help pages only, R14)

| | kinship2 1.9.6.2 | Pedixplorer 1.8.0 |
|---|---|---|
| Where hints live | `ped$hints`, a list attached by the user (`align.pedigree(..., hints = ped$hints)`) | the `hints` slot of a `Pedigree` (`hints(x)`, `horder(x)`, `spouse(x)`), or `align(..., hints =)` |
| Order | `order`: "a numeric vector with one element per subject in the pedigree. It determines the relative order of subjects within a sibship, as well as the relative order of processing for the founder couples. (For this latter, the female founders are ordered as though they were sisters)" | `horder`: the same, "a named numeric vector ... The names of the vector should be the individual identifiers" |
| Spouse | `spouse`: "a matrix with one row per hinted marriage ... the index of the left spouse, the right hand spouse, and the anchor: 1=left, 2=right, 0=either. Children will preferentially appear under the parents of the anchored spouse" | `spouse`: a data frame with `idl`, `idr`, `anchor` (1, 2, 0), the same meaning |
| No hints given | "the `autohint` routine is called to supply an initial guess" | "the `auto_hint()` routine is called" |
| Automatic search | `autohint()` | `auto_hint()`; `best_hint()` tries "all possible founder orders" for the least "stress" (timeout 60 s) |

Only the order of the numbers matters ("The actual values in the vector are not important, only their order",
kinship2's `autohint` help). A `Pedigree()` built without hints holds an empty `horder` (`numeric(0)`) and no
`spouse` rows (measured, M8).

## 4. Where the copied engine sets left-to-right order today

The layout code is copied from nprcgenekeepr (plan Phase 8, `R/makePedigreeDiagramData.R`,
`R/orderRootSubtrees.R`, `R/positionTreeApportion.R`, at nprcgenekeepr `baef1e12c`). Read for this design; line
numbers at `7846b2c`:

| What | Set by | Where |
|---|---|---|
| Matings (mating units) | first appearance of each sire-dam pair in the rows of `ped` | `R/makePedigreeDiagramData.R:452` ("D1 step 1") |
| Which partner anchors a mating (the one whose own place the children hang under) | a fixed rule: deeper generation, then fewer matings, then id in byte order | `:481` (`preferAnchor()`), `:519` (`anchorOf[u] <- winner`) |
| Sibling order | the rows of `ped`: children enter `childEdges` in row order, and `childrenOf()` reads them in that order | `:620`, `:927`-`:937` |
| Separate families | packed left to right by the smallest row of `ped` among their members | `:647` (`.forestComponents()` help), `:904`-`:909` |
| Founder order within a family | the rows of `ped` (`founderIds`, `rootIds`), then permuted by the founder-reordering step `.orderRootSubtrees()` when a family has 3 or more founder lines joined by repeat-node connectors and a strictly shorter order exists | `:993`, `:1015`, `:1023`; `R/orderRootSubtrees.R:59` |
| Which side a mate is drawn on | the male on the left for a simple mating (each partner has this one mating, one M and one F); otherwise the side of the children; an animal's first two matings left and right | `:1112` (the S666 pass's `sign`), `:1284`-`:1305` (the seeding loop's `sexSide` and `side`) |
| The final positions | a quadratic program that keeps each row's left-to-right order (sorted by generation, then first position, then id) | `:1353` (`.separationOrder()`) |

The help page says the male-left rule "cannot be turned off" (`:1576`-`:1579`). nprcgenekeepr's own study (its
`docs/planning/pedigree-diagram-sibling-order-appetite-evidence.md` section 1, S686) found the same: "every
sibling-order lever is ped ROW order", written before the founder-reordering step was added (its S690).

## 5. Measurements (Learnings 17-19, before the pickers)

Each ran from the project root with the package loaded by `pkgload::load_all()`; the random family pedigrees come
from the generator in Appendix A; "rows sorted" means `ped[order(hint[ped$id], seq_len(nrow(ped))), ]`.

| # | What | Result |
|---|---|---|
| M1 | An 8-animal pedigree (A x B have C, D, E; D x F have G, H), drawn by all three | No hints: all three draw `A B` / `C D F E` / `G H`. pedkindraw with the sibling rows reversed draws `E D F C` / `H G`, the same as kinship2's `align.pedigree()` and Pedixplorer's `align()` with an order hint E < D < C, H < G. With B's row before A's, pedkindraw still draws `A B` (male left); kinship2 with a spouse hint B left of A draws `B A`; kinship2 and Pedixplorer with F left of D draw `C F D E`. |
| M2 | The 8 fixture pedigrees (examplePedigree's 3,694 animals left out: past the drawing's measured limit), 5 random order hints each, rows sorted | Every sibship drawn in hinted order: 190 of 190 (38 sibships with 2 or more drawn children, 5 hints each). Repeat-node counts unchanged. With the rows as given, the founder-reordering step changed one family's founder order in 4 of the 8 fixtures (the 280- and 375-animal ones); with random hints it changed 29 of the 90 families laid out. |
| M3 | 200 seeded random family pedigrees (9 to 1,776 animals), one random order hint each, rows sorted | 9,840 of 9,840 sibships in hinted order, 7,241 of them with 3 or more children. Of 1,047 families laid out, 243 had 3 or more founder lines, and the founder-reordering step changed the hinted order in 216 of those. 84 s for the whole run. |
| M4 | M3 with the founder-reordering step replaced by a stand-in that returns its input | Founder order as hinted in 243 of 243 families; sibships still 9,840 of 9,840. Of 11,449 matings, 8,183 (71%) are simple (both partners have rows, each has this one mating, one M and one F), so the male-left rule fixes their sides. |
| M5 | Three founder couples joined by their children's matings (A x B, X x Y, P x Q; C x Z, R x K) | kinship2 and Pedixplorer order founder families by the female founder's number (Q < Y < B gives `X Y A B` on the top row); the males' numbers did not reorder them. Both draw the founder couple P x Q on the second row, above their son R, who is drawn on his mate K's row; pedkindraw draws every founder on the top row. pedkindraw's founder lines start at each couple's anchor (here A, X, P: the male, by id order); rows sorted by the males' numbers P < X < A give `X Y A B P Q` with the founder-reordering step and `P Q X Y A B` (as hinted) without it. |
| M6 | A scratch prototype of a spouse-side hint: at the two places the engine sets a mate's side (`:1112`, `:1290`), a hinted mating takes the hinted side (Appendix B) | The 8-animal pedigree draws `B A` and `C F D E`, as kinship2 does. 100 random pedigrees, a fifth of the matings each hinted to the side opposite the one drawn without hints: 1,090 of 1,090 drawn on the hinted side, 785 of them simple matings. |
| M7 | A scratch prototype of an anchor hint: one line before `:519` makes the hinted partner the anchor (Appendix B) | 100 random pedigrees; in the 99 with matings whose two partners both have parents, every such mating's anchor was flipped (1,936): 0 layout errors; 49 warnings without the hints and 45 with (their text not read); repeat-node counts unchanged in all 99. In 1,928 of the 1,936 the mating's dot sat nearer the hinted anchor's own node than the other partner's, with the other partner drawn there as a repeat node; the 8 others were not examined (D9). |
| M8 | Converters: `asPedFrame()` returning a third element `hints = NULL`, in a scratch tree | 5 of the 15 tests in `test_asPedFrame.R` and 4 of the 14 in `test_asPedFramePedixplorer.R` fail (585 expectations), each comparing the whole returned list. `Pedixplorer::Pedigree()` without hints holds `horder` `numeric(0)` and 0 `spouse` rows. |

## 6. Rulings (recorded in the plan's section 2)

- **R60** -- what hints change (Mark's pick, "Order + mate placement (Recommended)"): everything kinship2's and
  Pedixplorer's hints change. An order (a number per animal) sets the order of siblings, of separate families and of
  founder couples within a family, the founder-reordering step being skipped where the hint orders founders; a
  spouse hint sets which side a mate is drawn on and which partner anchors the mating. Without hints the drawing is
  unchanged. Measured: M1-M7.
- **R61** -- how hints are given (Mark's pick, "hints argument (Recommended)"): a new argument
  `makePedigreeMatingLayout(..., hints = NULL)`, `hints` a list with `order` (a numeric vector named by animal id)
  and `spouse` (a data frame with `left`, `right`, `anchor`). `drawPedigreeDiagram()` and
  `makePedigreeDiagramData()` take none. The copied functions changed are recorded in `DIVERGENCE.md`; nprcgenekeepr
  is not changed (R8).
- **R62** -- converters (Mark's pick, "Yes, a third element (Recommended)"): `asPedFrame()` returns
  `list(ped, twinRelations, hints)`, the object's hints turned into R61's form, or `NULL` when it holds none.
  Measured: M8.
- **R63** -- the build: three sessions, 15a (order), 15b (spouse hints), 15c (converters), with section 9's DONE
  criteria (Mark's approval of this design).

## 7. The design

### 7.1 The interface

```r
makePedigreeMatingLayout(ped, edgeStyle = c("rectilinear", "direct"),
                         twinRelations = NULL, kinshipMatrix = NULL,
                         hints = NULL)
```

`hints` is `NULL` (the default: the layout exactly as today) or a list with one or both of:

- `order`: a numeric vector named by ids in `ped`. Only the order of the numbers matters.
- `spouse`: a data frame, one row per hinted mating, with the character columns `left` and `right` (the ids of two
  animals that are the sire and dam of at least one child in `ped`, in either role) and `anchor` (`"left"`,
  `"right"` or `"either"`).

The names follow kinship2's (`order`, `spouse`); the ids, not positions, follow Pedixplorer's, because pedkindraw's
input is a data frame keyed by `id`.

### 7.2 What each part does

`order`:

1. The rows of `ped` are sorted by the hint's numbers before the layout, keeping the row order among equal numbers
   (D1 settles unnamed animals). Since the engine reads row order (section 4), this alone puts siblings and separate
   families in hinted order (M2, M3).
2. Founder couples within a family are ordered by the hint, and the founder-reordering step is skipped there (M4;
   D2 settles which founder's number counts, D3 when the step is skipped).
3. A parent's own matings follow from its children's order (the engine sorts an animal's matings by their children's
   mean position, `:1279`, and draws the first on its left and the second on its right, `:1298`-`:1301`).

`spouse`:

1. `left` is drawn left of `right` at that mating: the side the engine gives the mate relative to the anchor is
   replaced at both places it is set (`:1112`, `:1290`), including the male-left rule for simple matings (M6).
2. `anchor = "left"` or `"right"` makes that partner the anchor: the children hang under its own place, and the
   other partner, when it has parents of its own, is drawn beside it as a repeat node (M7). `"either"` keeps the
   engine's rule (`:481`).

### 7.3 Code changes

New code, pedkindraw's own (R3), written from kinship2's and Pedixplorer's help pages and these measurements, their
source not read (R14): `R/layoutHints.R`, the
internal helpers, for example `.checkLayoutHints()` (validation, plain error messages), `.layoutHintRows()` (the
sort), `.layoutHintKeepsRoots()` (whether to skip the founder-reordering step), `.layoutHintSide()` and
`.layoutHintAnchor()` (the spouse lookups). Each build session names its helpers at its pre-RED picker.

Copied functions, each changed by call-site lines only, so that a later port from nprcgenekeepr meets as few changed
lines as possible (Learning 16):

| Function | Change | Session |
|---|---|---|
| `makePedigreeMatingLayout()` | the `hints` argument and its help; `.checkLayoutHints()`; the row sort after isolated animals are dropped (`:1714`); `hints` handed to the two functions below (`:1753`, `:1754`) | 15a (spouse pass-through 15b) |
| `.positionMatingUnitForest()` | a `hints = NULL` argument handed to its per-family call (`:904`); the founder-reordering call (`:1023`) skipped where the hint orders founders | 15a |
| `.positionMatingUnitForest()` | the hinted side at `:1112` and `:1290` | 15b |
| `.buildMatingUnitForest()` | a `hints = NULL` argument; the hinted anchor before `:519` | 15b |

The copied tests call `.buildMatingUnitForest(ped)` and `.positionMatingUnitForest(ped, forest)` directly; the
`NULL` defaults keep them unchanged. `R/makePedigreeDiagramData.R`'s header lists each change; its help sentence "It
cannot be turned off" gains "unless a spouse hint says otherwise" (15b).

**Drift rule (plan section 5): a `DIVERGENCE.md` row for each changed function, not a mirror in nprcgenekeepr.**
Why: pedkindraw's work does not change nprcgenekeepr (R8, plan section 1.3); pedkindraw is a sibling product first
(R1); nprcgenekeepr's Diagram tab takes no hints, so the change has no use there today. Each row names the function,
the pedkindraw commit, nprcgenekeepr's `baef1e12c` (the copy's commit; unchanged there) and "Phase 15 layout hints,
R60-R63". If nprcgenekeepr later wants hints, porting them is a session of its own there (Mark's call).

### 7.4 Converters (15c)

`asPedFrame()` gains a third element, `hints`:

- kinship2: `x$hints$order` (one number per subject, in the object's order) named by id; `x$hints$spouse` (rows of
  subject indices and anchor 1, 2, 0) as ids with `"left"`, `"right"`, `"either"`.
- Pedixplorer: `horder(x)` (already named by the object's ids, `<famid>_<id>` with families as R58 keeps them) and
  `spouse(x)` (`idl`, `idr`, `anchor`) likewise.
- `NULL` when the object holds neither (a `Pedigree()` built without hints, M8).

R58's "a list of two" becomes three; contract section 4.5 is updated in 15c.

## 8. Not included, and why

| Left out | Why |
|---|---|
| An automatic hint search (kinship2's `autohint()`, Pedixplorer's `auto_hint()` and `best_hint()`) | R3 asks for hints a user supplies. The engine already orders by itself (row order and the founder-reordering step), and nprcgenekeepr's S686 measured a single-pass kinship2-autohint analogue making the connector ink worse every round on a 375-animal colony (its evidence document, section 4) |
| Hints for `makePedigreeDiagramData()` | it sets no x positions, only a generation `level` (`R/makePedigreeDiagramData.R:58`-`:164`) |
| Hints for `drawPedigreeDiagram()` | it draws a finished layout at fixed positions (`R/drawPedigreeDiagram.R:163`) |
| Moving an animal to another generation row (kinship2 and Pedixplorer draw a founder couple lower, above a son drawn on his mate's row, M5) | not part of either package's hints; pedkindraw draws founders on the top row by its own layout rule |
| kinship2's and Pedixplorer's `packed`, `width`, `align`, `align_parents` | layout options, not hints |
| A spouse hint for a pair with no child together (Pedixplorer's relation code 4) | the engine draws a mating only where a pair has a child (`:452`); such a hint is an error (D6) |
| Dragging animals in the drawn widget | interaction with a drawing, not a hint to the layout |

## 9. The build: three sessions (R63)

Every session: strict TDD (RED, GREEN, REFACTOR, each gate an `AskUserQuestion`), every expected value computed with
a scratch prototype before RED (Learning 18), its open details (section 10) settled at its pre-RED picker with
measured options (Learning 17), compared with kinship2 and Pedixplorer only where they return (Learning 19).
**Surface:** this Mac and CI (Linux, macOS, Windows). Order is checked on the layout's x positions, which the widget
draws unchanged (`physics = FALSE`); no new browser test is needed (the existing ones skip where Chrome is absent).
**Checks** (`CLAUDE.md`, "Build / Test / Verify"): the suite 0 failed, WARN 0; `lint_package()` 0; roxygen leaves
`NAMESPACE` and `man/` as committed; `R CMD check --as-cran` from a scratch folder R16's NOTE only; coverage, every
statement of `R/layoutHints.R` reached; the drift tool exit 0, the functions it lists as differing exactly those
with rows; the fidelity tool `tools/compareResultsWithNprcgenekeepr.R` exit 0 (no hint given, results identical to
nprcgenekeepr's); CI 5/5.

**15a -- order (one session; close out when done).** DONE when:

1. `makePedigreeMatingLayout()` takes `hints = NULL` with `order`; `R/layoutHints.R` holds the helpers.
2. A new test file `tests/testthat/test_layoutHintsOrder.R` and a helper `helper-layoutHints.R` (Appendix A's
   generator) test: the 8-animal pedigree of M1 (an order E < D < C, H < G draws `E D F C` / `H G`); separate
   families in hinted order; M5's founder couples in hinted order; on 100 seeded random family pedigrees every
   sibship and every family's founder lines in hinted order, with a floor on how many were checked
   (`expect_gte()`); `hints = NULL` and `hints = list()` give the layout of no hint; each error D4 rules.
3. Where kinship2 is installed: on the typed cases, each row's left-to-right order equals kinship2's
   `align.pedigree()` with the same order hint wherever their rows hold the same animals (M1 equal).
4. The copied test files unchanged; `DIVERGENCE.md` rows for `makePedigreeMatingLayout()` and
   `.positionMatingUnitForest()`; the file header lists the change; the contract's section 4.1 row for
   `makePedigreeMatingLayout()` shows `hints`.
5. The checks above; the plan's "Done 15a" record and status.

**15b -- spouse hints (one session; close out when done).** DONE when:

1. `hints$spouse` sets the side and the anchor (section 7.2); the help sentence is amended.
2. Tests in `tests/testthat/test_layoutHintsSpouse.R`: the 8-animal pedigree (`B A` for B left of A, `C F D E` for F
   left of D, as kinship2 draws them, M6); on 100 seeded random family pedigrees a fifth of the matings hinted to the
   side opposite the unhinted drawing, every one drawn on its hinted side; anchors flipped as in M7, the layout
   without error and the other partner a repeat node beside the hinted anchor; each error D6 rules; D7 and D9
   settled before RED.
3. `DIVERGENCE.md` row for `.buildMatingUnitForest()`, `.positionMatingUnitForest()`'s row updated.
4. The checks above; the plan's "Done 15b" record.

**15c -- converters (one session; close out when done).** DONE when:

1. `asPedFrame()` returns `hints` for kinship2's `pedigree` (and `pedigreeList`, as D8 rules) and Pedixplorer's
   `Pedigree`, `NULL` when none.
2. Tests: typed conversions of order and spouse hints from each package; the 9 converter tests of M8 expect the third
   element; where each package is installed, an object with hints through `asPedFrame()` and
   `makePedigreeMatingLayout(x$ped, hints = x$hints)` draws each row in the order kinship2's `align.pedigree()` or
   Pedixplorer's `align()` gives with those hints, on the typed cases where they return.
3. Contract section 4.5 and R58's return updated.
4. The checks above; the plan's "Done 15" record; Phase 15 DONE.

## 10. Open details for the build sessions' pre-RED pickers

| # | Question | Session | What to measure first |
|---|---|---|---|
| D1 | Animals the `order` does not name, and equal numbers | 15a | kinship2 and Pedixplorer want one number per subject; candidates: unnamed after named, in row order; or each unnamed animal keeps its row's place among the named |
| D2 | Which founder's number orders a founder couple | 15a | kinship2 and Pedixplorer use the female's (M5); pedkindraw's founder line starts at the couple's anchor; candidates: the anchor's own number, the female's, the smaller of the two |
| D3 | When the founder-reordering step is skipped | 15a | whenever `order` is given, or only in a family where `order` names a founder |
| D4 | Validation of `hints` and `order` | 15a | names not in `ped`; `NA`; not numeric; a name twice; unknown list elements; an empty list |
| D5 | An order that puts another sibling between twins | 15a | what kinship2 and Pedixplorer draw; whether the twin connector then crosses a sibling |
| D6 | Validation of `spouse` | 15b | a pair with no child together; a partner with no row of its own; the same pair twice; anchor values; two matings of one animal hinted to the same side (their seeds tie) |
| D7 | An anchor hint on a mating whose partners are at different generations | 15b | M7 flipped only matings whose partners both have parents; generations not compared |
| D8 | kinship2's `pedigreeList` hints; Pedixplorer's family-prefixed ids in `horder` names | 15c | what each object holds after its user sets hints |
| D9 | M7's 8 matings not drawn beside the hinted anchor by its rough test | 15b | print one and look at it before RED |

## 11. Risks

| Risk | Where it bites | Countermeasure |
|---|---|---|
| A later nprcgenekeepr change to one of the three functions | porting it (Learning 16): `patch -F0` refuses a hunk whose context includes a hint line | call-site lines only (section 7.3); the rows name them; port by hand where a hunk meets one |
| A hint makes a drawing worse (crossings, long connectors) | the user's drawing | the user's choice; the help says the engine's own order is used without hints, and that a hinted founder order turns off the founder-reordering step |
| The male-left rule nprcgenekeepr ruled for its default (its issue #145) is overridden | 15b | only by a user's spouse hint; the default is unchanged (no hint, identical layout) |
| The scratch numbers are measurements of prototypes, not of the build | 15a-15b | each build re-measures them as tests before RED (Learnings 18-21) |

---

## Appendix A -- the random family pedigree generator (M3, M4, M6, M7)

Each generation pairs males with females from the pool; about one male in 6 takes a second, marry-in mate; each
couple has 1 to 6 children; about one child in 12 has only its sire known; half as many marry-ins as children join
the next pool; the rows end in random order.

```r
randomFamilies <- function(seed) {
  set.seed(seed)
  nGen <- sample(2:4, 1L)
  nextId <- 0L
  newId <- function(k) {
    ids <- paste0("I", nextId + seq_len(k)); nextId <<- nextId + k; ids
  }
  fId <- newId(sample(4:10, 1L))
  ped <- data.frame(id = fId, sire = NA_character_, dam = NA_character_,
                    sex = rep(c("M", "F"), length.out = length(fId)),
                    stringsAsFactors = FALSE)
  pool <- ped$id
  for (g in seq_len(nGen)) {
    males <- intersect(pool, ped$id[ped$sex == "M"])
    females <- intersect(pool, ped$id[ped$sex == "F"])
    nCouples <- min(length(males), length(females))
    if (nCouples == 0L) break
    males <- sample(males)[seq_len(nCouples)]
    females <- sample(females)[seq_len(nCouples)]
    second <- males[runif(nCouples) < 1 / 6]
    if (length(second) > 0L) {
      mi <- newId(length(second))
      ped <- rbind(ped, data.frame(id = mi, sire = NA_character_,
                                   dam = NA_character_, sex = "F",
                                   stringsAsFactors = FALSE))
      males <- c(males, second)
      females <- c(females, mi)
    }
    kids <- character()
    for (k in seq_along(males)) {
      nk <- sample(1:6, 1L)
      kid <- newId(nk)
      s <- rep(males[k], nk)
      d <- rep(females[k], nk)
      d[runif(nk) < 1 / 12] <- NA
      ped <- rbind(ped, data.frame(id = kid, sire = s, dam = d,
                                   sex = sample(c("M", "F"), nk, TRUE),
                                   stringsAsFactors = FALSE))
      kids <- c(kids, kid)
    }
    mi <- newId(max(1L, length(kids) %/% 2L))
    ped <- rbind(ped, data.frame(id = mi, sire = NA_character_,
                                 dam = NA_character_,
                                 sex = sample(c("M", "F"), length(mi), TRUE),
                                 stringsAsFactors = FALSE))
    pool <- c(kids, mi)
  }
  ped <- ped[sample(nrow(ped)), ]
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}
```

A random order hint for seed `s`: `set.seed(1000L + s); hint <- stats::setNames(sample(nrow(f)), f$id)`. A sibship:
the children sharing a sire and dam, or a single known parent, with 2 or more drawn.

## Appendix B -- the prototype lines (M6, M7; scratch only, never committed)

The copied function's lines were read from `R/makePedigreeDiagramData.R`, these lines inserted, and the result
evaluated in an environment whose parent is pedkindraw's namespace and bound there in place of the original. The hint
tables were plain lists keyed by `paste(sire, dam)`: `.sideHint` (the mate's side relative to the anchor, -1 left,
1 right) and `.anchorHint` (the anchor's id).

M6, in `.positionMatingUnitForest()`, after the S666 pass's `sign` (`:1112`-`:1113`) and before
`if (side == 0.0) next` (`:1305`):

```r
hk <- paste(matingUnits$sire[matingUnits$id == u], matingUnits$dam[matingUnits$id == u])
if (!is.null(.sideHint[[hk]])) sign <- as.integer(.sideHint[[hk]])
# ...
hk <- paste(matingUnits$sire[matingUnits$id == u], matingUnits$dam[matingUnits$id == u])
if (!is.null(.sideHint[[hk]])) side <- .sideHint[[hk]]
```

M7, in `.buildMatingUnitForest()`, before `anchorOf[u] <- winner` (`:519`):

```r
hk <- paste(p1, p2); if (!is.null(.anchorHint[[hk]]) && p1Real && p2Real) winner <- .anchorHint[[hk]]
```
