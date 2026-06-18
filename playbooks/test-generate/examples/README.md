# Test Generate Examples

| Path | Purpose |
|------|---------|
| `golden/TEST-GEN-feature-001.md` | Golden TEST-GEN for WF-FEATURE preferences test generation |
| `anti-patterns/TEST-GEN-execute-tests.md` | Anti-pattern: agent runs tests during generate phase |
| `anti-patterns/TEST-GEN-no-file-paths.md` | Anti-pattern: empty §3 Generated Files Catalog |
| `anti-patterns/TEST-GEN-self-approved.md` | Anti-pattern: agent self-approves H-VERIFY |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-TEST-GEN manual rubric (see `11-test-plan.md` FT-04–FT-06)
- Do not treat examples as SSOT — project TEST-GEN files are authoritative per `work_id`