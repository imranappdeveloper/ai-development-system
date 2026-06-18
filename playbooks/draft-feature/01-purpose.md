# PB-draft-feature — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| name | Draft Feature |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Translate **approved DISC** (at H-FRAME) into an **approved-ready narrow feature specification (FEAT)** at `{project_root}/work/feature/{work_id}.md` — then stop.

---

## What Problem Does It Solve?

After discovery frames a **narrow vertical slice**, a full PRD may be unnecessary overhead. Work still needs a durable Plan artifact: scope, user-visible behavior, and testable acceptance criteria — without architecture, code, or issue breakdown.

Without structured FEAT drafting:

| Failure | Cost |
|---------|------|
| Requirements live only in chat | No SSOT for H-PLAN or downstream implement |
| PRD drafted for trivial slices | Planning latency; scope creep |
| Architecture drafted too early | Rework when constraints change |
| Issues invented in Plan phase | H-DECOMPOSE bypassed; wrong ISS-* |

**This playbook solves the narrow-slice planning documentation problem.** It produces one authoritative FEAT grounded in DISC.

It does **not** run discovery, draft PRDs, design architecture, decompose issues, or implement.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Approved DISC linked in WR at H-FRAME | Yes |
| `workflow_id` ∈ `WF-FEATURE`, `WF-ENHANCEMENT` (narrow slice) | Yes |
| FEAT not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** (pre-H-PLAN) | Yes |
| Feature-planner routing selects FEAT over PRD | Yes |

**Typical triggers:** H-FRAME approved DISC recommends narrow slice; `PB-feature-planner` decision matrix DM-01; orchestrator Plan-phase tick when PRD waived.

**Alternative to:** `PB-draft-prd` per `feature-planner` routing — use FEAT when DISC is sufficient and scope is a single implementable slice.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Multi-epic or full product scope | PB-draft-prd |
| No approved DISC / H-FRAME not passed | PB-discovery-research |
| FEAT already H-PLAN approved | PB-decompose-issues or PB-implement |
| `work_type: bugfix` | PB-draft-issue |
| User wants architecture or code now | Downstream playbooks after H-PLAN |

---

## Single Responsibility

> **Synthesize narrow-slice requirements from DISC — produce FEAT and stop.**

Sub-steps (persist, CL-DRAFT, handoff) are mandatory parts of FEAT completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-discovery-research | DISC content, problem framing, evidence |
| PB-feature-planner | Routing identity — FEAT vs PRD vs decompose (umbrella only) |
| PB-draft-feature | Goals, scope, behavior, ACs for one slice |
| Human at H-PLAN | Approve FEAT; resolve open questions sufficient for implement/decompose |
| PB-decompose-issues | ISS-* breakdown after H-PLAN when multiple units needed |
| PB-draft-architecture | Technical design — not in FEAT |

FEAT must trace to DISC — it must not silently invent discovery findings or embed architecture/API/DB detail.