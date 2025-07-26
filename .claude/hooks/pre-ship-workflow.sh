#!/bin/bash

# Pre-ship workflow hook for GitPlus integration
# Comprehensive pre-commit validation before GitPlus ship operations
# This hook runs BEFORE the GitPlus ship command is executed

# Exit codes
SUCCESS=0
VALIDATION_FAILED=1
SYNTAX_ERROR=2

# Security: Dynamic path resolution
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CLAUDE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
LOG_FILE="${HOME}/.claude/pre-ship-validation.log"
MAX_LOG_SIZE=1048576  # 1MB
readonly LOG_PERMISSIONS=600   # Secure log file permissions

# Logging function
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Ensure log directory exists with secure permissions
    local log_dir
    log_dir="$(dirname "$LOG_FILE")"
    if [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir"
        chmod 700 "$log_dir"  # Secure directory permissions
    fi
    
    # Rotate log if it gets too large
    if [[ -f "$LOG_FILE" ]] && [[ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo 0) -gt $MAX_LOG_SIZE ]]; then
        mv "$LOG_FILE" "${LOG_FILE}.old"
    fi
    
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Set secure permissions on log file
    chmod "$LOG_PERMISSIONS" "$LOG_FILE" 2>/dev/null || true
    
    # Also output to stderr for immediate feedback
    echo "[$level] $message" >&2
}

# Security: Enhanced JSON validation with comprehensive checks
validate_json() {
    local file="$1"
    
    # Basic existence and readability check
    if [[ ! -f "$file" ]] || [[ ! -r "$file" ]]; then
        log_message "ERROR" "JSON file is not readable: $file"
        return $SYNTAX_ERROR
    fi
    
    # Check file size to prevent resource exhaustion
    local file_size
    file_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
    if [[ $file_size -gt 10485760 ]]; then  # 10MB limit
        log_message "ERROR" "JSON file too large for validation: $file"
        return $SYNTAX_ERROR
    fi
    
    # Syntax validation
    if ! jq empty "$file" 2>/dev/null; then
        log_message "ERROR" "Invalid JSON syntax in $file"
        return $SYNTAX_ERROR
    fi
    
    # Security: Check for potentially dangerous JSON structures
    local json_content
    if json_content=$(jq -c . "$file" 2>/dev/null); then
        # Check for excessively nested structures (potential DoS)
        local nesting_level
        nesting_level=$(echo "$json_content" | jq '[paths | length] | max // 0' 2>/dev/null || echo 0)
        if [[ $nesting_level -gt 100 ]]; then
            log_message "WARN" "JSON file has excessive nesting depth in $file"
        fi
        
        # Check for extremely large arrays/objects
        local max_array_size
        max_array_size=$(echo "$json_content" | jq '[.. | arrays | length] | max // 0' 2>/dev/null || echo 0)
        if [[ $max_array_size -gt 10000 ]]; then
            log_message "WARN" "JSON file contains very large arrays in $file"
        fi
    fi
    
    log_message "INFO" "JSON validation passed for $file"
    return $SUCCESS
}
# Function to validate YAML files
validate_yaml() {
    local file="$1"
    
    # Check if yq is available for YAML validation
    if command -v yq >/dev/null 2>&1; then
        if ! yq eval '.' "$file" >/dev/null 2>&1; then
            log_message "ERROR" "Invalid YAML syntax in $file"
            return $SYNTAX_ERROR
        fi
    elif command -v python3 >/dev/null 2>&1; then
        # Fallback to Python YAML validation
        if ! python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
            log_message "ERROR" "Invalid YAML syntax in $file"
            return $SYNTAX_ERROR
        fi
    else
        log_message "WARN" "No YAML validator available, skipping validation for $file"
        return $SUCCESS
    fi
    
    log_message "INFO" "YAML validation passed for $file"
    return $SUCCESS
}

# Function to validate shell scripts
validate_shell() {
    local file="$1"
    
    # Check for bash syntax errors
    if ! bash -n "$file" 2>/dev/null; then
        log_message "ERROR" "Shell script syntax error in $file"
        return $SYNTAX_ERROR
    fi
    
    # Security: Enhanced security checks using shellcheck if available
    if command -v shellcheck >/dev/null 2>&1; then
        local shellcheck_output
        if shellcheck_output=$(shellcheck -f json "$file" 2>/dev/null); then
            # Parse shellcheck results for security issues
            local security_issues
            security_issues=$(echo "$shellcheck_output" | jq -r '.[] | select(.level == "error" or .level == "warning") | select(.code | tostring | test("SC2086|SC2046|SC2034|SC2155|SC2068|SC2206")) | .message' 2>/dev/null || true)
            
            if [[ -n "$security_issues" ]]; then
                while IFS= read -r issue; do
                    log_message "WARN" "Shellcheck security issue in $file: $issue"
                done <<< "$security_issues"
            fi
        else
            log_message "INFO" "Shellcheck analysis completed for $file"
        fi
    fi

    # Check for common security issues
    if grep -q "eval.*\$" "$file"; then
        log_message "WARN" "Potential security risk: eval with variable in $file"
    fi
    
    if grep -q "rm -rf.*\$" "$file"; then
        log_message "WARN" "Potential security risk: rm -rf with variable in $file"
    fi
    
    log_message "INFO" "Shell script validation passed for $file"
    return $SUCCESS
}

# Function to validate Python files
validate_python() {
    local file="$1"
    
    # Check Python syntax
    if ! python3 -m py_compile "$file" 2>/dev/null; then
        log_message "ERROR" "Python syntax error in $file"
        return $SYNTAX_ERROR
    fi
    
    log_message "INFO" "Python validation passed for $file"
    return $SUCCESS
}

# Function to validate JavaScript/TypeScript files
validate_js_ts() {
    local file="$1"
    
    # Check if we have node available
    if command -v node >/dev/null 2>&1; then
        # Try to parse the file as JavaScript
        if ! node -c "$file" 2>/dev/null; then
            log_message "ERROR" "JavaScript/TypeScript syntax error in $file"
            return $SYNTAX_ERROR
        fi
    else
        log_message "WARN" "Node.js not available, skipping JS/TS validation for $file"
        return $SUCCESS
    fi
    
    log_message "INFO" "JavaScript/TypeScript validation passed for $file"
    return $SUCCESS
}

# Function to validate file syntax based on extension
validate_file_syntax() {
    local file="$1"
    local extension="${file##*.}"
    local basename=$(basename "$file")
    
    case "$extension" in
        json)
            validate_json "$file"
            ;;
        yml|yaml)
            validate_yaml "$file"
            ;;
        sh|bash)
            validate_shell "$file"
            ;;
        py)
            validate_python "$file"
            ;;
        js|ts|jsx|tsx)
            validate_js_ts "$file"
            ;;
        *)
            # Check for shell scripts without extension
            if [[ -x "$file" ]] && head -n1 "$file" | grep -q "^#!.*sh"; then
                validate_shell "$file"
            else
                log_message "INFO" "No specific validation for $file (extension: $extension)"
                return $SUCCESS
            fi
            ;;
    esac
}

# Function to check for sensitive information with safe patterns
check_sensitive_info() {
    local file="$1"
    
    # Skip binary files and large files
    if ! file "$file" 2>/dev/null | grep -q "text"; then
        return $SUCCESS
    fi
    
    local file_size
    file_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
    if [[ $file_size -gt 1048576 ]]; then  # 1MB limit for sensitive data scanning
        log_message "INFO" "Skipping sensitive data scan for large file: $file"
        return $SUCCESS
    fi
    
    # Security: Use safe, non-ReDoS patterns for sensitive data detection
    local safe_patterns=(
        "password[[:space:]]*=[[:space:]]*['\"][^'\"]{8,}['\"]"
        "api[_-]?key[[:space:]]*=[[:space:]]*['\"][^'\"]{16,}['\"]"
        "secret[[:space:]]*=[[:space:]]*['\"][^'\"]{16,}['\"]"
        "private[_-]?key"
        "BEGIN[[:space:]]+.*PRIVATE.*KEY"
        "aws[_-]?access[_-]?key[_-]?id"
        "aws[_-]?secret[_-]?access[_-]?key"
        "bearer[[:space:]]+[a-zA-Z0-9._-]{20,}"
        "token[[:space:]]*=[[:space:]]*['\"][a-zA-Z0-9._-]{20,}['\"]"
    )
    
    for pattern in "${safe_patterns[@]}"; do
        if grep -iE "$pattern" "$file" >/dev/null 2>&1; then
            log_message "WARN" "Potential sensitive information detected in $file"
            break  # Only report once per file to avoid spam
        fi
    done
    
    return $SUCCESS
}
# Function to run existing pre-commit-review if available
run_existing_precommit() {
    local precommit_script="$CLAUDE_DIR/hooks/pre-commit-review.sh"
    
    if [[ -f "$precommit_script" && -x "$precommit_script" ]]; then
        log_message "INFO" "Running existing pre-commit review script"
        
        # Create a minimal JSON context for the script
        local json_context='{"tool_name": "GitPlus", "parameters": {"action": "pre-ship-validation"}}'
        
        if echo "$json_context" | "$precommit_script"; then
            log_message "INFO" "Pre-commit review completed successfully"
            return $SUCCESS
        else
            log_message "WARN" "Pre-commit review script returned non-zero exit code"
            # Don't fail the entire validation for this
            return $SUCCESS
        fi
    else
        log_message "INFO" "No executable pre-commit review script found"
        return $SUCCESS
    fi
}

# Function to get changed files for validation
get_changed_files() {
    local files=()
    
    # Get staged files
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            files+=("$file")
        fi
    done < <(git diff --cached --name-only -z 2>/dev/null)
    
    # Get unstaged changes
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            files+=("$file")
        fi
    done < <(git diff --name-only -z 2>/dev/null)
    
    # Remove duplicates and output
    printf '%s\n' "${files[@]}" | sort -u
}

# Main validation function
main() {
    local exit_code=$SUCCESS
    local file_count=0
    local error_count=0
    
    log_message "INFO" "Starting pre-ship workflow validation"
    
    # Read JSON context from stdin if available
    local json_context=""
    if [[ ! -t 0 ]]; then
        json_context=$(cat)
        log_message "INFO" "Received JSON context: $(echo "$json_context" | head -c 100)..."
    fi
    
    # Get list of files to validate
    local files
    mapfile -t files < <(get_changed_files)
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_message "INFO" "No files to validate"
        return $SUCCESS
    fi
    
    log_message "INFO" "Validating ${#files[@]} files"
    
    # Validate each file
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            ((file_count++))
            log_message "INFO" "Validating file: $file"
            
            # Run syntax validation
            if ! validate_file_syntax "$file"; then
                ((error_count++))
                exit_code=$SYNTAX_ERROR
            fi
            
            # Check for sensitive information
            check_sensitive_info "$file"
        fi
    done
    
    # Run existing pre-commit review integration
    if ! run_existing_precommit; then
        log_message "WARN" "Pre-commit review integration had issues"
    fi
    
    # Final summary
    if [[ $error_count -eq 0 ]]; then
        log_message "INFO" "Pre-ship validation completed successfully. Validated $file_count files."
    else
        log_message "ERROR" "Pre-ship validation failed. $error_count errors found in $file_count files."
        exit_code=$VALIDATION_FAILED
    fi
    
    return $exit_code
}

# Trap errors and log them
trap 'log_message "ERROR" "Pre-ship workflow hook failed with exit code $?"' ERR

# Execute main function
main "$@"
exit_code=$?

# Log final result
if [[ $exit_code -eq $SUCCESS ]]; then
    log_message "INFO" "Pre-ship workflow hook completed successfully"
else
    log_message "ERROR" "Pre-ship workflow hook failed with exit code $exit_code"
fi

exit $exit_code