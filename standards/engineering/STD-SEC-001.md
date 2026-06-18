# STD-SEC-001 — Security

| Field | Value |
|-------|-------|
| standard_id | STD-SEC-001 |
| version | 1.0.0 |
| status | active |
| owner | Security Lead |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Minimum security rules for OS authoring, agent execution, and artifact handling — not a full corporate security policy.

## Scope

- Secrets, PII, credentials in artifacts and prompts
- Safe context loading boundaries
- Excludes: security assessment delivery (**PB-security-assess**), application threat modeling in target repos

## Rules

### Secrets (MUST NOT)

- Store API keys, passwords, tokens, private keys in any OS or `work/` markdown
- Commit `.env` contents to fixtures or goldens
- Pass secrets in `raw_request` without redaction in INT

### Redaction (MUST)

- Use `[REDACTED]` placeholder in INT/DISC/handoff when input contains PII/secrets
- Document redaction in validation record when applied
- EC-SEC-* edge cases in playbooks implement this standard — not redefine it

### Context forbidden (MUST)

Align with **STD-CTX-001**: never load `.env`, `*.pem`, `credentials.*`, password managers from disk.

### Dependency supply chain (SHOULD)

- OS repo: pin tool versions when CI exists; document in CHANGELOG
- Implement skills: prefer locked dependency files in target project — out of OS scope but review flag per **STD-REVIEW-001**

### Least privilege (MUST)

- Agents receive `project_root` boundary only
- No cross-tenant project paths in envelope
- Waivers logged in WR `approvals[]`

### Human gates (MUST)

Security-impacting work routes through `WF-SECURITY` and `PB-security-assess` when `active` — interim: INT `work_type: security` + human H-PLAN.

## Examples

```yaml
# Good INT excerpt
stakeholder_email: "[REDACTED]"
```

```yaml
# Bad fixture
api_key: sk-live-abc123
```

## Exceptions

- Local dev fixtures MAY use obviously fake values (`sk-test-fake`) marked in fixture README
- Encrypted secret stores in target project are out of OS scope — agents MUST NOT read them
- Security research skill MAY reference CVE IDs and public advisories at T3

## Validation

| Check | Pass |
|-------|------|
| S-SEC-01 | M-MD-03 secret scan clean |
| S-SEC-02 | Goldens/fixtures contain no live patterns |
| S-SEC-03 | Redaction noted when input had PII |
| S-SEC-04 | Forbidden paths in 05-context.md |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-CTX-001 | Forbidden paths |
| STD-MD-001 | No secrets in markdown |
| STD-MEM-001 | No secrets in WR/ORS |
| STD-PROMPT-001 | NEVER list includes no exfiltration |
| STD-REVIEW-001 | P0 security findings |
| STD-LOG-001 | No secrets in logs |