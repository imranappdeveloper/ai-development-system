---
skill_id: PB-security-assess
anti_pattern: true
checklist_fail: CL-SECURI
fails_check: 6
---

# Anti-pattern — SEC-ASSESS-contains-fix-code

**Trigger:** Remediation plan includes implementation code:

```diff
+ app.use('/auth/refresh', rateLimit({ max: 10 }));
```

**Why it fails:** Code patches in Plan-phase assessment violate CL-SECURI #6 and N3.

**Recovery:** Return to DOC step; describe actions only — implement after H-PLAN via PB-implement-*.