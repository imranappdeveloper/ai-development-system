# PB-implement-frontend — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-implement-frontend |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | ISS/ISS-* linked; H-DECOMPOSE or H-PLAN soft satisfied |
| P2 | Load ISS + UIUX (soft) + API (soft) + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Map issues to implementation tasks | §3 Implementation Log lists ISS IDs |
| P4 | Write frontend code per issues | Components, pages, hooks, styles in repository |
| P5 | Document files changed | §4 Files Changed with paths and summaries |
| P6 | Document tests | §6 Testing Notes — unit/component/e2e; never empty |
| P7 | Produce CODE (OUT-01) | Complete per 04-io-contract at lane path |
| P8 | Update Work Record | Link CODE; `implement_frontend_pending_review` |
| P9 | Run CL-IMPLEMENT-FRONTEND | Validation record = pass |
| P10 | Prepare handoff for H-IMPLEMENT | `decision: pending`; recommend PB-verify only |

### implement_scope enum

| implement_scope | From signal |
|-----------------|-------------|
| `components` | ISS tags UI; reusable component changes |
| `pages` | Full screen or route-level implementation |
| `client_logic` | Hooks, stores, API client wiring without new screens |
| `mixed_frontend` | Multiple frontend concern types in one run |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Implement accessibility per STD-A11Y-001 | UIUX or ISS specifies a11y requirements |
| S2 | Flag UIUX gaps blocking implementation | `implement_confidence: low` |
| S3 | Note API client integration assumptions | When UIUX references API operations |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Cross-reference existing component/route markers | Bounded reads per 05-context.md |
| O2 | Suggest splitting work_id | ISS scope exceeds session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD | PB-draft-prd |
| N3 | Write or modify ARCH | PB-draft-architecture |
| N4 | Redesign UIUX screen flows | PB-draft-ui-ux |
| N5 | Implement backend, mobile, or devops code | Lane children |
| N6 | Approve H-IMPLEMENT or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-IMPLEMENT |
| N8 | Deploy to production or publish CDN assets | Human / PB-prepare-release post H-VERIFY |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Decompose or create ISS artifacts | PB-decompose-issues / PB-draft-issue |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist CODE |
| N13 | Self-approve implementation | Human at H-IMPLEMENT |
| N14 | Skip CL-IMPLEMENT-FRONTEND or tests documentation | Never |
| N15 | Copy secrets into CODE record | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Frontend code & CODE draft | proposes | approves / revises / rejects at H-IMPLEMENT |
| UIUX alignment assessment | proposes alignment blocks | decides on upstream revise vs proceed |
| Test adequacy for verify | documents what was run/added | decides sufficient for PB-verify |
| Production deployment | **never** | release process after verify gates |
| Next playbook | recommends PB-verify | approves after H-IMPLEMENT |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-decompose-issues | skill (soft) | ISS-* for WF-FEATURE |
| PB-draft-issue | skill (soft) | ISS for WF-BUGFIX |
| ISS / ISS-* | artifact | H-DECOMPOSE or H-PLAN |
| UIUX | artifact (soft) | Screen/interaction grounding |
| API | artifact (soft) | Client contract grounding when linked |
| CL-IMPLEMENT-FRONTEND | checklist | Handoff blocker |
| STD-A11Y-001 | standard | Accessibility requirements |
| STD-SEC-001 | standard | XSS, auth token handling |
| STD-TEST-001 | standard | Test documentation |