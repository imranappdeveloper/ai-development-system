---
name: sync-project
description: >
  Sync AI Dev OS and project after git pull — refresh skills/CLI, re-bind project
  (ai-new), refresh docs/agents. Use when user says sync project, /sync-project,
  update after pull, refresh OS binding, or after OS upgrade on a machine.
---

# Sync Project

Pull latest OS + project code, refresh CLI symlinks and skills, merge new OS blocks into the project. **Idempotent** — safe to run often.

**Propagation standard (STD-PROJ-001):** OS changes live only in `$AI_DEV_OS_HOME`. Working projects receive them through **`/sync-project`** (or `ai-new .`). New projects receive them through **`ai-new`**. Never ask users to copy OS scripts into project repos.

---

## When to use

- After `git pull` on OS repo or project repo
- New machine / teammate onboarding (second step after `install-cli.sh`)
- OS upgraded to new version (v1.1+)
- Stale `AGENTS.md` or missing slash skills

---

## Phase 1 — Script (required)

From **project root** (or pass path):

```bash
sync-project.sh
# or:
sync-project.sh /path/to/project
```

| Flag | Use |
|------|-----|
| `--os-only` | Machine setup only — no project |
| `--project-only` | Project already has latest OS; skip OS pull |
| `--skip-project-pull` | Re-bind without project `git pull` |

**Script does:**

1. `git pull` — OS repo (`$AI_DEV_OS_HOME`)
2. `install-cli.sh` — CLI + skill symlinks (grok/agy)
3. `check-cli` — verify
4. `git pull` — project repo (if `.git`)
5. `ai-new .` — merge AGENTS blocks, `ai-dev-os.yaml` keys (`feedback:`, `telemetry:`, `docs.usage_feedback`), sync `docs/USAGE-FEEDBACK.md`, scaffold `work/feedback/` + `work/telemetry/runs/`, observe CLI (`observe.sh`, `observe dashboard`, MCP `mcp_call` telemetry), task-run/graphify hooks; register project for observe dashboard (`~/.config/ai-dev-os/projects.json`)

Run the script yourself — do not ask the user to paste commands unless `check-cli` fails.

---

## Phase 2 — Refresh agents (if bound)

If `docs/agents/` exists:

```
/setup-project-agents --detect-only
```

Updates `engineering-standards.md` / `domain.md` detection — preserves user edits.

Skip if project never ran `/setup-project-agents`.

---

## Phase 3 — Optional

| Condition | Action |
|-----------|--------|
| `graphify-out/` exists + `graphify` on PATH | Rebuild index if code changed significantly |
| Server AFK | `task-run-server.sh --status` — no action unless resuming work |
| Cron poll | `task-run-poll.sh --dry-run` — verify poll config |
| After OS pull with MCP/observe changes | Restart Antigravity/Grok IDE session so `codebase-survey` MCP reloads; run `observe dashboard` to verify |

---

## Phase 4 — Integration check (required)

After Phases 1–2 complete, verify the machine **and** project are fully integrated:

```bash
check-integration
# or:
check-integration /path/to/project
```

Run it yourself from **project root** — do not skip.

**Script checks:**

| Area | Blocking (FAIL) | Advisory (WARN) |
|------|-----------------|-----------------|
| Machine | `check-cli`, `ai-paths check` | `~/.local/bin` not on PATH |
| Project binding | `AGENTS.md`, `ai-dev-os.yaml` | `work/`, `docs/` |
| AGENTS.md blocks | header, path-resolution, config, skills-source, setup-ads | optional blocks, setup placeholder |
| `docs/agents/` | — | issue-tracker, triage-labels, domain, engineering-standards, task-run |
| AFK | — | `work/task-run/`, `docs/agents/task-run.md` |
| Optional | — | graphify hook, `gh`, `CONTEXT.md`, grok/agy |

**Show the full report** to the user (all `OK`, `WARN`, `FAIL` lines + summary).

| Summary | Agent action |
|---------|--------------|
| `FULLY INTEGRATED` | Confirm ready; continue work |
| `PARTIAL` | List warnings; ask user to fix before AFK or `/plan-to-issue-v2` |
| `NOT READY` / `NOT BOUND` | List blocking items; **stop** — ask user to fix |

**When issues exist — ask the user to fix** (one message, A/B/C at forks):

```text
Integration check: <FULLY INTEGRATED | PARTIAL | NOT READY>

Blocking:
- <item> → <fix command or skill>

Warnings:
- <item> → <fix>

A) Fix blocking items now (I'll guide step by step)
B) Fix warnings only — continue without AFK/planning for now
C) Skip — I'll fix manually later

I recommend A if any FAIL; B if only WARN and you need to code immediately.
```

| Issue | Typical fix |
|-------|-------------|
| `check-cli` / `ai-paths` | `cd $AI_DEV_OS_HOME && ./scripts/install-cli.sh && source ~/.bashrc` |
| Missing `AGENTS.md` / `ai-dev-os.yaml` | `ai-new .` |
| Stale OS blocks | `ai-new .` (merge-only) |
| `docs/agents/` incomplete | `/setup-project-agents` |
| task-run scaffold | `setup-task-run.sh .` or `/setup-ads` Phase 1.6 |
| `CONTEXT.md` | `/setup-ads` grill or manual stub |

Do not proceed to AFK or issue publishing until blocking FAIL items are resolved (or user explicitly chooses C).

---

## Report

```text
Sync complete

OS:      pulled + install-cli
Project: pulled + ai-new
Agents:  refreshed (--detect-only) | skipped
Integration: FULLY INTEGRATED | PARTIAL (N warnings) | NOT READY (N blocking)
```

Include the integration summary and any open WARN/FAIL items from Phase 4.

End with OS status footer — `$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md`.

---

## Never

- Overwrite `ai-dev-os.yaml` or user `CONTEXT.md` (ai-new is merge-only)
- Run full `/setup-ads` unless user asks for re-kickoff
- Skip `git pull` on OS before `install-cli` when OS version changed

SSOT: `$AI_DEV_OS_HOME/skills/sync-project/SKILL.md`