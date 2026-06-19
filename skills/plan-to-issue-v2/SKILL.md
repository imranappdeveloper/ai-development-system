---
name: plan-to-issue-v2
description: >
  Plan-to-issue pipeline — grill, synthesize, publish GitHub epic + children.
  Canonical publish path. Execution is always task-run-server on Ubuntu (not --execute).
---

# Plan to Issue v2

Publish a reviewed GitHub epic and child issues. **Does not implement code** — hand off to server AFK.

**Prerequisite:** `/setup-project-agents` complete (`docs/agents/` exists).

---

## Canonical flow

```
/plan-to-issue-v2 --auto --lean     # publish (this skill)
task-run-server.sh --agent grok     # execute (server only)
```

**Never use `--execute`** in setup or planning chat. Batch code runs only via `task-run-server.sh`.

---

## Invocation

```
/plan-to-issue-v2 --auto --lean                    # recommended
/plan-to-issue-v2 --from-context --auto --lean     # after setup-ads grill
/plan-to-issue-v2 --from-issue <N> --auto --lean   # republish / held slices
/plan-to-issue-v2                                  # interactive (rare)
```

### `--execute` — DEPRECATED

Do not use. Same-session implementation bypasses server tmux, poll, and `task-run` orchestration.

After publish, user picks **Start AFK on server** → `task-run-server.sh --agent grok|agy --epic <N>`.

---

## Decision policy (`--auto`)

Read `plan-review` when `--auto` is set.

| Situation | Action |
|---|---|
| Engineering practices | Defer to `engineering-standards.md` at implementation |
| Documented in repo | Follow it |
| Blocking unknown | Epic `needs-info` — do not guess |
| Minor ambiguity | Least-surprising from repo neighbours |

**No questions in `--auto` mode.**

---

## Lean policy (`--lean`)

Requires `--auto`. Thin epic, fat children, AFK preflight stamps, milestone slices (max 3 issues).

---

## Phases

### Phase 1 — Grill

`/grill-for-planning` (`--auto` / `--lean` when set). Skip if `--from-context` after setup-ads grill.

### Phase 2 — Synthesize

`/plan-synthesis` (`--auto` / `--lean`). Stamps children `plan-review: READY` + `spec-sha256`.

### Phase 3 — Publish + handoff

```
Plan complete (v2) --auto --lean
- Epic: #<N>
- Children: #<list> (AFK preflight stamped)
- Held: <if any>

Start AFK on server:
  task-run-server.sh --agent grok --epic <N>
  task-run-server.sh --agent agy --epic <N>
```

Show user **short list only** (number, title, blocked-by). Do **not** start implementation in this chat.

---

## Skill map

| Phase | Skill | Notes |
|---|---|---|
| 1 | `grill-for-planning` | Reads grill-me / grill-with-docs |
| 2 | `plan-synthesis` | Internal: to-prd, to-issues templates |
| 2 (`--auto`) | `plan-review` | Autonomous gate |
| Execute | `task-run` → `work-to-pr-v2` | **Server only** — not this skill |

SSOT: `$AI_DEV_OS_HOME/skills/plan-to-issue-v2/SKILL.md`