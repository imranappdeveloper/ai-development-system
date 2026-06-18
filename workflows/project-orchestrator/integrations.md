# Orchestrator Integration Contracts

| Field | Value |
|-------|-------|
| document_id | ORCH-INT-001 |
| version | 1.0.0 |
| status | active |
| updated | 2026-06-18 |
| normative_ref | `DESIGN.md` §15 |

Per-playbook integration table for ORCH-PROJECT handoff ingestion and preflight.

---

## Integration Table

| skill_id | Phase | Requires gates | Requires artifacts | Produces | Exit gate |
|----------|-------|----------------|-------------------|----------|-----------|
| PB-intake-classify | Intake | — | raw_request | INT | H-INTAKE |
| PB-discovery-research | Frame | H-INTAKE | INT | DISC | H-FRAME |
| PB-onboard-project | Frame | H-INTAKE | INT | ONBOARD | H-FRAME |
| PB-survey-codebase | Frame | H-INTAKE | INT | SURVEY | none |
| PB-draft-prd | Plan | H-FRAME (soft) | INT, DISC? | PRD | H-PLAN |
| PB-draft-feature | Plan | H-FRAME | DISC | FEAT | H-PLAN |
| PB-draft-architecture | Plan | H-PLAN | PRD | ARCH | H-PLAN |
| PB-draft-issue | Plan | H-INTAKE | INT, DIAG? | ISS | H-PLAN |
| PB-diagnose-bug | Plan | H-INTAKE | INT | DIAG | H-PLAN |
| PB-security-assess | Plan | H-INTAKE | INT | SEC-ASSESS | H-PLAN |
| PB-perf-baseline | Plan | H-INTAKE | INT | PERF-BASE | H-PLAN |
| PB-draft-doc-update | Plan | H-INTAKE | INT | DOC-PLAN | H-PLAN |
| PB-bootstrap-project | Plan | H-PLAN | PRD | SCAFFOLD | H-PLAN |
| PB-decompose-issues | Decompose | H-PLAN | PRD | ISS-* | H-DECOMPOSE |
| PB-implement | Implement | H-DECOMPOSE or H-PLAN | ISS | CODE | H-IMPLEMENT |
| PB-test-plan | Verify | H-IMPLEMENT (soft) | CODE (soft), PRD?, ISS? | TEST-PLAN | H-VERIFY (soft — plan) |
| PB-test-generate | Verify | — | TEST-PLAN (soft), CODE (soft) | TEST-GEN | none |
| PB-verify | Verify | H-IMPLEMENT (soft) | CODE | TEST-RPT | H-VERIFY |
| PB-review | Verify | H-IMPLEMENT (soft) | CODE | REVIEW | H-VERIFY (soft — review) |
| PB-security-review | Verify | H-IMPLEMENT | CODE | SEC-REVIEW | H-VERIFY (soft optional) |
| PB-perf-review | Verify | H-IMPLEMENT | CODE | PERF-REVIEW | H-VERIFY |
| PB-prepare-release | Ship | H-VERIFY (soft for WF-RELEASE) | CODE; TEST-RPT (soft) | REL | H-SHIP |
| PB-maintenance-triage | Operate | H-INTAKE | INT | MAINT | H-OPERATE |

`?` = optional per workflow path. Resolve via `routing-matrix.yaml` + `phases.yaml`.

---

## Handoff Ingestion Contract

Orchestrator accepts playbook handoff **iff**:

1. `skill_id` matches invoked playbook
2. `work_id` matches ORS
3. Validation record `result: pass` OR escalation declared
4. Required OUT-* paths listed
5. `exit_gate` present if playbook has gate
6. `recommended_next_skill` ∈ routing matrix `next_candidates` (warning if not)

---

## Reconcile Command

On `resume`, ORCH-PROJECT:

1. Loads WR + linked artifacts + existing ORS (if any)
2. Rebuilds ORS phase from WR status and `approvals[]`
3. Does **not** re-run completed playbooks
4. Surfaces drift if standalone playbook ran outside orchestrator

Documented for standalone playbook runs merged back into orchestrated work.

---

## References

| Doc | Path |
|-----|------|
| Routing matrix | `routing-matrix.yaml` |
| Gates | `gates.yaml` |
| Skill graph | `skill-dependency-graph.yaml` |
| Design | `DESIGN.md` |