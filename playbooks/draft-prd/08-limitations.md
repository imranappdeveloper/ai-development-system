# PB-draft-prd — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee correct priority ordering | Human H-PLAN |
| Resolve all open questions in one pass | Revise loop |
| Replace missing discovery for complex greenfield | PB-discovery-research first |
| Produce accurate effort estimates | PB-decompose-issues / human |
| Validate technical feasibility in depth | PB-draft-architecture |
| Change intake or discovery classification | Flag gap; human decides |

---

## Human Approval Required

- H-PLAN approve / revise / reject
- Proceed with `discovery_gap: missing` on non-waivable workflows
- Accept `prd_type: lite` for large-scope initiatives
- Waive DISC requirement when orchestrator does not soft-allow

---

## AI / Context Limits

- Token budget caps per 05-context.md
- `src/**` markers only — not line-by-line audit
- No cross-project memory
- Vendor chat history not SSOT
- Routing matrix not loaded into PRD body