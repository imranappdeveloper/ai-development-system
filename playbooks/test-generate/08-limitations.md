# PB-test-generate — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Confirm tests pass without execution | PB-verify |
| Measure coverage percentages | PB-verify with coverage tooling |
| Run security scans or perf benchmarks | PB-verify / dedicated review skills |
| Resolve all TEST-PLAN ambiguities | Flag `requires_plan_revise` → PB-test-plan |
| Invent TC-* without TEST-PLAN | Flag `plan_gap`; human waiver |
| Full integration tests without test DB | Defer in §5; PB-verify with env |
| Infer legal/compliance rules without plan | Flag open question; human owner |
| Guarantee generated tests compile in all CI envs | PB-verify validates |

---

## Human Approval Required

- H-VERIFY approve (always after PB-verify — never from this playbook)
- Proceed with `test_confidence: low`
- Accept `requires_plan_revise` routing
- Waive CODE requirement (`code_gap: waiver`)
- Waive TEST-PLAN completeness (`plan_gap: waiver`)
- Skip PB-verify and proceed to PB-review only (documented waiver)
- `skip_file_write` dry-run catalog mode

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session)
- Bounded source reads — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases or live traffic
- Cannot execute test runners as part of this playbook