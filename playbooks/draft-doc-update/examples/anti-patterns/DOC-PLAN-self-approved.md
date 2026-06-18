---
document_id: DOC-PLAN-WR-BAD-APPROVE
work_id: WR-BAD-001
doc_plan_type: lite
workflow_id: WF-DOCS
status: approved
upstream_int_path: work/intake/WR-BAD-001.md
quality_chain_gap: waiver
---

# DOC-PLAN — BAD EXAMPLE (self-approved)

## 5. Planned Updates

| ID | Doc path | Change type | Priority | Owner | Acceptance signal |
|----|----------|-------------|----------|-------|-------------------|
| DU-01 | README.md | update | P0 | human | Done |

## 9. Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | approve |
| approver | PB-draft-doc-update |
| date | 2026-06-18 |

**Why anti-pattern:** CL-DOC-UPDATE #10 — agent must set `decision: pending` only; human approves at H-PLAN.