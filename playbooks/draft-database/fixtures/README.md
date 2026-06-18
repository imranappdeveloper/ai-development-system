# Database Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-feature-alpha/` | WF-FEATURE workspace with approved ARCH + PRD stubs, WR, and DB output directory |

## wf-feature-alpha layout

```text
wf-feature-alpha/
├── CONTEXT.md
└── work/
    ├── WR-FEATURE-ALPHA.md          # Work Record
    ├── prd/
    │   └── WR-FEATURE-ALPHA.md      # Approved PRD input (soft)
    ├── architecture/
    │   └── WR-FEATURE-ALPHA.md      # Approved ARCH input
    └── database/
        └── README.md                # Agent writes WR-FEATURE-ALPHA.md here during tests
```

Use with `11-test-plan.md` HT-06 and FT-01–FT-03.