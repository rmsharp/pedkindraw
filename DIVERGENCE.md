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

No row: every copied function matches nprcgenekeepr at the commit its file's
header names. The three rows S9 recorded for `R/affectedConditions.R`'s
deferred functions (plan R32) were deleted when Phase 9 copied them (S11).
