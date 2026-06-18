# CL-IMPLEMENT-DEVOPS — DevOps Implementation Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-IMPLEMENT-DEVOPS |
| version | 1.0.0 |
| status | draft |
| consumer | PB-implement-devops |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-IMPLEMENT**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | ISS or ISS-* linked in WR; H-DECOMPOSE or H-PLAN soft gate satisfied; `implement_lane: devops` |
| 2 | Issue traceability | Every pipeline/IaC change maps to ≥1 ISS/ISS-* ID in CODE §3 Implementation Log |
| 3 | Plan artifact grounding | ARCH and/or REL paths linked when present; `arch_gap` / `rel_gap` waiver documented if absent |
| 4 | CODE record persisted | `{project_root}/work/implement/devops/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | TDD + validation documented | Testable changes via `/tdd` vertical slices where applicable; §6 Validation Notes lists lint/plan/dry-run with commands/results — never empty |
| 6 | No production deploy | No production deploy, prod IaC apply, release tag push, or prod CD trigger in output or CODE record |
| 7 | Repository changes cited | §4 Files Changed lists paths with change summary; no orphan edits |
| 8 | WR updated | CODE artifact linked; `status: implement_devops_pending_review` |
| 9 | Scope compliance | DevOps lane only — no backend/frontend/mobile application implementation in this run |
| 10 | Human approval | `gate_id: H-IMPLEMENT`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing ISS link / traceability | LOAD | 3 |
| Missing validation documentation | VAL-DOC | 3 |
| Production deploy or prod apply attempted | SCOPE | 3 — escalate if repeated |
| Wrong lane scope (app code) | SCOPE | 3 |
| Missing CODE persist | PERSIST | 3 |
| Irrecoverable plan artifact gap | Escalate OUT-05 | — |