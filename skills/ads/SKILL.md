---
name: ads
description: >
  ADS session preflight on bound projects — blocking integration checks, live MCP
  survey probe (warn), observe watch, and context-aware handoff to planning or
  coding. Use when user runs /ads, ads, start session, preflight, or needs to
  confirm AI Dev OS is ready before work. Not for kickoff (/setup-ads) or Ubuntu AFK.
---

# ADS — Session Preflight

**Bound project ritual** before planning, bugs, or direct coding. Lighter than `/setup-ads` kickoff.

| Not this | Use instead |
|----------|-------------|
| Greenfield/brownfield kickoff | `/setup-ads` |
| Ubuntu `task-run` / AFK server | Server telemetry via `task-run` (exempt) |
| Full integration audit | `check-integration` |

**SSOT:** `work/requirement-lock.md` (REQ-LOCK-002) when present.

---

## Phase 0 — Confirm project root

```bash
pwd   # must contain AGENTS.md + ai-dev-os.yaml
```

If unbound → tell user to run `ai-new .` then `/setup-ads`. **Stop.**

---

## Phase 1 — Blocking preflight (script)

From project root:

```bash
ads-preflight.sh --json
```

Or: `$AI_DEV_OS_HOME/scripts/ads-preflight.sh --json`

| Result | Action |
|--------|--------|
| `"status": "ok"` | Continue Phase 2 |
| `"status": "fail"` | **Stop.** Show failing `checks[]` with fix messages. Do not proceed. |

Blocking items (script-enforced): `check-cli`, `ai-paths`, `AGENTS.md`, `ai-dev-os.yaml`, all five `docs/agents/*.md` files.

---

## Phase 2 — MCP survey live probe (warn-only)

Read `local_survey` from Phase 1 JSON.

| `local_survey.state` | Action |
|----------------------|--------|
| `disabled` | Skip probe — cloud-only OK |
| `ready`, `enabled-unreachable`, `enabled-no-ollama` | Run live probe |

**Live probe** (gated list only — no free-roam):

1. `setup-local-survey.sh --status .` for context
2. Call MCP tool **`survey`** (`codebase-survey`) with existing files only:
   - `AGENTS.md`
   - `CONTEXT.md` (skip if missing)
   - `ai-dev-os.yaml`
3. If `ok: false` or `fallback_recommended: true` → **warn** (do not block):
   - `ollama serve && ollama pull <model>`
   - `setup-local-survey.sh .`
   - Planning will use cloud explore on same gated lists

Ref: `$AI_DEV_OS_HOME/docs/LOCAL-SURVEY.md`

---

## Phase 3 — Observe telemetry + watch

On preflight pass:

```bash
observe-event.sh run-start --skill ads
observe.sh watch --interval 60   # background terminal
```

- **One run per Mac session** — do not `run-start` again when switching to `/grill-me`, `/plan-to-issue-v2`, `/tdd`, etc.
- **`run-end`** when user says `Done.` or hands off to AFK (`task-run-server.sh`):

```bash
observe-event.sh run-end --status ok   # or fail
```

Ref: `$AI_DEV_OS_HOME/skills/observe/SKILL.md`

---

## Phase 4 — Readiness card (≤10 lines)

```text
ADS preflight — <project>

Blocking: all passed | N failed (see above)
MCP survey: ready | warn — <reason> | disabled (cloud OK)
Observe: RUN-<id> — watch 60s (background)
Warnings: <count> or none

Next: <inferred skill> | pick: grill / plan / bug / Start coding
```

---

## Phase 5 — Context-aware handoff

| User intent in message | Continue into |
|------------------------|---------------|
| plan, feature, grill, MVP, `/grill-me` | `/grill-me` or `/grill-with-docs` |
| publish issues, `/plan-to-issue-v2` | `/plan-to-issue-v2` |
| `Bug Fix:`, `bug:`, broken/failing | `/triage` → `/diagnose` |
| implement, fix, build, Start coding | Appropriate skill after user says **Start coding** |
| `/ads` only (no intent) | Ask once: grill, plan, bug fix, or Start coding |

Do **not** implement batch features inline — hand off to `/plan-to-issue-v2` → **Start AFK**.

---

## Nudge (other chats — AGENTS.md rule)

If user starts planning/coding on a bound project **without** `/ads` or `/setup-ads`:

1. Suggest `/ads` **once** per chat
2. If declined, continue without blocking

---

## Never

- Replace `/setup-ads` kickoff
- Block on MCP survey failure (warn only)
- Free-roam survey or codebase reads during probe
- Auto-run `sync-project` on every `/ads`
- Start a new observe run per skill switch
- Omit OS status footer

## References

| Doc | Path |
|-----|------|
| Requirement lock | `work/requirement-lock.md` |
| Local survey | `$AI_DEV_OS_HOME/docs/LOCAL-SURVEY.md` |
| User flow | `$AI_DEV_OS_HOME/docs/USER-FLOW.md` |
| Observe | `$AI_DEV_OS_HOME/skills/observe/SKILL.md` |
| CLI | `$AI_DEV_OS_HOME/scripts/ads-preflight.sh` |