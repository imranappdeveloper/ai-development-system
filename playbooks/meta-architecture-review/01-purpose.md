# MS-architecture-review — Purpose

| Field | Value |
|-------|-------|
| skill_id | MS-architecture-review |
| name | Architecture Review |
| version | 0.1.0 |
| status | draft |
| document | 01-purpose |

## One-Liner

Review OS and playbook **architecture** for SRP, layering, and boundary violations — produce a scored review report; stop.

## When to Use

- Before Foundation freeze or skill `active` promotion
- After major DESIGN or STD changes
- When adding orchestrator or new phase model

## Produces

`REV-ARCH-{target}-{date}.md` — executive summary, dimension scores, P0/P1/P2, freeze recommendation.