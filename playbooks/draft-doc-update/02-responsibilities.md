# PB-draft-doc-update — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved INT linked in WR; `work_type: documentation` or documented quality-chain docs path |
| P2 | Load INT + WR + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Set `doc_plan_type` | Valid enum per scope and audience |
| P4 | Trace scope upstream | Goals and doc inventory cite INT; quality-chain refs when linked |
| P5 | Build document inventory | §4 lists paths with drift signals grounded in evidence |
| P6 | Define planned updates | §5 DU-* rows with change type, priority, acceptance signal |
| P7 | Produce DOC-PLAN (OUT-01) | Complete per TP-doc-plan + 04-io-contract |
| P8 | Update Work Record | Link DOC-PLAN; status `plan_pending_review` |
| P9 | Run CL-DOC-UPDATE | Validation record = pass |
| P10 | Prepare handoff for H-PLAN | `decision: pending`; WF-DOCS terminal — no auto-invoke |

### doc_plan_type enum

| doc_plan_type | When |
|---------------|------|
| `full` | Multi-surface doc refresh; new product area; OS + project docs |
| `lite` | Single README or CONTRIBUTING patch; narrow scope |
| `changelog` | Release notes / CHANGELOG alignment |
| `api_reference` | OpenAPI, endpoint tables, SDK docs |
| `runbook` | Operations, incident, deployment guides |
| `onboarding` | CONTEXT.md, getting-started, contributor paths |

### doc_scope enum

| doc_scope | When |
|-----------|------|
| `project_docs` | `{project_root}/docs/**`, README, CONTEXT |
| `os_docs` | `{ai_dev_os_home}/docs/**`, standards, playbooks (rare — human-gated) |
| `api_docs` | API reference surfaces |
| `mixed` | Multiple surfaces in one plan |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Incorporate REVIEW / SEC-REVIEW / PERF-REVIEW findings (soft) | When linked in WR for docs-capture path |
| S2 | Flag stale or missing referenced docs | `drift_signal: red` in §4; human resolves |
| S3 | Map STD-DOC-001 document classes | §6 standards table populated |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Edit `docs/**`, `README.md`, or API doc bodies | Human post-H-PLAN |
| N3 | Write or modify application code | PB-implement-* |
| N4 | Approve H-PLAN or advance workflow | Human |
| N5 | Auto-invoke next playbook | WF-DOCS terminal at H-PLAN |
| N6 | Update CONTEXT.md content | Human / PB-onboard-project |
| N7 | Deep unrestricted codebase survey | Bounded per 05-context.md |
| N8 | Embed routing matrix in outputs | Orchestrator SSOT |
| N9 | Modify OS repository files (except OUT-01 path) | OS maintainer |
| N10 | Store decisions only in chat | Must persist DOC-PLAN |
| N11 | Self-approve DOC-PLAN | Human at H-PLAN |
| N12 | Skip CL-DOC-UPDATE | Never |
| N13 | Copy secrets/PII into DOC-PLAN | Redact `[REDACTED]` |
| N14 | Re-run intake or discovery | PB-intake-classify / PB-discovery-research |
| N15 | Replace PB-prepare-release for release execution | PB-prepare-release when `work_type: release` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| DOC-PLAN content & scope | proposes | approves / revises / rejects at H-PLAN |
| `doc_plan_type` selection | proposes | may override at H-PLAN |
| Open questions resolution | lists | decides sufficient for execution |
| Quality-chain waiver when missing | documents `quality_chain_gap` | may waive when INT-only path |
| Execute planned doc edits | never | human or delegated author after H-PLAN |