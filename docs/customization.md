# Customization Guide

## Step 1: Configure Your Identity

Edit `CLAUDE.md` section 1 and 2:
- Set your preferred language
- Adjust communication style

## Step 2: Add Your Projects

Edit `CLAUDE.md` section 5:
- List your active projects
- Set paths and constraints
- Define project isolation rules

## Step 3: Configure MCP Servers

Edit `CLAUDE.md` section 8:
- Add your Supabase instances
- Configure SSH connections
- Add any other MCP servers you use

## Step 4: Customize Skills

Each skill in `skills/` can be customized:
- Adjust tech stack (e.g., change Next.js to Remix)
- Modify triggers for your workflow
- Add project-specific rules

## Step 5: Set Up Memory

Edit `memory/MEMORY.md`:
- Add information about yourself
- Add your active projects
- Set your rules and limits

## Adding New Skills

Create a new `.md` file in `skills/` following the template:

```markdown
# SkillName - Short Description

> One-line summary of what this skill does.

## Triggers
- [when this skill activates]

## Does NOT trigger on
- [what this skill does NOT handle]

## Process
1. [step 1]
2. [step 2]

## Critical Rules
- [rule 1]
- [rule 2]
```

Then add it to the routing table in `CLAUDE.md` section 3.

## Adding New Protocols

Create a new `.md` file in `protocols/` and reference it in `CLAUDE.md` section 6.

## Tips

- Start with the defaults and customize as you work
- Add to errors.md and learnings.md as you encounter issues
- The system improves over time as your memory grows
- Don't over-customize on day 1. Let the system tell you what needs changing
