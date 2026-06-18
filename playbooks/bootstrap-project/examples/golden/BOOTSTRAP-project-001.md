---
scenario_id: HT-04
skill_id: PB-bootstrap-project
prompt_version: 1.0.0
inputs:
  work_id: WR-PROJECT-NEW
  project_root: fixtures/projects/wf-project-new
  artifact_refs:
    - type: PRD
      path: work/prd/WR-PROJECT-NEW.md
expected_outputs:
  artifact_path: work/scaffold/WR-PROJECT-NEW.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-onboard-project
---

---
document_id: SCAFFOLD-WR-PROJECT-NEW
work_id: WR-PROJECT-NEW
workflow_id: WF-PROJECT-NEW
scaffold_scope: standard
scaffold_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T14:00:00Z
upstream_prd_path: work/prd/WR-PROJECT-NEW.md
upstream_arch_path: work/architecture/WR-PROJECT-NEW.md
---

# SCAFFOLD — Inventory API greenfield bootstrap

## Summary

Bootstrap plan for a Node.js + PostgreSQL inventory API per approved PRD and ARCH — directory layout, toolchain pins, and ordered setup commands. No application code in this artifact.

## Directory Plan

```
inventory-api/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   ├── routes/
│   └── db/
├── prisma/
│   └── schema.prisma
├── tests/
├── .github/workflows/ci.yml
└── README.md
```

## Toolchain

| Component | Choice | Source |
|-----------|--------|--------|
| Runtime | Node 20 LTS | PRD §3 |
| Language | TypeScript 5.x | ARCH |
| ORM | Prisma | ARCH data layer |
| DB | PostgreSQL 16 | PRD §3 |

## Bootstrap Steps

| Step | Action | Verify |
|------|--------|--------|
| 1 | `mkdir inventory-api && cd inventory-api` | dir exists |
| 2 | `npm init -y && npm i typescript ts-node @types/node` | package.json |
| 3 | `npx prisma init` | prisma/schema.prisma |
| 4 | Copy CI workflow template from SCAFFOLD manifest | workflow file present |
| 5 | Human: create repo remote and push | git remote -v |

## File Manifest

| Path | Purpose |
|------|---------|
| package.json | Dependencies and scripts |
| tsconfig.json | TS compiler options |
| prisma/schema.prisma | Initial entity stubs per PRD |
| .github/workflows/ci.yml | Lint + test pipeline skeleton |

## References

| artifact | path |
|----------|------|
| PRD | work/prd/WR-PROJECT-NEW.md |
| ARCH | work/architecture/WR-PROJECT-NEW.md |

## Open Questions

| # | Question | Owner |
|---|----------|-------|
| 1 | Monorepo vs single package? | Human at H-PLAN |

## Human Approval

| gate_id | H-PLAN |
| decision | pending |
