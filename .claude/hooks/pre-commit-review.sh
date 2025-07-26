#!/bin/bash

# Pre-commit reviewer hook for Claude Code
# This script automatically triggers the pre-commit-reviewer agent after file operations

# Read the tool context from stdin
TOOL_CONTEXT=$(cat)

# Extract tool name and file path from the context
TOOL_NAME=$(echo "$TOOL_CONTEXT" | jq -r '.tool_name // "unknown"')
FILE_PATH=$(echo "$TOOL_CONTEXT" | jq -r '.parameters.file_path // .parameters[0].file_path // "unknown"')

# Only trigger for file modification tools
case "$TOOL_NAME" in
    "Write"|"Edit"|"MultiEdit"|"Update")
        echo "🔍 Running pre-commit review for $FILE_PATH"
        
        # Use Claude's Task tool to launch the pre-commit-reviewer agent
        # This will be executed in the context where Claude is running
        echo "Triggering pre-commit-reviewer agent for file: $FILE_PATH"
        
        # The actual invocation will be handled by Claude's hook system
        # This script serves as a trigger point
        ;;
    *)
        # Skip for other tools
        exit 0
        ;;
esac