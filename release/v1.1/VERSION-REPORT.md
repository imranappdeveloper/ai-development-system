# AI Development OS v1.1 — Version Report

| Field | Value |
|-------|-------|
| platform | AI Development OS |
| release | **1.1.0** |
| codename | Standalone Execution |
| release_date | 2026-06-19 |
| status | frozen |
| spec_sha | `c969fe5de054aaac` |
| git_ref | `8e5d613` |
| prior_release | v1.0.0 (2026-06-18) |

---

## v1.1 Components

| Component | Version | Status | SSOT Path |
|-----------|---------|--------|-----------|
| Bundled skills manifest | 1.1 | frozen | `skills/MANIFEST.yaml` |
| Standalone guide | 1.1 | frozen | `docs/STANDALONE.md` |
| User flow | 1.1 | frozen | `docs/USER-FLOW.md` |
| AFK task run | 1.1 | frozen | `docs/AFK-TASK-RUN.md` |
| Server AFK scripts | 1.1 | frozen | `scripts/task-run-*.sh`, `scripts/lib/` |
| Setup ads skill | 1.1 | frozen | `skills/setup-ads/SKILL.md` |
| Task run skill | 1.1 | frozen | `skills/task-run/SKILL.md` |
| Work to PR v2 | 1.1 | frozen | `skills/work-to-pr-v2/SKILL.md` |

---

## Bundled Slash Skills (19)

| Skill | Category |
|-------|----------|
| setup-ads | OS bind + kickoff |
| setup-project-agents | Project agents config |
| setup-task-run | Server AFK setup |
| grill-me | New project requirements |
| grill-with-docs | Existing project grill |
| plan-to-issue-v2 | Plan → GitHub issues |
| grill-for-planning | Enhanced grilling |
| plan-synthesis | PRD + issue synthesis |
| plan-review | Autonomous plan preflight |
| to-issues | Issue breakdown |
| to-prd | PRD publish |
| task-run | AFK task manager |
| work-to-pr-v2 | Per-issue PR flow |
| issue-processor | Batch issue pattern |
| issue-spec-review | Issue preflight |
| pr-readiness-check | Pre-PR gate |
| tdd | Test-driven development |
| triage | Issue triage |
| diagnose | Bug diagnosis |

---

## v1.0 Substrate (unchanged)

| Component | Version | Status |
|-----------|---------|--------|
| Delivery playbooks | 1.0.0 | frozen (32 active) |
| Workflows | 1.0.0 | frozen (14) |
| Standards | 1.0.0 | frozen (18) |
| Release bundle | 1.0.0 | `release/v1.0/` |

---

## Verification at Freeze

| Script | Result |
|--------|--------|
| `verify-standalone.sh` | PASS |
| `verify-catalog.sh` | PASS |
| `sync-routing-graph.sh` | PASS |
| `simulate-workflow.sh all` | PASS |
| `test-task-run-session.sh` | PASS |

---

## Agent Targets

| Agent | CLI | Discovery path |
|-------|-----|----------------|
| Grok | `grok` | `~/.grok/skills/` → `$AI_DEV_OS_HOME/skills/` |
| Antigravity | `agy` | `~/.gemini/config/skills/` → `$AI_DEV_OS_HOME/skills/` |