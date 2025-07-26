#!/bin/bash

# Auto-delegate agent hook script
# Suggests appropriate agents based on file patterns

set -euo pipefail

# Simple function to suggest agents based on file patterns
suggest_agent() {
    local filepath="$1"
    [[ -z "$filepath" ]] && return 1
    
    local filename
    filename=$(basename "$filepath")
    local ext="${filename##*.}"
    
    # Frontend patterns
    if [[ "$ext" =~ ^(js|jsx|ts|tsx|html|css|scss|vue|svelte)$ ]] || 
       [[ "$filepath" =~ (components|pages|styles|frontend|ui)/ ]]; then
        echo "SUGGEST: Use frontend-developer agent for $filename"
        return 0
    fi
    
    # Backend patterns  
    if [[ "$ext" =~ ^(py|go|java|rs|php|rb|sql)$ ]] || 
       [[ "$filepath" =~ (backend|api|server|models)/ ]]; then
        echo "SUGGEST: Use backend-developer agent for $filename"
        return 0
    fi
    
    # Infrastructure patterns
    if [[ "$ext" =~ ^(yml|yaml|tf|dockerfile)$ ]] || 
       [[ "$filepath" =~ (infrastructure|deployment|k8s|terraform)/ ]]; then
        echo "SUGGEST: Use sre-devops-specialist agent for $filename"
        return 0
    fi
    
    # Testing patterns
    if [[ "$filename" =~ (test|spec) ]] || [[ "$filepath" =~ tests?/ ]]; then
        echo "SUGGEST: Use qa-testing-specialist agent for $filename"
        return 0
    fi
    
    # Security patterns
    if [[ "$filename" =~ (security|auth) ]] || [[ "$filepath" =~ security/ ]]; then
        echo "SUGGEST: Use security-compliance-auditor agent for $filename"
        return 0
    fi
    
    # Documentation patterns
    if [[ "$ext" =~ ^(md|rst|txt)$ ]] || [[ "$filepath" =~ docs?/ ]]; then
        echo "SUGGEST: Use product-requirements-analyst agent for $filename"
        return 0
    fi
    
    return 1
}

# Main execution
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <filepath>"
    exit 1
fi

suggest_agent "$1"