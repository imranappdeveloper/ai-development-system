# PB-verify — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
| name | Test Executor / Verify |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Execute test suites per **TEST-PLAN** and **TEST-GEN**, capture pass/fail evidence in **TEST-RPT** (`test_phase: evidence`) at `work/testing/{work_id}.md` per `templates/testing/template.md`, then stop without approving H-VERIFY.

---

## What Problem Does It Solve?

After test planning and generation, teams need authoritative execution evidence before a human can approve H-VERIFY. Without a dedicated test executor:

| Failure | Cost |
|---------|------|
| Evidence invented without command runs | False confidence; H-VERIFY approve on fiction |
| Plan/generation skipped before execution | Untraceable coverage; AC gaps at ship |
| Agent self-approves H-VERIFY | Gate bypass; release without human sign-off |
| Execution mixed into planning/generation | STD-TEST-002 violation; artifact conflation |
| Failures undocumented | PB-implement-* cannot revise; PB-review lacks context |

**This playbook solves the test execution problem.** It reads TEST-PLAN, TEST-GEN, and CODE (soft), runs suites per project conventions, produces TEST-RPT at `work/testing/{work_id}.md` with populated §9 Execution Evidence, and hands off evidence for human H-VERIFY decision.

It does **not** approve H-VERIFY, ship releases, generate test code, or rewrite TEST-PLAN strategy.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Workflow phase is **Verify** (execution sub-step) | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| TEST-PLAN at `work/testing/plan/{work_id}.md` linked (soft) | Yes |
| TEST-GEN at `work/testing/generate/{work_id}.md` linked (soft) | Yes |
| PB-test-generate sequential gate PASS (prerequisite) | Yes |
| CODE artifact linked or `code_gap: waiver` documented (soft) | Recommended |
| Human or orchestrator requests suite execution and evidence | Yes |

**Typical triggers:** WF-FEATURE after PB-test-generate completes; WF-BUGFIX reproduction run; WF-TESTING dedicated verification workflow.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Need test strategy / AC mapping only | PB-test-plan |
| Need test source files written | PB-test-generate |
| No TEST-PLAN / TEST-GEN and no waiver | PB-test-plan / PB-test-generate first |
| User wants gate approved without human | Human at H-VERIFY |
| Only documentation updates | PB-draft-doc-update |
| Code review without execution | PB-review |
| Performance baseline capture (first run) | PB-perf-baseline |

---

## Single Responsibility

> **Execute test suites — map results to TC-* — produce TEST-RPT evidence — stop without H-VERIFY approval.**

Sub-steps (persist, CL-VERIFY, handoff to PB-review / PB-prepare-release) are mandatory parts of execution completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-test-plan | TEST-PLAN strategy, layers, TC-* catalog (`test_phase: plan`) |
| PB-test-generate | Test code / fixture generation; TEST-GEN catalog (`test_phase: generate`) |
| PB-implement-* | CODE artifacts with §6 Testing Notes |
| PB-verify | Suite execution, TEST-RPT evidence (`test_phase: evidence`) |
| PB-review | Code review (parallel or after evidence) |
| Human at H-VERIFY | Approve verification evidence (after TEST-RPT only) |

Evidence mode: **`exit_gate: H-VERIFY`** — this playbook documents evidence and sets `decision: pending`. Full H-VERIFY approve is **human-only** after reviewing TEST-RPT.