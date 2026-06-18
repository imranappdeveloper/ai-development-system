# PB-perf-baseline — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| name | Performance Baseline |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Define **performance targets, SLOs, and a measurement plan** from an **approved INT** and produce an **approved-ready PERF-BASE** at `{project_root}/work/performance/{work_id}.md` — then stop. **No load-test execution.**

---

## What Problem Does It Solve?

Without structured performance planning before implement:

| Failure | Cost |
|---------|------|
| Targets live only in chat | No SSOT for Plan gate or PB-perf-review |
| Implement without measurable goals | Verify phase cannot compare CODE to intent |
| Premature benchmark runs in Plan | Wasted cycles; wrong environment assumptions |
| Missing SLOs | WF-PERF work fails its intent |

**This playbook solves the performance baseline planning problem.** It produces one authoritative PERF-BASE artifact grounded in upstream INT signals — targets, thresholds, measurement methodology, and explicit non-goals.

It does **not** classify intake, run load tests, implement optimizations, or approve human gates.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Upstream INT per routing-matrix | Yes |
| `PERF-BASE` not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** | Yes |
| `work_type: performance` or `workflow_id: WF-PERF` | Yes |

**Typical triggers:** Orchestrator Plan-phase tick after H-INTAKE; human requests performance baseline before implement.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Need benchmark execution or profiling runs | PB-verify (after implement) or human tooling |
| Need static review of implemented CODE | PB-perf-review (Verify phase) |
| Artifact already H-PLAN approved | PB-implement / PB-perf-review chain |
| User wants code changes now | PB-implement-* after H-PLAN on ISS |

---

## Single Responsibility

> **Performance baseline planning — define targets, SLOs, measurement plan — persist PERF-BASE, update WR, and stop.**

Sub-steps (load, validate, CL check, handoff) are mandatory parts of completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, INT |
| PB-perf-baseline | PERF-BASE content per 04-io-contract |
| Human at H-PLAN | Approve artifact; resolve open questions |
| PB-implement / lane children | Code per approved ISS |
| PB-perf-review | Static CODE review vs PERF-BASE (Verify) |