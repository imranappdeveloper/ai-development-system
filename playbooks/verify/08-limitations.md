# PB-verify — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-verify |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Approve H-VERIFY or authorize ship | Human reviews TEST-RPT |
| Generate missing test source files | PB-test-generate |
| Redesign test strategy or AC mapping | PB-test-plan |
| Fix failing application code | PB-implement-* |
| Run production traffic or live penetration scans | Dedicated security ops / staging env |
| Guarantee flake-free CI on first run | Document flakes; recommend re-run |
| Full monorepo regression in one session | Bounded scope per ISS + TEST-PLAN §4 |
| Infer legal/compliance pass without PRD criteria | Flag open question; human owner |
| Access credentials not in approved env | Document `blocked`; human provides env |

---

## Human Approval Required

- H-VERIFY `approve` / `revise` / `reject` (always after TEST-RPT)
- Proceed with `test_confidence: low`
- Accept `execution_result: partial` or `blocked`
- Waive TEST-PLAN requirement (`plan_gap: waiver`)
- Waive TEST-GEN requirement (`gen_gap: waiver`)
- Waive execution (`skip_execution_waiver`) — rare; must document in §9
- Accept failures and route to PB-implement-*

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session for reads)
- Command output truncated per failure — full logs not in TEST-RPT
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases without approved fixture env
- Cannot modify generated tests — report gap to PB-test-generate