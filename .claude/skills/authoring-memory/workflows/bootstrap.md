# Bootstrap: Create Memory System from Scratch

## 5-Minute Quick-Start

For small projects, do this first:

1. **Discover** (2 min) - List 3-5 key decisions
2. **Score** - Do any hit 3+ yes? If yes, proceed.
3. **Structure** - Pick starter or growing pattern
4. **Create** - Build CLAUDE.md + conventions.md
5. **Add inbox** - Ready for future discoveries

**Result:** Minimal Memory, expandable.

---

## Full Bootstrap (2-4 hours)

Complete workflow for comprehensive Memory.

### Step 1: Discover (30 min)

**Goal:** Understand codebase and current state

**Actions:**
- Read `package.json` → tech stack
- List directory structure → organization
- Read main entry files → architecture
- Check recent git commits → recent decisions
- Identify key modules → mental model

**Output:** List of 5-10 key decisions

### Step 2: Interview (45 min)

**Goal:** Extract knowledge not visible in code

Ask your team:

1. **Technology:** "Why did you choose X over Y?"
2. **Architecture:** "How are concerns separated?"
3. **Patterns:** "What's the standard pattern for...?"
4. **Constraints:** "What rules prevent bugs?"
5. **Product:** "What's unique about our domain?"
6. **Gotchas:** "What trips up new developers?"

**Output:** 20-30 discoveries

### Step 3: Score (30 min)

**Goal:** Determine what's worth documenting

For each discovery, apply decision matrix (1-5 on each criterion):

```
✓ Would Claude miss?
✓ Project-specific?
✓ Prevent bugs?
✓ Save time?
✓ Stable?
```

Keep items scoring 3+ yes.

**Output:** 10-20 high-value items

### Step 4: Structure (15 min)

**Goal:** Organize discoveries into files

Choose pattern:
- **Starter:** conventions.md only
- **Growing:** principles, architecture, patterns
- **Complex:** Add domain/concern-specific files

Group discoveries:
- **Principles** → WHY decisions, philosophy
- **Architecture** → Structure, HOW organized, constraints
- **Patterns** → Non-obvious implementations
- **[Feature/Concern]** → Domain-specific knowledge

**Output:** File organization plan

### Step 5: Create (60 min)

**Goal:** Write files with high-value content

Create in order:

1. **CLAUDE.md** - Routing hints
   ```markdown
   # [Project Name]

   **When:** [Query pattern] → @context/[file.md]
   **When:** [Query pattern] → @context/[file.md]

   [Brief project description]
   ```

2. **principles.md** - Why decisions, design philosophy
3. **architecture.md** - How organized, folder structure
4. **patterns.md** - Non-obvious implementations
5. **[Additional files]** - Feature/concern-specific
6. **inbox.md** - Empty, ready for discoveries

**For each file:**
- Use discovery content
- Apply delta principle (remove inferrable)
- Write densely (fragments, symbols)
- Include constraints (NEVER rules)

### Step 6: Validate (15 min)

**Goal:** Test that routing works

**Validation Checks:**

```
Routing broken?
- Hints too vague? → Make specific
- Test against real queries
- 1 level deep: CLAUDE.md → file only (no chains)

File size problems?
- >250 lines? → Split by domain or concern
- <30 lines? → Merge into parent + add section

Content issues?
- Framework/library basics? → Remove
- Discoverable via ls/grep? → Remove
- Project-specific? → Keep (score 3+ yes)
```

For each routing hint in CLAUDE.md, ask a test query:

```
Query: "Why use [technology]?"
Result: Finds relevant section in principles.md ✓

Query: "How implement [pattern]?"
Result: Finds pattern in patterns.md ✓

Query: "What security constraints?"
Result: Finds rules in architecture.md or security.md ✓
```

If Claude can't find answers → refine routing or files.

### Step 7: Report

Share with team:

```
Memory System Created ✓

Files:
- CLAUDE.md (5 routing hints)
- principles.md (3 decisions)
- architecture.md (structure + constraints)
- patterns.md (3 custom patterns)
- inbox.md (ready for captures)

Test Queries Passed: ✓ All
Coverage: 80% of high-value knowledge

Next: Use Promote workflow for inbox items
```

---

## Template: Quick Bootstrap (Copy-Paste)

Use for <2 hour bootstrap:

### CLAUDE.md
```markdown
# [Project Name]

**When:** How is [system] organized? → @context/architecture.md
**When:** Why use [technology]? → @context/principles.md
**When:** How do I implement [pattern]? → @context/patterns.md

[1-2 sentence description]
```

### principles.md
```markdown
# Principles & Decisions

## Technology Choices

**[Choice 1]:** [Tech chosen over alternative]
**Why:** [Reason 1], [Reason 2]

**[Choice 2]:** [Tech chosen over alternative]
**Why:** [Reason 1], [Reason 2]

## Design Philosophy

**[Philosophy 1]:** [High-level idea]
**Benefit:** [What it enables]
```

### architecture.md
```markdown
# Architecture & Structure

## Folder Organization

[Brief description]

## Module Boundaries

- Module A: [Responsibility]
- Module B: [Responsibility]

## Key Constraints

✓ [Important rule]
✗ [Never do this]
```

### patterns.md
```markdown
# Implementation Patterns

## Pattern 1: [Name]

**When:** [Situation]
**Pattern:** [Code example]

## Pattern 2: [Name]

**When:** [Situation]
**Pattern:** [Code example]
```

### inbox.md
```markdown
# Inbox: Discoveries Pending Promotion

Ready for your first discovery!
```
