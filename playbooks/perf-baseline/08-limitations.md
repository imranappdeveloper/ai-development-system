# PB-perf-baseline — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-perf-baseline |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee production performance without implement | PB-implement + PB-verify |
| Execute load tests or capture live metrics | Human tooling or PB-verify post-implement |
| Full codebase profiling | Bounded module map per 05-context.md |
| Resolve all upstream ambiguities | Flag open questions; human at H-PLAN |
| Static review of implemented CODE | PB-perf-review (Verify phase) |
| Change upstream artifact requirements | Document gap; upstream skill revise |
| Device-specific mobile perf without human metrics | Open Questions + measurement plan assumptions |

---

## Human Approval Required

- H-PLAN approve / revise / reject
- Proceed with `baseline_confidence: low`
- Waive optional upstream artifacts
- Accept `measurement_readiness: blocked` with documented plan gaps
- Authorize benchmark tooling and environments (execution is human/verify)

---

## AI / Context Limits

- Token budget caps per 05-context.md and STD-PERF-001 (≤30% session)
- No cross-project memory
- Vendor chat history not SSOT
- Cannot observe production traffic — targets are planned, not measured here