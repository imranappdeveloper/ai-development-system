# Review Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-feature-alpha/` | WF-FEATURE workspace with CODE stub, ISS, PRD, TEST-PLAN ref, and REVIEW output directory |

## wf-feature-alpha layout

```text
wf-feature-alpha/
├── CONTEXT.md
└── work/
    ├── WR-FEATURE-ALPHA.md              # Work Record with CODE + ISS refs
    ├── prd/
    │   └── WR-FEATURE-ALPHA.md          # PRD stub for AC grounding
    ├── issues/
    │   └── ISS-BE-001.md                # ISS stub
    ├── implement/
    │   └── backend/
    │       └── WR-FEATURE-ALPHA.md      # CODE stub (H-IMPLEMENT approved)
    ├── testing/
    │   └── plan/
    │       └── README.md                # TEST-PLAN chain ref (PB-test-plan output)
    └── review/
        └── README.md                    # Agent writes WR-FEATURE-ALPHA.md here during tests
```

Use with `11-test-plan.md` HT-06 and FT-01–FT-03.

**Chain note:** CODE stub aligns with `playbooks/test-plan/fixtures/projects/wf-feature-alpha/` for quality-chain continuity.