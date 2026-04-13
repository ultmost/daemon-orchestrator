# Session State

> Updated at the END of every session (Memory Flush protocol).
> Read at the START of every session to resume context.

## Last Session
- **Date**: 2026-04-12
- **Focus**: Launchpad - subscription billing flow

## Currently Working On
- Billing portal: Stripe Customer Portal integration. Backend route done (`/api/billing/portal`), frontend button wired, but redirect URL in Stripe dashboard still points to localhost. Need to update to production URL before testing.
- Petro Landing: client approved copy changes. Need to swap hero section text and update the CTA color from slate to amber.

## Pending Items
- [ ] Update Stripe Customer Portal return URL to `https://launchpad.app/dashboard/billing`
- [ ] Petro hero text swap (copy is in the Notion doc the client shared)
- [ ] Minerva review on billing route before merge
- [ ] Write Supabase migration for `subscription_status` column (discussed but not done yet)
- [ ] Test Stripe webhook locally with `stripe listen` before pushing billing changes

## Decisions Made Recently
- Chose Stripe Customer Portal over building custom billing UI. Saves 2 weeks and Stripe handles edge cases better.
- Petro: staying on static Next.js, no Supabase. Client has no need for dynamic content.

## Blockers
- Stripe Customer Portal redirect URL needs prod domain. Launchpad not on custom domain yet (still on vercel.app). Decided to use vercel.app URL for now.

## Next Session Should
- Start with Stripe Customer Portal URL fix (5 min task, unblocks billing)
- Then Petro hero copy swap
- Billing route is at `src/app/api/billing/portal/route.ts`
- Petro hero component is at `src/components/sections/Hero.tsx`
