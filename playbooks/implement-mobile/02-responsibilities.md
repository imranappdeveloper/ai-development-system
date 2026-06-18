# PB-implement-mobile — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-implement-mobile |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | ISS/ISS-* linked; H-DECOMPOSE or H-PLAN soft satisfied; UIUX soft satisfied |
| P2 | Load ISS + UIUX + API (soft) + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Map issues to implementation tasks | §3 Implementation Log lists ISS IDs |
| P4 | Write mobile code per issues | Screens, navigation, state in repository |
| P5 | Document files changed | §4 Files Changed with paths and summaries |
| P6 | Document tests | §6 Testing Notes — unit/widget/integration/e2e; never empty |
| P7 | Produce CODE (OUT-01) | Complete per 04-io-contract at lane path |
| P8 | Update Work Record | Link CODE; `implement_mobile_pending_review` |
| P9 | Run CL-IMPLEMENT-MOBILE | Validation record = pass |
| P10 | Prepare handoff for H-IMPLEMENT | `decision: pending`; recommend PB-verify only |

### implement_scope enum

| implement_scope | From signal |
|-----------------|-------------|
| `native_screens` | ISS tags UI; UIUX screen flows linked |
| `navigation` | Stack/tab/deep-link changes per UIUX |
| `state_management` | Store/hooks/context changes without new screens |
| `mixed_mobile` | Multiple mobile concern types in one run |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Implement loading, empty, error states per UIUX | UIUX §4 states defined |
| S2 | Flag UIUX/API gaps blocking implementation | `implement_confidence: low` |
| S3 | Note accessibility and platform constraints | UIUX §7 responsive/mobile notes |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Cross-reference existing screen/navigation markers | Bounded reads per 05-context.md |
| O2 | Suggest splitting work_id | ISS scope exceeds session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD | PB-draft-prd |
| N3 | Write or modify ARCH | PB-draft-architecture |
| N4 | Redesign UIUX flows or API contracts | PB-draft-ui-ux / PB-draft-api |
| N5 | Implement backend, web frontend, or devops code | Lane children |
| N6 | Approve H-IMPLEMENT or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-IMPLEMENT |
| N8 | Submit to app stores or apply infra | Human / PB-prepare-release post H-VERIFY |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Decompose or create ISS artifacts | PB-decompose-issues / PB-draft-issue |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist CODE |
| N13 | Self-approve implementation | Human at H-IMPLEMENT |
| N14 | Skip CL-IMPLEMENT-MOBILE or tests documentation | Never |
| N15 | Copy secrets or PII into CODE record | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Mobile code & CODE draft | proposes | approves / revises / rejects at H-IMPLEMENT |
| UIUX/API alignment assessment | proposes alignment blocks | decides on upstream revise vs proceed |
| Test adequacy for verify | documents what was run/added | decides sufficient for PB-verify |
| App store / production release | **never** | release process after verify gates |
| Next playbook | recommends PB-verify | approves after H-IMPLEMENT |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-decompose-issues | skill (soft) | ISS-* for WF-FEATURE |
| PB-draft-issue | skill (soft) | ISS for WF-BUGFIX |
| ISS / ISS-* | artifact | H-DECOMPOSE or H-PLAN |
| UIUX | artifact (soft required) | Screen flow and state grounding |
| API | artifact (soft) | Data-fetch contract when ISS tags API |
| CL-IMPLEMENT-MOBILE | checklist | Handoff blocker |
| STD-SEC-001 | standard | Auth tokens, secure storage |
| STD-TEST-001 | standard | Test documentation |
| STD-OPS-001 | standard | Client logging, correlation IDs |