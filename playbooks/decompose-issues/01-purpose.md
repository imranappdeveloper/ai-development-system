# PB-decompose-issues — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| name | Decompose Issues |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Translate an **approved PRD** (and **Plan artifacts when available**) into **approved-ready ISS-* issue artifacts** at `{project_root}/work/issues/{issue_id}.md` — then stop.

---

## What Problem Does It Solve?

After PRD approval at H-PLAN, teams still need implementable units with testable acceptance criteria, lane ownership, and traceability. Without a dedicated decompose step:

| Failure | Cost |
|---------|------|
| Implement starts without scoped issues | Undefined build order, missed AC |
| PRD requirements lost in chat | Rework and verification gaps |
| Mixed backend/frontend in one blob | Wrong lane routing, parallelization blocked |
| Sprint order invented by agent | Human planning SSOT violated |
| Issues embedded in PRD | PB-implement-* entry criteria fail |

**This playbook solves the issue-decomposition problem.** It produces durable ISS-* files traceable to PRD FR/NFR and hands off to implement lane children.

It does **not** write PRDs, ARCH, API, DB, UI specs, or implementation code.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved PRD linked in Work Record | Yes |
| `PB-draft-prd` completed or PRD produced by approved path | Yes |
| ISS-* set not yet approved for this `work_id` | Yes |
| Workflow phase is **Decompose** (post H-PLAN) | Yes |
| `workflow_id` ∈ `WF-FEATURE`, `WF-ENHANCEMENT` | Yes |
| Multiple implementable units OR human requests breakdown | Yes |

**Typical triggers:** WF-FEATURE after H-PLAN when backend + frontend (or more lanes) are needed; WF-ENHANCEMENT when change spans multiple components.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved PRD | PB-draft-prd |
| PRD not yet at H-PLAN | Complete Plan phase first |
| Single-issue bugfix | PB-draft-issue → PB-implement |
| ISS-* already H-DECOMPOSE approved | PB-implement-backend / PB-implement-frontend / lane child |
| User wants PRD rewritten | PB-draft-prd (`mode: revise`) |
| User wants handler or UI code | PB-implement-* (post H-DECOMPOSE) |

---

## Single Responsibility

> **Decompose PRD into ISS-* issues — persist issues, update WR, and stop.**

Sub-steps (analyze, lane-assign, CL-DECOMP, handoff) are mandatory parts of decomposition completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-draft-prd | Requirements, user-facing capabilities at product level |
| PB-draft-architecture | Components, data flows, technology boundaries |
| PB-draft-api / PB-draft-database / PB-draft-ui-ux | Plan-phase design artifacts (soft upstream) |
| PB-decompose-issues | ISS-* breakdown, AC, lane tags, scope in/out |
| Human at H-DECOMPOSE | Approve issue set, resolve coverage gaps |
| PB-implement-backend / PB-implement-frontend / lane children | Code per ISS-* |

Decompose may flag **prd_alignment: partial_mismatch** — it must not silently rewrite the PRD.