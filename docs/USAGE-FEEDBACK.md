# Usage Feedback & Monitoring

Learn what works as you adopt AI Dev OS — passive telemetry, milestone snapshots, on-demand feedback, and usage reports.

---

## Commands (user)

| Command | When |
|---------|------|
| `/feedback` | Anytime — report friction, bugs, or ideas |
| `/usage-report` | Anytime — full rollup + recommendations |
| `/observe` | Live or post-run — step trace for this project (skill: `observe`) |
| `observe.sh status` | Live — current run, step, elapsed time |
| `observe.sh watch` | Live status card every 60s + heartbeat when active (use `--remote` for Ubuntu AFK) |
| `observe.sh report` | After a run — per-issue step timeline |

## Automatic snapshots

Written at milestones (no invoke needed):

| Milestone | Trigger skill |
|-----------|---------------|
| `tasks-published` | `plan-to-issue-v2` — after epic + children published |
| `afk-run` | `task-run` — after batch completes |

Grill sessions (`grill-me`, `grill-for-planning`) do **not** write snapshots. Execution uses `work/requirement-lock.md` only.

Snapshots live at `work/feedback/snapshots/`. Anomalies trigger a one-line nudge: *"Run /feedback or reply skip."*

## Storage

| Location | Contents |
|----------|----------|
| `work/telemetry/events.jsonl` | Passive events, `script_invoked`, `files_used`, `mcp_probe` (project) |
| `work/telemetry/runs/*.jsonl` | Verbose per-run traces (gitignored) |
| `work/feedback/entries.jsonl` | Your feedback entries (verbatim text) |
| `work/feedback/snapshots/` | Milestone markdown summaries |
| `$AI_DEV_OS_HOME/.usage/rollup.jsonl` | Anonymized cross-project rollup |

Configure in `ai-dev-os.yaml`:

```yaml
feedback:
  nudge_grill_questions: 8
  nudge_afk_stale_minutes: 45
  rollup_sync: true

telemetry:
  level: verbose   # verbose | standard | minimal
```

Mac → Ubuntu AFK watch (`ai-dev-os.local.yaml`, gitignored):

```yaml
observe:
  remote_host: ubuntu-afk
  remote_project_root: ~/projects/my-app
```

```bash
observe.sh status --remote
observe.sh watch --remote --interval 60
observe.sh report --remote
```

## Anomaly thresholds (balanced)

Nudge when any of:

- AFK stall (no log activity > `nudge_afk_stale_minutes`)
- `needs-info` on an issue
- Task-run crash
- Grill abandoned without approved lock doc
- Any `⚠️ Partial` OS footer in session
- Grill > `nudge_grill_questions` questions
- Issue-spec-review reject/retry
- AFK batch: queued work but 0 PRs opened

## Improvement loop

| Phase | Behavior |
|-------|----------|
| **Now** | `/usage-report` recommends fixes; you approve before OS edits |
| **Later** | MS-* meta-skills auto-review when ≥4 weeks **and** (≥10 feedback entries **or** ≥5 anomalous snapshots) |

Check gate: `usage-feedback.sh meta-gate`

## CLI (agents / scripts)

```bash
usage-feedback.sh snapshot --milestone grill --grill-questions 6 --lock-approved true
usage-feedback.sh feedback --category workflow-friction --severity medium --text "..."
usage-feedback.sh report

observe-event.sh run-start --skill task-run --agent agy
observe-event.sh emit --type step_start --step work-to-pr-v2/implement --step-index 4/7 --issue 42
observe-event.sh run-end --status ok
observe.sh status --json
```

Schemas: `templates/telemetry/event-schema.yaml`, `templates/feedback/entry-schema.yaml`