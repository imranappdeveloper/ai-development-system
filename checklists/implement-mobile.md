# CL-IMPLEMENT-MOBILE — Mobile Implementation Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-IMPLEMENT-MOBILE |
| version | 1.0.0 |
| status | draft |
| consumer | PB-implement-mobile |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-IMPLEMENT**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | ISS or ISS-* linked in WR; H-DECOMPOSE or H-PLAN soft gate satisfied; `implement_lane: mobile` |
| 2 | Issue traceability | Every code change maps to ≥1 ISS/ISS-* ID in CODE §3 Implementation Log |
| 3 | Plan artifact grounding | UIUX path linked when present (soft required); `uiux_gap` waiver documented if absent; API path linked when data-fetch ISS present |
| 4 | CODE record persisted | `{project_root}/work/implement/mobile/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | TDD + tests documented | Code implemented via `/tdd` vertical slices (RED→GREEN per ISS); §6 Testing Notes lists tests with commands/results — never empty |
| 6 | No deployment | No app store submit, production release, or infra apply commands in output or CODE record |
| 7 | Repository changes cited | §4 Files Changed lists paths with change summary; no orphan edits |
| 8 | WR updated | CODE artifact linked; `status: implement_mobile_pending_review` |
| 9 | Scope compliance | Mobile lane only — no backend/web-frontend/devops implementation in this run |
| 10 | Human approval | `gate_id: H-IMPLEMENT`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing ISS link / traceability | LOAD | 3 |
| Missing UIUX link / uiux_gap undocumented | LOAD | 3 |
| Missing tests documentation | TEST-DOC | 3 |
| App store submit or release action attempted | SCOPE | 3 — escalate if repeated |
| Wrong lane scope (backend/web/infra) | SCOPE | 3 |
| Missing CODE persist | PERSIST | 3 |
| Irrecoverable UIUX artifact gap | Escalate OUT-05 | — |