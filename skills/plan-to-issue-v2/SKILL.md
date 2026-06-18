---
name: plan-to-issue-v2
description: Improved plan-to-issue pipeline — enhanced grilling, single synthesis gate, GitHub epic + child issues. Supports --auto for autonomous planning and --lean to minimize ceremony (thin epic, fat children, single preflight). Recommended AFK entrypoint is --auto --lean --execute. Ends with handoff to /work-to-pr-v2. Original /plan-to-issue remains unchanged.
---

# Plan to Issue v2

Turn a feature idea into a reviewed GitHub epic and child issues — without assumptions on product behaviour.

**Prerequisite:** Run `/setup-matt-pocock-skills` in the repo first so `docs/agents/` exists (use `--detect-only` to refresh on existing repos).

**Difference from v1:** Uses `/grill-for-planning` + `/plan-synthesis` instead of inline grilling and separate `/to-prd` + `/to-issues` approval gates. Original skills (`/plan-to-issue`, `/grill-me`, `/grill-with-docs`, `/to-prd`, `/to-issues`) are untouched.

## Recommended AFK entrypoint

```
/plan-to-issue-v2 --auto --lean --execute
```

Plan, publish, and implement in one session. Human effort: PR review + resolving epic `needs-info` only.

## Decision policy (`--auto`)

When `--auto` is set, read `$AI_DEV_OS_HOME/skills/plan-review/SKILL.md` and apply throughout all phases.

| Situation | Action |
|---|---|
| Engineering practices (logging, errors, architecture) | Defer to `docs/agents/engineering-standards.md` at implementation — **not** epic prose in `--lean` |
| Feature flow documented in repo, CONTEXT.md, ADRs, or issue body | Follow it; no questions |
| Important + no documentation + multiple valid approaches | Flag blocking unknown → epic `needs-info`; do not guess |
| Unimportant ambiguity | Pick least-surprising option from repo neighbours |

**Never ask questions in `--auto` mode.** Blocking unknowns are captured on the GitHub epic for human resolution there — not in chat.

## Lean policy (`--lean`)

Requires `--auto`. Propagate `--lean` to Phase 1, Phase 2, and (with `--execute`) `/work-to-pr-v2`.

| Full mode | Lean mode |
|---|---|
| Long epic PRD + extensive user stories | **Thin epic** — index + blocking unknowns only |
| Detail in epic and children | **Fat children** — all behaviour in issue ACs (incl. edge cases) |
| `CONTEXT.md` / ADR writes during planning | **Defer** — draft terms in epic `## Terms` only |
| `## Standard Decisions` on epic | **Removed** — link to `engineering-standards.md` |
| `plan-review` + `issue-spec-review` | **Single preflight** — AFK stamp + `spec-sha256`; skip re-review if unchanged |
| Many thin slices | **Milestone slices** — max 3 issues (&lt;3 day work); prefer 1–2 |
| `needs-triage` published slices | **Hold** uncertain slices — do not publish until spec-complete |

**Source of truth:** child issue bodies. Epic is a navigational shell.

## Invocation

```
/plan-to-issue-v2                              # interactive
/plan-to-issue-v2 --auto --lean --execute     # recommended AFK (plan + work)
/plan-to-issue-v2 --auto --lean               # lean plan only
/plan-to-issue-v2 --auto                      # full ceremony auto (also gets AFK stamp)
/plan-to-issue-v2 --from-context --auto --lean
/plan-to-issue-v2 --from-issue <N> --auto --lean
/work-to-pr-v2 <epic> --continue --lean       # resume epic after merges
```

### `--execute`

After Phase 3 publish, **in the same session**, run `$AI_DEV_OS_HOME/skills/work-to-pr-v2/SKILL.md` (pass `--lean` when set). Published issue numbers and `spec-sha256` values enable same-session preflight skip.

## Phases

Run in order. Do not skip phases or merge them.

### Phase 1 — Grill

Run `/grill-for-planning` (add `--auto` / `--lean` when set). Read `$AI_DEV_OS_HOME/skills/grill-for-planning/SKILL.md`.

### Phase 2 — Synthesize

Run `/plan-synthesis` (add `--auto` / `--lean` when set). Read `$AI_DEV_OS_HOME/skills/plan-synthesis/SKILL.md`.

All `--auto` publishes stamp children on `plan-review: READY` (with `spec-sha256`).

### Phase 3 — Handoff

```
Plan complete (v2)<auto><lean>.
- Epic: #<N>
- Child issues: #<list> (stamped with AFK preflight)
- Held (not published): <if any>

<if not --execute>
/work-to-pr-v2 <epic>              # auto-infers lean from stamps
/work-to-pr-v2 <epic> --continue --lean   # after merges
</if>
```

Do not start implementation **unless** `--execute` is set.

## Reliability guarantees

- **No product assumptions** — undocumented business behaviour is never invented
- **Fat child ACs** — testable behaviour in issue acceptance criteria
- **Single preflight** — `spec-sha256` stamp; immune to label/comment churn on GitHub
- **Auto-infer lean** — `/work-to-pr-v2` detects stamps; `--continue` inherits lean skip
- **Engineering standards at PR time** — `engineering-standards.md` + `pr-readiness-check`; never forced clean arch
- **Hold, don't half-publish** — lean mode does not create `needs-triage` slices

## Skill map (v2 → reads, never edits)

| Phase | New skill | Reads (unchanged) |
|---|---|---|
| 1 | `grill-for-planning` | `grill-with-docs` or `grill-me` |
| 2 | `plan-synthesis` | `to-prd`, `to-issues` |
| 2 (`--auto`) | `plan-review` | — |
| 3 (`--execute`) | `work-to-pr-v2` | `issue-spec-review`, `tdd`, `pr-readiness-check`, `engineering-standards.md` |

SSOT: `$AI_DEV_OS_HOME/skills/plan-to-issue-v2/SKILL.md`