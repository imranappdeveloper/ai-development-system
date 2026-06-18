---
skill_id: PB-security-assess
anti_pattern: true
checklist_fail: CL-SECURI
related_ec: EC-SCP-04
---

# Anti-pattern — SEC-ASSESS-confuses-review

**Trigger:** Agent produces Verify-phase SEC-REVIEW content during Plan assess:

```yaml
document_id: SEC-REVIEW-WR-SECURITY-ALPHA
upstream_code_path: work/implement/backend/WR-SECURITY-ALPHA.md
```

Or writes findings against `src/middleware/session.ts` without a threat model.

**Why it fails:** PB-security-assess is Plan-phase only — code review is PB-security-review (CL-SECURI scope / N4/N14).

**Recovery:** Return to MODEL step; produce SEC-ASSESS at `work/security/{work_id}.md` with threat model and SA-* controls — no CODE findings.