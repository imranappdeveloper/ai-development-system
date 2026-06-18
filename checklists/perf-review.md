# CL-PERF-REVIEW — Performance Review Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-PERF-REVIEW |
| version | 1.0.0 |
| status | draft |
| consumer | PB-perf-review |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-VERIFY**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | CODE linked in WR; H-IMPLEMENT soft gate satisfied; Verify phase; `work_id` resolvable |
| 2 | CODE traceability | Every finding maps to CODE §4 path or §3 issue_id; no orphan hotspots |
| 3 | Baseline grounding | PERF-BASE path linked when present; `baseline_alignment` block or `baseline_gap: waiver` documented |
| 4 | PERF-REVIEW persisted | `{project_root}/work/perf-review/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | Review only — no benchmarks | §6 Benchmark Evidence empty or `review_only` placeholder; no load-test commands run |
| 6 | Findings complete | §4 lists severity-tagged findings; blockers have required actions |
| 7 | NFR / baseline comparison | §3 targets table populated when PERF-BASE or PRD NFR present |
| 8 | WR updated | PERF-REVIEW artifact linked; `status: perf_review_pending` |
| 9 | No code fixes | No application source modifications — findings only |
| 10 | Human gate | `gate_id: H-VERIFY`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing CODE link / traceability | LOAD | 3 |
| Benchmark execution attempted | SCOPE | 3 — escalate if repeated |
| Application code modified | SCOPE | 3 |
| Missing PERF-REVIEW persist | PERSIST | 3 |
| Irrecoverable baseline/CODE gap | Escalate OUT-05 | — |