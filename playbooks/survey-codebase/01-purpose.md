# PB-survey-codebase — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| name | Survey Codebase |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Produce a **bounded, advisory Codebase Survey artifact (SURVEY)** — then stop. No human gate.

---

## What Problem Does It Solve?

After intake, discovery and planning often lack **structural codebase evidence**: module boundaries, dependency graphs, test layout, integration points, and complexity signals. CONTEXT.md may be stale or absent; discovery's T3 budget is marker-only.

Without a dedicated survey:

| Failure | Cost |
|---------|------|
| Discovery on outdated CONTEXT assumptions | Wrong scope and missed dependencies |
| PRD written without repo structure | Rework at Implement |
| Unbounded agent repo reads | Token blowout, security exposure |
| Survey scattered in chat | No durable SSOT for Frame phase |

**This playbook solves the bounded codebase-context problem.** It produces one authoritative SURVEY grounded in cited path evidence within an explicit allowlist.

It does **not** classify work (intake), write PRDs, design architecture, implement, or require human gate approval.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved INT at H-INTAKE, or documented waiver | Yes |
| `project_root` resolvable from INT / WR | Yes |
| Human or orchestrator explicitly invokes optional survey pre-step | Yes |
| Workflow phase is **Frame** (optional pre-discovery) | Yes |

**Typical triggers:** onboarding flagged "deep survey needed"; large brownfield with thin CONTEXT.md; human requests codebase context before PB-discovery-research.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved INT | PB-intake-classify |
| CONTEXT.md sufficient and no code depth needed | PB-discovery-research |
| User wants PRD or architecture now | PB-draft-prd / PB-draft-architecture (after Frame gates) |
| Bugfix with known repro path | PB-draft-issue |
| Full unrestricted audit | Out of scope — bounded survey only |

---

## Single Responsibility

> **Scan the codebase within budget, document structure and signals — produce SURVEY and stop.**

Persistence, CL-SURVEY validation, and advisory handoff are mandatory completion steps, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, `entry_mode` assignment |
| PB-survey-codebase | Bounded repo scan, module map, dependency/pattern signals |
| PB-discovery-research | Problem framing, as-is analysis, recommendations (may consume SURVEY) |
| Human / orchestrator | Decide whether to invoke survey; no H-gate on SURVEY itself |

Survey may flag **intake_classification_alignment: requires_re_intake** — it must not silently override INT classification.