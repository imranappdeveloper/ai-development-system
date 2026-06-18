# CL-DOC-UPDATE — Documentation Plan Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-DOC-UPDATE |
| version | 1.0.0 |
| status | draft |
| consumer | PB-draft-doc-update |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved on linked INT; `workflow_id: WF-DOCS`; `work_type: documentation` or documented quality-chain docs path |
| 2 | `doc_plan_type` valid | One of: `full`, `lite`, `changelog`, `api_reference`, `runbook`, `onboarding` |
| 3 | `workflow_id` in INDEX | Matches INT `workflow_id` (`WF-DOCS`) unless human revise notes override |
| 4 | Upstream traceability | `upstream_int_path` set; quality-chain refs or `quality_chain_gap` field populated |
| 5 | Inventory grounded | §4 lists ≥1 doc path with `drift_signal`; goals trace to INT — no unsupported scope invention |
| 6 | Planned updates complete | Required DOC-PLAN sections per TP-doc-plan; §5 ≥1 DU-* row with change type and acceptance signal |
| 7 | Plan only — no doc edits | No modifications to `docs/**`, README, API bodies, or application source — only `work/doc-plan/` and WR |
| 8 | Standards cited | §6 references STD-DOC-001 (and STD-MD-001 where applicable) |
| 9 | Work Record status | `plan_pending_review` before handoff; DOC-PLAN persisted or `persist: pending` documented |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / DU-* row | PLAN | 3 |
| Doc body edit attempted | PLAN | 3 — escalate if repeated |
| Missing upstream link | LOAD | 3 |
| Inventory incomplete | INV | 3 |
| Irrecoverable scope ambiguity | Escalate OUT-05 | — |