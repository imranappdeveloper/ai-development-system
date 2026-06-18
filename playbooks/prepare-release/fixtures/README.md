# Prepare-Release Fixtures

| Fixture | Purpose |
|---------|---------|
| `projects/wf-feature-alpha/` | WF-FEATURE happy path — CODE + TEST-RPT + WR for HT-06 |
| `projects/wf-release-alpha/` | WF-RELEASE waiver path — CODE without TEST-RPT for HT-08 |

## Usage

- Resolve paths relative to fixture `project_root`
- Do not mutate fixture files during automated tests — copy to temp workspace
- See `11-test-plan.md` FT-01–FT-09