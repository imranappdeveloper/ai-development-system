# PB-implement-backend — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-implement-backend |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee production performance without baselines | PB-perf-baseline + human metrics |
| Full regression across entire monorepo | Bounded tests per ISS scope; PB-verify |
| Deploy to staging or production | Human release after H-VERIFY |
| Resolve all API ambiguities | Flag `requires_api_revise` → PB-draft-api |
| Invent schema columns without DB artifact | Flag `requires_db_revise` → PB-draft-database |
| Implement UI components | PB-implement-frontend |
| Run CI pipelines in all environments | Document commands; PB-verify executes |
| Infer legal/compliance rules without PRD | Flag open question; human owner |

---

## Human Approval Required

- H-IMPLEMENT approve / revise / reject on CODE
- Proceed with `implement_confidence: low`
- Accept `requires_api_revise` or `requires_db_revise` routing
- Waive ISS requirement (`human_waiver` — WF-BUGFIX edge only)
- Waive API requirement (`api_gap: waiver`)
- Waive DB requirement (`db_gap: waiver`)
- Production deployment (always human — never agent)
- Material auth or data-exposure changes

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session)
- Targeted file reads — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases or live traffic
- Cannot execute deploy scripts as part of this playbook