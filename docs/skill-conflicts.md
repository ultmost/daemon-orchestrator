# Skill Conflicts and Hybrid Requests

## The problem

Some requests don't cleanly map to one skill. "Build a login form with a JWT API" is both frontend (Hermione) and backend (Neville). "Review this auth route for security issues" is both code review (Minerva) and security audit (Severus).

This document explains how Daemon handles these cases.

---

## How hybrid requests are handled

### Pattern 1: Sequential delegation

The most common pattern. Daemon identifies the dominant context, delegates to the primary skill, then hands off to the secondary skill.

**Example: "Build a user profile page that saves to the database"**

```
Daemon identifies:
  - Primary: UI + form = Hermione
  - Secondary: API route + DB = Neville

Execution order:
  1. Hermione builds the ProfileForm component (frontend)
  2. Neville builds /api/profile/update route + DB migration (backend)
  3. Hermione wires the form to the API endpoint
  4. Auto-Verify runs once for the whole thing
  5. Minerva reviews the combined diff
```

Daemon announces the split upfront: "This touches both frontend and backend. I'll have Hermione build the UI, then Neville handle the API route."

---

### Pattern 2: Parallel context

When two skills operate on the same deliverable simultaneously.

**Example: "Add authentication to this Next.js app"**

```
Daemon identifies:
  - Hermione: login page, UI components, form validation
  - Neville: auth API routes, session handling, middleware
  - Severus: auto-triggers because this is auth (payment/auth = auto security)

Execution order:
  1. Neville defines the auth architecture first (shapes what Hermione builds)
  2. Hermione builds the login/signup pages against that architecture
  3. Severus runs the security checklist on the auth implementation
  4. Minerva reviews the full diff
```

Architecture-first matters: Neville defines the API contract before Hermione builds the UI that calls it. This prevents the UI being rebuilt when the API shape changes.

---

### Pattern 3: Quality stack

When multiple quality skills apply at once.

**Example: "Review my payment webhook before I ship it"**

```
Daemon identifies:
  - Minerva: code quality review (always on "review" requests)
  - Severus: auto-triggers (payment = security-sensitive)

Execution order:
  1. Minerva: Phase 1 (spec compliance) + Phase 2 (code quality) + Phase 3 (evidence)
  2. Severus: OWASP checklist, injection, secrets, auth flow
  3. Combined verdict: PASS / FAIL with specific findings

Both run. Their findings are separate but presented together.
```

---

## Priority rules

When the intent is ambiguous, Daemon picks the primary skill using these rules:

| Signals in the request | Primary skill |
|------------------------|---------------|
| File extensions: `.tsx`, `.css`, `.html`, UI words | Hermione |
| File extensions: `.ts` (API route), database words, `route.ts` | Neville |
| "Review", "check", "before commit", "diff" | Minerva |
| "Security", "vulnerability", auth/payment context | Severus |
| "Should I", "A or B", "what do you think" | Council |

**The dominant context rule:** When a `.tsx` file is open and the user says "fix this", Hermione activates. When a `route.ts` is open and the user says "fix this", Neville activates. The open file context wins.

---

## Overriding routing manually

If Daemon picks the wrong skill, you can override explicitly:

```
"Use Neville for this" → forces backend skill
"This is a Hermione task" → forces frontend skill
"Just review it with Minerva, don't touch the code" → forces review only
```

You can also scope the task explicitly to prevent a hybrid split:

```
"Build only the UI for now, I'll do the API later" → Hermione only
"Review only the backend routes, not the components" → Minerva on specific files
```

---

## What NOT to expect

**Daemon does not run skills in true parallel.** It's a single conversation thread. "Parallel" means sequential with clear handoffs, not simultaneous execution.

**Skills don't have state between each other.** Hermione doesn't know what Neville built unless Daemon explicitly passes the context ("Neville built the API at `/api/profile`. Hermione, wire the form to that endpoint.").

**Routing isn't magic.** For very ambiguous requests, Daemon will ask: "This touches both UI and API — should I handle the frontend first or define the API contract first?" This is correct behavior, not a failure.

---

## Real examples of hybrid routing

### "Build a contact form that sends emails"
- Hermione: Contact form component, validation, loading state
- Neville: `/api/contact` route, email sending via Resend/SendGrid
- Severus: auto-checks the API route for rate limiting and input sanitization
- Sequence: Neville defines the API shape → Hermione builds against it → Severus reviews

### "Add Google login to the app"
- Neville: OAuth callback route, session handling, Supabase auth config
- Hermione: "Sign in with Google" button, loading state, redirect handling
- Severus: auto-triggers (auth = security-sensitive), checks token storage
- Sequence: Neville builds backend first → Hermione adds button → Severus audits

### "Is our current auth approach secure?" (review only, no build)
- Minerva: code quality review of auth routes
- Severus: OWASP checklist against the implementation
- Sequence: both run, combined report

### "Should we use JWT or sessions for auth?"
- Council: decision mode (--quick or --duo depending on complexity)
- No build skills involved until decision is made
- Sequence: Council debates → user decides → then Neville implements
