# CL-IMPLEMENT-FRONTEND — Frontend Implementation Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-IMPLEMENT-FRONTEND |
| version | 1.0.0 |
| status | draft |
| consumer | PB-implement-frontend |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-IMPLEMENT**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | ISS or ISS-* linked in WR; H-DECOMPOSE or H-PLAN soft gate satisfied; `implement_lane: frontend` |
| 2 | Issue traceability | Every code change maps to ≥1 ISS/ISS-* ID in CODE §3 Implementation Log |
| 3 | Plan artifact grounding | UIUX path linked when present; `uiux_gap` waiver documented if absent |
| 4 | CODE record persisted | `{project_root}/work/implement/frontend/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | TDD + tests documented | Code implemented via `/tdd` vertical slices (RED→GREEN per ISS); §6 Testing Notes lists tests with commands/results — never empty |
| 6 | No deployment | No production deploy, release tag, or CDN publish commands in output or CODE record |
| 7 | Repository changes cited | §4 Files Changed lists paths with change summary; no orphan edits |
| 8 | WR updated | CODE artifact linked; `status: implement_frontend_pending_review` |
| 9 | Scope compliance | Frontend lane only — no backend/mobile/devops implementation in this run |
| 10 | Human approval | `gate_id: H-IMPLEMENT`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing ISS link / traceability | LOAD | 3 |
| Missing tests documentation | TEST-DOC | 3 |
| Deployment or release action attempted | SCOPE | 3 — escalate if repeated |
| Wrong lane scope (server/infra) | SCOPE | 3 |
| Missing CODE persist | PERSIST | 3 |
| Irrecoverable UIUX artifact gap | Escalate OUT-05 | — |