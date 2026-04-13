# First 30 Minutes with Daemon

A concrete, step-by-step guide to go from zero to a working session.

---

## Minutes 0-5: Clone and run setup

```bash
git clone https://github.com/ultmost/daemon-orchestrator.git
cd daemon-orchestrator
bash setup.sh
```

The script copies everything to `~/.claude/`. It backs up any existing `CLAUDE.md` first. Takes about 10 seconds.

Verify it worked:

```bash
ls ~/.claude/CLAUDE.md          # should exist
ls ~/.claude/skills/daemon/     # should have .md files
ls ~/daemon-memory/             # should have MEMORY.md, errors.md, etc.
```

If `~/daemon-memory/` doesn't exist, create it manually:

```bash
mkdir -p ~/daemon-memory
cp memory/* ~/daemon-memory/
```

---

## Minutes 5-15: Customize CLAUDE.md

Open `~/.claude/CLAUDE.md`. There are four sections marked `<!-- CUSTOMIZE -->`. Edit each one.

### Section 2 — Language

Change this if you work in a language other than English:

```markdown
## 2. LANGUAGE
- Communication: English
- Code: English
- User-facing strings: English
```

For Portuguese, for example:
```markdown
## 2. LANGUAGE
- Communication: Portuguese BR (always with correct accents)
- Code: English (variables, functions, technical comments)
- User-facing strings: Portuguese BR with accents
```

### Section 5 — Persistent Memory (path)

The default path is `~/daemon-memory/`. If you want it somewhere else (e.g., inside a Dropbox or iCloud folder so it syncs), change it here:

```markdown
Memory location: `~/daemon-memory/`
```

Change to something like:
```markdown
Memory location: `~/Dropbox/claude-memory/`
```

Then move the folder: `mv ~/daemon-memory ~/Dropbox/claude-memory`

### Section 6 — Project Isolation

Add your active projects. Be specific about paths and what makes each one distinct:

```markdown
## 6. PROJECT ISOLATION
- NEVER mix projects. Each has its own database and deploy target.
- Before any server command: confirm WHICH project, WHICH server.
```

Becomes something like:

```markdown
## 6. PROJECT ISOLATION
- NEVER mix projects. Each has its own database, keys, and deploy target.
- **MyApp**: SaaS product. Supabase project: myapp-prod. Deploy: Vercel. Path: ~/projects/myapp/
- **ClientSite**: Client landing page. No database. Deploy: Netlify. Path: ~/projects/client-site/
- Before any Supabase command: confirm which project's MCP is active.
- Before any deploy command: confirm which Vercel project.
```

### Section 9 — MCP Servers

If you have MCPs installed, list them here so Daemon knows what tools are available. If you have none, leave this section as-is for now. You can add MCPs later.

Example with Supabase and browser:
```markdown
## 9. MCP SERVERS
| MCP            | What it accesses            |
|----------------|-----------------------------|
| supabase-myapp | MyApp database (prod)       |
| browser        | Real browser via Playwright |
| context7       | Up-to-date library docs     |
```

### Prune optional skills you don't need

If you don't run ad campaigns, delete Fred and George:

```bash
rm ~/.claude/skills/daemon/fred.md
rm ~/.claude/skills/daemon/george.md
```

Then remove their rows from the routing table in `~/.claude/CLAUDE.md` section 3.3.

Less skills = less context used = sharper focus on what you actually do.

---

## Minutes 15-25: Fill in your memory files

Open `~/daemon-memory/MEMORY.md` and fill in the three key sections:

```markdown
## About Me
- [Your experience level and preferences]
- [Your preferred stack]
- [How you like responses formatted]

## Active Projects
- **ProjectName**: [What it is, priority, path]

## Rules
- [Cross-project rules that always apply]
```

Realistic example:
```markdown
## About Me
- 3 years experience. Comfortable with frontend, learning backend.
- Stack: Next.js, TypeScript, Tailwind, Supabase, Vercel.
- Give me the code directly. I'll ask if I need explanation.

## Active Projects
- **Acme SaaS** (Priority #1): B2B tool for project managers. Auth + subscriptions live. Path: ~/projects/acme/
- **Portfolio** (Priority #2): Personal site. Static Next.js. Path: ~/projects/portfolio/

## Rules
- TypeScript strict mode, no `any`
- pnpm only (not npm or yarn)
- Conventional commits
- Never commit .env files
```

Then open `~/daemon-memory/errors.md` and add one real error you've encountered recently, in the format shown in the template. Even one entry primes the system to check before coding.

---

## Minutes 25-30: Your first session — verify it's working

Start Claude Code:

```bash
claude
```

You should see Claude greet you normally. The system instructions are loaded silently — there's no banner announcing it.

**Test 1: Routing check**

Type:
```
build me a responsive navbar with a logo on the left and nav links on the right
```

Watch Claude's response. If routing is working, it should:
- Acknowledge this is a frontend task
- Either say "activating Hermione" or just proceed in Hermione's style (structured, tech-specific)
- Ask clarifying questions about your stack if it doesn't know yet

If Claude just responds generically without any skill context, say:
```
check your system instructions and routing table
```

Claude will re-read CLAUDE.md and correct course.

**Test 2: Memory check**

Type:
```
what are my active projects?
```

Claude should list the projects you put in MEMORY.md. If it says "I don't have that information", the memory path is wrong. Check that `~/daemon-memory/MEMORY.md` exists and the path in CLAUDE.md matches.

**Test 3: Error log check**

Type:
```
before you start any coding today, what do you know about past errors?
```

Claude should reference `errors.md` and summarize any entries you've added. This is the prevention loop working.

---

## What "working" looks like

When the system is correctly set up, you'll notice:

- Claude asks fewer repeated questions (it already knows your stack from MEMORY.md)
- Before coding, Claude mentions checking errors.md
- After building frontend code, Claude runs typecheck and lint without being asked
- Claude pushes back on vague requests instead of guessing
- When you say "build a login form with API route", Claude splits the work: Hermione for the UI, Neville for the backend

If any of these aren't happening, see the [troubleshooting section in README](../README.md#troubleshooting).

---

## Common first-session mistakes

**"I added my project but Claude still asks what stack I'm using"**
The MEMORY.md section needs to be specific. "Next.js app" is vague. "Next.js 14 App Router, TypeScript, Tailwind, Supabase, deployed on Vercel" is what Claude needs.

**"Skills aren't activating, Claude just responds generically"**
Check that skill files are in `~/.claude/skills/daemon/` (not `~/.claude/skills/`). The path must match what CLAUDE.md references in section 4.

**"The session ends and Claude forgets everything next time"**
The Memory Flush protocol should run at session end. Prompt it explicitly for your first few sessions: "end session and flush memory state". Claude will update `session-state.md` with what you worked on.
