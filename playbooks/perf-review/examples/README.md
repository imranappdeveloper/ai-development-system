# Performance Review Examples

| Path | Purpose |
|------|---------|
| `golden/PERF-REVIEW-perf-001.md` | Golden PERF-REVIEW for WF-PERF list endpoint latency review |
| `anti-patterns/PERF-REVIEW-run-benchmarks.md` | Anti-pattern: agent runs load tests during review |
| `anti-patterns/PERF-REVIEW-no-code-grounding.md` | Anti-pattern: findings without CODE path traceability |
| `anti-patterns/PERF-REVIEW-self-approved.md` | Anti-pattern: agent self-approves H-VERIFY |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-PERF-REVIEW manual rubric (see `11-test-plan.md` FT-04–FT-06)
- Do not treat examples as SSOT — project PERF-REVIEW files are authoritative per `work_id`