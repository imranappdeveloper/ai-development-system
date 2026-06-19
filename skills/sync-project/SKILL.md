---
name: sync-project
description: >
  Sync AI Dev OS and project after git pull — refresh skills/CLI, re-bind project
  (ai-new), refresh docs/agents. Use when user says sync project, /sync-project,
  update after pull, refresh OS binding, or after OS upgrade on a machine.
---

# Sync Project

Pull latest OS + project code, refresh CLI symlinks and skills, merge new OS blocks into the project. **Idempotent** — safe to run often.

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
5. `ai-new .` — merge AGENTS blocks, task-run/graphify hooks

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

---

## Report

```text
Sync complete

OS:     pulled + install-cli
Project: pulled + ai-new
Agents: refreshed (--detect-only) | skipped
Ready:  check-cli OK | WARN: <fix>
```

End with OS status footer — `$AI_DEV_OS_HOME/docs/OS-STATUS-FOOTER.md`.

---

## Never

- Overwrite `ai-dev-os.yaml` or user `CONTEXT.md` (ai-new is merge-only)
- Run full `/setup-ads` unless user asks for re-kickoff
- Skip `git pull` on OS before `install-cli` when OS version changed

SSOT: `$AI_DEV_OS_HOME/skills/sync-project/SKILL.md`