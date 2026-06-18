---
anti_pattern_id: FP-merge-decompose-into-prd
severity: P0
related_ec: EC-RT-11
---

# Anti-Pattern — Merge Decompose into PRD/FEAT

## What goes wrong

During `PB-draft-prd` or `PB-draft-feature`, agent embeds:

- Task lists with issue IDs
- Sprint-ready tickets
- Implementation checklists with owners and estimates

inside the PRD or FEAT document instead of running `PB-decompose-issues`.

## Symptoms

- H-DECOMPOSE skipped or rubber-stamped
- Plan doc bloated with execution detail
- PB-implement receives no ISS-* artifact paths
- CL-DECOMP never runs

## Correct pattern

| Document | Content |
|----------|---------|
| PRD / FEAT | Requirements, scope, acceptance criteria — **plan level** |
| ISS-* | Implementable units — **decompose level** via PB-decompose-issues |

## Prevention

- PB-draft-prd / PB-draft-feature non-responsibilities: issue breakdown
- CL-DRAFT: no ISS-* sections in plan artifacts
- Separate phase invoke after H-PLAN