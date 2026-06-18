# PB-security-review — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Replace Plan-phase threat modeling | PB-security-assess → SEC-ASSESS |
| Guarantee zero vulnerabilities | Human + external tooling; document residual risk |
| Run DAST/SAST scanners in all environments | Document expectations; human CI integration |
| Fix implementation defects | Flag findings → PB-implement revise |
| Deploy to staging or production | Human release after H-VERIFY |
| Review files not cited in CODE §4 without expansion | Flag scope gap; human widen CODE or re-implement |
| Infer compliance frameworks without SEC-ASSESS/PRD | Flag open question; human owner |
| Satisfy H-VERIFY alone without human | Advisory model per STD-REVIEW-001 |

---

## Human Approval Required

- H-VERIFY approve / revise / reject / waive on SEC-REVIEW
- Proceed with `security_review_confidence: low`
- Accept P0 findings with ship waiver
- Waive SEC-ASSESS requirement (`assess_gap: waiver`)
- Waive optional H-VERIFY for this skill (`human_waiver`)
- Production deployment (always human — never agent)
- Material auth or data-exposure accept-with-risk decisions

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤55% session)
- CODE §4 bounded file reads — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases or live traffic
- Cannot execute exploit payloads against running systems