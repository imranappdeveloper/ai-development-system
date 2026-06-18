# PB-perf-review — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No CODE in WR | Block; recommend PB-implement-* | N |
| EC-ENT-02 | PERF-REVIEW already H-VERIFY approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | H-IMPLEMENT not approved when CODE present | Block soft; document in handoff | Y |
| EC-ENT-04 | WR missing CODE artifact ref | Block; list missing IN-41 | N |
| EC-ENT-05 | WF-PERF without PERF-BASE | Proceed with `baseline_gap: waiver` or block per human | Y |
| EC-ENT-06 | PB-test-plan gate not PASS | Block; cite prerequisite IN-33 | N |
| EC-RES-01 | CODE §4 paths missing on disk | Flag in §4; `perf_confidence: low` | Y |
| EC-RES-02 | PERF-BASE targets conflict with PRD NFR | Flag in §3; human resolves | Y |
| EC-RES-03 | CODE partial_mismatch with PERF-BASE scope | `code_alignment: partial_mismatch` | Y |
| EC-RES-04 | Ambiguous hotspot — cannot locate in CODE | List blockers; request human clarify | Y |
| EC-WF-01 | `WF-BUGFIX` perf regression fix | Narrow scope to changed hot path | N |
| EC-WF-02 | `WF-FEATURE` multi-lane CODE | Review all linked CODE paths or `implement_lane_hint` | Y |
| EC-WF-03 | `WF-PERF` mandatory path | PERF-BASE comparison required unless waiver | Y |
| EC-WF-04 | `WF-REFACTOR` structural change | Emphasize regression risk in §5 | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from CODE; note gap in §1 | N |
| EC-CTX-02 | CONTEXT > budget | Digest stack/DB per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full PERF-REVIEW in output + `persist: pending` | Y |
| EC-SCP-01 | Agent runs k6/ab/wrk | CL-PERF-REVIEW #5 fail; STOP | N |
| EC-SCP-02 | Agent populates §6 with p95 metrics | CL-PERF-REVIEW #5 fail | N |
| EC-SCP-03 | Agent sets H-VERIFY `decision: approve` | CL-PERF-REVIEW #10 fail | N |
| EC-SCP-04 | Agent patches application code | CL-PERF-REVIEW #9 fail | N |
| EC-FND-01 | Finding without CODE path | CL-PERF-REVIEW #2 fail | N |
| EC-FND-02 | Blocker without required action | CL-PERF-REVIEW #6 fail | N |
| EC-SEC-01 | Secrets in §7 benchmark suggestions | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-PERF-REVIEW fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple CODE lanes (BE+FE) | Merge hotspots from all paths | Y |
| EC-PAR-01 | Partial file scope via `target_hotspot_path` | Document out-of-scope in §1.2 | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing CODE traceability | LOAD | 3 |
| Benchmark execution attempted | SCOPE | 3 — escalate if repeated |
| Application code modified | SCOPE | 3 |
| Missing PERF-REVIEW persist | PERSIST | 3 |
| Irrecoverable baseline/CODE gap | Escalate OUT-05 | — |