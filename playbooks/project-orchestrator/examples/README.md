# Orchestrator Examples

Regression fixtures for prompt and spec validation per `11-test-plan.md`.

| Path | Type | Purpose |
|------|------|---------|
| `golden/ORS-tick-intake-hold-001.md` | Golden | ORS state after intake tick with H-INTAKE hold |
| `anti-patterns/ORCH-auto-chain.md` | Anti-pattern | Auto-chaining playbooks without human tick |
| `anti-patterns/ORCH-self-approve-gate.md` | Anti-pattern | Agent approves human gate |
| `anti-patterns/ORCH-skip-ors.md` | Anti-pattern | Tick without ORS persistence |

**Usage:** Compare agent output structure to golden; anti-patterns must trigger CL-ORCH or NEVER violations.