# PB-decompose-issues — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-decompose-issues |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee optimal sprint sequencing | Human project planning; non-binding notes only |
| Accurate effort estimates per issue | Human H-DECOMPOSE + team input |
| Full codebase audit for hidden dependencies | Bounded markers per 05-context.md |
| Resolve all PRD ambiguities | Flag `requires_prd_revise` → PB-draft-prd |
| Produce implementation code | PB-implement-* after H-DECOMPOSE |
| Change PRD requirements | Document `prd_alignment`; human decides |
| Validate tests in CI | PB-implement-* + PB-verify |
| Infer legal/compliance rules without PRD | Flag open question; human owner |

---

## Human Approval Required

- H-DECOMPOSE approve / revise / reject on issue set
- Proceed with `decompose_confidence: low`
- Accept `requires_prd_revise` routing back to PRD
- Waive multi-issue breakdown (`single_issue_path`)
- Deferred scope via `decompose_gap`
- Lane boundary disputes (backend vs frontend)

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤30% session)
- Code markers only — not full implementation review
- No cross-project memory
- Vendor chat history not SSOT
- Cannot run implement or verify suites