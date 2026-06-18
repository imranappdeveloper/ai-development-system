# PB-survey-codebase — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |

---

## Cannot Reliably Do

| Limitation | Alternative |
|------------|-------------|
| Guarantee complete repo coverage | Bounded scan + §9 Gaps; `mode: refresh` |
| Runtime behavior analysis | PB-diagnose-bug / test execution playbooks |
| Security vulnerability assessment | PB-security-assess |
| Performance baseline | PB-perf-baseline |
| Change intake classification | Flag `requires_re_intake` → PB-intake-classify |
| Replace discovery problem framing | PB-discovery-research consumes SURVEY as input |

---

## Human Approval Required

- Waive approved INT requirement (`human_waiver`)
- Accept `requires_re_intake` routing
- Proceed with `survey_confidence: low` into discovery
- Expand scan beyond allowlist (out of scope — revise `scan_focus` within allowlist)

**Not required:** Human gate on SURVEY artifact (`exit_gate: none`).

---

## AI / Context Limits

- Token budget caps per 05-context.md (≤45% session; T3 ≤25%)
- 40-file / 2,400-line T3 hard caps
- No cross-project memory
- Vendor chat history not SSOT
- Line-by-line audit of large files forbidden