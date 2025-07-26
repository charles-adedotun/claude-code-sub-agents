---
name: agents-info
description: Quick reference for Claude's sub-agent ecosystem and parallel task delegation
aliases: ["agents", "agent-help", "sub-agents"]
---

# Sub-Agents Quick Reference

## Available Agents

**📋 Planning**
- `product-requirements-analyst` - Requirements, architecture, API design

**🔨 Implementation** 
- `frontend-developer` - React/shadcn/ui/Tailwind v4 (strict design system)
- `backend-developer` - APIs, databases (Node.js/Python/Go/Java/Rust)
- `sre-devops-specialist` - Infrastructure, CI/CD, deployments

**🧪 Validation**
- `qa-testing-specialist` - Testing, Playwright E2E, accessibility
- `security-compliance-auditor` - Security audits, compliance (blocks releases)
- `pre-commit-reviewer` - Fast code quality checks (auto-triggered)

## Parallel Task Examples

**Simultaneous Implementation:**
```
Use frontend-developer to create the user dashboard component while 
backend-developer builds the user API endpoints, and 
sre-devops-specialist sets up the deployment pipeline
```

**Parallel Review Process:**
```
security-compliance-auditor review the authentication system while
qa-testing-specialist creates E2E tests for login flow and
frontend-developer implements accessibility improvements
```

**Multi-Agent Feature Development:**
```
product-requirements-analyst define the payment system requirements,
then have backend-developer build the payment API simultaneously with
frontend-developer creating the checkout UI, while
sre-devops-specialist configures the secure payment infrastructure
```

## Agent Authority Matrix

| Agent | Blocks Commits | Blocks Releases | Blocks Deployment |
|-------|:--------------:|:---------------:|:-----------------:|
| pre-commit-reviewer | ✅ | ❌ | ❌ |
| qa-testing-specialist | ❌ | ✅ | ❌ |
| security-compliance-auditor | ✅ | ✅ | ✅ |
| sre-devops-specialist | ❌ | ❌ | ✅ |

## Workflow Stages

```
📋 PLANNING → 🔨 IMPLEMENTATION → 🧪 VALIDATION → 🚀 DEPLOYMENT
```

**Planning**: requirements-analyst designs system
**Implementation**: frontend/backend/devops build in parallel
**Validation**: qa-testing & security-compliance verify quality
**Deployment**: sre-devops manages production releases

## Key Quality Standards

- **Frontend**: 4 font sizes, 8pt grid, WCAG 2.1 AA
- **Backend**: 100% API docs, no hardcoded secrets, 90% test coverage
- **Security**: Zero critical vulnerabilities
- **DevOps**: 99.9% uptime SLO, Infrastructure as Code

**Use this ecosystem to run multiple specialized agents in parallel for faster, higher-quality delivery.**