---
name: observe
description: >
  Run observability for any bound project — live status, watch, and post-run
  reports for AFK, Mac sessions, and subagents. Use when user runs /observe,
  asks what background work is doing, wants step timing or token trace, or says
  watch AFK, observe status, or show run timeline.
---

# Observe — Run Observability (any project)

**Works on every project bound to AI Dev OS** — not limited to the OS repo.

- **CLI lives in OS:** `$AI_DEV_OS_HOME/scripts/observe.sh` → `observe` on PATH after `install-cli.sh`
- **Data lives in project:** `work/telemetry/` under the **current project root**

Always `cd` to the target project (or pass remote SSH for Ubuntu AFK) before running commands.

---

## When to use

| Trigger | Action |
|---------|--------|
| `/observe` or "what is AFK doing?" | `observe.sh status` |
| "watch background work" | `observe.sh watch` — auto-starts telemetry if none active (Mac) or `observe.sh watch --remote` (Ubuntu AFK) |
| "show run timeline / steps taken" | `observe.sh report` |
| "monitor all projects (local page)" | `observe.sh dashboard` |
| Mac user watching Ubuntu server | `observe.sh watch --remote` |

Pair with `/usage-report` for milestone rollups and improvement recommendations — observe is **per-run detail**; usage-report is **historical rollup**.

---

## Prerequisites

Project bound via `ai-new` (scaffolds `work/telemetry/runs/`, `telemetry:` in `ai-dev-os.yaml`).

If missing after OS upgrade:

```bash
sync-project
# or: ai-new .
check-integration
```

Remote AFK (Mac → Ubuntu) — gitignored `ai-dev-os.local.yaml`:

```yaml
observe:
  remote_host: ubuntu-afk
  remote_project_root: ~/projects/my-app
```

Telemetry verbosity (`ai-dev-os.yaml`):

```yaml
telemetry:
  level: verbose   # verbose | standard | minimal
```

---

## Commands (run from project root)

```bash
observe.sh status
observe.sh status --json
observe.sh watch --interval 60   # auto run-start when no session
observe.sh report
observe.sh report --run-id RUN-2026-06-21-abc12345
observe.sh dashboard              # local page http://127.0.0.1:8765
observe.sh dashboard --port 9000 --open

# Ubuntu AFK from Mac
observe.sh status --remote
observe.sh watch --remote
observe.sh report --remote
```

**`observe watch`** auto-calls `observe-event.sh run-start --skill observe` when the project has no active session. End a session with `observe-event.sh run-end` on `Done.` or AFK handoff.

**MCP `codebase-survey` / `survey` tool** — auto-logs `mcp_call` to `work/telemetry/events.jsonl` (files, duration, model, fallback flag). Visible on `observe dashboard` and `observe report`.

**Agents emit events** (low-token — one JSON line per boundary):

```bash
observe-event.sh run-start --skill task-run --agent agy
observe-event.sh emit --type step_start --step work-to-pr-v2/implement --step-index 4/7 --issue 42
observe-event.sh emit --type step_end --step work-to-pr-v2/implement --issue 42 --duration-sec 120
observe-event.sh run-end --status ok
```

---

## Flow (agent)

1. Confirm project root (`pwd` has `AGENTS.md` + `ai-dev-os.yaml`).
2. Run the appropriate `observe.sh` subcommand — **do not** narrate steps in chat instead of logging.
3. Summarize output for user (≤10 lines): health, last script, MCP/daemon lines, current issue/step, elapsed, anomalies.
4. On `report`: highlight step order, long steps, missing expected steps (spec-review skipped, etc.).
5. If scaffolds missing → tell user to run `sync-project`, then retry.

---

## Storage (this project only)

| Path | Contents |
|------|----------|
| `work/telemetry/runs/*.jsonl` | Verbose per-run trace (gitignored) |
| `work/telemetry/events.jsonl` | Summary events + `script_invoked`, `files_used`, `mcp_probe` |
| `work/telemetry/.current-run` | Active run id (gitignored) |

---

## User-facing summary format

```text
Observe — <project>

Health: active | idle
Run: RUN-…
Issue: #42 — work-to-pr-v2/implement (4/7)
Elapsed: 12m
Telemetry level: verbose

Run observe.sh report for full timeline.
```

---

## References

- STD-PROJ-001 — OS changes propagate via sync-project / ai-new
- STD-LOG-001 — audit trail rules
- `docs/USAGE-FEEDBACK.md` — telemetry levels + remote config
- Schema: `templates/telemetry/event-schema.yaml`
- CLI: `$AI_DEV_OS_HOME/scripts/observe.sh`, `observe-event.sh`