# Claude Code Agent Configuration

> Essential configuration for Claude Code's sub-agent ecosystem

## Available Agents

### 📋 Planning
- **`product-requirements-analyst`** - Requirements analysis & system architecture

### 🔨 Implementation  
- **`frontend-developer`** - React/shadcn/ui/Tailwind v4 specialist
- **`backend-developer`** - Multi-language server development
- **`sre-devops-specialist`** - Infrastructure & deployment automation

### 🧪 Validation
- **`qa-testing-specialist`** - Testing & quality assurance with Playwright
- **`security-compliance-auditor`** - Security analysis & compliance
- **`pre-commit-reviewer`** - Fast code quality gate (auto-triggered)

## Quick Usage

### Automatic Delegation
Agents are suggested automatically based on file patterns:
- Frontend files → `frontend-developer`
- Backend files → `backend-developer`  
- Infrastructure → `sre-devops-specialist`
- Tests → `qa-testing-specialist`
- Security files → `security-compliance-auditor`
- Documentation → `product-requirements-analyst`

### Explicit Usage
```
> Use the frontend-developer agent to create a responsive navigation component
> Have the security-compliance-auditor review this authentication code
> Ask the qa-testing-specialist to create E2E tests for checkout
```

## Key Quality Standards

### Frontend (shadcn/ui + Tailwind v4)
- **4 font sizes, 2 weights** (non-negotiable)
- **8pt grid system** (all spacing divisible by 8 or 4) 
- **60/30/10 color distribution**
- **WCAG 2.1 AA accessibility**

### Backend
- **100% API documentation** (OpenAPI/Swagger)
- **Input validation & sanitization**
- **90%+ test coverage**
- **No hardcoded secrets**

### Security & DevOps
- **Zero high/critical vulnerabilities**
- **Infrastructure as Code**
- **99.9% uptime SLO**
- **Comprehensive monitoring**

## Workflow Integration

```
Planning → Implementation → Validation → Deployment
    ↓           ↓             ↓           ↓
 analyst   developers    validators    devops
```

## Agent Authority
- **pre-commit-reviewer**: Can block commits
- **qa-testing-specialist**: Can block releases  
- **security-compliance-auditor**: Can block commits, releases & deployments
- **sre-devops-specialist**: Controls production deployments

For detailed documentation, see `docs/AGENT_CLASSIFICATION.md`