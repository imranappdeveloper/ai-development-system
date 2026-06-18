---
anti_pattern_id: REL-missing-verify
severity: P0
related_ec: EC-ENT-05
fails_checklist: 2
---

# Anti-Pattern — WF-FEATURE Without TEST-RPT Grounding

## What goes wrong

Agent produces REL for `WF-FEATURE` with empty §8.1 and no TEST-RPT reference:

```yaml
upstream_test_rpt_path: null
```

```markdown
### 8.1 Pre-Release Checks

| Check | Result | Evidence | Standard ref |
|-------|--------|----------|--------------|
| CI green | pass | CODE §6 notes | STD-CI-001 |
| regression tests | pass | assumed | STD-TEST-002 |
```

## Symptoms

- CL-RELEASE #2 and #8 fail
- Ship without regression evidence
- Quality chain bypass — PB-verify skipped
- H-VERIFY false confidence

## Correct pattern

Link TEST-RPT or block soft with recommendation:

```yaml
upstream_test_rpt_path: work/testing/WR-FEATURE-ALPHA.md
```

```markdown
| regression tests | pass | TEST-RPT §4 — 12/12 pass | STD-TEST-002 |
```

Or when blocked:

```yaml
recommended_next_skill: PB-verify
gate_decision: pending
notes: TEST-RPT missing on WF-FEATURE — invoke PB-verify before REL complete
```

## Prevention

- IN-42 soft required for WF-FEATURE
- CL-RELEASE #2 TEST-RPT grounding
- `07-edge-cases.md` EC-ENT-05