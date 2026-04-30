#!/bin/bash
# Daemon Orchestrator - Setup Script
# Installs Daemon into your Claude Code environment

set -e

CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills/daemon"
AGENTS_DIR="$CLAUDE_DIR/agents"
MEMORY_DIR="$HOME/daemon-memory"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WELCOME_FLAG="$CLAUDE_DIR/.daemon-welcomed"

# colors (best-effort, skipped if no tty)
if [ -t 1 ]; then
    BOLD=$'\033[1m'
    DIM=$'\033[2m'
    CYAN=$'\033[36m'
    GREEN=$'\033[32m'
    YELLOW=$'\033[33m'
    RESET=$'\033[0m'
else
    BOLD=""; DIM=""; CYAN=""; GREEN=""; YELLOW=""; RESET=""
fi

print_banner() {
    echo ""
    echo "${CYAN}${BOLD}  ┌─────────────────────────────────────────────┐${RESET}"
    echo "${CYAN}${BOLD}  │           daemon orchestrator              │${RESET}"
    echo "${CYAN}${BOLD}  │           setup & first-run                │${RESET}"
    echo "${CYAN}${BOLD}  └─────────────────────────────────────────────┘${RESET}"
    echo ""
    echo "${DIM}  built by Vitor Araujo (@ultmost) - shared with the world.${RESET}"
    echo "${DIM}  https://github.com/ultmost/daemon-orchestrator${RESET}"
    echo ""
}

ask() {
    local prompt="$1"
    local default="$2"
    local answer
    if [ -n "$default" ]; then
        read -r -p "  ${prompt} [${default}]: " answer
        echo "${answer:-$default}"
    else
        read -r -p "  ${prompt}: " answer
        echo "$answer"
    fi
}

print_banner

# ─── 1. Welcome / detect first install ─────────────────────────────
FIRST_RUN=0
if [ ! -f "$WELCOME_FLAG" ]; then
    FIRST_RUN=1
    echo "${BOLD}  Hi there.${RESET}"
    echo ""
    echo "  This installs ${BOLD}Daemon${RESET}, an orchestration layer for Claude Code:"
    echo "    - 21 specialized skills (frontend, backend, review, security, research, ...)"
    echo "    - 4 verification subagents that run in parallel after every build"
    echo "    - quality protocols (auto-verify, auto-review, circuit breaker)"
    echo "    - persistent memory so Claude remembers context across sessions"
    echo ""
    echo "  Daemon was originally built by ${BOLD}Vitor Araujo${RESET} for his own daily workflow"
    echo "  and is shared as MIT for anyone starting with AI-assisted coding."
    echo ""
    if [ -t 0 ]; then
        read -r -p "  Press ${BOLD}Enter${RESET} to continue..." _
    fi
    echo ""
fi

# ─── 2. Optional interactive customization ──────────────────────────
USER_NAME=""
USER_LANG="English"

if [ "$FIRST_RUN" = "1" ] && [ -t 0 ]; then
    echo "${BOLD}  Quick setup (3 questions, all optional):${RESET}"
    echo ""
    USER_NAME=$(ask "What should Daemon call you?" "$(whoami)")
    USER_LANG=$(ask "Communication language" "English")
    echo ""
fi

# ─── 3. Backup existing CLAUDE.md ───────────────────────────────────
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
    BACKUP="$CLAUDE_DIR/CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)"
    cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP"
    echo "  ${YELLOW}[backup]${RESET} existing CLAUDE.md saved to ${DIM}$BACKUP${RESET}"
fi

# ─── 4. Create directories ──────────────────────────────────────────
mkdir -p "$CLAUDE_DIR" "$SKILLS_DIR" "$AGENTS_DIR" "$MEMORY_DIR"

# ─── 5. Copy CLAUDE.md, skills, agents, protocols, memory ───────────
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "  ${GREEN}[ok]${RESET} CLAUDE.md installed at ${DIM}$CLAUDE_DIR/${RESET}"

cp "$SCRIPT_DIR"/skills/*.md "$SKILLS_DIR/"
SKILL_COUNT=$(ls -1 "$SKILLS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
echo "  ${GREEN}[ok]${RESET} ${SKILL_COUNT} skills installed at ${DIM}$SKILLS_DIR/${RESET}"

if [ -d "$SCRIPT_DIR/agents" ]; then
    cp "$SCRIPT_DIR"/agents/*.md "$AGENTS_DIR/"
    AGENT_COUNT=$(ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
    echo "  ${GREEN}[ok]${RESET} ${AGENT_COUNT} subagents installed at ${DIM}$AGENTS_DIR/${RESET}"
fi

mkdir -p "$SKILLS_DIR/protocols"
cp "$SCRIPT_DIR"/protocols/*.md "$SKILLS_DIR/protocols/"
echo "  ${GREEN}[ok]${RESET} protocols installed"

# memory templates - never overwrite if user already has notes
for f in "$SCRIPT_DIR"/memory/*.md; do
    fname=$(basename "$f")
    if [ ! -f "$MEMORY_DIR/$fname" ]; then
        cp "$f" "$MEMORY_DIR/$fname"
    fi
done
echo "  ${GREEN}[ok]${RESET} memory templates at ${DIM}$MEMORY_DIR/${RESET}"

# ─── 6. Apply customization to CLAUDE.md ─────────────────────────────
SED_INPLACE=( -i )
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_INPLACE=( -i '' )
fi

# memory path
sed "${SED_INPLACE[@]}" "s|~/daemon-memory/|$MEMORY_DIR/|g" "$CLAUDE_DIR/CLAUDE.md"

# language
if [ -n "$USER_LANG" ] && [ "$USER_LANG" != "English" ]; then
    sed "${SED_INPLACE[@]}" "s|Communication: English (or your preferred language)|Communication: $USER_LANG|" "$CLAUDE_DIR/CLAUDE.md"
fi

# user name (added as a comment near the top so Claude knows)
if [ -n "$USER_NAME" ]; then
    if ! grep -q "User name:" "$CLAUDE_DIR/CLAUDE.md"; then
        # insert "User name: X" right after the title
        awk -v name="$USER_NAME" '
            NR==1 { print; print ""; print "> User name: " name; next }
            { print }
        ' "$CLAUDE_DIR/CLAUDE.md" > "$CLAUDE_DIR/CLAUDE.md.tmp" && mv "$CLAUDE_DIR/CLAUDE.md.tmp" "$CLAUDE_DIR/CLAUDE.md"
    fi
fi

# ─── 7. First-run greeting flag ──────────────────────────────────────
if [ "$FIRST_RUN" = "1" ]; then
    cat > "$WELCOME_FLAG" <<EOF
installed_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
user_name=${USER_NAME}
EOF

    # drop a session-start nudge so Claude greets the user the first time
    GREETING_FILE="$MEMORY_DIR/first-run-greeting.md"
    cat > "$GREETING_FILE" <<EOF
# First-Run Greeting (one-shot)

When this file exists, Daemon should greet the user on the very next message before doing anything else, then DELETE this file.

Greeting template (adapt to the language in CLAUDE.md section 2):

---
Hi${USER_NAME:+ $USER_NAME}, welcome.

I am Daemon, an orchestration layer for Claude Code. I was originally built by Vitor Araujo (@ultmost on GitHub) for his own workflow and shared publicly under MIT so anyone starting with AI-assisted coding can use it.

What I do for you:
- Route every task to the right specialist skill (frontend, backend, review, security, research, ...)
- Run quality checks automatically after each build (review + security + QA + visual proof)
- Remember context across sessions in ${MEMORY_DIR}
- Never write production code directly - always delegate to a builder skill

What I would like from you in this first conversation:
1. Tell me what you are working on (a project, a learning goal, just exploring?)
2. Show me the folder/repo if you have one, or describe the idea
3. Ask me anything - I will pick the right skill and explain what I am doing

When you are ready, just describe your first task in plain language. No commands needed.
---

After greeting, DELETE this file: \`rm "$GREETING_FILE"\`
EOF
    echo "  ${GREEN}[ok]${RESET} first-run greeting prepared"
fi

# ─── 8. Done ─────────────────────────────────────────────────────────
echo ""
echo "${GREEN}${BOLD}  ✓ Setup complete.${RESET}"
echo ""
echo "${BOLD}  Next steps:${RESET}"
echo "    1. ${CYAN}claude${RESET}                                  # start Claude Code"
echo "    2. Type your first task in plain language"
echo "    3. Daemon will greet you and route automatically"
echo ""
echo "${DIM}  Files installed:${RESET}"
echo "${DIM}    $CLAUDE_DIR/CLAUDE.md${RESET}"
echo "${DIM}    $SKILLS_DIR/         (${SKILL_COUNT} skills)${RESET}"
echo "${DIM}    $AGENTS_DIR/         (${AGENT_COUNT:-0} subagents)${RESET}"
echo "${DIM}    $MEMORY_DIR/         (memory templates)${RESET}"
echo ""
echo "${DIM}  Documentation:${RESET}"
echo "${DIM}    docs/first-30-minutes.md        - step-by-step guide${RESET}"
echo "${DIM}    docs/customization.md           - tune CLAUDE.md to your stack${RESET}"
echo "${DIM}    https://github.com/ultmost/daemon-orchestrator${RESET}"
echo ""
