# PB-draft-architecture — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved PRD linked in WR, or waiver recorded |
| P2 | Load PRD + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Set `architecture_type` | Maps from PRD `prd_type`, workflow, and scope |
| P4 | Model system context | C4 context + container views per STD-ARCH-001 |
| P5 | Define layers, modules, dependencies | Dependency rules explicit; inward flow documented |
| P6 | Document data flows & cross-cutting concerns | Critical flows + security/ops references |
| P7 | Produce ARCH (OUT-01) | Complete per TP-architecture + 04-io-contract |
| P8 | Update Work Record | Link ARCH; status `architecture_pending_review` |
| P9 | Run CL-ARCH | Validation record = pass |
| P10 | Prepare handoff for H-PLAN | `decision: pending`; recommend next playbook only |

### architecture_type enum

| architecture_type | From signal |
|-------------------|-------------|
| `greenfield` | `WF-PROJECT-NEW`; no existing system in CONTEXT |
| `as_is` | Document current state only (rare; usually paired with delta) |
| `delta` | `WF-REFACTOR` or PRD describes change to existing system |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Recommend ADR topics | Material decisions without existing ADR |
| S2 | Flag PRD gaps blocking design | `architecture_confidence: low` |
| S3 | Note migration/rollback phases | `delta` or refactor scope |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Reference existing ADRs | Project has `docs/adr/` |
| O2 | Suggest PB-draft-database / PB-draft-api | Data or API surface is complex |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD | PB-draft-prd |
| N3 | Write application code or pseudocode blocks | PB-implement |
| N4 | Decompose issues | PB-decompose-issues |
| N5 | Write detailed API or database schemas | PB-draft-api / PB-draft-database |
| N6 | Approve H-PLAN or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-PLAN |
| N8 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Choose implementation tasks or sprint order | PB-decompose-issues |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist ARCH |
| N13 | Self-approve architecture | Human at H-PLAN |
| N14 | Skip CL-ARCH | Never |
| N15 | Copy secrets/PII into ARCH | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Architecture design & ARCH draft | proposes | approves / revises / rejects at H-PLAN |
| PRD alignment assessment | proposes `prd_alignment` field | decides on PRD revise vs proceed |
| Open questions resolution | lists | decides sufficient for Decompose |
| Technology choices with tradeoffs | proposes | approves material decisions |
| Next playbook | recommends | approves after H-PLAN |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-draft-prd | skill | PRD artifact |
| PRD | artifact | H-PLAN approved on PRD (or documented waiver) |
| TP-architecture | template | OUT-01 structure |
| CL-ARCH | checklist | Handoff blocker |
| STD-ARCH-001 | standard | Layering rules |