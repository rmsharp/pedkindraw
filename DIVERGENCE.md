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
| `makePedigreeMatingLayout()` | `b598bcd` (S22, plan Phase 15a) | `baef1e12c` (the copy's; unchanged there) | Phase 15 layout hints, R60-R63 (`docs/planning/layout-hints-design.md` section 7.3): the argument `hints = NULL`, `.checkLayoutHints()` after the `kinshipMatrix` check, the row reorder `.layoutHintRows()` after isolated animals are dropped, and `hints` passed to `.positionMatingUnitForest()`. Not mirrored in nprcgenekeepr: pedkindraw's work does not change it (R8), and its Diagram tab takes no hints. Phase 15b passes the spouse hint on here too. |
| `.positionMatingUnitForest()` | `b598bcd` (S22, plan Phase 15a) | `baef1e12c` (the copy's; unchanged there) | Phase 15 layout hints, R60-R63: the argument `hints = NULL`, passed to its per-family call; where `hints$order` names a founder of the family, the founder lines are ordered by it (`.layoutHintRoots()`) and `.orderRootSubtrees()` is not called. Not mirrored, as above. Phase 15b adds the spouse hint's side of a mate here. |

Every other copied function matches nprcgenekeepr at the commit its file's
header names. The three rows S9 recorded for `R/affectedConditions.R`'s
deferred functions (plan R32) were deleted when Phase 9 copied them (S11); the
row for `drawPedigreeDiagram()` (plan R37: nprcgenekeepr S1159's legend fill,
`392dd347e`, `a85311021` and `4283e3502`) when S12 ported that change.
