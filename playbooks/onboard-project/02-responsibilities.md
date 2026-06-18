# PB-onboard-project — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved INT linked in WR; CONTEXT.md path resolvable |
| P2 | Load INT + CONTEXT.md | Full CONTEXT read within budget per 05-context.md |
| P3 | Set `onboarding_type` | `existing_project` from INT `work_type` |
| P4 | Assess CONTEXT.md | Drift signals, gaps, proposed updates (proposals only) |
| P5 | Build module map | Top-level modules with purpose and key paths |
| P6 | OS adoption checklist | Checklist rows grounded in evidence |
| P7 | Produce ONBOARD (OUT-01) | Complete per 04-io-contract |
| P8 | Update Work Record | Link ONBOARD; status `onboard_pending_review` |
| P9 | Run CL-ONBOAR | Validation record = pass |
| P10 | Prepare handoff for H-FRAME | `decision: pending`; recommend next playbook only |

### onboarding_type enum

| onboarding_type | From INT signal |
|-----------------|-----------------|
| `existing_project` | `work_type: existing_project` |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write PRD or feature specs | PB-draft-prd |
| N3 | Write architecture / API / database specs | PB-draft-architecture |
| N4 | Implement application code | PB-implement |
| N5 | Approve H-FRAME or advance workflow | Human |
| N6 | Auto-invoke next playbook | Human after H-FRAME |
| N7 | **Write** CONTEXT.md without human-approved doc skill | PB-draft-doc-update / human |
| N8 | Deep unrestricted codebase survey | Bounded per 05-context.md; PB-survey-codebase optional |
| N9 | Stakeholder interviews (live) | Human |
| N10 | Modify OS repository files | OS maintainer |
| N11 | Store decisions only in chat | Must persist ONBOARD |
| N12 | Self-approve onboarding | Human at H-FRAME |
| N13 | Skip CL-ONBOAR | Never |
| N14 | Copy secrets/PII into ONBOARD | Redact `[REDACTED]` |
| N15 | Proceed without CONTEXT.md | Block; EC-ENT-04 |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| CONTEXT assessment & ONBOARD draft | proposes | approves / revises / rejects at H-FRAME |
| Proposed CONTEXT.md updates | lists in §3 | approves before PB-draft-doc-update |
| OS adoption gaps | documents | prioritizes at H-FRAME |
| Next playbook | recommends | approves after H-FRAME |