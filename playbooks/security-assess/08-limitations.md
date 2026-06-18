# PB-security-assess — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee exploitability without testing | PB-verify + PB-security-review after implement |
| Full codebase security audit | Bounded markers per 05-context.md |
| Run automated SAST/DAST or dependency scanners | Document as remediation action for implement |
| Resolve all upstream ambiguities | Flag open questions; human at H-PLAN |
| Verify controls in production | PB-security-review traces CODE vs SA-* |
| Certify compliance (SOC2, PCI) | Human compliance owner in Open Questions |
| Perform live penetration testing | Out of scope — plan only |

---

## Human Approval Required

- H-PLAN approve / revise / reject
- Proceed with `assess_confidence: low`
- Accept residual critical risks in risk register
- Waive optional upstream artifacts

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤30% session)
- No cross-project memory
- Vendor chat history not SSOT
- Cannot read encrypted secret stores in target project