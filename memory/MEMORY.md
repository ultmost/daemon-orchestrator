# Daemon - Memory Index

> This file is loaded into conversation context every session.
> Keep it concise. Lines after 200 will be truncated.
> Only links to memory files with brief descriptions. No content here.

## Boot (READ before every session)
- Pending items: `session-state.md` section "PENDING ITEMS". Bring them up in the brief.
- Recent errors: `errors.md` (last 3 entries) - READ BEFORE any technical task
- Learnings: `learnings.md` - consult BEFORE coding, prevents repeating mistakes
- Recent decisions: `decisions.md` (last 3 entries)
- Orchestration rules: `protocols/orchestration-rules.md`

---

## About Me
- Full-stack developer, 4 years. Strong on frontend, backend is newer territory.
- Stack: Next.js 14 (App Router), TypeScript, Tailwind, Supabase, Vercel
- I like direct answers. Skip the preamble. Show me the code.
- Working across 2 active products + 1 client site

## Active Projects

- **Launchpad** (Priority #1): SaaS boilerplate I'm selling. Stripe subscriptions, Supabase auth, admin dashboard. Path: `~/projects/launchpad/`
- **Petro Landing** (Priority #2): Landing page for a client in the oil equipment niche. Static Next.js, no auth. Path: `~/projects/petro-landing/`
- **Personal site**: Portfolio + blog. Deprioritized. Path: `~/projects/personal/`

## Rules (cross-project)
- NEVER mix project databases. Launchpad = `supabase-launchpad`. Petro = no Supabase.
- Always use TypeScript. Never `any` unless explicitly approved.
- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:` prefixes
- Run `pnpm typecheck && pnpm lint` before every commit
- No inline styles. Tailwind classes only. Exception: dynamic values via CSS vars.
- When unsure about a lib's API, check Context7 first (my training data may be stale)

## Feedbacks (from past sessions)
- Do NOT rewrite an entire component to fix one prop. Surgical edits only.
- When I say "clean this up" I mean remove dead code, not refactor the architecture.
- Integration tests must hit real Supabase, not mocks. We burned 2 hours on false-passing mocks in March.
- Always check `src/components/ui/` before creating a new component. I have a lot already.

## Critical Limits
- ISOLAMENTO between Launchpad and Petro. Different clients, different keys, different deploys.
- Never commit `.env.local` or `.env.production`. Both are in `.gitignore` but double-check.
- Stripe webhook handler: test with `stripe listen --forward-to` BEFORE touching production.
