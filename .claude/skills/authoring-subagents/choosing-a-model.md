# Choosing a Model

Quick guide to selecting the right model for your agent's `model:` field.

## Quick Decision

**Most agents: use `sonnet`** - Best balance of intelligence, speed, and cost.

## Decision Guide

1. Do you need maximum intelligence for complex reasoning?
   - Yes → `opus`
   - No → Continue to next
2. Do you prioritize speed and cost over capability?
   - Yes → `haiku`
   - No → `sonnet` (recommended)

## Model Comparison

| Model | Speed | Intelligence | Cost | Best For |
|-------|-------|--------------|------|----------|
| `sonnet` | Fast | Highest | Moderate | Most agents (default) |
| `haiku` | Fastest | High | Lowest | Simple automation, quick tasks |
| `opus` | Moderate | Exceptional | Highest | Specialized reasoning, complex logic |

## Other Options

- **`inherit`**: Use main conversation's model for consistency between agent and parent context

## Learn More

Full details: [Claude Models Overview](https://docs.claude.com/en/docs/about-claude/models/overview)
