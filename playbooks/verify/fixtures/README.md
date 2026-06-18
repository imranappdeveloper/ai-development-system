# Verify Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-feature-alpha/` | WF-FEATURE workspace with TEST-PLAN, TEST-GEN, and CODE stubs for execution tests |

## wf-feature-alpha layout

```text
wf-feature-alpha/
├── CONTEXT.md
└── work/
    ├── WR-FEATURE-ALPHA.md              # Work Record with TEST-PLAN + TEST-GEN refs
    ├── prd/
    │   └── WR-FEATURE-ALPHA.md          # PRD stub for AC grounding
    ├── issues/
    │   └── ISS-BE-001.md                # ISS stub
    ├── implement/
    │   └── backend/
    │       └── WR-FEATURE-ALPHA.md      # CODE stub (H-IMPLEMENT approved)
    └── testing/
        ├── plan/
        │   └── WR-FEATURE-ALPHA.md      # TEST-PLAN stub
        ├── generate/
        │   └── WR-FEATURE-ALPHA.md      # TEST-GEN stub
        └── README.md                    # Agent writes WR-FEATURE-ALPHA.md here (TEST-RPT)
```

Use with `11-test-plan.md` HT-06 and FT-01–FT-03.