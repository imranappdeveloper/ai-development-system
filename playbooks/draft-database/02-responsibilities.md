# PB-draft-database — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved ARCH linked in WR; PRD or `prd_gap` waiver |
| P2 | Load ARCH + PRD slice + CONTEXT | T1/T2 bundles per 05-context.md |
| P3 | Set `change_type` | Maps from ARCH scope, workflow, and migration signals |
| P4 | Map domain entities & data requirements | §2.1 entities trace to PRD/ARCH |
| P5 | Model logical schema | ER overview, entities, relationships in §3 |
| P6 | Define physical schema | Tables, indexes, constraints in §4 |
| P7 | Produce DB (OUT-01) | Complete per TP-database + 04-io-contract |
| P8 | Update Work Record | Link DB; status `database_pending_review` |
| P9 | Run CL-DATABASE | Validation record = pass |
| P10 | Prepare handoff for H-PLAN | `decision: pending`; recommend next playbook only |

### change_type enum

| change_type | From signal |
|-------------|-------------|
| `new_schema` | Greenfield tables or additive schema; typical WF-FEATURE |
| `migration` | Alter existing tables; WF-REFACTOR or WF-SECURITY structural change |
| `optimization` | Index, partition, or denormalization; WF-PERF |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Document access patterns & latency targets | Hot read/write paths from ARCH §5 |
| S2 | Flag ARCH gaps blocking schema design | `database_confidence: low` |
| S3 | Note rollback and reversibility | `migration` change_type |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Cross-reference existing schema dumps or ORM models | Project has bounded schema markers |
| O2 | Suggest PB-draft-api | API surface depends on new entities |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD | PB-draft-prd |
| N3 | Write or modify ARCH | PB-draft-architecture |
| N4 | Write executable DDL, migration SQL, or ORM code | PB-implement |
| N5 | Write API endpoint specifications | PB-draft-api |
| N6 | Approve H-PLAN or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-PLAN |
| N8 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Choose implementation tasks or sprint order | PB-decompose-issues |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist DB |
| N13 | Self-approve database design | Human at H-PLAN |
| N14 | Skip CL-DATABASE | Never |
| N15 | Copy secrets/PII sample values into DB | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Schema design & DB draft | proposes | approves / revises / rejects at H-PLAN |
| ARCH/PRD alignment assessment | proposes `arch_alignment` / `prd_alignment` | decides on upstream revise vs proceed |
| Open questions resolution | lists | decides sufficient for Implement |
| Material indexing or partitioning choices | proposes | approves high-impact decisions |
| Next playbook | recommends | approves after H-PLAN |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-draft-architecture | skill (soft) | ARCH artifact |
| ARCH | artifact | H-PLAN approved on ARCH (or documented waiver) |
| PRD | artifact (soft) | Grounding for domain entities when present |
| TP-database | template | OUT-01 structure |
| CL-DATABASE | checklist | Handoff blocker |
| STD-ARCH-005 | standard | Schema SSOT |
| STD-SEC-001 | standard | PII and encryption |
| STD-PERF-001 | standard | Access pattern targets |