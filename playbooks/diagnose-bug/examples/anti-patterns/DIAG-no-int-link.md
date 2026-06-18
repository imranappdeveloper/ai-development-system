---
skill_id: PB-diagnose-bug
anti_pattern: true
checklist_fail: CL-DIAGNO
---

# Anti-pattern — DIAG-no-int-link

**Trigger:** `upstream_int_path: null`

**Why it fails:** Missing INT link fails CL-DIAGNO #3.

**Recovery:** Return to DOC step; fix per `checklists/diagnose.md`.
