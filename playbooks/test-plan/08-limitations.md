# PB-test-plan — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-test-plan |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Confirm tests pass without execution | PB-verify after PB-test-generate |
| Generate executable test code | PB-test-generate |
| Measure coverage percentages | PB-verify with coverage tooling |
| Run security scans or perf benchmarks | PB-verify / dedicated review skills |
| Resolve all CODE ambiguities | Flag `requires_code_revise` → PB-implement-* |
| Invent AC without PRD/ISS | Flag `ac_gap`; human waiver |
| Full regression across entire monorepo | Bounded scope per ISS + CODE §4 |
| Infer legal/compliance rules without PRD | Flag open question; human owner |

---

## Human Approval Required

- H-VERIFY full evidence approve (always after PB-verify)
- Inline `approve_plan` / `revise_plan` / `reject_plan` when reviewing plan sub-artifact
- Proceed with `test_confidence: low`
- Accept `requires_code_revise` routing
- Waive CODE requirement (`code_gap: waiver`)
- Waive AC grounding (`ac_gap: waiver`)
- Skip PB-test-generate and proceed to PB-verify (documented waiver)

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤45% session)
- Marker reads only — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases or live traffic
- Cannot execute test runners as part of this playbook