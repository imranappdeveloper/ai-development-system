---
document_id: ARCH-WR-BAD-APPROVE
work_id: WR-BAD-APPROVE
architecture_type: delta
status: approved
---

# Architecture — BAD EXAMPLE (self-approved)

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | approve |
| approver | PB-draft-architecture |
| date | 2026-06-18 |

**Why anti-pattern:** CL-ARCH #10 — agent must set `decision: pending` only; human approves at H-PLAN.