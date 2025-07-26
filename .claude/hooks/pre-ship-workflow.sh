#!/bin/bash

# Pre-ship workflow hook - Basic validation before ship operations

set -euo pipefail

# Basic validation functions
validate_syntax() {
    local file="$1"
    local ext="${file##*.}"
    
    case "$ext" in
        json) jq empty "$file" 2>/dev/null || return 1 ;;
        yml|yaml) python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null || return 1 ;;
        sh) bash -n "$file" || return 1 ;;
        py) python3 -m py_compile "$file" || return 1 ;;
        js|ts) node -c "$file" 2>/dev/null || return 1 ;;
    esac
    return 0
}

# Main validation
main() {
    echo "Running pre-ship validation..."
    
    # Get modified files
    local modified_files
    if command -v git >/dev/null 2>&1; then
        modified_files=$(git diff --cached --name-only 2>/dev/null || echo "")
    else
        modified_files=""
    fi
    
    local error_count=0
    
    for file in $modified_files; do
        if [[ -f "$file" ]]; then
            echo "Validating $file..."
            if ! validate_syntax "$file"; then
                echo "✗ Syntax error in $file"
                ((error_count++))
            else
                echo "✓ $file is valid"
            fi
        fi
    done
    
    if [[ $error_count -gt 0 ]]; then
        echo "Pre-ship validation failed with $error_count errors"
        exit 1
    else
        echo "✓ Pre-ship validation passed"
        exit 0
    fi
}

main "$@"