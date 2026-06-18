# PB-onboard-project — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| name | Onboard Project |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Assess an **existing project** and produce an **approved-ready Onboarding artifact (ONBOARD)** grounded in **CONTEXT.md** — then stop.

---

## What Problem Does It Solve?

After intake classifies `existing_project`, teams need a durable onboarding record before planning adoption of the AI Development OS: module map, CONTEXT.md accuracy, gap analysis, and OS adoption checklist.

Without structured onboarding:

| Failure | Cost |
|---------|------|
| CONTEXT.md stale or missing | Wrong assumptions in Plan and Implement |
| No module map | Agents wander codebase; token waste |
| OS adoption gaps undocumented | Late rework at H-PLAN |
| Onboarding scattered in chat | No durable SSOT for Frame phase |

**This playbook solves the brownfield onboarding problem.** It produces one authoritative ONBOARD document citing INT and CONTEXT.md evidence.

It does **not** classify work (intake), write PRDs, implement code, or silently rewrite CONTEXT.md.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved INT at H-INTAKE, or documented waiver | Yes |
| `work_type: existing_project` and `workflow_id: WF-PROJECT-EXISTING` | Yes |
| `{project_root}/CONTEXT.md` readable | Yes |
| ONBOARD not yet approved for this `work_id` | Yes |
| Workflow phase is **Frame** (pre-H-FRAME) | Yes |

**Typical triggers:** intake recommends `PB-onboard-project`; brownfield OS adoption; CONTEXT.md refresh before Plan.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved INT | PB-intake-classify |
| CONTEXT.md missing | Human creates CONTEXT.md first; block invoke |
| `work_type: new_project` | PB-discovery-research |
| ONBOARD already H-FRAME approved | PB-draft-prd or phase-appropriate playbook |
| User wants code or PRD now | Downstream playbooks after H-FRAME |

---

## Single Responsibility

> **Assess existing project context, document adoption readiness — produce ONBOARD and stop.**

Sub-steps (persist, CL-ONBOAR, handoff) are mandatory parts of onboarding completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, `entry_mode` assignment |
| PB-onboard-project | CONTEXT assessment, module map, OS adoption checklist, gap analysis |
| Human at H-FRAME | Approve ONBOARD, accept proposed CONTEXT.md updates |
| PB-draft-doc-update | Author CONTEXT.md changes after human approval |

ONBOARD may flag **intake_classification_alignment: requires_re_intake** — it must not silently override INT classification.