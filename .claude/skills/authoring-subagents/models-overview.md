# Model Selection

Quick reference for the `model:` field when authoring agents.

## Recommended Default

**Use `sonnet`** - Best balance of intelligence and speed for most agents.

## Available Model Aliases

| Alias | Description | Best For |
|-------|-------------|----------|
| `sonnet` | Smartest model for complex agents | Multi-step workflows, code analysis, balanced tasks |
| `haiku` | Fastest model with strong intelligence | Simple automation, high-volume tasks |
| `opus` | Exceptional reasoning capabilities | Specialized domains, critical decisions |

## Choosing a Model

- **Sonnet**: Default choice for most agents (complex workflows, coding, multi-step)
- **Haiku**: Fast, simple tasks (formatting, linting, quick automation)
- **Opus**: Deep reasoning required (specialized expertise, critical decisions)
- **`inherit`**: Match main conversation's model for consistency

For comprehensive model details, see [Claude Models Overview](https://docs.claude.com/en/docs/about-claude/models/overview).
