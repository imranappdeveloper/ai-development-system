---
skill_id: PB-security-assess
anti_pattern: true
checklist_fail: CL-SECURI
fails_check: 2
---

# Anti-pattern — SEC-ASSESS-no-int-link

**Trigger:** `upstream_int_path: null` and empty References table.

**Why it fails:** Missing INT traceability fails CL-SECURI #2.

**Recovery:** Return to LOAD step; set `upstream_int_path` and populate References per `checklists/security.md`.