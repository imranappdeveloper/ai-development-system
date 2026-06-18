# Decompose Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-feature-alpha/` | WF-FEATURE workspace with approved PRD stub, WR, and ISS-BE-001 output stub |

## wf-feature-alpha layout

```text
wf-feature-alpha/
├── CONTEXT.md
└── work/
    ├── WR-FEATURE-ALPHA.md          # Work Record — post H-PLAN
    ├── prd/
    │   └── WR-FEATURE-ALPHA.md      # Approved PRD input
    └── issues/
        └── ISS-BE-001.md            # ISS output stub (agent adds ISS-FE-* during tests)
```

Use with `11-test-plan.md` HT-05 and FT-01–FT-03.