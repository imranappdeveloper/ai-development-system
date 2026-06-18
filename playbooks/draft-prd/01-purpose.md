# PB-draft-prd — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
| name | Draft PRD |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Translate approved intake (and discovery when present) into an **approved-ready Product Requirements Document (PRD)** — then stop.

---

## What Problem Does It Solve?

After H-INTAKE (and optionally H-FRAME), work items need a durable plan artifact: goals, requirements, acceptance criteria, and rollout intent — without premature architecture or implementation detail.

Without structured PRD drafting:

| Failure | Cost |
|---------|------|
| Requirements live only in chat | No SSOT for Plan gate or downstream specs |
| Architecture drafted too early | Rework when constraints change |
| Scope drift from INT/DISC | Wrong issues decomposed at H-DECOMPOSE |
| Missing testable ACs | Verify phase blocked |

**This playbook solves the product-planning documentation problem.** It produces one authoritative PRD grounded in upstream artifacts.

It does **not** classify intake, run discovery, design architecture, decompose issues, or implement.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved INT at H-INTAKE | Yes |
| `work_type` ∈ `new_project`, `feature`, `enhancement` | Yes |
| PRD not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** (pre-H-PLAN) | Yes |

**Typical triggers:** H-FRAME approved DISC recommends PB-draft-prd; WF-PRD slice after intake; orchestrator Plan-phase tick.

**Soft upstream:** DISC and H-FRAME — proceed with documented waiver when workflow allows (e.g. WF-PRD).

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved INT | PB-intake-classify |
| PRD already H-PLAN approved | PB-draft-architecture or PB-decompose-issues |
| `work_type: bugfix` | PB-draft-issue |
| User wants code or architecture now | Downstream playbooks after H-PLAN |

---

## Single Responsibility

> **Synthesize requirements, define scope and acceptance criteria — produce PRD and stop.**

Sub-steps (persist, CL-PRD, handoff) are mandatory parts of PRD completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, `entry_mode` |
| PB-discovery-research | Problem framing, evidence, recommended direction (DISC) |
| PB-draft-prd | Goals, FR/NFR, ACs, rollout intent, risks |
| Human at H-PLAN | Approve PRD, resolve open questions sufficient for Implement prep |
| PB-draft-architecture | Technical design after H-PLAN |

PRD may flag **discovery_gap: waiver | missing | stale** — it must not silently invent discovery findings.