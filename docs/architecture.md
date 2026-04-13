# Daemon Architecture

## Three Layers

### Layer 1: Orchestration (CLAUDE.md)
The brain. Defines routing rules, skill registry, protocols, and behavioral guidelines. Loaded every session as system instructions.

### Layer 2: Execution (Skills)
The hands. 17 specialized agents, each with clear scope, triggers, and processes. Skills are invoked by the orchestrator based on context, never directly by the user.

### Layer 3: Persistence (Memory)
The memory. File-based system that persists across sessions: errors, learnings, decisions, session state, and user preferences.

## Data Flow

```
User message
    |
    v
Daemon (CLAUDE.md) analyzes context
    |
    v
Routes to appropriate skill
    |
    v
Skill executes (may use MCP servers)
    |
    v
Auto-Verify pipeline runs
    |
    v
Auto-Review (Minerva + Severus if needed)
    |
    v
ProofShot (if frontend)
    |
    v
Delivery to user
```

## Design Principles

### 1. Orchestrator Never Codes
Daemon thinks, routes, verifies. Skills implement. This separation keeps the orchestrator focused on quality and the skills focused on execution.

### 2. Automatic Quality Gates
Every delivery passes through verification (Auto-Verify), review (Minerva/Severus), and proof (ProofShot). No manual invocation needed.

### 3. Context-Based Routing
No commands, no menus. The user speaks naturally. Daemon detects intent and routes to the right skill.

### 4. Error Prevention Over Error Handling
Reading errors.md and learnings.md before every task prevents repeating mistakes. The Circuit Breaker prevents infinite loops.

### 5. Minimum Viable Tool
Always use the simplest tool that works. WebFetch before Browser. Direct API before manual navigation.

## MCP Integration Pattern

Skills connect to external services through MCP (Model Context Protocol) servers:

```
Skill (e.g., Neville)
    |
    v
MCP Server (e.g., Supabase)
    |
    v
External Service (e.g., PostgreSQL database)
```

Each project can have its own set of MCP servers. The CLAUDE.md template includes a configuration section for mapping projects to their MCP servers.

## Token Efficiency

The entire system (CLAUDE.md + memory index) uses less than 2% of the 1M context window. Skills are loaded on-demand, not all at once. This leaves 98%+ of the context for actual work.
