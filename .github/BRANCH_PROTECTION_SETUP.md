# Branch Protection Configuration

This document provides step-by-step instructions for configuring branch protection rules for the claude-code-sub-agents repository.

## 🔒 Required Branch Protection Rules

### Main Branch Protection

Navigate to your repository settings and configure the following branch protection rules for the `main` branch:

#### Basic Protection
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: **1**
  - ✅ Dismiss stale PR approvals when new commits are pushed
  - ✅ Require review from code owners
  - ✅ Restrict pushes that create files larger than 100MB

#### Status Checks
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  
  **Required Status Checks:**
  - `validate-changes` (CI workflow)
  - `security-analysis` (CI workflow)  
  - `quality-checks` (CI workflow)
  - `documentation-check` (CI workflow)
  - `trivy-scan` (Security workflow)
  - `secret-scan` (Security workflow)

#### Additional Restrictions
- ✅ **Restrict pushes to matching branches**
  - Add administrators and repository owners
  - Only allow specified users/teams to push to main
- ✅ **Allow force pushes**: ❌ (Disabled)
- ✅ **Allow deletions**: ❌ (Disabled)

## 🛠️ Step-by-Step Configuration

### 1. Access Repository Settings
1. Go to your repository on GitHub
2. Click **Settings** tab
3. Select **Branches** from the left sidebar

### 2. Add Branch Protection Rule
1. Click **Add rule**
2. Enter branch name pattern: `main`
3. Configure the following settings:

### 3. Pull Request Requirements
```
✅ Require a pull request before merging
  ├── ✅ Require approvals (1)
  ├── ✅ Dismiss stale PR approvals when new commits are pushed
  ├── ✅ Require review from code owners
  └── ✅ Restrict pushes that create files larger than 100MB
```

### 4. Status Check Requirements
```
✅ Require status checks to pass before merging
  ├── ✅ Require branches to be up to date before merging
  └── Required status checks:
      ├── validate-changes
      ├── security-analysis
      ├── quality-checks
      ├── documentation-check
      ├── trivy-scan
      └── secret-scan
```

### 5. Additional Restrictions
```
✅ Restrict pushes to matching branches
  ├── Include administrators: ✅
  └── Allowed users/teams: [Repository admins only]

❌ Allow force pushes: Disabled
❌ Allow deletions: Disabled
```

## 🔐 CODEOWNERS Configuration

Create a `.github/CODEOWNERS` file to define code review requirements:

```bash
# Global owners
* @charles-adedotun

# Agent configurations require specialized review
/.claude/agents/ @charles-adedotun
/.claude/hooks/ @charles-adedotun

# CI/CD changes require infrastructure review
/.github/workflows/ @charles-adedotun

# Security-sensitive files require security review
/.github/workflows/security-scan.yml @charles-adedotun
/validate-setup.sh @charles-adedotun

# Documentation changes
/*.md @charles-adedotun
/.claude/commands/ @charles-adedotun
```

## 🚨 Emergency Access Procedures

### Break Glass Procedures
1. **Critical Security Issue**: Administrators can temporarily disable branch protection
2. **Production Incident**: Emergency hotfix process bypasses some checks
3. **CI/CD Failure**: Temporary status check bypass for infrastructure issues

### Emergency Access Steps
1. Document the emergency in an issue
2. Temporarily adjust branch protection settings
3. Implement fix with expedited review
4. Restore full branch protection
5. Conduct post-incident review

## 📋 Verification Checklist

After configuration, verify the following:

### Protection Rules Active
- [ ] Pull requests required for main branch
- [ ] At least 1 approval required
- [ ] All status checks must pass
- [ ] Branch must be up to date
- [ ] Direct pushes to main blocked

### Status Checks Working
- [ ] CI workflows trigger on PR creation
- [ ] Security scans complete successfully
- [ ] Quality checks validate configurations
- [ ] Documentation checks pass

### Emergency Procedures
- [ ] CODEOWNERS file properly configured
- [ ] Emergency access procedures documented
- [ ] Administrator privileges properly set

## 🔄 Workflow Integration

### PR Creation Workflow
```
1. Developer creates feature branch
2. Developer opens pull request
3. Automated CI checks run:
   ├── Configuration validation
   ├── Security scanning
   ├── Quality checks
   └── Documentation validation
4. Required approvals obtained
5. Status checks pass
6. PR merged to main
7. Release pipeline triggers
```

### Status Check Details

#### CI Workflow Checks
- **validate-changes**: Agent configs, hook scripts, settings validation
- **security-analysis**: Trivy scan, secret detection, permissions check
- **quality-checks**: ShellCheck, YAML lint, markdown links, agent consistency
- **documentation-check**: Required docs present, quality validation

#### Security Workflow Checks
- **trivy-scan**: Vulnerability scanning
- **secret-scan**: Hardcoded secret detection
- **dependency-scan**: Package vulnerability checks (if applicable)
- **compliance-check**: Repository compliance and file permissions

## 🎯 Quality Gates

### Blocking Conditions
The following conditions will block PR merging:

#### Security Issues
- High/Critical vulnerabilities detected
- Hardcoded secrets found
- Insecure file permissions
- Security policy violations

#### Quality Issues
- Agent configuration validation failures
- Hook script syntax errors
- Missing required documentation
- Broken internal links

#### CI/CD Issues
- Workflow syntax errors
- Failed status checks
- Missing required approvals
- Outdated branch

## 📊 Monitoring and Metrics

### Key Metrics to Track
- PR merge success rate
- Time from PR creation to merge
- Security scan failure rate
- Quality check failure rate
- Emergency procedure usage

### Reporting
- Weekly branch protection effectiveness report
- Monthly security scanning summary
- Quarterly quality metrics review
- Annual emergency access audit

## 🔧 Troubleshooting

### Common Issues

#### Status Checks Not Running
1. Verify workflow files are present
2. Check branch name patterns in workflows
3. Ensure proper permissions in workflow files
4. Validate YAML syntax

#### Required Checks Failing
1. Review CI workflow logs
2. Check agent configuration validity
3. Verify security scan results
4. Validate documentation completeness

#### Emergency Access Needed
1. Create emergency issue
2. Contact repository administrators
3. Follow documented procedures
4. Restore protections after resolution

### Support Contacts
- **Repository Issues**: Create GitHub issue
- **Security Concerns**: Contact security team
- **CI/CD Problems**: Infrastructure team
- **Emergency Access**: Repository administrators

---

**Note**: These branch protection rules ensure the integrity and security of the claude-code-sub-agents ecosystem while maintaining development velocity through automated quality gates.