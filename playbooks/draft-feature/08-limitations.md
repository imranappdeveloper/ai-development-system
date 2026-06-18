# PB-draft-feature — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee correct priority ordering across slices | Human H-PLAN |
| Resolve all open questions in one pass | Revise loop |
| Replace missing discovery for ambiguous scope | PB-discovery-research first |
| Produce accurate effort estimates | PB-decompose-issues / human |
| Validate technical feasibility in depth | PB-draft-architecture after PRD path |
| Decide PRD vs FEAT without DISC signal | PB-feature-planner decision matrix + human |
| Invent codebase structure from thin DISC | Flag gap; request survey or architecture path |

---

## Human Approval Required

- H-PLAN approve / revise / reject
- Proceed when `discovery_alignment: partial`
- Accept narrow slice when DISC scope is borderline multi-epic
- Waive decompose for single-unit implement path
- Redirect to PB-draft-prd when FEAT insufficient

---

## AI / Context Limits

- Token budget caps per 05-context.md
- No `src/**` reads — behavior from DISC only
- No cross-project memory
- Vendor chat history not SSOT
- Routing matrix not loaded into FEAT body
- TP-feature full template not used — narrow subset only