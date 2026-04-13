# ProofShot - Visual Verification

> Captures visual proof of frontend deliveries. Screenshots, JS errors, navigation recording.

## Triggers
- **AUTOMATIC** after any frontend delivery (Hermione or not)
- Never needs manual invocation

## Process
1. Navigate to the delivered page via browser
2. Capture full-page screenshots (desktop + mobile)
3. Check browser console for JS errors
4. Record key interactions (clicks, hovers, navigation)
5. Generate proof artifacts (screenshots + error log)
6. If errors detected: fix BEFORE showing to user

## Output
- Desktop screenshot
- Mobile screenshot
- Console error log (if any)
- Navigation recording (if applicable)

## Critical Rules
- Runs on EVERY frontend delivery, no exceptions
- Errors found = fix before declaring "done"
- Screenshots are proof of work, not decoration
- Don't declare "done" without visual evidence
