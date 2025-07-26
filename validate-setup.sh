#!/bin/bash

# Sub-Agent Ecosystem Validation Script
# Validates that all components are properly configured and functional

set -euo pipefail

echo "🔍 Validating Sub-Agent Ecosystem Setup..."
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track validation results
ERRORS=0
WARNINGS=0

# Function to print status messages
print_status() {
    local status="$1"
    local message="$2"
    case "$status" in
        "OK")    echo -e "${GREEN}✅ $message${NC}" ;;
        "WARN")  echo -e "${YELLOW}⚠️  $message${NC}"; ((WARNINGS++)) ;;
        "ERROR") echo -e "${RED}❌ $message${NC}"; ((ERRORS++)) ;;
        "INFO")  echo -e "${BLUE}ℹ️  $message${NC}" ;;
    esac
}

echo -e "\n${BLUE}1. Validating Agent Configurations${NC}"
echo "-----------------------------------"

# Check if .claude directory exists
if [ ! -d ".claude" ]; then
    print_status "ERROR" ".claude directory not found"
    exit 1
else
    print_status "OK" ".claude directory exists"
fi

# Check agent files
EXPECTED_AGENTS=(
    "product-requirements-analyst.md"
    "frontend-developer.md"
    "backend-developer.md"
    "sre-devops-specialist.md"
    "qa-testing-specialist.md"
    "security-compliance-auditor.md"
    "pre-commit-reviewer.md"
)

for agent in "${EXPECTED_AGENTS[@]}"; do
    if [ -f ".claude/agents/$agent" ]; then
        print_status "OK" "Agent $agent exists"
        
        # Validate agent file structure
        if grep -q "^name:" ".claude/agents/$agent" && \
           grep -q "^description:" ".claude/agents/$agent" && \
           grep -q "^tools:" ".claude/agents/$agent"; then
            print_status "OK" "Agent $agent has valid structure"
        else
            print_status "ERROR" "Agent $agent missing required fields (name, description, tools)"
        fi
    else
        print_status "ERROR" "Agent $agent not found"
    fi
done

echo -e "\n${BLUE}2. Validating Hook Scripts${NC}"
echo "----------------------------"

# Check hook scripts
HOOK_SCRIPTS=(
    "auto-delegate-agent.sh"
    "pre-ship-workflow.sh"
    "pre-commit-review.sh"
)

for script in "${HOOK_SCRIPTS[@]}"; do
    if [ -f ".claude/hooks/$script" ]; then
        print_status "OK" "Hook script $script exists"
        
        # Check if executable
        if [ -x ".claude/hooks/$script" ]; then
            print_status "OK" "Hook script $script is executable"
        else
            print_status "WARN" "Hook script $script is not executable (run: chmod +x .claude/hooks/$script)"
        fi
        
        # Basic syntax check
        if bash -n ".claude/hooks/$script" 2>/dev/null; then
            print_status "OK" "Hook script $script has valid syntax"
        else
            print_status "ERROR" "Hook script $script has syntax errors"
        fi
    else
        print_status "ERROR" "Hook script $script not found"
    fi
done

echo -e "\n${BLUE}3. Validating Settings Configuration${NC}"
echo "-------------------------------------"

# Check settings.json
if [ -f ".claude/settings.json" ]; then
    print_status "OK" "settings.json exists"
    
    # Validate JSON syntax
    if jq empty ".claude/settings.json" 2>/dev/null; then
        print_status "OK" "settings.json has valid JSON syntax"
        
        # Check for required hook configuration
        if jq -e '.hooks.PostToolUse' ".claude/settings.json" >/dev/null 2>&1; then
            print_status "OK" "PostToolUse hooks configured"
        else
            print_status "WARN" "PostToolUse hooks not configured"
        fi
        
        if jq -e '.hooks.PreToolUse' ".claude/settings.json" >/dev/null 2>&1; then
            print_status "OK" "PreToolUse hooks configured"
        else
            print_status "WARN" "PreToolUse hooks not configured"
        fi
    else
        print_status "ERROR" "settings.json has invalid JSON syntax"
    fi
else
    print_status "ERROR" "settings.json not found"
fi

echo -e "\n${BLUE}4. Validating Documentation${NC}"
echo "------------------------------"

# Check documentation files
DOCS=(
    "README.md"
    "CLAUDE.md"
    ".claude/AGENT_CLASSIFICATION.md"
)

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        print_status "OK" "Documentation $doc exists"
        
        # Check if file is not empty
        if [ -s "$doc" ]; then
            print_status "OK" "Documentation $doc is not empty"
        else
            print_status "WARN" "Documentation $doc is empty"
        fi
    else
        print_status "ERROR" "Documentation $doc not found"
    fi
done

echo -e "\n${BLUE}5. Validating Agent Name Consistency${NC}"
echo "---------------------------------------------"

# Check if hook scripts reference correct agent names
if [ -f ".claude/hooks/auto-delegate-agent.sh" ]; then
    # Check for updated agent names in the delegation script
    AGENT_REFS=(
        "qa-testing-specialist"
        "frontend-developer"
        "backend-developer"
        "sre-devops-specialist"
        "security-compliance-auditor"
        "product-requirements-analyst"
    )
    
    for agent_ref in "${AGENT_REFS[@]}"; do
        if grep -q "$agent_ref" ".claude/hooks/auto-delegate-agent.sh"; then
            print_status "OK" "Auto-delegate script references $agent_ref"
        else
            print_status "WARN" "Auto-delegate script missing reference to $agent_ref"
        fi
    done
fi

echo -e "\n${BLUE}6. Security Validation${NC}"
echo "------------------------"

# Check for potential security issues
if [ -f ".gitignore" ]; then
    print_status "OK" ".gitignore exists"
    
    # Check if important files are ignored
    if grep -q "\.env" ".gitignore"; then
        print_status "OK" ".env files are ignored"
    else
        print_status "WARN" ".env files not in .gitignore"
    fi
    
    if grep -q "\.log" ".gitignore"; then
        print_status "OK" "Log files are ignored"
    else
        print_status "WARN" "Log files not in .gitignore"
    fi
else
    print_status "WARN" ".gitignore not found"
fi

# Check for hardcoded secrets in scripts (excluding legitimate security patterns)
if grep -r -i -E "(password|secret|key|token)\s*[:=]\s*[\"'][^\"']+[\"']" .claude/hooks/ --exclude="*.log" | grep -v "example\|placeholder\|TODO\|FIXME\|pattern\|regex\|\[\[\:space\:\]\]\|\[a-zA-Z0-9\]" | head -1 >/dev/null; then
    print_status "WARN" "Potential hardcoded secrets found in hook scripts"
else
    print_status "OK" "No obvious hardcoded secrets in hook scripts"
fi

echo -e "\n${BLUE}7. File Permissions Check${NC}"
echo "-----------------------------"

# Check critical file permissions
if [ -d ".claude" ]; then
    CLAUDE_PERMS=$(stat -f "%A" .claude 2>/dev/null || stat -c "%a" .claude 2>/dev/null || echo "unknown")
    if [[ "$CLAUDE_PERMS" =~ ^7[0-7][0-7]$ ]]; then
        print_status "OK" ".claude directory permissions are secure ($CLAUDE_PERMS)"
    else
        print_status "WARN" ".claude directory permissions may be too permissive ($CLAUDE_PERMS)"
    fi
fi

# Final summary
echo -e "\n${BLUE}📊 Validation Summary${NC}"
echo "===================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    print_status "OK" "All validations passed! Your sub-agent ecosystem is ready to use."
    echo -e "\n${GREEN}🚀 Ready for deployment!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    print_status "WARN" "Validation completed with $WARNINGS warnings (non-critical)"
    echo -e "\n${YELLOW}⚠️  System is functional but has minor issues to address${NC}"
    exit 0
else
    print_status "ERROR" "Validation failed with $ERRORS errors and $WARNINGS warnings"
    echo -e "\n${RED}❌ Please fix the errors before using the system${NC}"
    exit 1
fi