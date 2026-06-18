# PB-draft-issue — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-issue |
| name | Draft Issue |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Translate **approved INT** (and **DIAG when present**) into a **single approved-ready bugfix issue (ISS)** at `{project_root}/work/issue/{work_id}.md` — then stop.

---

## What Problem Does It Solve?

Without structured bugfix without implementable issue spec documentation:

| Failure | Cost |
|---------|------|
| Work lives only in chat | No SSOT for Plan gate or downstream skills |
| Wrong playbook invoked | Rework and blocked implement entry |
| Scope drift from upstream | Verify phase fails; wrong fix shipped |
| Missing testable ACs | PB-implement / PB-verify blocked |

**This playbook solves the bugfix without implementable issue spec problem.** It produces one authoritative ISS artifact grounded in upstream inputs.

It does **not** classify intake, write PRDs, implement fixes, or approve human gates.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Upstream artifacts per routing-matrix | Yes |
| `ISS` not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** | Yes |
| WF-BUGFIX after H-INTAKE; single defect path (not decompose) | Yes |

**Typical triggers:** Orchestrator Plan-phase tick after upstream gate; human requests bugfix issue draft.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| WF-FEATURE multi-issue | PB-decompose-issues; no INT | PB-intake-classify | See routing-matrix |
| Artifact already H-PLAN approved | Downstream implement / verify chain |
| User wants code changes now | PB-implement-* after H-PLAN on ISS |

---

## Single Responsibility

> **Draft single bugfix ISS — persist issue, update WR, and stop.**

Sub-steps (load, validate, CL check, handoff) are mandatory parts of completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, INT |
| PB-intake-classify | Primary upstream artifact |
| PB-draft-issue | ISS content per 04-io-contract |
| Human at H-PLAN | Approve artifact; resolve open questions |
| PB-implement / lane children | Code per approved ISS |
