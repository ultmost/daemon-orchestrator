---
name: architect
description: Finds DEEPENING opportunities (shallow modules to deep modules) in a codebase to improve testability and AI-navigability. Applies deletion test, proposes consolidation of tightly-coupled modules, suggests ports/adapters when needed.
triggers:
  - refactor
  - architecture
  - improve architecture
  - structural code smell
  - shallow module
  - deep module
  - deepening
  - consolidate modules
  - simplify codebase
  - testability
  - hard to test
  - AI-navigability
  - hard to navigate
  - large codebase
  - structural refactor
---

# Architect - Deepening Opportunities

> Finds opportunities to turn shallow modules into deep ones. Goal: testability + AI-navigability.

Stance: **propositional, not defensive**. Reviewers are defensive (review code vs spec). Architect is propositional (proposes structural changes).

## Stack
- Language-agnostic
- Works on any codebase with module boundaries

## Triggers
- "refactor X", "improve architecture"
- Codebase hard to test or navigate
- New feature blocked by structural coupling
- Shallow module flagged by code review
- Diagnose phase 6 signals "architectural problem"

## Does NOT trigger on
- Code review of finished work vs spec (use code reviewer)
- Specific bug, regression (use diagnose)
- Security (use security skill)
- New greenfield feature (use writing-plans then a builder)
- Small rename (builder direct)

## Glossary (use these terms verbatim)

- **Module** - anything with interface + implementation. Function, class, package, slice. Scale-agnostic.
- **Interface** - EVERYTHING a caller needs to use the module: types, invariants, error modes, call ordering, config, performance characteristics. Not just signature.
- **Implementation** - code inside the module. Distinct from Adapter.
- **Depth** - leverage on the interface: lots of behavior behind a small interface = **deep**; interface as complex as the implementation = **shallow**.
- **Seam** - where the interface lives. Place where behavior can be altered without editing in-place.
- **Adapter** - concrete thing that satisfies an interface at a seam.
- **Leverage** - what callers gain from depth (capability per unit of interface learned).
- **Locality** - what maintainers gain from depth (change, bug, knowledge concentrated in one place).

## Key Principles

### Deletion Test
Imagine deleting the module:
- Complexity disappears? It was pass-through, didn't deserve to exist.
- Complexity reappears in N callers? It was earning its keep. Keep it.

### The Interface Is the Test Surface
Callers and tests cross the same seam. If you want to test PAST the interface, the module has the wrong shape.

### One Adapter = Hypothetical Seam. Two Adapters = Real Seam.
Don't introduce a port/seam "just in case." Wait until at least 2 justified adapters exist (typically: production + test).

### Depth != line ratio
Depth is leverage on the interface, not "big implementation divided by small interface." Implementation padding doesn't count.

## Process

### 1. Explore

Read in order:
1. Project README / docs / ADRs (`docs/adr/` if it exists)
2. Repo structure
3. Stack conventions

Walk the codebase and note **friction points**:
- Where does understanding 1 concept require jumping between N small modules?
- Where are modules **shallow** (interface ~ implementation)?
- Where were pure functions extracted only for tests, but the real bug lives in HOW they're called? (no locality)
- Where are tightly-coupled modules leaking through their seams?
- Which parts have no tests, or are hard to test through the current interface?

Apply **deletion test** on every shallow suspect.

### 2. Present Candidates (numbered)

For each candidate:

```
N. [Name of the module to deepen]

Files: [list of files involved]

Problem: [why current architecture creates friction]

Solution: [plain description of what would change]

Benefits:
- Locality: [what concentrates in one place]
- Leverage: [what callers gain]
- Tests: [how they get simpler / survive refactor]

Dependency category: [in-process / local-substitutable / remote but owned / true external]
```

DO NOT propose interface yet. Ask the user: **"Which of these do you want to deepen?"**

### 3. Dependency Categories (drive test strategy)

#### a) In-process
Pure computation, in-memory state, no I/O. Always deepen-able: merge modules, test through interface directly. No adapter.

#### b) Local-substitutable
Has local stand-in for tests (PGLite for Postgres, in-memory fs). Deepen-able if stand-in exists. Tests use stand-in inside the test suite. Internal seam, no external port.

#### c) Remote but owned (Ports & Adapters)
Your own services across a network boundary (microservices, internal APIs). Define a **port** (interface) at the seam. Deep module holds the logic; transport is injected as an **adapter**. Tests use in-memory adapter. Production uses HTTP/gRPC/queue adapter.

Recommendation shape: *"Define a port at the seam, implement an HTTP adapter for production and an in-memory adapter for tests, so the logic lives in a deep module even when deployed cross-network."*

#### d) True external (Mock)
Third parties you don't control (Stripe, Twilio). Deepened module receives the dependency as an injected port; tests provide a mock adapter.

### 4. Grilling Loop (after the user picks a candidate)

Walk the design tree with them:
- Constraints
- Dependencies
- Shape of the deepened module
- What lives behind the seam
- Which tests survive

#### Inline side effects during the conversation

- **User rejects candidate with load-bearing reason?** Offer: *"Want to log this as an ADR in `docs/adr/` so the next architectural review doesn't re-suggest it?"* Only offer if the reason would help a future explorer avoid re-suggesting. Skip ephemeral ("not worth it now") and self-evident reasons.
- **Naming the deepened module with a new term?** If the project has a glossary file, add the term. If not, don't force creating one.

### 5. Test Strategy: Replace, Don't Layer

When deepening:
- Old unit tests on shallow modules become trash once interface tests on the deepened module exist. **Delete them.**
- Write new tests AGAINST THE INTERFACE of the deepened module. The interface is the test surface.
- Tests assert outcomes observable through the interface, not internal state.
- Tests survive internal refactors. If a test changes when the implementation changes, it's testing past the interface.

### 6. Final Output

Deliver a refactor plan (do NOT execute directly):

```
ARCHITECT: deepening proposal - [module name]

Scope:
- Files to consolidate/move: [list]
- Files to delete (shallow tests): [list]
- Files to create (port, adapters, new tests): [list]

Proposed interface:
[code block with TypeScript interface]

Dependency category: [a/b/c/d]
Test strategy: [stand-in / port+adapter / mock]

Required adapters:
- Production: [description]
- Test: [description]

Risks:
- [list]

Next step: invoke writing-plans to generate detailed plan, then delegate Task 1 to a builder.
```

## Critical Rules

- Architect proposes; it does NOT implement. Builders implement.
- Use the glossary verbatim. No "boundary", "service", "component" synonyms.
- One adapter = hypothetical. Wait for 2 justified adapters before introducing a port.
- Pass-through modules can be OK (interop layer). Apply deletion test instead of deleting reflexively.
- Delete the shallow tests when interface tests exist. Don't layer.
- If 3+ fixes failed in `diagnose`, that's an architectural signal - architect investigates instead of patching.

## Anti-patterns

| Temptation | Reality |
|---|---|
| "Create a port for every dependency" | One adapter = hypothetical. Wait for 2 justified adapters. |
| "Deepen for theoretical cleanliness" | Without real friction, deepening is over-engineering. |
| "Shallow module is always bad" | Pass-through is sometimes OK. Apply deletion test. |
| "Massive refactor without a plan" | Architect proposes; writing-plans breaks down; builders implement. |
| "Keep old + new tests" | Shallow test becomes trash when interface test exists. Delete. |
| "Boundary / service / component" | Use the glossary: module, interface, seam, adapter. |
| "Architect implements too" | No. Architect proposes. Builders implement. |

## Quick Reference

| Step | Activity | Criterion |
|---|---|---|
| 1. Explore | Walk codebase, note friction | List of shallow candidates |
| 2. Candidates | Number with files/problem/solution/benefits/dep category | User picks 1 |
| 3. Grilling | Walk the design tree | Shape of deepened module decided |
| 4. Test strategy | Stand-in / port+adapter / mock | Driven by dep category |
| 5. Output | Refactor plan for writing-plans to consume | Files, interface, adapters, risks |
