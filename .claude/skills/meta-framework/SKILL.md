---
name: Meta-Framework Architecture
description: Understand the entire Claude Code framework - how Skills, Memory, and agents work together to organize knowledge. Use when deciding where to document knowledge, designing agents, or rebuilding the system.
---

# Meta-Framework Architecture

**Living Blueprint:** This skill teaches the complete system for organizing knowledge in Claude Code projects. It's the foundation that enables curator agents, bootstraps new projects, and evolves as the framework grows.

---

## What Is This Framework?

A system for organizing knowledge in Claude Code projects that:
- **Separates concerns:** Procedures from facts
- **Scales across projects:** User-level (universal) vs project-level (project-specific)
- **Automates curation:** Curator agents use this framework to organize knowledge
- **Enables bootstrap:** Any Claude instance with this skill can rebuild the entire system

**Core philosophy:** Think of this as **operating system for your project's Claude interaction.**

---

## The Fundamental Distinction

All knowledge falls into exactly two categories:

### Skills = Instructions (HOW to do things)
- **Pattern:** "How to...", "Steps to...", "Process for..."
- **Content:** Workflows, procedures, methods, techniques
- **Scope:** Can be **universal** (reusable across projects) or **project-specific**
- **Location:**
  - Universal: `~/.claude/skills/` (shared across all projects)
  - Project-specific: `.claude/skills/` (this project only)
- **Examples:**
  - "How to author a Skill?" (universal)
  - "How to organize Memory?" (universal)
  - "How to deploy this app?" (project-specific, rare)

### Memory = Knowledge (WHAT is true)
- **Pattern:** "What is...", "When to...", "Never...", "Always...", "Constraint:"
- **Content:** Facts, decisions, rules, constraints, project logic
- **Scope:** **Always project-specific** (tied to THIS project/codebase)
- **Location:** `.claude/context/` or `.claude/memory/` (project-level only)
- **Examples:**
  - "Valid commit scopes: git, nvim, zsh, tmux, docker"
  - "Architecture: 4-layer shell structure"
  - "Constraint: Never modify core initialization"
  - "Decision: Why we use XDG Base Directory spec"

**Key insight:** Skills provide HOW, Memory provides WHAT. Together they create informed execution:
```
Skill:  "Use Conventional Commits with type(scope): description"
Memory: "Valid scopes for this project: git, nvim, zsh, tmux"
Result: Follow the procedure while respecting project constraints
```

---

## Decision Methodology

### Step 1: Skill or Memory?

**Ask: Is this a PROCEDURE or a FACT?**

| Type | Pattern | Creates |
|------|---------|---------|
| Procedure | "How to...", "Steps to..." | **Skill** |
| Fact | "What is...", "Never...", "Always..." | **Memory** |

**If unsure:** Can you rewrite this as an instruction for another Claude instance? If yes → Skill. If no → Memory.

### Step 2: Skill Scope (User-Level or Project-Level?)

*This step ONLY applies to Skills. Memory is always project-level.*

**Ask: Is this procedure UNIVERSAL or PROJECT-SPECIFIC?**

| Characteristic | Universal | Project-Specific |
|---|---|---|
| Works for any project? | ✓ YES | ✗ NO |
| Reusable elsewhere? | ✓ YES | ✗ NO |
| Teaches a general technique? | ✓ YES | ✗ NO |
| Unique to this project's workflow? | ✗ NO | ✓ YES |

**Default:** User-level (preferred). Only use project-level when truly necessary.

---

## How It All Fits Together

### The Four Authoring Skills (User-Level)

These universal skills teach HOW to use the framework:

1. **authoring-agent-skills/SKILL.md**
   - When: "How do I create or improve a Skill?"
   - Teaches: Process for writing focused, reusable procedures
   - Used by: Curator agent, authors, anyone extending the system

2. **authoring-memory/SKILL.md**
   - When: "How do I organize project Knowledge?"
   - Teaches: Retrieval-based organization, query patterns
   - Used by: Curator agent, when adding project facts

3. **authoring-subagents/SKILL.md**
   - When: "How do I design a specialized agent?"
   - Teaches: Subagent architecture, asking before writing, negotiability
   - Used by: Curator agent architecture itself

4. **working-with-git/SKILL.md**
   - When: "How do I work with Git using this framework?"
   - Teaches: Conventional commits, scopes, workflow
   - Used by: Any developer in projects using this framework

### Progressive Disclosure Pattern

Each skill uses this pattern:
```
SKILL.md (overview, when to use, quick examples)
  ↓
reference.md or best-practices.md (deeper guidance)
  ↓
Curator agent loads what it needs via Skills tool
```

**Why:** Keeps main skill concise, detailed guidance available on-demand, token-efficient.

---

## The Curator Agent Pattern

A curator agent orchestrates knowledge organization:

```
User: "Hey agent, assimilate what we've learned"
  ↓
Agent reads this meta-framework skill (understands methodology)
  ↓
Agent reads authoring-* skills (understands procedures)
  ↓
Agent examines discoveries (new facts, new procedures)
  ↓
Agent classifies each using the decision matrices:
  - Skill or Memory?
  - Skill: User-level or Project-level?
  ↓
Agent proposes changes with reasoning
  ↓
Agent asks for approval (unless bypassed)
  ↓
Agent writes changes, reads back to validate
  ↓
Agent reports: "Updated X skills, Y memory files"
```

**Why this works:**
- Separate context window (token-efficient)
- Uses Skills tool (loads framework knowledge on-demand)
- Asks before writing (approval gate)
- Reads its output (self-validating)
- Negotiable (accepts corrections mid-execution)

---

## Applying to Projects

### For New Project

1. Copy user-level skills to `~/.claude/skills/` (if not already installed)
2. Create this meta-framework skill reference in `.claude/skills/meta-framework/SKILL.md`
3. Create project-level memory in `.claude/context/` for project-specific facts
4. Create CLAUDE.md that routes to your memory files
5. Optionally: Set up curator agent in `.claude/agents/`

### For Existing Project

1. Audit existing `.claude/` structure against this framework
2. Migrate project facts to `.claude/context/` (Memory)
3. Create `.claude/skills/` for project-specific procedures (rare)
4. Update CLAUDE.md routing
5. Initialize curator agent

### Evolving Framework

As you learn what works:
1. **Curator discovers new patterns** → Proposes memory files
2. **Curator identifies reusable procedures** → Proposes user-level skills
3. **You approve changes** → Files update
4. **Framework evolves** → This skill gets updated
5. **Next project uses updated skill** → Starts from latest knowledge

---

## Decision Matrices (One Source of Truth)

### Matrix 1: Skill vs Memory?

| Question | Skill | Memory |
|----------|-------|--------|
| Is this a procedure? | ✓ YES | ✗ NO |
| Is this a fact/constraint? | ✗ NO | ✓ YES |
| Can it be reused as a process? | ✓ YES | ✗ NO |
| Is it project-specific fact? | ✗ NO | ✓ YES |
| Does it answer "How to...?"? | ✓ YES | ✗ NO |
| Does it answer "What is..." or "Never..."? | ✗ NO | ✓ YES |

**Decision rule:** 4+ left = Skill | 4+ right = Memory

### Matrix 2: Skill Location (User-Level or Project-Level)?

*Only applies if Step 1 result was: Skill*

| Question | User-Level | Project-Level |
|----------|------------|---------------|
| Works for any project? | ✓ YES | ✗ NO |
| Universal best practice? | ✓ YES | ✗ NO |
| Reusable by others? | ✓ YES | ✗ NO |
| Only for this project? | ✗ NO | ✓ YES |
| Unique to this codebase? | ✗ NO | ✓ YES |

**Decision rule:** 4+ left = User-level | 4+ right = Project-level (rare)

---

## Living Blueprint Philosophy

This skill is intentionally **not fixed:**

**It evolves as you:**
- Discover patterns that work
- Build and refine curator agents
- Learn what scales across projects
- Find new use cases

**Curator agent updates this skill when:**
- New classification patterns emerge
- Decision matrices need refinement
- New authoring skills are created
- Framework architecture improves

**Next project automatically gets:**
- Updated meta-framework skill
- Refined authoring skills
- Proven curator agent patterns

This creates a **learning loop**: Each project refines the framework, next project starts from that refinement.

---

## Quick Reference

**When you're unsure:**
1. Ask: "Is this a procedure or fact?" → Determines Skill vs Memory
2. Ask: "Universal or project-specific?" → Determines user-level vs project-level
3. Consult decision matrices above
4. Use authoring-* skills for detailed guidance
5. Curator agent can help classify and organize

**When something feels monolithic:**
- Break it into targeted skills (not domain-wide skills)
- Split procedures from facts
- Push facts to Memory
- Create focused, reusable Skills

**When starting fresh:**
- Read this skill first (you're here!)
- Use authoring-* skills to create project knowledge
- Set up curator agent for ongoing organization
- Framework emerges from application

---

**Mission:** Enable any Claude instance to understand, apply, refine, and rebuild this entire framework from one focused skill.
