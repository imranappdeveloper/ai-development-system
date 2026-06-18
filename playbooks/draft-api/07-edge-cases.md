# PB-draft-api — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved ARCH | Block; recommend PB-draft-architecture | N |
| EC-ENT-02 | API already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | ARCH `status: draft` only | Block; await H-PLAN on ARCH or waiver | N |
| EC-ENT-04 | WR missing ARCH artifact ref | Block; list missing IN-10 | N |
| EC-ENT-05 | PRD missing and no waiver | Proceed with `prd_gap: missing`; flag in §4 traceability | Y |
| EC-ENT-06 | DB missing and no waiver | Proceed with `db_gap: missing`; models from ARCH only | Y |
| EC-RES-01 | ARCH underspecified for API surface | `api_confidence: low`; list blockers in open questions | Y |
| EC-RES-02 | ARCH conflicts with existing route markers | Document in §11; `arch_alignment: partial_mismatch` | Y |
| EC-RES-03 | PRD FR not in ARCH data flows | Flag `prd_alignment: partial_mismatch`; do not invent scope | Y |
| EC-RES-04 | DB entity missing for API model field | Flag `db_alignment: partial_mismatch`; do not invent columns | Y |
| EC-WF-01 | `WF-REFACTOR` path | `change_type: breaking`; §8 required | N |
| EC-WF-02 | `WF-FEATURE` greenfield API | `change_type: new`; §8 minimal | N |
| EC-WF-03 | `WF-ENHANCEMENT` additive endpoint | `change_type: additive`; version strategy in §3.3 | N |
| EC-WF-04 | `WF-SECURITY` auth hardening | `change_type: breaking \| additive`; §2 scopes explicit | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from ARCH only; note gap in §1.2 | N |
| EC-CTX-02 | CONTEXT > budget | Digest API conventions per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full API in output + `persist: pending` | Y |
| EC-SCP-01 | Handler code in API body | CL-API #8 fail; use parameter tables | N |
| EC-SCP-02 | ARCH component list copied into API | CL-API #8 fail; reference ARCH path only | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-API #10 fail | N |
| EC-LNK-01 | No ARCH link in alignment block | CL-API #4 fail | N |
| EC-SEC-01 | API key sample values in input | Redact `[REDACTED]` in auth notes | N |
| EC-VAL-01 | CL-API fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-PLAN | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple unrelated API surfaces in ARCH | Flag; recommend split work_id or ARCH revise | Y |
| EC-BRK-01 | Breaking change without §8 | CL-API #9 fail | N |
| EC-VER-01 | Version deprecation without sunset date | List in §8 or open questions | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / ARCH duplication) | DOC | 3 |
| Missing ARCH link | DOC | 3 |
| Insufficient operation or model definitions | MODEL | 3 |
| Incomplete breaking-change plan | BREAK | 3 |
| Irrecoverable ARCH/PRD/DB gap | Escalate OUT-05 | — |