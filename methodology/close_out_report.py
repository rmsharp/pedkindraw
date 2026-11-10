#!/usr/bin/env python3
"""close_out_report.py -- render and lint the Phase 3G close-out report.

One definition of the report's shape, used to print it and to check it, so a session never
hand-formats the last thing the operator reads.

  python3 close_out_report.py --deliverable T --outcome done --well W --badly B \\
          --predecessor P --next N          print the report
  python3 close_out_report.py --check FILE  lint a message ('-' reads stdin); exit 1 on any breach
  python3 close_out_report.py --hook        Claude Code Stop / SessionStart hook: payload on stdin; exit 0 always

The mechanical facts (session, date, both scores, HEAD, uncommitted count, the gate-run citation)
come from the newest receipt in HANDOFFS.md and from git, never from the caller. The five texts the
caller supplies are judgment, each at most FIELD_MAX characters; longer input is refused, not cut.
Session 1 has no predecessor to score (HANDOFFS.md tells it to leave `predecessor_score` out): its report
says "n/a, first session" in place of a score, and the lint accepts that line.

The hook only ever adds a message: every uncertainty resolves to allow, and an internal error is
swallowed (exit 0, never 2), so it cannot trap a session. It keeps its state under the clone's .git/
(never tracked). Python 3 stdlib only.
"""
import argparse
import hashlib
import json
import os
import re
import shlex
import subprocess
import sys
from datetime import datetime, timezone

__version__ = "1.2.1"   # 1.2.1: the shipped seed's Format example is not a receipt; Session 1 needs no predecessor_score
                        # 1.2.0: BL-101 P3 -- the receipt ledger is where the layout resolver finds it

LEDGER_NAME = "HANDOFFS.md"   # layout: ok -- the receipt ledger's own file name: the resolver's anchor

# === LAYOUT ===
# A project keeps its ledgers at its root (legacy) or under methodology/ (new): the plan's section 4.3. This
# block is the resolver, embedded byte for byte; the canonical suite asserts that. The framework anchor decides a
# tie without being asked (decided 2026-10-07, plan 7.2b): a project's own HANDOFFS.md at the root never stands in
# for the ledger.

# --- layout resolver: BEGIN ---
import os as _os
from pathlib import Path as _Path


def resolve_layout(root, anchor="SESSION_RUNNER.md"):
    """Return (kind, directory, found): kind is new|legacy|half|none, directory a Path or None,
    found the anchor paths that exist. A half-migrated tree has no directory, by design.
    A file found in both places is the framework's under methodology/ when the runner is under
    methodology/ and not at the root: the root copy is the project's own and is left alone, kind new,
    and found still names both. Any other tie stays half, and the runner cannot decide a tie about itself."""
    root = _Path(root)
    new, old = root / "methodology" / anchor, root / anchor
    found = tuple(p for p in (new, old) if _os.path.isfile(p))
    if len(found) == 2:
        if _os.path.isfile(root / "methodology" / "SESSION_RUNNER.md") and not _os.path.isfile(root / "SESSION_RUNNER.md"):
            return "new", new.parent, found
        return "half", None, found
    if not found:
        return "none", None, ()
    return ("new", new.parent, found) if found[0] == new else ("legacy", root, found)
# --- layout resolver: END ---


HEAD_RE = re.compile(r"^## Close-out report: (S\S+) · (\d{4}-\d{2}-\d{2})$")
LABELS = ("Deliverable", "Record", "Self-assessment", "Predecessor handoff", "Next session")
CLOSING = "Session over."
FIRST = "n/a, first session"  # what the predecessor line says in place of a score when there is no predecessor
FIELDS = ("deliverable", "outcome", "well", "badly", "predecessor", "next")
FIELD_MAX = 300   # characters per judgment text: one short paragraph
OUTCOME_MAX = 20  # the outcome is one word (DONE, PARTIAL, BLOCKED), not a paragraph
TOTAL_MAX = 2000  # bytes for the whole report: one screen
_FENCE_OPEN = re.compile(r"^(`{3,})([^`]*)$")   # a run of 3+ backticks and an info string, on a stripped line
_HANDOFF_OPEN = re.compile(r"^```handoff[ \t]*$")
_KEY = re.compile(r"^([a-z_]+):\s*(.*)$")
_GATE = re.compile(r"quality_ratchet:\s*([^;\n]*?pass[^;\n]*?unmeasured)")


def _closes(line, need):
    """True if `line` is a bare run of at least `need` backticks: the only thing that closes a fence."""
    s = line.strip()
    return len(s) >= need and set(s) == {"`"}


def parse_receipts(text):
    """Every top-level ```handoff block in `text`, newest first as written, as {key: first-line value}.

    The block rule is bin/check-handoff's `scan()`, written out again because that checker is canonical-only and
    this file is distributed. A fenced region opened by anything but ```handoff, such as the four-backtick wrapper
    round the seed's Format example or a ```sh block, is skipped whole, to a bare closer at least as long as its
    opener; a receipt closes at the first bare run of three or more backticks, and one never closed runs to the
    end. Nothing here reports a defect (the checker does that); tools/test_close_out_report.py
    ParityWithCheckHandoff fails on the first ledger where the two disagree about what the receipts are.
    """
    lines = text.splitlines()
    out, i = [], 0
    while i < len(lines):
        fence = _FENCE_OPEN.match(lines[i].strip())
        if fence and fence.group(2).split()[:1] != ["handoff"]:
            need, i = len(fence.group(1)), i + 1
            while i < len(lines) and not _closes(lines[i], need):
                i += 1
            i += 1  # past the closer, or past the end of an unclosed fence
        elif _HANDOFF_OPEN.match(lines[i]):
            d, i = {}, i + 1
            while i < len(lines) and not _closes(lines[i], 3):
                k = _KEY.match(lines[i])
                if k and k.group(1) not in d:
                    d[k.group(1)] = k.group(2)
                i += 1
            i += 1
            out.append(d)
        else:
            i += 1
    return out


def is_first_session(receipt):
    """True for the one receipt with no predecessor to score: S1 with `predecessor_score` absent or blank, which is
    what HANDOFFS.md tells Session 1 to write. bin/check-handoff excuses exactly this (its `is_s1`)."""
    return receipt.get("session", "").strip() == "S1" and not receipt.get("predecessor_score", "").strip()


def _git(*args, cwd=None):
    r = subprocess.run(["git", *args], capture_output=True, text=True, cwd=cwd)
    return r.stdout.strip() if r.returncode == 0 else ""


def facts(new, prev, head, dirty):
    """The mechanical facts of one report. Pure: the property test feeds it every archived receipt."""
    g = _GATE.search(new.get("runtime_smoke", ""))
    first = is_first_session(new)
    return {"session": new.get("session", "?"), "date": new.get("date", "?"),
            "self": new.get("self_score", ""), "pred": new.get("predecessor_score", ""), "first": first,
            "pred_id": "none" if first else (prev or {}).get("session", "?"), "head": head, "dirty": dirty,
            "gate": g.group(1) if g else "not cited"}


def resolve_ledger(top):
    """(the receipt ledger's path under the repository `top`, the copies found). The path is None for a
    half-migrated tree. A tree with no ledger yet gets the legacy default, so the caller's open() names it."""
    kind, directory, found = resolve_layout(top, LEDGER_NAME)
    if kind == "half":
        return None, found
    return os.path.join(str(directory if directory is not None else top), LEDGER_NAME), found


def default_ledger(cwd):
    """The receipt ledger of the repository `cwd` is in. ValueError, naming both copies, for a half-migrated tree."""
    top = _git("rev-parse", "--show-toplevel", cwd=cwd) or os.path.abspath(cwd)
    path, found = resolve_ledger(top)
    if path is None:
        raise ValueError("the receipt ledger is in both places (" + ", ".join(sorted(os.path.relpath(str(f), top) for f in found))
                         + "), a half-migrated tree: finish the move or revert it. It is not a tie only when the "
                         "runner is tracked under that directory alone")
    return path


def live_facts(ledger=None, cwd="."):
    """Facts from the newest receipt in `ledger` (default: the repository's own, found by the layout resolver) and
    from git in `cwd`. Raises ValueError if unusable."""
    if ledger is None:
        ledger = default_ledger(cwd)
    with open(ledger, encoding="utf-8") as f:
        r = parse_receipts(f.read())
    if not r:
        raise ValueError(f"no handoff receipt in {ledger}")
    if r[0].get("status") != "complete":
        raise ValueError(f"newest receipt ({r[0].get('session', '?')}) is {r[0].get('status', '?')}, not complete: "
                         "write the close-out receipt first")
    for k in ("self_score", "predecessor_score"):
        if k == "predecessor_score" and is_first_session(r[0]):
            continue  # Session 1 has no predecessor to score; the seed tells it to leave the key out
        if not re.fullmatch(r"\d+", r[0].get(k, "")):
            raise ValueError(f"newest receipt has no numeric {k}")
    head = _git("rev-parse", "--short", "HEAD", cwd=cwd)
    if not head:
        raise ValueError(f"no git HEAD in {cwd}")
    dirty = len([x for x in _git("status", "--porcelain", cwd=cwd).splitlines() if x])
    return facts(r[0], r[1] if len(r) > 1 else {}, head, dirty)


def render(m, deliverable, outcome, well, badly, predecessor, nxt):
    """The report. Refuses (ValueError) any empty or over-long text, a pipe, or a newline; never truncates."""
    given = dict(zip(FIELDS, (deliverable, outcome, well, badly, predecessor, nxt)))
    for k, v in given.items():
        if not v or not v.strip():
            raise ValueError(f"--{k} is required")
        cap = OUTCOME_MAX if k == "outcome" else FIELD_MAX
        if len(v) > cap:
            raise ValueError(f"--{k} is {len(v)} characters; the most is {cap}")
        if "|" in v or "\n" in v:
            raise ValueError(f"--{k} may not contain a pipe or a newline")
    lines = [f"## Close-out report: {m['session']} · {m['date']}", "",
             f"**{LABELS[0]}:** {deliverable} — {outcome.upper()}", "",
             f"**{LABELS[1]}:** HEAD `{m['head']}` · {m['dirty']} uncommitted · gate run: {m['gate']}", "",
             f"**{LABELS[2]}:** {m['self']}/10 — went well: {well}; did not: {badly}", "",
             f"**{LABELS[3]} ({m['pred_id']}):** {FIRST if m['first'] else m['pred'] + '/10'} — {predecessor}", "",
             f"**{LABELS[4]}:** {nxt}", "", CLOSING]
    text = "\n".join(lines) + "\n"
    n = len(text.encode("utf-8"))
    if n > TOTAL_MAX:
        raise ValueError(f"the report is {n} bytes; the most is {TOTAL_MAX}")
    return text


def lint(text, m):
    """Every rule the report breaks, as strings; [] means clean. R1-R7 are the plan's section 2.1."""
    errs = []
    lines = text.rstrip("\n").split("\n")
    nonblank = [x for x in lines if x.strip()]
    h = HEAD_RE.match(nonblank[0]) if nonblank else None
    if not h:
        errs.append("R1 the first line is not '## Close-out report: S<N> · <date>'")
    elif (h.group(1), h.group(2)) != (m["session"], m["date"]):
        errs.append("R1 the heading names a different session or date than the newest receipt")
    pos = -1
    for lab in LABELS:
        i = next((n for n, x in enumerate(lines) if re.match(rf"^\*\*{re.escape(lab)}[^*]*:\*\*", x)), None)
        if i is None:
            errs.append(f"R2 missing label: {lab}")
        elif i < pos:
            errs.append(f"R2 label out of order: {lab}")
        else:
            pos = i
    if nonblank[-1:] != [CLOSING]:
        errs.append(f"R3 the last non-blank line is not '{CLOSING}'")
    if f"{m['self']}/10" not in text or (FIRST not in text if m["first"] else f"{m['pred']}/10" not in text):
        errs.append("R4 a score differs from the newest receipt's")
    if f"`{m['head']}`" not in text:
        errs.append("R5 the HEAD sha is stale or absent")
    if "|" in text:
        errs.append("R6 a pipe character: tables do not wrap in a terminal")
    n = len(text.encode("utf-8"))
    if n > TOTAL_MAX:
        errs.append(f"R7 {n} bytes exceeds {TOTAL_MAX}")
    return errs


def _state_path(gitdir, kind, sid):
    """A per-session state file under .git/. The id is the harness's; keep it a file name, never a path."""
    return os.path.join(gitdir, f"close-out-{kind}-{re.sub(r'[^A-Za-z0-9._-]', '_', str(sid))[:100]}")


def _log(gitdir, sid, what):
    """One line per block, unclean retry or accepted report: the trace the plan's section 2.3 relies on."""
    try:
        with open(os.path.join(gitdir, "close-out-report.log"), "a", encoding="utf-8") as f:
            f.write(f"{datetime.now(timezone.utc).isoformat(timespec='seconds')} {sid} {what}\n")
    except OSError:
        pass


def _ident(receipt):
    return [receipt.get("session", "?"), receipt.get("date", "?"), receipt.get("status", "?")]


def decide(payload):
    """The Stop / SessionStart decision (plan section 2.2): the block dict, or None to allow.

    SessionStart records the newest receipt once per session_id (resume and compact never overwrite it).
    A close-out is OWED when the newest receipt is complete and is not the one the session began with, or
    that one was not yet complete. Owed, a final message that lints clean is stamped with [HEAD, commits
    ahead of upstream, receipt hash]; anything else is blocked unless the harness is already on its one
    forced retry or the stamp shows nothing changed since the last report. May raise: the CLI swallows it.
    """
    event, sid, cwd = payload.get("hook_event_name"), payload["session_id"], payload["cwd"]
    top, gitdir = _git("rev-parse", "--show-toplevel", cwd=cwd), _git("rev-parse", "--absolute-git-dir", cwd=cwd)
    if not (top and gitdir) or event not in ("SessionStart", "Stop"):
        return None
    ledger, _found = resolve_ledger(top)
    if ledger is None:
        return None  # a half-migrated tree: the hook only ever adds a message, and cannot say which ledger to read
    with open(ledger, encoding="utf-8") as f:
        receipts = parse_receipts(f.read())
    newest = receipts[0] if receipts else {}  # a seed with no receipt yet: the baseline is "nothing before it"
    base, stamp = _state_path(gitdir, "baseline", sid), _state_path(gitdir, "stamp", sid)
    if event == "SessionStart":
        try:
            with open(base, "x", encoding="utf-8") as f:
                json.dump(_ident(newest), f)
        except FileExistsError:
            pass
        return None
    if not os.path.exists(base) or "last_assistant_message" not in payload:
        return None  # hook installed mid-session, or a harness that does not send the message: fail quiet
    with open(base, encoding="utf-8") as f:
        began = json.load(f)
    if newest.get("status") != "complete" or (began[:2] == _ident(newest)[:2] and began[2] == "complete"):
        return None  # no close-out has happened in this session
    m = live_facts(ledger, top)
    state = [m["head"], _git("rev-list", "--count", "@{upstream}..HEAD", cwd=top) or "0",
             hashlib.sha256(json.dumps(newest, sort_keys=True).encode()).hexdigest()[:12]]
    errs = lint(payload["last_assistant_message"], m)
    if not errs:
        with open(stamp, "w", encoding="utf-8") as f:
            json.dump(state, f)
        _log(gitdir, sid, "reported")
        return None
    codes = ",".join(dict.fromkeys(e.split()[0] for e in errs))
    if payload.get("stop_hook_active"):
        _log(gitdir, sid, f"retry-unclean {codes}")
        return None  # the harness allows ONE forced retry per Stop chain
    if os.path.exists(stamp):
        with open(stamp, encoding="utf-8") as f:
            if json.load(f) == state:
                return None  # a report was issued at this state and nothing has changed since
    _log(gitdir, sid, f"blocked {codes}")
    cmd = " ".join(["python3", shlex.quote(os.path.abspath(__file__)), "--ledger", shlex.quote(ledger),
                    "--cwd", shlex.quote(top)]) + (" --deliverable '...' --outcome done|partial|blocked "
                                                  "--well '...' --badly '...' --predecessor '...' --next '...'")
    return {"decision": "block", "reason":
            f"Close-out is complete but your final message is not the Phase 3G report ({'; '.join(errs[:3])}). "
            f"Run: {cmd} (each text at most {FIELD_MAX} characters, no '|'; the outcome is one word) and print "
            "its output verbatim as your entire final message, with nothing before or after it."}


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--ledger", default=None, help="the receipt ledger (default: the project's own, found by the layout resolver)")
    ap.add_argument("--cwd", default=".", help="the repository whose HEAD the report names")
    ap.add_argument("--check", metavar="FILE", help="lint FILE ('-' = stdin) instead of printing a report")
    ap.add_argument("--hook", action="store_true", help="act as a Claude Code Stop / SessionStart hook (stdin payload)")
    for f in FIELDS:
        ap.add_argument("--" + f)
    a = ap.parse_args(argv)
    if a.hook:
        try:
            out = decide(json.load(sys.stdin))
        except Exception:  # fail quiet: an error must never block a session, and exit 2 would
            out = None
        if out:
            print(json.dumps(out))
        return 0
    try:
        m = live_facts(a.ledger, a.cwd)
    except (OSError, ValueError) as e:
        print(f"refused: {e}", file=sys.stderr)
        return 2
    if a.check:
        text = sys.stdin.read() if a.check == "-" else open(a.check, encoding="utf-8").read()
        errs = lint(text, m)
        print("\n".join(errs) if errs else "OK")
        return 1 if errs else 0
    try:
        sys.stdout.write(render(m, *(getattr(a, f) or "" for f in FIELDS)))
    except ValueError as e:
        print(f"refused: {e}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
