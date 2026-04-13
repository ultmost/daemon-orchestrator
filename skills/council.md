---
name: council
description: Decision panel with multi-perspective debate - quick, duo, or full mode
triggers:
  - what do you think
  - should I
  - is it worth
  - A or B
  - which option
  - trade-off
  - dilemma
  - decision
modes:
  quick: 2 rounds, 3-4 voices (technical)
  duo: 2 opposing characters (binary choice)
  full: 6-8 voices (strategic)
---

# Council - Decision Panel

> 12-character debate panel for making decisions. Provides multi-perspective analysis.

## Triggers
- Any doubt, trade-off, "what do you think?"
- "should I?", "is it worth it?", "A or B?"
- "which option?", "compare options", "advice"
- "decision", "dilemma", "trade-off"

## Does NOT trigger on
- Speculative "what if" questions about consequences (that's What-If Oracle)

## Modes

### `--quick` (Technical decisions)
- 2 rounds, 3-4 voices
- Best for: stack choices, library selection, approach decisions
- Token-efficient

### `--duo` (A vs B)
- 2 opposing characters debate
- Best for: clear binary choices (pivot vs stay, accept vs reject)
- Most focused mode

### `full` (Strategic decisions)
- 6-8 voices, full round
- Best for: business strategy, partnerships, money, direction
- Most thorough

## Process
1. Present the decision clearly
2. Each character argues from their perspective
3. Characters can respond to each other
4. Synthesis with recommendation
5. Final vote/consensus

## Critical Rules
- Anti-recursion: if consensus is reached too quickly (all agreeing in < 2 rounds), FORCE a contrarian perspective. Easy consensus = blind spot
- Characters should genuinely disagree, not perform disagreement
- Present minority opinions even when there's a majority
- The user makes the final decision, not the council
