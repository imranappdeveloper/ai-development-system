# PB-discovery-research — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| name | Discovery Research |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Research the problem space and produce an **approved-ready Discovery artifact (DISC)** — then stop.

---

## What Problem Does It Solve?

After intake classification, many work items lack enough evidence to plan safely: greenfield ideas, ambiguous features, onboarding unknowns, or intake marked `classification_confidence: low`.

Without structured discovery:

| Failure | Cost |
|---------|------|
| PRD written on assumptions | Rework in Plan and Implement |
| Wrong scope inherited from intake | Feature vs enhancement drift |
| Missing stakeholder or system context | Late surprises at H-PLAN |
| Research scattered in chat | No durable SSOT for Frame phase |

**This playbook solves the research-and-framing problem.** It produces one authoritative Discovery document grounded in cited evidence.

It does **not** classify work (intake), write PRDs, design architecture, or implement.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved INT at H-INTAKE, or documented waiver | Yes |
| `work_type` ∈ `new_project`, `existing_project`, `feature`, `enhancement` | Yes |
| Discovery not yet approved for this `work_id` | Yes |
| Workflow phase is **Frame** (pre-H-FRAME) | Yes |

**Typical triggers:** intake recommends `PB-discovery-research`; `new_project` / `feature` paths; low-confidence intake with human approval to discover first.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved INT | PB-intake-classify |
| DISC already H-FRAME approved | PB-draft-prd or phase-appropriate playbook |
| `work_type: bugfix` with sufficient repro | PB-draft-issue |
| User wants code or PRD now | Downstream playbooks after H-FRAME |

---

## Single Responsibility

> **Research, document findings, recommend direction — produce DISC and stop.**

Sub-steps (persist, CL-DISCOVERY, handoff) are mandatory parts of discovery completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, `entry_mode` assignment |
| PB-discovery-research | Evidence, as-is analysis, alternatives, recommended direction |
| Human at H-FRAME | Approve DISC, resolve open questions sufficient for Plan |
| PB-draft-prd | PRD content after H-FRAME |

Discovery may flag **intake_classification_alignment: requires_re_intake** — it must not silently override INT classification.