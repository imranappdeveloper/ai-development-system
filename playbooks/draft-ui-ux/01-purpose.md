# PB-draft-ui-ux — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
| name | Draft UI/UX |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Translate an **approved PRD** (and **ARCH / DISC when available**) into an **approved-ready UI/UX Plan artifact (UIUX)** — then stop.

---

## What Problem Does It Solve?

After product requirements are approved at H-PLAN, teams still need durable UX decisions: user journeys, screen inventory, interaction states, accessibility targets, and responsive layout notes. Without a dedicated UI/UX step:

| Failure | Cost |
|---------|------|
| Screens invented during Implement | Rework, inconsistent user flows |
| Missing empty/error/loading states | Production defects and support load |
| Accessibility gaps discovered late | STD-A11Y-001 violations and retrofit cost |
| UI scattered in chat or Figma-only | No SSOT for Plan phase handoff |
| Mobile/web divergence | Duplicate Implement cycles |

**This playbook solves the UI/UX planning problem.** It produces one authoritative UIUX document traceable to PRD and grounded in ARCH boundaries and DISC research when present.

It does **not** classify work, write PRDs or ARCH, design APIs or databases, decompose issues, or implement components.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved PRD linked in Work Record | Yes |
| `PB-draft-prd` completed or PRD produced by approved path | Yes |
| UI/UX plan not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** (pre- or at H-PLAN) | Yes |
| `workflow_id` ∈ `WF-FEATURE`, `WF-ENHANCEMENT` | Yes |
| Material user-facing surface change needed | Yes |

**Typical triggers:** WF-FEATURE after PRD when screens or flows are non-trivial; WF-ENHANCEMENT when UX changes accompany additive product scope.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved PRD | PB-draft-prd |
| UIUX already H-PLAN approved | PB-implement-frontend or PB-implement-mobile |
| Trivial copy-only change fully specified in PRD | Skip UIUX (optional path) |
| User wants API contract design | PB-draft-api |
| User wants database schema design | PB-draft-database |
| User wants component code written | PB-implement-frontend (post H-PLAN) |

---

## Single Responsibility

> **Design UI/UX plans from PRD — produce UIUX and stop.**

Sub-steps (persist, CL-UIUX, handoff) are mandatory parts of UI/UX planning completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-draft-prd | Requirements, user-facing capabilities at product level |
| PB-discovery-research | User research, personas, problem validation (DISC) |
| PB-draft-architecture | Components, data flows, technology boundaries |
| PB-draft-ui-ux | Journeys, screens, states, accessibility, responsive notes |
| Human at H-PLAN | Approve UIUX, resolve open questions sufficient for Implement |
| PB-implement-frontend | Web component implementation |
| PB-implement-mobile | Mobile screen implementation |

UIUX may flag **prd_alignment: partial_mismatch** — it must not silently override PRD scope or ARCH boundaries.