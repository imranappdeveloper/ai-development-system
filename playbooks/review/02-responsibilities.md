# PB-review — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | CODE linked; H-IMPLEMENT soft satisfied; quality-chain prerequisite noted |
| P2 | Load CODE + ISS + PRD + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Map ISS/PRD AC to CODE §2 traceability | §4 Acceptance Criteria Review populated |
| P4 | Evaluate standards checklist | §3 Standards Checklist per STD-REVIEW-001 dimensions |
| P5 | Document findings with severity | §5 Blockers / Should-Fix / Nits with locations |
| P6 | Assess scope and risk | §6 Scope & Risk Assessment complete |
| P7 | Produce REVIEW (OUT-01) | Complete per 04-io-contract at review path |
| P8 | Update Work Record | Link REVIEW; `review_pending` status |
| P9 | Run CL-REVIEW | Validation record = pass |
| P10 | Prepare handoff for H-VERIFY | `decision: pending`; recommend PB-prepare-release or PB-implement-* on blockers |

### review_type enum

| review_type | From signal |
|-------------|-------------|
| `code` | Default — CODE artifact present |
| `design` | ARCH-linked scope review (no code paths) |
| `security` | WF-SECURITY or SEC-ASSESS linked |
| `doc` | WF-DOCS with CODE doc paths only |
| `release_readiness` | Pre-ship checklist when TEST-RPT linked (soft) |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference TEST-PLAN / TEST-RPT when linked | Verify phase chain context |
| S2 | Flag drive-by changes in CODE §4 | §6 `drive-by changes: yes` |
| S3 | Note rollback feasibility | Migrations or breaking API changes |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Bounded reads of changed source files | CODE §4 paths only — no full-repo audit |
| O2 | Suggest splitting review scope | Multiple lanes exceed session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Modify source code or apply fixes | PB-implement-* |
| N2 | Execute test suites | PB-verify |
| N3 | Generate test code | PB-test-generate |
| N4 | Approve H-VERIFY or H-IMPLEMENT | Human |
| N5 | Auto-invoke next playbook | Human after gate |
| N6 | Write or modify PRD, ISS, API, DB | Respective draft playbooks |
| N7 | Produce TEST-RPT or TEST-PLAN | PB-verify / PB-test-plan |
| N8 | Deploy or release | PB-prepare-release post H-VERIFY |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Assign or change `workflow_id` | PB-intake-classify |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store findings only in chat | Must persist REVIEW |
| N13 | Self-approve review or H-VERIFY | Human gate |
| N14 | Skip CL-REVIEW or standards §3 | Never |
| N15 | Copy secrets into REVIEW | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Findings draft & REVIEW artifact | proposes | approves / revises / rejects at H-VERIFY |
| Severity classification (P0/P1/P2) | proposes | confirms; P0 blocks approve |
| Standards pass/fail per row | proposes | may override with waiver |
| Implement fixes for findings | **never** | routes to PB-implement-* |
| Next playbook | recommends PB-prepare-release or implement revise | decides after H-VERIFY |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| CODE | artifact | Required — any implement lane path |
| ISS / ISS-* | artifact (soft) | AC grounding |
| PRD | artifact (soft) | AC grounding |
| H-IMPLEMENT | gate (soft) | When CODE present |
| PB-test-plan | skill (soft) | Quality chain — TEST-PLAN PASS or documented waiver |
| PB-test-generate | skill (future) | Will gate invoke when authored |
| CL-REVIEW | checklist | Handoff blocker |
| STD-REVIEW-001 | standard | Normative review dimensions |