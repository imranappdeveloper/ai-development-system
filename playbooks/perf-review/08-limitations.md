# PB-perf-review — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Confirm latency under load without benchmarks | Human / PB-verify with perf tooling |
| Measure p95/p99 in production | Human APM + benchmark runs |
| Guarantee index effectiveness without EXPLAIN | Flag risk; human DB review |
| Resolve all CODE ambiguities | Flag `requires_code_revise` → PB-implement-* |
| Invent NFR targets without PERF-BASE/PRD | Flag `baseline_gap`; human waiver |
| Full monorepo perf audit | Bounded scope per CODE §4 |
| Device-specific mobile perf without baselines | PB-perf-baseline + human on-device metrics |

---

## Human Approval Required

- H-VERIFY approve / revise / reject (always)
- Proceed with `perf_confidence: low`
- Accept `requires_code_revise` routing
- Waive PERF-BASE requirement (`baseline_gap: waiver`) on WF-PERF
- Ship with open should-fix findings (documented waiver)
- Run suggested benchmarks from §7 Recommendations

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session)
- Static analysis only — no profiler attachment
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases or live traffic
- Cannot execute load generators as part of this playbook