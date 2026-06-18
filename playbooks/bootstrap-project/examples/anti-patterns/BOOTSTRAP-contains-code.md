---
skill_id: PB-bootstrap-project
anti_pattern: true
checklist_fail: CL-BOOTST
---

# Anti-pattern — BOOTSTRAP-contains-code

**Trigger:** `const express = require('express')`

**Why it fails:** Implementation code in SCAFFOLD violates CL-BOOTST #5.

**Recovery:** Return to DOC step; fix per `checklists/bootstrap.md`.
