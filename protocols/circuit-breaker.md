# Circuit Breaker Protocol

> Prevents infinite error loops. Stops work and generates diagnostics.

## Trigger Conditions

### Error Loop
- 3x same error in sequence --> **STOP**
- Generate diagnostic: what failed, why, what was tried

### Progress Stall
- 3x attempts with no measurable progress --> **STOP**
- Generate diagnostic: what's blocking, what alternatives exist

### Resource Loop
- Repeated API calls returning same error --> **STOP**
- Don't retry the same failing call endlessly

## Diagnostic Report

When Circuit Breaker activates, generate:

```markdown
## Circuit Breaker Activated

**Trigger:** [error-loop | progress-stall | resource-loop]
**Error:** [description]
**Attempts:** [what was tried, 3x]
**Root Cause Analysis:** [best guess]
**Suggested Alternatives:**
1. [alternative approach 1]
2. [alternative approach 2]
3. [ask user for direction]
```

## Critical Rules
- NEVER brute-force past the breaker
- Always present alternatives, not just the problem
- Log the incident in errors.md
- User decides next step, not Daemon
