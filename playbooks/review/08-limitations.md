# PB-review — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Confirm runtime behavior without tests | PB-verify execution |
| Apply fixes to source code | PB-implement-* after human routes |
| Guarantee zero defects | Human H-VERIFY + PB-verify evidence |
| Full static analysis of entire monorepo | Bounded CODE §4 scope |
| Replace dedicated security audit | PB-security-review when active |
| Measure test coverage percentages | PB-verify with coverage tooling |
| Resolve all CODE ambiguities | Flag `requires_code_revise` → PB-implement-* |
| Invent AC without PRD/ISS | Flag gap; human waiver |
| Satisfy H-VERIFY alone | Human gate per STD-REVIEW-001 |

---

## Human Approval Required

- H-VERIFY full evidence approve (always after PB-verify TEST-RPT)
- Inline `approve` / `revise` / `reject` on review findings
- Proceed with `review_confidence: low`
- Accept `requires_code_revise` routing
- Waive review requirement (`review_waiver` in WR)
- Override P0 finding severity or waive with documented reason
- Skip PB-review when optional and document waiver

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session)
- CODE §4 paths only — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases or live traffic
- Cannot execute test runners as part of this playbook
- Agent review is advisory — human decision authoritative per STD-REVIEW-001