# Playbook Contract Scaffold

Copy this folder to `playbooks/<kebab-name>/` when creating a new skill.

```bash
cp -r playbooks/_contract-scaffold playbooks/<kebab-name>
```

Then replace all `PB-<kebab-name>` placeholders and fill per **STD-SKILL-001** (`standards/SKILL-CONTRACT.md`).

## After copy

1. Set `skill_id` in every file metadata table
2. Complete `01-purpose.md` → `11-test-plan.md`
3. Add `registry.yaml` enums and routing
4. Create `checklists/<kebab-short>.md`
5. Register in `INDEX.md` and `routing-matrix.yaml`
6. Run promotion gate before `status: active`