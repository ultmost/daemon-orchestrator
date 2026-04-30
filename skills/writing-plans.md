---
name: writing-plans
description: Generates a detailed implementation plan from a PRD or spec. Maps file structure, decomposes into bite-sized tasks (2-5 min each) with complete code in every step, no placeholders.
triggers:
  - plan
  - implementation plan
  - breakdown
  - break into tasks
  - file structure
  - tasks list
  - detailed plan
  - before coding
  - decomposition
---

# Writing Plans - Detailed Implementation Plan

> Takes an approved spec/PRD and generates a plan that an engineer with **zero codebase context** can execute. Every task = complete code, exact paths, exact commands. No TBD, no "implement later".

## Stack
- Output: Markdown plan in `docs/plans/YYYY-MM-DD-<feature-name>.md`
- Compatible with any builder (frontend or backend)

## Triggers
- An approved PRD or spec exists
- Feature touches 3+ files
- Structural refactor
- BEFORE delegating to a builder

## Does NOT trigger on
- PRD itself (use the PRD skill)
- Feasibility research (use research skill)
- Choosing between approaches (use decision/council skill)
- Single simple 1-file task (delegate directly)
- Bug fix (use diagnose)

## Where to Save

`docs/plans/YYYY-MM-DD-<feature-name>.md` at the project root.

If the project has a different convention in its CLAUDE.md or contributing guide, follow that.

## Non-negotiable Principles

1. **Zero placeholders.** No "TBD", "implement later", "add validation here"
2. **Complete code in every code step.** If a step changes code, show the entire code to alter/create
3. **Exact paths.** `src/components/checkout/PaymentForm.tsx`, not "the payment component"
4. **Exact commands with expected output.** `npx vitest run tests/foo.test.ts` -> "Expected: PASS, 3 tests"
5. **DRY, YAGNI, frequent commits.** Each task ends in a commit
6. **Bite-sized.** Each step = 1 action of 2-5 min

## Process

### Step 1 - Scope Check

Read the PRD/spec. Ask:
- Does it cover multiple independent sub-systems? (e.g., dashboard + checkout + admin)
- If YES -> recommend splitting into separate plans, one per sub-system. Each plan ships testable software on its own.
- If NO -> continue.

### Step 2 - File Structure (ARCHITECTURAL LOCK-IN)

Before defining tasks, map WHICH files will be created/modified and the responsibility of each.

```markdown
## File Structure

### Create
- `src/lib/checkout/calculate-total.ts` - pricing logic (single responsibility)
- `src/lib/checkout/calculate-total.test.ts` - unit tests

### Modify
- `src/app/api/checkout/route.ts:42-78` - calls calculate-total
- `src/components/CheckoutForm.tsx:120-145` - displays computed total
```

**Decomposition rules:**
- Each file = 1 clear responsibility
- Files that change together live together (split by responsibility, not by technical layer)
- In an existing codebase, follow the established pattern. Don't restructure unilaterally
- If a file grew monstrous, OK to include a split in the plan

### Step 3 - Plan Header

Every plan starts with:

```markdown
# [Feature Name] - Implementation Plan

> **For builders:** required skill = a frontend builder or backend builder per task. After each task: auto-verify + auto-review. Use checkboxes (`- [ ]`) to track.

**Goal:** [1 sentence of what it builds]

**Architecture:** [2-3 sentences on the approach]

**Stack:** [key technologies: Next.js 15, Postgres, Stripe, Zod, etc.]

**Branch:** [branch name, if applicable]

---
```

### Step 4 - Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `src/lib/foo/bar.ts`
- Modify: `src/app/api/baz/route.ts:42-78`
- Test: `src/lib/foo/bar.test.ts`

**Builder:** Frontend | Backend | Mixed

- [ ] **Step 1: Write the failing test**

```typescript
// src/lib/foo/bar.test.ts
import { describe, it, expect } from 'vitest'
import { calculateTotal } from './bar'

describe('calculateTotal', () => {
  it('sums items with discount applied', () => {
    const result = calculateTotal([{ price: 100 }, { price: 50 }], 0.1)
    expect(result).toBe(135)
  })
})
```

- [ ] **Step 2: Run the test to confirm it fails**

Command: `npx vitest run src/lib/foo/bar.test.ts`
Expected output: FAIL with "calculateTotal is not defined"

- [ ] **Step 3: Implement the minimum to pass**

```typescript
// src/lib/foo/bar.ts
export function calculateTotal(items: { price: number }[], discount: number): number {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0)
  return subtotal * (1 - discount)
}
```

- [ ] **Step 4: Run the test to confirm it passes**

Command: `npx vitest run src/lib/foo/bar.test.ts`
Expected output: PASS, 1 test

- [ ] **Step 5: Auto-verify**

Command: `npx tsc --noEmit && npx next lint && npm run build`
Expected output: all PASS

- [ ] **Step 6: Commit**

```bash
git add src/lib/foo/bar.ts src/lib/foo/bar.test.ts
git commit -m "feat(checkout): add calculateTotal helper"
```
````

### Step 5 - No Placeholders Policy

These are **plan failures** - NEVER write:

| Anti-pattern | Reality |
|---|---|
| "TBD", "TODO", "implement later" | Plan isn't ready, don't delegate |
| "Add appropriate error handling" | Show the exact error handler code |
| "Add validation" | Show the Zod schema / the exact if |
| "Handle edge cases" | List the edge cases and show the code |
| "Write tests for the above" (no code) | Show the test code |
| "Similar to Task N" | REPEAT the code (engineer may read out of order) |
| "Do X" without code | If a step changes code, show the code |
| References to types/functions not defined in any task | Define them or reference an exact path |

### Step 6 - Self-Review (mandatory)

After writing the full plan, review against the spec with fresh eyes:

1. **Spec coverage.** Each spec requirement -> is there a task that implements it? List gaps.
2. **Placeholder scan.** Search the plan for: TBD, TODO, "later", "appropriate", "etc". Fix.
3. **Type consistency.** Function called `clearLayers()` in Task 3 and `clearFullLayers()` in Task 7 = bug. Verify names/signatures.
4. **Dependency order.** Task 5 uses an export from Task 2? OK. Task 5 uses an export from Task 8? Reorder.

Found a problem -> fix inline. Don't re-review, fix and continue.

### Step 7 - Save + Handoff

1. Save to `docs/plans/YYYY-MM-DD-<feature-name>.md`
2. Commit the plan: `git add docs/plans/... && git commit -m "docs: add plan for X"`
3. Report:

```
PLAN SAVED: docs/plans/YYYY-MM-DD-<feature>.md

Summary:
- Tasks: N
- Files to create: X
- Files to modify: Y
- Stack: [list]

Next step: delegate Task 1 to the builder?
```

## Critical Rules

- NEVER ship a plan with placeholders. The plan must run 100% as written.
- NEVER skip the self-review step. It catches 60% of bugs before coding.
- NEVER use "Similar to Task N" - repeat the code. Engineers read tasks out of order.
- ALWAYS show the exact test command and expected output.
- ALWAYS end each task in a commit.
- Each step = 2-5 minutes. If bigger, split.

## Anti-patterns

| Temptation | Reality |
|---|---|
| "Generic plan, builder will figure out details" | They won't. Zero-context builders don't infer. Show the code. |
| "Task: implement the checkout" | Giant granularity = builder errs. Break into 5-10 bite-sized tasks. |
| "Skip tests, add later" | Test-first lock-in. Left for the end, doesn't happen. |
| "No self-review, it's quick" | Self-review catches 60% of bugs before coding. 5 min now saves 30 later. |
| "Don't need to show test command" | Show it. Builder doesn't know if it's vitest or jest in this project. |
| "Refs instead of complete code" | Engineer reads out of order. Repeat the code. |

## Quick Reference

| Step | Activity | Criterion |
|---|---|---|
| 1. Scope | Split into sub-plans if multi-subsystem | 1 plan = 1 testable sub-system |
| 2. File structure | Map files to create/modify | Each file = 1 responsibility |
| 3. Header | Goal + architecture + stack | 3-5 lines at the top |
| 4. Tasks | Bite-sized 2-5 min, complete code | Zero-context builder executes without asking |
| 5. No placeholders | No TBD/TODO/"later" | Plan runs 100% as written |
| 6. Self-review | Coverage + placeholders + types | Inline, no subagent |
| 7. Save | `docs/plans/YYYY-MM-DD-<feature>.md` | Commit the plan |
