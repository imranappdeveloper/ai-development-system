---
template_id: TP-doc-plan
version: 1.0.0
status: draft
document_type: plan
producer: PB-draft-doc-update
artifact_id: DOC-PLAN
gate: H-PLAN
---

# {{document_title}}

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | {{document_id}} |
| work_id | {{work_id}} |
| project | {{project_name}} |
| author | PB-draft-doc-update |
| created | {{date}} |
| last_updated | {{date}} |
| status | draft \| pending_review \| approved \| rejected |
| doc_plan_type | full \| lite \| changelog \| api_reference \| runbook \| onboarding |

---

## 1. Overview

### 1.1 Summary

[One paragraph — what documentation work is planned and why.]

### 1.2 Goals

| Goal | Metric | Target |
|------|--------|--------|
| | | |

### 1.3 Non-Goals

| Non-goal | Rationale |
|----------|-----------|
| | |

---

## 2. Scope & Audience

### 2.1 Audience

| Audience | Needs | Primary docs |
|----------|-------|--------------|
| | | |

### 2.2 Doc scope

`project_docs` | `os_docs` | `api_docs` | `mixed`

---

## 3. Upstream Traceability

```yaml
upstream_traceability:
  intake_work_type: <from INT>
  intake_workflow_id: <from INT>
  upstream_int_path: <INT path>
  quality_chain_linked: true | false
  quality_chain_refs: [<REVIEW | SEC-REVIEW | PERF-REVIEW paths or empty>]
  quality_chain_alignment: aligned | partial | not_applicable
```

### 3.1 References

| Artifact | Path | Role |
|----------|------|------|
| INT | | SSOT for scope |
| | | |

---

## 4. Document Inventory

| Path | Current state | Drift signal | Action |
|------|---------------|--------------|--------|
| | exists \| missing \| stale | green \| yellow \| red | update \| create \| deprecate |

---

## 5. Planned Updates

| ID | Doc path | Change type | Priority | Owner | Acceptance signal |
|----|----------|-------------|----------|-------|-------------------|
| DU-01 | | update \| create \| remove | P0 \| P1 \| P2 | | |

---

## 6. Standards & Conventions

| Standard | Application |
|----------|-------------|
| STD-DOC-001 | Document classes and ownership |
| STD-MD-001 | Markdown structure |
| STD-VER-001 | Version and status semantics |

---

## 7. Rollout & Review Plan

| Phase | Action | Owner | Done when |
|-------|--------|-------|-----------|
| | | | |

---

## 8. Risks & Open Questions

| ID | Risk / question | Impact | Mitigation / decision needed |
|----|-----------------|--------|------------------------------|
| | | | |

---

## 9. Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | pending |
| approver | |
| date | |
| notes | |