# Review Examples

| Path | Purpose |
|------|---------|
| `golden/REVIEW-feature-001.md` | Golden REVIEW for WF-FEATURE preferences backend review |
| `anti-patterns/REVIEW-self-approved.md` | Anti-pattern: agent self-approves H-VERIFY |
| `anti-patterns/REVIEW-modifies-code.md` | Anti-pattern: agent changes source during review |
| `anti-patterns/REVIEW-no-ac-assessment.md` | Anti-pattern: empty §4 AC assessment |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-REVIEW manual rubric (see `11-test-plan.md` FT-04–FT-06)
- Do not treat examples as SSOT — project REVIEW files are authoritative per `work_id`