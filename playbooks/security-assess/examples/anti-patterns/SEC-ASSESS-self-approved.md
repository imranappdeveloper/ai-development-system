---
skill_id: PB-security-assess
anti_pattern: true
checklist_fail: CL-SECURI
fails_check: 10
---

# Anti-pattern — SEC-ASSESS-self-approved

**Trigger:** Human Approval block contains `decision: approve`.

**Why it fails:** Agent self-approval fails CL-SECURI #10.

**Recovery:** Return to DOC step; set `decision: pending` only.