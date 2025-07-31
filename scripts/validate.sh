#!/bin/bash
# Quick validation

echo "🔍 Validating Claude Agents..."

# Check structure
[ -d ".claude/agents" ] && echo "✅ Agents directory exists" || echo "❌ Missing .claude/agents"
[ -f ".claude/agents/agent-architect.md" ] && echo "✅ Agent architect exists" || echo "❌ Missing agent-architect"
[ -x ".claude/hooks/auto-agent-setup.sh" ] && echo "✅ Hook is executable" || echo "❌ Hook not executable"
[ -f ".claude/VERSION" ] && echo "✅ Version file exists" || echo "❌ Missing VERSION"

echo "Done!"