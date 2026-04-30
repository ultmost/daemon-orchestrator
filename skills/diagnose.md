---
name: diagnose
description: Disciplined investigation of bugs, failures, persistent errors, and performance regressions. Builds a feedback loop before proposing a cause, generates 3-5 ranked falsifiable hypotheses, instruments with tagged logs, writes a regression test before the fix.
triggers:
  - diagnose
  - debug
  - bug
  - broken
  - error
  - not working
  - failure
  - failing
  - regression
  - slow
  - bad performance
  - persistent error
  - fix didn't work
  - build failing
  - test failing
  - unexpected behavior
---

# Diagnose - Disciplined Bug Investigation

> **Iron Law**: NO FIX WITHOUT BUILDING THE FEEDBACK LOOP FIRST.

A bug with a reproducible loop is 90% solved. Without a loop, no amount of code reading resolves it. This skill enforces the inversion: **build the signal before proposing the cause**.

## Stack
- Language/framework agnostic
- Test runners, debuggers, REPLs, headless browsers, profilers

## Triggers
- Test failing, bug in production, unexpected behavior
- Performance regression, build broken, integration broken
- Error that appeared after a recent change, error that returned after a "fix"

USE ESPECIALLY when:
- Under time pressure (emergency invites guessing)
- "It's a quick fix, I know what it is"
- Already tried 2+ fixes without resolving
- Previous fix didn't work
- You don't fully understand the problem

## Does NOT trigger on
- New feature (use a builder)
- Polish UI (use frontend builder)
- Code review of finished work (use reviewer)
- Security audit (use security skill)
- Full app QA (use QA skill)

## The Six Phases

Each phase is a gate. Don't skip. Violating the letter of the process is violating the spirit.

---

### PHASE 1 - BUILD THE FEEDBACK LOOP

**This IS the skill.** Everything after is mechanical. Good loop = bug 90% solved.

Spend disproportionate effort here. Be aggressive. Creative. Don't give up.

#### Techniques in order of preference

1. **Failing test** at the seam that reaches the bug (unit, integration, e2e)
2. **Curl / HTTP script** against running dev server
3. **CLI invocation** with fixture, diff stdout against known-good snapshot
4. **Headless browser script** (Playwright) - drives UI, asserts DOM/console/network
5. **Replay captured trace** - save real request/payload/event log, replay isolated
6. **Throwaway harness** - minimal subset of system with mocked deps, exercises bug in one call
7. **Property / fuzz loop** - for "sometimes wrong", run 1000 random inputs
8. **Bisection harness** - bug between known states (commit, dataset, version), `git bisect run`
9. **Differential loop** - same input on old vs new, diff outputs
10. **HITL bash script** - last resort. Human clicks, but structure captures output

#### Iterate on the loop

The loop is the product. Ask:
- Faster? (cache setup, skip unrelated init, smaller scope)
- Sharper signal? (assert the specific symptom, not "didn't crash")
- More deterministic? (fix time, seed RNG, isolate fs, freeze network)

Flaky 30s loop = almost no loop. Deterministic 2s loop = superpower.

#### Non-deterministic bug

Goal isn't a clean repro, it's a **high reproduction rate**:
- Loop the trigger 100x, parallelize, add stress, narrow timing window, inject sleeps
- Bug failing 50% = debuggable; 1% = not. Push the rate up until it's debuggable.

#### Multi-component: instrument per layer

When the system has multiple layers (CI -> build -> signing, API -> DB -> trigger):

BEFORE proposing a fix, add logs at each boundary:

```
For EACH component boundary:
  - Log data going IN
  - Log data going OUT
  - Verify env/config propagation
  - Check state at each layer

Run once to collect evidence of WHERE it breaks
THEN analyze to identify the failing component
THEN investigate that specific component
```

Example:
```typescript
console.log('[DEBUG-a4f2] route input', body)
const { data, error } = await db.from('x').insert(body)
console.log('[DEBUG-a4f2] db result', { data, error })
```

This reveals which layer breaks before you guess.

#### When you genuinely can't build a loop

Stop and speak up. List what you tried. Ask the user for:
1. Access to an environment that reproduces, OR
2. Captured artifact (HAR, log dump, core dump, screen recording with timestamps), OR
3. Permission to add temporary instrumentation in production

**Do NOT proceed to Phase 2 without a loop you trust.**

---

### PHASE 2 - REPRODUCE

Run the loop. Watch the bug appear.

Confirm:
- [ ] Loop produces the failure the user described, NOT a neighboring failure. Wrong bug = wrong fix.
- [ ] Reproducible across multiple runs (or rate high enough to debug)
- [ ] Exact symptom captured (error message, wrong output, timing) so later phases can verify the fix actually addresses it

Do NOT proceed without reproducing.

---

### PHASE 3 - HYPOTHESES (3-5 ranked, falsifiable)

Generate **3-5 ranked hypotheses** BEFORE testing any of them. Single hypothesis = anchored on the first plausible idea.

Each hypothesis must be **falsifiable**: state the prediction.

Format:
> "If <X> is the cause, then <changing Y> makes the bug disappear / <changing Z> makes it worse."

If you can't state the prediction, it's vibes. Discard or sharpen.

**Show the ranked list to the user before testing.** They have domain knowledge that re-ranks instantly ("just touched #3"), or hypotheses already discarded. Cheap checkpoint, saves time. Don't block - go with your ranking if user is AFK.

---

### PHASE 4 - INSTRUMENT

Each probe maps to a specific Phase 3 prediction. **Change ONE variable at a time.**

Preference:
1. **Debugger / REPL** if environment supports it. One breakpoint > 10 logs.
2. **Targeted logs** at the boundaries that distinguish hypotheses.
3. NEVER "log everything and grep".

**Tag EVERY debug log** with a unique prefix, e.g. `[DEBUG-a4f2]`. Cleanup at the end = one grep. Untagged logs survive; tagged ones die.

**Performance branch.** For perf regressions, logs usually miss. Do:
1. Establish baseline (timing harness, `performance.now()`, profiler, query plan, `EXPLAIN ANALYZE`)
2. Bisect

Measure first, fix later.

---

### PHASE 5 - FIX + REGRESSION TEST

Write the regression test **BEFORE the fix** - but only if a **correct seam** exists.

Correct seam = the test exercises the **real pattern of the bug** as it occurs at the call site. If the available seam is too shallow (single-caller test when the bug needs multi-caller, unit test that doesn't replicate the chain that triggers the bug), a regression test there gives false confidence.

**If no correct seam exists, that IS the finding.** Note it. The codebase architecture is blocking the bug from being pinned. Flag for Phase 6.

If a correct seam exists:
1. Turn the minimized repro into a failing test at that seam
2. See it fail (RED)
3. Apply the fix
4. See it pass (GREEN)
5. Re-run the Phase 1 loop against the ORIGINAL (non-minimized) scenario

#### If 3+ fixes failed: question the architecture

Pattern indicating an architectural problem:
- Each fix reveals shared state / coupling / new problem in a different place
- Fixes ask for "massive refactor" to implement
- Each fix creates a new symptom elsewhere

STOP and question fundamentals:
- Is this pattern fundamentally sound?
- Are we persisting from sheer inertia?
- Refactor architecture > continue patching symptoms?

**Discuss with the user before attempting fix #4.**

This is NOT the wrong hypothesis. It's the wrong architecture. Trigger circuit-breaker (3x same error = OPEN).

---

### PHASE 6 - CLEANUP + POST-MORTEM

Required before declaring done:
- [ ] Original repro NO LONGER reproduces (re-run Phase 1 loop)
- [ ] Regression test passes (or absence of seam documented as a finding)
- [ ] All `[DEBUG-...]` instrumentation removed (`grep -r '\[DEBUG-' src/`)
- [ ] Throwaway prototypes deleted (or moved to a marked debug location)
- [ ] Winning hypothesis is in the commit / PR message - so the next debugger can learn
- [ ] Auto-verify ran PASS (typecheck -> lint -> build -> tests)
- [ ] Auto-review approved (reviewer agent)

**Final question**: what would have prevented this bug? If the answer involves an architectural change (no test seam, tangled callers, hidden coupling), open an issue / recommend a refactor. Make the recommendation **AFTER** the fix is in, not before.

---

## Red Flags - STOP AND FOLLOW THE PROCESS

These thoughts mean STOP:

| Thought | Reality |
|---|---|
| "Quick fix now, I'll investigate later" | You won't. Investigate now. |
| "Just change X and see if it works" | Guess. Build the loop. |
| "Multiple changes together, run the tests" | Doesn't isolate what worked. Causes new bugs. |
| "Skip the test, I'll verify manually" | Manual QA fails. Test now. |
| "Probably X, let me fix it" | Probably = guess. Proving = build the loop. |
| "I don't fully understand but this might work" | Will spawn 2 new bugs. Stop. |
| "Pattern says X but I'll adapt" | Partial adaptation guarantees a bug. Read fully first. |
| "Here are the main problems: [list of fixes without investigating]" | List of guesses. Back to Phase 1. |
| "One more fix" (after 2+ failed) | 3+ failures = architecture. Not fix #4. |
| "Each fix reveals a problem elsewhere" | Architectural signal, not wrong hypothesis. |

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "It's simple, doesn't need the process" | Simple bugs have root causes too. Process is fast for simple bugs. |
| "Emergency, no time" | Systematic diagnosis is FASTER than guess-and-check. |
| "Try this first, then investigate" | First fix becomes the pattern. Do it right from the start. |
| "I'll write tests after seeing the fix work" | Fix without test doesn't fix. Test first proves it. |
| "Multiple fixes saves time" | Doesn't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees a bug. Read fully. |
| "I see the problem, let me fix it" | Seeing the symptom != understanding the root cause. |
| "One more fix" (after 2+ failed) | 3+ failures = architectural problem. Question it. |

## Quick Reference

| Phase | Activities | Success Criterion |
|---|---|---|
| 1. Feedback Loop | Build fast deterministic pass/fail signal | A loop you trust |
| 2. Reproduce | Run loop, see bug appear | Bug appears, symptom captured |
| 3. Hypotheses | 3-5 ranked falsifiable | List shown to user |
| 4. Instrument | Targeted probes, 1 variable at a time, tagged logs | Hypothesis confirmed or new one |
| 5. Fix + Regression | Test BEFORE fix, original loop re-runs PASS | Bug resolved, tests pass |
| 6. Cleanup | Logs removed, post-mortem, hypothesis in commit | Ready to deliver |

## Critical Rules

- NEVER fix without a feedback loop you trust.
- NEVER skip writing the regression test (or document the missing seam as a finding).
- NEVER attempt fix #4 if 2+ failed - escalate to architecture.
- ALWAYS tag debug logs with a unique prefix and grep them out at the end.
- ALWAYS change one variable at a time when instrumenting.
