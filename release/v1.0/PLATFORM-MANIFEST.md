# AI Development OS — Platform Manifest v1.0

| Field | Value |
|-------|-------|
| platform | **AI Development OS** |
| version | **1.0.0** |
| codename | Foundation |
| status | **frozen** |
| freeze_date | 2026-06-18 |
| spec_sha | `14d731c15af6532e` |
| git_ref | `98d2ffc7e496665d67a1a43e00c8acaf5521aa9c` |
| substrate_readiness | 96/100 |
| owner | Principal Architect |

---

## Identity

The **AI Development OS** is a vendor-agnostic, globally installed operating system for AI-assisted software delivery. It orchestrates playbooks (skills), human gates, durable artifacts, and workflows — without copying into target project repositories.

| Concept | Rule |
|---------|------|
| Install root | `AI_DEV_OS_HOME` → this repository |
| Project state | `{project_root}/work/` only |
| Playbook SSOT | `playbooks/<kebab-name>/` |
| Platform adapters | `skills/` — pointers only; not SSOT |

---

## v1.0 Scope (Frozen)

### Delivery spine — 32 active playbooks

| Phase | Skills |
|-------|--------|
| Orchestrator | `PB-project-orchestrator` |
| Intake | `PB-intake-classify` |
| Frame | `PB-discovery-research`, `PB-onboard-project`, `PB-survey-codebase` (optional) |
| Plan | `PB-draft-prd`, `PB-draft-feature`, `PB-draft-architecture`, `PB-draft-database`, `PB-draft-api`, `PB-draft-ui-ux`, `PB-draft-issue`, `PB-diagnose-bug`, `PB-security-assess`, `PB-perf-baseline`, `PB-draft-doc-update`, `PB-bootstrap-project`, `PB-feature-planner` (umbrella) |
| Decompose | `PB-decompose-issues` |
| Implement | `PB-implement` (umbrella), `PB-implement-backend`, `PB-implement-frontend`, `PB-implement-mobile`, `PB-implement-devops` |
| Verify | `PB-test-plan`, `PB-test-generate`, `PB-verify`, `PB-review`, `PB-security-review`, `PB-perf-review` |
| Ship | `PB-prepare-release` |
| Operate | `PB-maintenance-triage` |

### Workflows — 14 frozen

`WF-PROJECT-NEW`, `WF-PROJECT-EXISTING`, `WF-DISCOVERY`, `WF-PRD`, `WF-FEATURE`, `WF-ENHANCEMENT`, `WF-BUGFIX`, `WF-REFACTOR`, `WF-TESTING`, `WF-RELEASE`, `WF-MAINTENANCE`, `WF-SECURITY`, `WF-PERF`, `WF-DOCS`

### Standards — 18 frozen

4 contracts + 14 engineering standards (see `STANDARDS-REGISTRY.yaml`)

### Human gates — 8

`H-INTAKE`, `H-FRAME`, `H-PLAN`, `H-DECOMPOSE`, `H-IMPLEMENT`, `H-VERIFY`, `H-SHIP`, `H-OPERATE`, `H-META` (advisory)

---

## Machine Registries (Frozen Snapshots)

| Registry | Path |
|----------|------|
| Skill Registry | `release/v1.0/SKILL-REGISTRY.yaml` |
| Workflow Registry | `release/v1.0/WORKFLOW-REGISTRY.yaml` |
| Standards Registry | `release/v1.0/STANDARDS-REGISTRY.yaml` |
| Dependency Graph | `release/v1.0/DEPENDENCY-GRAPH.yaml` |
| Artifact Registry (live SSOT) | `ARTIFACT-REGISTRY.yaml` |
| Routing Matrix (live SSOT) | `workflows/project-orchestrator/routing-matrix.yaml` |

---

## CI Validation (Frozen Baseline)

| Script | Purpose |
|--------|---------|
| `scripts/verify-catalog.sh` | INDEX `active_skills` ↔ registry count |
| `scripts/sync-routing-graph.sh` | routing-matrix ↔ playbook status |
| `scripts/simulate-workflow.sh` | All WF phases playbook-ready |
| `scripts/verify-skill-spec.sh` | STD-SKILL-001 structural preflight |

---

## Out of Scope for v1.0 (Post-Freeze)

| Item | Target |
|------|--------|
| Meta skills (`MS-*`) promotion | v1.1 |
| Platform adapter bundles | v1.1 |
| Runtime agent E2E harness | v1.1 |
| `12-qa-scenarios.md` rollout (31 skills) | v1.1 |
| Checklist `draft` → `active` promotion | v1.1+ |

See `FUTURE-ENHANCEMENTS.md` and `ROADMAP-v2.md`.

---

## Freeze Sign-Off

| Field | Value |
|-------|-------|
| reviewer | Principal Architect |
| review_date | 2026-06-18 |
| decision | **approved** |
| active_playbooks | 32 |
| open_p0 | 0 |
| notes | No further architectural changes in v1.0. Enhancement via v1.1+ roadmap only. |

---

## Release Bundle Index

| Document | Path |
|----------|------|
| Platform Manifest | `release/v1.0/PLATFORM-MANIFEST.md` (this file) |
| Version Report | `release/v1.0/VERSION-REPORT.md` |
| Architecture Report | `release/v1.0/ARCHITECTURE-REPORT.md` |
| Dependency Graph | `release/v1.0/DEPENDENCY-GRAPH.md` |
| Roadmap v2 | `release/v1.0/ROADMAP-v2.md` |
| Future Enhancements | `release/v1.0/FUTURE-ENHANCEMENTS.md` |
| Foundation (live) | `FOUNDATION.md` |
| Catalog (live) | `INDEX.md` |