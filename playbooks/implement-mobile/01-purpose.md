# PB-implement-mobile — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-implement-mobile |
| name | Implement Mobile |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Implement **mobile-native screen code** per approved **ISS / ISS-*** issues and **UIUX** plan — produce a durable **CODE** implementation record with tests documented — then stop.

---

## What Problem Does It Solve?

After decomposition (or single-issue bugfix), teams need traceable mobile implementation tied to UI/UX plan artifacts. Without a dedicated mobile lane:

| Failure | Cost |
|---------|------|
| Screens invented without ISS mapping | Untraceable scope; verify cannot map tests |
| UIUX states skipped (loading, error, empty) | Poor UX; IMP-wrong-lane anti-pattern on web |
| Tests omitted from CODE record | PB-verify blocked; false H-IMPLEMENT confidence |
| App store submit from implement agent | Gate bypass; release incidents |
| Backend or web work mixed into mobile lane | Wrong ownership; lane confusion |

**This playbook solves the mobile implementation problem.** It writes repository code per issues, persists a CODE record at `work/implement/mobile/{work_id}.md`, documents tests, and hands off at H-IMPLEMENT.

It does **not** classify work, draft plans, decompose issues, implement backend/web/devops, submit to app stores, or approve its own gate.

---

## When to Use

| Condition | Required |
|-----------|----------|
| ISS or ISS-* linked in Work Record | Yes |
| `implement_lane: mobile` (native/mobile-primary scope) | Yes |
| UIUX linked or `uiux_gap` waiver documented | Yes (soft required) |
| H-DECOMPOSE approved (WF-FEATURE) or H-PLAN (WF-BUGFIX) | Yes (soft alternative) |
| Workflow phase is **Implement** | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| Mobile code changes needed for mapped issues | Yes |

**Typical triggers:** WF-FEATURE after H-DECOMPOSE with mobile ISS items and UIUX; WF-BUGFIX after PB-draft-issue for mobile defect; PRD/UIUX marked mobile-primary.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No ISS / ISS-* artifacts | PB-decompose-issues or PB-draft-issue |
| Web-only UI scope | PB-implement-frontend |
| Backend API or migration work | PB-implement-backend |
| CI/CD or IaC changes | PB-implement-devops |
| UI/UX design not yet approved | PB-draft-ui-ux |
| User wants app store production release | Human release process after H-VERIFY |
| Orchestrator should invoke umbrella | Resolve to lane child — never `PB-implement` |

---

## Single Responsibility

> **Write mobile screen code per issues — produce CODE record with tests documented — stop.**

Sub-steps (persist, CL-IMPLEMENT-MOBILE, handoff) are mandatory parts of implementation completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-decompose-issues | ISS-* breakdown for WF-FEATURE |
| PB-draft-issue | Single ISS for WF-BUGFIX |
| PB-draft-ui-ux | Screen flows, states, responsive/mobile §7 |
| PB-draft-api | HTTP contract design (data-fetch grounding) |
| PB-implement-mobile | Native screens, navigation, client state, CODE record |
| Human at H-IMPLEMENT | Approve implementation, authorize verify |
| PB-verify | Run test suites, produce TEST-RPT |

Mobile may flag **uiux_alignment: partial_mismatch** — it must not silently override approved UIUX flows.