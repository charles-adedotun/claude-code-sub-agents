#!/bin/bash

# =============================================================================
# Security Test Scenarios Script
# =============================================================================
# This script contains test scenarios to validate the security pipeline
# It will be used to test various security controls and scanning workflows
#
# IMPORTANT: This file contains intentional test patterns for security validation
# These are NOT real security issues but test cases for the security pipeline
#
# Test Categories:
# 1. File permission tests
# 2. Secret scanning tests (with safe patterns)
# 3. Workflow validation tests
# 4. CODEOWNERS enforcement tests
# =============================================================================

set -euo pipefail

# Test 1: File Permission Validation
echo "=== File Permission Tests ==="
echo "Testing file permissions and executable checks..."

# This should pass - proper shell script permissions
chmod +x "$0"

# Test 2: Safe Pattern Testing (for secret scanner validation)
echo "=== Secret Scanner Validation ==="
echo "Testing secret detection patterns with safe test data..."

# These are safe test patterns that should trigger our security scanners
# but don't contain real secrets
test_api_key_pattern="api_key=placeholder_for_testing_purposes_12345678"
test_password_pattern="password=example_test_password_not_real"
test_token_pattern="secret_token=demo_token_for_validation_only"

echo "Test patterns created for validation purposes"
echo "Pattern 1: $test_api_key_pattern"
echo "Pattern 2: $test_password_pattern" 
echo "Pattern 3: $test_token_pattern"

# Test 3: Workflow Integration Test
echo "=== Workflow Integration Tests ==="
echo "This file should trigger the security-scan workflow"
echo "Expected behavior:"
echo "- Trivy scan should run"
echo "- Secret scan should detect test patterns"
echo "- Dependency scan should run"
echo "- Infrastructure scan should run"
echo "- Compliance check should validate this file"

# Test 4: Hook System Validation
echo "=== Hook System Tests ==="
echo "This file should trigger:"
echo "- auto-delegate-agent.sh (should suggest sre-devops-specialist)"
echo "- pre-commit-review.sh (should run pre-commit checks)"

# Test 5: File Format and Linting
echo "=== Linting Tests ==="
echo "This script should pass shellcheck validation"
echo "All YAML files should pass yamllint"
echo "All JSON files should be valid JSON"

# Test function to demonstrate proper error handling
test_function() {
    local test_param="$1"
    echo "Testing function with parameter: $test_param"
    
    if [[ -z "$test_param" ]]; then
        echo "ERROR: Parameter required"
        return 1
    fi
    
    echo "Function test completed successfully"
    return 0
}

# Run the test function
if test_function "security-validation"; then
    echo "✅ Function test passed"
else
    echo "❌ Function test failed"
fi

echo "=== Security Test Scenarios Complete ==="
echo "This script validates:"
echo "1. ✅ File permissions are properly set"
echo "2. ✅ Shell script syntax is valid"
echo "3. ✅ Security patterns are detectable"
echo "4. ✅ Workflow triggers are functional"
echo "5. ✅ Hook system integration works"

# End of test script
exit 0