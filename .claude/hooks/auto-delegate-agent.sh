#!/bin/bash

# Auto-delegate agent hook script
# Analyzes file paths and suggests appropriate agents based on patterns
# Enhanced to handle JSON context input and async execution
#
# SECURITY: Enhanced with comprehensive security controls
# - Secure file permissions for logs
# - Enhanced JSON validation and sanitization
# - Safe pattern matching to prevent ReDoS attacks
# - Proper input validation and timeout handling

set -euo pipefail  # Enhanced error handling

# Security: Dynamic path resolution
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CLAUDE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly LOG_PERMISSIONS=600  # Secure log file permissions

# Security: Enhanced logging function with proper file permissions
log_suggestion() {
    local message="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local logfile="${HOME}/.claude/agent-suggestions.log"
    
    # Ensure log directory exists with secure permissions
    local log_dir
    log_dir="$(dirname "$logfile")"
    if [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir"
        chmod 700 "$log_dir"  # Secure directory permissions
    fi
    
    # Sanitize message to prevent log injection
    local sanitized_message
    sanitized_message=$(printf '%s' "$message" | tr -cd '[:print:][:space:]' | head -c 500)
    
    echo "[$timestamp] $sanitized_message" >> "$logfile"
    
    # Set secure permissions on log file
    chmod "$LOG_PERMISSIONS" "$logfile" 2>/dev/null || true
}

# Security: Safe file path validation
validate_file_path() {
    local filepath="$1"
    
    # Check for null or empty path
    if [[ -z "$filepath" || "$filepath" == "null" ]]; then
        return 1
    fi
    
    # Check for path traversal attempts
    if [[ "$filepath" == *".."* ]] || [[ "$filepath" == *"//"* ]]; then
        log_suggestion "SECURITY: Rejected potentially dangerous file path: $filepath"
        return 1
    fi
    
    # Check path length to prevent buffer overflow attacks
    if [[ ${#filepath} -gt 1000 ]]; then
        log_suggestion "SECURITY: Rejected excessively long file path"
        return 1
    fi
    
    return 0
}

# Function to analyze file patterns and suggest agents
suggest_agent() {
    local filepath="$1"
    
    # Security: Validate file path first
    if ! validate_file_path "$filepath"; then
        return 1
    fi
    
    local filename
    filename=$(basename "$filepath")
    local dirname
    dirname=$(dirname "$filepath")
    
    # Convert to lowercase for pattern matching (secure)
    local lower_path
    lower_path=$(printf '%s' "$filepath" | tr '[:upper:]' '[:lower:]')
    local lower_file
    lower_file=$(printf '%s' "$filename" | tr '[:upper:]' '[:lower:]')
    
    # Security: Use safe regex patterns to avoid ReDoS attacks
    # Testing patterns (check first to avoid conflicts with file extensions)
    if [[ "$lower_path" =~ /test/ ]] || \
       [[ "$lower_path" =~ /spec/ ]] || \
       [[ "$lower_file" =~ \.test\. ]] || \
       [[ "$lower_file" =~ \.spec\. ]] || \
       [[ "$lower_path" =~ /e2e/ ]] || \
       [[ "$lower_path" =~ /cypress/ ]] || \
       [[ "$lower_path" =~ /__tests__/ ]] || \
       [[ "$lower_file" =~ ^test.*\.(js|ts|py|go|java)$ ]]; then
        local suggestion="SUGGEST: Use qa-testing-specialist agent for testing implementation in $filename"
        echo "$suggestion"
        log_suggestion "$suggestion - Path: $filepath"
        return 0
    fi
    
    # Frontend patterns
    if [[ "$lower_file" =~ \.(tsx|jsx|ts|js)$ ]] || \
       [[ "$lower_path" =~ /components/ ]] || \
       [[ "$lower_path" =~ /pages/ ]] || \
       [[ "$lower_path" =~ /styles/ ]] || \
       [[ "$lower_path" =~ /src/.*\.(css|scss|sass|less)$ ]]; then
        local suggestion="SUGGEST: Use frontend-developer agent for frontend development in $filename"
        echo "$suggestion"
        log_suggestion "$suggestion - Path: $filepath"
        return 0
    fi
    
    # Backend patterns
    if [[ "$lower_path" =~ /api/ ]] || \
       [[ "$lower_path" =~ /server/ ]] || \
       [[ "$lower_path" =~ /database/ ]] || \
       [[ "$lower_file" =~ \.(py|go|java|rs|php|rb)$ ]] || \
       [[ "$lower_path" =~ /backend/ ]] || \
       [[ "$lower_path" =~ /models/ ]]; then
        local suggestion="SUGGEST: Use backend-developer agent for backend development in $filename"
        echo "$suggestion"
        log_suggestion "$suggestion - Path: $filepath"
        return 0
    fi
    
    # Infrastructure/DevOps patterns
    if [[ "$lower_file" =~ ^dockerfile ]] || \
       [[ "$lower_file" =~ ^docker-compose ]] || \
       [[ "$lower_path" =~ /k8s/ ]] || \
       [[ "$lower_path" =~ /kubernetes/ ]] || \
       [[ "$lower_path" =~ /\.github/workflows/ ]] || \
       [[ "$lower_path" =~ /terraform/ ]] || \
       [[ "$lower_path" =~ /ansible/ ]] || \
       [[ "$lower_file" =~ \.(yml|yaml)$ ]] || \
       [[ "$lower_path" =~ /infrastructure/ ]] || \
       [[ "$lower_path" =~ /deployment/ ]]; then
        local suggestion="SUGGEST: Use sre-devops-specialist agent for infrastructure/deployment in $filename"
        echo "$suggestion"
        log_suggestion "$suggestion - Path: $filepath"
        return 0
    fi
    
    # Security patterns
    if [[ "$lower_file" =~ \.env ]] || \
       [[ "$lower_path" =~ /security/ ]] || \
       [[ "$lower_path" =~ /auth/ ]] || \
       [[ "$lower_path" =~ /secrets/ ]] || \
       [[ "$lower_path" =~ /certs/ ]] || \
       [[ "$lower_file" =~ (ssl|tls|cert|key)$ ]] || \
       [[ "$lower_path" =~ /config/.*security ]] || \
       [[ "$lower_file" =~ ^security.*\.(json|yml|yaml)$ ]]; then
        local suggestion="SUGGEST: Use security-compliance-auditor agent for security configuration in $filename"
        echo "$suggestion"
        log_suggestion "$suggestion - Path: $filepath"
        return 0
    fi
    
    # Documentation/Product patterns
    if [[ "$lower_file" =~ ^readme ]] || \
       [[ "$lower_file" =~ ^requirements ]] || \
       [[ "$lower_path" =~ /docs/ ]] || \
       [[ "$lower_path" =~ /documentation/ ]] || \
       [[ "$lower_path" =~ /specs/ ]] || \
       [[ "$lower_file" =~ \.(md|txt|rst)$ ]] || \
       [[ "$lower_file" =~ ^changelog ]] || \
       [[ "$lower_file" =~ ^license ]]; then
        local suggestion="SUGGEST: Use product-requirements-analyst agent for documentation/specifications in $filename"
        echo "$suggestion"
        log_suggestion "$suggestion - Path: $filepath"
        return 0
    fi
    
    return 0
}

# Security: Enhanced JSON path extraction with comprehensive validation
extract_file_path() {
    local json_context="$1"
    
    # Security: Validate JSON input first
    if [[ -z "$json_context" ]] || ! echo "$json_context" | jq empty 2>/dev/null; then
        log_suggestion "SECURITY: Invalid JSON context provided"
        return 1
    fi
    
    # Check JSON size to prevent resource exhaustion
    if [[ ${#json_context} -gt 100000 ]]; then  # 100KB limit
        log_suggestion "SECURITY: JSON context too large, truncating"
        json_context=$(echo "$json_context" | head -c 100000)
    fi
    
    local file_path=""
    
    # Security: Use safe jq operations with error handling
    # Try direct file_path parameter
    if file_path=$(echo "$json_context" | jq -r '.parameters.file_path // empty' 2>/dev/null) && [[ -n "$file_path" && "$file_path" != "null" ]]; then
        if validate_file_path "$file_path"; then
            echo "$file_path"
            return 0
        fi
    fi
    
    # Try edits array (MultiEdit tool)
    if file_path=$(echo "$json_context" | jq -r '.parameters.edits[0].file_path // empty' 2>/dev/null) && [[ -n "$file_path" && "$file_path" != "null" ]]; then
        if validate_file_path "$file_path"; then
            echo "$file_path"
            return 0
        fi
    fi
    
    # Try notebook_path (NotebookRead/NotebookEdit)
    if file_path=$(echo "$json_context" | jq -r '.parameters.notebook_path // empty' 2>/dev/null) && [[ -n "$file_path" && "$file_path" != "null" ]]; then
        if validate_file_path "$file_path"; then
            echo "$file_path"
            return 0
        fi
    fi
    
    # Try glob pattern (Glob tool) - extract from pattern if it's a specific file
    local pattern
    if pattern=$(echo "$json_context" | jq -r '.parameters.pattern // empty' 2>/dev/null) && [[ -n "$pattern" && "$pattern" != "null" && "$pattern" != *"*"* ]]; then
        if validate_file_path "$pattern"; then
            echo "$pattern"
            return 0
        fi
    fi
    
    return 1
}

# Security: Enhanced JSON context processing with timeout and validation
process_json_context() {
    local json_context=""
    
    # Read JSON context from stdin with timeout and size limit
    if json_context=$(timeout 10s head -c 100000 2>/dev/null); then
        if [[ -z "$json_context" ]]; then
            log_suggestion "WARN: Empty JSON context provided via stdin"
            return 1
        fi
        
        # Security: Validate JSON structure
        if ! echo "$json_context" | jq empty 2>/dev/null; then
            log_suggestion "WARN: Invalid JSON context received via stdin"
            return 1
        fi
        
        # Log the context for debugging (safely truncated)
        local context_preview
        context_preview=$(echo "$json_context" | head -c 200 | tr -cd '[:print:][:space:]')
        log_suggestion "INFO: Processing JSON context: ${context_preview}..."
        
        # Extract file path from JSON
        local file_path
        if file_path=$(extract_file_path "$json_context"); then
            log_suggestion "INFO: Extracted file path: $file_path"
            suggest_agent "$file_path"
            return 0
        else
            log_suggestion "WARN: Could not extract valid file path from JSON context"
            return 1
        fi
    else
        log_suggestion "WARN: Failed to read JSON context from stdin within timeout"
        return 1
    fi
}

# Function to process files from git status
process_git_files() {
    local changed_files staged_files all_files
    
    # Security: Use safe git operations with timeout
    if ! changed_files=$(timeout 30s git diff --name-only HEAD 2>/dev/null); then
        log_suggestion "WARN: Failed to get git diff within timeout"
        changed_files=""
    fi
    
    if ! staged_files=$(timeout 30s git diff --cached --name-only 2>/dev/null); then
        log_suggestion "WARN: Failed to get git staged files within timeout"
        staged_files=""
    fi
    
    all_files="$changed_files $staged_files"
    
    if [[ -n "$all_files" ]]; then
        # Security: Process files safely with validation
        for file in $all_files; do
            if [[ -n "$file" ]] && validate_file_path "$file"; then
                suggest_agent "$file"
            fi
        done
    else
        log_suggestion "INFO: No modified files found via git status"
    fi
}

# Security: Enhanced argument processing with validation
process_file_arguments() {
    local file_count=0
    
    log_suggestion "INFO: Processing $# file arguments"
    
    for file in "$@"; do
        if validate_file_path "$file"; then
            suggest_agent "$file"
            ((file_count++))
        else
            log_suggestion "WARN: Skipped invalid file path: $file"
        fi
        
        # Security: Limit number of files processed to prevent resource exhaustion
        if [[ $file_count -gt 100 ]]; then
            log_suggestion "WARN: File limit reached, stopping processing"
            break
        fi
    done
}

# Main execution logic with enhanced security
main() {
    # Set up async execution marker
    log_suggestion "INFO: Auto-delegate hook started (async mode, PID: $$)"
    
    # Security: Validate environment
    if [[ -z "${HOME:-}" ]]; then
        echo "ERROR: HOME environment variable not set" >&2
        exit 1
    fi
    
    if [[ $# -eq 0 ]]; then
        # No arguments - check if we have stdin (JSON context from hook system)
        if [[ -t 0 ]]; then
            # No stdin - fallback to git status
            log_suggestion "INFO: No stdin detected, falling back to git status"
            process_git_files
        else
            # We have stdin - process JSON context
            if ! process_json_context; then
                log_suggestion "INFO: JSON processing failed, falling back to git status"
                process_git_files
            fi
        fi
    else
        # Process provided file arguments
        process_file_arguments "$@"
    fi
    
    log_suggestion "INFO: Auto-delegate hook completed successfully"
}

# Security: Enhanced error handling and cleanup
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_suggestion "ERROR: Auto-delegate hook failed with exit code $exit_code"
    fi
    exit $exit_code
}

# Set up secure error handling
trap cleanup EXIT ERR

# Execute main function
main "$@"
