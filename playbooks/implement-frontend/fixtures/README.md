# Frontend Implement Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-feature-alpha/` | WF-FEATURE workspace with ISS + UIUX stub, WR, and CODE output directory |

## wf-feature-alpha layout

```text
wf-feature-alpha/
├── CONTEXT.md
└── work/
    ├── WR-FEATURE-ALPHA.md          # Work Record with ISS + UIUX refs
    ├── issues/
    │   └── ISS-FE-001.md            # Frontend ISS stub
    ├── uiux/
    │   └── WR-FEATURE-ALPHA.md      # UIUX stub — link when H-PLAN passed
    ├── api/
    │   └── WR-FEATURE-ALPHA.md      # Optional — client integration
    └── implement/
        └── frontend/
            └── README.md              # Agent writes WR-FEATURE-ALPHA.md here during tests
```

Use with `11-test-plan.md` HT-06 and FT-01–FT-04.