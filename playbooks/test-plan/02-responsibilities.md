# PB-test-plan — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | CODE (soft) or waiver; H-IMPLEMENT soft when CODE linked |
| P2 | Load CODE + PRD + ISS + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Extract acceptance criteria | AC IDs from PRD, ISS, CODE §2 traceability |
| P4 | Define test strategy layers | §2.1 Approach table with rationale per STD-TEST-002 |
| P5 | Map AC to planned test cases | §3.1 table — every in-scope AC has TC-* |
| P6 | Define regression scope | §4 Regression Scope when CODE lists changed modules |
| P7 | Produce TEST-PLAN (OUT-01) | Complete per 04-io-contract; `test_phase: plan` |
| P8 | Update Work Record | Link TEST-PLAN; `test_plan_pending_review` |
| P9 | Run CL-TEST-PLAN | Validation record = pass |
| P10 | Prepare handoff | `recommended_next_skill: PB-test-generate`; H-VERIFY soft pending |

### test_scope enum

| test_scope | From signal |
|------------|-------------|
| `unit` | Repository / service logic in CODE §4 |
| `integration` | Multi-module flows in CODE |
| `contract` | API handlers with API artifact |
| `e2e` | User journeys from PRD |
| `regression` | Changed modules + adjacent areas |
| `security` | WF-SECURITY or CODE §7 security notes |
| `perf` | WF-PERF or PRD NFR |
| `a11y` | UI scope flagged in WR (soft — plan only) |
| `mixed` | Multiple layers in one run |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference CODE §6 Testing Notes | Avoid duplicate or conflicting planned cases |
| S2 | Flag CODE gaps blocking plan confidence | `test_confidence: low`; `requires_code_revise` |
| S3 | Note environment assumptions | §8 Test Environment — planned config only |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Security / perf / a11y subsections | When workflow or PRD signals apply |
| O2 | Suggest splitting work_id | AC count exceeds session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify CODE | PB-implement-* |
| N3 | Write or modify PRD or ISS | PB-draft-prd / PB-decompose-issues |
| N4 | Generate test source files | PB-test-generate |
| N5 | Execute test commands (`pytest`, `npm test`, etc.) | PB-verify |
| N6 | Populate §9 Execution Evidence with results | PB-verify |
| N7 | Approve H-VERIFY or advance to ship | Human |
| N8 | Auto-invoke next playbook | Human / orchestrator |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Implement application fixes | PB-implement-* |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist TEST-PLAN |
| N13 | Self-approve verification | Human at H-VERIFY |
| N14 | Skip CL-TEST-PLAN or AC mapping | Never |
| N15 | Copy secrets into TEST-PLAN | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| TEST-PLAN draft | proposes | reviews plan; may revise before PB-test-generate |
| Layer selection & AC mapping | proposes | approves strategy adequacy |
| `code_gap: waiver` | documents | authorizes proceed without CODE |
| H-VERIFY (full evidence) | **never** approves | after PB-verify TEST-RPT |
| Next playbook | recommends PB-test-generate | approves chain |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-implement-* | skill (soft) | CODE when implementation complete |
| PRD | artifact (soft) | AC grounding for WF-FEATURE |
| ISS / ISS-* | artifact (soft) | AC grounding per issue |
| CL-TEST-PLAN | checklist | Handoff blocker |
| STD-TEST-001 | standard | Test documentation |
| STD-TEST-002 | standard | Strategy layers & plan structure |
| templates/testing/template.md | template | TEST-PLAN shape |