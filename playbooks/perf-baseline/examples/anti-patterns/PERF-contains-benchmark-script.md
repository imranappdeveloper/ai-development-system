---
skill_id: PB-perf-baseline
anti_pattern: true
checklist_fail: CL-PERF
---

# Anti-pattern — PERF-contains-benchmark-script

**Trigger:** `export default function () { http.get('http://...') }` or `k6 run` in PERF-BASE body

**Why it fails:** Load-test execution violates CL-PERF #5 and #7 — Plan phase defines targets and measurement plan only.

**Recovery:** Return to MEASURE step; describe tooling categories without scripts; fix per `checklists/perf.md`.