# AI Development OS v1.0 — Version Report

| Field | Value |
|-------|-------|
| platform | AI Development OS |
| release | **1.0.0** |
| release_date | 2026-06-18 |
| status | frozen |
| spec_sha | `14d731c15af6532e` |
| git_ref | `98d2ffc7e496665d67a1a43e00c8acaf5521aa9c` |

---

## Platform Components

| Component | Version | Status | SSOT Path |
|-----------|---------|--------|-----------|
| Foundation manifest | 1.0.0 | frozen | `FOUNDATION.md` |
| Catalog index | 1.0.0 | frozen | `INDEX.md` |
| Artifact registry | 1.0.0 | active | `ARTIFACT-REGISTRY.yaml` |
| Workflow engine | 1.0.0 | frozen | `workflows/WORKFLOW-REGISTRY.yaml` |
| Routing matrix | 1.0.0 | active | `workflows/project-orchestrator/routing-matrix.yaml` |
| Skill dependency graph | 1.0.0 | frozen | `workflows/project-orchestrator/skill-dependency-graph.yaml` |
| Gates registry | 1.0.0 | active | `workflows/project-orchestrator/gates.yaml` |
| STD-SKILL-001 contract | 1.0.0 | active | `standards/SKILL-CONTRACT.md` |

---

## Delivery Playbooks (32 active)

| skill_id | spec_version | prompt_version | exit_gate |
|----------|--------------|----------------|-----------|
| PB-project-orchestrator | 0.2.0 | — | none |
| PB-intake-classify | 1.0.0 | 1.0.0 | H-INTAKE |
| PB-discovery-research | 1.0.0 | 1.0.0 | H-FRAME |
| PB-onboard-project | 1.0.0 | 1.0.0 | H-FRAME |
| PB-survey-codebase | 1.0.0 | 1.0.0 | none |
| PB-draft-prd | 1.0.0 | 1.0.0 | H-PLAN |
| PB-draft-feature | 1.0.0 | 1.0.0 | H-PLAN |
| PB-feature-planner | 1.0.0 | 1.0.0 | none (umbrella) |
| PB-draft-architecture | 1.0.0 | 1.0.0 | H-PLAN |
| PB-draft-database | 1.0.0 | 1.0.0 | H-PLAN |
| PB-draft-api | 1.0.0 | 1.0.0 | H-PLAN |
| PB-draft-ui-ux | 1.0.0 | 1.0.0 | H-PLAN |
| PB-draft-issue | 1.0.0 | 1.0.0 | H-PLAN |
| PB-diagnose-bug | 1.0.0 | 1.0.0 | H-PLAN |
| PB-security-assess | 1.0.0 | 1.0.0 | H-PLAN |
| PB-perf-baseline | 1.0.0 | 1.0.0 | H-PLAN |
| PB-draft-doc-update | 1.0.0 | 1.0.0 | H-PLAN |
| PB-bootstrap-project | 1.0.0 | 1.0.0 | H-PLAN |
| PB-decompose-issues | 1.0.0 | 1.0.0 | H-DECOMPOSE |
| PB-implement | 1.0.0 | 1.0.0 | none (umbrella) |
| PB-implement-backend | 1.0.0 | 1.0.0 | H-IMPLEMENT |
| PB-implement-frontend | 1.0.0 | 1.0.0 | H-IMPLEMENT |
| PB-implement-mobile | 1.0.0 | 1.0.0 | H-IMPLEMENT |
| PB-implement-devops | 1.0.0 | 1.0.0 | H-IMPLEMENT |
| PB-test-plan | 1.0.0 | 1.0.0 | H-VERIFY |
| PB-test-generate | 1.0.0 | 1.0.0 | none |
| PB-verify | 1.0.0 | 1.0.0 | H-VERIFY |
| PB-review | 1.0.0 | 1.0.0 | H-VERIFY |
| PB-security-review | 1.0.0 | 1.0.0 | H-VERIFY |
| PB-perf-review | 1.0.0 | 1.0.0 | H-VERIFY |
| PB-prepare-release | 1.0.0 | 1.0.0 | H-SHIP |
| PB-maintenance-triage | 1.0.0 | 1.0.0 | H-OPERATE |

---

## Meta Skills (6 draft — not in v1.0 invoke path)

| skill_id | status |
|----------|--------|
| MS-architecture-review | draft |
| MS-dependency-analysis | draft |
| MS-standards-review | draft |
| MS-workflow-review | draft |
| MS-repository-review | draft |
| MS-quality-review | draft |

---

## Workflows (14)

All workflows at engine version **1.0.0**. Normative specs in `workflows/specs/WF-*.yaml`. Phase DAGs in `workflows/WF-*/phases.yaml`.

| Class | Count | Workflows |
|-------|-------|-----------|
| end_to_end | 9 | PROJECT-NEW, PROJECT-EXISTING, FEATURE, ENHANCEMENT, BUGFIX, REFACTOR, SECURITY, PERF, DOCS |
| slice | 3 | DISCOVERY, PRD, TESTING |
| operate | 2 | RELEASE, MAINTENANCE |

---

## Standards (18)

| Layer | Count |
|-------|-------|
| Contracts | 4 (SKILL, META, ARTIFACT, ORCH design) |
| Engineering | 14 |

Full enumeration: `STANDARDS-REGISTRY.yaml`

---

## Templates (14)

`TP-intake`, `TP-WR`, `TP-ORS`, `TP-vision`, `TP-discovery`, `TP-prd`, `TP-architecture`, `TP-database`, `TP-api`, `TP-feature`, `TP-testing`, `TP-review`, `TP-release`, `TP-maintenance`

---

## Verification Baseline at Freeze

```
verify-catalog.sh         → PASS (active_skills=32)
sync-routing-graph.sh     → WARN=0
simulate-workflow.sh all  → FAIL=0
verify-skill-spec.sh ×32  → FAIL=0
```

---

## Versioning Policy (v1.0+)

Per `STD-VER-001`:

| Change type | Version bump |
|-------------|--------------|
| Breaking contract / gate / routing | Major (2.0.0) |
| New playbook or workflow | Minor (1.1.0) |
| Spec clarification, fixtures | Patch (1.0.1) |

Frozen v1.0 snapshots remain immutable under `release/v1.0/`. Live SSOT evolves on `main` per governance.