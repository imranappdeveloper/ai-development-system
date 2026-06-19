---
name: issue-processor
description: DEPRECATED — use work-to-pr-v2 or task-run. Do not load for AFK execution.
---

# Issue Processor — DEPRECATED

**Do not use.** Removed from AFK chain in v1.1.1.

| Use instead | When |
|-------------|------|
| `work-to-pr-v2` | Single issue or epic queue (per-issue loop) |
| `task-run` | Server AFK orchestrator (delegates to `work-to-pr-v2`) |

GitHub issues + PRs only — not `.scratch/` file loops.