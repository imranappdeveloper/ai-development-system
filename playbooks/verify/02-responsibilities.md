# PB-verify — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | TEST-PLAN + TEST-GEN linked (soft); PB-test-generate gate PASS; CODE soft or waiver |
| P2 | Load TEST-PLAN + TEST-GEN + CODE + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Resolve execution scope from TEST-PLAN §2.1 + TEST-GEN §3 | Commands and paths identified per layer |
| P4 | Execute test suites | Commands run per CONTEXT conventions; exit codes captured |
| P5 | Map results to TC-* | §3.1/§3.2 actual results and status populated |
| P6 | Populate execution evidence | §9 commands, summary, failure log complete |
| P7 | Produce TEST-RPT (OUT-01) | Complete per 04-io-contract; `test_phase: evidence` |
| P8 | Update Work Record | Link TEST-RPT; `verify_pending_review` |
| P9 | Run CL-VERIFY | Validation record = pass |
| P10 | Prepare handoff | `recommended_next_skill: PB-review` or PB-prepare-release; H-VERIFY `decision: pending` |

### execution_result enum

| execution_result | Meaning |
|------------------|---------|
| `pass` | All required suites passed |
| `fail` | One or more required suites failed |
| `partial` | Some layers executed; others blocked (env, deferred) |
| `blocked` | Could not run any required suite — documented blocker |
| `skipped` | Human/orchestrator waived execution with documented reason |

### tc_status enum (per test case)

| tc_status | Meaning |
|-----------|---------|
| `pass` | TC-* assertion satisfied |
| `fail` | TC-* assertion failed |
| `blocked` | Could not run — env or dependency missing |
| `skipped` | Waived per plan deferral or human instruction |
| `not_run` | In scope but not executed this session |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference TEST-GEN §3 catalog | Run files that were generated or updated |
| S2 | Flag failures requiring code revise | `code_alignment: requires_code_revise` in handoff |
| S3 | Capture coverage when tooling available | §9.2 informational only — not gate criterion |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Run regression suites from TEST-PLAN §4 | When CODE §4 lists changed modules |
| O2 | Re-run failed TC-* after human fix hint | `mode: resume` with narrowed scope |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify CODE (implementation) | PB-implement-* |
| N3 | Rewrite TEST-PLAN strategy or AC mapping | PB-test-plan |
| N4 | Generate or modify test source files | PB-test-generate |
| N5 | Approve H-VERIFY or advance to ship | Human only |
| N6 | Auto-invoke next playbook | Human / orchestrator |
| N7 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N8 | Implement application fixes | PB-implement-* |
| N9 | Modify OS repository files | OS maintainer |
| N10 | Store decisions only in chat | Must persist TEST-RPT |
| N11 | Self-approve verification | Human at H-VERIFY |
| N12 | Skip CL-VERIFY or execution when in scope | Never without documented waiver |
| N13 | Copy secrets into TEST-RPT | Redact `[REDACTED]` |
| N14 | Claim pass without running commands | Never |
| N15 | Fabricate exit codes or timestamps | Record actual command output |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| TEST-RPT draft | proposes | reviews evidence adequacy |
| Suite execution | runs commands | may waive layers with documented reason |
| `plan_gap: waiver` / `gen_gap: waiver` | documents | authorizes proceed without upstream |
| H-VERIFY approve | **never** | after reviewing TEST-RPT only |
| Next playbook | recommends PB-review / PB-prepare-release | approves chain |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-test-generate | skill (soft) | TEST-GEN when generation complete |
| PB-test-plan | artifact (soft) | TEST-PLAN for TC-* catalog |
| CODE | artifact (soft) | Grounding when implementation present |
| CL-VERIFY | checklist | Handoff blocker |
| STD-TEST-001 | standard | Test documentation |
| STD-TEST-002 | standard | Strategy layers & evidence structure |
| templates/testing/template.md | template | TEST-RPT shape |