---
document_id: API-WR-BAD-APPROVE
work_id: WR-BAD-APPROVE
change_type: new
status: approved
---

# API Specification — BAD EXAMPLE (self-approved)

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | approve |
| approver | PB-draft-api |
| date | 2026-06-18 |

**Why anti-pattern:** CL-API #10 — agent must set `decision: pending` only; human approves at H-PLAN.