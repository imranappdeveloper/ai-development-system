# PB-maintenance-triage — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Execute patches or deploys | Human / CI after H-OPERATE |
| Guarantee CVE completeness without scanner | PB-security-assess for deep review |
| Live production metric collection | Human provides alerts or monitoring exports |
| Spawn child workflows | Human after H-OPERATE approve |
| Resolve all backlog in one cycle | §3.3 defer + follow-up cycles |

---

## Human Approval Required

- H-OPERATE approve / revise / reject
- Authorize child work fan-out
- Accept P0 reactive triage with incomplete metrics
- Waive REL requirement on post-release path
- Waive approved INT requirement (`human_waiver`)

---

## AI / Context Limits

- Token budget caps per 05-context.md
- Batch depth ≤ 2 (G-WF-MNT-01)
- No cross-project memory
- Vendor chat history not SSOT