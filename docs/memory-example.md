# Memory Example (Filled)

> This shows what the memory system looks like after a few weeks of real use.
> Copy this pattern — replace the content with your own context.
> The key is specificity. Vague entries don't help Claude.

---

## What ~/daemon-memory/MEMORY.md looks like

```markdown
# Daemon - Memory Index

## Boot (READ before every session)
- Pending items: `session-state.md` section "PENDING ITEMS". Bring them up in the brief.
- Recent errors: `errors.md` (last 3 entries) - READ BEFORE any technical task
- Learnings: `learnings.md` - consult BEFORE coding, prevents repeating mistakes
- Recent decisions: `decisions.md` (last 3 entries)

---

## About Me
- Full-stack developer, 4 years. Strong on frontend, backend is newer territory.
- Stack: Next.js 14 (App Router), TypeScript, Tailwind, Supabase, Vercel
- I like direct answers. Skip the preamble. Show me the code.
- Working across 2 active products + 1 client site

## Active Projects
- **Launchpad** (Priority #1): SaaS boilerplate I'm selling. Stripe subscriptions, Supabase
  auth, admin dashboard. Path: ~/projects/launchpad/
- **Petro Landing** (Priority #2): Landing page for a client in the oil equipment niche.
  Static Next.js, no auth. Path: ~/projects/petro-landing/
- **Personal site**: Portfolio + blog. Deprioritized. Path: ~/projects/personal/

## Rules (cross-project)
- NEVER mix project databases. Launchpad = supabase-launchpad MCP. Petro = no Supabase.
- Always use TypeScript. Never `any` unless explicitly approved.
- Conventional commits: feat:, fix:, chore:, docs: prefixes
- Run `pnpm typecheck && pnpm lint` before every commit
- No inline styles. Tailwind classes only. Exception: dynamic values via CSS vars.
- When unsure about a lib's API, check Context7 first (training data may be stale)

## Feedbacks (learned from past sessions)
- Do NOT rewrite an entire component to fix one prop. Surgical edits only.
- When I say "clean this up" I mean remove dead code, not refactor the architecture.
- Integration tests must hit real Supabase, not mocks. We burned 2h on false-passing mocks.
- Always check src/components/ui/ before creating a new component.

## Critical Limits
- ISOLATION between Launchpad and Petro. Different clients, different keys, different deploys.
- Never commit .env.local or .env.production. Both in .gitignore but double-check.
- Stripe webhook handler: test with `stripe listen --forward-to` BEFORE touching production.
```

---

## What ~/daemon-memory/errors.md looks like

```markdown
# Error Log

### [bug] Stripe webhook 400 on production only (2026-03-28)
- **What happened**: Webhooks worked in dev with `stripe listen`, silently failed in prod.
  Orders weren't being fulfilled.
- **Root cause**: Production webhook secret was different from .env.production. I had rotated
  it in Stripe dashboard but forgot to update Vercel env vars.
- **Fix**: Updated STRIPE_WEBHOOK_SECRET in Vercel dashboard, redeployed.
- **Prevention**: After any Stripe secret rotation, immediately check Vercel env vars.
  Add to deploy checklist.

---

### [bug] Supabase RLS blocked legitimate admin queries (2026-04-02)
- **What happened**: Admin dashboard showed 0 rows for all users. Looked like a UI bug.
- **Root cause**: Wrote RLS policies, tested with service role key (bypasses RLS). When
  dashboard used anon key, all queries returned empty.
- **Fix**: Added auth.role() = 'authenticated' check + admin role policy.
- **Prevention**: ALWAYS test RLS with anon key after writing policies. Never trust tests
  done with service role key.

---

### [regression] Tailwind classes disappeared after pnpm upgrade (2026-04-08)
- **What happened**: After upgrading to Tailwind v4, most utility classes stopped working.
  Build passed but styles were missing.
- **Root cause**: Tailwind v4 changed config format. Old tailwind.config.ts was silently ignored.
- **Fix**: Migrated to CSS-based config (@import "tailwindcss" in globals.css).
- **Prevention**: Before upgrading major versions of styling libs, read the migration guide.
  Never upgrade Tailwind without reading the changelog.
```

---

## What ~/daemon-memory/learnings.md looks like

```markdown
# Learnings Log

### [best_practice] Supabase: test RLS as anon, not service role (2026-03-20)
- **Context**: Wrote RLS policies, tested in Supabase Studio (which uses service role).
- **Learning**: Service role bypasses RLS. All tests were meaningless.
- **Rule**: After writing any RLS policy, sign out and test as anon user.
  Use supabase.auth.signOut() then retry the query.

---

### [pattern] Next.js App Router: server components can't use useState (2026-03-22)
- **Context**: Hermione built a component with useState in a server component.
  TypeScript didn't catch it — only errored at runtime.
- **Learning**: Error message ("useState is not a function") is confusing. Root cause
  is always "missing 'use client' directive".
- **Rule**: Any component with hooks, event handlers, or browser APIs needs 'use client'
  at the top. When in doubt: does it need interactivity? If yes, client component.

---

### [tool_discovery] pnpm why reveals phantom dependencies (2026-03-30)
- **Context**: Getting a type error from a package I didn't install.
- **Learning**: pnpm why <package-name> shows the full dep tree that brought it in.
- **Rule**: Use pnpm why before manually installing a package — it might already be available.

---

### [best_practice] Absorb ideas, don't stack tools (2026-04-10)
- **Context**: Evaluated 3 new AI workflow repos this week.
- **Learning**: Most ideas can be absorbed as a rule in CLAUDE.md or a skill tweak.
- **Rule**: New tools only enter if they fill a gap nothing else covers. Cherry-pick
  patterns, don't install the whole thing.
```

---

## What ~/daemon-memory/session-state.md looks like

```markdown
# Session State

## Last Session
- **Date**: 2026-04-12
- **Focus**: Launchpad - subscription billing flow

## Currently Working On
- Billing portal: Stripe Customer Portal integration. Backend route done
  (src/app/api/billing/portal/route.ts), frontend button wired, but redirect URL in
  Stripe dashboard still points to localhost. Need to update before testing.
- Petro Landing: client approved copy changes. Need to swap hero section text and
  update CTA color from slate to amber.

## Pending Items
- [ ] Update Stripe Customer Portal return URL to https://launchpad.app/dashboard/billing
- [ ] Petro hero text swap (copy in client's Notion doc)
- [ ] Minerva review on billing route before merge
- [ ] Write Supabase migration for subscription_status column (discussed, not done yet)
- [ ] Test Stripe webhook locally with stripe listen before pushing billing changes

## Decisions Made Recently
- Chose Stripe Customer Portal over custom billing UI. Saves 2 weeks, Stripe handles edge cases.
- Petro: staying on static Next.js, no Supabase. Client has no need for dynamic content.

## Blockers
- Stripe Customer Portal redirect needs prod domain. Using vercel.app URL for now.

## Next Session Should
- Start with Stripe Customer Portal URL fix (5 min, unblocks billing)
- Then Petro hero copy swap
- Billing route: src/app/api/billing/portal/route.ts
- Petro hero component: src/components/sections/Hero.tsx
```

---

## What ~/daemon-memory/decisions.md looks like

```markdown
# Decision Log

### Stripe Customer Portal vs custom billing UI (2026-04-11)
- **Decision**: Use Stripe Customer Portal for subscription management
- **Context**: Needed billing portal for Launchpad users to manage their subscriptions,
  update payment methods, cancel
- **Alternatives**: Build custom billing UI with Stripe API directly
- **Rationale**: Customer Portal handles all edge cases (failed payments, dunning, prorations,
  invoice history). Building it custom = 2 weeks minimum. Portal = 1 day.
- **Outcome**: Integrated. Users can manage billing. Saved estimated 2 weeks of work.

---

### pnpm vs npm for Launchpad (2026-03-15)
- **Decision**: pnpm for all new projects
- **Context**: npm install was consistently slow on CI. Evaluating alternatives.
- **Alternatives**: npm (familiar), yarn (complex workspaces), bun (immature ecosystem)
- **Rationale**: pnpm is 2-3x faster on CI due to content-addressable store. workspace support
  is solid. The team already uses it for one project.
- **Outcome**: All new projects use pnpm. CI time dropped from ~3min to ~80s.
```

---

## Tips for keeping memory healthy

**Add to errors.md immediately when something breaks.** The longer you wait, the less detail you remember. Even a one-liner is better than nothing.

**Be specific in MEMORY.md.** "I like TypeScript" is not useful. "TypeScript strict mode, no `any` unless approved, always use `satisfies` for config objects" is useful.

**Session state is a handoff note to your future self.** Write it as if you're explaining the context to someone who's never seen the project. Because in 48 hours, that's effectively true.

**Keep MEMORY.md under 200 lines.** Claude loads it every session. Long = expensive + diluted. If it gets long, move stable facts to a separate file and reference it from MEMORY.md.

**Prune errors.md every few weeks.** Old, irrelevant errors add noise. Archive them to an `errors-archive.md` file and keep only the last 10-15 entries in the active log.
