# Test Plan Examples

| Path | Purpose |
|------|---------|
| `golden/TEST-PLAN-feature-001.md` | Golden TEST-PLAN for WF-FEATURE preferences verification plan |
| `anti-patterns/TEST-PLAN-execute-tests.md` | Anti-pattern: agent runs tests during plan phase |
| `anti-patterns/TEST-PLAN-no-ac-mapping.md` | Anti-pattern: empty §3.1 AC mapping |
| `anti-patterns/TEST-PLAN-self-approved.md` | Anti-pattern: agent self-approves H-VERIFY |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-TEST-PLAN manual rubric (see `11-test-plan.md` FT-04–FT-06)
- Do not treat examples as SSOT — project TEST-PLAN files are authoritative per `work_id`