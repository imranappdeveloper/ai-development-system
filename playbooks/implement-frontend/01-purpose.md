# PB-implement-frontend — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-implement-frontend |
| name | Implement Frontend |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Implement **web frontend code** per approved **ISS / ISS-*** issues — produce a durable **CODE** implementation record with tests documented — then stop.

---

## What Problem Does It Solve?

After decomposition (or single-issue bugfix), teams need traceable frontend implementation tied to plan artifacts. Without a dedicated frontend lane:

| Failure | Cost |
|---------|------|
| Components invented without ISS mapping | Untraceable scope; verify cannot map tests |
| UIUX screens skipped or undocumented | UX drift, accessibility regressions |
| Tests omitted from CODE record | PB-verify blocked; false H-IMPLEMENT confidence |
| Production deploy from implement agent | Incidents; gate bypass |
| Backend work mixed into frontend lane | Wrong ownership; IMP-wrong-lane anti-pattern |

**This playbook solves the frontend implementation problem.** It writes repository code per issues, persists a CODE record at `work/implement/frontend/{work_id}.md`, documents tests, and hands off at H-IMPLEMENT.

It does **not** classify work, draft plans, decompose issues, implement backend/mobile/devops, deploy, or approve its own gate.

---

## When to Use

| Condition | Required |
|-----------|----------|
| ISS or ISS-* linked in Work Record | Yes |
| `implement_lane: frontend` (UIUX web scope) | Yes |
| H-DECOMPOSE approved (WF-FEATURE) or H-PLAN (WF-BUGFIX) | Yes (soft alternative) |
| Workflow phase is **Implement** | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| Frontend code changes needed for mapped issues | Yes |

**Typical triggers:** WF-FEATURE after H-DECOMPOSE with UI ISS items; WF-BUGFIX after PB-draft-issue for UI defect; WF-ENHANCEMENT additive screen changes per approved UIUX.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No ISS / ISS-* artifacts | PB-decompose-issues or PB-draft-issue |
| API-only / server scope | PB-implement-backend |
| Native mobile screen implementation | PB-implement-mobile |
| CI/CD or IaC changes | PB-implement-devops |
| UI/UX design not yet approved | PB-draft-ui-ux |
| User wants production deployment | Human release process after H-VERIFY |
| Orchestrator should invoke umbrella | Resolve to lane child — never `PB-implement` |

---

## Single Responsibility

> **Write frontend code per issues — produce CODE record with tests documented — stop.**

Sub-steps (persist, CL-IMPLEMENT-FRONTEND, handoff) are mandatory parts of implementation completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-decompose-issues | ISS-* breakdown for WF-FEATURE |
| PB-draft-issue | Single ISS for WF-BUGFIX |
| PB-draft-ui-ux | Screen flow and interaction design |
| PB-implement-frontend | Component code, pages, client UI, CODE record |
| Human at H-IMPLEMENT | Approve implementation, authorize verify |
| PB-verify | Run test suites, produce TEST-RPT |

Frontend may flag **uiux_alignment: partial_mismatch** — it must not silently override approved UIUX plans.