---
anti_pattern_id: TEST-RPT-no-plan-link
severity: P0
related_ec: EC-ENT-01
fails_checklist: 2
---

# Anti-Pattern — No TEST-PLAN Link

## What goes wrong

Agent executes ad-hoc tests without grounding in TEST-PLAN or TEST-GEN:

```yaml
---
document_id: TEST-RPT-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
test_phase: evidence
upstream_test_plan_path: null
upstream_test_gen_path: null
---
```

```markdown
## 1. Overview

### 1.1 Purpose

Ran pytest on the repo — all tests green.
```

## Symptoms

- CL-VERIFY #2 fail
- Untraceable coverage — AC mapping unknown
- Quality chain broken — PB-test-plan / PB-test-generate skipped
- H-VERIFY cannot assess requirement satisfaction

## Correct pattern

Link upstream artifacts and align to TC-*:

```yaml
upstream_test_plan_path: work/testing/plan/WR-FEATURE-ALPHA.md
upstream_test_gen_path: work/testing/generate/WR-FEATURE-ALPHA.md
```

```yaml
plan_alignment:
  test_plan_document_id: TEST-PLAN-WR-FEATURE-ALPHA
  alignment: aligned
  test_plan_path: work/testing/plan/WR-FEATURE-ALPHA.md
gen_alignment:
  test_gen_document_id: TEST-GEN-WR-FEATURE-ALPHA
  alignment: aligned
  test_gen_path: work/testing/generate/WR-FEATURE-ALPHA.md
```

## Prevention

- CL-VERIFY check #2
- AC-PLN-01 + AC-GEN-01 in 06-quality.md
- EC-ENT-01 + EC-ENT-02 in 07-edge-cases.md