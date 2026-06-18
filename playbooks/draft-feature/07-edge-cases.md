# PB-draft-feature — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-feature |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved DISC | Block; recommend PB-discovery-research | N |
| EC-ENT-02 | FEAT already H-PLAN approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type: bugfix` | Block; recommend PB-draft-issue | N |
| EC-ENT-04 | H-FRAME not approved | Block; complete Frame gate | N |
| EC-ENT-05 | WR missing DISC ref | Block; list missing IN-10 | N |
| EC-ENT-06 | Multi-epic scope in DISC | Block; recommend PB-draft-prd | Y |
| EC-RES-01 | DISC contradicts narrow-slice assumption | Document `discovery_alignment: partial`; flag in Open Questions | Y |
| EC-RES-02 | Stale DISC (`revision` < INT) | `discovery_gap: stale`; cite both versions | Y |
| EC-WF-01 | `WF-FEATURE` narrow slice | Proceed; recommend PB-decompose-issues after approve | N |
| EC-WF-02 | `WF-ENHANCEMENT` fast path | Proceed with `feat_type: enhancement` | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from DISC only | N |
| EC-CTX-02 | CONTEXT > budget | Digest module map | N |
| EC-CTX-03 | Chat-only agent | Full FEAT in output + `persist: pending` | Y |
| EC-SEC-01 | PII in stakeholder input | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-DRAFT fail | Recovery ≤3 → OUT-05 | Y |
| EC-SCP-01 | Code snippets in FEAT | CL-DRAFT #7 fail; remove | N |
| EC-SCP-02 | Architecture/API detail in FEAT | CL-DRAFT #7 fail; defer to downstream TPs | N |
| EC-SCP-03 | Implementation Slices / ISS-* in FEAT | CL-DRAFT #7 fail; defer to PB-decompose-issues | N |
| EC-HUM-01 | Vague H-PLAN revise notes | Request specificity; re-HAND | Y |
| EC-RT-01 | Human requests PRD instead | Document; recommend PB-draft-prd at H-PLAN | Y |
| EC-RT-02 | Single-unit scope | May recommend PB-implement — not decompose | Y |
| EC-LNK-01 | No DISC link in References | CL-DRAFT #4 fail | N |
| EC-OPT-01 | PRD already exists | Block FEAT; wrong path | N |
| EC-ALT-01 | feature-planner selects PRD | Do not invoke PB-draft-feature | N |
| EC-REG-01 | Agent `decision: approve` | CL-DRAFT #10 fail | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / arch / issues) | DOC | 3 |
| Missing upstream link | LOAD | 3 |
| Scope too large for FEAT | Escalate OUT-05; recommend PRD | — |
| Irrecoverable upstream gap | Escalate OUT-05 | — |