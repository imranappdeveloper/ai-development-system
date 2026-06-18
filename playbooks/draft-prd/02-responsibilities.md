# PB-draft-prd — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved INT linked in WR; DISC or waiver per workflow |
| P2 | Load INT + DISC + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Set `prd_type` | `full` or `lite` per scope and workflow |
| P4 | Trace requirements upstream | Goals/FR cite INT and DISC where present |
| P5 | Define FR/NFR and ACs | IDs assigned; ACs testable with verification method |
| P6 | Document UX intent & rollout | High-level only — detail deferred to downstream TPs |
| P7 | Produce PRD (OUT-01) | Complete per TP-prd + 04-io-contract |
| P8 | Update Work Record | Link PRD; status `plan_pending_review` |
| P9 | Run CL-PRD | Validation record = pass |
| P10 | Prepare handoff for H-PLAN | `decision: pending`; recommend next playbook only |

### prd_type enum

| prd_type | When |
|----------|------|
| `full` | `new_project`, large `feature`, multi-surface scope |
| `lite` | Narrow `enhancement`, WF-PRD slice, single-module change |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Re-run discovery research | PB-discovery-research |
| N3 | Write architecture / API / database specs | PB-draft-architecture, PB-draft-api, PB-draft-database |
| N4 | Decompose issues or sprint plans | PB-decompose-issues, PB-feature-planner |
| N5 | Write or modify application code | PB-implement |
| N6 | Approve H-PLAN or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-PLAN |
| N8 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N9 | Deep unrestricted codebase survey | Bounded per 05-context.md |
| N10 | Embed routing matrix in outputs | Orchestrator SSOT |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist PRD |
| N13 | Self-approve PRD | Human at H-PLAN |
| N14 | Skip CL-PRD | Never |
| N15 | Copy secrets/PII into PRD | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| PRD content & scope | proposes | approves / revises / rejects at H-PLAN |
| `prd_type` selection | proposes | may override at H-PLAN |
| Open questions resolution | lists | decides sufficient for downstream |
| DISC waiver when missing | documents `discovery_gap` | may waive at orchestrator preflight |
| Next playbook | recommends | approves after H-PLAN |