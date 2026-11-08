#!/bin/bash
# Claude Agents - Simple Installer

set -e

REPO="https://raw.githubusercontent.com/charles-adedotun/claude-code-sub-agents/main"
DIR="${1:-.}"

echo "🤖 Installing Claude Agents..."

# Create directories
mkdir -p "$DIR/.claude/agents" "$DIR/.claude/hooks" "$DIR/.claude/templates"

# Download agent-architect (the only essential agent)
curl -fsSL "$REPO/.claude/agents/agent-architect.md" -o "$DIR/.claude/agents/agent-architect.md" || {
    echo "❌ Failed to download. Check internet connection."
    exit 1
}

# Download essential hook
curl -fsSL "$REPO/.claude/hooks/auto-agent-setup.sh" -o "$DIR/.claude/hooks/auto-agent-setup.sh"
chmod +x "$DIR/.claude/hooks/auto-agent-setup.sh"

# Download template
curl -fsSL "$REPO/.claude/templates/agent.template.md" -o "$DIR/.claude/templates/agent.template.md"

# Download settings
curl -fsSL "$REPO/.claude/settings.json" -o "$DIR/.claude/settings.json"

# Preserve existing CLAUDE.md or create a new one (fixes Issue #6)
AGENTS_BLOCK=$(cat << 'EOF'

## Available Claude Agents

- **agent-architect**: Analyzes your project stack and generates focused sub-agents in `.claude/agents/`

### Quick Start
```
> Use agent-architect to set up agents for this project
```

### Upgrading
```
> Use agent-architect to upgrade agents
```
EOF
)

if [ -f "$DIR/CLAUDE.md" ]; then
    if grep -qE "^## Available Claude Agents|^# Claude Agents" "$DIR/CLAUDE.md"; then
        echo "ℹ️  Existing CLAUDE.md already contains a Claude Agents section — preserved untouched."
    else
        printf "%s\n" "$AGENTS_BLOCK" >> "$DIR/CLAUDE.md"
        echo "✅ Appended '## Available Claude Agents' section to existing CLAUDE.md (preserved all project context)."
    fi
else
    printf "# Claude Agents\n%s\n" "$AGENTS_BLOCK" > "$DIR/CLAUDE.md"
    echo "✅ Created CLAUDE.md with Claude Agents quick start."
fi

# Create VERSION
echo "1.0.7" > "$DIR/.claude/VERSION"

echo "✅ Done! Use 'agent-architect' in Claude Code to set up project-specific agents."