# PB-implement-mobile — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-implement-mobile |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee device-specific performance without baselines | PB-perf-baseline + human metrics on target devices |
| Full regression across all device matrix | Bounded tests per ISS scope; PB-verify |
| Submit to App Store or Play Store | Human release after H-VERIFY |
| Resolve all UIUX ambiguities | Flag `requires_uiux_revise` → PB-draft-ui-ux |
| Invent API endpoints without API artifact | Flag `requires_api_revise` → PB-draft-api |
| Implement backend handlers or web SPA pages | PB-implement-backend / PB-implement-frontend |
| Run CI pipelines on physical devices in all environments | Document commands; PB-verify executes |
| Infer legal/compliance rules without PRD | Flag open question; human owner |

---

## Human Approval Required

- H-IMPLEMENT approve / revise / reject on CODE
- Proceed with `implement_confidence: low`
- Accept `requires_uiux_revise` or `requires_api_revise` routing
- Waive ISS requirement (`human_waiver` — WF-BUGFIX edge only)
- Waive UIUX requirement (`uiux_gap: waiver`)
- Waive API requirement (`api_gap: waiver`)
- App store / production release (always human — never agent)
- Material auth token or PII exposure changes

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session)
- Targeted file reads — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production analytics with PII
- Cannot execute app store submit scripts as part of this playbook