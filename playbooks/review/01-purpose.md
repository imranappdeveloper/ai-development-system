# PB-review — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| name | Code Reviewer |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Produce a durable **REVIEW** artifact at `work/review/{work_id}.md` from CODE and upstream requirements — evaluate correctness, scope, security, and standards — then stop without modifying code or approving H-VERIFY.

---

## What Problem Does It Solve?

After implementation, teams need a traceable code review record before verification sign-off. Without a dedicated reviewer playbook:

| Failure | Cost |
|---------|------|
| Review only in chat | No audit trail; H-VERIFY false confidence |
| Agent fixes code during review | Scope blur; implement/review conflation |
| AC not checked against CODE | Requirements drift undetected |
| Standards skipped | Security and logging gaps ship |
| Agent self-approves H-VERIFY | Gate bypass; ship without human decision |

**This playbook solves the structured code review problem.** It reads CODE and upstream artifacts, produces REVIEW per `templates/review/template.md`, and hands off to human at H-VERIFY (soft review sub-artifact).

It does **not** implement fixes, execute tests, produce TEST-RPT, approve H-VERIFY, or ship releases.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Workflow phase is **Verify** | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| CODE artifact linked in WR | Yes |
| H-IMPLEMENT approved when CODE present (soft) | Yes (soft) |
| ISS / PRD for AC grounding (soft) | Recommended |
| Human or orchestrator requests code review before H-VERIFY | Yes |

**Typical triggers:** WF-FEATURE after implement lanes complete; WF-BUGFIX with single ISS; WF-SECURITY requiring security dimension in §3.

**Quality chain position:** After **PB-test-plan** (PASS documented); **PB-test-generate** will gate invoke when authored — plan chain prerequisite is TEST-PLAN approved or `sub_gate: plan` pending with PB-test-plan PASS.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Need test execution or TEST-RPT | PB-verify |
| Need test strategy only | PB-test-plan |
| Need test code generation | PB-test-generate |
| Need to change implementation | PB-implement-* |
| Need security audit playbook | PB-security-review (when active) |
| Need release packaging | PB-prepare-release |
| Docs-only change with waived review | Human WR waiver per STD-REVIEW-001 |

---

## Single Responsibility

> **Review CODE against requirements and standards — document findings in REVIEW — stop without code changes.**

Sub-steps (persist, CL-REVIEW, handoff) are mandatory parts of review completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-implement-* | CODE artifacts with §4 Files Changed |
| PB-draft-prd | PRD acceptance criteria |
| PB-decompose-issues / PB-draft-issue | ISS / ISS-* AC |
| PB-test-plan | TEST-PLAN strategy (`test_phase: plan`) |
| PB-test-generate | Test code from approved plan (future chain gate) |
| PB-verify | Execution, TEST-RPT, H-VERIFY evidence |
| PB-review | REVIEW findings, standards checklist, scope assessment |
| Human at H-VERIFY | Authoritative approve / revise / reject |

Review-only mode: **H-VERIFY is soft** at this sub-artifact — human may review findings inline or defer full H-VERIFY until PB-verify produces TEST-RPT evidence.