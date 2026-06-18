# PB-draft-feature — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | DISC linked in WR; H-FRAME approved |
| P2 | Load DISC + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Set `feat_type` and `feat_scope` | Enums per registry.yaml |
| P4 | Trace requirements upstream | Goals/behavior cite DISC evidence |
| P5 | Define scope and testable ACs | IDs assigned; ACs have verification method |
| P6 | Document user-visible behavior | Flows and rules — no technical design |
| P7 | Produce FEAT (OUT-01) | Complete per 04-io-contract; no forbidden sections |
| P8 | Update Work Record | Link FEAT; status `plan_pending_review` |
| P9 | Run CL-DRAFT (FEAT path) | Validation record = pass |
| P10 | Prepare handoff for H-PLAN | `decision: pending`; recommend `PB-decompose-issues` only |

### feat_type / feat_scope enums

| Enum | When |
|------|------|
| `feat_type: new` | Net-new user-visible capability per DISC |
| `feat_type: enhancement` | Extension of existing surface per DISC |
| `feat_scope: narrow_slice` | Single implementable unit; PRD waived |
| `feat_scope: vertical_slice` | End-to-end user journey for one feature area |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference INT when linked in DISC | Cite path in References — do not re-classify |
| S2 | Flag alignment gaps | `discovery_alignment: partial` with risks table |
| S3 | Document open questions for human | In artifact §Open Questions |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Note single-unit implement path | When scope clearly one ISS — recommend only |
| O2 | Suggest UX notes | High-level copy/layout intent — no wireframes as SSOT |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Re-run discovery research | PB-discovery-research |
| N3 | Write PRD for multi-epic scope | PB-draft-prd |
| N4 | Write architecture / API / database specs | PB-draft-architecture, PB-draft-api, PB-draft-database |
| N5 | Decompose issues or sprint plans | PB-decompose-issues |
| N6 | Write or modify application code | PB-implement-* |
| N7 | Approve H-PLAN or advance workflow | Human |
| N8 | Auto-invoke next playbook | Human after gate |
| N9 | Update CONTEXT.md | PB-onboard-project / human |
| N10 | Deep unrestricted codebase survey | Bounded per 05-context.md |
| N11 | Embed routing matrix in outputs | Orchestrator SSOT |
| N12 | Modify OS repository files | OS maintainer |
| N13 | Store decisions only in chat | Must persist FEAT |
| N14 | Self-approve artifact | Human at H-PLAN |
| N15 | Copy secrets/PII into FEAT | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| FEAT content & scope | proposes | approves / revises / rejects at H-PLAN |
| `feat_type` / `feat_scope` selection | proposes | may override at H-PLAN |
| Open questions resolution | lists | decides sufficient for downstream |
| PRD vs FEAT path | documents rationale from DISC | may redirect to PB-draft-prd at H-PLAN |
| Next playbook | recommends | approves after H-PLAN |