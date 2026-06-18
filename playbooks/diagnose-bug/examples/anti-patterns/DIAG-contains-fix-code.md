---
skill_id: PB-diagnose-bug
anti_pattern: true
checklist_fail: CL-DIAGNO
---

# Anti-pattern — DIAG-contains-fix-code

**Trigger:** `diff --git a/src/auth/login.ts`

**Why it fails:** Patch/diff in DIAG violates CL-DIAGNO #5.

**Recovery:** Return to DOC step; fix per `checklists/diagnose.md`.
