# PB-maintenance-triage — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| name | Maintenance Triage |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Triage maintenance and post-release operate work — produce an **approved-ready Maintenance artifact (MAINT)** — then stop without executing fixes or approving H-OPERATE.

---

## What Problem Does It Solve?

Operate-phase work (`WF-MAINTENANCE`, post-`H-SHIP` `WF-RELEASE`) needs a durable triage record: health snapshot, backlog routing, dependency hygiene, and child work_ids — before humans authorize operate actions.

Without structured maintenance triage:

| Failure | Cost |
|---------|------|
| Ad-hoc ticket lists in chat | No audit trail at H-OPERATE |
| Agent runs patches or deploys | Unauthorized production changes |
| Maintenance items not routed to workflows | Stuck in operate limbo |
| Post-release follow-ups lost | Incidents recur; REL evidence ignored |
| Agent self-approves H-OPERATE | Gate bypass |

**This playbook solves the operate triage problem.** It synthesizes MAINT per `templates/maintenance/template.md` from INT and optional REL/CONTEXT, and hands off to human at **H-OPERATE**.

It does **not** implement fixes, run deploy commands, approve H-OPERATE, or fan out child workflows without human authorization.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved INT at H-INTAKE, or documented waiver | Yes |
| `work_type: maintenance` or post-release operate invoke | Yes |
| `workflow_id` ∈ `WF-MAINTENANCE`, `WF-RELEASE` | Yes |
| Workflow phase is **Operate** | Yes |
| MAINT not yet approved for this `work_id` | Yes |

**Typical triggers:** intake `maintenance`; PB-prepare-release recommends post H-SHIP; scheduled hygiene cycle.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved INT | PB-intake-classify |
| Need release record before ship | PB-prepare-release |
| Need bug fix implementation | PB-diagnose-bug → PB-implement-* |
| Need security remediation code | PB-security-assess → implement chain |
| MAINT already H-OPERATE approved | Spawn child workflows per §7 |

---

## Single Responsibility

> **Assess operate health, triage backlog, route maintenance items — produce MAINT and stop.**

Sub-steps (persist, CL-MAINT, handoff) are mandatory parts of triage completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id` assignment |
| PB-prepare-release | REL artifact before ship |
| PB-maintenance-triage | Health snapshot, backlog triage, child work routing table |
| Human at H-OPERATE | Approve MAINT, authorize child workflow fan-out |
| Child workflows | Execute fixes per routed WF-* |