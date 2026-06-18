# PB-bootstrap-project — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-bootstrap-project |
| name | Bootstrap Project |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Translate an **approved PRD** (and **ARCH when present**) into an **approved-ready project scaffold plan (SCAFFOLD)** at `{project_root}/work/scaffold/{work_id}.md` — then stop.

---

## What Problem Does It Solve?

Without structured greenfield repo structure documentation:

| Failure | Cost |
|---------|------|
| Work lives only in chat | No SSOT for Plan gate or downstream skills |
| Wrong playbook invoked | Rework and blocked implement entry |
| Scope drift from upstream | Verify phase fails; wrong fix shipped |
| Missing testable ACs | PB-implement / PB-verify blocked |

**This playbook solves the greenfield repo structure problem.** It produces one authoritative SCAFFOLD artifact grounded in upstream inputs.

It does **not** classify intake, write PRDs, implement fixes, or approve human gates.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Upstream artifacts per routing-matrix | Yes |
| `SCAFFOLD` not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** | Yes |
| WF-PROJECT-NEW after H-PLAN on PRD; human wants scaffold plan before implement | Yes |

**Typical triggers:** Orchestrator Plan-phase tick after upstream gate; human requests project bootstrap.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Existing repo with CONTEXT | PB-onboard-project; no PRD | PB-draft-prd | See routing-matrix |
| Artifact already H-PLAN approved | Downstream implement / verify chain |
| User wants code changes now | PB-implement-* after H-PLAN on ISS |

---

## Single Responsibility

> **Plan repository scaffold from PRD — persist SCAFFOLD, update WR, and stop.**

Sub-steps (load, validate, CL check, handoff) are mandatory parts of completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, INT |
| PB-draft-prd | Primary upstream artifact |
| PB-bootstrap-project | SCAFFOLD content per 04-io-contract |
| Human at H-PLAN | Approve artifact; resolve open questions |
| PB-implement / lane children | Code per approved ISS |
