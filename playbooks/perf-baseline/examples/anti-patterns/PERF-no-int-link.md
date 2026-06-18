---
skill_id: PB-perf-baseline
anti_pattern: true
checklist_fail: CL-PERF
---

# Anti-pattern — PERF-no-int-link

**Trigger:** `upstream_int_path: null` or empty References block

**Why it fails:** PERF-BASE must trace to approved INT per CL-PERF #3.

**Recovery:** Return to LOAD step; set `upstream_int_path` and populate References; fix per `checklists/perf.md`.