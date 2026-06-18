# PB-onboard-project — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee CONTEXT.md accuracy without human review | Human H-FRAME |
| Full line-by-line codebase audit | PB-survey-codebase (optional follow-up) |
| Change intake classification | Flag `requires_re_intake` → PB-intake-classify |
| Apply CONTEXT.md edits | PB-draft-doc-update after human approval |
| Resolve all adoption gaps in one pass | Revise loop or follow-up survey |

---

## Human Approval Required

- H-FRAME approve / revise / reject
- Accept proposed CONTEXT.md updates
- Proceed with `onboarding_confidence: low`
- Accept `requires_re_intake` routing
- Waive approved INT requirement (`human_waiver`)

---

## AI / Context Limits

- Token budget caps per 05-context.md
- Repo markers only — not exhaustive code review
- No cross-project memory
- Vendor chat history not SSOT