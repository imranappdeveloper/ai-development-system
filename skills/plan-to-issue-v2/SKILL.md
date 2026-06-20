---
name: plan-to-issue-v2
description: >
  Plan-to-issue pipeline — grill, requirement lock doc, overview gate, publish GitHub
  epic + children. Canonical publish path. Execution is always task-run-server on Ubuntu
  (not --execute).
---

# Plan to Issue v2

Publish a reviewed GitHub epic and child issues. **Does not implement code** — hand off to server AFK.

**Prerequisite:** `/setup-project-agents` complete (`docs/agents/` exists).

---

## Canonical flow (default)

```
/plan-to-issue-v2                    # grill → lock doc → overview → publish
task-run-server.sh --agent grok      # execute (server only)
```

**Never use `--execute`** in setup or planning chat. Batch code runs only via `task-run-server.sh`.

---

## Invocation

```
/plan-to-issue-v2                                  # default (recommended)
/plan-to-issue-v2 --from-issue <N>                 # republish after lock-doc edits
/plan-to-issue-v2 --auto --lean                    # legacy opt-in — no lock doc, autonomous
```

### Default path (lock doc)

1. **Grill** — `/grill-for-planning` (explore first; misalignment forks only)
2. **Lock doc** — `work/requirement-lock.md` approved by user
3. **Synthesize** — `/plan-synthesis` from lock doc
4. **Overview gate** — per-screen one-liners + task table; user approves or requests changes
5. **Publish** — epic + children with `ready-for-agent`

Skip Phase 1 re-grill when a fresh approved lock doc already exists from the same session.

### Legacy `--auto --lean` — opt-in only

Autonomous guessing without requirement lock or overview gate. **Not recommended** — higher rework risk and surprise implementations.

Requires explicit user request. Runs `/grill-for-planning --auto --lean` → `/plan-synthesis --auto --lean`.

### `--execute` — DEPRECATED

Do not use. Same-session implementation bypasses server tmux, poll, and `task-run` orchestration.

After publish, user picks **Start AFK on server** → `task-run-server.sh --agent grok|agy --epic <N>`.

---

## Overview gate (default — before publish)

Show the user an **overview only** — not full issue bodies:

```text
<Feature> — agreed changes:

Settings → add notification toggle (default OFF, saves on change)
Profile → hide legacy phone field (read-only if already set)
…

Tasks (epic draft):
1. Settings notification toggle — blocked by: none
2. Profile phone field cleanup — blocked by: none

A) Publish and Start AFK on server (grok)
B) Publish and Start AFK on server (agy)
C) Not yet — change something
```

| User says | Agent does |
|---|---|
| **A / B** | Publish issues, then hand off to `task-run-server.sh` |
| **C — small fix** | Edit lock doc, adjust issue drafts, show overview again |
| **C — scope change** | Re-grill affected screens only, update lock doc, show overview again |

User never reads full issue bodies or the lock doc unless they ask.

---

## Phases (default)

### Phase 1 — Grill + lock doc

`/grill-for-planning`. Produces approved `work/requirement-lock.md`. Updates `CONTEXT.md` when needed.

### Phase 2 — Synthesize + overview

`/plan-synthesis` from lock doc. Presents overview gate. Publishes only after user approves.

### Phase 3 — Handoff

```
Plan complete (v2)
- Lock doc: work/requirement-lock.md (approved)
- Epic: #<N>
- Children: #<list>

Start AFK on server:
  task-run-server.sh --agent grok --epic <N>
  task-run-server.sh --agent agy --epic <N>
```

Do **not** start implementation in this chat.

### Usage snapshot (after publish)

After epic + children are published:

```bash
usage-feedback.sh snapshot --milestone tasks-published \
  --issues-published <child_count> \
  --partial-footers <N> \
  --skills "plan-to-issue-v2"
```

Show snapshot path + summary. Nudge only if anomalies (see `usage-report` skill).

---

## Skill map

| Phase | Skill | Notes |
|---|---|---|
| 1 | `grill-for-planning` | Lock doc SSOT; reads grill-me / grill-with-docs |
| 2 | `plan-synthesis` | Slices lock doc; overview gate; to-prd / to-issues templates |
| 2 | `plan-review` | Mechanical validation before publish |
| Execute | `task-run` → `work-to-pr-v2` | **Server only** — reads lock doc + spot-check |

SSOT: `$AI_DEV_OS_HOME/skills/plan-to-issue-v2/SKILL.md`