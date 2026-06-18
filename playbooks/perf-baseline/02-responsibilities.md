# PB-perf-baseline — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Upstream INT linked in WR; H-INTAKE satisfied |
| P2 | Load upstream + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Extract performance scope from INT | `perf_scope` enum set per registry.yaml |
| P4 | Draft targets, SLOs, and measurement plan | Measurable rows with thresholds — no execution |
| P5 | Trace upstream references | INT path in References block |
| P6 | Persist OUT-01 artifact | `work/performance/{work_id}.md` written or `persist: pending` |
| P7 | Update Work Record | Link PERF-BASE; status `perf_baseline_pending_review` |
| P8 | Run CL-PERF | Validation record = pass |
| P9 | Prepare handoff for H-PLAN | `decision: pending` only |
| P10 | Recommend next skill (non-binding) | `PB-implement` or `PB-perf-review` per routing |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference soft upstream (PRD NFR) | When linked in WR |
| S2 | Flag measurement gaps | `measurement_readiness: partial` with blockers |
| S3 | Document open questions for human | In artifact §Open Questions |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Suggest verification tooling categories | Human requests in revise notes — no scripts |
| O2 | Note downstream lane hint | For implement routing only — not SSOT |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify upstream artifact bodies | Upstream producer skills |
| N3 | Write implementation code or optimization patches | PB-implement-* |
| N4 | Approve H-PLAN or advance workflow | Human |
| N5 | Auto-invoke next playbook | Human after gate |
| N6 | Update CONTEXT.md | PB-onboard-project / human |
| N7 | Execute load tests, k6 runs, or profiling | PB-verify / human |
| N8 | Modify OS repository files | OS maintainer |
| N9 | Store decisions only in chat | Must persist PERF-BASE |
| N10 | Self-approve artifact | Human at H-PLAN |
| N11 | Skip CL-PERF | Never |
| N12 | Embed routing matrix in output | Orchestrator SSOT |
| N13 | Run PB-perf-review static analysis | PB-perf-review (Verify) |
| N14 | Invent production metrics without INT grounding | Flag open questions |
| N15 | Copy secrets into artifact | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Draft PERF-BASE | Yes | Revise notes |
| H-PLAN decision | Never | approve / revise / reject |
| Override workflow_id | Never | Via revise on INT/WR |
| Persist artifact | Yes (or pending ack) | Confirms paths on approve |
| Run benchmarks | Never | After implement if needed |

---

## Required Dependencies

| Type | ID | Rule |
|------|-----|------|
| Skill | PB-intake-classify | Upstream producer |
| Artifact | PERF-BASE path | OUT-01 destination |
| Checklist | CL-PERF | Blocks handoff on fail |
| Gate | H-PLAN | Human binding on approve |
| Gate | H-INTAKE | Prerequisite |