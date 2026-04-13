# Auto-Verify Protocol

> Runs automatically after every build. Mandatory. No exceptions.

## Pipeline

```
typecheck --> lint --> build --> tests
```

## Behavior

1. After any code change, run the full pipeline
2. If any step fails: attempt fix (up to 3 attempts)
3. If fix succeeds: continue pipeline
4. If 3 attempts fail: **STOP** and report to user with diagnostic

## Commands (customize per project)

```bash
# TypeScript project example
npx tsc --noEmit          # typecheck
npx eslint .              # lint
npm run build             # build
npm test                  # tests
```

## Integration with Circuit Breaker

If Auto-Verify fails 3x on the same error, Circuit Breaker activates:
- Stop all work
- Generate diagnostic report
- Present to user with analysis
- Wait for user direction

## Critical Rules
- NEVER skip any step
- NEVER declare "done" if pipeline fails
- Fix attempts should be targeted, not shotgun
- Log failures in errors.md for future reference
