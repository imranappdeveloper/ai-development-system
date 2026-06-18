# Database Examples

| Path | Purpose |
|------|---------|
| `golden/DB-feature-001.md` | Golden DB for WF-FEATURE user preferences schema |
| `anti-patterns/DB-contains-sql.md` | Anti-pattern: executable DDL/SQL in DB doc |
| `anti-patterns/DB-no-arch-link.md` | Anti-pattern: missing ARCH traceability |
| `anti-patterns/DB-self-approved.md` | Anti-pattern: agent self-approves H-PLAN |

## Usage

- Compare agent output structure against golden snapshot
- Run anti-patterns through CL-DATABASE manual rubric (see `11-test-plan.md` FT-04–FT-06)
- Do not treat examples as SSOT — project DB files are authoritative per `work_id`