---
skill_id: PB-perf-baseline
anti_pattern: true
checklist_fail: CL-PERF
---

# Anti-pattern — PERF-self-approved

**Trigger:** `decision: approve` in Human Approval block set by agent

**Why it fails:** Agent must set `decision: pending` only — CL-PERF #10.

**Recovery:** Return to HAND step; reset Human Approval; fix per `checklists/perf.md`.