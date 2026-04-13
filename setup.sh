#!/bin/bash
# Daemon Orchestrator - Setup Script
# Installs Daemon into your Claude Code environment

set -e

CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills/daemon"
MEMORY_DIR="$HOME/daemon-memory"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  daemon orchestrator - setup"
echo "  ================================"
echo ""

# 1. Backup existing CLAUDE.md if present
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    BACKUP="$CLAUDE_DIR/CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)"
    cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP"
    echo "  [backup] Existing CLAUDE.md saved to $BACKUP"
fi

# 2. Create directories
mkdir -p "$CLAUDE_DIR"
mkdir -p "$SKILLS_DIR"
mkdir -p "$MEMORY_DIR"

# 3. Copy CLAUDE.md
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  [ok] CLAUDE.md installed to $CLAUDE_DIR/"

# 4. Copy skills
cp "$SCRIPT_DIR"/skills/*.md "$SKILLS_DIR/"
SKILL_COUNT=$(ls -1 "$SKILLS_DIR"/*.md 2>/dev/null | wc -l)
echo "  [ok] $SKILL_COUNT skills installed to $SKILLS_DIR/"

# 5. Copy protocols into skills dir (Claude reads from skills/)
mkdir -p "$SKILLS_DIR/protocols"
cp "$SCRIPT_DIR"/protocols/*.md "$SKILLS_DIR/protocols/"
echo "  [ok] Protocols installed"

# 6. Copy memory templates
cp "$SCRIPT_DIR"/memory/*.md "$MEMORY_DIR/"
echo "  [ok] Memory templates installed to $MEMORY_DIR/"

# 7. Update memory path in CLAUDE.md
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s|~/daemon-memory/|$MEMORY_DIR/|g" "$CLAUDE_DIR/CLAUDE.md"
else
    sed -i "s|~/daemon-memory/|$MEMORY_DIR/|g" "$CLAUDE_DIR/CLAUDE.md"
fi

echo ""
echo "  Setup complete!"
echo ""
echo "  Next steps:"
echo "    1. Edit ~/.claude/CLAUDE.md - customize sections marked <!-- CUSTOMIZE -->"
echo "    2. Add your projects, MCP servers, and preferences"
echo "    3. Run 'claude' to start - Daemon is now active"
echo ""
