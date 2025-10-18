---
name: Authoring Subagents
description: Create and design Claude Code subagents for specialized tasks. Use when authoring agents, implementing ask-before-write patterns, building multi-step automation with approval gates, or creating domain-specific workflows (code review, knowledge curation, refactoring).
---

# Authoring Subagents

**Focused capability:** Design autonomous agents that handle complex, multi-step tasks with human oversight.

---

## Core Principle: Ask Before Writing

Agents that modify state → Show reasoning → Ask approval → Execute

**Why:** ✓ User control, ✓ Proposal transparency, ✓ Negotiable execution

---

## Agent Anatomy

### Required Structure

**Frontmatter (metadata):**
```yaml
---
name: agent-name                        # Unique identifier (lowercase, hyphens)
description: When to use this agent     # Purpose and triggers
tools: Read, Write, Edit                # Comma-separated; omit to inherit all
model: sonnet                           # See choosing-a-model.md
---
```

**System Prompt (body):**
```markdown
You are a [specialist description].

Your responsibilities:
1. [First responsibility]
2. [Second responsibility]

When you are invoked:
- [Use case 1]
- [Use case 2]

Your workflow:
1. [First step]
2. [Second step]
```

### Model Selection

See [choosing-a-model.md](choosing-a-model.md) for details. Quick reference:
- **Haiku**: Fast, simple tasks, low cost
- **Sonnet**: Balanced (recommended default)
- **Opus**: Complex reasoning, specialized tasks

### Complete Minimal Example

```yaml
---
name: code-formatter
description: Format code according to project standards
tools: Read, Edit
model: sonnet
---

You are a code formatter ensuring consistent style.

When you are invoked:
- User asks to format code or files
- Code needs style standardization

Your workflow:
1. Read the target file
2. Identify formatting issues
3. Propose changes with reasoning
4. Ask: "Should I proceed with these changes?"
5. After approval: Apply edits
6. Read back and report results
```

---

## Design Patterns

Quick patterns for common agent types. See [reference.md](reference.md) for complete examples.

| Pattern | Use Case | Tools |
|---------|----------|-------|
| Simple automation | Single-step tasks | Read, Edit |
| Multi-step approval | Complex workflows | Read, Grep, Edit |
| Knowledge curator | Classification, organization | Read, Write, Edit, Grep |

---

## Ask-Before-Write Pattern

**Workflow:**
1. Analyze situation
2. Propose action with reasoning
3. Ask: "Should I proceed?"
4. After approval: Execute
5. Read back to validate
6. Report results

**Benefits:** ✓ User control, ✓ Transparent reasoning, ✓ Negotiable execution

---

## Negotiability: Accept Mid-Execution Corrections

Design agents to pivot without restarting:

```
Agent: "I'll refactor Component A by extracting getUser"
User: "Actually, extract useUser hook from Component B instead"
Agent: "Understood. Refactoring Component B..."
```

**How:**
- Be specific in proposals (user can correct exactly)
- Ask confirmation before major steps
- Accept "no, try this instead"
- Adjust and continue

---

## Detailed Guidance

- [reference.md](reference.md) - Official Claude Code subagent documentation
- [examples.md](examples.md) - Advanced patterns: curator workflow, domain-specific agents, error handling, safe modifications
- [choosing-a-model.md](choosing-a-model.md) - How to choose the right model for your agent

---

## Quick Start

1. Choose agent type (simple, multi-step, curator, etc.)
2. Define role and specialty
3. Select only required tools
4. Write step-by-step workflow
5. Include ask-before-write gates if modifying state
6. Test with sample requests
7. Iterate based on usage

See [reference.md](reference.md) for complete examples and error handling patterns.
