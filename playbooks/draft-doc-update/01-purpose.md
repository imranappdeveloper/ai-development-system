# PB-draft-doc-update — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
| name | Documentation Planner |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Translate approved intake into a durable **documentation update plan (DOC-PLAN)** at `work/doc-plan/{work_id}.md` — inventory targets, scope, rollout, and standards alignment — then stop without editing project documentation bodies.

---

## What Problem Does It Solve?

After H-INTAKE, documentation work needs a structured plan: which files to create or update, for which audiences, under which standards — without premature content authoring or code changes.

Without a dedicated documentation planner:

| Failure | Cost |
|---------|------|
| Doc updates live only in chat | No SSOT for H-PLAN or human execution |
| Agents edit `docs/**` during planning | Unreviewed content drift; gate bypass |
| Quality-chain findings (REVIEW, SEC-REVIEW, PERF-REVIEW) lost | Release notes and runbooks miss blockers |
| Scope drift from INT | Wrong files updated; wasted review cycles |
| Missing rollout sequencing | Partial doc updates confuse users |

**This playbook solves the documentation planning problem.** It produces one authoritative DOC-PLAN grounded in INT and optional quality-chain artifacts.

It does **not** classify intake, implement features, write final documentation content, or approve H-PLAN.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved INT at H-INTAKE | Yes |
| `work_type: documentation` **or** docs-only handoff from quality chain | Yes |
| DOC-PLAN not yet H-PLAN approved for this `work_id` | Yes |
| Workflow phase is **Plan** (pre-H-PLAN) | Yes |
| `workflow_id: WF-DOCS` | Yes (primary path) |

**Typical triggers:** INT routes `documentation` → PB-draft-doc-update; PB-perf-review / PB-security-review recommend docs-only follow-up; orchestrator WF-DOCS Plan-phase tick.

**Soft upstream:** REVIEW, SEC-REVIEW, PERF-REVIEW, CODE — cite when linked in WR for traceability; proceed with INT-only when absent.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved INT | PB-intake-classify |
| DOC-PLAN already H-PLAN approved | Human execution per plan; PB-prepare-release if release-bound |
| `work_type: feature` needing product requirements | PB-draft-prd |
| User wants documentation content written now | Human or future doc-authoring skill after H-PLAN |
| User wants code fixes for doc-related bugs | PB-draft-issue → implement chain |

---

## Single Responsibility

> **Plan documentation updates — inventory targets, scope, rollout — produce DOC-PLAN and stop.**

Sub-steps (persist, CL-DOC-UPDATE, handoff) are mandatory parts of plan completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, `entry_mode` |
| PB-review / PB-security-review / PB-perf-review | Findings artifacts when docs capture quality outcomes (soft) |
| PB-draft-doc-update | Doc inventory, update plan, standards refs, rollout intent |
| Human at H-PLAN | Approve plan, resolve open questions sufficient for execution |
| Human post-H-PLAN | Apply planned edits to `docs/**`, README, API references |

DOC-PLAN may flag **quality_chain_gap: waiver | missing | stale** — it must not silently invent review findings.

---

## Quality-Chain Position

Per `skills/meta-skill/LIFECYCLE.md`, PB-draft-doc-update is authored **after** PB-perf-review in the build order. Runtime entry for WF-DOCS requires **INT only**; quality-chain artifacts are soft inputs when WR links them (e.g. docs-only perf notes from PB-perf-review handoff).