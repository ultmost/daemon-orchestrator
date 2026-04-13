# Auto-Review Protocol

> Minerva + Severus run automatically before any delivery is declared "done".

## Flow

```
Build complete
    |
    v
Minerva Phase 1 (Spec Compliance)
    |
    v
Minerva Phase 2 (Code Quality)
    |
    v
[If touches auth/webhooks/payments/RLS]
    |
    v
Severus Security Audit
    |
    v
Minerva Phase 3 (Evidence)
    |
    v
All PASS? --> Declare "done"
Any FAIL? --> Fix and re-review
```

## When Severus is mandatory
- Any change to authentication flow
- Webhook handlers
- Payment processing
- RLS (Row Level Security) policies
- Secret/credential management
- API endpoints exposed to public

## Critical Rules
- NEVER declare "done" without review passing
- Severus findings graded CRITICAL block deployment
- Review findings include file:line references
- Fix -> re-review (don't skip second pass)
