# PB-test-generate — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | TEST-PLAN linked; PB-test-plan gate PASS; CODE soft or waiver |
| P2 | Load TEST-PLAN + CODE + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Resolve TC-* catalog from TEST-PLAN §3 | Every in-scope TC-* addressed (generate, skip, or defer) |
| P4 | Generate test source files | Files written per CONTEXT conventions and CODE §6 |
| P5 | Map TC-* to file paths | §3 Generated Files Catalog complete |
| P6 | Document fixtures and helpers | §4 Fixtures Generated when plan references fixtures |
| P7 | Produce TEST-GEN (OUT-01) | Complete per 04-io-contract; `test_phase: generate` |
| P8 | Update Work Record | Link TEST-GEN; `test_gen_pending_review` |
| P9 | Run CL-TEST-GEN | Validation record = pass |
| P10 | Prepare handoff | `recommended_next_skill: PB-verify`; alternate PB-review; **no H-VERIFY approve** |

### file_action enum

| file_action | Meaning |
|-------------|---------|
| `created` | New test file written this session |
| `updated` | Existing test file modified |
| `skipped` | TC-* covered by existing test — no write |
| `existing` | File pre-existed; referenced only |
| `deferred` | TC-* not generated — documented reason (e.g. integration needs DB) |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference CODE §6 Testing Notes | Avoid duplicate or conflicting tests |
| S2 | Flag plan gaps blocking generation | `plan_alignment: requires_plan_revise` |
| S3 | Note deferred layers from TEST-PLAN §2.1 | §5 Gaps / Deferred populated |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Generate fixture modules referenced in TEST-PLAN §8 | When `data fixtures` paths listed |
| O2 | Suggest splitting generation by `target_issue_id` | TC count exceeds session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify CODE (implementation) | PB-implement-* |
| N3 | Rewrite TEST-PLAN strategy or AC mapping | PB-test-plan |
| N4 | Execute test commands (`pytest`, `npm test`, etc.) | PB-verify |
| N5 | Populate execution evidence or pass/fail counts | PB-verify |
| N6 | Approve H-VERIFY or advance to ship | Human after PB-verify |
| N7 | Auto-invoke next playbook | Human / orchestrator |
| N8 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N9 | Implement application fixes | PB-implement-* |
| N10 | Modify OS repository files | OS maintainer |
| N11 | Store decisions only in chat | Must persist TEST-GEN |
| N12 | Self-approve verification | Human at H-VERIFY |
| N13 | Skip CL-TEST-GEN or file path catalog | Never |
| N14 | Copy secrets into test files or TEST-GEN | Redact `[REDACTED]` |
| N15 | Claim tests pass without execution | PB-verify |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| TEST-GEN draft | proposes | reviews catalog completeness |
| Test file generation | proposes | reviews code quality via PB-review |
| `code_gap: waiver` | documents | authorizes proceed without CODE |
| H-VERIFY approve | **never** | after PB-verify TEST-RPT only |
| Next playbook | recommends PB-verify | approves chain |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-test-plan | skill (soft) | TEST-PLAN + prerequisite gate PASS |
| CODE | artifact (soft) | Implementation context when linked |
| CL-TEST-GEN | checklist | Handoff blocker |
| STD-TEST-001 | standard | Test documentation |
| STD-TEST-002 | standard | Strategy layers & file conventions |
| PB-test-plan gate record | prerequisite | `test-runs/latest-gate.md` VERDICT PASS |