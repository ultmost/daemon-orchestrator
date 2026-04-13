# Minimal Setup (Lite Mode)

Don't want 17 skills and a full memory system? Start here.

This gets you 80% of the value with 20% of the setup time. No MCPs required. Works with any stack.

---

## What Lite Mode includes

**5 skills only:**
- `hermione.md` — Frontend builder
- `neville.md` — Backend builder
- `minerva.md` — Code review before committing
- `severus.md` — Security check (auto-triggers on auth/payments)
- `council.md` — When you need to think through a decision

**2 protocols:**
- `auto-verify.md` — typecheck + lint + build after every change
- `circuit-breaker.md` — stops infinite error loops

**Memory (simplified):**
- `MEMORY.md` — who you are and your projects
- `errors.md` — past mistakes (the most valuable file)
- `session-state.md` — what you were working on

**What's NOT included in Lite Mode:**
- No Dobby (daily brief)
- No Hedwig (deep research)
- No George, Fred, Rita Skeeter (business/ads/social)
- No Lucius, Lupin (PDF/study)
- No ProofShot, Pomfrey (require MCP Browser)
- No MCP servers required

---

## Install (Lite)

```bash
git clone https://github.com/ultmost/daemon-orchestrator.git
cd daemon-orchestrator
bash setup.sh
```

Then remove what you don't need:

```bash
# Remove optional skills
cd ~/.claude/skills/daemon
rm dobby.md hedwig.md george.md fred.md rita-skeeter.md lucius.md lupin.md proofshot.md pomfrey.md prd.md claude-api.md what-if-oracle.md
```

Then open `~/.claude/CLAUDE.md` and delete the rows for those skills from the routing table (section 3). The routing table is a markdown table — just delete the rows for the skills you removed.

Also remove the automatic protocol references in section 7 for ProofShot and Daily Brief (since those skills no longer exist).

---

## Minimal CLAUDE.md (Lite version)

After pruning, your routing table should look like this:

```markdown
## 3. ROUTING

### Build Skills
| Skill       | When to call                          |
|-------------|---------------------------------------|
| hermione    | Any UI/frontend/CSS/component request |
| neville     | Any API/database/backend request      |

### Quality Skills
| Skill    | When to call                                        |
|----------|-----------------------------------------------------|
| minerva  | "review code", "before commit". Auto after builds.  |
| severus  | "security". Auto when touching auth or payments.    |

### Decision Skills
| Skill   | When to call                      |
|---------|-----------------------------------|
| council | Any trade-off or "what do you think?" |

### Routing Rule
  1. Frontend?   --> hermione
  2. Backend?    --> neville
  3. Review?     --> minerva
  4. Security?   --> severus
  5. Decision?   --> council
  6. Nothing?    --> act directly
```

---

## Minimal MEMORY.md (Lite version)

```markdown
# Memory

## About Me
- [Your experience and preferences]
- [Your stack]

## Active Projects
- **ProjectName**: [what it is, path]

## Rules
- [2-3 rules that always apply]

## Boot
- Read errors.md before any technical task
- Read session-state.md to resume where you left off
```

---

## Minimal errors.md (start with one real entry)

Don't leave errors.md empty. Add one real mistake from your past:

```markdown
# Error Log

### [type] What went wrong (date)
- **What happened**: [description]
- **Root cause**: [why]
- **Fix**: [what fixed it]
- **Prevention**: [rule to prevent recurrence]
```

Even a single entry gets Claude checking before coding. The log grows organically.

---

## When to upgrade from Lite to Full

Add skills when you hit a real need, not before:

| You find yourself doing this manually... | Add this skill |
|------------------------------------------|----------------|
| Researching docs/libraries mid-task | Hedwig |
| Starting every session re-explaining context | Dobby |
| Building UI that needs visual verification | ProofShot + MCP Browser |
| Running campaigns or ad tracking | Fred, George |
| Posting content on LinkedIn/X | Rita Skeeter |
| Creating client proposals or pitch decks | Lucius |

Don't add skills preemptively. Each one adds context tokens and routing complexity. Lite Mode stays leaner and often faster for focused work.

---

## No MCPs? No problem.

The core build/review/decision loop works entirely without MCPs:

- Hermione generates code (no external service needed)
- Neville generates code and migrations (no Supabase MCP needed to write the SQL)
- Minerva reviews code (reads files, no external service)
- Severus audits code (reads files, no external service)
- Council debates (no external service)

You only need MCPs when you want Claude to *execute* against a live service: run a migration, take a screenshot, SSH into a server. For code generation and review, MCPs are optional.
