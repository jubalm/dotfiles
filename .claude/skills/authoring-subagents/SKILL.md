---
name: Authoring Subagents
description: Design specialized Claude agents for complex multi-step tasks - knowledge curators, code reviewers, domain experts. Use when creating custom agents, designing curator workflows, or extending Claude Code capabilities.
---

# Authoring Subagents

**Focused capability:** Design autonomous agents that handle complex, multi-step tasks with human oversight.

A subagent is a specialized Claude instance with focused tools, role definition, and decision-making authority. This guide teaches how to design agents that are effective, safe, and user-friendly.

---

## When to Use This Skill

- Creating a specialized agent for a specific task
- Designing a curator agent for knowledge curation
- Building multi-step workflow automation
- Extending Claude Code with domain expertise
- Designing agents that modify files safely

---

## Core Principle: Ask Before Writing

**Safety pattern:** Agents that modify state should ask for approval before making changes.

**User experience:** Users stay in control. Agents propose, users decide.

**Implementation:** Show reasoning, ask for approval, wait for confirmation, then execute.

---

## Agent Anatomy

### Required Elements

```yaml
---
subagent_type: agent-name        # Unique identifier
description: When to use this agent
tools: [Read, Write, Edit, Bash, Grep]  # Only what's needed
model: claude-sonnet-4           # Which model to use
---

## Role

You are a specialist in...

## When you are invoked

- Scenario 1
- Scenario 2

## Your workflow

1. First step
2. Second step
```

### Key Principles

1. **Focused role** - One specialty per agent
2. **Limited tools** - Only tools the task requires
3. **Clear workflow** - Step-by-step procedure
4. **Approval gates** - Ask before modifying state
5. **Negotiability** - Accept user corrections mid-execution

---

## Design Patterns

### Pattern 1: Simple Task Automation

**Use when:** Single-step or linear workflow

```yaml
---
subagent_type: code-formatter
description: Format code according to project standards
tools: [Read, Edit, Bash]
model: claude-sonnet-4
---

## Role

You are a code formatter. Your job is to ensure code follows project conventions.

## Your workflow

1. Read the target file
2. Identify formatting issues
3. Apply project conventions
4. Report changes made
```

### Pattern 2: Multi-Step with Approval

**Use when:** Complex operations where user should approve intermediate steps

```yaml
---
subagent_type: refactoring-assistant
description: Large-scale code refactoring with approval at each step
tools: [Read, Grep, Edit]
model: claude-sonnet-4
---

## Your workflow

1. Analyze current code structure
2. Propose refactoring plan (wait for approval)
3. Refactor first component (show changes, ask for approval)
4. Refactor second component (show changes, ask for approval)
5. Run tests to verify (report results)
```

### Pattern 3: Knowledge Curator

**Use when:** Organizing and classifying knowledge

```yaml
---
subagent_type: knowledge-curator
description: Classify and organize project knowledge using decision frameworks
tools: [Read, Write, Edit, Grep]
model: claude-sonnet-4
---

## Role

You are a knowledge curator. Your job is to organize project knowledge using the Claude Code framework.

## Your workflow

1. Read discoveries (provided by user)
2. Use authoring-* skills to classify each
3. Propose organization with reasoning
4. Ask for approval before writing
5. Write to appropriate Memory files
6. Validate by reading back
7. Report: what was organized, where
```

---

## Key Patterns: Ask Before Writing

### Pattern: Show Reasoning, Request Approval, Execute

```
Agent:
1. Analyzes the situation
2. Proposes a specific action with reasoning
3. Asks: "Should I proceed with this change?"
4. Waits for user confirmation
5. After approval: Makes the change
6. Reads back to validate
7. Reports: "✓ Done, here's what changed"
```

### Why This Works

- ✓ User stays in control
- ✓ Agent can explain reasoning
- ✓ User can correct course mid-execution
- ✓ Prevents surprises
- ✓ Builds trust

---

## Negotiability: Accept User Corrections

**Design agents to accept mid-execution feedback:**

```
Agent proposes: "I'll refactor Component A by extracting getUser function"

User corrects: "Actually, keep it inline. Extract something else instead."

Agent adapts: "Understood. I'll refactor Component B instead,
extracting useUser hook"

Result: Agent pivots without restarting
```

**Implementation:**
- Be specific in proposals (user can correct exactly)
- Ask for confirmation before major steps
- Accept "no, try this instead"
- Adjust plan and continue

---

## Curator Agent: Complete Example

The knowledge curator agent orchestrates Memory organization.

### Curator Agent Definition

```yaml
---
subagent_type: knowledge-curator
description: Classify project discoveries using Claude Code framework and organize into Memory files
tools: [Read, Write, Edit, Grep, Bash]
model: claude-sonnet-4
---

## Role

You are a knowledge curator. Your job is to organize project knowledge using the Claude Code framework (Skills vs Memory, decision matrices, quality principles).

## When you are invoked

- User asks to "assimilate discoveries"
- User provides new project knowledge to organize
- Memory system needs curation or reorganization
- Inbox items need promotion to permanent files

## Your workflow

1. **Load framework** - Use authoring-agent-skills and authoring-memory skills
2. **Read input** - Get discoveries or inbox items from user
3. **Classify each** - Apply decision matrices (Skill or Memory? User or Project level?)
4. **Propose organization** - Show: [Discovery] → [Type] → [Location]
5. **Ask for approval** - "Should I proceed with these changes?"
6. **Write changes** - Create/edit Memory files and Skills
7. **Validate** - Read back written content
8. **Report results** - Summary of what was organized
9. **Be negotiable** - Accept corrections to classification or placement
```

### Curator Agent Usage

**User:** "Here are 3 discoveries from today, organize them"

**Curator:**
1. Reads discoveries
2. Uses authoring-* skills to classify
3. Proposes: "I'll add #1 to principles.md, #2 to security.md, #3 to inbox"
4. Asks: "Proceed?"
5. User: "Actually, move #2 to architecture.md instead"
6. Agent: "Got it, updating to architecture.md"
7. Agent writes all changes
8. Agent reports: "✓ Updated 2 Memory files, added 1 to inbox"

---

## Safe File Modification

### Before-And-After Pattern

When an agent modifies files:

1. **Show current state** - Read and display
2. **Propose changes** - "I'll change X to Y"
3. **Ask approval** - "Proceed?"
4. **Make changes** - Apply edits
5. **Show new state** - Read and display changed file
6. **Report** - "✓ Done, here's what changed"

### Example: Code Formatter Agent

```
Current file:
def hello(x,y):
  return x+y

Proposed changes:
- Add spaces around operators
- Add type hints
- Add docstring

Result:
def hello(x: int, y: int) -> int:
    """Add two integers."""
    return x + y

Proceed? [User confirms]
[Agent makes edit]
[Agent reads back to verify]
Report: ✓ Formatted successfully
```

---

## Progressive Disclosure: Skills in Agents

Agents can use Skills to load knowledge on-demand.

**Why:**
- Keeps agent instructions concise
- Skills updated automatically → agent behavior updates
- Separate context window (token-efficient)

**Example: Curator Agent**

```
Agent definition:
"Use authoring-memory skill to understand Memory organization.
Use authoring-agent-skills skill to understand Skill authoring.
Use these frameworks when classifying discoveries."

Result:
- Agent's own context is small (~500 tokens)
- Agent loads framework skills only when needed
- Framework updates automatically apply
- Each discovery classification is efficient
```

---

## Testing Agents

### Quick Validation

Before using an agent in production:

1. **Test with simple request** - Basic, single-step task
2. **Test with complex request** - Multi-step with decisions
3. **Test error handling** - What happens when something fails?
4. **Test negotiability** - Can user correct mid-execution?
5. **Test approval flow** - Does ask-before-write work?

### Example Testing

**Test 1: Simple request**
```
User: "Organize these 2 discoveries"
Agent should: Classify, propose, ask, execute
Result: ✓ Works
```

**Test 2: Complex request**
```
User: "Organize 5 discoveries with different contexts"
Agent should: Handle variety, ask about ambiguous cases
Result: ✓ Works with one clarification
```

---

## Detailed Guidance

For comprehensive agent architecture patterns:
- See [reference.md](reference.md) for advanced patterns
- See [SKILL.md](SKILL.md) for quick reference

For creating specific agent types:
- Curator agents: Memory organization, knowledge curation
- Reviewer agents: Code review, quality checks
- Optimizer agents: Performance, refactoring
- Analyzer agents: Research, synthesis, reporting

---

## Quick Checklist: Agent Quality

- [ ] Single, focused specialty?
- [ ] Only necessary tools included?
- [ ] Clear role definition?
- [ ] Step-by-step workflow?
- [ ] Ask-before-write for modifications?
- [ ] Accepts user corrections (negotiable)?
- [ ] Uses Skills for framework knowledge?
- [ ] Tested with representative requests?

---

## Next Steps

1. Define your agent's role and specialty
2. Choose only the tools it needs
3. Write step-by-step workflow
4. Include ask-before-write gates
5. Test with sample requests
6. Deploy and iterate based on usage

See [reference.md](reference.md) for advanced curator patterns, domain-specific agents, and error handling strategies.
