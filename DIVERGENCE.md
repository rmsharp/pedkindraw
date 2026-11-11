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
| `.conditionSectionsHandler()` | `d120883` (not copied) | `baef1e12c` | In nprcgenekeepr's `R/affectedConditions.R`, not yet in pedkindraw's: only `drawPedigreeDiagram()` uses it, so Phase 9 copies it with that function (plan R32, S9) and deletes this row |
| `.diagramAfterDrawing()` | `d120883` (not copied) | `baef1e12c` | The same: drawing only, Phase 9 (R32) |
| `.diagramHeight()` | `d120883` (not copied) | `baef1e12c` | The same: drawing only, Phase 9 (R32) |

Every other copied function matches nprcgenekeepr at `baef1e12c`. The three rows above are a deferred copy, not a
change: `R/affectedConditions.R` holds the source file's lines 1-75 only (S9, Phase 8).
