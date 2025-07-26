# Branch Protection Setup Guide

> **CRITICAL**: These branch protection rules must be configured manually in the GitHub UI to ensure proper CI/CD automation.

## Overview

This repository uses automated releases based on conventional commits. Branch protection rules ensure that:
- All code goes through CI validation before merging
- Releases are triggered automatically only after successful validation
- Manual releases are prevented (all releases must be automated)

## Required Branch Protection Rules

### Main Branch Protection

Navigate to: `Settings > Branches > Add rule` in your GitHub repository

#### Rule Configuration

**Branch name pattern**: `main`

#### Protection Settings

✅ **Require a pull request before merging**
- Required approving reviews: `1`
- Dismiss stale PR approvals when new commits are pushed: `enabled`
- Require review from code owners: `enabled`
- Restrict pushes that create files larger than 100MB: `enabled`

✅ **Require status checks to pass before merging**
- Require branches to be up to date before merging: `enabled`
- Required status checks:
  - `validate` (Pre-Release Validation)
  - `security-scan` (Security Scanning)
  - `ci` (from ci.yml workflow)
  - `security-audit` (from security-scan.yml workflow)

✅ **Require conversation resolution before merging**
- All PR conversations must be resolved: `enabled`

✅ **Require signed commits**
- All commits must be signed: `enabled`

✅ **Require linear history**
- Prevent merge commits: `enabled`
- Force push protection: `enabled`

✅ **Do not allow bypassing the above settings**
- Include administrators: `enabled`
- Restrict pushes that create new files: `enabled`

#### Advanced Settings

✅ **Lock branch**
- Allow specified actors to push to this branch: `disabled`

✅ **Allow force pushes**
- Nobody: `selected`

✅ **Allow deletions**
- Nobody: `selected`

## Validation Commands

After setting up branch protection, validate the configuration:

```bash
# Check branch protection status
gh api repos/:owner/:repo/branches/main/protection

# Test that direct pushes are blocked
git push origin main  # Should fail

# Test that unprotected branches can be pushed
git checkout -b test-branch
git push origin test-branch  # Should succeed
```

## Automated Release Workflow

With branch protection enabled, the proper workflow becomes:

### 1. Development Flow
```bash
# Create feature branch
git checkout -b feat/new-feature

# Make changes with conventional commits
git commit -m "feat: add new agent delegation system"
git commit -m "docs: update setup instructions"
git commit -m "fix: resolve memory leak in hook processing"

# Push and create PR
git push origin feat/new-feature
gh pr create --title "feat: add new agent delegation system"
```

### 2. Review & Merge Flow
```bash
# Reviewer approves PR
# All status checks pass automatically
# Merge via GitHub UI (squash and merge recommended)
```

### 3. Automated Release Flow
```bash
# After merge to main:
# 1. release.yml workflow triggers automatically
# 2. Validates all systems
# 3. Runs security scans  
# 4. Analyzes commits using conventional commits
# 5. Determines version bump (major.minor.patch)
# 6. Creates release automatically
# 7. Updates CHANGELOG.md
# 8. Creates release artifacts
```

## Commit Message Standards

For automated releases to work properly, all commits must follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Release Types
- `feat:` → Minor version bump (1.0.0 → 1.1.0)
- `fix:` → Patch version bump (1.0.0 → 1.0.1)
- `perf:` → Patch version bump
- `docs:` → Patch version bump
- `style:` → Patch version bump
- `refactor:` → Patch version bump
- `test:` → Patch version bump
- `build:` → Patch version bump
- `ci:` → Patch version bump
- `chore:` → No release
- `BREAKING CHANGE:` → Major version bump (1.0.0 → 2.0.0)

### Examples
```bash
# Minor release
git commit -m "feat: add new security scanning agent"

# Patch release  
git commit -m "fix: resolve race condition in hook execution"

# Major release
git commit -m "feat!: redesign agent configuration system

BREAKING CHANGE: agent configuration file format has changed"

# No release
git commit -m "chore: update development dependencies"
```

## Manual Release Prevention

**NEVER create releases manually using:**
- `gh release create`
- GitHub UI release creation
- Git tags without conventional commits

The automated system will:
1. Detect manual releases and may conflict
2. Skip automated releases if tags already exist
3. Break the conventional commit versioning system

## Troubleshooting

### Release Not Created After Merge
```bash
# Check if commits follow conventional format
git log --oneline main

# Check workflow status
gh run list --workflow=release.yml

# View workflow logs
gh run view <run-id> --log
```

### Status Checks Failing
```bash
# Check required status checks
gh api repos/:owner/:repo/branches/main/protection/required_status_checks

# Re-run failed checks
gh run rerun <run-id>
```

### Emergency Hotfix Process
```bash
# Create hotfix branch from main
git checkout -b hotfix/critical-security-fix main

# Make minimal fix with conventional commit
git commit -m "fix: patch critical security vulnerability CVE-2024-xxxxx"

# Create PR with expedited review
gh pr create --title "hotfix: critical security patch" --label "urgent"

# After merge, automated release will create patch version
```

## Security Considerations

- Branch protection prevents direct pushes to main
- All changes require PR review and CI validation
- Security scans must pass before any release
- Signed commits ensure authenticity
- Automated releases prevent human error in security-critical releases

## Next Steps

1. ✅ Configure branch protection rules as specified above
2. ✅ Test the workflow with a feature branch
3. ✅ Validate automated release creation
4. ✅ Train team on conventional commit standards
5. ✅ Document any repository-specific customizations