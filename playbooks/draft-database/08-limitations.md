# PB-draft-database — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee optimal index or partition strategy | Human H-PLAN + production metrics |
| Full data volume forecasting without baselines | PB-perf-baseline, human estimates |
| Line-by-line review of all migration history | Bounded markers per 05-context.md |
| Resolve all ARCH ambiguities | Flag `requires_arch_revise` → PB-draft-architecture |
| Produce executable migration scripts | PB-implement after H-PLAN |
| Change ARCH component boundaries | Document `arch_alignment`; human decides |
| Validate query plans in production | PB-implement + PB-verify |
| Infer GDPR/legal retention without PRD | Flag open question; human owner |

---

## Human Approval Required

- H-PLAN approve / revise / reject on DB
- Proceed with `database_confidence: low`
- Accept `requires_arch_revise` routing back to ARCH
- Waive approved ARCH requirement (`human_waiver`)
- Waive PRD requirement (`prd_gap: waiver`)
- Non-reversible migrations and destructive schema changes
- Material partitioning or sharding decisions

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤35% session)
- Schema markers only — not full SQL body review
- No cross-project memory
- Vendor chat history not SSOT
- Cannot connect to live databases or run EXPLAIN