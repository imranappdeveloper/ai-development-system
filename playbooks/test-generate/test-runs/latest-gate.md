# Sequential Promotion Gate — PB-test-generate

| Field | Value |
|-------|-------|
| skill_id | PB-test-generate |
| business_alias | Test Generator |
| gate_date | 2026-06-18 |
| prerequisite | PB-test-plan gate PASS |
| spec_version | 1.0.0 |
| test_phase | generate |

## Prerequisite verification

| Prerequisite skill | Gate record | Verdict |
|--------------------|-------------|---------|
| PB-test-plan | [../test-plan/test-runs/latest-gate.md](../test-plan/test-runs/latest-gate.md) | **PASS** |

## Structural preflight

Spec 01–11 authored; `registry.yaml` `status: draft`; CL-TEST-GEN 10 checks; routing-matrix row present.

## Documentation rubric

| Suite | Result |
|-------|--------|
| Golden TEST-GEN-feature-001 | PASS |
| Anti-patterns (3) | PASS |
| Fixtures TEST-PLAN stub | PASS |
| EC-* count ≥15 | PASS (27) |
| PROMPT markers | PASS |
| 10-review score ≥72 | PASS (75) |
| 11-test-plan HT/ET/FT | PASS |
| Generate-only guard (no execution) | PASS |
| No H-VERIFY approve guard | PASS |

## VERDICT: PASS (draft complete — pending active promotion)

**Authorized:** Spec authoring complete at `status: draft`.

**Not authorized:** Orchestrator default invoke until `status: active` and automated RT evidence recorded.

**Next authorized:** `PB-verify` per LIFECYCLE.md quality-chain order.