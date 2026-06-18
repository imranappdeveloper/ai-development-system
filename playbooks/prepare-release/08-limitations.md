# PB-prepare-release — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Confirm production health after deploy | Human H-OPERATE smoke |
| Execute deployments or CI/CD pipelines | Human after H-SHIP |
| Guarantee zero defects in release | Human H-SHIP + TEST-RPT evidence |
| Invent semver without human hint | Flag §11 open item |
| Resolve CODE/TEST-RPT contradictions alone | Escalate OUT-05 |
| Replace dedicated security or perf review | Upstream SEC-REVIEW / PERF-REVIEW |
| Run regression tests | PB-verify |
| Access production secrets or kubeconfig | Human deploy pipeline |
| Satisfy H-SHIP alone | Human gate per STD-WF-001 |

---

## Human Approval Required

- H-SHIP approve / revise / reject on REL
- Semver bump override
- Proceed with `release_confidence: low`
- Waive TEST-RPT requirement outside WF-RELEASE
- Accept §11 P0 blockers for ship anyway
- Execute production deployment
- H-OPERATE post-release verification
- Multi-work release bundle approval (`included_work_ids`)

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤45% session)
- CODE §4 file list only — not full repository dump
- No cross-project memory
- Vendor chat history not SSOT
- Cannot access production databases or live traffic
- Cannot execute deploy runners as part of this playbook
- Agent release plan is advisory — human ship decision authoritative