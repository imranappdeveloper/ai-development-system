# PB-draft-api — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee optimal rate-limit or caching strategy | Human H-PLAN + production metrics |
| Full API traffic forecasting without baselines | Human estimates, PB-perf-baseline |
| Line-by-line review of all existing handlers | Bounded markers per 05-context.md |
| Resolve all ARCH ambiguities | Flag `requires_arch_revise` → PB-draft-architecture |
| Produce executable handler code or OpenAPI files | PB-implement-backend after H-PLAN |
| Change ARCH component boundaries | Document `arch_alignment`; human decides |
| Validate contract tests in production | PB-implement-backend + PB-verify |
| Infer legal data-retention rules without PRD | Flag open question; human owner |

---

## Human Approval Required

- H-PLAN approve / revise / reject on API
- Proceed with `api_confidence: low`
- Accept `requires_arch_revise` routing back to ARCH
- Waive approved ARCH requirement (`human_waiver`)
- Waive PRD requirement (`prd_gap: waiver`)
- Waive DB requirement (`db_gap: waiver`)
- Breaking changes and client migration acceptance
- Material auth model or scope changes

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤35% session)
- API markers only — not full handler body review
- No cross-project memory
- Vendor chat history not SSOT
- Cannot call live APIs or run contract test suites