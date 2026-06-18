# PB-<kebab-name> — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-<kebab-name> |
| version | 0.1.0 |
| status | draft |
| document | 04-io-contract |

---

## Contract rule

Undocumented I/O is forbidden. See **STD-SKILL-001** §5–§6.

---

## Input summary

| Category | IDs |
|----------|-----|
| Invocation | IN-01–09 |
| Human / request | IN-10–19 |
| Environment | IN-20–29 |
| OS artifacts | IN-30–39 |
| Project artifacts | IN-40–49 |
| Revise loop | IN-50–59 |
| Orchestrator | IN-60–69 |

## Output summary

| ID | Name | Required |
|----|------|----------|
| OUT-01 | Primary artifact | yes |
| OUT-02 | Work Record | yes |
| OUT-03 | Validation Record | yes |
| OUT-04 | Handoff Package | yes |
| OUT-05 | Escalation Package | conditional |

## Invoke template

```yaml
mode: new | resume | revise
work_id: WR-###
project_root: /absolute/path
ai_dev_os_home: /data/project/ai-development-system
# skill-specific inputs below
```