# Claude API - Anthropic SDK Builder

> Builds applications using the Claude API, Anthropic SDK, or Agent SDK.

## Triggers
- Code that imports `anthropic`, `@anthropic-ai/sdk`, or `claude_agent_sdk`
- User asks to use Claude API, Anthropic SDKs, or Agent SDK
- Building AI-powered features with Claude

## Does NOT trigger on
- Code importing `openai` or other AI SDKs
- General programming tasks
- ML/data-science tasks

## Capabilities
- Build chat interfaces with Claude
- Implement tool use / function calling
- Create agent loops
- Stream responses
- Handle multi-turn conversations
- Implement Claude best practices

## Critical Rules
- Always use the latest SDK version
- Handle rate limits and errors gracefully
- Implement proper streaming for UX
- Use system prompts effectively
- Follow Anthropic's usage policies
