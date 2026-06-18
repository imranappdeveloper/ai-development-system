# AI Development OS — Platform Manifest v1.1

| Field | Value |
|-------|-------|
| platform | **AI Development OS** |
| version | **1.1.0** |
| codename | Standalone Execution |
| status | **frozen** |
| freeze_date | 2026-06-19 |
| spec_sha | `c969fe5de054aaac` |
| git_ref | `8e5d613` |
| baseline | v1.0.0 (playbook substrate — unchanged) |
| owner | Principal Architect |

---

## Identity

v1.1 delivers a **standalone, runnable execution layer** on top of the frozen v1.0 playbook substrate. Users and agents interact through bundled slash skills — no external skill packs required.

| Concept | Rule |
|---------|------|
| Install root | `AI_DEV_OS_HOME` → this repository |
| Bundled skills SSOT | `skills/<name>/SKILL.md` + `skills/MANIFEST.yaml` |
| Agent discovery | Symlinks via `install-cli.sh` → `~/.grok/skills/`, `~/.gemini/config/skills/` |
| Playbook SSOT | `playbooks/` — internal specs (v1.0 frozen) |
| Batch code | **Server only** — `task-run-server.sh` + tmux + grok/agy |

---

## v1.1 Scope (Frozen)

### Bundled slash skills — 19

Setup: `setup-ads`, `setup-project-agents`, `setup-task-run`  
Grill: `grill-me`, `grill-with-docs`  
Planning: `plan-to-issue-v2`, `grill-for-planning`, `plan-synthesis`, `plan-review`, `to-issues`, `to-prd`  
AFK: `task-run`, `work-to-pr-v2`, `issue-processor`, `issue-spec-review`, `pr-readiness-check`, `tdd`  
Bugs: `triage`, `diagnose`

### Server AFK stack

| Script | Role |
|--------|------|
| `task-run-server.sh` | tmux + grok/agy auto-start |
| `task-run-poll.sh` | cron/systemd auto-start/resume |
| `lib/task-run-agent.sh` | grok/agy resolution |
| `lib/task-run-session.sh` | health, stale recovery, poll logic |
| `setup-graphify.sh` | optional graphify CLI + post-commit hook |
| `setup-task-run.sh` | project `docs/agents/task-run.md` + cron example |

### User flows (frozen docs)

| Doc | Path |
|-----|------|
| User interaction | `docs/USER-FLOW.md` |
| AFK server guide | `docs/AFK-TASK-RUN.md` |
| Standalone SSOT | `docs/STANDALONE.md` |
| Setup | `docs/SETUP-ADS.md` |
| Kickoff | `docs/PROJECT-KICKOFF.md` |
| Bug path | `docs/BUG-FIX.md` |

### Execution policy (frozen)

- Task **done when PR opens** — label `done`, unblock dependents immediately
- **No wait for human merge** — queue continues to next unblocked issue
- `pr-open` — legacy label only; repaired to `done` on state sync

### CLI (frozen)

`install-cli.sh`, `check-cli.sh`, `ai-new`, `new-project.sh`, `verify-standalone.sh`, `task-run.sh` (handoff helper)

---

## v1.0 Substrate (Unchanged)

32 active playbooks, 14 workflows, 18 standards — frozen in `release/v1.0/`. No architectural changes to v1.0 substrate in this release.

---

## CI Validation (v1.1 baseline)

| Script | Purpose |
|--------|---------|
| `scripts/verify-standalone.sh` | Manifest, symlinks, bundled skills, session tests |
| `scripts/verify-catalog.sh` | INDEX `active_skills` ↔ playbook registry |
| `scripts/sync-routing-graph.sh` | routing-matrix ↔ playbook status |
| `scripts/simulate-workflow.sh` | WF phases playbook-ready |
| `scripts/test-task-run-session.sh` | Poll/session helper unit tests |

---

## Out of Scope for v1.1 (v1.2+)

| Item | Target |
|------|--------|
| Runtime agent E2E harness | v1.2 |
| `12-qa-scenarios.md` rollout (31 playbooks) | v1.2 |
| Meta skills (`MS-*`) promotion | v1.2 |
| `issue-processor` GitHub rewrite | v1.2 |
| AFK security hardening doc | v1.2 |

See `release/v1.0/FUTURE-ENHANCEMENTS.md` and `release/v1.0/ROADMAP-v2.md`.

---

## Freeze Sign-Off

| Field | Value |
|-------|-------|
| reviewer | Principal Architect |
| review_date | 2026-06-19 |
| decision | **approved** |
| bundled_skills | 19 |
| verify_standalone | pass |
| open_p0 | 0 (known P1: issue-processor staleness — documented in out-of-scope) |
| notes | v1.1 adds standalone execution; v1.0 playbook substrate immutable. |

---

## Release Bundle Index

| Document | Path |
|----------|------|
| Platform Manifest | `release/v1.1/PLATFORM-MANIFEST.md` (this file) |
| Version Report | `release/v1.1/VERSION-REPORT.md` |
| Bundled Skills | `release/v1.1/BUNDLED-SKILLS.yaml` |
| v1.0 substrate | `release/v1.0/` |