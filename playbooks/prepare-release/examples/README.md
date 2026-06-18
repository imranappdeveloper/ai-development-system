# Release Examples

| Path | Purpose |
|------|---------|
| `golden/REL-feature-001.md` | Golden REL for WF-FEATURE preferences backend release |
| `anti-patterns/REL-self-approved.md` | Anti-pattern: agent self-approves H-SHIP |
| `anti-patterns/REL-deploy-commands.md` | Anti-pattern: handoff includes live deploy commands |
| `anti-patterns/REL-missing-verify.md` | Anti-pattern: WF-FEATURE without TEST-RPT grounding |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-RELEASE manual rubric (see `11-test-plan.md` FT-05–FT-07)
- Do not treat examples as SSOT — project REL files are authoritative per `work_id`