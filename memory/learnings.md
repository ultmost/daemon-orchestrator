# Learnings Log

> Active learnings that Daemon needs to remember. Keep concise.
> Categories: correction, best_practice, knowledge_gap, tool_discovery, pattern

---

### [best_practice] Supabase: test RLS as anon, not service role (2026-03-20)
- **Context**: Wrote RLS policies, tested in Supabase Studio (which uses service role). Looked fine.
- **Learning**: Service role bypasses RLS entirely. All tests were meaningless.
- **Rule**: After writing any RLS policy, sign out and test as anon/authenticated user. Use `supabase.auth.signOut()` then retry. Also run `supabase db lint` to catch obvious policy gaps.

---

### [pattern] Next.js App Router: server components can't use useState (2026-03-22)
- **Context**: Hermione built a component with `useState` in a server component. TypeScript didn't catch it, only errored at runtime.
- **Learning**: The error message ("useState is not a function") is confusing. Root cause is always "missing 'use client' directive".
- **Rule**: Any component with hooks, event handlers, or browser APIs needs `'use client'` at the top. When in doubt, check: does it need interactivity? If yes, client component.

---

### [tool_discovery] pnpm why reveals phantom dependencies (2026-03-30)
- **Context**: Was getting a type error from a package I didn't install. Couldn't figure out where it came from.
- **Learning**: `pnpm why <package-name>` shows the full dependency tree that brought it in. Found it was a transitive dep of an older version of Radix UI.
- **Rule**: Use `pnpm why` before manually installing a package to see if it's already available.

---

### [correction] Vercel edge functions don't have Node.js APIs (2026-04-05)
- **Context**: Moved an API route to edge runtime for latency. It crashed because it used `fs` and `crypto`.
- **Learning**: Edge runtime runs V8 only. No `fs`, no `child_process`, limited `crypto`. Neville needs to check runtime compatibility before suggesting edge.
- **Rule**: Before moving anything to edge runtime, audit all imports. `fs`, `path`, `crypto`, `buffer` = Node.js only. Stick to Node.js runtime unless latency is proven bottleneck.

---

### [best_practice] Absorb ideas, don't stack tools (2026-04-10)
- **Context**: Evaluated 3 new "AI coding workflow" repos this week. All had interesting ideas.
- **Learning**: Most ideas can be absorbed as a rule in CLAUDE.md or a skill tweak. Installing a new tool adds complexity without proportional value.
- **Rule**: New tools only enter if they fill a gap nothing else covers. Cherry-pick patterns and rules, don't stack tools.
