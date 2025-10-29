---
name: claude-code-memory
description: Manage project-specific knowledge for Claude Code by organizing constraints, quirks, decisions, and conventions into auto-loaded memory files and an on-demand inbox system. Use for initializing memory in new projects, capturing knowledge naturally during work, auditing memory for quality, and managing uncertainties.
---

# Claude Code Memory

This skill helps you build and maintain a structured knowledge system for your project. Every token in memory is auto-loaded into Claude's context, so **memory must complement baseline knowledge, not duplicate it**.

Memory captures only project-specific patterns—not generic best practices Claude already knows.

## Memory Architecture

Memory lives in `.claude/` with two layers:

### Active Memory (Auto-loaded)
Four concise files imported via `CLAUDE.md`, always in context:

1. **constraints.md** - Business/technical limitations (API rate limits, platform restrictions, budget/performance constraints)
2. **quirks.md** - Non-standard behaviors (unusual configurations, workarounds, deviations from framework defaults)
3. **decisions.md** - Architectural choices with rationale (why we chose X over Y, tech stack selections)
4. **conventions.md** - Team standards that are non-obvious (custom workflows, project-specific naming patterns)

### Inbox (On-demand)
`.claude/memory/inbox/` contains individual `.md` files for uncertainties, deferred questions, and investigations. Load only what you need into context.

**Key benefit:** Inbox isolates verbose discussions without polluting active memory.

## Workflows

### Initialize Memory

**User intent:** "Set up memory for this project" or "Initialize project memory"

**Process:**
1. Create `.claude/` directory structure
2. Create CLAUDE.md with imports: `@memory/constraints.md`, `@memory/quirks.md`, `@memory/decisions.md`, `@memory/conventions.md`
3. Create empty memory files and inbox directory
4. Analyze codebase with Explore sub-agent
5. Extract project-specific findings and populate memory files with concise entries
6. Confirm with summary

**Output:**
```
[OK] Memory system initialized at .claude/
[OK] Analyzed codebase with Explore
[OK] Captured findings:
  - 3 constraints (API limits, platform requirements)
  - 5 quirks (custom build process, DB setup)
  - 2 decisions (PostgreSQL choice, monorepo structure)
  - 4 conventions (git workflow, test patterns)
```

### Natural Capture

**User intent:** "Remember this...", "Save this for next time", "Don't forget that...", "This would be useful team knowledge"

**Process:**
1. Detect intent and classify: constraint/quirk/decision/convention
2. Write concise entry (target: <30 tokens, max 50 tokens)
3. Append to appropriate memory file
4. Confirm to user

**Example:**
- **User:** "We use `.env.production` for all environments, not `.env.local`"
- **Claude writes:** Add to quirks.md: `## Config File` + `Use .env.production (not .env.local) for all environments`
- **Confirms:** "Added to quirks.md"

### Inbox Capture (Uncertainties)

**User intent:** "Remind me to review X, something feels off", "This works but I want to check later", uncertain language ("might be", "not sure", "possibly")

**Process:**
1. Create individual `.md` file in inbox/ with YAML frontmatter
2. Include: id, type, title, priority, status, date, added_by
3. Add observation, context, discussion (can be lengthy)
4. Confirm to user: "Added to inbox"

**Entry format:**
```markdown
---
id: review-auth-logic
type: intuition
title: Review auth logic
priority: medium
status: pending
added_by: user
date: 2025-10-29
---

# Review auth logic

**Note:** User gut feeling - something feels off

**Context:** Recent refactor of token handling, all tests pass

## Background
[Discussion, code snippets, investigation notes]
```

### Inbox Review

**User intent:** "What's in the inbox?", "Show inbox", "Check if we noted X"

**Process:**
1. List `.claude/memory/inbox/` directory
2. Read frontmatter from each file
3. Show summary with id, priority, title
4. Wait for user selection

**Example output:**
```
Inbox (3 items):
1. [Medium] Review auth logic - gut feeling
   File: review-auth-logic.md
2. [Low] Payment flow feels fragile - passing tests
   File: payment-flow-check.md
3. Config confusion - needs clarification
   File: config-confusion.md

Type: "show inbox item 1" or "tackle #1"
```

User picks one → Claude loads full `.md` into context with discussion, code, notes.

**Token efficiency:** Only load the selected item, not all inbox files.

### Inbox Promotion

**User intent:** "The auth thing—it's a race condition. Save it.", "Config issue resolved—use .env.production"

**Process:**
1. Read full inbox item content
2. Write concise entry to appropriate memory file (e.g., "Auth: Token refresh needs mutex lock (race condition)")
3. Archive/remove from inbox
4. Confirm: "Promoted to quirks.md"

### Skill Usage as Convention

**User intent:** "Use the docx skill for all reports", "Always use shadcn-ui skill for components"

**Process:**
1. Recognize skill usage pattern
2. Write to conventions.md: "UI Components: Always use shadcn-ui skill"
3. Confirm: "Added to conventions.md"

### Memory Audit

**User intent:** "Audit the memory", "Check for bloat", "Any conflicts in memory?"

**Process:**
1. Read all memory files (constraints.md, quirks.md, decisions.md, conventions.md)
2. Analyze each entry for:
   - **Token count** per entry (target: <25 tokens)
   - **Generic knowledge patterns** (entries Claude should already know)
   - **Staleness** (entries >6 months old)
   - **Conflicts** (contradictory entries)
   - **Redundancy** (duplicate information)
3. Report findings with line numbers and suggestions

**Example report:**
```
Memory Audit Report
===================

[OK] Token Efficiency: 18 tokens/entry avg (Target: <25)
[WARN] Generic Knowledge: 2 entries flagged
[OK] No Conflicts
[OK] Freshness: All <6 months

Flagged for Review:
1. constraints.md line 5: "Use TypeScript for type safety"
   → Generic best practice, not project-specific
   → Suggest: Remove

2. conventions.md line 12: "Write tests before deploying"
   → Universal practice
   → Suggest: Remove
```

## Entry Guidelines

### Token Efficiency Rules

**Verbose (❌ ~60 tokens):**
```markdown
## API Timeout Issues
When making requests to the authentication API, we discovered that after 100 requests, 
the API times out and returns 503 errors. We need to implement batching or caching.
```

**Concise (✅ ~15 tokens):**
```markdown
## API Rate Limit
Auth API: 100 req/min → 503 errors. Batch or cache requests.
```

### Entry Format

```markdown
## [Topic]
[Single-line description with key constraint/quirk/decision]
[Optional second line for critical context only]

---
```

### What NOT to Capture

❌ Generic knowledge Claude already knows:
- "Use TypeScript for type safety"
- "Write unit tests"
- "Use git for version control"

✅ Project-specific only:
- "TypeScript strict mode breaks legacy auth—use loose"
- "E2E tests timeout in CI at 10s—set to 30s in jest.config"
- "Use feature branches, deploy via tag push to v/*"
- "Auth errors must be sanitized—never expose internal details"

## File Structure

```
.claude/
├── CLAUDE.md
│   @memory/constraints.md
│   @memory/quirks.md
│   @memory/decisions.md
│   @memory/conventions.md
│
└── memory/
    ├── constraints.md        (auto-loaded)
    ├── quirks.md             (auto-loaded)
    ├── decisions.md          (auto-loaded)
    ├── conventions.md        (auto-loaded)
    └── inbox/                (on-demand only)
        ├── item-1.md
        ├── item-2.md
        └── item-3.md
```

## Success Metrics

- **Memory size:** <50 entries per file
- **Token efficiency:** <25 tokens per entry average
- **Generic knowledge:** <10% of entries flagged during audit
- **Staleness:** All entries <6 months old
- **Friction:** Zero—capture via natural conversation

## Anti-patterns to Avoid

❌ **Verbose entries** - "The problem we encountered was..."  
✅ Use: "Problem X → Solution Y"

❌ **Generic knowledge** - "Use async/await for promises"  
✅ Use: "Async breaks in legacy IE11 build—use promises"

❌ **Manual processes** - User must edit files directly  
✅ Use: Natural language triggers

❌ **Immediate promotion** - Uncertainty → memory directly  
✅ Use: Uncertainty → inbox → confirmed → memory

❌ **No auditing** - Let bloat accumulate  
✅ Use: Regular audits with automated suggestions
