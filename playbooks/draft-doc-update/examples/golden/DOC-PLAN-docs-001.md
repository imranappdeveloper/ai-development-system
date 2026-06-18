---
scenario_id: HT-05
skill_id: PB-draft-doc-update
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-DOCS
    current_phase: Plan
  playbook_invocation:
    skill_id: PB-draft-doc-update
    mode: new
  work_id: WR-DOCS-ALPHA
  project_root: fixtures/projects/wf-docs-alpha
  artifact_refs:
    - type: INT
      path: work/intake/WR-DOCS-ALPHA.md
expected_outputs:
  out_01_path: work/doc-plan/WR-DOCS-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: null
---

---
document_id: DOC-PLAN-WR-DOCS-ALPHA
work_id: WR-DOCS-ALPHA
doc_plan_type: lite
doc_scope: project_docs
workflow_id: WF-DOCS
status: pending_review
revision: 0
created: 2026-06-18T14:00:00Z
upstream_int_path: work/intake/WR-DOCS-ALPHA.md
quality_chain_gap: waiver
---

# Documentation Plan — API onboarding refresh

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | DOC-PLAN-WR-DOCS-ALPHA |
| work_id | WR-DOCS-ALPHA |
| project | wf-docs-alpha |
| author | PB-draft-doc-update |
| created | 2026-06-18 |
| status | pending_review |
| doc_plan_type | lite |

---

## 1. Overview

### 1.1 Summary

Refresh project documentation so new contributors can discover the HTTP API surface, authentication flow, and local development setup without reading source code.

### 1.2 Goals

| Goal | Metric | Target |
|------|--------|--------|
| Faster onboarding | Time-to-first successful API call (self-reported) | ≤15 minutes |
| Doc accuracy | Broken links in `docs/` | 0 at execution complete |

### 1.3 Non-Goals

| Non-goal | Rationale |
|----------|-----------|
| OpenAPI spec generation from code | Out of INT scope — manual tables only |
| Marketing site copy | Product marketing separate initiative |

---

## 2. Scope & Audience

### 2.1 Audience

| Audience | Needs | Primary docs |
|----------|-------|--------------|
| New backend contributors | Auth + local run | README, `docs/api.md` |
| API consumers | Endpoint summary | `docs/api.md` |

### 2.2 Doc scope

`project_docs`

---

## 3. Upstream Traceability

```yaml
upstream_traceability:
  intake_work_type: documentation
  intake_workflow_id: WF-DOCS
  upstream_int_path: work/intake/WR-DOCS-ALPHA.md
  quality_chain_linked: false
  quality_chain_refs: []
  quality_chain_alignment: not_applicable
```

### 3.1 References

| Artifact | Path | Role |
|----------|------|------|
| INT | work/intake/WR-DOCS-ALPHA.md | SSOT for scope |
| CONTEXT | CONTEXT.md | Stack and conventions |

---

## 4. Document Inventory

| Path | Current state | Drift signal | Action |
|------|---------------|--------------|--------|
| README.md | exists | yellow | update |
| docs/api.md | missing | red | create |
| docs/CONTRIBUTING.md | exists | green | update |

---

## 5. Planned Updates

| ID | Doc path | Change type | Priority | Owner | Acceptance signal |
|----|----------|-------------|----------|-------|-------------------|
| DU-01 | README.md | update | P0 | human | Quickstart lists `make dev` and health URL |
| DU-02 | docs/api.md | create | P0 | human | Documents auth header + 3 core endpoints |
| DU-03 | docs/CONTRIBUTING.md | update | P1 | human | Links to `docs/api.md` from API section |

---

## 6. Standards & Conventions

| Standard | Application |
|----------|-------------|
| STD-DOC-001 | README and `docs/**` ownership; folder index rules |
| STD-MD-001 | Heading hierarchy and metadata tables |
| STD-VER-001 | `status` and `revision` on durable docs when added |

---

## 7. Rollout & Review Plan

| Phase | Action | Owner | Done when |
|-------|--------|-------|-----------|
| 1 | Apply DU-01 README quickstart | human | Local smoke test documented |
| 2 | Create DU-02 `docs/api.md` | human | Peer review against running API |
| 3 | Link DU-03 CONTRIBUTING | human | No broken relative links |

---

## 8. Risks & Open Questions

| ID | Risk / question | Impact | Mitigation / decision needed |
|----|-----------------|--------|------------------------------|
| RQ-01 | Auth mechanism may change in Q3 | api.md stale quickly | Human: add version banner in DU-02 |
| RQ-02 | Missing OpenAPI — table maintenance burden | Drift from code | Accept manual tables per INT non-goals |

---

## 9. Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | pending |
| approver | |
| date | |
| notes | |