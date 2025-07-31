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

# Create minimal CLAUDE.md
cat > "$DIR/CLAUDE.md" << 'EOF'
# Claude Agents

## Quick Start
```
> Use agent-architect to set up agents for this project
```

The agent-architect will analyze your project and create appropriate agents.

## Upgrading
```
> Use agent-architect to upgrade agents
```
EOF

# Create VERSION
echo "2.0.0" > "$DIR/.claude/VERSION"

echo "✅ Done! Use 'agent-architect' in Claude Code to set up project-specific agents."