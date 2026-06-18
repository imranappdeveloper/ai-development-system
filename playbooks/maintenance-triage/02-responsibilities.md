# PB-maintenance-triage — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved INT linked in WR; Operate phase |
| P2 | Load INT + soft artifacts | REL when post-release; CONTEXT when present |
| P3 | Set `cycle_type` | From INT signals or human hint |
| P4 | Health snapshot | §2 signals with evidence |
| P5 | Triage backlog | §3 items with priority and routed `workflow_id` |
| P6 | Dependency & security hygiene | §4 table from evidence or stated unknowns |
| P7 | Produce MAINT (OUT-01) | Complete per TP-maintenance + 04-io-contract |
| P8 | Update Work Record | Link MAINT; status `maintenance_pending_review` |
| P9 | Run CL-MAINT | Validation record = pass |
| P10 | Prepare handoff for H-OPERATE | `decision: pending`; child work_ids as proposals only |

### cycle_type enum

| cycle_type | Typical trigger |
|------------|-----------------|
| `scheduled` | Calendar / cron maintenance window |
| `reactive` | Incident, alert, post-release issue |
| `hygiene` | Dependency audit, docs drift, debt review |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` on INT | PB-intake-classify |
| N2 | Execute deploy, patch, or infra commands | Human / CI pipeline |
| N3 | Implement application fixes | PB-implement-* |
| N4 | Approve H-OPERATE or spawn child ORS | Human after H-OPERATE |
| N5 | Auto-invoke child playbooks | Human authorization |
| N6 | Approve H-SHIP or release | PB-prepare-release / human |
| N7 | Write REL artifact | PB-prepare-release |
| N8 | Update CONTEXT.md | PB-draft-doc-update / human |
| N9 | Deep unrestricted security pentest | PB-security-assess |
| N10 | Modify OS repository files | OS maintainer |
| N11 | Store triage only in chat | Must persist MAINT |
| N12 | Self-approve maintenance cycle | Human at H-OPERATE |
| N13 | Skip CL-MAINT | Never |
| N14 | Copy secrets/PII into MAINT | Redact `[REDACTED]` |
| N15 | Fan-out batch depth > 2 | Block per G-WF-MNT-01 |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Health assessment & MAINT draft | proposes | approves / revises / rejects at H-OPERATE |
| Backlog priority & routing | proposes §3 table | approves fan-out |
| Child work_ids | lists in §7 as proposals | spawns after H-OPERATE |
| Deferred items | documents §3.3 | sets revisit dates |