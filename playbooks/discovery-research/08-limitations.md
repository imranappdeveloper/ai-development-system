# PB-discovery-research — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee correct recommendations | Human H-FRAME |
| Live stakeholder interviews | Human conducts; agent documents |
| Full architecture survey | PB-survey-codebase (future) |
| Change intake classification | Flag `requires_re_intake` → PB-intake-classify |
| Resolve all open questions in one pass | Revise loop or follow-up discovery |

---

## Human Approval Required

- H-FRAME approve / revise / reject
- Proceed with `discovery_confidence: low`
- Accept `requires_re_intake` routing
- Waive approved INT requirement (`human_waiver`)

---

## AI / Context Limits

- Token budget caps per 05-context.md
- `src/**` markers only — not line-by-line audit
- No cross-project memory
- Vendor chat history not SSOT