# Handoff Receipts — durable close-out proof

The cumulative, append-only record of **each session's close-out handoff**, distilled into a
machine-checkable block. It is the durable answer to *"was close-out actually performed, and what
did the session hand its successor?"* — the part of close-out that otherwise lives only in the
transient `SESSION_NOTES.md` (overwritten every session) or the spoken report (which leaves no file
at all).

One `handoff` block per **session** (not per commit), newest on top. The canonical-only
`bin/check-handoff` (copy it into your `bin/` if you want the structural check) asserts each block is
present and structurally complete; the next session's Phase 0 reconcile greps this file for a missing
or still-`pending` receipt and backfills it — that reconcile, not the checker, is the dependable
backstop, so the discipline needs no tooling. Together — a write-step at close-out **and** a
reconcile-on-read backstop — this makes a skipped handoff *detectable* rather than silent.

> **A green `bin/check-handoff` is not a good handoff.** The check verifies presence and structure,
> never semantic quality. Faithfulness is still scored 1–10 by the next session (Phase 3A). A
> well-formed but hollow receipt passes the check and is caught only by that human judgement.

## How to write a receipt

**At Phase 1B (claim the session)** — write the stub block below with `status: pending`, filling what
you can, and commit it with your session-claim commit. This committed `pending` block is the crash
breadcrumb: if the session ends before close-out, the next session's Phase 0 reconcile sees it.

**At Phase 3D (close-out)** — overwrite that block in place to `status: complete` and fill every
field. The block must satisfy all six Minimum Handoff Requirements (`SESSION_RUNNER.md` §3D).

**Naming the acting model (optional).** No new key — `REQUIRED_KEYS` is unchanged, and the fenced
block below stays exactly as documented. When a one-line summary is useful, especially for a
single-tier session where it saves a reader a cross-reference into `CHANGELOG.md`'s per-action
**Model:** bullet (see that file's format section), name the model in this receipt's free-text
prose area — the Format section below documents that area as *"the durable proxy for the Phase 3G
spoken report."* This formalizes what a capability-tiered session already does organically when it
states which tier built which layer and which tier reviewed it; this fork's own first receipt
(root `HANDOFFS.md`, session S1) is the worked precedent. `CHANGELOG.md`'s **Model:** bullet
remains the structured, per-action record; this is a convenience pointer for the session-level
view, not a second schema — and it is fine for both to name the same model on a single-tier
session, since they answer different questions ("what happened, action by action" vs. "which model
ran this session"). A canonical-only `bin/model-report` (copy it into your `bin/` if you want it,
same as `bin/check-handoff`) reads this free-text convention back alongside `CHANGELOG.md`'s
**Model:** bullets and git's `Co-Authored-By` trailers, keeping all three visually separate.

## Format — a fenced `handoff` block

````
```handoff
session: S<N>
date: YYYY-MM-DD
status: <pending | complete>
self_score: <1-10>
predecessor_score: <1-10>
active_task: <current state>
what_was_done: <what you did, including a commit sha — or the literal `pending`>
next_steps: <specific and actionable; never "pick next from backlog">
key_files: <each entry carries a path:line token, e.g. SessionManager.java:245>
gotchas: <traps the next session should watch for>
runtime_smoke: <a run result, or "n/a — docs-only", or "impossible: <reason>"; where .quality-gates.json declares gates, the `quality_ratchet: N/M pass · …` summary line of this session's --run>
changelog_ref: <PR #N, a short-sha, or CHANGELOG.md "<its ### heading>" — never a bare line number, which decays once the ledger is trimmed>
commit: <short-sha — or the literal `pending`>
```
<free-text prose: the durable proxy for the Phase 3G spoken report, plus the +/- self-score breakdown>

Write clean `key: value` lines — no inline `#` comments (a `#` is a literal value character,
as in `changelog_ref: PR #52`). The keys are the six Phase 3D Minimum Handoff Requirements (the sixth
*is* `self_score`) plus `predecessor_score` (the Phase 3A evaluation) and a little metadata. `status`
is `pending` at the Phase 1B claim and `complete` at
close-out; a third value, `reconciled`, is written *only* by a later session's Phase 0 reconcile
when it reconstructs a receipt a crashed session never completed — you never write it yourself.
````

`self_score` and `predecessor_score` are distinct keys so one can never stand in for the other; omit
`predecessor_score` on Session 1 (there is no predecessor to score). `commit: pending` and
`what_was_done: pending` are legal at write time (the receipt ships in the very commit whose sha it
would name); no future session is assigned to fill either in later, so `pending` is a legitimate
resting value for both, not a promise a later session owes.

**A receipt's identity is `session` + `date`, not `session` alone.** `S<N>` is a per-sequence
counter, and one ledger may legitimately merge more than one sequence — a fork and its upstream each
running their own, so two distinct sessions share an `S<N>` by construction. Keep `S<N>` unique
within a sequence if you can (never renumber an already-written receipt to do it — a visible gap
that closes on merge is the lesser defect), but do not treat a repeated id across sequences as
corruption. `bin/check-handoff --all` keys on the pair for this reason.

**Concurrent sequences in one repository** get a tag. Each repository's `main` uses bare `S<N>`; a session
claimed on any other branch of the same repository writes `S<N>-<seq>` (`S24-ratchet`, the branch's short name
or the agent's), so two sessions live at once never share a name. Each line's newest pending receipt is that line's live claim, even when another line's receipts sit above it; a pending receipt superseded within its own line is a session that never closed out. When their branches merge, `HANDOFFS.md`
conflicts — it is deliberately left out of the `.gitattributes` union driver, which would fuse two prepended
receipts into one block — and the merge is resolved keep-both, ours on top, from the three index stages:

```sh
git show :1:HANDOFFS.md > base; git show :2:HANDOFFS.md > ours; git show :3:HANDOFFS.md > theirs
git merge-file -p --union --diff3 ours base theirs > HANDOFFS.md   # --diff3 keeps each receipt whole
```

Then check every receipt before committing the merge (the canonical `bin/check-handoff --all` refuses a key
repeated in one block). **A merge is one action with one receipt:** the merging session writes one receipt
naming the merged range and its sequence tag, scores the merged sequence's last receipt in one line of its own,
and owes no `status: reconciled` receipt per merged commit. The method behind all of this:
`ITERATIVE_METHODOLOGY.md` §Parallel Actors.

## Size, and when to archive

handoffs-format: 2 — keep this marker, and bring it across with this section; `bin/status` reads it.

This file gains a receipt every session and nothing removes one, so it grows without bound. The
protocol never asks a session to read it whole: Phase 0 reconciles it against `git log` and checks
the newest receipt, and a session reads that receipt at the top — past the harness's default-read
refusal, with an offset and a limit. Archive it when the trimmer's trigger fires. The tool states the
trigger, and this file names no size of its own.

**Run this rather than estimating it:**

```sh
python3 methodology_trim.py --file HANDOFFS.md --check
```

`--check` evaluates the trigger and never writes. `--write` performs the trim, refuses unless it
can prove the split lossless, and **neither commits nor stages** — it leaves this file modified and
the new shard *untracked*, and leaves the commit to you (`git add HANDOFFS.md docs/archive/`).

An archive is a **shard**: a new frozen file, same format, same newest-on-top order.

- **Path: `docs/archive/HANDOFFS-through-<CUT-KEY>.md`.** Both halves are load-bearing — the
  directory keeps the shard from shadowing this file, and the `HANDOFFS-` prefix is what the
  trigger's own glob looks for. A shard named otherwise is silently invisible to it.
- **This file keeps one short pointer** naming each shard, the span it covers and how many receipts
  it holds — with the command that recomputes those counts, never a hand-maintained number.
- **The shard back-links here and states only facts about itself.** It must not restate a
  forward-looking rule: a shard is frozen, so a rule copied into one cannot be corrected when the
  live rule moves.
- **After a split, anything that enumerates receipts must span both** — `HANDOFFS.md
  $(git ls-files 'docs/archive/HANDOFFS-*.md')` — or it silently counts a shrunken
  population. Enumerate the shards with `git ls-files`, never as a bare glob: zsh aborts a
  command whose glob matches nothing, so before the first split the bare form counts nothing
  at all — the same reason the ledger's audit is written that way.

The reasoning this file shares with `CHANGELOG.md` — how a ledger is read, why the tool is the only
statement of its trigger, and what a split must conserve — is in the *Reading and archiving*
subsection of `FRAMEWORK_APPARATUS.md` §The Action Ledger.
That subsection makes archiving optional for `CHANGELOG.md`; this file keeps its own rule, above —
archive it when the trimmer's trigger fires. Everything needed to *act* is here.

What is specific to *this* file, and gets receipts wrong if assumed:

- **A record is a `handoff` block *plus the prose beneath it*, not the fence alone.** The self-score
  and predecessor-score paragraphs sit outside the fence and belong to the receipt above them. A
  fence-only cut severs every receipt from its own scoring.
- **Archive oldest-first by position, never by sorting on `session:`.** Two independent `S<N>`
  sequences can share one ledger — a fork and its upstream each running their own counter — and
  their numbers collide. The record's identity is **session + date**.
- **A trim leaves the newest-receipt check alone and moves what the older-receipt checks see.**
  Phase 0 reconcile is frontier-based and a structural checker applies the full schema to the newest
  receipt only, so neither is disturbed. Its other passes are not so confined — `--all` reads every
  receipt, and a rule a project adds over its older receipts reads them too. So after a trim,
  **run the checker against each shard as well**, and recompute any "all N older receipts" count from
  the files rather than carrying it forward.
- **Never trim to zero receipts.** An empty receipt ledger is indistinguishable from a broken one.
- **A shard freezes, and nothing in it is rewritten** — not even a `commit:` slot. A `pending` there
  stays `pending`: it is a legitimate resting value (above), and no later session is assigned to fill
  it in.

## Three files, three questions, one shared key

- **`SESSION_NOTES.md`** — the *transient scratchpad*: rich working notes, overwritten every session.
- **`HANDOFFS.md`** (this file) — the *durable receipt*: the distilled, machine-checkable proof that
  the handoff was written. Nothing is ever deleted; when the file is archived, the oldest receipts
  move to a frozen shard (see **Size, and when to archive** above).
- **`CHANGELOG.md`** — the *cumulative action ledger*: *"what was done here, ever?"*, append-only.

The shared key across all three is the commit sha (`changelog_ref` / `commit` here). This file
**distills** the handoff; it does not copy the scratchpad. The belongs-here test: *would the next
session need this block to continue the work without re-reading the whole repo?*

## Citing the gate run — honesty made countable

Where the project declares quality gates (`.quality-gates.json` with at least one gate), a
`status: complete` receipt cites the session's own gate run: paste the summary line
`quality_ratchet.py --run` prints (`quality_ratchet: N/M pass · F fail · U unmeasured · results
<sha12> · manifest <sha12>`) into `runtime_smoke` (or `what_was_done`). A run that reads `U unmeasured`
with `U` above 0 is not a clean one: repair the gate (its command, or `timeout_seconds` if it is only
slow) and run again, or name each unmeasured gate in the same field as `unmeasured: <gate>, <gate> — by
hand: <result>`, at least `U` names. The canonical-only
`bin/check-handoff` lints the **newest** receipt for that token and clause when a manifest with gates is present;
the next session's Phase 0 reconcile compares the cited `results` hash and counts against the current
`.quality-gates-results.json` (or re-runs `--run`) and treats a contradiction — a receipt claiming
`6/6 pass` over results that say otherwise — as the same class of finding as an unrecorded commit.
Ceiling, stated as v3.3 stated it: the lint checks the citation's **structure**, the reconcile checks
its **counts**; neither reaches the truth of anything no gate expresses. Receipts written before the
manifest existed are not re-judged.

**Archived 27 record(s), 2026-11-10 → 2026-11-15** into [`methodology/archive/HANDOFFS-through-2026-11-15.md`](archive/HANDOFFS-through-2026-11-15.md) — same format, same order, frozen.
Losslessness is proved by [`methodology/archive/HANDOFFS-through-2026-11-15.md.verify.sh`](archive/HANDOFFS-through-2026-11-15.md.verify.sh), which re-derives L1/L2/L3 from git; run it rather
than trusting this sentence. Written by `methodology_trim.py` v1.8.1.

---

<!-- Receipts go below, newest on top. Delete the seed-sentinel line above when you add the first one. -->

```handoff
session: S46
date: 2026-11-18
status: pending
active_task: Phase G5, a function that rewrites other ways of writing missing parents ("0", "") and sex (1/2, male/female, m/f) into pedkindraw's (NA, "M", "F") (gap C4; docs/planning/gaps-and-shared-code-plan.md:359; R97; methodology/BACKLOG.md:26), a new export: measure first, a pre-RED picker (its name, which codes by default, "0" as missing only when asked, copy convertSexCodes() or write new, the _pkgdown.yml section), RED, GREEN, REFACTOR by the gates; strict TDD; Mark's pick "Phase G5 (Recommended)"
what_was_done: pending
commit: pending
```

```handoff
session: S45
date: 2026-11-18
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase G4 DONE: makePedigreeDiagramData() and makePedigreeMatingLayout() take conditionColors, the colours of the affected conditions (the four drawn before by default; any colour R knows, written as its "#RRGGBB" code); the layout's fills and its conditions table take them, and drawPedigreeDiagram() paints its sections and legend from that table, so the three agree; a colour R does not know, a number, a transparent colour, white, the unknown grey, a colour given twice and fewer colours than conditions drawn stop (R111-R113). Next: Phase G5, a function that rewrites other ways of writing missing parents and sex into pedkindraw's (gap C4; docs/planning/gaps-and-shared-code-plan.md:359), a new export. READY, tree clean but pedkindraw.Rproj.
what_was_done: claim f67a36e (Mark's pick "Phase G4 (Recommended)"). Measured before the pre-RED picker: the gap case style; every place a condition colour is chosen; R's 657 colour names in headless Chrome (136 read as R means them, 5 as other colours, 516 not read); a scratch prototype (lint 0; its suite 739 tests 0 failed; its fidelity 600 of 600; its 40 browser readings exact; the draft tests 12 of 12 pass there, 148 expectations, and 12 of 12 fail on HEAD). Picks: conditionColors, both builders, any R colour as its code, clashes and gaps stop. RED b978aeb (tests/testthat/test_conditionColors.R, 12 tests, a browser test among them); GREEN 1a 9efb2e5 (R/conditionColors.R, the builders, .affectedColor(affectedFill =), .diagramAfterDrawing(colors =), drawPedigreeDiagram()'s sectionColors, grDevices in Imports; copied from the prototype); GREEN 1b 684175e (3 help pages identical to the prototype's; DIVERGENCE.md: 4 rows gain G4, a new .diagramAfterDrawing() row); GREEN 2 5e3abb4 (NEWS, the contract's sections 4 and 5, three gap-case probes); REFACTOR cc4189f (tests only: .pixelReaderJs() in helper-legendPictures.R for the three browser colour tests); close-out 1 5182246 (R111-R113, the plans' status and Done G4, dragons 16-17, ROADMAP, BACKLOG with N2's item removed).
next_steps: Orient; drift tool (expect 91 functions, 20 differ, 0 without a row); nprcgenekeepr's log on the copied files (the same 4 commits; nprcgenekeepr finished N2 in its S1190, faf6823c3, and was at its S1191 RED, b43f81c55: report a new commit to a copied file to Mark); check S45's push's runs. G5: run tools/gapCases.R inputCodes; read what pedkindraw already says about the codes (checkPedigree()'s missingParentCodes, R/checkPedigree.R:24, "a value that is also the id of a row is a real parent"; findUnrelated(), R/findUnrelated.R:120; sexCodes, R/sexCodes.R:15, whose help names nprcgenekeepr's convertSexCodes(), not copied: ../nprcgenekeepr/R/convertSexCodes.R:43); run kinship2's pedigree(missid =) and Pedixplorer on the codes under a time limit (Learning 19); then the pre-RED picker (the name; which codes by default; "0" as missing only when asked; copy convertSexCodes() or write new; the _pkgdown.yml section), RED, GREEN, REFACTOR by the gates; the contract's section 4; NEWS; _pkgdown.yml; R CMD check --as-cran after the last code change. The orient picker also offers the smallPed fixture (READY) and the DIVERGENCE.md rewording.
key_files: docs/planning/gaps-and-shared-code-plan.md:359 (G5's row), :495 and :500 (dragons 16-17); docs/research/pedkindraw-gaps-2026-11-18.md:297 (C4); docs/planning/standalone-pedigree-package-plan.md:65 (Next), :243 to :245 (R111-R113), :1034 (Done G4); docs/planning/cran-submission-plan.md:577 (Done G4); R/conditionColors.R:25 (.checkConditionColors()); R/makePedigreeDiagramData.R:128, :285, :1914, :1919 (G4's checks, .affectedColor(), conditions$color); R/drawPedigreeDiagram.R:125 (sectionColors); R/affectedConditions.R:255 (.diagramAfterDrawing()); tests/testthat/test_conditionColors.R; tests/testthat/helper-legendPictures.R:41 (.pixelReaderJs()); tools/gapCases.R:407 (case style), :591 (case inputCodes); R/checkPedigree.R:24; R/sexCodes.R:15; _pkgdown.yml:14 (the reference list); methodology/BACKLOG.md:26 (G5-G17), :34, :52 (smallPed fixture)
gotchas: a new export needs the contract's section 4, _pkgdown.yml's reference list and a help page with an example; R colours reaching a browser are codes (dragon 16), and a browser colour test uses .pixelReaderJs() (dragon 17); lint the prototype, help text included (S45 met two long lines there), and check test lines over 80 by hand (.lintr excludes tests); count each scripted edit's anchor and refuse any not matched exactly once (dragon 14); run the draft tests on the prototype before RED (S45's drafts had two helper bugs: an empty regex match indexed, unlist() of nothing NULL); scratch copies need .Rprofile removed and env -u RENV_PROJECT R_LIBS= R_LIBS_USER= set to renv's library, and the fidelity tool runs from a scratch copy that way; zsh has pipestatus, not PIPESTATUS; times: suite 4.5 min, fidelity 3.5, CRAN check 8, ratchet 5; CLAUDE.md over budget; never pipe chromote into head
runtime_smoke: library code, no app; the deliverable run in R and in headless Chrome: tools/gapCases.R style reads the chosen colours in the one-condition fills and legend row (#FFA500 for "orange") and in the section painter's list; the browser test reads 40 colours vis.js draws (fills, sections, the legend's hexagon and section pictures, 1, 3 and 4 conditions) within 10 of each chosen colour (the prototype's readings exact); R CMD check --as-cran from a scratch folder after GREEN and again after the REFACTOR, Status 1 NOTE each time (the incoming-feasibility one, R16); full suite 61 files, 751 tests, 0 failed, 0 skipped, 0 warnings after GREEN and after the REFACTOR; lint_package() 0; roxygenise() stable; covr 35 of 35 new or changed statements; drift tool exit 0 (91/20/0); fidelity tool exit 0, 600 of 600 identical, no new set-aside; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-18 · [BL-Phase G4] S45: Phase G4, one colours argument for the fills, the sections and the legend (R111-R113)", "S45: rulings R111-R113", "S45: the backlog's N2 item removed" and "S45 push 1"
commit: this receipt's commit (close-out 2)
```

```handoff
session: S44
date: 2026-11-18
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase G3 DONE: makePedigreeDiagramData() and makePedigreeMatingLayout() take maxNameChars = 15, the most characters of the name column written under an id (an animal's node and its repeat nodes alike); Inf writes every name whole, as kinship2 and Pedixplorer write labels; a line break counts as one character, as before; anything but one whole number of 1 or more stops (R108-R110). Next: Phase G4, a colours argument carried to the fills, the sections script and the legend (gap B5; docs/planning/gaps-and-shared-code-plan.md:358). READY, tree clean but pedkindraw.Rproj.
what_was_done: claim 1286b77 (Mark's pick "Phase G3 (Recommended)"). Measured before the pre-RED picker: the gap case (kinship2 and Pedixplorer write the note whole, pedkindraw "MHC A01/B..."); every caller of .nameLabel(); the closest animals on a row 120 px apart in 5 fixtures' layouts; label widths in headless Chrome for 6 texts at 8 limits (about 7 px a character; the default's cut overlaps a neighbour by about 5 px, the case's line whole by 27 px); no test or fidelity name has a line break, and the fidelity cases do carry names past 15. Picks: maxNameChars, both builders, Inf, the whole name counted. Draft tests run on a scratch prototype (10 of 10 pass, 71 expectations; full suite 739 0 failed; fidelity 600 of 600) and on HEAD (10 of 10 fail). RED c0a96a8 (tests/testthat/test_maxNameChars.R, 10 tests, a browser test among them); GREEN 1 5c6fdc0 (both builders, R/maxNameChars.R's check, help, DIVERGENCE.md; parsed code identical to the prototype's); GREEN 2 14e1bcb (NEWS, contract, the gap case's Inf probe); REFACTOR fefc4d7 (two comments, parsed code identical); close-out 1 d909337 (R108-R110, the plans' status and Done G3, dragons 14-15, ROADMAP, BACKLOG).
next_steps: Orient; drift tool (expect 91 functions, 19 differ, 0 without a row); nprcgenekeepr's log on the copied files (the same 4 commits; its N2 was at GREEN 1cdae181c in its S1190: report a new commit to a copied file to Mark); check S44's push's runs. G4: run tools/gapCases.R style; grep every place a condition colour is chosen (.conditionColors, .affectedColor()'s literal pink for one condition, the layout's conditions$color, the sections script called with no colours, the legend's Affected row) with their callers; prototype the argument in a scratch copy, lint it, read its colours in headless Chrome (test_unknownAffected.R's pixel reader); then the pre-RED picker (which function takes it; how colours are checked; the grey's distance from chosen colours), RED, GREEN, REFACTOR by the gates; DIVERGENCE.md "at the switch"; NEWS; contract; R CMD check --as-cran after the last code change. The orient picker also offers the smallPed fixture (READY) and the DIVERGENCE.md rewording.
key_files: docs/planning/gaps-and-shared-code-plan.md:358 (G4's row), :485 and :491 (dragons 14-15); docs/research/pedkindraw-gaps-2026-11-18.md:219 (B5); docs/planning/standalone-pedigree-package-plan.md:64 (Next), :239 to :241 (R108-R110), :1022 (Done G3); docs/planning/cran-submission-plan.md:573 (Done G3); R/affectedConditions.R:26 (.conditionColors), :119 (.conditionSectionsHandler()), :252 (its call, no colours); R/makePedigreeDiagramData.R:261 (.affectedColor()'s pink), :1860 (conditions$color), :2008 (.affectedColorForVec()); R/drawPedigreeDiagram.R:116 (the legend's Affected row); R/maxNameChars.R:19 (.checkMaxNameChars()); R/makePedigreeDiagramData.R:112, :171, :1841, :2036 (G3's checks and labels); tools/gapCases.R:407 (case style); methodology/BACKLOG.md:26 (G4-G17), :34, :52 (smallPed fixture)
gotchas: lint the prototype before RED (S44's two implicit_integer lints reached GREEN; a numeric default is written 15.0, dragon 15); a scripted edit lands at the first match (the column-check text is in three functions, R/makePedigreeDiagramData.R:521, :972, :1839; dragon 14), so anchor on text naming the function and diff every scratch edit; prove GREEN equals the prototype by parse(keep.source = FALSE) and deparse; an all-NA vector stands for "no column" and "several conditions" (dragon 12); visNetwork keeps a drawing's height twice (dragon 13); scratch copies need .Rprofile removed and env -u RENV_PROJECT R_LIBS= R_LIBS_USER= set to renv's library; zsh has pipestatus, not PIPESTATUS; times: suite 4.5 min, fidelity 3.5, CRAN check 8, ratchet 5; CLAUDE.md over budget; never pipe chromote into head
runtime_smoke: library code, no app; the deliverable run in R and in headless Chrome: tools/gapCases.R labels reads "B\nage 7\nMHC A01/B02 long text" with maxNameChars = Inf (kinship2 and Pedixplorer write the same text) and "MHC A01/B..." by default; the browser test reads the lines vis.js draws under A, "MHC A01/B..." by default and "MHC A01/B02 long text" with Inf; R CMD check --as-cran from a scratch folder after GREEN and again after the REFACTOR, Status 1 NOTE each time (the incoming-feasibility one, R16); full suite 60 files, 739 tests, 0 failed, 0 errors, 0 warnings, 0 skipped; lint_package() 0; roxygenise() stable; covr 10 of 10 new statements; drift tool exit 0 (91/19/0); fidelity tool exit 0, 600 of 600 identical, no new set-aside; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-18 · [BL-Phase G3] S44: Phase G3, the length of a name under an id becomes an argument (R108-R110)", "S44: rulings R108-R110" and "S44 push 1"
commit: this receipt's commit (close-out 2)
```
S44 did Phase G3 by strict TDD on copied code. Before the pre-RED picker it measured what the choices meant: how
close animals are drawn (120 px at the closest, in every fixture laid out), how wide vis.js draws a label (about 7 px
a character, so more than about 17 characters overlaps a neighbour), that the limit counts a line break, and that the
fidelity cases carry names, so "600 of 600" can see a label change. The draft tests were run on a scratch prototype
(all pass, with the full suite and the fidelity tool) and on HEAD (all fail) before RED, and GREEN's code was proved
identical to the prototype's. Every pick and gate came first time. Self-score 8: + measured pickers, prototype-checked
RED, every DONE check run, the CRAN check after GREEN and after the REFACTOR; - the prototype's scripted insert first
went into the wrong function (caught by diff, dragon 14), and the prototype was not linted, so two lints reached
GREEN (dragon 15). Model: Claude Opus 5.5.

```handoff
session: S43
date: 2026-11-18
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase G2 DONE: an unknown affected status (NA, or text as.logical() cannot read) is filled grey, #BEBEBE (R's grey, as Pedixplorer), the whole symbol with one condition (makePedigreeMatingLayout(), and makePedigreeDiagramData() when its column is there) or its section with two to four ("?" in affectedSections), and drawPedigreeDiagram()'s legend has a grey hexagon "Affected status unknown" after the condition rows, 45 px more (rulings R106-R107). Next: Phase G3, the 15-character limit on the notes under an id becomes an argument (gap B6; an addition: the 600 fidelity cases identical at the default).
what_was_done: claim ec58c61 (Mark's pick "Phase G2 (Recommended)"). Measured before the pre-RED picker: the gap case (kinship2 draws "?", Pedixplorer grey, pedkindraw white); every place NA becomes a look; two prototypes in scratch copies, grey fill and kinship2's "?", each drawn in headless Chrome with pixels read from vis.js, run through the full suite (grey broke 9 copied tests, "?" 7) and the fidelity tool (66 and 54 of 600 results changed); four greys against white and the condition colours in normal vision, three simulated colour blindnesses and greyscale (#BEBEBE closest 16, #999999 2 from the pink in greyscale); three legend labels fit the 269 px legend. Mark's picks: "Grey fill (Recommended)" (R106), "Affected status unknown (Recommended)" (R107). RED b11d1d9 (tests/testthat/test_unknownAffected.R, 10 tests with a 35-pixel browser test; 9 copied tests changed; all passed on the prototype first; 18 failed on the code before). GREEN 1 3cb9425 (.unknownColor, .affectedSectionsOf() "?", the section painter, .affectedColor(unknown =), the legend row and height; DIVERGENCE.md six rows "at the switch"). GREEN 2 14e9143 (the fidelity tool's counted set-aside withoutUnknownStatus(): 66 results, 600 of 600 identical). Help 5bbe818; vignette, NEWS and contract e47a675. REFACTOR 638b394 (the unknown fill chosen once in each function; one shared legend-picture wait helper; 192 of 192 results identical before and after). Close-out 1 a181de2 (R106-R107, the plans, roadmap, backlog, dragons 12-13); close-out 2 this receipt; close-out 3 the HANDOFFS.md trim.
next_steps: Orient; drift tool (expect 91 functions, 19 differ, 0 without a row); nprcgenekeepr's log on the copied files (the same 4 commits; its N2 in S1190 may change copied files: report a new commit to Mark and run the fidelity tool at f09a028f5, Learning 15); check S43's push's runs. G3: run tools/gapCases.R labels; read .nameLabelCharBudget and its callers (grep each name, dragon 10); measure in headless Chrome how a longer label overlaps its neighbours (the 15 was calibrated against the tightest node spacing); the default must leave the 600 fidelity cases identical. Then the picker: the argument's name, which functions take it, the value for "no limit". RED, GREEN, REFACTOR by the gates; the contract's section 4; DIVERGENCE.md rows "at the switch"; NEWS; R CMD check --as-cran after the last code change.
key_files: docs/planning/gaps-and-shared-code-plan.md:357 (G3's row), :442 (dragons; 12-13 at :475, :480); docs/research/pedkindraw-gaps-2026-11-18.md:237 (B6); docs/planning/standalone-pedigree-package-plan.md:63 (Next), :235 (R106), :236 (R107), :1009 (Done G2); R/makePedigreeDiagramData.R:272 (.nameLabelCharBudget), :298 (.nameLabel()), :156, :1998 (its callers), :245 (.affectedColor()), :133, :1966 (G2's unknownFill); R/affectedConditions.R:36 (.unknownColor), :89, :119; R/drawPedigreeDiagram.R:196 (the unknown row), :212 (height); tools/compareResultsWithNprcgenekeepr.R:765 (withoutUnknownStatus()); tools/gapCases.R:465 (case labels); tests/testthat/test_unknownAffected.R:1; tests/testthat/helper-legendPictures.R:13; methodology/BACKLOG.md:26, :34, :52
gotchas: an all-NA status vector also stands for "no column" and "several conditions" in the fill code (dragon 12), and labels have the same shape (hasName), so test "no name column" beside a new argument; visNetwork keeps a drawing's height twice ($height, $x$height; dragon 13), and one pedigree's results diffed field by field (--child on a folder holding only synthetic_300.csv, 13 s) find such a miss before a 3.5-min fidelity run; samplePed's text "0"/"1" is unknown, so its drawings are grey and the G2 set-aside turns them back (it runs before R81's); the gaps document cites .nameLabelCharBudget at :240, now :272; a scratch copy's .Rprofile must go (rm "${S:?}/..."); Rscript in tests/testthat has no renv; zsh has no PIPESTATUS; CLAUDE.md over its budget.
runtime_smoke: library code, no app; the deliverable run in R and in headless Chrome: tools/gapCases.R unknownAffected reads pink / grey / white / pink for A, B (unknown), C, D (Pedixplorer red / grey / white / red); the browser test reads #BEBEBE (190,190,190) in each unknown symbol, section and legend row; R CMD check --as-cran from a scratch folder after GREEN and again after the REFACTOR, Status 1 NOTE each time (the incoming-feasibility one, R16); full suite 59 files, 729 tests, 0 failed, 0 errors, 0 warnings, 0 skipped; lint_package() 0; roxygenise() leaves NAMESPACE and man/ unchanged; covr 17 of 17 new statements; drift tool exit 0 (91/19/0); fidelity tool exit 0, 600 of 600 identical, twice; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-18 · [BL-Phase G2] S43: Phase G2, an unknown affected status drawn grey (R106-R107)", "S43: rulings R106-R107", "Ledger trim: `methodology/HANDOFFS.md` → `methodology/archive/HANDOFFS-through-2026-11-15.md`" (close-out 3) and "S43 push 1"
commit: this receipt's commit (close-out 2)
```
S43 did Phase G2 by strict TDD on copied code. Before the pre-RED picker it built both candidate looks as prototypes
in scratch copies and measured each: pixels in headless Chrome, the tests each broke, the fidelity results each
changed, and the grey's distance from every other fill. Mark's picks were all Claude's recommendations, each first
time. The REFACTOR took the three repetitions GREEN left. The one slow spot: the fidelity set-aside took three full
runs before it held (a variable defined later in the tool, then visNetwork's second height), where one small
pedigree diffed field by field would have shown both at once. Self 8: + measured pickers, prototype-computed RED
values, every DONE check run twice where code changed; - the three fidelity runs, a claim stub that split a line, a
RED message written before its last fix. Predecessor 9: S42's measure-first steps were the session's plan; it did
not know the fill code's all-NA "no column".

```handoff
session: S42
date: 2026-11-18
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase G1 DONE: a condition column holding a number other than 0 and 1 stops, naming the column and the numbers, in makePedigreeMatingLayout() (drawn conditions, before any animal is left out), makePedigreeDiagramData() and the shrink functions' input check; bitSize() and findUnavailable() do not read the column (rulings R102-R105). Next: Phase G2, an unknown affected status (NA) gets its own look and a legend row (docs/planning/gaps-and-shared-code-plan.md:355); READY beside it: rewording DIVERGENCE.md's 14 rows older than R98 (methodology/BACKLOG.md:34)
what_was_done: claim ccd0d89 (Mark's pick "Phase G1 (Recommended)"). Measured before the pre-RED picker: kinship2 1.9.6.2 stops on 2.5/0.3/9; asPedFrame() writes 0, 1, NA from kinship2 and Pedixplorer; a logging scratch copy over the 600 fidelity cases and 707 tests (no number other than 0 and 1 at any read; samplePed's text "0"/"1"; 3 copied tests with unreadable text); warn and stop drafts (suite 0 failed, 0 warnings; fidelity 600 of 600). Picks R102 stop, R103 numbers only, R104 all three reads. RED 17da874 (tests/testthat/test_conditionValues.R, 11 tests, 8 failing); GREEN 1 37a25fc (R/conditionValues.R .checkConditionNumbers(); checks in makePedigreeDiagramData(), makePedigreeMatingLayout(), .checkShrinkInput(); DIVERGENCE.md rows "at the switch"). Found after GREEN 1: bitSize() and findUnavailable() also call .checkShrinkInput() and now stopped; Mark's pick R105 "Ignore the column (Recommended)"; RED 2 0362dcf, GREEN 2 34b4c00. Help 3bd2e3d, a6d3080; NEWS and the API contract c9a8a52; REFACTOR ba01a0c (one affected block in makePedigreeDiagramData(), bitSize()'s vector named once; 92 of 92 results identical before and after); close-out 1 b9ea08c (rulings, plans, roadmap, backlog, dragons 10-11); close-out 2 (notes, receipt, ledger); pushed
next_steps: Orient; drift tool (expect 91 functions, 16 differ, 0 without a row); nprcgenekeepr's log on the copied files (the same 4 commits; a new one departs from R101, report it); check S42's push's runs (S41's R-CMD-check took 46 min on ubuntu oldrel-1). G2: run tools/gapCases.R unknownAffected; find every place NA becomes a look (.affectedColor(), .affectedSectionsOf(), the sections painter, the legend rows) and grep each helper's callers (dragon 10); the fidelity set-aside is measured: all 55 of the 600 cases that draw a condition column hold an NA; measure colours from vis.js in headless Chrome. Then the pre-RED picker (grey fill or "?"; the legend's words), RED, GREEN, REFACTOR by the gates, a counted set-aside in tools/compareResultsWithNprcgenekeepr.R, DIVERGENCE.md rows "at the switch", NEWS, R CMD check --as-cran after the last code change
key_files: R/conditionValues.R:20 (.checkConditionNumbers()); R/makePedigreeDiagramData.R:124 (diagram data's affected block), :227 (.affectedColor()), :1807 (the layout's G1 check), :1946 (.affectedColorForVec()); R/shrinkPedigree.R:102 (the shrink check); R/bitSize.R:50, R/findUnavailable.R:63 (R105); R/affectedConditions.R:75 (.affectedSectionsOf()); R/drawPedigreeDiagram.R:142 (sexRows), :155 (conditionRows); tools/gapCases.R:315 (unknownAffected); tools/compareResultsWithNprcgenekeepr.R:181 (cycle(), TRUE/FALSE/NA), :745 (withoutConditionSymbols()); DIVERGENCE.md:14 (G1's rows to :16); docs/planning/gaps-and-shared-code-plan.md:355 (G2), :464 (dragons 10-11); docs/planning/standalone-pedigree-package-plan.md:229 (R102-R105), :999 (Done G1); methodology/BACKLOG.md:26 (G2-G17), :34 (DIVERGENCE.md rewording)
gotchas: samplePed's text "0"/"1" reads as unknown (R103 left text alone), so once G2 draws unknown differently samplePed read as text draws every animal unknown in its 8 drawing cases; G1's check runs before isolated animals are dropped (R/makePedigreeDiagramData.R:1807), so a G2 test with numbers stops there; a scratch copy needs its .Rprofile removed or renv starts there with an empty library; the shell is zsh, where ${PIPESTATUS[0]} is empty (use echo $? without a pipe); R CMD check must follow the last code change; the suite takes about 255 s (719 tests); HANDOFFS.md near its trim trigger (check with methodology_trim.py); CLAUDE.md over budget, so learnings go to the plans' dragons
runtime_smoke: library code, no app; the deliverable run in R: tools/gapCases.R measuredTrait stops with the message; R CMD check --as-cran from a scratch folder after GREEN and again after the REFACTOR, Status 1 NOTE each time (the incoming-feasibility one, R16); full suite 58 files, 719 tests, 0 failed, 0 errors, 0 warnings; lint_package() 0; roxygenise() leaves NAMESPACE and man/ unchanged; covr: 15 of 15 new statements reached; drift tool 91 functions, 16 differ, 0 without a row; fidelity tool exit 0, 600 of 600 identical, kinship largest difference 0; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-18 · [BL-Phase G1] S42: Phase G1, a number in a condition column stops (R102-R105)", "S42: rulings R102-R105" and "S42 push 1"
commit: this receipt's commit (close-out 2)
```
S42 did Phase G1 by strict TDD on copied code, with every pre-RED option measured on scratch copies first. Mark's
picks were all Claude's recommendations. The one stumble: the pre-RED picker described the shrink check's reach
from a grep of `affected` and named three of its five callers; GREEN 1 made the other two (`bitSize()`,
`findUnavailable()`) stop, which Claude found, reported and put to Mark (R105), adding a second RED-GREEN round.
Self 8: + measured pickers, the logging run, every DONE check run (the CRAN check twice); - the missed callers, two
wrong line citations, a scratch run lost to `.Rprofile`, an exit status lost to zsh. Predecessor 9: S41's
measure-first steps and the #133 gotcha shaped the session; it did not know of the third read.

```handoff
session: S41
date: 2026-11-18
status: complete
self_score: 7
predecessor_score: 9
active_task: Phase 17f2 DONE: docs/planning/gaps-and-shared-code-plan.md, rulings R97-R101. Every gap closes before the first CRAN release (R97, phases G1-G17 before 17g); nprcgenekeepr names its calls now and imports pedkindraw after CRAN accepts it (R98), fixing its two faults first (R99) and re-exporting the 22 shared functions (R100); changes to the 91 copied functions start in pedkindraw until then (R101). Next: Phase G1, a number in a condition column reported (plan section 5.1; methodology/BACKLOG.md:26), strict TDD, copied code
what_was_done: claim f709b00 (Mark's pick "Plan 17f2 (Recommended)"). Inventory: nprcgenekeepr at eafd54851 parsed (57 calls from 24 files to 20 copied functions; 4 in the order R89 changed); its whole suite on scratch copies with pedkindraw in a scratch library (unchanged 0 failed; pedkindraw's functions in place of its copies 55 of 467 own test files failing; the 4 calls rewritten 31, each classified); two faults in nprcgenekeepr found and checked against kinship2 (its simulation's stale generations, 200 of 200 draws wrong, also in 3.0.0; smallPed's 8 of 17 generations); CRAN policy 6985 read. Framing picker "This outline (Recommended)"; 5bebd3c the evidence (sections 1-3). Pickers: D4 needed two clarifications from Mark (options did not map to the plan's rows; no "all"), then "All before release (Recommended)"; D11 "Name calls now, switch later"; the faults "Next nprcgenekeepr session"; D12 "Re-export all 22"; D13 "pedkindraw leads shared code". da69a34 sections 4-7 (rulings, G1-G17, N1-N3, P1, coordination, order, dragons). 2e8e6e1 close-out 1 (CRAN plan, standalone plan R97-R101, ROADMAP, BACKLOG). Close-out 2: G1's 0/1 finding and dragon 9 in the plan, notes, this receipt, the ledger; all pushed
next_steps: Orient; drift tool (91, 14 differ, 0 without a row); nprcgenekeepr's log on the copied files (the same 4 commits; a new one there is a departure from R101, report it); check S41's push's runs. G1: measure first which fidelity cases and test files give a non-logical condition column, what asPedFrame() writes for kinship2's and Pedixplorer's conditions (kinship2's 0/1 pass through), and a draft check on a scratch copy with the whole suite; pre-RED picker (a warning or a stop; 0 and 1 accepted); RED, GREEN, REFACTOR by the gates; DIVERGENCE.md rows "at the switch"; fidelity tool 600 of 600; NEWS; R CMD check --as-cran from a scratch folder
key_files: docs/planning/gaps-and-shared-code-plan.md:86 (3.1 gap table), :159 (3.3 substitution run), :222 (3.4 faults), :298 (4 rulings), :329 (5.1 G1-G17), :375 (5.2 N1-N3), :401 (6 coordination), :441 (7.2 dragons); docs/planning/cran-submission-plan.md:6 (status), :545 (17f2 Done), :556 (G1-G17), :700 (session map); docs/planning/standalone-pedigree-package-plan.md:61 (Next), :223-:227 (R97-R101), :1010 (drift rule until the switch); R/makePedigreeDiagramData.R:117, :1913 (the as.logical() reads), :109 (issue #133's comment); R/asPedFrame.R:255; tools/gapCases.R:377 (measuredTrait); methodology/BACKLOG.md:26 (G1), :40 (P1), :49 (fixture), :83 (N1-N3)
gotchas: the as.logical() reading is deliberate (nprcgenekeepr #133: CSV text TRUE/FALSE, NA-tolerant), so G1 narrows only numbers other than 0 and 1 unless Mark picks otherwise; asPedFrame() passes kinship2's 0/1 through (R/asPedFrame.R:255-262); R98: pedkindraw's changes to copied functions are DIVERGENCE.md rows marked "at the switch", not ported; additions must leave the fidelity tool's 600 cases identical; nprcgenekeepr's faults are its own (R8, R99), and pedkindraw's tests/testthat/fixtures/smallPed.rds has the same 8 of 17 wrong generations (BLOCKED item, after N1); running nprcgenekeepr's suite: its renv library is in ~/Library/Caches, start Rscript from its folder with env -u RENV_PROJECT -u R_LIBS_USER, 6-9 min; edit a copy's DESCRIPTION as text; never pipe a script that saves a file into head; HANDOFFS.md near its trim trigger (an estimate: one more session)
runtime_smoke: no package code changed (R/, tests/, man/ untouched; docs/ and tools/ are build-ignored), so no app or check run; the deliverable's own runs: nprcgenekeepr's suite three times on scratch copies (510 files each; 0/0, 69/434, 35/274 failed/errors), the simulation probe against kinship2 (200 draws, twice), the dataset probe; every R/ citation in the plan checked against its line; drift tool 91, 14 differ, 0 without a row; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-18 · [BL-Phase 17f2] S41: Phase 17f2, the plan for closing the gaps in both repositories and coordinating them", "S41: the gaps closed before the release, and nprcgenekeepr's switch to pedkindraw (rulings R97-R101)" and "S41 push 1"
commit: this receipt's commit (close-out 2)
```

```handoff
session: S40
date: 2026-11-18
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase 17f DONE: docs/research/pedkindraw-gaps-2026-11-18.md, 16 open gaps between pedkindraw and kinship2 1.9.6.2 or Pedixplorer 1.8.0, each on a typed case. D4 (which gaps close before the release) went to a planning session by Mark's direction (R96, his five points verbatim). Next: Phase 17f2, the plan for closing the gaps in both repositories and coordinating them (docs/planning/cran-submission-plan.md:519; methodology/BACKLOG.md:58), a planning session, no code
what_was_done: claim 2626c16 (pushed with S39's close-out 1 and 2: CI 44247956305 5/5, site 44247956292, Pages 44248288466, all success). Inventory of the three packages' exports from renv; probes on typed pedigrees; framing picker answered "Full outline + case script (Recommended)". c267ffd: the document (16 gaps in groups A pictures outside the browser, B what a drawing shows, C computing and input; ruled R3/R13/R21/R7; not gaps; the 2026-09-20 table's 25 rows re-checked; Pedixplorer's 80 functions mapped; found on the way: a numeric condition column drawn affected wherever not 0, silently), tools/gapCases.R (20 cases, each in its own process under GNU timeout, all exit 0 in 82 s) and its record. D4 picker: Mark asked to clarify, asked for the gaps' implications to use and which are in nprcgenekeepr; 210a901 added section 1.1 (effect on use) and section 10 (nprcgenekeepr at ae3491dff has 13 of the 16 too, closes 3 in part: its app, convertSexCodes(), offspringCounts()), tools/gapCasesNprcgenekeepr.R and its record. Mark then directed the planning session (R96) and added that pausing one repository is acceptable. 24d3306 close-out 1: R96, Phase 17f2, D4, the session map, dragons 27-28, ROADMAP, BACKLOG (17f2 item; numeric condition column item). Close-out 2: notes, this receipt, the ledger; all pushed
next_steps: Orient; drift tool (91, 14 differ, 0 without a row); nprcgenekeepr's log on the copied files (the same 4 commits); check S40's push's runs. 17f2 (a planning session, deepest reasoning): read the gaps document whole, R8, R96, the standalone plan's section 4 "Later, optional" and section 5, DIVERGENCE.md and the three BLOCKED port items; inventory by grep in nprcgenekeepr of its calls to the 91 copied functions and which of pedkindraw's 31 exports it has no use for; a framing picker on the plan's outline, then one picker per decision: D4 (which gaps before the release, each a phase before 17g), nprcgenekeepr calling pedkindraw or carrying copies until CRAN acceptance (points 2-3), the order of work between the repositories, pausing one allowed (point 4), which functions nprcgenekeepr needs (point 5); record each as a ruling; commit the plan
key_files: docs/planning/cran-submission-plan.md:6 (status), :505 (17f Done), :519 (17f2, Mark's words), :653 (D4), :675 (session map), :777-:782 (dragons 27-28); docs/planning/standalone-pedigree-package-plan.md:59 (Next), :220 (R96), :970 (Done 17f), :979 ("Later, optional"); docs/research/pedkindraw-gaps-2026-11-18.md:30 (summary), :61 (1.1), :339 (6), :417 (9), :435 (10); tools/gapCases.R:22, :762, :776; tools/gapCasesNprcgenekeepr.R (header); methodology/BACKLOG.md:58 (17f2), :71 (numeric condition column), :26/:37/:47 (ports)
gotchas: R8 is in play (points 2-3 propose changing nprcgenekeepr; the plan proposes, Mark rules; nothing changes in nprcgenekeepr from a pedkindraw session); a CRAN package cannot Import one not on CRAN or Bioconductor, so nprcgenekeepr cannot depend on pedkindraw before acceptance (check the policy text before the plan states it; not checked in S40); gap facts are on stated commits (rerun the two scripts before quoting a moved number); the gaps document's S/M/L sizes are guesses; load kinship2, Pedixplorer and pedkindraw together and an unqualified kinship() is not pedkindraw's (dragon 27); Pedixplorer writes Rplots.pdf unless pdf(NULL) is open (dragon 28); run nprcgenekeepr's code from an archive of a commit, started from a shell in its folder (Learning 5); HANDOFFS.md nears its trim trigger (about two sessions, an estimate)
runtime_smoke: no package code changed (R/, tests/, man/ untouched; docs/ and tools/ are build-ignored), so no app or check run; the deliverable's own runs: tools/gapCases.R 20 of 20 cases exit 0 (82 s), its record matching a second run line for line apart from timings; tools/gapCasesNprcgenekeepr.R exit 0 on nprcgenekeepr ae3491dff; lint 0 on both tools; drift tool 91, 14 differ, 0 without a row; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-18 · [BL-Phase 17f] S40: Phase 17f, the gaps document...", "S40: D4 put to a planning session by Mark (ruling R96)", "S40 push 1" and "S40 push 2"
commit: this receipt's commit (close-out 2)
```

```handoff
session: S39
date: 2026-11-17
status: complete
self_score: 9
predecessor_score: 9
active_task: Phase 17e DONE (R95): the legend's four lines ("Same animal, again", MZ, DZ, ?) are drawn without arrowheads and each label on white, so the label reads whole. Next: Phase 17f, the gaps document (docs/planning/cran-submission-plan.md:496; methodology/BACKLOG.md:58), a research document under docs/research/ with each gap shown on a typed case, then Mark's D4 picker (plan :617)
what_was_done: claim fe82f69 (pushed with S38's close-out 1 and 2: CI 44232368509 and site 44232368399 success; S38's CI run 44227398574 finished 5/5). Measured before the picks in headless Chrome: the label was not cut by the legend's width but covered by the arrowhead visLegend() gives every legend line (5.5 px at 776 px, 10.1 px at 700 px; the live site's 12 drawings all 5.5 px); no arrowheads whole at 776, 700, 600 and 500 px, a shorter label or a 35% legend covered again at 600 px; the whole suite on the chosen draft 705 blocks, 0 failed; pedkindraw's own fidelity runs, 48 of 600 results differing only by the two new columns. Mark's picks: "Fix the legend label" (orient), "No arrowheads, white label" and "Port later" (pre-RED; ruling R95 37c41cf), the RED, GREEN and REFACTOR gates (REFACTOR over Claude's "skip"). RED b35911a (a new file, 2 tests); GREEN 1 eb1e845 (arrows "" and font.background "#FFFFFF" in the legend's line table); GREEN 2 fab63a8 (the fidelity tool's withoutLegendLineStyle(); the DIVERGENCE.md row); GREEN 3 f4f5744 (NEWS); REFACTOR 9505d9d (the tool's three set-asides through one eachDrawing(), proved on one raw dump); the six pushed together; close-out 1 264742c (plans, ROADMAP, BACKLOG, dragons 25-26); close-out 2 (notes, receipt, ledger)
next_steps: Orient; drift tool (91, 14 differ, 0 without a row); nprcgenekeepr's log on every copied file (expect exactly the 4 commits already in the copy); S39's code push finished green before its close (CI 44240187232 5/5, site 44240187166); push S39's close-out 1 and 2 (both workflows run); 17f: re-check the kinship2 gap table (docs/research/kinship2-feature-gap-analysis-2026-09-20.md, 25 exports) against pedkindraw's 31 exports, the comparison study's section 10 (docs/research/pedigree-package-comparison-2026-11.md), and Pedixplorer 1.8.0's exports and help; each gap on a typed case run with kinship2 1.9.6.2 and Pedixplorer from renv, in tryCatch() under a per-process time limit (Learning 19); a framing picker on the document's outline first, then the document, then the D4 picker
key_files: docs/planning/cran-submission-plan.md:6 (status), :471 (17e, Done :479), :496 (17f), :616 (D3), :617 (D4), :659 (dragons; 25 :730, 26 :737); docs/planning/standalone-pedigree-package-plan.md:58 (Next), :217 (R95), :957 (Done 17e); R/drawPedigreeDiagram.R:122 (legend line table), :133 (R95's columns), :246 (legend width); tests/testthat/test_drawPedigreeDiagramLegendLines.R:42, :82; tools/compareResultsWithNprcgenekeepr.R:720 (eachDrawing), :805 (R95 set-aside); DIVERGENCE.md:17; methodology/BACKLOG.md:47 (R95 port), :58 (17f), :116 (the suite gate's time limit)
gotchas: the suite takes 273-297 s now, and quality_ratchet --run measured all 5 gates in 297 s, 3 s under the suite gate's 300 s limit (BACKLOG :116); the fidelity tool prints three set-asides (R81 36 drawings; R94 33 drawings, 3,152 entries; R95 120 drawings in the 48 drawing-case results), any other count is a change; the drawing results are 48 of 600 (12 pedigrees by 4 cases), not 33; read browser positions from vis.js, not a chromote screenshot (about 30 px off); never pipe a chromote script into head; rm -rf with shell variables is refused by Claude Code's safety check; nprcgenekeepr moves often (4 commits during S39, none on a copied file); HANDOFFS.md 180,183 B after S39's receipt, of its 196,608 B trigger (about 3 more sessions at 5-6 KB each, an estimate)
runtime_smoke: library change verified by its tests and checks, not an app: suite 57 files, 707 blocks, 0 failed, 0 errors, 0 skipped, WARN 0 (GREEN 1 and REFACTOR); R CMD check --as-cran 1 NOTE (R16's) on f4f5744; the shipped vignettes (from the build's tarball) in headless Chrome: 12 drawings 700 px wide, 48 of 48 legend line labels whole, on white, no arrowhead; the live website after the push, 12 drawings 776 px wide, 48 of 48 the same (before: all 12 covered 5.5 px); fidelity tool exit 0, 600 of 600 identical (nprcgenekeepr at 3b8bf9374); drift tool 91, 14 differ, 0 without a row; REFACTOR's before/after record identical; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-17 · [BL-Phase 17e] S39: Phase 17e, the legend's lines have no arrowheads and their labels sit on white", "S39 push 1" and "S39 push 2"
commit: this receipt's commit (close-out 2)
```
```
S39 made Phase 17e: measured first, the legend's "Same animal, again" label was covered by the arrowhead visNetwork
gives every legend line, not cut by the legend's width as S31, the plan and S38 had framed it; by Mark's picks the
legend's lines lose their arrowheads (the diagram's lines have none) and each label sits on white. Each picker stated
measured results, the repository's code was the measured draft, and the DONE line was checked in headless Chrome on
the live site before and on the shipped vignettes after. Port to nprcgenekeepr later (R95): a `DIVERGENCE.md` row and
a fidelity-tool set-aside until then; at REFACTOR, by Mark's pick over Claude's recommendation to skip, the tool's
three set-asides share one walk. Model: Claude Opus 5.5, one tier.

```handoff
session: S38
date: 2026-11-17
status: complete
self_score: 9
predecessor_score: 9
active_task: Phase 17d DONE (R94): the "Select by id" box lists the animals only, .buildMatingUnitForest() refuses a real id starting __jog_, and the six reserved prefixes are written once (.reservedIdPrefixes, .reservedIdPattern). Next: Phase 17e, the legend's "Same animal, again" label fits (docs/planning/cran-submission-plan.md:471), strict TDD, copied code (D3 at its pre-RED picker); measure first at 776 px and 700 px
what_was_done: claim 09a9737 (pushed with S37's close-out 1 and 2: CI 44218384987 5/5). Before RED, on scratch copies: found the input check's prefix list also missing __jog_ and measured the collision (smallPed with B renamed __jog_1_a: two nodes of that id, no error); the colony box in headless Chrome 572 options; both RED variants; the whole suite on the draft (705 blocks, 0 failed); pedkindraw's own fidelity runs on HEAD and the draft (33 of 600 differ, only by 3,152 __jog_ entries). Mark's picks: "17d" (orient), "Box and check" and "Port later" (pre-RED; ruling R94 2ac5308), the RED, GREEN and REFACTOR gates (REFACTOR over Claude's "skip"). RED 88798f0 (2 tests); GREEN 1 21a164e (filter, check), GREEN 2 e75171e (fidelity allowance withoutJogSelections(), two DIVERGENCE.md rows), GREEN 3 48e4c92 (two NEWS bullets); REFACTOR 7c9e306 (prefixes written once; before/after record identical); close-out 1 18e4e8a (plans, ROADMAP, BACKLOG, dragons 23-24); close-out 2 (notes, receipt, ledger, 17e's citation :119 to :121)
next_steps: Orient; drift tool (91, 14 differ, 0 without a row); nprcgenekeepr's log on every copied file (expect exactly the 4 commits already in the copy); read CI run 44227398574's final result (its ubuntu-devel job was stuck installing packages at S38's close); push S38's close-out 1 and 2 (both workflows run); 17e: measure the label (R/drawPedigreeDiagram.R:121) against the legend (width = 0.28, :236) at the website's 776 px widget and the vignette's 700 px column in headless Chrome, for a shorter label and a wider legend, both edge styles; the legend is a canvas, so the check likely needs measureText or a screenshot (an estimate); then the D3 picker (R81 and R94 chose port later), then RED
key_files: docs/planning/cran-submission-plan.md:6 (status), :452 (17d, Done :459), :471 (17e), :600 (D3), :643 (dragons; 22 :701, 23 :705, 24 :710); docs/planning/standalone-pedigree-package-plan.md:57 (Next), :216 (R94), :948 (Done 17d); R/drawPedigreeDiagram.R:121 (label), :236 (legend width), :248 (stepY), :298 (box filter); R/makePedigreeDiagramData.R:389-:391 (reserved prefixes), :466 (input check); tests/testthat/test_drawPedigreeDiagram.R:210; tests/testthat/test_buildMatingUnitForest.R:82; tools/compareResultsWithNprcgenekeepr.R:726 (R81 allowance), :766 (R94 allowance); DIVERGENCE.md:16-17; methodology/BACKLOG.md:26 (17e), :45 (R94 port)
gotchas: the suite takes 305-312 s now, over the suite gate's 300 s limit (unmeasured; tally WARN by hand); Rscript -e with a backslash stops (put tallies in a script file); zsh's time prints total, not real; tail with two files fails on this Mac; a select box has one placeholder option more than its values; the fidelity tool now prints two allowances (R81 36 drawings; R94 33 drawings, 3,152 entries), any other count is a change; pedkindraw's --child half of the fidelity tool runs from a scratch copy, nprcgenekeepr's does not; nprcgenekeepr has the same label (:90) and moves often (4 commits during S38); HANDOFFS.md about 175 KB of its 196,608 B trigger (about 3-4 sessions, an estimate)
runtime_smoke: library change verified by its tests and checks, not an app: suite 56 files, 705 blocks, 0 failed, 0 errors, WARN 0 (GREEN 1 and REFACTOR); R CMD check --as-cran 1 NOTE (R16's) on 48e4c92 and on 7c9e306; the shipped vignette (from each build's tarball) in headless Chrome: the colony drawing's box 376 options (375 animals, no __ entry), 572 before; fidelity tool exit 0, 600 of 600 identical (nprcgenekeepr at 110709b65 and 83c50c611); drift tool 91, 14 differ, 0 without a row; every changed statement reached by the tests; REFACTOR's before/after record identical; quality_ratchet: 4/5 pass · 0 fail · 1 unmeasured · results 42b564bc4c70 · manifest 01151c525b8a; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: testthat::test_local() on 7c9e306, the last commit to change R/ or tests/, 56 files, 705 blocks, WARN 0 (311 s); CI 44228850631 on 7c9e306 5/5 success; CI 44227398574 on 48e4c92 4/5 success, ubuntu-devel unfinished at close (in setup-r-dependencies, no package check started)
changelog_ref: CHANGELOG.md "2026-11-17 · [BL-Phase 17d] S38: Phase 17d, "Select by id" lists the animals only, and a real id starting `__jog_` is refused", "S38 push 1", "S38 push 2" and "S38 push 3"
commit: this receipt's commit (close-out 2)
```
S38 made Phase 17d: the "Select by id" box no longer lists the routing points a rectilinear drawing adds, and,
by Mark's pick after a measured finding, the layout refuses an animal id that would collide with one; at REFACTOR,
by Mark's pick over Claude's recommendation to skip, the six reserved prefixes are written once. Each picker stated
results measured on scratch copies, the repository's changes were those drafts, proved byte-identical, and the DONE
line was checked on the vignette as shipped in headless Chrome. Port to nprcgenekeepr later (R94): two
`DIVERGENCE.md` rows and a fidelity-tool allowance until then. Model: Claude Opus 5.5, one tier.

```handoff
session: S37
date: 2026-11-17
status: complete
self_score: 9
predecessor_score: 9
active_task: Phase 17c3 DONE (getProbandPedigree(ped, probands), getDescendantPedigree(ped, probands), trimPedigree(ped, probands, ...), hasBothParents(ped, id); R89), so Phase 17c is DONE. Next: Phase 17d ("Select by id" leaves out the routing points, docs/planning/cran-submission-plan.md:451) or 17e (the legend's "Same animal, again" label fits, :459), either order, strict TDD, copied code (D3 at the pre-RED picker). The orient picker offers 17d (recommended) or 17e
what_was_done: claim e241cd0 (pushed with S36's close-out 1 and 2: CI 44203608487 5/5, site success). Before RED: the parse of every call (65, 42 unchanged, 23 to rewrite, exactly R89's); both RED variants measured on HEAD; the whole suite on a scratch copy with all 23 rewrites drafted, 703 blocks 0 failed; the help examples, the vignette's code and the regenerated pages on the draft. Mark's picks, each Claude's recommendation at the first asking: 17c3; the 8 old-order test calls in RED; hasBothParents()'s tests in a new file; getParents()'s order sentence dropped; a new NEWS bullet; the RED and GREEN gates; skip REFACTOR. RED 374f970 (7 failures exactly where measured, WARN 0); GREEN 1 8f921d5, GREEN 2 6a2caf9 (code, pages, vignette), GREEN 3 4602b7c (fidelity tool, 4 DIVERGENCE.md rows), GREEN 4 2b6ef7a (help sentence, NEWS); close-out 1 758e528 (plans, contract, ROADMAP, BACKLOG; dragons 21-22; R89's citation :50); close-out 2 (notes, receipt, ledger)
next_steps: Orient; drift tool (91, 14 differ, all with rows); nprcgenekeepr's log on every copied file (expect exactly the 4 commits already in the copy); push S37's close-out 1 and 2 (both workflows run); 17d: the D3 picker (nprcgenekeepr fixed too, in a session there, or a DIVERGENCE.md reason beside R81's) and, measured S37, the fidelity tool's rectilinear drawing cases of 11 of 12 pedigrees hold __jog_ entries, so it needs an allowance like withoutConditionSymbols() until nprcgenekeepr has the fix; draft in a scratch copy and run the whole suite there; RED reads drawPedigreeDiagram(layout)$x$idselection$values on smallPed's rectilinear layout (2 jogs); DONE includes the colony drawing in headless Chrome. 17e: measure a shorter label against a wider column at 776 px and 700 px first
key_files: docs/planning/cran-submission-plan.md:6, :451 (17d), :459 (17e), :588 (D3), :599 (session map), :631 (dragons; 10 :656, 21 :685, 22 :689); docs/planning/standalone-pedigree-package-plan.md:56 (Next), :938 (Done 17c3); R/drawPedigreeDiagram.R:119 (label), :290, :292 (filter); tools/compareResultsWithNprcgenekeepr.R:450 (drawing case), :723 (withoutConditionSymbols); vignettes/drawing.Rmd:626 (colony drawing); DIVERGENCE.md:17; methodology/BACKLOG.md:26 (17d), :36 (17e)
gotchas: the fidelity tool compares drawings whole, and rectilinear layouts of 11 of its 12 pedigrees have __jog_ select entries (rhesus375 190, synthetic_300 436, smallPed 2; direct none), so 17d makes them differ unless an allowance is added; the backlog's 571/196 is the vignette's drawing, the defaults give 565/190; nprcgenekeepr has the same filter (:252 at 2eb3920b0) and label (:90); code outside test_that() fails RED as one file error (dragon 21); the fidelity tool runs from the repository, not a scratch copy (dragon 22); a check's URL NOTE can be transient (dragon 10); the suite gate's 300 s limit was hit this session (backlog, Phase 17l); Rscript -e with a backslash regex fails, use a file or [.]; CLAUDE.md over budget (learnings in the plan's dragons)
runtime_smoke: library change verified by its tests and checks, not an app: suite 56 files, 703 blocks, 0 failed, 0 errors, WARN 0; R CMD check --as-cran 1 NOTE (R16's) on the second run; fidelity tool exit 0, 600 of 600 identical, 132 kinship matrices, largest difference 0 (nprcgenekeepr at 8ebd33d39); drift tool 91, 14 differ, 0 without a row; the changed files' lines all reached by their tests; quality_ratchet: 4/5 pass · 0 fail · 1 unmeasured · results 42b564bc4c70 · manifest 01151c525b8a; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: testthat::test_local() on 2b6ef7a, the last commit to change R/ or tests/, 56 files, 703 blocks, WARN 0 (258 s); CI 44212240619 5/5 success at the first attempt (16 min)
changelog_ref: CHANGELOG.md "2026-11-17 · [BL-Phase 17c3] S37: Phase 17c3, the pedigree first in `getProbandPedigree()`, `getDescendantPedigree()`, `trimPedigree()` and `hasBothParents()`", "S37 push 1" and "S37 push 2"
commit: this receipt's commit (close-out 2)
```
S37 made Phase 17c3: `getProbandPedigree()`, `getDescendantPedigree()`, `trimPedigree()` and `hasBothParents()` take
the pedigree first, and the 23 calls that passed both arguments by position changed with them; an old-order call
now stops with an error, tested in each. Before each picker the choices were measured on scratch copies (both RED
variants, the whole suite on the drafted change), and the repository's changes were those drafts, proved
byte-identical. Every pick was Claude's recommendation at the first asking; REFACTOR was skipped by Mark's pick.
Model: Claude Opus 5.5, one tier.

```handoff
session: S36
date: 2026-11-17
status: complete
self_score: 9
predecessor_score: 9
active_task: Phase 17c2 DONE (getParents(ped, ids), getOffspring(ped, ids), getIdsWithOneParent(ped), addBackSecondParents(trimmedPed, ped); R88). Next: Phase 17c3, strict TDD (docs/planning/cran-submission-plan.md:428; R89 :207): the pedigree first in getProbandPedigree(), getDescendantPedigree(), trimPedigree() and hasBothParents(), and the 23 calls that pass both by position; four DIVERGENCE.md rows; about 16 files. The orient picker offers 17c3 (recommended) or a drawing fix (17d, 17e)
what_was_done: claim a78de5b (pushed with S35's close-out 1 and 2: CI 44185838926 5/5, site success). Before RED: the parse's 24 calls, none by name; git grep 35 lines in 8 files; the whole suite on a scratch copy with the renames drafted, 697 blocks 0 failed; the drafted RED blocks on HEAD and the draft, which found that partial matching lets getParents(ped = ) and getOffspring(ped = ) reach pedSourceDf on the old code (dragon 20). Mark's picks, each Claude's recommendation at the first asking: 17c2; getIdsWithOneParent()'s tests in a new file; a NEWS line now; the RED and GREEN gates; skip REFACTOR. RED ef101e8 (5 new blocks failing, WARN 0); GREEN 1 91f65e5, GREEN 2 858cfc9 (code, pages, 4 DIVERGENCE.md rows), GREEN 3 7d4de5d (NEWS); close-out 1 26076c3 (plans, contract, ROADMAP, BACKLOG; 17c3's help sentence at R/getParents.R:14; dragon 20); close-out 2 (notes, receipt, ledger; R89's citation of R/addBackSecondParents.R:45, now :49)
next_steps: Orient; drift tool (91, 10 differ, all with rows); nprcgenekeepr's log on every copied file (expect exactly the 4 commits already in the copy); push S36's close-out 1 and 2 (both workflows run); 17c3: nprcgenekeepr's log on the four files, re-parse the calls (65 at 5525edd, 23 by position) and read the fidelity tool's fn() calls by hand, then the whole suite on a scratch copy with the order swapped and the 23 calls rewritten (dragon 18); the pre-RED picker (where hasBothParents()'s names test goes, whether the 8 positional test calls change in RED or GREEN, the NEWS wording) and the RED gate; RED expect_named per function (dragon 20) and a new-order call equal to a call by name; GREEN in commits of at most 5 files, each a function with its callers; then 17c's DONE list (plan :433) and CI
key_files: docs/planning/cran-submission-plan.md:6, :207 (R89, the 23 calls), :388 (17c; 17c2 Done :419, 17c3 :428, DONE :433), :586 (session map), :618 (dragons; 16 :651, 20 :666); docs/planning/standalone-pedigree-package-plan.md:55 (Next), :209 (R89), :931 (Done 17c2); docs/planning/pedkindraw-api-contract.md:123, :128, :129, :130; R/getProbandPedigree.R:33; R/getDescendantPedigree.R:34; R/trimPedigree.R:57, :59; R/hasBothParents.R:31; R/addBackSecondParents.R:49; R/getParents.R:14; vignettes/pedkindraw.Rmd:152; tools/compareResultsWithNprcgenekeepr.R:104; DIVERGENCE.md:23; NEWS.md:47; methodology/BACKLOG.md:11
gotchas: a rename's named call can pass on the old code through partial matching, so expect_named(formals(f)) carries RED (dragon 20); for the order change the positional calls break ("$ operator is invalid for atomic vectors"), the named ones keep working; the fidelity tool's calls must name their arguments to run on both packages (R89); getParents()'s help sentence on the order (R/getParents.R:14-16) becomes false, and man/getOffspring.Rd inherits it; there is no test_hasBothParents.R; nprcgenekeepr runs sessions beside this one (it moved four times in S36): read it at a commit for the fidelity tool; parse, skipping the empty argument by index; scratch copies with env -u RENV_PROJECT and --no-init-file; quality_ratchet runs as python3 methodology/quality_ratchet.py --run; CLAUDE.md over budget (learnings in the plan's dragons)
runtime_smoke: library change verified by its tests and checks, not an app: suite 55 files, 698 blocks, 0 failed, 0 errors, WARN 0; R CMD check --as-cran 1 NOTE (R16's); fidelity tool exit 0, 600 of 600 identical, 132 kinship matrices, largest difference 0; drift tool 91, 10 differ, 0 without a row; the four functions' statements all reached; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a; CI 44191349985 5/5 success at the first attempt (17 min)
changelog_ref: CHANGELOG.md "2026-11-17 · [BL-Phase 17c2] S36: Phase 17c2, the pedigree argument is `ped` in `getParents()`, `getOffspring()`, `getIdsWithOneParent()` and `addBackSecondParents()`", "S36 push 1" and "S36 push 2"
commit: this receipt's commit (close-out 2)
```
S36 made Phase 17c2: the pedigree argument is `ped` in `getParents()`, `getOffspring()` and `getIdsWithOneParent()`,
and `addBackSecondParents()` takes `(trimmedPed, ped)`, in the old positions, so no call changed. Running the drafted
tests on both the old code and the draft before RED showed that R's partial matching already let `ped =` reach
`pedSourceDf`, so the names check is what fails a rename's RED (dragon 20). Every pick was Claude's recommendation at
the first asking; REFACTOR was skipped by Mark's pick.

```handoff
session: S35
date: 2026-11-17
status: complete
self_score: 8
predecessor_score: 8
active_task: Phase 17c1 DONE (kinship(id, sire, dam, pdepth, ...) and its pdepth check; R87, R91, R92). Next: Phase 17c2, strict TDD (docs/planning/cran-submission-plan.md:416; R88 :205): the pedigree argument is ped in getParents(), getOffspring() (were pedSourceDf), getIdsWithOneParent() (was uPed), with addBackSecondParents(trimmedPed, ped) (was uPed); names only, no caller changes; four DIVERGENCE.md rows; then 17c3 (R89). The orient picker offers 17c2 (recommended) or a drawing fix (17d, 17e)
what_was_done: claim 4fc0e1a (pushed with S34's close-out 2: CI 44168447176 5/5, site success). Before RED, a scratch copy with a drafted check: every expected value run against the draft and HEAD (one wrong case caught); HEAD silently wrong in 425 of minnbreast's 426 families and both sample.ped families, the draft stopping all 428 and passing findGeneration()'s numbers in all 428 in 0.19 s (no CRAN skip needed); the whole suite against the draft found test_maleLeftDuplicateMate.R stopping through the layout's kinship() call on smallPed's stored gen (wrong in 8 of 17). Mark's picks, each Claude's recommendation at the first asking: the message with the hint, smallPed's gen computed in that test, a NEWS line now; RED gate; GREEN gate; skip REFACTOR. RED 3faf597 (test_kinship.R R87 test, the 3 C11 messages, new test_kinshipPdepthOrder.R 9 blocks 23 expectations, test_maleLeftDuplicateMate.R): 9 blocks failing, exactly the planned, WARN 0. GREEN 1 9e72121: R/kinship.R (sire, dam; the length message; the check after the other input checks; help: pdepth, a section on the names kinship2 and Pedixplorer share, measured: both take a pedigree or the vectors id, dadid, momid, sex), man/kinship.Rd, the DIVERGENCE.md row. GREEN 2 5adcba9: README paragraph (rendered after installing the tree), NEWS bullet. Pushed (CI 44178145615 5/5 success at the first attempt (16 min), site 44178145626 success). Close-out 1 94024bc: both plans (status, 17c1's Done, dragons 18-19), the contract, ROADMAP, BACKLOG
next_steps: Orient; drift tool (91, 6 differ, all with rows); nprcgenekeepr's log on every copied file (expect exactly the 4 commits already in the copy); push S35's close-out 1 and 2 (both workflows run: docs/planning changed); 17c2: nprcgenekeepr's log on the four files (0 at S35), re-parse the calls (S34: 24, none by name), git grep pedSourceDf/uPed (35 lines in 8 files), then the whole suite against a scratch copy with the renames (dragon 18), the pre-RED picker (where getIdsWithOneParent()'s names test goes: no test file of its own) and the RED gate; RED expect_named and a named call per function, headers naming the change; GREEN in two commits of at most 5 files (getParents and getOffspring with their pages and 2 rows; getIdsWithOneParent and addBackSecondParents with theirs); 17c's DONE list (plan :420)
key_files: docs/planning/cran-submission-plan.md:6, :194 (Decided; R88 :205), :387 (17c; 17c1 Done :404, 17c2 :416, DONE :420), :573 (session map), :605 (dragons; 18 :646, 19 :649); docs/planning/standalone-pedigree-package-plan.md:54 (Next), :207 (R88), :922 (Done 17c1); docs/planning/pedkindraw-api-contract.md:119, :120, :124, :126 (17c2 signatures); R/getParents.R:4, :11, :28; R/getOffspring.R:4, :10 (@inheritParams), :24; R/getIdsWithOneParent.R:4, :10, :27; R/addBackSecondParents.R:4, :16, :38, :40; DIVERGENCE.md:19 (kinship() row); methodology/BACKLOG.md:11
gotchas: run the whole suite against a scratch copy with the change before RED (env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib> Rscript --no-init-file); old fixtures can be wrong (smallPed's gen, 8 of 17); render the README after R CMD INSTALL -l <renv lib> . (the installed copy was older); count exports on pkgload::load_all(), not the installed copy; the parse must skip the empty argument by index; kinship() now stops an NA id, a character pdepth past 9 and kinship2's numeric sex codes, and a factor pdepth warns twice before its old error; makePedigreeMatingLayout() stops the same way on gen out of order unless given a kinshipMatrix; kinship()'s copied help still says "from his mother" (R/kinship.R:66) and its locals father/mother stay (Mark's REFACTOR pick); CLAUDE.md over budget, learnings in the notes and the plan's dragons
runtime_smoke: library change verified by its tests and checks, not an app: suite 54 files, 693 blocks, 0 failed, 0 errors, WARN 0; R CMD check --as-cran 1 NOTE (R16's); fidelity tool exit 0, 600 of 600 identical, 132 kinship matrices, largest difference 0; drift tool 91, 6 differ, 0 without a row; new check's 10 statements all reached; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a; CI 44178145615 5/5 success at the first attempt (16 min)
changelog_ref: CHANGELOG.md "2026-11-17 · [BL-Phase 17c1] S35: Phase 17c1, `kinship()` takes `sire` and `dam` and refuses generation numbers out of order", "S35 push 1" and "S35 push 2"
commit: this receipt's commit (close-out 2)
```
S35 made Phase 17c1: `kinship()` takes `sire` and `dam` and stops, naming the animal, when a known parent's
generation number is not below its offspring's, which turns kinship2's call form from a silent wrong matrix into an
error. A whole-suite run against a drafted check, before RED, found a copied layout test whose fixture stores wrong
generation numbers; Mark chose to compute them in that test. Every pick was Claude's recommendation at the first
asking; REFACTOR was skipped by Mark's pick.

```handoff
session: S34
date: 2026-11-17
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase 17b DONE (seven rulings R87-R93, no code changed). Next: Phase 17c1, kinship(), strict TDD (docs/planning/cran-submission-plan.md:394; inventory :193): parents sire and dam (R87), the pdepth check (R92), the help and README note on names shared with kinship2 and Pedixplorer (R91); then 17c2 (R88) and 17c3 (R89). The orient picker offers 17c1 (recommended) or a drawing fix (17d, 17e need 17b only)
what_was_done: claim 5525edd (pushed with S33's close-out 2, no run); 17b's inventory re-run (section 2.4's name counts held) and every call parsed to see what each change breaks; seven questions in three AskUserQuestion calls, every pick Claude's recommendation at the first asking: R87 kinship(id, sire, dam, pdepth, ...); R88 ped in getParents/getOffspring/getIdsWithOneParent, addBackSecondParents(trimmedPed, ped); R89 the pedigree first in getProbandPedigree/getDescendantPedigree/trimPedigree/hasBothParents; R90 addIdRecords() internal; R91 shared names kept with a note; R92 kinship() refuses a pdepth that puts a known parent at or after its offspring (found: kinship2's kinship(id, dadid, momid, sex) gives a silent wrong matrix, 425 of minnbreast's 426 families; the check stops all 426 and passes findGeneration()'s numbers in all 426); R93 17c in three sessions. Record 92333c3 (both plans, the contract); close-out 1 44bef08 (ROADMAP, BACKLOG), pushed; close-out 2 (notes, receipt, ledger, dragons 16-17)
next_steps: Orient; drift tool (91, 5 differ, all with rows); nprcgenekeepr's log on every copied file (expect exactly 4 commits, all in the copy); push S34's close-out 2 (methodology only); 17c1: nprcgenekeepr's log on kinship's files, re-parse kinship( calls (43, 1 by name), draft and run the check's typed cases and time the kinship2 cases in a scratch copy, then the pre-RED scope picker (minnbreast subset or skip_on_cran; a NEWS line now or in 17m) and the RED gate; RED the C13 test (test_kinship.R:238-252), the three messages (test_kinshipMemoryEquivalence.R:74-76), the check's tests; GREEN R/kinship.R, its header, roxygen, README.Rmd and its render, a DIVERGENCE.md row; 17c's DONE list (plan :407), fidelity tool included
key_files: docs/planning/cran-submission-plan.md:193 (2.4 Decided, table :201), :211 (9 DIVERGENCE.md rows), :386 (17c; 17c1 :394, check placement :398, DONE :407), :560 (session map), :592 (dragons; 16-17 last); docs/planning/standalone-pedigree-package-plan.md:205-211 (R87-R93), :882 (17c rows), :914 (Done 17b); docs/planning/pedkindraw-api-contract.md:106, :118-129, :145, :288; R/kinship.R:3, :101, :115, :118-136, :144, :165; tests/testthat/test_kinship.R:241; tests/testthat/test_kinshipMemoryEquivalence.R:74; README.Rmd:84, :145; DIVERGENCE.md:12; methodology/BACKLOG.md:11, :19, :23
gotchas: count what a change breaks by parsing (tools::Rd2ex for examples, knitr::purl for README and vignettes), recording each call's pkg:: before stripping it (the picker's 45 of 46 was 42 of 43), and read the fidelity tool's fn("name")(...) calls by hand; zsh does not split an unquoted variable (P="R tests"; git grep -- $P finds nothing); kinship()'s silent wrong answer is live until 17c1; minnbreast's sex has 1,761 NA (code 3); the new check goes after every existing input check so the fidelity tool's kinshipErrors messages stay; the sire/dam words gate; CLAUDE.md over budget, learnings in the notes and the plan's dragons
runtime_smoke: n/a -- documents only (R/, tests/, vignettes/, man/, inst/, tools/, DESCRIPTION unchanged); quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a (load 3.7-5.6); site run 44162711010 success; CI 44162710948 5/5 success at the first attempt (16 min)
changelog_ref: CHANGELOG.md "2026-11-17 · [BL-Phase 17b] S34: Phase 17b, the argument-name review", "S34 push 1" and "S34 push 2"
commit: this receipt's commit (close-out 2)
```
S34 ran Phase 17b, the argument-name review, as seven questions in three pickers, each answered with Claude's
recommendation: `kinship()` takes `sire` and `dam`; the pedigree argument is `ped` and comes first in every export;
`addIdRecords()` stays internal; shared names stay, with a note. Measuring the shared `kinship()` found that
kinship2's own call form gives pedkindraw a wrong matrix silently; Mark ruled that 17c1 adds a check. The changes are
three test-first sessions (R93). Self 8: + parsed every call rather than counting text, and checked the new check on
426 families before claiming it; - two picker counts were corrected only in the record (neither changed a decision),
and three wrapping slips took later commits. Model: Claude Opus 5.5, one tier.

```handoff
session: S33
date: 2026-11-17
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase 17a DONE (win-builder R-devel 398 s, R16's NOTE only; R86: 17k opens with one more reading after 17j). Next: Phase 17b, the argument-name review, a decision session (docs/planning/cran-submission-plan.md:341, inventory :165); the orient picker offers 17b (recommended) or a drawing fix (17d, 17e)
what_was_done: claim eaff4a7 (pushed with S32's close-out 2); the tarball from eaff4a7 built by the scratch recipe, its contents proven against git ls-files (170 kept less .Rbuildignore, plus 7 built); the same tarball's local R CMD check --as-cran 208 s at load 10-13, R16's NOTE only; uploaded by FTP to win-builder R-devel (Mark's D1 pick "I upload it via FTP (Recommended)"), result W1Ko4S0RDs2W: 398 s, install 11 s, tests 286 s (286.4 s CPU, an idle machine), vignettes 18 s, R code 16 s, examples 13 s, PDF manual 13 s, FAIL 0 WARN 0 SKIP 9 PASS 5400, the spelling step flagging nothing; ratio to this Mac 1.9 (S32 estimated 3.4-3.8); Mark's pick "Decide after 17j (Recommended)" became R86. The record 8a27fcf (cran-submission-plan.md: status, summary, section 2.1's table and decision, 17a Done, 17k rewritten, session map 18-22, dragon 8; the standalone plan: status, Next, R86, the 17k row, Done 17a); close-out 1 b8ff56b (ROADMAP; BACKLOG: 17a removed, 17b to Up Next), pushed
next_steps: Orient; drift tool (91, 5 differ, all with rows); nprcgenekeepr's log on every copied file (expect exactly 4 commits, 4283e3502 a85311021 392dd347e 471589138, already in the copy); push S33's close-out 2 (methodology only); Phase 17b: re-run section 2.4's git grep -w inventory, read C13 (contract :102, :146; standalone plan :544) before offering to rename kinship()'s fatherId/motherId, then a picker per item (parent names, the pedigree argument's name, argument order, exporting addIdRecords(), shared export names; two AskUserQuestion calls for five items); the picks become rulings, the contract's sections 4 and 6 and the plan's inventory updated; no code
key_files: docs/planning/cran-submission-plan.md:96 (S33's win-builder record, R86), docs/planning/cran-submission-plan.md:165 (2.4 names, 17b's inventory), docs/planning/cran-submission-plan.md:341 (17b), docs/planning/cran-submission-plan.md:422 (17k), docs/planning/cran-submission-plan.md:493 (decisions; D2 :498), docs/planning/cran-submission-plan.md:554 (dragon 8), docs/planning/standalone-pedigree-package-plan.md:53 (Next), docs/planning/standalone-pedigree-package-plan.md:204 (R86), docs/planning/standalone-pedigree-package-plan.md:544 (C13 names), docs/planning/pedkindraw-api-contract.md:102 (C13), docs/planning/pedkindraw-api-contract.md:271 (6, versioning), methodology/BACKLOG.md:11 (17b)
gotchas: a win-builder reading may come from an idle machine: read examples_and_tests/tests/testthat.Rout's proc.time() (CPU against elapsed) before trusting a margin; the check time in seconds is in the email, not 00check.log, which times only steps of 10 s or more; the FTP upload worked (curl -T to ftp://win-builder.r-project.org/R-devel/, reply 226, result in about 15 min), each upload needs Mark's approval in the session; this Mac at load 10-13 during S33's timings; the copied test_positionMatingUnitForest.R prints three message() lines into the check's test output (not flagged); the sire/dam words gate binds any parent-argument rename in user-facing text; carried: no hunspell dictionary here, 7 of 9 Suggests in R's own library, count copied files by the capitalized header (79), nprcgenekeepr counts go stale (169 at 3c87a17a9), the suite gate counts warnings only and times out under load, CLAUDE.md over budget, pedkindraw.Rproj untracked (Mark's)
runtime_smoke: n/a -- no package code changed (R/, tests/, vignettes/, man/, inst/, DESCRIPTION identical to d00ebda); the tarball's R CMD check --as-cran here R16's NOTE only, tests FAIL 0 WARN 0 SKIP 8 PASS 5401; win-builder R-devel W1Ko4S0RDs2W R16's NOTE only, FAIL 0 WARN 0 SKIP 9 PASS 5400; site run 44153786342 success; CI 44153786408 5/5 success at the first attempt (20 min); quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a (load 4.6-14.8)
changelog_ref: CHANGELOG.md "2026-11-17 · [BL-Phase 17a] S33: Phase 17a, the check time on win-builder R-devel", "S33 push 1", "S33 upload" and "S33 push 2"
commit: this receipt's commit (close-out 2)
```
S33 measured Phase 17a. The tarball from `eaff4a7` passed the local CRAN-style check, then went to win-builder R-devel
by FTP with Mark's approval: 398 s and only the new-submission NOTE, against S32's estimate of 615-688 s. The tests'
CPU time equalled their elapsed time, so win-builder was idle; a busy day could read about 470-550 s. Mark chose to
decide any cut of the tests CRAN runs after 17j, by one more reading (R86). Self 8: + measured before every picker,
read the reading's busyness instead of its face value, proved the tarball's contents; - the first replies lacked the
TDD phase line, and the 10-40 s for 17b-17j is a guess. Model: Claude Opus 5.5, one tier.

```handoff
session: S32
date: 2026-11-16
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase 17, the CRAN submission, is planned (docs/planning/cran-submission-plan.md, R83-R85, phases 17a-17q). Next: Phase 17a, the check time on win-builder R-devel, Mark approving the upload; the orient picker offers 17a (recommended) or 17b, the name review
what_was_done: claim ba811e7 (pushed with S31's close-out 2); measured on this Mac under load 5.3-12.7: R CMD check --as-cran 181 s (tests 118 s, examples 1.1 s), R16's NOTE only, win-builder estimate 615-688 s; CRAN-mode tests 684, 0 failed, 8 skipped, 103.6 s, eight files 81%; static checks clean; spelling 49 words, 0 in DESCRIPTION; mockery and withr unguarded in tests; 7 of 9 Suggests in R's own library; names shared with nprcgenekeepr (22 of 31), kinship2 (6), Pedixplorer (1) and the call sites of each name the review may change; nprcgenekeepr 165 commits after baef1e12c, none to the 79 copied files' sources. Mark's picks: "Release plan, all three (Recommended)" after his clarification, "This outline (Recommended)", all four open items before the release, "Measure on win-builder first (Recommended)". The plan 4886bb9; close-out 1 53afbfe (standalone plan status, R83-R85, Phase 17's table and Done record; contract section 6 note; ROADMAP; BACKLOG retagged), pushed
next_steps: Orient; drift tool (91, 5 differ, all with rows); nprcgenekeepr's log on every copied file (expect exactly 4 commits, 4283e3502 a85311021 392dd347e 471589138, already in the copy); push S32's close-out 2 (methodology only); Phase 17a: build the tarball by the scratch recipe, the D1 picker (Mark uploads at win-builder.r-project.org/upload.aspx, or Claude after his OK), read the emailed result's 00check.log, record it in the plan's section 2.1, decide whether 17k is needed against 540 s
key_files: docs/planning/cran-submission-plan.md:57 (2.1 check time), docs/planning/cran-submission-plan.md:124 (2.4 names), docs/planning/cran-submission-plan.md:193 (4 nprcgenekeepr), docs/planning/cran-submission-plan.md:283 (17a), docs/planning/cran-submission-plan.md:446 (decisions), docs/planning/cran-submission-plan.md:463 (session map), docs/planning/standalone-pedigree-package-plan.md:52 (Next), docs/planning/standalone-pedigree-package-plan.md:200 (R83-R85), docs/planning/standalone-pedigree-package-plan.md:860 (Phase 17), docs/planning/pedkindraw-api-contract.md:277 (the review is 17b), methodology/BACKLOG.md:11 (17a), methodology/BACKLOG.md:195 (name review)
gotchas: this Mac is loaded by other projects (timings at load 5-13, gates at 84-89): record uptime beside every timing; no English hunspell dictionary, so the incoming spelling step never runs here (use the spelling package from R's own library); R's own library holds 7 of 9 Suggests, so a depends-only check here hides only kinship2 and Pedixplorer; count copied files by the header's capitalized "Copied from nprcgenekeepr"; counts taken in nprcgenekeepr go stale within a session (163, then 165); uploads and the submission are outward actions needing Mark's approval; no CRAN link or badge before acceptance; the suite gate counts warnings only; CLAUDE.md over budget; pedkindraw.Rproj untracked (Mark's)
runtime_smoke: n/a -- docs-only (no package code changed: R/, tests/, vignettes/ identical to d00ebda); the CRAN-mode check R16's NOTE only; site run 43990847843 success; CI 43990847828 5/5 success at the first attempt; quality_ratchet: 4/5 pass · 0 fail · 1 unmeasured · results 42b564bc4c70 · manifest 01151c525b8a; unmeasured: test-suite-warnings-zero (timeout 300 s at load 88-214) — by hand: test_local() 684 tests, 0 failed, 0 skipped, WARN 0, 6,109 passed
changelog_ref: CHANGELOG.md "2026-11-16 · [BL-Phase 17] S32: Phase 17's plan, the CRAN submission", "S32 push 1" and "S32 push 2"
commit: this receipt's commit (close-out 2)
```
S32 wrote Phase 17's plan. Mark sent the first orient picker back to say that a release plan should weigh the other
open work, nprcgenekeepr's changes and the comparison with kinship2 and Pedixplorer; the plan does all three. The
measurements came before the scope picker: the check near CRAN's 10-minute limit on CRAN's slower machines, the
tests' time by file, the names, the unguarded Suggests, nprcgenekeepr unchanged on every copied file. Mark put all
four open items before the release and chose to measure on win-builder first. Self 8: + counts in every picker; the
outline before the writing; each phase's surface named; five wrong numbers caught by re-checking the draft before
its commit. - the first picker's framing missed what Mark wanted; timings under other projects' load; "615-690 s"
told to Mark before the arithmetic was exact (615-688).

```handoff
session: S31
date: 2026-11-16
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase 16 is DONE (Phase 16e, the website, https://rmsharp.github.io/pedkindraw/). Next by the plan: Phase 17, the CRAN submission, its own plan first; the orient picker offers Phase 17's plan, the argument-name review, the "Select by id" bug or the cut legend label, the gap document, coverage, or hold
what_was_done: claim 81a2829; _pkgdown.yml (url, destination pkgdown_site, Bootstrap 5, the 32 help pages in ?pedkindraw's seven groups; check_pkgdown() run on the incomplete index first, 28 topics missing, then "No problems found") and .github/workflows/pkgdown.yaml (push to master and by hand, the package installed, CLAUDE.md and DIVERGENCE.md deleted from the runner's copy, deploy to gh-pages with JamesIves v4.8.0 at d92aa23) with .Rbuildignore and .gitignore lines, 4c389e7; the first site run made gh-pages (no project note on it); GitHub Pages turned on with Mark's approval; the site 200, the notes 404, every node of all 12 drawings inside its canvas on the live articles; the site in DESCRIPTION's URL, the README and ?pedkindraw's links, d00ebda; close-out 1 93e3cae (the plan's Done 16e and Done 16, the documentation plan, ROADMAP, BACKLOG: Phase 17's plan and the legend label added)
next_steps: Orient; drift tool (91 functions, 5 differ, all with rows); nprcgenekeepr's log on the six copied drawing files since b4abb9a0b (R81's port unblocks BACKLOG.md:48); push S31's close-out 2 with the first push (methodology only); check the site answers (R CMD check --as-cran reads it); the orient picker: Phase 17's plan (a planning session modeled on nprcgenekeepr's docs/planning/cran-3.0.0-submission-plan.md; recommended, not measured), the argument-name review, "Select by id" or the legend label, the gap document, coverage
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK), docs/planning/standalone-pedigree-package-plan.md:51 (Next), docs/planning/standalone-pedigree-package-plan.md:829 (Done 16e), docs/planning/standalone-pedigree-package-plan.md:855 (Phase 17), docs/planning/documentation-plan.md:221 (Built S31), docs/planning/documentation-plan.md:314 (what waits for Phase 17), docs/planning/pedkindraw-api-contract.md:271 (versioning, the name review), _pkgdown.yml:14 (reference index), .github/workflows/pkgdown.yaml:49 (notes deleted), .github/workflows/pkgdown.yaml:57 (deploy pin), DESCRIPTION:13 (URL), README.Rmd:34 (the site's paragraph), methodology/BACKLOG.md:11 (Phase 17's plan), methodology/BACKLOG.md:41 (legend label), methodology/BACKLOG.md:185 (name review)
gotchas: check_pkgdown() stops at its URL check before the index until DESCRIPTION's URL holds the site; R run inside a scratch copy of the repository starts renv from .Rprofile (RENV_CONFIG_AUTOLOADER_ENABLED=false), and renv is active on the runners too; both workflows run on any push beyond CLAUDE.md and methodology/** and never save their package cache (a post-step Path Validation Error); pkgdown publishes every root .md but README, NEWS and LICENSE; the README is the site's home page; this Mac's case-insensitive disk makes 45 pages to CI's 46; the suite gate counts warnings, not failures; CLAUDE.md over its budget; pedkindraw.Rproj untracked (Mark's)
runtime_smoke: the site run on GitHub (43979094493, 43981525853) and served by Pages: https://rmsharp.github.io/pedkindraw/ 200 with both articles, every node of all 12 drawings inside its canvas in headless Chrome (failing when zoomed in); R CMD check --as-cran R16's NOTE only, the live URLs read; suite 684 tests, 0 failed, WARN 0, 6,109 passed; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-16 · [BL-Phase 16e] S31: plan Phase 16e, the website; Phase 16 DONE", "S31 Pages" and "S31 push 1" to "S31 push 4"
commit: this receipt's commit (close-out 2)
```
S31 built the pkgdown website and closed Phase 16. Mark approved the site's outline before its settings were
written (S30's lesson), chose pkgdown from R's own library for local builds and the deploy action's version, and
approved turning on GitHub Pages after the first run had made `gh-pages`. The site's address went into `DESCRIPTION`
and the README only once it answered. Self 8: + every picker stated measured counts; the check failed first; the
live site was checked in a browser with a check that could fail; the suite tallied for failures. - one wasted run
(renv started inside the scratch tree); a grep's false 404, explained; the legend's cut label seen at one width
only.

```handoff
session: S30
date: 2026-11-16
status: complete
self_score: 7
predecessor_score: 9
active_task: Phase 16d is DEFERRED (ruling R82): the comparison of pedkindraw with kinship2 and Pedixplorer waits until pedkindraw times itself; the draft is on the branch draft/speed-vignette (612eed9, not merged). Next: Phase 16e, the website, with two articles (docs/planning/documentation-plan.md section 5.6, DONE at its 16e item), READY; Phase 16 DONE after it
what_was_done: claim a580612 (pushed with S29's two close-out commits, CI 43958321631 5/5); tools/checkSpeedTables.R written first and run failing (0 of 417 numbers), then the draft vignettes/speed.Rmd (nine captioned tables, 366 of 366 cells holding a number and 621 of 621 cells matching, four planted changes each failing the check, a separate check against the studies' printed tables on 298 cells, a definition of each computation at Mark's request); Mark judged the comparison premature while pedkindraw tracks nprcgenekeepr: R82; the draft on the branch draft/speed-vignette (612eed9, pushed); ruling 6883985 (the plan's R82, notes on R77 and R79, status, Phase 16 row, "Deferred 16d" record; the documentation plan's notes and 16e's two articles; the contract's shrink row with the rewrite's 3.69 s and 92.0 s); close-out 1 7de3d09 (ROADMAP, BACKLOG), pushed, CI 43966717453 5/5; no package file changed
next_steps: Orient; drift tool (91 functions, 5 differ, all with rows); nprcgenekeepr's log on the copied drawing files since b4abb9a0b (if it has ported R81, BACKLOG.md:41 is unblocked); push S30's close-out 2 with the first push; the orient picker offers 16e (recommended), the "Select by id" bug (BACKLOG.md:32), the gap document (:52), coverage (:62), or hold; for 16e measure D4's two ways (pkgdown into renv by Learning 3's recipe, 9 packages, or from R's own library) and a trial build_site() into a scratch folder with the package installed before the picker; Pages turned on only with Mark's approval; DESCRIPTION's URL only once the site answers
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK), docs/planning/documentation-plan.md:209 (5.6, the website), docs/planning/documentation-plan.md:290 (16e's DONE), docs/planning/documentation-plan.md:334 (D4), docs/planning/standalone-pedigree-package-plan.md:192 (R78), docs/planning/standalone-pedigree-package-plan.md:196 (R82), docs/planning/standalone-pedigree-package-plan.md:815 (Deferred 16d), DESCRIPTION:13 (URL), .github/workflows/R-CMD-check.yaml:7 (triggers), methodology/BACKLOG.md:11 (16e), methodology/BACKLOG.md:19 (the speed vignette later), methodology/BACKLOG.md:117 (the stale copy)
gotchas: show Mark a page's framing in a picker before filling it, and define its terms (S30 built nine checked tables before Mark judged the framing premature, and Mark asked what three rows meant); CI's paths-ignore lists only CLAUDE.md and methodology/**, so docs/planning pushes start a full run; chromote clips in page coordinates (sips --cropOffset ignored its offsets); Table: captions render above html_vignette tables; `cmd | tail; echo $?` is tail's status; zsh does not split an unquoted $VAR; Rscript -e with "\\|" fails, use a file; the suite gate's 300 s limit; the stale pedkindraw 0.0.1; CLAUDE.md over budget; pedkindraw.Rproj untracked
runtime_smoke: n/a for the package (no package file changed: git diff a580612 HEAD lists docs/planning/ and methodology/ only); the draft vignette rendered and opened in headless Chrome (35 KB, all 9 tables inside the 700 px column); the check script's failing and passing runs and four planted changes; the fidelity tool 600 of 600 identical, exit 0; drift tool exit 0; quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-16 · [BL-Phase 16d] S30: plan Phase 16d drafted and deferred (ruling R82)", "S30 push 1", "S30 branch" and "S30 push 2"
commit: this receipt's commit (close-out 2)
```

```handoff
session: S29
date: 2026-11-16
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase 16c is DONE: vignettes/drawing.Rmd, "Drawing pedigrees", 11 drawings, each statement of where an animal is drawn or what a drawing shows held by a hidden stopifnot() chunk; Mark looked at the built page. Next: Phase 16d, the speed and size-limits vignette (docs/planning/documentation-plan.md section 5.5, DONE at its 16d item), READY
what_was_done: claim 0910a03 (pushed with S28's two close-out commits, CI 43918919966 5/5); a trial page at the vignette's width (every node of 11 drawings inside its canvas in headless Chrome; page 2,040,883 B; installed 4,316 KB from a scratch build; the colony warning and the direct style measured; a click's ids and the "Select by id" box measured); Mark's picks "As drafted", "Show and explain", "Numbers now"; vignette 7ab93a0 (vignettes/drawing.Rmd; ?pedkindraw and the getting-started vignette's Where next name it; man/pedkindraw-package.Rd), pushed, CI 43937366764 5/5; Mark's "Looks right" on the built page; close-out 1 5c1eb1c (the plan's status and Done 16c, the documentation plan's S29 note, ROADMAP, BACKLOG: 16d's pointers, the "Select by id" bug, the suite gate's time limit)
next_steps: Orient; drift tool (91 functions, 5 differ, all with rows); nprcgenekeepr's log on the copied drawing files since b4abb9a0b (if it has ported R81, BACKLOG.md:33 is unblocked); push S29's two close-out commits with the first push; the orient picker offers 16d (recommended), the "Select by id" bug (BACKLOG.md:24), the gap document (:44), coverage (:54), or hold; for 16d list every number its tables will state with its source file, commit and cell, and write tools/checkSpeedTables.R and run it failing before the tables are filled; then point ?pedkindraw, the getting-started vignette and the drawing vignette's size section at the new vignette
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK), docs/planning/documentation-plan.md:67 (the timing records), docs/planning/documentation-plan.md:185 (5.5), docs/planning/documentation-plan.md:269 (16d DONE), docs/planning/pedkindraw-api-contract.md:279 (section 7), vignettes/drawing.Rmd:681 (the size section), vignettes/pedkindraw.Rmd:399 (Where next), R/pedkindraw-package.R:42 (Getting started), R/drawPedigreeDiagram.R:292 (the box's filter), methodology/BACKLOG.md:11 (16d-16e), methodology/BACKLOG.md:100 (the suite gate's limit)
gotchas: a widget's first canvas is the legend's, the diagram's is network.canvas.frame.canvas; judge what a reader sees from a picture (an escaped .vis-tooltip read misled, the picture showed the tooltip rendered), a screenshot clip needs page coordinates (r.top + scrollY) and a screenshot re-fits the legend; the invisible turning points sit between the animals' rows, y is integer under direct and double under rectilinear; an isolated animal gives a message; the suite gate's 300 s limit is below the suite's 261-271 s (cite by hand if it times out); the scratch-install recipe and the render without kinship2 (links to 123 of renv's 126 packages); installed 4,284 KB of 5,120; nprcgenekeepr's sessions commit during a session; grep -F for code text with ^ or |; .lintr excludes vignettes; words; CLAUDE.md over budget; pedkindraw.Rproj left for Mark
runtime_smoke: the built page opened in headless Chrome: every node of all 11 drawings inside its canvas (1,466 of 1,466 for the colony; 2 of 17 when zoomed to 4), hover greys the animals not near the pointer and its tooltip renders (a picture); rendered with kinship2 and Pedixplorer absent; six changed values each stopped a render; R CMD check --as-cran: 1 NOTE (Maintainer, New submission only), vignettes re-built OK, installed 4,284 KB; suite 684 tests, 0 failed, 0 skipped, WARN 0, 6,109 passed; Mark looked at the built page; CI 43937366764 5/5; quality_ratchet: 4/5 pass · 0 fail · 1 unmeasured · results 42b564bc4c70 · manifest 01151c525b8a; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: test_local() on 7ab93a0's files, 684 tests, WARN 0
changelog_ref: CHANGELOG.md "2026-11-16 · [BL-Phase 16c] S29: plan Phase 16c, the drawing vignette", "S29 push 1" and "S29 push 2"
commit: this receipt's commit (close-out 2)
```

```handoff
session: S28
date: 2026-11-16
status: complete
self_score: 8
predecessor_score: 9
active_task: the legend item is DONE (plan R81): with two or more conditions drawPedigreeDiagram()'s legend draws each condition's row as a section picture, a circle cut into the symbols' sections with that condition's section filled (.conditionLegendImage(), R/affectedConditions.R:192); with none or one the hexagon stays; to be ported to nprcgenekeepr in a session there (Mark's "Port later"), DIVERGENCE.md rows and the fidelity tool's allowance until then. Next: Phase 16c, the drawing vignette
what_was_done: claim f7c2433; both candidates drawn at 2-4 conditions, a prototype measured (1 existing test, 3 checks; 24 of 600 fidelity results, only the condition rows' shape, fill and picture), the browser check prototyped (58 of 58 right, 20 wrong on the old code); Mark's three pre-RED picks; RED 39bf333 (test_conditionLegendImage.R 8 tests incl. 58 pixels in Chrome; 3 checks of the copied test_drawPedigreeDiagram.R); GREEN 1 b6a20bf (.conditionLegendImage(), drawPedigreeDiagram()'s block and help, Rd, DIVERGENCE.md rows, NEWS); GREEN 2 6701d74 (fidelity tool's withoutConditionSymbols(), negative control); REFACTOR reviewed, no change; pushed d0068a7..6701d74; close-out 1 9413b7b (R81, plan status, documentation plan 5.4 note, ROADMAP, BACKLOG); close-out 2 (notes, receipt, ledger)
next_steps: Orient; drift tool (91 functions, 5 differ, all with rows); nprcgenekeepr's log on the legend's and layout's files (if it has ported R81, BACKLOG.md:28 is unblocked); push S28's close-out commits with the first push; the orient picker offers 16c (recommended), the gap document, coverage, or hold; for 16c draw each candidate on a trial html_vignette page at the page's width and compute every stated value first (documentation-plan.md:162 section 5.4, DONE at :250)
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK), docs/planning/documentation-plan.md:162 (5.4), docs/planning/documentation-plan.md:250 (16c DONE), vignettes/pedkindraw.Rmd:399 (Where next), R/pedkindraw-package.R:42 (Getting started), R/affectedConditions.R:192 (.conditionLegendImage), R/drawPedigreeDiagram.R:154 (S28's block), tools/compareResultsWithNprcgenekeepr.R:714 (withoutConditionSymbols), methodology/BACKLOG.md:28 (after nprcgenekeepr's port)
gotchas: chromote's screenshot(selector = "html") re-fits the legend (33 px), so read positions with JS before the shot; HTMLWidgets.find(...).network and .legend, a legend picture loaded when shape.imageObj.width > 0; the fidelity tool's --child mode measures a scratch tree; run single test files from the root (renv), regexes in script files (zsh); paste0("X", integer(0)) is "X"; the stale pedkindraw 0.0.1 in renv's library (recipe in the notes); out.width = "100%" for a vignette drawing; the 375-animal layout's 72-collision warning; the legend's pictures not measured at 700 px; .lintr excludes vignettes; CLAUDE.md over budget; pedkindraw.Rproj left for Mark
runtime_smoke: the committed drawing at 2, 3 and 4 conditions photographed in headless Chrome and looked at; the browser test reads 58 pixels (each legend section where the diagram's is); R CMD check --as-cran on 6701d74: 1 NOTE (Maintainer, New submission only), vignettes rebuilt OK, installed size OK; suite 684 tests, 0 failed, WARN 0, 6,109 passed; fidelity tool 600 of 600 identical, exit 0; drift tool 0 without a row; CI run 43913026012 5/5 success at the first attempt, 14 min, FAIL 0 WARN 0 on each (macOS PASS 6109 SKIP 0, Windows 6108 SKIP 1, Ubuntu devel, release and oldrel-1 6098 SKIP 2: S27's counts plus the new file's 180, so the browser test ran on every job); quality_ratchet: 5/5 pass · 0 fail · 0 unmeasured · results 5ddbb5b1aeb3 · manifest 01151c525b8a
changelog_ref: CHANGELOG.md "2026-11-16 · [BL-legend] S28: the legend item, each condition's legend row a section picture (plan R81)" and "2026-11-16 · [BL-legend] S28 push"
commit: this receipt's commit (close-out 2)
```

