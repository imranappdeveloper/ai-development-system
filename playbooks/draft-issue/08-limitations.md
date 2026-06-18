# PB-draft-issue — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-issue |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee production fix without implement | PB-implement + PB-verify |
| Full codebase audit | Bounded markers per 05-context.md |
| Resolve all upstream ambiguities | Flag open questions; human at H-PLAN |
| Run tests or CI | PB-verify |
| Change upstream artifact requirements | Document gap; upstream skill revise |
| Infer compliance without upstream | Human owner in Open Questions |

---

## Human Approval Required

- H-PLAN approve / revise / reject
- Proceed with low confidence enums
- Waive optional upstream artifacts
- Accept blocked reproduction (diagnose path)

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤30% session)
- No cross-project memory
- Vendor chat history not SSOT
