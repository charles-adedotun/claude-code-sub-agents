# Claude Agents

AI agents for Claude Code that adapt to your project.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/charles-adedotun/claude-code-sub-agents/main/init.sh | bash
```

## Use

In Claude Code:
```
> Use agent-architect to set up agents for this project
```

The agent-architect will:
- Detect your tech stack
- Create 2-4 specialized agents
- Configure them for your project

## How It Works

1. **agent-architect** - The meta-agent that creates other agents
2. **Project agents** - Created based on what you're building:
   - `frontend-developer` - For React, Vue, etc.
   - `backend-developer` - For APIs, databases
   - `test-engineer` - For testing
   - `devops-engineer` - For deployment

## Update

```
> Use agent-architect to check for updates
> Use agent-architect to upgrade agents
```

## Custom Agents

Create your own in `.claude/agents/my-agent.md`:

```markdown
---
name: my-agent
description: What this agent does
---

You are a [role] specialist.

## Expertise
[What you know]

## Responsibilities  
[What you do]
```

## License

MIT