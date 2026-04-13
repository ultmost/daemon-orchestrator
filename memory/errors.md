# Error Log

> Log errors as they happen. Read BEFORE every technical task.
> Keep only recent/relevant entries. Archive old ones.
> Format: date, what happened, root cause, fix, prevention rule.

---

### [bug] Stripe webhook 400 on production only (2026-03-28)
- **What happened**: Webhooks worked in dev with `stripe listen`, silently failed in prod. Orders weren't being fulfilled.
- **Root cause**: Production webhook secret was different from the one in `.env.production`. I had rotated it in Stripe dashboard but forgot to update Vercel env vars.
- **Fix**: Updated `STRIPE_WEBHOOK_SECRET` in Vercel dashboard, redeployed.
- **Prevention**: After any Stripe secret rotation, immediately check Vercel/Railway env vars. Add to deploy checklist.

---

### [bug] Supabase RLS blocked legitimate admin queries (2026-04-02)
- **What happened**: Admin dashboard showed 0 rows for all users. Looked like a UI bug, was actually RLS.
- **Root cause**: I wrote RLS policies testing with the service role key (bypasses RLS). When the dashboard used the anon key, all queries returned empty.
- **Fix**: Added `auth.role() = 'authenticated'` check + admin role policy.
- **Prevention**: ALWAYS test RLS with anon key after writing policies. `supabase.auth.signOut()` then retry the query. Never trust tests done with service role.

---

### [regression] Tailwind classes disappeared after pnpm upgrade (2026-04-08)
- **What happened**: After upgrading to Tailwind v4, most utility classes stopped working. Build passed but styles were missing.
- **Root cause**: Tailwind v4 changed the config format. The old `tailwind.config.ts` was silently ignored.
- **Fix**: Migrated to the new CSS-based config (`@import "tailwindcss"` in globals.css). Removed `tailwind.config.ts`.
- **Prevention**: Before upgrading major versions of styling libs, check migration guide first. Never upgrade Tailwind without reading the changelog.

---

### [infra] Declared "done" without testing on mobile (2026-03-19)
- **What happened**: Shipped the pricing page. Client reported it was broken on iPhone. Horizontal scroll, text overflow, CTA button hidden below fold.
- **Root cause**: I tested only on desktop Chrome. Hermione built it correctly but I never verified on real mobile.
- **Fix**: Fixed overflow, adjusted padding, tested on BrowserStack iOS Safari.
- **Prevention**: "Done" for any landing/marketing page = tested on iPhone Safari AND Android Chrome. ProofShot must include mobile viewport.
