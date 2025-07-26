# Contributing to Claude Code Sub-Agents

Thank you for your interest in contributing to the Claude Code Sub-Agents ecosystem! This guide will help you get started with contributing effectively.

## 🚀 Quick Start

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/claude-code-sub-agents.git
   cd claude-code-sub-agents
   ```

2. **Validate Setup**
   ```bash
   ./validate-setup.sh
   ```

3. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-improvement
   ```

## 🎯 Contribution Types

### 🤖 Agent Improvements
- Enhance existing agent capabilities
- Add new tools or integrations
- Improve decision-making logic
- Optimize parallel task handling

### 🔧 Infrastructure Enhancements
- CI/CD pipeline improvements
- Security scanning enhancements
- Hook script optimizations
- Workflow automation

### 📚 Documentation
- Agent capability documentation
- Workflow examples
- Best practices guides
- API documentation

### 🐛 Bug Fixes
- Agent configuration issues
- Hook script bugs
- CI/CD pipeline failures
- Security vulnerabilities

## 📋 Development Workflow

### Before You Start
1. Check existing [issues](https://github.com/charles-adedotun/claude-code-sub-agents/issues)
2. Review the [agents-info command](.claude/commands/agents-info.md) for context
3. Understand the [agent classification system](.claude/AGENT_CLASSIFICATION.md)

### Making Changes

#### Agent Configuration Changes
```bash
# Edit agent files in .claude/agents/
# Validate structure
grep -q "^name:\|^description:\|^tools:" .claude/agents/your-agent.md

# Test agent functionality
# (Follow agent-specific testing procedures)
```

#### Hook Script Changes  
```bash
# Edit scripts in .claude/hooks/
# Check syntax
bash -n .claude/hooks/your-script.sh

# Run linting
shellcheck .claude/hooks/your-script.sh

# Test functionality
./.claude/hooks/your-script.sh
```

#### CI/CD Pipeline Changes
```bash
# Edit workflows in .github/workflows/
# Validate YAML syntax
yamllint .github/workflows/your-workflow.yml

# Test locally if possible
act -l  # List available jobs
act -j your-job  # Run specific job
```

### Quality Standards

#### All Contributions Must:
- [ ] Pass `./validate-setup.sh`
- [ ] Include appropriate tests
- [ ] Update relevant documentation
- [ ] Follow security best practices
- [ ] Not contain hardcoded secrets

#### Agent-Specific Standards:
- **Frontend**: Follow shadcn/ui + Tailwind v4 design system
- **Backend**: Include API documentation and validation
- **Security**: Zero high/critical vulnerabilities
- **DevOps**: Infrastructure as Code principles

### Testing Your Changes

1. **Run Validation Script**
   ```bash
   ./validate-setup.sh
   ```

2. **Test Agent Configurations**
   ```bash
   # Check agent file structure
   for agent in .claude/agents/*.md; do
     echo "Validating $agent..."
     grep -q "^name:\|^description:\|^tools:" "$agent" || echo "Missing required fields"
   done
   ```

3. **Test Hook Scripts**
   ```bash
   # Syntax check
   find .claude/hooks -name "*.sh" -exec bash -n {} \;
   
   # Linting
   find .claude/hooks -name "*.sh" -exec shellcheck {} \;
   ```

4. **Security Scan**
   ```bash
   # Check for secrets
   grep -r -i -E "(password|secret|key|token)\s*[:=]\s*[\"'][^\"']+[\"']" .claude/ | grep -v "example\|placeholder"
   ```

## 📝 Commit Guidelines

### Commit Message Format
```
type(scope): description

- detailed change 1
- detailed change 2

Closes #issue-number
```

### Commit Types
- `feat`: New feature or capability
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (no logic changes)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `security`: Security-related changes
- `ci`: CI/CD pipeline changes

### Examples
```
feat(agents): add parallel task capability to frontend-developer

- Enable simultaneous component and styling tasks
- Improve design system validation
- Add accessibility checking pipeline

Closes #123
```

```
fix(hooks): resolve pre-commit script syntax error

- Fix bash syntax in pre-commit-review.sh
- Add proper error handling
- Update shellcheck configuration

Fixes #456
```

## 🔒 Security Guidelines

### Security Requirements
- **No hardcoded secrets** in any files
- **Scan all changes** with security tools
- **Follow principle of least privilege**
- **Validate all inputs** in scripts
- **Use secure defaults** in configurations

### Security Review Process
1. All security-related changes require review by `security-compliance-auditor`
2. Security scans must pass in CI/CD pipeline
3. Sensitive changes require additional manual review
4. Security vulnerabilities have priority for fixes

## 🧪 Testing Guidelines

### Test Types
- **Unit Tests**: For individual components
- **Integration Tests**: For agent interactions
- **End-to-End Tests**: For complete workflows
- **Security Tests**: For vulnerability assessment
- **Performance Tests**: For system efficiency

### Parallel Testing
- Test agent configurations independently
- Validate multi-agent workflows
- Ensure proper isolation between agents
- Test concurrent delegation scenarios

## 📚 Documentation Standards

### Required Documentation
- **Agent Changes**: Update agent capability descriptions
- **Workflow Changes**: Update workflow diagrams and examples
- **API Changes**: Update API documentation
- **Breaking Changes**: Provide migration guides

### Documentation Style
- Use clear, concise language
- Include practical examples
- Keep parallel task examples prominent
- Update the agents-info command as needed

## 🎯 Pull Request Process

### Before Submitting
1. **Validate Changes**
   ```bash
   ./validate-setup.sh
   ```

2. **Run Tests**
   ```bash
   # Run applicable tests
   # Verify CI pipeline compatibility
   ```

3. **Update Documentation**
   - Update relevant agent documentation
   - Add examples for new capabilities
   - Update workflow diagrams if needed

### Pull Request Requirements
- [ ] Clear description of changes
- [ ] Link to related issues
- [ ] All CI checks passing
- [ ] Documentation updated
- [ ] Security review (if applicable)
- [ ] Agent impact assessment

### Review Process
1. **Automated Checks**: CI/CD pipeline validation
2. **Peer Review**: Code and approach review
3. **Agent Testing**: Functionality verification
4. **Security Review**: Security and compliance check
5. **Final Approval**: Maintainer approval

## 🚀 Release Process

### Semantic Versioning
- **MAJOR**: Breaking changes to agent interfaces
- **MINOR**: New agent capabilities or features
- **PATCH**: Bug fixes and minor improvements

### Release Pipeline
1. **Merge to main** triggers release pipeline
2. **Automated testing** validates all components
3. **Security scanning** checks for vulnerabilities
4. **Semantic release** generates version and changelog
5. **GitHub release** created with artifacts

## 💬 Getting Help

### Communication Channels
- **Issues**: Bug reports and feature requests
- **Discussions**: Questions and community support
- **Pull Requests**: Code review and collaboration

### Resources
- [Agent Classification Guide](.claude/AGENT_CLASSIFICATION.md)
- [Agents Info Command](.claude/commands/agents-info.md)
- [Validation Script](./validate-setup.sh)
- [Quality Standards](./CLAUDE.md)

## 🤝 Community Guidelines

### Code of Conduct
- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Focus on technical merit
- Maintain professional communication

### Best Practices
- **Start small**: Begin with minor improvements
- **Ask questions**: Clarify requirements before coding
- **Test thoroughly**: Ensure quality contributions
- **Document changes**: Help others understand your work
- **Be patient**: Code review takes time

## 📊 Contribution Recognition

Contributors will be recognized for:
- Agent capability improvements
- Infrastructure enhancements
- Documentation improvements
- Bug fixes and security patches
- Community support and mentoring

Thank you for contributing to the Claude Code Sub-Agents ecosystem! Your contributions help make AI-powered development more efficient and reliable for everyone.