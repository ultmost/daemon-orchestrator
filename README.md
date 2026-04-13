<p align="center">
  <img src="docs/daemon-banner.svg" alt="Daemon Orchestrator" width="600">
</p>

<h3 align="center">Prompt architecture for Claude Code: 17 specialized roles, automatic quality gates, persistent memory.</h3>

<p align="center">
  <a href="https://github.com/ultmost/daemon-orchestrator/stargazers"><img src="https://img.shields.io/github/stars/ultmost/daemon-orchestrator?style=flat-square&color=yellow" alt="Stars"></a>
  <a href="https://github.com/ultmost/daemon-orchestrator/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/claude--code-compatible-blueviolet?style=flat-square" alt="Claude Code"></a>
  <a href="#"><img src="https://img.shields.io/badge/agents-17-green?style=flat-square" alt="Agents"></a>
  <a href="#"><img src="https://img.shields.io/badge/MCP%20integrations-17-orange?style=flat-square" alt="MCPs"></a>
</p>

---

## What is Daemon?

Daemon is a **prompt architecture** for Claude Code that organizes your AI workflow into specialized roles with automatic quality gates. It's a structured set of instructions, skills, and memory templates that guide Claude to work like a coordinated team.

**The core idea:** You define the rules. Claude follows them. Skills handle specific domains. Protocols enforce quality.

```
You speak naturally --> CLAUDE.md routing matches context --> Skill instructions activate --> Quality protocols run
```

### What this is

- A **CLAUDE.md template** with routing logic for 17 specialized roles
- **Skill files** (.md) that give Claude domain-specific instructions and rules
- **Protocol definitions** for automatic verify, review, and error prevention
- **Memory templates** for persistent context across sessions
- A **setup script** that installs everything in one command

### What this is NOT

- Not a runtime, daemon process, or background service
- Not a CLI tool or executable
- Not enforced by code. It's enforced by Claude following well-structured instructions
- Not magic. Claude can still ignore instructions. The quality of your results depends on how well you customize the prompts for your workflow

### Why it works anyway

Claude Code loads `~/.claude/CLAUDE.md` as system instructions every session. Well-structured instructions with clear triggers, rules, and processes produce dramatically better results than ad-hoc prompting. This system was built iteratively while shipping multiple production apps. Every protocol exists because something broke without it.

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

### One-command install

```bash
git clone https://github.com/ultmost/daemon-orchestrator.git
cd daemon-orchestrator && bash setup.sh
```

The setup script:
1. Copies `CLAUDE.md` to `~/.claude/CLAUDE.md` (backs up existing one)
2. Copies all skills to `~/.claude/skills/daemon/`
3. Creates memory directory at `~/daemon-memory/`
4. Copies protocols and memory templates

### How it works

Claude Code loads `~/.claude/CLAUDE.md` as system instructions on every session. That file contains:
- The routing table (which skill handles what)
- Protocol definitions (auto-verify, auto-review, etc.)
- Memory system location
- Your project configs

Skills are `.md` files with frontmatter that Claude reads as behavioral instructions. When you say "build me a landing page", Claude matches it against skill triggers and activates Hermione with all its rules and process.

**You don't invoke skills manually.** You talk naturally. Daemon routes automatically.

### After install

1. Open `~/.claude/CLAUDE.md` and customize sections marked `<!-- CUSTOMIZE -->`
2. Add your projects, MCP servers, and preferences
3. Start Claude Code - it's now Daemon

> **First session tip:** Say "hello" and Daemon will run the daily brief protocol (Dobby), check for pending items, and ask what you're working on.

---

## Example Session

Here's what a real session looks like:

```
You: "build a pricing section with 3 tiers for my saas"

Daemon thinks: frontend request --> routes to Hermione

Hermione activates:
  1. Checks for DESIGN.md in project root (design tokens)
  2. Builds the component with Next.js + Tailwind + shadcn
  3. Auto-Verify runs: typecheck ✓ lint ✓ build ✓
  4. ProofShot captures screenshot (desktop + mobile)
  5. Delivers component with visual proof

You: "looks good, but add a toggle for monthly/yearly"

Hermione updates the component, Auto-Verify runs again.

You: "ship it"

Daemon: suggests Minerva review before commit
  Minerva Phase 1 (spec compliance): PASS
  Minerva Phase 2 (code quality): PASS with notes - suggests extracting price config
  You: "fix the note and commit"
  Done. Committed with clean code.
```

```
You: "the checkout webhook is failing in production"

Daemon thinks: backend + security --> routes to Neville, flags Severus

Neville investigates:
  1. Reads errors.md (checks if this happened before)
  2. Checks webhook handler code
  3. Identifies missing signature validation
  4. Fixes and adds test

Severus auto-activates (webhook = sensitive):
  Security audit: found 1 MEDIUM - webhook endpoint lacks rate limiting
  Fix applied.

Auto-Verify: all tests pass. Committed.
```

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

> **See [memory-example.md](docs/memory-example.md)** for a real-world example of what a filled memory system looks like after a few weeks of use.

---

## MCP Integrations

Daemon connects to MCP servers for real-world actions. See **[MCP config examples](docs/mcp-config-example.md)** for setup commands.

| MCP | Purpose | Install |
|-----|---------|---------|
| **Supabase** | Database, Auth, Storage, Edge Functions | `claude mcp add supabase-myapp ...` |
| **Browser** | Real browser via Playwright for complex navigation | `claude mcp add browser ...` |
| **Figma** | Read designs, generate diagrams, Code Connect | `claude mcp add figma ...` |
| **SSH** | VPS deployment and server management | `claude mcp add ssh-prod ...` |
| **PostHog** | Analytics, funnels, feature flags | `claude mcp add posthog ...` |
| **Context7** | Up-to-date library documentation | `claude mcp add context7 ...` |
| **Obsidian** | Personal knowledge base, notes | `claude mcp add obsidian ...` |

> You can add multiple instances per type (e.g., `supabase-projecta`, `supabase-projectb`, `ssh-staging`, `ssh-production`)

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

### Prompt Architecture > Runtime
This system doesn't enforce behavior through code. It enforces behavior through well-structured instructions that Claude follows consistently. Think of it as an operating manual, not an operating system. The value is in the **structure**, not in automation magic.

### Harness Engineering
The concept (coined by OpenAI, validated by Anthropic): your job is not to write code. Your job is to build the **harness** that guides AI to write code well:
- Rules for how AI should work (CLAUDE.md)
- Review instructions (Minerva, Severus)
- Verification steps (Auto-Verify)
- Organized context (memory, skills)
- Guardrails (circuit breaker, isolation)

### Cherry-Pick, Don't Stack
This system was built by absorbing ideas from many tools and repos, not by installing all of them. New tools only enter if they fill a real gap. The best approach is to take what works from Daemon and adapt it to your workflow.

### Solo Developer Focus
Designed for one person shipping multiple projects. Every skill and protocol exists to multiply individual output by reducing repeated mistakes and automating quality checks.

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
    mcp-config-example.md      # MCP server setup commands
    memory-example.md          # What a filled memory system looks like
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
