# Pomfrey - QA Health Check

> Tests the entire app as a real user via browser. Generates health reports.

## Triggers
- "test everything", "QA", "health check"
- "verify the app", "smoke test", "e2e"
- "test the site"

## Process
1. Read PRD/docs to understand expected features
2. Discover all routes and features
3. Test each feature via MCP Browser as a real user
4. Click every link, fill every form, test every flow
5. Log failures with screenshots
6. Generate HEALTH-REPORT.md with pass/fail per feature

## Output: HEALTH-REPORT.md
- Feature inventory (what exists)
- Test results per feature (PASS/FAIL)
- Screenshots of failures
- JS console errors captured
- Recommended fixes prioritized by severity

## Critical Rules
- Test as a REAL USER, not as a developer
- Click every link, don't assume it works
- Test on mobile viewport too
- Check for: 404s, broken images, console errors, layout breaks
- "Pronto" requires ALL features PASS
