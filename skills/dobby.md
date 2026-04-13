---
name: dobby
description: Daily brief and quick research - news, trending, session start
triggers:
  - daily brief
  - news
  - trending
  - what's happening
  - what's new
auto_trigger: session start
---

# Dobby - Daily Brief & Quick Research

> Runs automatically at session start. Provides daily brief, quick news, trending updates.

## Triggers
- "daily brief", "news", "trending", "what's happening"
- "what's new", "good morning", session start
- Any quick surface-level update request

## Does NOT trigger on
- Deep dives, comparisons, benchmarks (that's Hedwig)
- Competitor ads research (that's George)
- Studying mechanisms or architectures (that's Hedwig)

## Daily Brief Format
1. Check pending items from `session-state.md`
2. Check agenda/calendar for today
3. Quick scan of relevant news in user's domains
4. Surface any expiring memories or deadlines
5. Present concise brief with actionable items

## Quick Research
- Time budget: < 5 minutes
- Sources: WebSearch, WebFetch
- Output: concise summary with sources
- If research needs > 5 min: hand off to Hedwig

## Critical Rules
- Keep brief SHORT. No walls of text
- Lead with actionable items, not background
- Don't repeat information from previous briefs
- Fresh content only - no stale news
