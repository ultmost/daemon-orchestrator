# Hooks Setup Guide

> This is the #1 gap in most CLAUDE.md-based systems: instructions can be forgotten or skipped; hooks cannot.

---

## What Are Hooks?

Claude Code supports a `hooks` field in `.claude/settings.json` that runs shell commands at specific lifecycle events. Unlike CLAUDE.md instructions, hooks are enforced at the platform level — Claude cannot skip them even if it tries.

**Why this matters:**
- CLAUDE.md says "read errors.md before every technical task" — Claude sometimes forgets
- A `session-start` hook that literally runs `cat ~/daemon-memory/errors.md` CANNOT be forgotten
- Hooks bridge the gap between "instructions" and "guarantees"

---

## Supported Hook Events

| Event | When it fires | Best use |
|-------|--------------|----------|
| `session-start` | When Claude Code opens a new session | Load memory, print context |
| `session-end` | When session closes | Flush state, log summary |
| `post-tool` | After every tool call | Track file changes, audit logs |
| `pre-tool` | Before every tool call | Safety checks, confirmations |

---

## Example settings.json with Hooks

Create or edit `~/.claude/settings.json`:

```json
{
  "hooks": {
    "session-start": [
      {
        "command": "python3 ~/.claude/hooks/session_start.py",
        "description": "Load daemon memory context at session start"
      }
    ],
    "session-end": [
      {
        "command": "python3 ~/.claude/hooks/session_end.py",
        "description": "Flush session state and log summary"
      }
    ],
    "post-tool": [
      {
        "command": "python3 ~/.claude/hooks/track_changes.py",
        "description": "Track file modifications for audit log"
      }
    ]
  }
}
```

---

## hooks.py Examples

### session_start.py — Load Memory Context

```python
#!/usr/bin/env python3
"""
Runs at the start of every Claude Code session.
Prints memory context so Claude is immediately aware of:
- Active projects
- Recent errors (to not repeat)
- Pending items from last session
"""
import os
import sys
from pathlib import Path
from datetime import datetime

MEMORY_DIR = Path.home() / "daemon-memory"

def load_file(path: Path, max_lines: int = 20) -> str:
    if not path.exists():
        return f"(not found: {path})"
    lines = path.read_text(encoding="utf-8").splitlines()
    if len(lines) <= max_lines:
        return "\n".join(lines)
    # Return last N lines (most recent)
    return "\n".join(lines[-max_lines:])

def main():
    print("=" * 60)
    print(f"DAEMON SESSION START — {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    print("=" * 60)

    # Load recent errors (most important — don't repeat mistakes)
    print("\n--- RECENT ERRORS (last 10 lines) ---")
    print(load_file(MEMORY_DIR / "errors.md", max_lines=10))

    # Load session state (pending items)
    print("\n--- PENDING FROM LAST SESSION ---")
    print(load_file(MEMORY_DIR / "session-state.md", max_lines=15))

    # Load active projects summary
    print("\n--- ACTIVE PROJECTS ---")
    print(load_file(MEMORY_DIR / "MEMORY.md", max_lines=20))

    print("\n" + "=" * 60)
    print("Memory loaded. Routing rules active. Ready.")
    print("=" * 60 + "\n")

if __name__ == "__main__":
    main()
```

### session_end.py — Flush Session State

```python
#!/usr/bin/env python3
"""
Runs at the end of every Claude Code session.
Appends a timestamp marker to session-state.md as a checkpoint.
Claude should write its own summary before this runs,
but this guarantees a record even if it forgets.
"""
import os
from pathlib import Path
from datetime import datetime

MEMORY_DIR = Path.home() / "daemon-memory"
SESSION_STATE = MEMORY_DIR / "session-state.md"

def main():
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    marker = f"\n\n---\n_Session closed at {timestamp}_\n"

    SESSION_STATE.parent.mkdir(parents=True, exist_ok=True)
    with open(SESSION_STATE, "a", encoding="utf-8") as f:
        f.write(marker)

    print(f"Session state checkpoint written at {timestamp}")

if __name__ == "__main__":
    main()
```

### track_changes.py — Post-Tool Audit Log

```python
#!/usr/bin/env python3
"""
Runs after every tool call.
Logs file writes/edits to an audit trail.
Useful for reviewing what changed in a session.
Reads tool result from stdin (JSON).
"""
import json
import sys
import os
from pathlib import Path
from datetime import datetime

MEMORY_DIR = Path.home() / "daemon-memory"
AUDIT_LOG = MEMORY_DIR / "audit.log"

def main():
    # Claude Code passes tool info via stdin
    try:
        data = json.loads(sys.stdin.read())
    except (json.JSONDecodeError, EOFError):
        return

    tool_name = data.get("tool", "")

    # Only track file-modifying tools
    if tool_name not in ("Write", "Edit", "Bash"):
        return

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    target = data.get("params", {}).get("file_path") or data.get("params", {}).get("command", "")[:80]

    AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)
    with open(AUDIT_LOG, "a", encoding="utf-8") as f:
        f.write(f"[{timestamp}] {tool_name}: {target}\n")

if __name__ == "__main__":
    main()
```

---

## Installation

```bash
# Create hooks directory
mkdir -p ~/.claude/hooks

# Copy scripts (from daemon-orchestrator)
cp docs/hooks/*.py ~/.claude/hooks/

# Make executable
chmod +x ~/.claude/hooks/*.py

# Verify settings.json exists
cat ~/.claude/settings.json
```

---

## The Core Insight

> Instructions tell Claude what to do. Hooks make sure it happens.

The combination is what makes the system robust:
- **CLAUDE.md** provides reasoning context and behavioral guidelines
- **Hooks** enforce the non-negotiable parts (memory load, state flush, audit trail)

Think of CLAUDE.md as the training and hooks as the safety rails.

---

## Inspiration

This pattern is explored in [claude-code-best-practice](https://github.com/grahama1970/claude-code-best-practice) and the [Anthropic engineering blog](https://www.anthropic.com/engineering/managed-agents). The key insight from both: the more you can move from "Claude is instructed to" toward "the system enforces", the more reliable your workflow becomes.
