---
anti_pattern_id: PERF-REVIEW-run-benchmarks
severity: P0
related_ec: EC-SCP-01
fails_checklist: 5
---

# Anti-Pattern — Run Benchmarks During Review

## What goes wrong

Agent runs load tests and populates §6 Benchmark Evidence during PB-perf-review:

```markdown
## 6. Benchmark Evidence

| Scenario | Tool | p95 (ms) | RPS | Timestamp |
|----------|------|----------|-----|-----------|
| list_items | k6 | 342 | 120 | 2026-06-18T22:15:00Z |
```

## Symptoms

- CL-PERF-REVIEW #5 fail
- Review conflated with verification evidence
- H-VERIFY gate bypass risk
- PB-verify scope overlap

## Correct pattern

§6 must remain `review_only` with no live metrics. Suggest benchmarks in §7 Recommendations for human execution after CODE fixes.