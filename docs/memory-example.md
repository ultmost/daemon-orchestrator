# Memory Example (Filled)

> This shows what a real MEMORY.md looks like after a few weeks of use.
> Copy this pattern for your own setup.

---

# Daemon - Memory Index

## Boot (READ before every session)
- Pending items: `session-state.md` section "PENDING ITEMS"
- Recent errors: `errors.md` (last 3 entries)
- Learnings: `learnings.md` (consult BEFORE coding)
- Recent decisions: `decisions.md` (last 3 entries)

## About the User
- Senior full-stack developer, 5 years experience
- Prefers TypeScript, Next.js, Supabase stack
- Likes concise responses, no fluff
- Works on 3 projects simultaneously

## Active Projects
- **ProjectAlpha**: E-commerce platform. Priority #1. Path: ~/projects/alpha/
- **ProjectBeta**: Internal dashboard. Priority #2. Path: ~/projects/beta/
- **ProjectGamma**: Mobile API. Priority #3. Path: ~/projects/gamma/

## Rules
- NEVER mix projects. Each has its own database and deploy target
- Always run tests before committing
- Use conventional commits format
- Portuguese for user-facing strings, English for code
- No emojis in UI components

## Feedbacks
- Don't summarize what you just did after every response (user reads the diff)
- Integration tests must hit real database, not mocks
- Always check existing components before creating new ones

---

# Example errors.md entry:

### [bug] Auth redirect loop on mobile Safari (2026-03-15)
- **What happened**: Users on iOS couldn't log in - infinite redirect
- **Root cause**: Safari blocks third-party cookies by default, session cookie not persisting
- **Fix**: Switched to URL-based session token for mobile browsers
- **Prevention**: Always test auth flows on Safari/iOS before shipping

---

# Example learnings.md entry:

### [best_practice] Supabase RLS: test as anonymous user (2026-03-20)
- **Context**: Shipped feature with RLS policies that looked correct
- **Learning**: RLS policies passed in admin view but failed for anon users - was testing with service role key
- **Rule**: After writing RLS, ALWAYS test with anon key: `supabase.auth.signOut()` then try the query

---

# Example session-state.md:

## Last Session
- **Date**: 2026-04-10
- **Focus**: ProjectAlpha checkout flow redesign

## Currently Working On
- Checkout page v2 - 3-step form with address validation
- Step 1 (customer info) done, Step 2 (shipping) in progress

## Pending Items
- [ ] Finish shipping step with address autocomplete
- [ ] Add payment step (Stripe integration)
- [ ] Minerva review before merge
- [ ] Update TestLog with checkout conversion baseline

## Next Session Should
- Continue from shipping step - component is at src/app/checkout/step-2.tsx
- Address API key is in .env.local (GOOGLE_MAPS_KEY)
