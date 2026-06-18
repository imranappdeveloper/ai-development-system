# PB-draft-api — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved ARCH linked in WR; PRD/DB or gap waivers documented |
| P2 | Load ARCH + PRD + DB slice + CONTEXT | T1/T2 bundles per 05-context.md |
| P3 | Set `change_type` | Maps from ARCH scope, workflow, and versioning signals |
| P4 | Map operations to requirements | §4 operations trace to PRD FR/NFR or ARCH flows |
| P5 | Define request/response models | §5 data models align with DB when present |
| P6 | Document auth, errors, conventions | §2–§3 per TP-api + STD-SEC-001 |
| P7 | Produce API (OUT-01) | Complete per TP-api + 04-io-contract |
| P8 | Update Work Record | Link API; status `api_pending_review` |
| P9 | Run CL-API | Validation record = pass |
| P10 | Prepare handoff for H-PLAN | `decision: pending`; recommend next playbook only |

### change_type enum

| change_type | From signal |
|-------------|-------------|
| `new` | Greenfield API surface; typical WF-FEATURE |
| `additive` | New endpoints or fields without breaking clients; WF-ENHANCEMENT |
| `breaking` | Contract changes requiring client migration; WF-REFACTOR or WF-SECURITY |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Document rate limits and versioning | Public or partner-facing APIs |
| S2 | Flag ARCH gaps blocking API design | `api_confidence: low` |
| S3 | Note breaking-change migration path | `breaking` change_type |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Cross-reference existing OpenAPI or route files | Project has bounded API markers |
| O2 | Suggest PB-decompose-issues | Large surface needing task breakdown |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD | PB-draft-prd |
| N3 | Write or modify ARCH | PB-draft-architecture |
| N4 | Write or modify DB schema design | PB-draft-database |
| N5 | Write handler code, middleware, or client SDKs | PB-implement-backend |
| N6 | Approve H-PLAN or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-PLAN |
| N8 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Choose implementation tasks or sprint order | PB-decompose-issues |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist API |
| N13 | Self-approve API specification | Human at H-PLAN |
| N14 | Skip CL-API | Never |
| N15 | Copy secrets/API keys into API doc | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| API design & API draft | proposes | approves / revises / rejects at H-PLAN |
| ARCH/PRD/DB alignment assessment | proposes alignment blocks | decides on upstream revise vs proceed |
| Open questions resolution | lists | decides sufficient for Implement |
| Breaking-change acceptance | proposes migration path | approves high-impact decisions |
| Next playbook | recommends | approves after H-PLAN |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-draft-architecture | skill (soft) | ARCH artifact |
| ARCH | artifact | H-PLAN approved on ARCH (or documented waiver) |
| PRD | artifact (soft) | Grounding for FR/NFR when present |
| DB | artifact (soft) | Grounding for data models when present |
| TP-api | template | OUT-01 structure |
| CL-API | checklist | Handoff blocker |
| STD-ARCH-005 | standard | Contract SSOT |
| STD-SEC-001 | standard | Auth and data exposure |
| STD-OPS-001 | standard | Correlation IDs, audit |