# Memory Flush Protocol

> Persist session state before ending. Next session picks up seamlessly.

## When to flush
- Before ending any session
- Before context window compression
- When user says "goodbye", "done for today", "stopping"

## What to persist in session-state.md

```markdown
## Session State - [DATE]

### Currently Working On
- [task description, current status]

### Pending Items
- [ ] [item 1 - what's left to do]
- [ ] [item 2]

### Decisions Made This Session
- [decision 1 with context]

### Blockers
- [anything blocking progress]

### Next Session Should
- [first thing to do next time]
```

## What to update
- `session-state.md`: current state and pending items
- `errors.md`: any new errors encountered (if not already logged)
- `learnings.md`: any new learnings discovered (if not already logged)
- `decisions.md`: any significant decisions made

## Critical Rules
- MANDATORY. No session ends without flush
- Keep entries concise but complete
- Include enough context for cold-start next session
- Clean up completed items from previous sessions
