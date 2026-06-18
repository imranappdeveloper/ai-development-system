# PB-implement-frontend — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-implement-frontend |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee production performance without baselines | PB-perf-baseline + human metrics |
| Full visual regression across entire design system | Bounded tests per ISS scope; PB-verify |
| Deploy to staging or production / CDN publish | Human release after H-VERIFY |
| Resolve all UIUX ambiguities | Flag `requires_uiux_revise` → PB-draft-ui-ux |
| Invent API endpoints without API artifact | Flag `requires_api_revise` → PB-draft-api |
| Implement server handlers or migrations | PB-implement-backend |
| Run CI pipelines in all environments | Document commands; PB-verify executes |
| Infer legal/compliance rules without PRD | Flag open question; human owner |
| Native mobile screens | PB-implement-mobile |

---

## Human Approval Required

- H-IMPLEMENT approve / revise / reject on CODE
- Proceed with `implement_confidence: low`
- Accept `requires_uiux_revise` or `requires_api_revise` routing
- Waive ISS requirement (`human_waiver` — WF-BUGFIX edge only)
- Waive UIUX requirement (`uiux_gap: waiver`)
- Waive API requirement (`api_gap: waiver`)
- Production deployment / CDN publish (always human — never agent)
- Material auth or PII exposure changes in client

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session)
- Targeted file reads — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production analytics or live user data
- Cannot execute deploy or CDN publish scripts as part of this playbook