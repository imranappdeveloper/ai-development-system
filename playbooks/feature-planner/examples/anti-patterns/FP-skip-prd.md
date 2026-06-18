---
anti_pattern_id: FP-skip-prd
severity: P0
related_ec: EC-RT-06
---

# Anti-Pattern — Skip Plan artifact before Decompose

## What goes wrong

Agent invokes `PB-decompose-issues` when:

- No PRD exists
- H-PLAN not approved
- Only raw DISC or chat intent available

## Symptoms

- ISS-* items lack plan SSOT
- Implement scope drifts from discovery
- H-DECOMPOSE review fails — no authoritative requirements

## Correct pattern

```text
Plan phase first:
  PB-draft-prd  → H-PLAN → PRD
  OR
  PB-draft-feature → H-PLAN → FEAT (with waiver if decompose needs PRD)

Then:
  PB-decompose-issues → H-DECOMPOSE → ISS-*
```

## Prevention

- Check IN-41 PRD + H-PLAN before decompose
- CL-FEAT-PLAN item #7
- fixtures/decision-matrix.yaml `decompose_requires_prd`