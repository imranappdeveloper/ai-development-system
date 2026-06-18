# Verify Examples

| Path | Purpose |
|------|---------|
| `golden/TEST-RPT-feature-001.md` | Golden TEST-RPT for WF-FEATURE preferences execution |
| `anti-patterns/TEST-RPT-skip-execution.md` | Anti-pattern: agent skips runs but claims pass |
| `anti-patterns/TEST-RPT-no-plan-link.md` | Anti-pattern: missing TEST-PLAN / TEST-GEN grounding |
| `anti-patterns/TEST-RPT-self-approved.md` | Anti-pattern: agent self-approves H-VERIFY |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-VERIFY manual rubric (see `11-test-plan.md` FT-04–FT-06)
- Do not treat examples as SSOT — project TEST-RPT files are authoritative per `work_id`