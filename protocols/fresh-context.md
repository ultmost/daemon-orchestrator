# Fresh Context Protocol

> For long autonomous work: every phase starts clean, reads only persistent artifacts.

---

## The Problem: Context Rot

In long Claude Code sessions, context degrades:
- Early conversation details linger and create confusion
- Claude starts treating solved problems as open questions
- Reasoning from Phase 1 contaminates Phase 3 decisions
- The longer the session, the more noise competes with signal

**Symptom:** Claude making decisions that contradict earlier agreements, or re-solving problems already solved.

**Root cause:** Conversation history is not the same as persistent knowledge. Mixing them causes drift.

---

## The Solution: Clean Context Per Phase

Borrowed from Ralph's "one story per iteration" approach: each meaningful unit of work starts with a fresh context that reads only from persistent, structured files — not from conversation history.

**Key principle:** Persistent files are truth. Conversation is ephemeral.

---

## What to Persist (Source of Truth)

These files survive between contexts and are read at the start of each phase:

```
PROJECT.md          # What this project is, tech stack, key decisions
REQUIREMENTS.md     # What must be built, acceptance criteria
STATE.md            # Current phase, what's done, what's next, blockers
PLAN.md             # Current phase's task breakdown
```

**Rule:** If something matters beyond this conversation, it belongs in a file.

---

## What NOT to Carry Forward

Never treat conversation history as a reliable source for:
- Requirements ("you said earlier that...")
- Decisions ("we agreed to...")
- State ("we already finished...")
- Constraints ("you mentioned that X was off limits...")

If it's not in a persistent file, it didn't happen.

---

## How to Implement in Practice

### Phase Handoff Checklist

Before ending a phase or starting autonomous multi-phase work, ensure:

```
[ ] STATE.md updated: completed tasks, current blockers, next phase
[ ] REQUIREMENTS.md reflects any scope changes agreed during the phase
[ ] PLAN.md for next phase is written and scoped
[ ] session-state.md flushed (via Memory Flush protocol)
```

### Starting a Phase (Fresh Context)

At the start of each phase, Claude reads:

```
1. PROJECT.md       → What are we building?
2. REQUIREMENTS.md  → What must this phase deliver?
3. STATE.md         → What's already done? What's the current state?
4. PLAN.md          → What are the tasks for this phase?
5. errors.md        → What mistakes to avoid?
```

Then begins work — without relying on conversation history for any of the above.

### Daemon Workflow Integration

This protocol integrates with GSD (Get Stuff Done) skills:

```
gsd-discuss-phase → decisions in REQUIREMENTS.md
gsd-plan-phase    → tasks in PLAN.md
gsd-execute-phase → reads PLAN.md + STATE.md, updates STATE.md
gsd-verify-work   → reads REQUIREMENTS.md, validates against STATE.md
```

Each skill reads from files, not from conversation. This makes the pipeline robust to session length.

---

## File Templates

### STATE.md

```markdown
# State

**Last updated:** YYYY-MM-DD HH:MM
**Current phase:** Phase 2 — Backend API

## Completed
- [x] Phase 1: Project setup, DB schema, auth
- [x] Phase 2 (partial): User endpoints

## In Progress
- [ ] POST /api/checkout — 80% done, payment webhook pending

## Blockers
- Stripe test keys not configured yet

## Next
- Phase 3: Frontend — checkout flow
- Requires: Stripe keys, backend PASS
```

### REQUIREMENTS.md

```markdown
# Requirements

## Must Have (MVP)
1. User can sign up and log in
2. User can browse products
3. User can complete checkout (Stripe)

## Acceptance Criteria
- Checkout success rate > 99% in test mode
- Mobile responsive on 375px width
- Page load < 2s on 3G

## Out of Scope (explicit)
- Admin dashboard (Phase 2)
- Email notifications (Phase 2)
- Multiple currencies (TBD)
```

---

## When to Use This Protocol

| Situation | Use fresh context? |
|-----------|-------------------|
| Single task, short session | No — natural conversation flow is fine |
| Multi-phase build (3+ phases) | Yes — STATE.md + PLAN.md between phases |
| Autonomous work (gsd-autonomous) | Yes — mandatory, built into the GSD pipeline |
| Returning to a project after days away | Yes — re-read PROJECT.md + STATE.md before starting |
| Long debugging session | Partial — log findings to errors.md, reset context if > 1 hour |

---

## Inspiration

This pattern is based on Ralph's approach to iterative autonomous work, where each iteration gets a clean context and reads from structured artifacts. The core insight: **models don't have long-term memory; files do**. Build your workflow around that truth instead of fighting it.
