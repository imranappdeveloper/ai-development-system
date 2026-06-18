# CL-PERF — Performance Baseline Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-PERF |
| version | 1.0.0 |
| status | active |
| consumer | PB-perf-baseline |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved INT linked; `work_type: performance` or `workflow_id: WF-PERF` |
| 2 | Workflow valid | `workflow_id` in INDEX; performance routing consistent with INT |
| 3 | INT traceability | `upstream_int_path` set; Scope cites INT performance signals |
| 4 | Required sections | Summary, Scope, Targets & SLOs, Measurement Plan, Non-Goals, Infrastructure Assumptions, References, Open Questions |
| 5 | No forbidden content | No load-test scripts/results, routing-matrix embed, implementation patches, or secrets |
| 6 | Targets & SLOs | ≥1 row with `target_id`, metric, threshold, and `slo_tier` |
| 7 | Measurement plan | Documents how/when/where to measure — **no execution or result data** |
| 8 | Artifact path | Output at `work/performance/{work_id}.md` per ARTIFACT-REGISTRY |
| 9 | Work Record status | `perf_baseline_pending_review` before handoff; `artifacts[]` lists PERF-BASE path |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (scripts / routing embed) | DOC | 3 |
| Missing INT link | LOAD | 3 |
| Insufficient targets | TARGET | 3 |
| Measurement plan includes execution | MEASURE | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |