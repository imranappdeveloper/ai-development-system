# AI Development OS v1.0 — Architecture Report

| Field | Value |
|-------|-------|
| document_id | ARCH-REPORT-v1.0 |
| platform_version | 1.0.0 |
| status | frozen |
| updated | 2026-06-18 |
| normative_ref | `docs/ARCHITECTURE.md` (DOC-ARCH-001) |

---

## 1. Executive Summary

AI Development OS v1.0 implements a **Clean Architecture** for AI-assisted delivery: domain rules at the center, orchestration in the application layer, agent contracts at the interface, and adapters at the edge. Human gates enforce approval at every phase transition. Chat is never SSOT — artifacts and Work Records are.

**Architectural invariant (frozen):** No playbook embeds routing tables; orchestrator reads machine SSOT only.

---

## 2. Deployment Topology

```
┌─────────────────────────────────────────────────────────┐
│  AI_DEV_OS_HOME (global install — this repository)      │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │ standards/  │  │ workflows/   │  │ playbooks/     │ │
│  │ (domain)    │  │ (application)│  │ (interface)    │ │
│  └─────────────┘  └──────────────┘  └────────────────┘ │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐ │
│  │ templates/  │  │ checklists/  │  │ skills/ (ptr)  │ │
│  └─────────────┘  └──────────────┘  └────────────────┘ │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼ invokes
┌─────────────────────────────────────────────────────────┐
│  project_root (target software project)                 │
│  CONTEXT.md + work/{intake,prd,implement,...}/        │
└─────────────────────────────────────────────────────────┘
```

---

## 3. Layer Model

| Layer | Components | Dependency rule |
|-------|------------|-----------------|
| **Domain** | `ARTIFACT-REGISTRY.yaml`, `standards/`, `gates.yaml` enums | No outward deps |
| **Application** | ORCH-PROJECT, `routing-matrix.yaml`, `skill-dependency-graph.yaml`, `WF-*/phases.yaml` | → Domain only |
| **Interface** | `playbooks/*`, `checklists/*`, `templates/*` | → Application + Domain (read) |
| **Infrastructure** | `skills/` adapters, fixtures, CI scripts, `INDEX.md` | → all inward layers |

---

## 4. Orchestration Model

### ORCH-PROJECT responsibilities (frozen)

1. **Route** — map `work_type` + phase → `PB-*` via `routing-matrix.yaml`
2. **Sequence** — walk `WF-*/phases.yaml` execution DAG
3. **Gate** — block phase advance until `H-*` human approval
4. **Recover** — OUT-05 escalation, max 3 retries, rewind per `gates.yaml`

### Phase spine (canonical)

```
Intake → Frame → Plan → Decompose → Implement → Verify → Ship → Operate
```

### Umbrella skills (non-invokable)

| skill_id | Role |
|----------|------|
| `PB-project-orchestrator` | Meta-orchestration identity |
| `PB-feature-planner` | Routes to `PB-draft-feature` or `PB-decompose-issues` |
| `PB-implement` | Routes to lane children |

---

## 5. Artifact Flow

| Phase | Primary artifacts | Producer examples |
|-------|-------------------|-------------------|
| Intake | INT | PB-intake-classify |
| Frame | DISC, ONBOARD, SURVEY | PB-discovery-research, PB-onboard-project |
| Plan | PRD, FEAT, ARCH, ISS, SEC-ASSESS, PERF-BASE | PB-draft-prd, PB-draft-feature, … |
| Decompose | ISS-* | PB-decompose-issues |
| Implement | CODE (lane paths) | PB-implement-* |
| Verify | TEST-PLAN, TEST-GEN, TEST-RPT, REVIEW | PB-test-plan, PB-verify, PB-review |
| Ship | REL | PB-prepare-release |
| Operate | MAINT | PB-maintenance-triage |

Path SSOT: `ARTIFACT-REGISTRY.yaml`

---

## 6. Human Gate Architecture

| Gate | Binds | Blocks |
|------|-------|--------|
| H-INTAKE | INT | Frame, Plan |
| H-FRAME | DISC, ONBOARD | Plan |
| H-PLAN | PRD, FEAT, ARCH, ISS, … | Decompose, Implement |
| H-DECOMPOSE | ISS-* | Implement |
| H-IMPLEMENT | CODE | Verify (advisory/skippable) |
| H-VERIFY | TEST-RPT, REVIEW, … | Ship |
| H-SHIP | REL | Operate |
| H-OPERATE | MAINT | DONE |
| H-META | meta reviews | — (advisory) |

Waivers: per-workflow allowlist in `gates.yaml#waivable_gates`

---

## 7. Workflow Classes

| Class | Purpose | Terminal gate examples |
|-------|---------|------------------------|
| end_to_end | Full delivery path | H-SHIP, H-VERIFY, H-PLAN |
| slice | Partial path (discovery, PRD, testing) | H-FRAME, H-PLAN, H-VERIFY |
| operate | Release / maintenance | H-OPERATE |

---

## 8. Quality Architecture

| Mechanism | Role |
|-----------|------|
| STD-SKILL-001 | Playbook spec contract (01–11 + registry) |
| CL-* checklists | Pre-handoff self-check (10 checks when active) |
| `verify-skill-spec.sh` | Structural CI preflight |
| `latest-gate.md` | Sequential promotion evidence |
| `simulate-workflow.sh` | Workflow path readiness |

---

## 9. SSOT Hierarchy

```
FOUNDATION.md / INDEX.md
    └── ARTIFACT-REGISTRY.yaml
    └── routing-matrix.yaml
    └── skill-dependency-graph.yaml
    └── WORKFLOW-REGISTRY.yaml
    └── playbooks/<skill>/registry.yaml
    └── standards/*
```

Conflicts resolve upward. Playbook output must never embed routing matrix rows.

---

## 10. Frozen Boundaries (v1.0)

**In scope:**
- 32 delivery playbooks, 14 workflows, 8 gates
- Advisory enforcement (checklists + human sign-off)
- Structural CI validation

**Out of scope (v1.0):**
- Automated gate blocking in target project CI
- Live agent runtime daemon
- Meta skill execution path
- Platform vendor adapter bundles

---

## References

| Doc | Path |
|-----|------|
| Platform architecture | `docs/ARCHITECTURE.md` |
| SSOT hierarchy | `docs/SSOT-HIERARCHY.md` |
| Governance | `docs/GOVERNANCE.md` |
| Orchestrator design | `workflows/project-orchestrator/DESIGN.md` |
| Workflow engine | `workflows/ENGINE.md` |