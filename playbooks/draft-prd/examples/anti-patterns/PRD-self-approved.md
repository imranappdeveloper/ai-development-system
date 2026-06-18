---
document_id: PRD-WR-BAD-APPROVE
work_id: WR-BAD-003
prd_type: full
status: approved
upstream_int_path: work/intake/WR-BAD-003.md
discovery_gap: waiver
---

# PRD — BAD EXAMPLE (self-approved)

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | approve |
| approver | PB-draft-prd |
| date | 2026-06-18 |

**Why anti-pattern:** CL-PRD #10 — agent must set `decision: pending` only; human approves at H-PLAN.