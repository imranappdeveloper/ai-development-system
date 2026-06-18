# PB-test-generate — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| name | Test Generator |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Generate executable test source files from an approved **TEST-PLAN** (`test_phase: plan`), document every path in **TEST-GEN** at `work/testing/generate/{work_id}.md`, then stop without executing suites or approving H-VERIFY.

---

## What Problem Does It Solve?

After test planning, teams need traceable test code aligned to TC-* catalog before PB-verify runs suites. Without a dedicated test generator:

| Failure | Cost |
|---------|------|
| Tests invented without plan traceability | Coverage drift; AC gaps at H-VERIFY |
| Execution mixed into generation | Premature pass/fail; polluted TEST-GEN artifact |
| Plan TC-* ignored | PB-verify cannot map evidence to AC |
| Agent runs pytest during generation | STD-TEST-002 violation; plan/generate/evidence conflation |
| Agent self-approves H-VERIFY | Gate bypass; ship without evidence |

**This playbook solves the test generation problem.** It reads TEST-PLAN and CODE (soft), writes test source files per project conventions, produces TEST-GEN at `work/testing/generate/{work_id}.md` with a complete generated-files catalog, and hands off to PB-verify.

It does **not** execute test suites, produce TEST-RPT, approve H-VERIFY, or ship releases.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Workflow phase is **Verify** (generate sub-step) | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| TEST-PLAN at `work/testing/plan/{work_id}.md` linked (soft) | Yes |
| PB-test-plan sequential gate PASS (prerequisite) | Yes |
| CODE artifact linked or `code_gap: waiver` documented (soft) | Yes |
| Human or orchestrator requests test code from approved plan | Yes |

**Typical triggers:** WF-FEATURE after PB-test-plan completes; WF-BUGFIX with narrow reproduction test from plan.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Need test strategy / AC mapping only | PB-test-plan |
| Need suites executed and evidence captured | PB-verify |
| No TEST-PLAN and no waiver | PB-test-plan first |
| User wants TEST-RPT with pass/fail | PB-verify |
| Only documentation updates | PB-draft-doc-update |
| Performance benchmark execution | PB-perf-baseline + PB-verify |

---

## Single Responsibility

> **Generate test source files from TEST-PLAN — document paths in TEST-GEN — stop without execution or H-VERIFY approval.**

Sub-steps (persist, CL-TEST-GEN, handoff to PB-verify) are mandatory parts of generation completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-test-plan | TEST-PLAN strategy, layers, TC-* catalog (`test_phase: plan`) |
| PB-implement-* | CODE artifacts with §6 Testing Notes |
| PB-test-generate | Test code / fixture generation; TEST-GEN catalog (`test_phase: generate`) |
| PB-verify | Execution, TEST-RPT, H-VERIFY evidence |
| PB-review | Code review in parallel after generation |
| Human at H-VERIFY | Approve verification evidence (after PB-verify only) |

Generation mode: **`exit_gate: none`** — this playbook never binds or approves H-VERIFY. Full H-VERIFY applies only after PB-verify produces evidence.