# CL-MAINT — Maintenance Triage Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-MAINT |
| version | 1.0.0 |
| status | active |
| consumer | PB-maintenance-triage |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-OPERATE**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved on linked INT, or documented human waiver; Operate phase; INT path in Work Record |
| 2 | `workflow_id` valid | `WF-MAINTENANCE` or `WF-RELEASE` matches INT |
| 3 | `cycle_type` valid | One of: `scheduled`, `reactive`, `hygiene` |
| 4 | Health snapshot | §2.1 all five signals (errors, performance, dependencies, security, documentation drift) evaluated |
| 5 | Backlog triage | §3.1 ≥1 item with category, priority, and routed `workflow_id` |
| 6 | Required MAINT sections | Cycle Overview, Health Snapshot, Backlog (3.1–3.3), Dependency Hygiene, Debt Review, Follow-Ups, Human Approval |
| 7 | No forbidden content | No deploy/patch/migrate commands; no secrets; no child ORS spawn |
| 8 | Batch depth | §3.2 approved items ≤ 2 (G-WF-MNT-01); excess in §3.3 deferred |
| 9 | Work Record status | `maintenance_pending_review` before handoff; MAINT path in `artifacts[]` |
| 10 | Human approval | `gate_id: H-OPERATE`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing health signals | SNAPSHOT | 3 |
| Backlog incomplete | TRIAGE | 3 |
| Deploy command attempted | DOC | 3 — escalate if repeated |
| Batch depth exceeded | TRIAGE | 3 |
| Missing MAINT persist | PERSIST | 3 |
| Irrecoverable routing gap | Escalate OUT-05 | — |