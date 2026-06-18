# PB-implement-devops — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
| name | Implement DevOps |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Implement **CI/CD, infra-as-code, and deploy pipeline changes** per approved **ISS / ISS-*** issues — produce a durable **CODE** implementation record with pipeline validation documented — then stop.

---

## What Problem Does It Solve?

After decomposition, teams need traceable DevOps implementation tied to architecture and release context. Without a dedicated DevOps lane:

| Failure | Cost |
|---------|------|
| Pipelines invented without ISS mapping | Untraceable scope; verify cannot map checks |
| IaC changes without plan-only evidence | Blind prod applies; rollback failures |
| Validation omitted from CODE record | PB-verify blocked; false H-IMPLEMENT confidence |
| Production deploy from implement agent | Incidents; gate bypass |
| Application code mixed into DevOps lane | Wrong ownership; IMP-wrong-lane anti-pattern |

**This playbook solves the DevOps implementation problem.** It writes repository pipeline and IaC code per issues, persists a CODE record at `work/implement/devops/{work_id}.md`, documents pipeline validation, and hands off at H-IMPLEMENT.

It does **not** classify work, draft plans, decompose issues, implement backend/frontend/mobile, ship to production, or approve its own gate.

---

## When to Use

| Condition | Required |
|-----------|----------|
| ISS or ISS-* linked in Work Record | Yes |
| `implement_lane: devops` (CI/CD, IaC, deploy-pipeline scope) | Yes |
| H-DECOMPOSE approved (WF-FEATURE) or H-PLAN (WF-BUGFIX) | Yes (soft alternative) |
| Workflow phase is **Implement** | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| DevOps code changes needed for mapped issues | Yes |

**Typical triggers:** WF-FEATURE after H-DECOMPOSE with infra-tagged ISS items; WF-BUGFIX after PB-draft-issue for pipeline fix; WF-RELEASE prep for release automation (no prod ship).

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No ISS / ISS-* artifacts | PB-decompose-issues or PB-draft-issue |
| Backend handler implementation | PB-implement-backend |
| UI component implementation | PB-implement-frontend |
| Mobile screen implementation | PB-implement-mobile |
| Architecture design not yet approved | PB-draft-architecture |
| User wants production deployment | Human release process after H-VERIFY / H-SHIP |
| Final release record authoring | PB-prepare-release |
| Orchestrator should invoke umbrella | Resolve to lane child — never `PB-implement` |

---

## Single Responsibility

> **Write DevOps code per issues — produce CODE record with pipeline validation documented — stop.**

Sub-steps (persist, CL-IMPLEMENT-DEVOPS, handoff) are mandatory parts of implementation completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-decompose-issues | ISS-* breakdown for WF-FEATURE |
| PB-draft-issue | Single ISS for WF-BUGFIX |
| PB-draft-architecture | System topology and deployment boundaries |
| PB-implement-devops | CI workflows, IaC modules, deploy pipelines, CODE record |
| PB-prepare-release | REL artifact and H-SHIP release record |
| Human at H-IMPLEMENT | Approve implementation, authorize verify |
| PB-verify | Run test suites and pipeline checks, produce TEST-RPT |

DevOps may flag **arch_alignment: partial_mismatch** — it must not silently override approved ARCH boundaries.