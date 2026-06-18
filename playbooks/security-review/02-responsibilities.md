# PB-security-review — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | CODE linked; H-IMPLEMENT satisfied; Verify phase |
| P2 | Load CODE + SEC-ASSESS (soft) + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Map CODE §4 files to review tasks | §3 Review Scope lists paths and dimensions |
| P4 | Review code for security defects | Auth, validation, exposure, crypto, deps per STD-SEC-001 |
| P5 | Document findings with severity | §4 Findings — P0/P1/P2 with file refs |
| P6 | Assess SEC-ASSESS alignment | `assess_alignment` block when SEC-ASSESS linked |
| P7 | Produce SEC-REVIEW (OUT-01) | Complete per 04-io-contract at review path |
| P8 | Update Work Record | Link SEC-REVIEW; `security_review_pending` |
| P9 | Run CL-SECURITY-REVIEW | Validation record = pass |
| P10 | Prepare handoff for H-VERIFY | `decision: pending`; recommend PB-prepare-release |

### security_review_scope enum

| security_review_scope | From signal |
|-----------------------|-------------|
| `auth` | CODE §7 or ISS tags auth/session |
| `input_validation` | Handlers, forms, API inputs |
| `data_exposure` | PII, logging, error messages |
| `crypto` | Hashing, encryption, token handling |
| `dependencies` | Lockfile or dep changes in CODE §4 |
| `api_surface` | New/changed endpoints |
| `mixed_security` | Multiple dimensions in one run |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference SEC-ASSESS controls | SEC-ASSESS linked (soft) |
| S2 | Flag CODE gaps blocking review | `security_review_confidence: low` |
| S3 | Note regression test expectations | When P0/P1 findings need PB-verify re-run |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Cross-reference TEST-RPT when PB-verify completed | TEST-RPT linked in WR |
| O2 | Suggest splitting work_id | CODE scope exceeds session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Produce SEC-ASSESS or Plan-phase threat model | PB-security-assess |
| N3 | Write or modify PRD, ARCH, API, or DB design | Plan playbooks |
| N4 | Implement or patch repository code | PB-implement lane children |
| N5 | Run full penetration test or DAST scan | Human / external tooling |
| N6 | Approve H-VERIFY or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-VERIFY |
| N8 | Deploy to production or apply infra | Human / PB-prepare-release |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | General style/naming review without security angle | PB-review |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist SEC-REVIEW |
| N13 | Self-approve verify gate | Human at H-VERIFY |
| N14 | Skip CL-SECURITY-REVIEW or findings documentation | Never |
| N15 | Copy secrets into SEC-REVIEW record | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Security findings & SEC-REVIEW draft | proposes | approves / revises / rejects at H-VERIFY |
| SEC-ASSESS alignment assessment | proposes alignment blocks | decides on upstream assess vs proceed |
| Accept P0 findings blocking ship | documents | decides waive vs implement revise |
| Production deployment | **never** | release process after verify gates |
| Next playbook | recommends PB-prepare-release | approves after H-VERIFY |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-implement | skill (soft) | CODE production |
| PB-verify | skill (soft) | TEST-RPT when tests inform review |
| CODE | artifact | H-IMPLEMENT |
| SEC-ASSESS | artifact (soft) | Plan-phase control grounding |
| CL-SECURITY-REVIEW | checklist | Handoff blocker |
| STD-SEC-001 | standard | Secrets, validation, exposure |
| STD-REVIEW-001 | standard | Finding severity, review record |
| STD-LOG-001 | standard | Logging of sensitive data |