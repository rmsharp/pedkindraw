# Divergence from nprcgenekeepr

pedkindraw's copied functions start as copies of nprcgenekeepr's (plan Phases 6-10). Under the drift rule
(`docs/planning/standalone-pedigree-package-plan.md` section 5), a change to a copied function in
either repository is made in the other too, in a session of its own there, or recorded here as a row: the function,
both commits, and why.

`Rscript tools/compareWithNprcgenekeepr.R` lists every copied function whose arguments or code differ from
nprcgenekeepr's, and fails when one has no row here. Help text, comments and layout are not compared; each copied
file's header lists its help-text changes.

| Function | pedkindraw commit | nprcgenekeepr commit | Why |
|---|---|---|---|
| `makePedigreeMatingLayout()` | `b598bcd` (S22, plan Phase 15a); `7889ec8` (S23, plan Phase 15b) | `baef1e12c` (the copy's; unchanged there) | Phase 15 layout hints, R60-R63 (`docs/planning/layout-hints-design.md` section 7.3): the argument `hints = NULL`, `.checkLayoutHints()` after the `kinshipMatrix` check, the row reorder `.layoutHintRows()` after isolated animals are dropped, and `hints` passed to `.positionMatingUnitForest()`. Phase 15b (the mate hint, Mark's S23 picks): `.checkLayoutHints()` takes `ped` (the mate checks need sires, dams and generations), the row reorder only for an order hint, and `hints` passed to `.buildMatingUnitForest()` too. Not mirrored in nprcgenekeepr: pedkindraw's work does not change it (R8), and its Diagram tab takes no hints. |
| `.positionMatingUnitForest()` | `b598bcd` (S22, plan Phase 15a); `7889ec8` (S23, plan Phase 15b) | `baef1e12c` (the copy's; unchanged there) | Phase 15 layout hints, R60-R63: the argument `hints = NULL`, passed to its per-family call; where `hints$order` names a founder of the family, the founder lines are ordered by it (`.layoutHintRoots()`) and `.orderRootSubtrees()` is not called. Phase 15b, the mate hint: `unitChildrenOf()` orders an anchor's matings by their mates' hinted sides (`.layoutHintFamilies()`), the S666 pass takes a hinted mate's side for its `sign`, and the seeding loop takes each hinted mate's side and a distance factor (`.layoutHintSides()`). Not mirrored, as above. |
| `.buildMatingUnitForest()` | `7889ec8` (S23, plan Phase 15b) | `baef1e12c` (the copy's; unchanged there) | Phase 15 layout hints, the mate hint (R60-R61, Mark's S23 picks): the argument `hints = NULL`; before `anchorOf[u] <- winner`, a mating whose `hints$mate` row anchors it on a named partner takes that partner as its anchor (`.layoutHintAnchor()`). Not mirrored, as above. |
| `drawPedigreeDiagram()` | S28 GREEN (plan R81) | `4283e3502` (the copy's; unchanged there) | The legend item (Mark's S26 find: the dividing lines in a multi-condition symbol "are not explained in the legend. It looks like an error."). With two or more conditions each condition's legend row is a section picture (`shape = "image"`, no fill, `.conditionLegendImage()`) instead of a filled hexagon, so the legend says which section of a symbol is which; with no condition or one the legend is unchanged. To be ported to nprcgenekeepr in a session of its own there (Mark's S28 pick, "Port later"): when it lands this row, the next one and `tools/compareResultsWithNprcgenekeepr.R`'s allowance for the condition rows' shape, fill and picture are removed. |
| `.conditionLegendImage()` | S28 GREEN (plan R81) | none: only in pedkindraw | The picture each condition's legend row shows: the Deceased picture's circle cut at `.conditionSectionsHandler()`'s angles, the condition's own section filled. Added to the copied `R/affectedConditions.R` beside that handler, whose angles it uses, so the port puts it in the same place. Port later, as above. |

Every other copied function matches nprcgenekeepr at the commit its file's
header names. The three rows S9 recorded for `R/affectedConditions.R`'s
deferred functions (plan R32) were deleted when Phase 9 copied them (S11); the
row for `drawPedigreeDiagram()` (plan R37: nprcgenekeepr S1159's legend fill,
`392dd347e`, `a85311021` and `4283e3502`) when S12 ported that change.
