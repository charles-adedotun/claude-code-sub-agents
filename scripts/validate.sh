#!/bin/bash
# Quick validation & regression test suite for claude-code-sub-agents
set -euo pipefail

echo "🔍 Validating Claude Agents..."

# 1. Check repository structure
[ -d ".claude/agents" ] && echo "✅ Agents directory exists" || { echo "❌ Missing .claude/agents"; exit 1; }
[ -f ".claude/agents/agent-architect.md" ] && echo "✅ Agent architect exists" || { echo "❌ Missing agent-architect"; exit 1; }
[ -x ".claude/hooks/auto-agent-setup.sh" ] && echo "✅ Hook is executable" || { echo "❌ Hook not executable"; exit 1; }
[ -f ".claude/VERSION" ] && echo "✅ Version file exists" || { echo "❌ Missing VERSION"; exit 1; }

# 2. Regression test for Issue #6: Preserve existing CLAUDE.md content and append idempotently
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

cat > "$TMP_DIR/CLAUDE.md" << 'EOF'
# My Existing Project
- Critical build command: `npm run test`
- Architecture notes: Do not delete!
EOF

# Run installer against TMP_DIR
bash ./init.sh "$TMP_DIR"

# Verify original lines still exist
grep -q "Critical build command: \`npm run test\`" "$TMP_DIR/CLAUDE.md" || {
    echo "❌ Regression: Existing CLAUDE.md content was overwritten!"
    exit 1
}
# Verify new section was appended
grep -q "^## Available Claude Agents" "$TMP_DIR/CLAUDE.md" || {
    echo "❌ Regression: '## Available Claude Agents' section was not appended!"
    exit 1
}

# Run a second time to verify idempotency (section appears exactly once)
bash ./init.sh "$TMP_DIR"
COUNT=$(grep -c "^## Available Claude Agents" "$TMP_DIR/CLAUDE.md")
[ "$COUNT" -eq 1 ] || {
    echo "❌ Regression: '## Available Claude Agents' duplicated ($COUNT times)!"
    exit 1
}

echo "✅ Issue #6 regression test passed (existing CLAUDE.md preserved & idempotent)."
echo "Done!"
