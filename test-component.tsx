// Test React Component for Security Pipeline Validation
// This file tests frontend pattern detection and workflow triggers

import React, { useState, useEffect } from 'react';

interface SecurityTestProps {
  testMode: boolean;
  onValidationResult: (result: boolean) => void;
}

// Test component with security validation scenarios
export const SecurityTestComponent: React.FC<SecurityTestProps> = ({
  testMode,
  onValidationResult
}) => {
  const [isSecure, setIsSecure] = useState<boolean>(false);
  
  // Test pattern for security scanning
  const testApiConfig = {
    // These are safe test patterns for validation
    endpoint: 'https://api.example.com/test',
    apiKey: 'test_key_placeholder_validation_only',
    timeout: 5000
  };
  
  useEffect(() => {
    // Simulate security validation
    const validateSecurity = () => {
      // This should trigger the frontend-developer agent suggestion
      console.log('Running security validation in test mode');
      
      if (testMode) {
        // Test various security patterns
        const patterns = [
          'password=test_example_not_real',
          'secret=demo_validation_only',
          'token=placeholder_for_testing'
        ];
        
        console.log('Test patterns:', patterns);
        setIsSecure(true);
        onValidationResult(true);
      }
    };
    
    validateSecurity();
  }, [testMode, onValidationResult]);
  
  const handleSecurityTest = () => {
    // Test function that should be picked up by quality checks
    if (!testMode) {
      console.warn('Security test can only run in test mode');
      return;
    }
    
    // Simulate API call with test credentials
    fetch(testApiConfig.endpoint, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${testApiConfig.apiKey}`,
        'Content-Type': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      console.log('Test API response:', data);
    })
    .catch(error => {
      console.error('Test API error:', error);
    });
  };
  
  return (
    <div className="security-test-component">
      <h2>Security Pipeline Test Component</h2>
      
      {testMode && (
        <div className="test-controls">
          <p>Security Status: {isSecure ? '✅ Validated' : '⏳ Validating...'}</p>
          
          <button 
            onClick={handleSecurityTest}
            className="test-button"
            disabled={!isSecure}
          >
            Run Security Test
          </button>
          
          <div className="test-info">
            <p>This component tests:</p>
            <ul>
              <li>Frontend pattern detection</li>
              <li>Secret scanning with safe patterns</li>
              <li>Code quality validation</li>
              <li>Agent delegation to frontend-developer</li>
            </ul>
          </div>
        </div>
      )}
      
      <div className="validation-results">
        <p>Expected workflow triggers:</p>
        <ul>
          <li>✅ CI/CD pipeline validation</li>
          <li>✅ Security scanning (Trivy, TruffleHog)</li>
          <li>✅ Quality checks (linting, formatting)</li>
          <li>✅ CODEOWNERS review requirement</li>
        </ul>
      </div>
    </div>
  );
};

export default SecurityTestComponent;