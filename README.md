<p align="center">
  <img src="docs/daemon-banner.svg" alt="Daemon Orchestrator" width="600">
</p>

<h3 align="center">A 17-agent AI orchestration system built on Claude Code.<br>One person. Full team output.</h3>

<p align="center">
  <a href="https://github.com/ultmost/daemon-orchestrator/stargazers"><img src="https://img.shields.io/github/stars/ultmost/daemon-orchestrator?style=flat-square&color=yellow" alt="Stars"></a>
  <a href="https://github.com/ultmost/daemon-orchestrator/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/claude--code-compatible-blueviolet?style=flat-square" alt="Claude Code"></a>
  <a href="#"><img src="https://img.shields.io/badge/agents-17-green?style=flat-square" alt="Agents"></a>
  <a href="#"><img src="https://img.shields.io/badge/MCP%20integrations-17-orange?style=flat-square" alt="MCPs"></a>
</p>

---

## What is Daemon?

Daemon is a **harness engineering** system that turns Claude Code into a full development team. Instead of writing code yourself, you build the structure that enables AI to write production-quality code with built-in review, security, and quality gates.

**The core idea:** You are the architect. AI agents are the team. Daemon is the operating system that connects them.

```
You speak naturally --> Daemon routes to the right agent --> Agent executes --> Auto-review pipeline runs --> Done
```

### Built in production. Not in theory.

This system was built while shipping 8+ production web apps simultaneously as a solo developer. Every protocol exists because something broke without it.

---

## Architecture

```
                          +-----------------+
                          |     DAEMON      |
                          |  (Orchestrator) |
                          +--------+--------+
                                   |
                     Context-based routing
                                   |
        +----------+----------+----+----+----------+----------+
        |          |          |         |          |          |
   +---------+ +--------+ +--------+ +-------+ +--------+ +--------+
   |Hermione | |Neville | |Minerva | |Severus| | Dobby  | |  Fred  |
   |Frontend | |Backend | | Review | |Security| |Research| |  Ads   |
   +---------+ +--------+ +--------+ +-------+ +--------+ +--------+
   | Council | | Hedwig | | George | | Rita  | | Lupin  | | Lucius |
   |Decision | |Deep Res| |Ad Intel| |Social | | Study  | |  PDFs  |
   +---------+ +--------+ +--------+ +-------+ +--------+ +--------+

                          +-----------------+
                          |   PROTOCOLS     |
                          +-----------------+
                          | Auto-Verify     |
                          | Auto-Review     |
                          | Circuit Breaker |
                          | ProofShot       |
                          | Memory Flush    |
                          +-----------------+

                          +-----------------+
                          |  MCP SERVERS    |
                          +-----------------+
                          | Supabase (x7)   |
                          | Obsidian        |
                          | Figma           |
                          | PostHog         |
                          | Google Ads      |
                          | SSH (x3)        |
                          | Browser         |
                          | Unity           |
                          +-----------------+
```

---

## The 17 Agents

### Builders (who writes the code)

| Agent | Role | Triggers |
|-------|------|----------|
| **Hermione** | Frontend builder. Pages, components, animations, design systems. Next.js + Tailwind + shadcn + Framer Motion | Any UI request: "landing page", "component", "responsive", "animation", "dark mode" |
| **Neville** | Backend builder. APIs, database, migrations, Supabase, Docker, VPS, webhooks | Any backend request: "API", "endpoint", "database", "migration", "deploy" |
| **Claude-API** | Apps using Claude API / Anthropic SDK / Agent SDK | Code importing `anthropic` or `@anthropic-ai/sdk` |

### Quality (who verifies)

| Agent | Role | Triggers |
|-------|------|----------|
| **Minerva** | Adversarial code review in 3 phases: spec compliance, code quality, evidence | "code review", "before commit", "before merge", "PR review". **Auto after builds** |
| **Severus** | Security audit. OWASP, pentest, secrets, XSS, CSRF, RLS, injection | "security", "vulnerability", "pentest". **Auto when build touches auth/webhooks/payments** |
| **ProofShot** | Visual verification post-frontend. Records video, captures JS errors, generates proof artifacts | **Auto after any frontend delivery** |
| **Pomfrey** | QA Health Check. Reads PRD/docs, discovers features, tests everything via browser | "test everything", "QA", "health check", "smoke test" |

### Research (who finds information)

| Agent | Role | Triggers |
|-------|------|----------|
| **Dobby** | Daily brief + quick research. News, trending, updates. **Runs automatically at session start** | "daily brief", "news", "trending", "what's new" |
| **Hedwig** | Deep research. Benchmarks, comparisons, analysis, references | "deep dive", "compare", "benchmark", "how does X work" |
| **George** | Ad intelligence & competitor spy. Ad Library, winning products, niche analysis | "spy", "ad library", "competitor", "winning product" |

### Business (who manages)

| Agent | Role | Triggers |
|-------|------|----------|
| **Fred** | Paid traffic. Create/manage/optimize ads, budgets, performance diagnostics, pixels | "create ad", "my campaign", "adjust budget", "CTR", "ROAS" |
| **Rita Skeeter** | Social media. LinkedIn and X/Twitter. Content calendar, engagement, personal branding | "LinkedIn post", "Twitter post", "social media", "content calendar" |
| **Lucius** | Premium PDF generator. Proposals, decks, contracts, invoices, reports | "PDF", "proposal", "deck", "pitch deck", "contract" |

### Decision (who thinks with you)

| Agent | Role | Triggers |
|-------|------|----------|
| **Council** | 12-character debate panel for decisions. Modes: `--quick` (technical), `--duo` (A vs B), `full` (strategic) | Any doubt, trade-off, "what do you think?", "should I?", "A or B?" |
| **What-If Oracle** | Scenario analysis. Explores consequences of paths/events | "what if...", "what happens if...", "scenarios", "risk analysis" |

### Personal Development

| Agent | Role | Triggers |
|-------|------|----------|
| **Lupin** | Study mentor. Plans study sessions, tracks progress, quizzes, manages learning goals | "study plan", "what to study", "quiz", "study progress" |

---

## Protocols

These run **automatically**. You don't invoke them.

### Auto-Verify
After every build: `typecheck --> lint --> build --> tests`. Fix loop up to 3x. **Mandatory.**

### Auto-Review
Minerva + Severus run automatically before any delivery is declared "done". No exceptions.

### Circuit Breaker
3x same error --> **STOP** with diagnostic. 3x no progress --> **STOP** with diagnostic. Prevents infinite loops.

### ProofShot
After any frontend delivery: navigate the page, capture screenshots, detect JS errors. Generates proof artifacts.

### Memory Flush
Before ending any session: persist state to `session-state.md`. Next session picks up where you left off.

---

## Routing Logic

Daemon doesn't wait for commands. It reads context and routes automatically:

```python
every_message -> daemon_analyzes:
    is_frontend?        -> hermione
    is_backend?         -> neville
    is_review?          -> minerva
    is_security?        -> severus
    is_quick_research?  -> dobby
    is_deep_research?   -> hedwig
    is_competitor_spy?  -> george
    is_paid_traffic?    -> fred
    is_decision?        -> council
    is_scenario?        -> what_if_oracle
    is_social_media?    -> rita_skeeter
    is_pdf?             -> lucius
    is_study?           -> lupin
    is_prd?             -> prd
    none_match?         -> daemon_acts_directly
```

**Key principle:** Daemon is the **orchestrator**. It never writes production code directly. It thinks, routes, verifies, and coordinates.

---

## Quick Start

### 1. Clone this repo

```bash
git clone https://github.com/ultmost/daemon-orchestrator.git
```

### 2. Copy the CLAUDE.md to your home directory

```bash
cp daemon-orchestrator/CLAUDE.md ~/.claude/CLAUDE.md
```

### 3. Copy skills to your Claude Code skills directory

```bash
cp -r daemon-orchestrator/skills/* ~/.claude/skills/
```

### 4. Set up your memory system

```bash
mkdir -p ~/claude-memory
cp daemon-orchestrator/memory/* ~/claude-memory/
```

### 5. Start Claude Code

Claude will automatically load the CLAUDE.md and begin operating as Daemon.

> **Note:** You'll need to customize the CLAUDE.md with your own project paths, MCP server configs, and personal preferences. The template includes comments showing where to customize.

---

## Memory System

Daemon has persistent, file-based memory across sessions:

```
memory/
  MEMORY.md              # Index file - loaded every session
  session-state.md       # Current state, pending tasks, handoff notes
  errors.md              # Error log - read BEFORE every technical task
  learnings.md           # Lessons learned - prevents repeating mistakes
  decisions.md           # Decision log with context
  orchestration-rules.md # Proactive behavior rules
```

### Memory Types

| Type | What it stores | When to save |
|------|---------------|--------------|
| **user** | Role, goals, preferences, knowledge level | When learning about the user |
| **feedback** | Corrections and guidance from the user | When the user corrects your approach |
| **project** | Ongoing work, goals, initiatives, deadlines | When learning who/what/why/when |
| **reference** | Pointers to external resources | When learning about external systems |

### What NOT to save
- Code patterns (derive from codebase)
- Git history (use `git log`)
- Debugging solutions (the fix is in the code)
- Ephemeral task details

---

## MCP Integrations

Daemon connects to 17 MCP servers for real-world actions:

| MCP | Purpose |
|-----|---------|
| **Supabase** (multiple) | Database, Auth, Storage, Edge Functions per project |
| **Obsidian** | Personal knowledge base, notes, agenda |
| **Figma** | Read designs, generate diagrams, Code Connect |
| **PostHog** | Analytics, funnels, feature flags, experiments |
| **Google Ads** | Campaign management via API |
| **Browser** | Real browser via Playwright MCP for complex navigation |
| **SSH** (multiple) | VPS deployment and server management |
| **Unity** | Game development (editor integration) |
| **Context7** | Up-to-date library documentation |

---

## Tool Hierarchy

Always use the **minimum** tool needed:

```
Simple data    --> WebFetch
Complex nav    --> Playwright CLI
Login/interact --> MCP Browser
```

```
Quick news     --> Dobby
Deep analysis  --> Hedwig
Ad research    --> George
```

**Never** use MCP Browser for something WebFetch can handle.
**Never** navigate manually when an API exists.

---

## Design Philosophy

### Harness Engineering
Your job is not to write code. Your job is to build the **harness** that allows AI to write code well:
- Rules for how AI should work (CLAUDE.md)
- Automatic review system (Minerva, Severus)
- Tests that validate output (Auto-Verify)
- Organized context (memory, skills)
- Guardrails (circuit breaker, isolation)

### Absorb > Install
After evaluating 60+ repos and tools: our setup covers 80%+ of the ecosystem. New tools only enter if they fill a **real** gap. Cherry-pick ideas, don't stack tools.

### One Person, Full Team
The entire system is designed for a solo developer shipping multiple production apps simultaneously. Every agent, protocol, and integration exists to multiply one person's output.

---

## Project Structure

```
daemon-orchestrator/
  CLAUDE.md                    # Main orchestrator config (template)
  README.md                    # This file
  LICENSE                      # MIT
  skills/
    hermione.md                # Frontend builder
    neville.md                 # Backend builder
    minerva.md                 # Code review (3-phase adversarial)
    severus.md                 # Security audit
    dobby.md                   # Daily brief + quick research
    hedwig.md                  # Deep research
    george.md                  # Ad intelligence & competitor spy
    fred.md                    # Paid traffic management
    council.md                 # Decision panel (12 characters)
    what-if-oracle.md          # Scenario analysis
    rita-skeeter.md            # Social media management
    lucius.md                  # PDF generator
    lupin.md                   # Study mentor
    pomfrey.md                 # QA health check
    proofshot.md               # Visual verification
    prd.md                     # Product requirements document
    claude-api.md              # Claude API builder
  protocols/
    auto-verify.md             # Post-build verification pipeline
    auto-review.md             # Automatic code review
    circuit-breaker.md         # Error loop prevention
    proofshot-protocol.md      # Visual proof generation
    memory-flush.md            # Session state persistence
    orchestration-rules.md     # Proactive behavior rules
  memory/
    MEMORY.md                  # Memory index template
    session-state.md           # Session state template
    errors.md                  # Error log template
    learnings.md               # Learnings template
    decisions.md               # Decision log template
  docs/
    daemon-banner.svg          # Banner image
    architecture.md            # Detailed architecture docs
    customization.md           # How to customize for your workflow
```

---

## Inspiration & References

Daemon was built independently, arriving at conclusions similar to:
- [Harness Engineering](https://www.anthropic.com/engineering/managed-agents) (Anthropic / OpenAI concept)
- [CREAO's AI-First Engineering](https://medium.com/@stefano.demartini) (25-person team, same architecture principles)
- [Everything Claude Code](https://github.com/affaan-m/everything-claude-code) (agent harness optimization)

The difference: Daemon was built by one person shipping real products, not by a team theorizing about AI workflows.

---

## Contributing

Contributions welcome. If you've built something similar or have ideas:

1. Fork the repo
2. Create a feature branch
3. Open a PR with a clear description

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

<p align="center">
  <b>Built by <a href="https://linkedin.com/in/vharaujo1">Vitor Araujo</a></b><br>
  <i>Building businesses with AI | Automation & AI Agents</i>
</p>
