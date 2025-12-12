# Claude Code Sub-Agents

[![CI](https://github.com/charles-adedotun/claude-code-sub-agents/actions/workflows/ci.yml/badge.svg)](https://github.com/charles-adedotun/claude-code-sub-agents/actions/workflows/ci.yml)

Meta-agent system that bootstraps project-specific AI agents for Claude Code.

## Why This Exists

You're starting a new project and need specialized AI assistance. Instead of using a general-purpose AI, you want agents that understand your stack, know your patterns, and speak your domain language. This tool generates that expertise on demand.

## What It Does

Installs an `agent-architect` that creates specialized sub-agents for your project:

- **Frontend Agent** - React, Vue, styling, component architecture
- **Backend Agent** - APIs, databases, business logic
- **DevOps Agent** - CI/CD, deployment, infrastructure
- **Test Agent** - Unit tests, integration tests, test strategy

Each agent lives in `.claude/agents/` as a markdown file containing focused instructions and domain knowledge.

## Tech Stack

- Shell scripts for bootstrapping
- Markdown for agent definitions
- Claude Code CLI for execution

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/charles-adedotun/claude-code-sub-agents/main/init.sh | bash
```

Then in your project:

```bash
/agent-architect
```

Select the agents you need. The architect generates them instantly.

## How It Works

1. **Single Entry Point** - `init.sh` bootstraps the entire system
2. **Agent Templates** - Pre-built agent definitions in `templates/`
3. **Custom Generation** - Architect adapts templates to your project context
4. **Instant Availability** - Agents appear in `.claude/agents/` ready to use

## Architecture

```
claude-code-sub-agents/
├── init.sh                    # Bootstrap script
├── templates/
│   ├── frontend-agent.md      # Frontend specialist template
│   ├── backend-agent.md       # Backend specialist template
│   ├── devops-agent.md        # DevOps specialist template
│   └── test-agent.md          # Test specialist template
└── agent-architect/
    └── architect.md           # Meta-agent that creates other agents
```

Agents are markdown files containing:
- Role definition
- Technical expertise
- Common patterns
- Best practices
- Project-specific context

## Usage

After installation, invoke agents like any Claude Code agent:

```bash
# Use the architect to create new agents
/agent-architect

# Use generated agents
/frontend "Build a user profile component"
/backend "Add rate limiting to the API"
/devops "Set up staging environment"
/test "Write integration tests for auth flow"
```

## Future Ideas

- **Expanded Templates** - Database, security, documentation, API design agents
- **Team Sharing** - Export/import agent configurations across teams
- **Version Control** - Track agent evolution alongside code changes
- **Context Learning** - Agents that improve based on project patterns
- **Agent Composition** - Combine multiple agents for complex tasks

## Contributing

This is a tool for builders. If you've created agents that solve real problems, submit them. If you've found edge cases, document them. Keep it practical.

## License

MIT
