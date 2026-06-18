# PB-perf-review — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| name | Performance Reviewer |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Review **implemented CODE** for performance risks and NFR alignment — produce a durable **PERF-REVIEW** at `work/perf-review/{work_id}.md` — compare against **PERF-BASE** when present (soft) — then stop without running benchmarks.

---

## What Problem Does It Solve?

After implementation and verification planning, teams need a structured performance review before ship. Without a dedicated perf reviewer:

| Failure | Cost |
|---------|------|
| N+1 queries and missing indexes ship unnoticed | Production latency incidents |
| Baseline targets ignored when PERF-BASE exists | WF-PERF work fails its intent |
| Load tests run during review | Conflated analysis with evidence; gate bypass |
| Perf findings only in chat | No audit trail for H-VERIFY |
| Generic code review misses hot paths | PB-review scope creep |

**This playbook solves the performance review problem.** It reads CODE (required) and PERF-BASE (soft), performs static performance analysis, persists PERF-REVIEW, and hands off at H-VERIFY with `decision: pending`.

It does **not** run load tests, approve H-VERIFY, implement fixes, or replace PB-perf-baseline planning.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Workflow phase is **Verify** | Yes |
| CODE artifact linked in Work Record | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| H-IMPLEMENT approved when CODE present (soft) | Yes (soft) |
| PERF-BASE linked for WF-PERF or `work_type: performance` (soft) | Recommended |
| Human or orchestrator requests perf review before ship | Yes |

**Typical triggers:** WF-PERF after implement + verify chain; WF-FEATURE with latency NFRs; refactor touching database or API hot paths.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Need performance baseline targets defined | PB-perf-baseline (Plan phase) |
| Need load/benchmark execution and metrics | PB-verify + human tooling |
| No CODE artifact | PB-implement-* first |
| Need general code quality review | PB-review |
| Need security vulnerability assessment | PB-security-assess / PB-security-review |
| User wants production tuning deploy | Human after H-VERIFY |

---

## Single Responsibility

> **Review CODE for performance risks — align to PERF-BASE when present — produce PERF-REVIEW — stop without benchmarks.**

Sub-steps (persist, CL-PERF-REVIEW, handoff) are mandatory parts of review completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-perf-baseline | PERF-BASE targets and measurement plan (Plan) |
| PB-implement-* | CODE artifacts with changed hot paths |
| PB-verify | Test execution, TEST-RPT evidence |
| PB-review | General code review, REVIEW artifact |
| PB-perf-review | Static perf analysis, PERF-REVIEW artifact |
| Human at H-VERIFY | Approve perf review outcome |

Perf review may flag **requires_code_revise** — it must not silently patch application code.