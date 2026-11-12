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
| `drawPedigreeDiagram()` | `8f02d44` (copied at `471589138`) | `a85311021` | nprcgenekeepr's S1159 changed it after the copy, during pedkindraw S11: the legend's five sex rows are filled white (`color.background`, `.affectedColor(FALSE)`) where they took vis.js's default light blue, and its condition rows set only their fill, so their outline stays the diagram's blue; its RED `392dd347e` changed three legend-colour checks in `test_drawPedigreeDiagram.R`. To be ported, tests and code, in a pedkindraw session of its own (plan R37), which deletes this row |

Every other copied function matches nprcgenekeepr at the commit its file's
header names. The three rows S9 recorded for `R/affectedConditions.R`'s
deferred functions (plan R32) were deleted when Phase 9 copied them (S11).
