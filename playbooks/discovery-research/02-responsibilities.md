# PB-discovery-research — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved INT linked in WR, or waiver recorded |
| P2 | Load INT + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Set `discovery_type` | Maps from INT `work_type` + `entry_mode` |
| P4 | Gather evidence | Citations for as-is, gaps, and impact claims |
| P5 | Document exploration | Questions investigated, alternatives, risks |
| P6 | Define problem & recommendations | Problem statement + recommended direction |
| P7 | Produce DISC (OUT-01) | Complete per TP-discovery + 04-io-contract |
| P8 | Update Work Record | Link DISC; status `discovery_pending_review` |
| P9 | Run CL-DISCOVERY | Validation record = pass |
| P10 | Prepare handoff for H-FRAME | `decision: pending`; recommend next playbook only |

### discovery_type enum

| discovery_type | From INT signal |
|----------------|-----------------|
| `new_project` | `work_type: new_project` |
| `existing_onboarding` | `work_type: existing_project` |
| `feature` | `work_type: feature` |
| `enhancement` | `work_type: enhancement` |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write PRD | PB-draft-prd |
| N3 | Write architecture / API / database specs | PB-draft-architecture |
| N4 | Decompose issues | PB-decompose-issues |
| N5 | Write or modify application code | PB-implement |
| N6 | Approve H-FRAME or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-FRAME |
| N8 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N9 | Deep unrestricted codebase survey | Bounded per 05-context.md |
| N10 | Stakeholder interviews (live) | Human |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist DISC |
| N13 | Self-approve discovery | Human at H-FRAME |
| N14 | Skip CL-DISCOVERY | Never |
| N15 | Copy secrets/PII into DISC | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Research findings & DISC draft | proposes | approves / revises / rejects at H-FRAME |
| Intake alignment assessment | proposes `alignment` field | decides on re-intake |
| Open questions resolution | lists | decides sufficient for Plan |
| Next playbook | recommends | approves after H-FRAME |