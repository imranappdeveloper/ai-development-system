# Documentation Plan Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-docs-alpha/` | WF-DOCS fixture with approved INT only (no CODE/PERF-REVIEW required) |

## Layout

```text
fixtures/projects/wf-docs-alpha/
├── CONTEXT.md
├── README.md
└── work/
    ├── WR-DOCS-ALPHA.md
    ├── intake/WR-DOCS-ALPHA.md
    └── doc-plan/README.md
```

Output directory `work/doc-plan/` is empty until agent run — golden snapshot in `examples/golden/`.