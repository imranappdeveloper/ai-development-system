# PB-draft-ui-ux — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee optimal visual design without brand guidelines | Human H-PLAN + design review |
| Full usability testing without participants | Human research, PB-discovery-research |
| Line-by-line review of all existing components | Bounded markers per 05-context.md |
| Resolve all PRD ambiguities | Flag `requires_prd_revise` → PB-draft-prd |
| Produce executable component code or Figma files | PB-implement-frontend after H-PLAN |
| Change PRD functional scope | Document `prd_alignment`; human decides |
| Validate accessibility in production | PB-implement-frontend + PB-verify |
| Infer legal consent UX without PRD | Flag open question; human owner |

---

## Human Approval Required

- H-PLAN approve / revise / reject on UIUX
- Proceed with `uiux_confidence: low`
- Accept `requires_prd_revise` routing back to PRD
- Waive approved PRD requirement (`human_waiver`)
- Waive ARCH requirement (`arch_gap: waiver`)
- Waive DISC requirement (`disc_gap: waiver`)
- Material accessibility exceptions
- Redesign acceptance when replacing existing flows

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤35% session)
- UI markers only — not full component body review
- No cross-project memory
- Vendor chat history not SSOT
- Cannot run browser or accessibility audit tools