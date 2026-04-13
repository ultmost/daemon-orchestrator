<p align="center">
  <img src="docs/daemon-banner.svg" alt="Daemon" width="600">
</p>

<h3 align="center">Prompt architecture for Claude Code: specialized skills, quality protocols, persistent memory.</h3>

<p align="center">
  <a href="https://github.com/ultmost/daemon-orchestrator/stargazers"><img src="https://img.shields.io/github/stars/ultmost/daemon-orchestrator?style=flat-square&color=yellow" alt="Stars"></a>
  <a href="https://github.com/ultmost/daemon-orchestrator/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/claude--code-compatible-blueviolet?style=flat-square" alt="Claude Code"></a>
</p>

---

## What is Daemon?

Daemon is a **structured set of markdown files** that turn Claude Code from a general-purpose assistant into a specialized workflow with roles, quality gates, and persistent memory.

It's not a runtime. It's not a CLI. It's a carefully organized `CLAUDE.md` + skill files + memory templates that Claude Code loads as system instructions.

### What you get

- A **CLAUDE.md template** with context-based routing logic
- **17 skill files** (.md) with domain-specific instructions, triggers, and rules
- **5 protocol definitions** for verification, review, error prevention, and session persistence
- **Memory templates** for tracking errors, learnings, decisions, and session state across conversations
- A **setup.sh** that installs everything in one command (with backup)

### What you DON'T get

- No runtime, daemon process, or background service
- No CLI tool or executable binary
- No code-level enforcement. Claude follows instructions, not code contracts
- No guarantee. Claude can still deviate. Your mileage depends on your customization

### Why it works

Claude Code loads `~/.claude/CLAUDE.md` as system instructions every session. Well-structured instructions with clear triggers, rules, and processes produce dramatically better results than ad-hoc prompting.

This system was built iteratively over months of daily use shipping real products. Every protocol exists because something broke without it. Every rule in `errors.md` was learned the hard way.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│                  CLAUDE.md                       │
│  (system instructions loaded every session)      │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Routing  │  │Protocols │  │ Memory   │      │
│  │ Table    │  │ Rules    │  │ Location │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└──────────────────────┬──────────────────────────┘
                       │ loads
          ┌────────────┼────────────┐
          │            │            │
    ┌─────┴─────┐ ┌───┴────┐ ┌────┴─────┐
    │  Skills   │ │Protocol│ │  Memory  │
    │  (.md)    │ │ (.md)  │ │  (.md)   │
    │           │ │        │ │          │
    │ hermione  │ │ verify │ │ errors   │
    │ neville   │ │ review │ │ learnings│
    │ minerva   │ │ circuit│ │ session  │
    │ severus   │ │ flush  │ │ decisions│
    │ ...       │ │        │ │          │
    └───────────┘ └────────┘ └──────────┘
          │
          │ may use
          v
    ┌───────────┐
    │MCP Servers│
    │ (optional)│
    │           │
    │ supabase  │
    │ browser   │
    │ figma     │
    │ ssh       │
    │ ...       │
    └───────────┘
```

Everything is markdown files. There's no hidden runtime, no background process, no binary. Claude Code reads them as instructions and follows them.

---

## Lite vs Full

Not every developer needs all 17 skills. Here's how to choose:

| | Lite Mode | Full Mode |
|---|---|---|
| **Skills** | 5 core skills | 17 skills |
| **Setup time** | ~10 minutes | ~30 minutes |
| **MCPs required** | None | Optional (browser, Supabase, etc.) |
| **Best for** | Solo devs, focused projects, getting started | Teams, multiple projects, full workflow |
| **Covers** | Frontend + backend build, code review, security, decisions | Everything in Lite + research, ads, social, PDFs, QA, study |

**Lite setup:** See [docs/minimal-setup.md](docs/minimal-setup.md) — 5 skills, no MCPs, works today.

**Full setup:** Follow the Quick Start below.

---

## Skills

Skills are `.md` files with frontmatter (triggers, description) that define how Claude should handle specific types of work.

### Core Skills (useful for any developer)

| Skill | Role | Triggers |
|-------|------|----------|
| **Hermione** | Frontend builder. Pages, components, animations, design systems | "landing page", "component", "responsive", "animation", "dark mode" |
| **Neville** | Backend builder. APIs, database, migrations, auth, Docker, webhooks | "API", "endpoint", "database", "migration", "deploy" |
| **Minerva** | Adversarial code review in 3 phases | "code review", "before commit", "PR review". Auto after builds |
| **Severus** | Security audit. OWASP, XSS, CSRF, secrets, RLS | "security", "vulnerability". Auto when touching auth/payments |
| **Dobby** | Daily brief + quick research | "news", "trending". Auto at session start |
| **Hedwig** | Deep research. Benchmarks, comparisons, analysis | "deep dive", "compare", "how does X work" |
| **Council** | Multi-perspective decision panel (`--quick`, `--duo`, `full`) | "what do you think?", "should I?", "A or B?" |
| **What-If Oracle** | Scenario analysis | "what if...", "scenarios", "risk analysis" |
| **ProofShot** | Visual verification post-frontend (screenshots, JS errors) | Auto after any frontend delivery |
| **Pomfrey** | QA health check via browser | "test everything", "QA", "health check" |
| **PRD** | Product requirements document generator | "PRD", "user stories", "acceptance criteria" |
| **Claude-API** | Apps using Claude/Anthropic SDK | Code importing `anthropic` SDK |

### Optional Skills (specific to original author's workflow)

These skills were built for a specific solo-developer workflow. They may not fit your needs, but you can adapt or remove them:

| Skill | Role | Why it's optional |
|-------|------|-------------------|
| **Fred** | Paid traffic management (Meta Ads, Google Ads) | Only useful if you run ad campaigns |
| **George** | Ad intelligence & competitor spy | Only useful for e-commerce/DTC |
| **Rita Skeeter** | Social media management (LinkedIn, X) | Only useful if you post content |
| **Lucius** | Premium PDF generator (proposals, decks) | Only useful if you create business documents |
| **Lupin** | Study mentor & personal development | Only useful if you track learning goals |

> **You can delete any optional skill** without breaking the system. Just remove the file and its entry from the routing table in CLAUDE.md.

### A note on names

The Harry Potter naming is the original author's preference. If you find it unprofessional for your context, rename them. The system works the same with any names:

| Original | Neutral alternative |
|----------|-------------------|
| Hermione | frontend-builder |
| Neville | backend-builder |
| Minerva | code-reviewer |
| Severus | security-auditor |
| Dobby | daily-brief |
| Hedwig | deep-researcher |

The names are just file names and references in CLAUDE.md. A find-and-replace takes 2 minutes.

### What a skill looks like (full example)

Every skill is a markdown file with frontmatter and structured instructions. Here's `minerva.md` (code review) in full:

```markdown
---
name: minerva
description: Adversarial code review in 3 phases - spec compliance, code quality, evidence
triggers:
  - code review
  - review the code
  - before commit
  - before merge
  - PR review
  - refactor
auto_trigger: after any build by hermione or neville
---

# Minerva - Code Review (Adversarial)

> Reviews code in 3 phases with an adversarial posture. Finds what others miss.

## 3-Phase Review

### Phase 1: Spec Compliance
- Does the code do what was asked?
- Are all requirements met?
- Any missing edge cases?

### Phase 2: Code Quality
- Logic errors, performance issues, maintainability
- Code smells, unnecessary complexity
- Naming conventions, consistency
- Dead code, unused imports

### Phase 3: Evidence
- Verify claims with actual code (don't trust summaries)
- Check that tests actually test what they claim
- Verify build passes

## Critical Rules
- Be ADVERSARIAL. Your job is to find problems, not approve code
- Never rubber-stamp. If everything looks perfect, look harder
- Report findings with specific file:line references
- Grade: PASS / PASS WITH NOTES / FAIL
```

This is the actual content Claude reads when Minerva activates. No hidden logic. What you see is what Claude gets.

### Lite Setup (start here)

Don't want all 17 skills? Start with these 5. They cover 80% of a developer's daily workflow:

| Skill | Why it's essential |
|-------|-------------------|
| **Hermione** | Frontend work |
| **Neville** | Backend work |
| **Minerva** | Code review before committing |
| **Circuit Breaker** (protocol) | Prevents infinite error loops |
| **Memory system** (errors.md + learnings.md) | Prevents repeating mistakes |

To install lite: run `setup.sh`, then delete every skill file you don't need from `~/.claude/skills/daemon/` and remove its entry from the routing table in `~/.claude/CLAUDE.md`.

---

## Protocols

Protocols are behavioral rules that Claude follows during and after work. They're defined in `protocols/` and referenced in CLAUDE.md.

| Protocol | What it does | When it runs |
|----------|-------------|--------------|
| **Auto-Verify** | `typecheck -> lint -> build -> tests`, fix loop up to 3x | After every code change |
| **Auto-Review** | Minerva (code quality) + Severus (security) review | Before declaring anything "done" |
| **Circuit Breaker** | 3x same error = STOP with diagnostic | When stuck in error loops |
| **ProofShot** | Screenshot + JS error capture | After frontend delivery |
| **Memory Flush** | Persist state to session-state.md | Before ending any session |

**Important:** These are instructions, not automated hooks. Claude follows them because CLAUDE.md tells it to. In practice, compliance is high (~90%+) but not 100%. If Claude skips a step, you can remind it: "run the review protocol".

---

## Routing

The CLAUDE.md includes a routing table. Claude reads your message, matches context, and activates the appropriate skill:

```
is_frontend?        -> hermione
is_backend?         -> neville
is_review?          -> minerva
is_security?        -> severus
is_quick_research?  -> dobby
is_deep_research?   -> hedwig
is_decision?        -> council
is_scenario?        -> what_if_oracle
none_match?         -> acts directly
```

This isn't magic routing. It's a priority list in the system prompt that Claude follows. It works well for clear-cut requests and sometimes needs a nudge for ambiguous ones.

### When routing fails

Routing can be ambiguous. What happens when you say "fix this page's API call" (frontend or backend?):

- **Claude picks one.** Usually the dominant context wins (if you're in a `.tsx` file, Hermione activates)
- **You can override.** Say "use Neville for this" or "treat this as a backend task"
- **If Claude acts generically** without activating a skill, say: "check your routing table" and it will re-evaluate

This isn't a solved problem. Ambiguous prompts produce ambiguous routing. The fix is to be specific, or nudge when you notice Claude acting without a skill's rules.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│                  CLAUDE.md                       │
│  (system instructions loaded every session)      │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ Routing  │  │Protocols │  │ Memory   │      │
│  │ Table    │  │ Rules    │  │ Location │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└──────────────────────┬──────────────────────────┘
                       │ loads
          ┌────────────┼────────────┐
          │            │            │
    ┌─────┴─────┐ ┌───┴────┐ ┌────┴─────┐
    │  Skills   │ │Protocol│ │  Memory  │
    │  (.md)    │ │ (.md)  │ │  (.md)   │
    │           │ │        │ │          │
    │ hermione  │ │ verify │ │ errors   │
    │ neville   │ │ review │ │ learnings│
    │ minerva   │ │ circuit│ │ session  │
    │ severus   │ │ flush  │ │ decisions│
    │ ...       │ │        │ │          │
    └───────────┘ └────────┘ └──────────┘
          │
          │ may use
          v
    ┌───────────┐
    │MCP Servers│
    │ (optional)│
    │           │
    │ supabase  │
    │ browser   │
    │ figma     │
    │ ssh       │
    │ ...       │
    └───────────┘
```

Everything is markdown files. There's no hidden runtime, no background process, no binary. Claude Code reads them as instructions and follows them.

---

## Quick Start

> **New here? Read [docs/first-30-minutes.md](docs/first-30-minutes.md) first.** It walks you through setup, customization, and verifying it works — step by step, minute by minute.

### Install

```bash
git clone https://github.com/ultmost/daemon-orchestrator.git
cd daemon-orchestrator && bash setup.sh
```

The setup script:
1. Backs up your existing `~/.claude/CLAUDE.md` (if any)
2. Copies CLAUDE.md, skills, protocols, and memory templates
3. Takes about 30 seconds

### Configure (required)

Open `~/.claude/CLAUDE.md` and customize sections marked `<!-- CUSTOMIZE -->`:

1. **Language** - Set your preferred language
2. **Projects** - Add your active projects and paths
3. **MCP Servers** - Add your integrations (see [MCP config examples](docs/mcp-config-example.md))
4. **Remove optional skills** you don't need (Fred, George, Rita, Lucius, Lupin)

### Start

```bash
claude
```

Claude will load the CLAUDE.md and begin following the routing rules. Try:
- "build me a navbar component" (routes to Hermione)
- "review the last commit" (routes to Minerva)
- "what do you think about using Supabase vs Firebase?" (routes to Council)

### Troubleshooting

| Problem | Fix |
|---------|-----|
| Claude ignores routing and acts generically | Check that `~/.claude/CLAUDE.md` exists and was loaded. Say "check your system instructions" |
| Claude skips Auto-Verify after a build | Remind it: "run the verify protocol" |
| Skills don't activate | Make sure skill files are in `~/.claude/skills/daemon/` |
| Claude mixes up projects | Add explicit project isolation rules in CLAUDE.md section 5 |
| Memory not persisting | Check memory path in CLAUDE.md matches actual directory |
| ProofShot/Pomfrey not working | These require MCP Browser. Install it first (see MCP config) |
| Too many skills cluttering context | Delete optional skills you don't use. Less is more |

---

## Example Session

This is a **representative example**, not a recorded log. Real sessions look similar but with more back-and-forth:

```
You: "the checkout page is broken on mobile"

Claude (following CLAUDE.md routing):
  - Reads errors.md first (checks if this happened before)
  - Identifies it as frontend → activates Hermione skill
  - Inspects the component, finds CSS overflow issue
  - Fixes it
  - Auto-Verify: typecheck ✓ lint ✓ build ✓
  - ProofShot: captures mobile screenshot as proof
  - Shows you the fix + screenshot

You: "ship it"

Claude:
  - Auto-Review activates: Minerva reviews the diff
  - Phase 1 (spec compliance): PASS
  - Phase 2 (code quality): PASS
  - Commits with clean message
```

```
You: "should we switch from Stripe to Lemonsqueezy?"

Claude (detects decision → activates Council --quick):
  - 3-4 perspectives debate the trade-offs
  - Considers: pricing, MoR, tax handling, API maturity
  - Presents structured comparison
  - You decide. Council doesn't decide for you.
```

---

## Memory System

File-based persistence across sessions. The most practically valuable part of this repo.

```
~/daemon-memory/
  MEMORY.md          # Index loaded every session (keep under 200 lines)
  session-state.md   # What you were working on, pending items, blockers
  errors.md          # Error log - READ BEFORE every technical task
  learnings.md       # Lessons learned - prevents repeating mistakes
  decisions.md       # Decision log with context and rationale
```

**The key insight:** Claude reads `errors.md` before every technical task. This means mistakes you made last week won't happen again this week. Over time, your error log becomes a knowledge base that makes Claude progressively better at your specific workflow.

> **See [memory-example.md](docs/memory-example.md)** for what a filled memory system looks like after real use.

---

## MCP Integrations (Optional)

MCPs extend what Claude can actually do. None are required for the core system to work.

See **[MCP config examples](docs/mcp-config-example.md)** for copy-paste setup commands.

| MCP | What it enables | Required by |
|-----|----------------|-------------|
| **Supabase** | Database queries, auth, migrations | Neville (backend) |
| **Browser** | Real browser navigation, screenshots | ProofShot, Pomfrey |
| **Figma** | Read designs, Code Connect | Hermione (design-to-code) |
| **SSH** | VPS commands, deployment | Neville (deploy) |
| **Context7** | Up-to-date library docs | Any skill needing current docs |

> Without MCPs, skills still work for code generation and review. They just can't interact with external services.

---

## How to Know It's Working

When the system is correctly set up and running, you'll see these signs:

**Routing is happening:**
- Claude mentions the skill before starting ("This is a frontend task — activating Hermione...") or shifts into skill-specific structured behavior without prompting
- Asking "build me a navbar" produces a response that follows Hermione's rules (asks about stack if unknown, produces TypeScript + Tailwind by default, runs typecheck after)
- Asking "should we use Postgres or SQLite?" activates Council mode with multiple perspectives, not a single direct answer

**Memory is working:**
- At session start, Claude references your active projects without you telling it again
- Before coding, Claude says something like "checking errors.md first..." and references past mistakes
- At session end (or when you say "flush session state"), Claude writes a summary to `~/daemon-memory/session-state.md`

**Quality gates are running:**
- After Hermione or Neville builds something, Claude runs typecheck + lint without being asked
- Before Claude declares anything "done", Minerva's review happens automatically
- When touching auth or payment code, Severus activates without being prompted

**Common failure modes and fixes:**

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| Claude responds generically, no skill language | CLAUDE.md not loaded or path wrong | Run `ls ~/.claude/CLAUDE.md`. If missing, re-run `setup.sh` |
| Claude asks "what stack are you using?" every session | MEMORY.md not filled in | Add your stack to `~/daemon-memory/MEMORY.md` |
| Auto-Verify never runs | Protocol not referenced in CLAUDE.md | Check section 7 in `~/.claude/CLAUDE.md` lists Auto-Verify |
| Skill activates but ignores its rules | Skill file not in the right path | Check `~/.claude/skills/daemon/` has the `.md` files |
| Memory lost between sessions | Memory flush not running | At session end, say "flush memory state" explicitly |
| Claude mixes up two projects | Project isolation not configured | Add explicit project sections to CLAUDE.md section 6 |

**Quick diagnostic — type this in any session:**

```
what are your current routing rules and what skill would you use for:
1) building a login page
2) reviewing an API route
3) deciding between two database options
```

Claude should answer: Hermione, Minerva, Council. If it doesn't, check that CLAUDE.md is loaded correctly.

---

## Design Philosophy

### It's instructions, not infrastructure
This system doesn't enforce behavior through code. It enforces it through well-structured prompts that Claude follows consistently. The value is in the **structure and organization**, not in automation magic.

### Harness engineering
Your job shifts from writing code to building the **harness** that guides AI to write code well: rules, review processes, memory, guardrails. [Anthropic](https://www.anthropic.com/engineering/managed-agents) and [OpenAI](https://openai.com) have both written about this pattern.

### Cherry-pick, don't adopt wholesale
Take what works for your workflow. Delete what doesn't. The best version of this system is one you've customized heavily for your own projects and preferences.

---

## Project Structure

```
daemon-orchestrator/
  CLAUDE.md                    # Main config template (customize this)
  setup.sh                     # One-command installer
  README.md
  LICENSE                      # MIT
  skills/
    hermione.md                # Frontend builder          [core]
    neville.md                 # Backend builder           [core]
    minerva.md                 # Code review               [core]
    severus.md                 # Security audit            [core]
    dobby.md                   # Daily brief + research    [core]
    hedwig.md                  # Deep research             [core]
    council.md                 # Decision panel            [core]
    what-if-oracle.md          # Scenario analysis         [core]
    pomfrey.md                 # QA health check           [core]
    proofshot.md               # Visual verification       [core]
    prd.md                     # PRD generator             [core]
    claude-api.md              # Claude API builder        [core]
    fred.md                    # Paid traffic              [optional]
    george.md                  # Ad intelligence           [optional]
    rita-skeeter.md            # Social media              [optional]
    lucius.md                  # PDF generator             [optional]
    lupin.md                   # Study mentor              [optional]
  protocols/
    auto-verify.md             # Post-build verification
    auto-review.md             # Automatic code review
    circuit-breaker.md         # Error loop prevention
    memory-flush.md            # Session state persistence
    orchestration-rules.md     # Proactive behavior rules
  memory/
    MEMORY.md                  # Memory index template
    session-state.md           # Session state template
    errors.md                  # Error log template
    learnings.md               # Learnings template
    decisions.md               # Decision log template
  docs/
    architecture.md            # Detailed architecture docs
    customization.md           # How to customize
    mcp-config-example.md      # MCP server setup commands
    memory-example.md          # Filled memory example
    daemon-banner.svg          # Banner image
```

---

## Limitations

Being honest about what this system can't do:

- **Claude can still ignore instructions.** Compliance is high but not 100%. Complex or ambiguous requests sometimes bypass routing
- **No enforcement mechanism.** If Claude decides to skip Auto-Verify, nothing stops it except your reminder
- **Context window cost.** The full CLAUDE.md + loaded skills use context tokens. On the 200k window this matters; on 1M it's negligible (~2%)
- **Skill quality varies.** Core skills (Hermione, Neville, Minerva) are battle-tested. Optional skills are less refined
- **Memory is manual.** Claude writes to memory files, but there's no automated cleanup, deduplication, or expiry. You maintain it
- **Not tested on other AI coding tools.** Built for Claude Code specifically. May partially work with Cursor/Windsurf but untested

---

## How Daemon Compares

Honest comparison against trending Claude Code setups and agent frameworks. Every "better" and "worse" is relative to use case, not a universal claim.

| Feature | Daemon | claude-mem | Karpathy Skills | Ralph | Archon |
|---------|--------|-----------|----------------|-------|--------|
| **Memory system** | Full file-based (errors, learnings, decisions, session state) | Auto + vector memory | None | None | None |
| **Skill routing** | 17 skills, context-based auto-routing | None | Manual | None | YAML-defined agents |
| **Quality gates** | 3 protocols (Auto-Verify, Auto-Review, Circuit Breaker) | None | Goal criteria | None | Deterministic pipelines |
| **Acceptance criteria** | Required before every build task | None | Core principle | None | Baked into pipeline |
| **Fresh context protocol** | Yes (per-phase clean context for long work) | No | No | Yes (per-iteration) | Partial |
| **Hooks enforcement** | Documented (settings.json hooks guide) | No | No | No | No |
| **UI-SPEC gate** | Yes (pre-build contract for frontend) | No | No | No | No |
| **Setup complexity** | Medium (markdown files + customization) | Low (npm install) | Low (copy skills) | High (runtime setup) | High (self-hosted) |
| **Claude Code native** | Yes (pure CLAUDE.md + skills) | Yes | Yes | Partial | No (separate runtime) |
| **Customizable** | High (delete/rename anything) | Low | Medium | Low | Medium |

### Where others are better

Being honest here builds trust:

- **claude-mem** has automatic vector memory that works without any manual maintenance. Daemon's memory is file-based and requires you to maintain it. If you want zero-maintenance memory, claude-mem wins.
- **Karpathy's approach** treats goal-driven execution as the central principle, not one gate among many. If you want a purer version of "define success before starting", study his skills repo.
- **Ralph** has a more mature fresh-context/iteration model for long autonomous work. Daemon's `protocols/fresh-context.md` was directly inspired by Ralph.
- **Archon** offers a visual UI and self-hosted setup with more deterministic agent pipelines. If you need a team-facing interface, Archon is worth evaluating.

### Where Daemon is stronger

- The combination of memory + routing + quality gates in a single unified system is unique. Most alternatives pick one or two of these.
- 17 battle-tested skills covering the full workflow (build, review, research, business, decisions) versus most repos offering 3-5 skills.
- The skill files are the actual content Claude reads — no hidden logic, fully auditable and customizable.

---

## Inspired By

Each of these repos contributed a specific insight that shaped Daemon:

| Repo / Resource | What we learned |
|----------------|----------------|
| [Karpathy's Claude skills](https://github.com/karpathy) | Goal-Driven Execution: define success criteria before any task. Now the Acceptance Criteria Gate in section 3.6. |
| [Ralph (iterative agent)](https://github.com/badass-courses/ralph) | Clean context per iteration. Persistent artifacts over conversation history. Now `protocols/fresh-context.md`. |
| [claude-code-best-practice](https://github.com/grahama1970/claude-code-best-practice) | Using `settings.json` hooks to enforce protocols at the platform level, not just instruction level. Now `docs/hooks-setup.md`. |
| [Harness Engineering](https://www.anthropic.com/engineering/managed-agents) (Anthropic) | The "harness" mental model: your job is to build the structure that guides AI, not to prompt it every time. |
| [Everything Claude Code](https://github.com/affaan-m/everything-claude-code) | Agent harness optimization patterns. |
| [wshobson/agents](https://github.com/wshobson/agents) | Modular plugin architecture for agent skills. |

If you want more **modular, plugin-based** approaches, check those repos. If you want an **opinionated, integrated template** you can customize, that's what Daemon is.

---

## New in This Version

Recent improvements based on competitive analysis:

- **Acceptance Criteria Gate** (CLAUDE.md §3.6) — Required WHAT/SUCCESS/OUT-OF-SCOPE before any build task
- **UI-SPEC Gate** (CLAUDE.md §3.7) — Frontend pre-build contract for new pages and features. See [`docs/ui-spec-guide.md`](docs/ui-spec-guide.md)
- **Hooks Setup Guide** ([`docs/hooks-setup.md`](docs/hooks-setup.md)) — How to use `settings.json` hooks so protocols are enforced, not just instructed
- **Fresh Context Protocol** ([`protocols/fresh-context.md`](protocols/fresh-context.md)) — Per-phase clean context for long autonomous work

---

## Contributing

PRs welcome. Especially:
- New core skills that are useful for most developers
- Improvements to existing protocols
- Better troubleshooting docs
- Real session logs showing the system in action

---

## License

MIT. See [LICENSE](LICENSE).

---

<p align="center">
  <b>Built by <a href="https://linkedin.com/in/vharaujo1">Vitor Araujo</a></b><br>
  <sub>Building businesses with AI | Automation & AI Agents</sub>
</p>
