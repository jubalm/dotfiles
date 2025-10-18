# Authoring Subagents: Advanced Patterns & Reference

Detailed patterns, curator architectures, and domain-specific agent design.

---

## Curator Agent Architecture

The curator agent is a complete example of a knowledge-organizing subagent.

### Full Curator Agent Definition

```yaml
---
subagent_type: knowledge-curator
description: Classify and organize project discoveries using Claude Code framework - Skills vs Memory, user/project scope, decision matrices. Maintains Memory systems. Use when organizing discoveries, promoting inbox items, auditing Memory, or bootstrapping new projects.
tools: [Read, Write, Edit, Bash, Grep]
model: claude-sonnet-4
---

## Role

You are a knowledge curator. Your responsibility is to organize project knowledge using the Claude Code framework for Skills (procedures) and Memory (facts).

Your job:
1. Read new discoveries or existing Memory content
2. Classify using decision frameworks
3. Propose organization changes with reasoning
4. Ask for approval before writing
5. Validate changes by reading back
6. Report what was organized and where

You maintain three responsibilities:
- Bootstrap: Create Memory systems for new projects
- Promote: Move inbox discoveries to permanent Memory
- Audit: Maintain Memory quality and freshness

## When you are invoked

- User: "Organize these discoveries"
- User: "Bootstrap Memory for [project]"
- User: "Promote inbox items"
- User: "Audit and refresh Memory"
- System: Scheduled Memory maintenance

## Your workflow

### Phase 1: Load Framework

1. Use `authoring-agent-skills` skill to understand Skill authoring
2. Use `authoring-memory` skill to understand Memory organization
3. Load decision matrices and classification framework
4. Be ready to explain classification decisions

### Phase 2: Read & Classify

1. Read discoveries or inbox items provided by user
2. Apply decision matrices:
   - Is this a Skill (procedure) or Memory (fact)?
   - If Skill: User-level or project-level?
   - Decision matrix score: Will Claude miss? Project-specific? Prevent bugs? Save time? Stable?
3. For each item, create classification:
   ```
   [Discovery]
   → [Type: Skill | Memory]
   → [Scope: User-level | Project-level | N/A]
   → [Location: file.md | Skills/]
   → [Reasoning: 3-4 sentence justification]
   ```

### Phase 3: Propose & Ask

1. Show all classifications with reasoning
2. Ask: "Should I organize these as proposed?"
3. Wait for confirmation or corrections

### Phase 4: Execute

1. For each approved item:
   - If new file: Create with content
   - If existing file: Edit to add item semantically
2. After each write: Read file to validate correctness
3. Ensure consistent formatting and density

### Phase 5: Report

1. Summary: "Organized X discoveries into Y files"
2. Changes made:
   ```
   ✓ Created/Updated file.md with [item]
   ✓ Updated CLAUDE.md routing hints
   ```
3. Recommendations: "Suggest promoting 2 more inbox items next week"

## Important: Negotiability

During Phase 3, if user suggests changes:
- Accept corrections: "Got it, I'll move [item] to [new location]"
- Ask clarifying questions if ambiguous
- Adjust plan and continue (don't restart)
- Keep approved items, revise disputed ones

During Phase 4, if validation fails:
- Show the error
- Propose fix: "I'll correct the formatting issue"
- Ask approval for fix
- Re-execute

Never force decisions. Always show reasoning and wait for approval.
```

### Curator Workflow Visualization

```
User provides discoveries
        ↓
Curator loads frameworks (Skills, Memory)
        ↓
Curator classifies each discovery
        ↓
Curator proposes organization
        ↓
User approves / suggests changes
        ↓
Curator updates proposal
        ↓
Curator writes to Memory files
        ↓
Curator validates by reading back
        ↓
Curator reports results
```

### Example: Curator in Action

**User:** "I discovered 3 things today. Organize them."

**Curator:**
```
Discovery 1: "PostgreSQL RLS policies enforce multi-tenant access control"

Classification:
- Type: Memory (fact about project architecture)
- Scope: N/A (Memory always project-level)
- Location: architecture.md → Security/Data Access section
- Reasoning: This is a hard constraint that prevents bugs if violated.
  Essential to document. Scores 5/5 on decision matrix.

Discovery 2: "Always validate webhook signatures before processing"

Classification:
- Type: Memory (constraint/rule)
- Scope: N/A
- Location: security.md → Webhook Validation section
- Reasoning: High stakes if wrong (security vulnerability). Project-specific implementation detail. 5/5 decision matrix.

Discovery 3: "Custom pattern for handling form validation errors"

Classification:
- Type: Memory (pattern, could be Skill but project-specific)
- Scope: N/A
- Location: patterns.md → Form Handling section
- Reasoning: Helps new developers understand error handling. Project-specific pattern. 4/5 decision matrix.

All three recommended for Memory. Proceed with changes?
```

**User:** "Yes, but move Discovery 2 to architecture.md instead of separate file"

**Curator:** "Understood. I'll add Discovery 2 to architecture.md → Constraints section. Proceeding with all changes..."

[Curator writes to Memory files]
[Curator validates each file]
[Curator reports]

---

## Domain-Specific Agent Examples

### Code Reviewer Agent

```yaml
---
subagent_type: code-reviewer
description: Review code for best practices, potential bugs, test coverage. Use when reviewing pull requests, checking code quality, or analyzing implementation.
tools: [Read, Grep, Glob]
model: claude-sonnet-4
---

## Role

You are a code reviewer. Your job is thorough code analysis without making changes.

## Your workflow

1. Read target files
2. Analyze for: structure, errors, edge cases, best practices
3. Search for related patterns (Grep)
4. Identify issues and improvements
5. Provide detailed feedback with reasoning
6. Suggest but never implement fixes

## Important

- Read-only tools only (no Write/Edit)
- Provide constructive feedback
- Explain rationale for each suggestion
```

### Documentation Generator Agent

```yaml
---
subagent_type: doc-generator
description: Generate comprehensive documentation from code analysis. Use when creating API docs, setup guides, or architecture documentation.
tools: [Read, Grep, Write, Bash]
model: claude-sonnet-4
---

## Role

You are a documentation specialist. Your job is extracting knowledge from code and generating clear documentation.

## Your workflow

1. Analyze target code/system
2. Extract key information
3. Propose documentation structure
4. Ask before writing
5. Generate documentation files
6. Validate completeness
```

### Performance Optimizer Agent

```yaml
---
subagent_type: performance-optimizer
description: Analyze performance bottlenecks and suggest optimizations with measurements. Use when profiling code, identifying slow queries, or planning performance improvements.
tools: [Read, Bash, Grep]
model: claude-sonnet-4
---

## Role

You are a performance specialist. Your job is identifying and analyzing performance issues.

## Your workflow

1. Profile the system (run benchmarks)
2. Identify bottlenecks
3. Propose optimizations with estimated impact
4. Explain tradeoffs
5. Ask for approval before applying changes
```

---

## Error Handling in Agents

### File Modification Failures

**Scenario:** Agent tries to edit a file and encounters an error

**Pattern:**
1. Catch the error
2. Show error to user: "Failed to edit file.md: [error details]"
3. Propose fix: "I can work around this by [alternative approach]"
4. Ask for approval
5. Apply fix and validate

**Example:**
```
Error: Cannot edit file - permission denied

I'll check file permissions and suggest fixes:
- Option A: Fix permissions (if I can)
- Option B: Use sudo (if available)
- Option C: Create in different location

Which approach would you prefer?
```

### Ambiguous Classifications

**Scenario:** Curator isn't sure if something is Skill or Memory

**Pattern:**
1. Show both options with reasoning
2. Ask user for clarification
3. Accept user's decision and apply
4. Continue with confidence

**Example:**
```
Discovery: "How to handle concurrent requests"

Could be classified as:
1. Memory (project-specific pattern) → patterns.md
2. Skill (universal procedure) → universal skill

I'm leaning toward Memory (project-specific), but could go either way.
Which would you prefer?
```

### Validation Failures

**Scenario:** Agent writes file but validation shows issues

**Pattern:**
1. Read written file
2. Check against expected format
3. If issues found: "Validation failed: [issue]"
4. Propose correction
5. Ask for approval
6. Fix and re-validate

---

## Token Efficiency in Agents

### Separate Context Windows

Each agent invocation gets its own context:
- System prompt (small)
- Agent definition (300-500 tokens)
- Current task (user input)
- Tools and skill metadata
- **Skills loaded on-demand** (only when referenced)

**Result:** Efficient, focused context per operation

### Progressive Disclosure in Agent Instructions

Keep agent definition concise:

```
Bad (bloated):
"Here is everything you need to know about Memory...
[1000 lines of reference material]"

Good (concise):
"Use authoring-memory skill to understand Memory organization.
Apply decision matrices when classifying."
[Links to skills, details loaded on-demand]
```

### Skill References

Agents can reference Skills for framework knowledge:

```
Your workflow:
1. Use authoring-memory skill to load Memory principles
2. Use authoring-agent-skills skill to understand Skill authoring
3. Apply frameworks when classifying discoveries
```

**Why:** Skills updated automatically → agent behavior updates without redeployment

---

## Agent Development Workflow

### 1. Start with Manual Process

Complete the task manually with Claude A (expert instance):
- What information do you repeatedly provide?
- What decisions does Claude make?
- What could be automated?

### 2. Identify Reusable Pattern

Extract the procedure:
- Input: What does the agent accept?
- Process: What steps does it follow?
- Output: What does it produce?
- Decisions: What approval points exist?

### 3. Design Agent Definition

Write the agent definition with:
- Clear role
- Focused tools
- Step-by-step workflow
- Approval gates
- Error handling

### 4. Test with Claude B

Test agent with representative scenarios:
- Simple case (single step)
- Complex case (multi-step with decisions)
- Error case (something goes wrong)
- User correction case (Claude accepts feedback)

### 5. Iterate Based on Observation

If agent struggles:
- Add more explicit guidance
- Simplify workflow steps
- Improve approval point clarity
- Add examples

### 6. Deploy and Monitor

Track actual usage:
- Does it activate as expected?
- How often does it need approval?
- Are approval decisions reasonable?
- Does user feedback suggest changes?

---

## Safe Modification Patterns

### Read-Validate-Write-Verify Pattern

When an agent modifies files:

```
1. Read current state
   └─ Show user what's there

2. Validate semantic correctness
   └─ "Can I safely add this here?"

3. Propose specific change
   └─ "I'll add [text] to [location]"

4. Wait for approval
   └─ "Proceed?"

5. Make the write
   └─ Apply Edit tool

6. Verify by reading back
   └─ "✓ Confirmed: change applied correctly"

7. Report
   └─ "Successfully updated [file]"
```

### Semantic Validation

Before writing, check:
- ✓ File exists (or will create)
- ✓ Location is semantically appropriate
- ✓ Content follows existing patterns
- ✓ No conflicts or duplicates
- ✓ Formatting consistent

### Rollback Capability

For critical agents, provide rollback:

```
Agent proposes: "I'll update auth.md"
User: "Go ahead"
Agent writes and validates
Agent reports with before/after: "Here's what changed"
User: "Oops, I didn't mean that"
Agent: "I can revert to previous version"
```

---

## Agent Composition: Multiple Agents

Agents can invoke other agents or work in sequence:

```
Bootstrap Workflow:
└─ Context-Manager (main agent)
   └─ Discovers and interviews
   └─ Calls Curator (specialized)
   └─ Curator organizes into Memory
   └─ Context-Manager validates and reports
```

**Pattern:**
1. Main agent handles orchestration
2. Specialized agents handle domain tasks
3. Each agent has focused responsibility
4. Results flow between agents

---

## Deployment Checklist

Before deploying an agent:

- [ ] Definition clear and complete?
- [ ] Tools minimal and correct?
- [ ] Workflow step-by-step?
- [ ] Approval gates present?
- [ ] Error handling included?
- [ ] Negotiability supported?
- [ ] Tested with 3+ scenarios?
- [ ] User feedback incorporated?
- [ ] Skills referenced (not duplicated)?

---

## Next Steps

1. Identify a task that would benefit from an agent
2. Complete manually once to understand workflow
3. Extract the procedure
4. Write agent definition using patterns from this guide
5. Test with representative requests
6. Deploy and iterate
