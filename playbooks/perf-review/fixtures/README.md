# Performance Review Fixtures

| Path | Purpose |
|------|---------|
| `projects/wf-perf-alpha/` | WF-PERF fixture with CODE + PERF-BASE stubs for HT-06 / FT-01–FT-03 |

## Layout

```text
fixtures/projects/wf-perf-alpha/
├── CONTEXT.md
└── work/
    ├── WR-PERF-ALPHA.md
    ├── implement/backend/WR-PERF-ALPHA.md
    ├── performance/WR-PERF-ALPHA.md
    └── perf-review/README.md
```

Output directory `work/perf-review/` is empty until agent run — golden snapshot in `examples/golden/`.