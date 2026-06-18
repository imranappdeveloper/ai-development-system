# PB-decompose-issues — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved PRD linked in WR; H-PLAN satisfied |
| P2 | Load PRD + Plan artifacts slice + CONTEXT | T1/T2 bundles per 05-context.md |
| P3 | Set `decompose_scope` | Maps from PRD surface, lanes needed, workflow |
| P4 | Map PRD FR/NFR to issue units | Each in-scope requirement traces to ≥1 ISS-* AC |
| P5 | Assign lanes and issue IDs | `ISS-{LANE}-{SEQ}` per registry `lane` enum |
| P6 | Write ISS-* artifacts (OUT-01) | Summary, AC, scope, tags, references per 04-io-contract |
| P7 | Produce decomposition manifest (OUT-01b) | Issue index with coverage map |
| P8 | Update Work Record | Link all ISS-*; status `decompose_pending_review` |
| P9 | Run CL-DECOMP | Validation record = pass |
| P10 | Prepare handoff for H-DECOMPOSE | `decision: pending`; recommend implement lane only |

### decompose_scope enum

| decompose_scope | From signal |
|-----------------|-------------|
| `single_lane` | One lane (e.g. backend-only enhancement) |
| `multi_lane` | Two or more lanes (typical WF-FEATURE) |
| `full_stack` | Backend + frontend + mobile and/or devops explicitly in scope |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference ARCH/API/DB/UIUX for lane hints | Plan artifacts linked in WR |
| S2 | Flag PRD gaps blocking decomposition | `decompose_confidence: low` |
| S3 | Document `decompose_gap` for deferred PRD items | Explicit human waiver at H-DECOMPOSE |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Suggest dependency order between ISS-* (non-binding) | Human requests sequencing notes in manifest |
| O2 | Recommend primary implement lane child | Based on first critical path issue |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD body | PB-draft-prd |
| N3 | Write or modify ARCH | PB-draft-architecture |
| N4 | Write or modify API / DB / UIUX specs | PB-draft-api / PB-draft-database / PB-draft-ui-ux |
| N5 | Write handler, UI, mobile, or IaC code | PB-implement-* |
| N6 | Approve H-DECOMPOSE or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-DECOMPOSE |
| N8 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Set sprint order or team assignments as SSOT | Human / project management |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist ISS-* |
| N13 | Self-approve issue set | Human at H-DECOMPOSE |
| N14 | Skip CL-DECOMP | Never |
| N15 | Embed routing matrix or orchestrator rules in issue output | Orchestrator SSOT |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Issue breakdown & ISS-* drafts | proposes | approves / revises / rejects at H-DECOMPOSE |
| PRD/Plan alignment assessment | proposes alignment blocks | decides on upstream revise vs proceed |
| Coverage gaps & deferred scope | lists `decompose_gap` | accepts or sends back to PRD |
| Lane split decisions | proposes | approves boundary changes |
| Next implement lane | recommends | approves after H-DECOMPOSE |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-draft-prd | skill (soft) | PRD artifact |
| PRD | artifact | H-PLAN approved on PRD |
| ARCH / API / DB / UIUX | artifact (soft) | Lane and AC grounding when present |
| CL-DECOMP | checklist | Handoff blocker |
| STD-DOC-001 | standard | Document structure |
| STD-NAMING-001 | standard | ISS-* ID pattern |