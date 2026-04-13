# PRD - Product Requirements Document Generator

> Creates formal PRDs with user stories, acceptance criteria, and MVP scope.

## Triggers
- "PRD", "create PRD", "write PRD"
- "requirements document", "feature requirements"
- "user stories", "acceptance criteria"
- "feature spec", "MVP scope"

## Does NOT trigger on
- Infrastructure requirements
- Package dependencies
- Study plans
- Content plans

## Output Structure
1. **Overview**: Problem statement, target users, goals
2. **User Stories**: As a [user], I want [goal], so that [benefit]
3. **Acceptance Criteria**: Testable conditions per story
4. **MVP Scope**: What's in v1, what's deferred
5. **Technical Constraints**: Stack, integrations, limitations
6. **Success Metrics**: How to measure if it worked

## Critical Rules
- Keep user stories focused and testable
- Acceptance criteria must be verifiable (not vague)
- MVP = minimum. Cut aggressively
- Include what's explicitly OUT of scope
