# Security Review Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-security-alpha/` | WF-SECURITY Verify-phase fixture with CODE + SEC-ASSESS stubs |

## Usage

- HT-06 / FT-01–FT-03 in `11-test-plan.md`
- CODE stub has H-IMPLEMENT-approved WR parent
- SEC-ASSESS stub is soft dependency — tests `assess_gap: missing` when omitted

## Fake values

All credentials use `sk-test-fake` or `[REDACTED]` per STD-SEC-001 fixture exception.