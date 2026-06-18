# PB-diagnose-bug — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-diagnose-bug |
| name | Diagnose Bug |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Analyze an **approved INT** for a bugfix and produce an **approved-ready diagnosis (DIAG)** at `{project_root}/work/diagnose/{work_id}.md` — then stop.

---

## What Problem Does It Solve?

Without structured unclear root cause before issue drafting documentation:

| Failure | Cost |
|---------|------|
| Work lives only in chat | No SSOT for Plan gate or downstream skills |
| Wrong playbook invoked | Rework and blocked implement entry |
| Scope drift from upstream | Verify phase fails; wrong fix shipped |
| Missing testable ACs | PB-implement / PB-verify blocked |

**This playbook solves the unclear root cause before issue drafting problem.** It produces one authoritative DIAG artifact grounded in upstream inputs.

It does **not** classify intake, write PRDs, implement fixes, or approve human gates.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Upstream artifacts per routing-matrix | Yes |
| `DIAG` not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** | Yes |
| WF-BUGFIX when repro is partial, root cause unknown, or human requests diagnosis | Yes |

**Typical triggers:** Orchestrator Plan-phase tick after upstream gate; human requests bug diagnosis.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Sufficient repro in INT for direct issue draft | PB-draft-issue; not bugfix | other playbooks | See routing-matrix |
| Artifact already H-PLAN approved | Downstream implement / verify chain |
| User wants code changes now | PB-implement-* after H-PLAN on ISS |

---

## Single Responsibility

> **Root-cause analysis for bugfix — persist DIAG, update WR, and stop.**

Sub-steps (load, validate, CL check, handoff) are mandatory parts of completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, INT |
| PB-intake-classify | Primary upstream artifact |
| PB-diagnose-bug | DIAG content per 04-io-contract |
| Human at H-PLAN | Approve artifact; resolve open questions |
| PB-implement / lane children | Code per approved ISS |
