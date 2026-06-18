# PB-draft-architecture — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee optimal technology choices | Human H-PLAN + ADRs |
| Full performance or security audit | PB-security-assess, PB-perf-baseline |
| Line-by-line codebase comprehension | Bounded markers per 05-context.md |
| Resolve all PRD ambiguities | Flag `requires_prd_revise` → PB-draft-prd |
| Produce API/database field-level specs | PB-draft-api / PB-draft-database |
| Change PRD scope or requirements | Document `prd_alignment`; human decides |
| Validate implementation feasibility in code | PB-implement + PB-verify |

---

## Human Approval Required

- H-PLAN approve / revise / reject on ARCH
- Proceed with `architecture_confidence: low`
- Accept `requires_prd_revise` routing back to PRD
- Waive approved PRD requirement (`human_waiver`)
- Material technology decisions with high rollback cost

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤40% session)
- `src/**` markers only — not implementation review
- No cross-project memory
- Vendor chat history not SSOT
- Cannot run load tests or provision infrastructure