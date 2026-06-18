# PB-implement-devops — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee production pipeline performance without baselines | Human metrics + PB-verify |
| Full regression across all environments | Bounded validation per ISS scope; PB-verify |
| Deploy to production or apply prod IaC | Human release after H-VERIFY / H-SHIP |
| Resolve all ARCH ambiguities | Flag `requires_arch_revise` → PB-draft-architecture |
| Invent release steps without REL artifact | Flag `requires_rel_prepare` → PB-prepare-release |
| Implement application handlers or UI | Lane children |
| Run pipelines in all cloud accounts | Document commands; PB-verify executes in allowed envs |
| Infer compliance rules without PRD/ARCH | Flag open question; human owner |

---

## Human Approval Required

- H-IMPLEMENT approve / revise / reject on CODE
- Proceed with `implement_confidence: low`
- Accept `requires_arch_revise` or `requires_rel_prepare` routing
- Waive ISS requirement (`human_waiver` — WF-BUGFIX edge only)
- Waive ARCH requirement (`arch_gap: waiver`)
- Waive REL requirement (`rel_gap: waiver`)
- Production deployment and prod IaC apply (always human — never agent)
- Material secrets or IAM policy expansion

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤50% session)
- Targeted file reads — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production clusters or live deploy state
- Cannot execute prod deploy scripts as part of this playbook