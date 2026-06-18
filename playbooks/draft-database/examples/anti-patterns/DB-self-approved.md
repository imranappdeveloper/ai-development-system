---
document_id: DB-WR-BAD-APPROVE
work_id: WR-BAD-APPROVE
change_type: new_schema
status: approved
---

# Database Design — BAD EXAMPLE (self-approved)

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | approve |
| approver | PB-draft-database |
| date | 2026-06-18 |

**Why anti-pattern:** CL-DATABASE #10 — agent must set `decision: pending` only; human approves at H-PLAN.