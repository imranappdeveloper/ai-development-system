# Foundation v1.0 Manifest

| Field | Value |
|-------|-------|
| platform | **AI Development OS** |
| version | **1.1.0** |
| status | **frozen** |
| freeze_date | 2026-06-19 |
| updated | 2026-06-19 |
| owner | Principal Architect |
| substrate_readiness | 96/100 (v1.0 playbooks) |
| spec_sha | `c969fe5de054aaac` |
| release_bundle | `release/v1.1/` |
| prior_release | `release/v1.0/` (playbook substrate — immutable) |

---

## Purpose

Single entry point for platform version, P0 completion tracking, and freeze criteria.

**v1.1** adds standalone execution (bundled skills + server AFK). **v1.0** playbook substrate in `release/v1.0/` is unchanged.

---

## P0 Checklist — Complete

| # | Item | Status |
|---|------|--------|
| 1 | `docs/` platform architecture | done |
| 2 | `FOUNDATION.md` | done |
| 3 | `ARTIFACT-REGISTRY.yaml` | done |
| 4 | `workflows/project-orchestrator/routing-matrix.yaml` | done |
| 5 | `workflows/project-orchestrator/gates.yaml` | done |
| 6 | `workflows/project-orchestrator/integrations.md` | done |
| 7 | 14× `WF-*/phases.yaml` + 14 normative specs | done |
| 8 | `CL-ORCH` + referenced CL-* registry integrity | done |
| 9 | `STD-ARTIFACT-001` | done |
| 10 | TP-intake, TP-WR, TP-ORS | done |
| 11 | intake + discovery `registry.yaml` | done |
| 12 | Fixtures + goldens (intake, discovery) | done |
| 13 | Orchestrator playbook 02–11 | done |
| 14 | Phantom skill stubs under `playbooks/` | done |
| 15 | feature-planner identity resolution | done |
| 16 | Intake routing SSOT dedupe | done |
| 17 | WF-RELEASE graph fix | done |
| 18 | Promotion gate evidence | done |
| 19 | Catalog end-to-end alignment | done |

---

## Architectural P0 Resolution (2026-06-18)

| ID | Issue | Resolution |
|----|-------|------------|
| P0-01 | Scaffold registries falsely `draft` | Honest `registry.yaml` per scaffold |
| P0-02 | Missing CL-* checklists | 36 checklists; registry `checklist_id` resolvable |
| P0-03 | H-META missing | Added to `gates.yaml` |
| P0-04 | Manifest path inaccuracy | Orchestrator paths corrected |
| P0-05 | G-WF-05 incomplete | T-E2E-01–06 in orchestrator `11-test-plan.md` |
| P0-06 | Zero `active` skills | Full spine promoted → 32 active |
| P0-07 | No version control | Git repository initialized |

---

## v1.1 Scope (Frozen — 2026-06-19)

**Delivered:** Standalone execution layer — **19 bundled slash skills**, server AFK (`task-run-server.sh`, `task-run-poll.sh`), grok/agy symlinks, user flows (`USER-FLOW`, `AFK-TASK-RUN`, `STANDALONE`), done-at-PR-create policy.

**Bundle:** `release/v1.1/`

## v1.0 Scope (Frozen — 2026-06-18, unchanged)

**Delivered:** Full delivery spine — **32 `active` playbooks**, 14 workflows, 18 standards, CI validation (`verify-catalog`, `sync-routing-graph`, `simulate-workflow`, `verify-skill-spec`).

**Bundle:** `release/v1.0/`

**Post-freeze backlog:** Meta skills (`MS-*`), runtime E2E harness, `12-qa-scenarios.md` rollout. See `release/v1.0/ROADMAP-v2.md`.

---

## Freeze Criteria — v1.1 (2026-06-19)

- [x] `verify-standalone.sh` passes (19 bundled skills, symlinks, session tests)
- [x] `verify-catalog.sh` + `simulate-workflow.sh` pass (v1.0 substrate intact)
- [x] Server AFK stack documented (`AFK-TASK-RUN.md`, `task-run` skill)
- [x] User flow documented (`USER-FLOW.md`, `SETUP-ADS.md`)
- [x] Done-at-PR-create policy consistent across skills + docs
- [x] Principal Architect sign-off

### Principal Architect Sign-Off — v1.1

| Field | Value |
|-------|-------|
| reviewer | Principal Architect |
| review_date | 2026-06-19 |
| decision | **approved** |
| bundled_skills | 19 |
| open_p0 | 0 |
| notes | v1.1 frozen as Standalone Execution. v1.0 playbook substrate unchanged in `release/v1.0/`. |

## Freeze Criteria — v1.0 (2026-06-18)

- [x] All P0 checklist items done
- [x] Architectural P0 blockers resolved
- [x] Substrate readiness ≥ 95/100 (96)
- [x] Principal Architect sign-off

### Principal Architect Sign-Off — v1.0

| Field | Value |
|-------|-------|
| reviewer | Principal Architect |
| review_date | 2026-06-18 |
| decision | **approved** |
| active_playbooks | 32 |
| notes | Playbook substrate frozen. No further architectural changes to v1.0. |

---

## Release Bundles

### v1.1 (current)

| Document | Path |
|----------|------|
| Platform Manifest | `release/v1.1/PLATFORM-MANIFEST.md` |
| Version Report | `release/v1.1/VERSION-REPORT.md` |
| Bundled Skills | `release/v1.1/BUNDLED-SKILLS.yaml` |

### v1.0 (playbook substrate)

| Document | Path |
|----------|------|
| Platform Manifest | `release/v1.0/PLATFORM-MANIFEST.md` |
| Version Report | `release/v1.0/VERSION-REPORT.md` |
| Architecture Report | `release/v1.0/ARCHITECTURE-REPORT.md` |
| Dependency Graph | `release/v1.0/DEPENDENCY-GRAPH.md` + `.yaml` |
| Skill Registry | `release/v1.0/SKILL-REGISTRY.yaml` |
| Workflow Registry | `release/v1.0/WORKFLOW-REGISTRY.yaml` |
| Standards Registry | `release/v1.0/STANDARDS-REGISTRY.yaml` |
| Roadmap v2 | `release/v1.0/ROADMAP-v2.md` |
| Future Enhancements | `release/v1.0/FUTURE-ENHANCEMENTS.md` |

---

## References

| Doc | Path |
|-----|------|
| **Project Kickoff** | `docs/PROJECT-KICKOFF.md` |
| **Getting Started** | `docs/GETTING-STARTED.md` |
| Architecture | `docs/ARCHITECTURE.md` |
| SSOT hierarchy | `docs/SSOT-HIERARCHY.md` |
| Governance | `docs/GOVERNANCE.md` |
| Repository governance | `docs/REPOSITORY-GOVERNANCE.md` |
| Catalog | `INDEX.md` |
| Changelog | `CHANGELOG.md` |