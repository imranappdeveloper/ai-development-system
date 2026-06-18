# Backend Implement Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-feature-alpha/` | WF-FEATURE workspace with ISS stub, WR, and CODE output directory |

## wf-feature-alpha layout

```text
wf-feature-alpha/
├── CONTEXT.md
└── work/
    ├── WR-FEATURE-ALPHA.md          # Work Record with ISS ref
    ├── issues/
    │   └── ISS-BE-001.md            # Backend ISS stub
    ├── api/
    │   └── WR-FEATURE-ALPHA.md      # Optional — link when API gate passed
    ├── database/
    │   └── WR-FEATURE-ALPHA.md      # Optional — link when DB gate passed
    └── implement/
        └── backend/
            └── README.md              # Agent writes WR-FEATURE-ALPHA.md here during tests
```

Use with `11-test-plan.md` HT-06 and FT-01–FT-03.