# PB-draft-architecture — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| name | Draft Architecture |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Translate an **approved PRD** into an **approved-ready Architecture artifact (ARCH)** — then stop.

---

## What Problem Does It Solve?

After PRD approval at H-PLAN (or equivalent human gate on PRD), implementation teams still need structural decisions: layers, components, data flows, technology choices, and migration boundaries. Without a dedicated architecture step:

| Failure | Cost |
|---------|------|
| PRD requirements mapped ad hoc to code | Rework during Implement |
| Hidden coupling and boundary violations | STD-ARCH-001 violations in review |
| Refactor scope undefined | Partial migrations, rollback risk |
| Architecture scattered in chat | No durable SSOT for Plan phase |

**This playbook solves the structural-design problem.** It produces one authoritative Architecture document traceable to PRD and grounded in project context.

It does **not** classify work, discover problems, write PRDs, decompose issues, or implement.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved PRD linked in Work Record | Yes |
| `PB-draft-prd` completed or PRD produced by approved path | Yes |
| Architecture not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** (pre- or at H-PLAN) | Yes |
| `workflow_id` ∈ `WF-PROJECT-NEW`, `WF-FEATURE`, `WF-REFACTOR` | Yes |

**Typical triggers:** WF-FEATURE execution sequence after PRD; WF-PROJECT-NEW greenfield path; WF-REFACTOR structural improvement with PRD-lite or full PRD.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved PRD | PB-draft-prd |
| ARCH already H-PLAN approved | PB-decompose-issues or phase-appropriate playbook |
| `work_type: bugfix` with sufficient repro | PB-draft-issue |
| User wants code or issues now | Downstream playbooks after H-PLAN |
| Trivial enhancement with no structural delta | Skip ARCH (workflow optional path) |

---

## Single Responsibility

> **Design system structure from PRD — produce ARCH and stop.**

Sub-steps (persist, CL-ARCH, handoff) are mandatory parts of architecture completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-draft-prd | Requirements, goals, non-goals, user stories |
| PB-draft-architecture | Layers, components, data flows, tech choices, migration strategy |
| Human at H-PLAN | Approve ARCH, resolve open questions sufficient for Decompose/Implement |
| PB-decompose-issues | Issue breakdown after H-PLAN |
| PB-draft-database / PB-draft-api | Detailed specs after ARCH when needed |

Architecture may flag **prd_alignment: partial_mismatch** — it must not silently override PRD scope.