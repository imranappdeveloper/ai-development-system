# Security Review Examples

| Path | Purpose |
|------|---------|
| `golden/SEC-REVIEW-security-001.md` | Golden SEC-REVIEW for WF-SECURITY auth hardening CODE |
| `anti-patterns/SEC-REVIEW-mutates-code.md` | Anti-pattern: agent patches code during review |
| `anti-patterns/SEC-REVIEW-self-approved.md` | Anti-pattern: agent self-approves H-VERIFY |
| `anti-patterns/SEC-REVIEW-confuses-assess.md` | Anti-pattern: produces SEC-ASSESS (Plan) instead of SEC-REVIEW |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-SECURITY-REVIEW manual rubric (see `11-test-plan.md` FT-04–FT-06)
- Do not treat examples as SSOT — project SEC-REVIEW files are authoritative per `work_id`