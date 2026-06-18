# PB-implement-backend — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-implement-backend |
| name | Implement Backend |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Implement **backend server code** per approved **ISS / ISS-*** issues — produce a durable **CODE** implementation record with tests documented — then stop.

---

## What Problem Does It Solve?

After decomposition (or single-issue bugfix), teams need traceable backend implementation tied to plan artifacts. Without a dedicated backend lane:

| Failure | Cost |
|---------|------|
| Handlers invented without ISS mapping | Untraceable scope; verify cannot map tests |
| Migrations skipped or undocumented | Schema drift, rollback failures |
| Tests omitted from CODE record | PB-verify blocked; false H-IMPLEMENT confidence |
| Production deploy from implement agent | Incidents; gate bypass |
| UI work mixed into backend lane | Wrong ownership; IMP-wrong-lane anti-pattern |

**This playbook solves the backend implementation problem.** It implements repository code per issues using the **`/tdd`** skill (vertical RED→GREEN→refactor per ISS), persists a CODE record at `work/implement/backend/{work_id}.md`, documents tests, and hands off at H-IMPLEMENT.

It does **not** classify work, draft plans, decompose issues, implement frontend/mobile/devops, deploy, or approve its own gate.

---

## When to Use

| Condition | Required |
|-----------|----------|
| ISS or ISS-* linked in Work Record | Yes |
| `implement_lane: backend` (API/DB/server scope) | Yes |
| H-DECOMPOSE approved (WF-FEATURE) or H-PLAN (WF-BUGFIX) | Yes (soft alternative) |
| Workflow phase is **Implement** | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| Backend code changes needed for mapped issues | Yes |

**Typical triggers:** WF-FEATURE after H-DECOMPOSE with API/DB ISS items; WF-BUGFIX after PB-draft-issue; WF-ENHANCEMENT additive server endpoints.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No ISS / ISS-* artifacts | PB-decompose-issues or PB-draft-issue |
| UI-only scope | PB-implement-frontend |
| Mobile screen implementation | PB-implement-mobile |
| CI/CD or IaC changes | PB-implement-devops |
| API contract design not yet approved | PB-draft-api |
| User wants production deployment | Human release process after H-VERIFY |
| Orchestrator should invoke umbrella | Resolve to lane child — never `PB-implement` |

---

## Single Responsibility

> **Write backend code per issues — produce CODE record with tests documented — stop.**

Sub-steps (persist, CL-IMPLEMENT-BACKEND, handoff) are mandatory parts of implementation completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-decompose-issues | ISS-* breakdown for WF-FEATURE |
| PB-draft-issue | Single ISS for WF-BUGFIX |
| PB-draft-api | HTTP contract design |
| PB-draft-database | Schema design |
| PB-implement-backend | Handler code, migrations, server logic, CODE record |
| Human at H-IMPLEMENT | Approve implementation, authorize verify |
| PB-verify | Run test suites, produce TEST-RPT |

Backend may flag **api_alignment: partial_mismatch** — it must not silently override approved API contracts.