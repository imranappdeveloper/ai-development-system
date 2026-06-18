# Mobile Implement Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-feature-alpha-mobile/` | WF-FEATURE mobile workspace with ISS + UIUX stub, WR, and CODE output directory |

## wf-feature-alpha-mobile layout

```text
wf-feature-alpha-mobile/
├── CONTEXT.md
└── work/
    ├── WR-FEATURE-ALPHA-MOBILE.md     # Work Record with ISS + UIUX refs
    ├── issues/
    │   └── ISS-MOB-001.md             # Mobile ISS stub
    ├── uiux/
    │   └── WR-FEATURE-ALPHA-MOBILE.md # UIUX stub (soft required)
    ├── api/
    │   └── WR-FEATURE-ALPHA.md        # Optional — data-fetch grounding
    └── implement/
        └── mobile/
            └── README.md              # Agent writes WR-FEATURE-ALPHA-MOBILE.md here during tests
```

Use with `11-test-plan.md` HT-06 and FT-01–FT-04.