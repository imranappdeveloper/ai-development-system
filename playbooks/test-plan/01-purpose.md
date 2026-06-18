# PB-test-plan — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
| name | Test Planner |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Design a durable **TEST-PLAN** (`test_phase: plan`) from CODE, PRD, and ISS artifacts — map acceptance criteria to planned test cases — then stop without executing tests.

---

## What Problem Does It Solve?

After implementation, teams need a traceable verification strategy before test generation or execution. Without a dedicated test planner:

| Failure | Cost |
|---------|------|
| Tests invented without AC mapping | Untraceable coverage; H-VERIFY false confidence |
| Execution mixed into planning | Premature pass/fail; polluted plan artifact |
| CODE changes ignored in strategy | Wrong layers selected; PB-test-generate blocked |
| PRD/ISS AC omitted | Requirements drift; verify cannot sign off |
| Agent runs pytest during plan | STD-TEST-002 violation; plan/evidence conflation |

**This playbook solves the test planning problem.** It reads upstream artifacts, produces TEST-PLAN at `work/testing/plan/{work_id}.md` per `templates/testing/template.md` with `test_phase: plan`, and hands off to PB-test-generate.

It does **not** generate test code, execute suites, produce TEST-RPT, approve H-VERIFY, or ship releases.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Workflow phase is **Verify** (plan sub-step) | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| CODE artifact linked or `code_gap: waiver` documented (soft) | Yes |
| H-IMPLEMENT approved (soft) when CODE present | Yes (soft) |
| PRD and/or ISS / ISS-* for AC grounding (soft) | Recommended |
| Human or orchestrator requests test strategy before generation | Yes |

**Typical triggers:** WF-FEATURE after implement lanes complete; WF-BUGFIX with single ISS; WF-SECURITY requiring security layer in strategy.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Need test code / fixtures written | PB-test-generate |
| Need suites executed and evidence captured | PB-verify |
| No upstream artifacts and no waiver | PB-implement-* first |
| User wants TEST-RPT with pass/fail | PB-verify |
| Only documentation updates | PB-draft-doc-update |
| Performance benchmark execution | PB-perf-baseline + PB-verify |

---

## Single Responsibility

> **Design TEST-PLAN from upstream artifacts — map AC to planned cases — stop without execution.**

Sub-steps (persist, CL-TEST-PLAN, handoff to PB-test-generate) are mandatory parts of plan completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-implement-* | CODE artifacts with §6 Testing Notes |
| PB-draft-prd | PRD acceptance criteria |
| PB-decompose-issues / PB-draft-issue | ISS / ISS-* AC |
| PB-test-plan | TEST-PLAN strategy, layers, case catalog (`test_phase: plan`) |
| PB-test-generate | Test code / fixture generation from approved plan |
| PB-verify | Execution, TEST-RPT, H-VERIFY evidence |
| Human at H-VERIFY | Approve verification evidence (after execution chain) |

Plan-only mode: **H-VERIFY is soft** at this sub-artifact — human may review plan inline or defer full H-VERIFY until PB-verify produces evidence.