---
name: claude-code-memory
description: Manage Claude Code project memory with auto-loaded constraints, quirks, decisions, and conventions. Capture project-specific knowledge through natural conversation, use inbox for uncertainties, and audit memory for quality and conflicts.
---

# Claude Code Memory Management

This skill provides a structured system for capturing and organizing project-specific knowledge that enhances Claude's ability to assist with Claude Code tasks.

## Why Memory Matters

Every context window token is precious. This memory system ensures that:

- **Project-specific knowledge is always available** - Captured once, auto-loaded into every conversation
- **Baseline Claude knowledge is never duplicated** - Only store what Claude doesn't already know
- **Uncertainties are staged, not stored** - Inbox prevents polluting memory with unconfirmed information
- **Memory stays lean** - Auditing detects bloat and staleness

## Core Principle

**Memory complements Claude's baseline knowledge, not duplicates it.** Every token in memory is auto-loaded into context, so maximum information density is critical.

## Memory Structure

The memory system lives in `.claude/memory/` and auto-loads via `CLAUDE.md`:

```
.claude/
├── CLAUDE.md (imports memory files)
└── memory/
    ├── constraints.md (API limits, platform restrictions, budgets)
    ├── quirks.md (non-standard behaviors, workarounds)
    ├── decisions.md (architectural choices with rationale)
    ├── conventions.md (team standards, skill usage patterns)
    └── inbox/
        └── [individual items] (on-demand only, not auto-loaded)
```

## Getting Started

### Initialize Memory

Trigger Claude with natural language:

- "Set up memory for this project"
- "Initialize project memory"
- "Let's start tracking project knowledge"

Claude will:
1. Create the `.claude/` directory structure
2. Explore your codebase to find project-specific patterns
3. Populate memory files with findings
4. Confirm with a summary

### Capture During Development

As you work, use natural language triggers:

- "Remember this: We use .env.production for all environments"
- "Save this for next time: Auth API has 100 req/min limit"
- "I notice you keep [problem]. Remember [solution]"

Claude detects intent, classifies the entry, checks token efficiency, and adds it automatically.

### Manage Uncertainties with Inbox

When you have gut feelings or need to defer investigation:

- "Remind me to review the auth logic, something feels off"
- "This works but seems fragile - review later"
- "May be an issue with X, check next time"

Claude creates an **inbox item** - a separate file that loads only when you need it.

Later, when the issue is confirmed:

- "That auth thing - it's a race condition. Save it."

Claude promotes the item from inbox to active memory.

### Review and Audit

- **"What's in the inbox?"** - See all pending items
- **"Show inbox item 1"** - Load full content selectively
- **"Audit the memory"** - Check for bloat, generic knowledge, conflicts

## Memory Types

### constraints.md
**Business and technical limitations** that affect implementation.

```markdown
## API Rate Limit
Auth API: 100 req/min → 503 errors. Batch or cache requests.

## Database Pool
Max 50 concurrent connections. Use HikariCP with queueTimeout=30s
```

Target: Deviations from defaults, external limits, legal/compliance requirements.

### quirks.md
**Non-standard behaviors and workarounds** specific to your project.

```markdown
## Config Files
Use .env.production (not .env.local) for all environments

## Async in Legacy Build
Breaks IE11 - use promises instead of async/await
```

Target: "This works differently than expected", platform-specific workarounds, custom configurations.

### decisions.md
**Architectural choices with rationale** - why you chose X over Y.

```markdown
## Monorepo Architecture
Chose monorepo for faster local dev, despite slower CI builds

## PostgreSQL Database
Selected for scalability and JSON support
```

Target: Tech stack choices, design pattern selections, significant trade-offs made.

### conventions.md
**Team standards and project-specific practices** that aren't obvious.

```markdown
## UI Components
Always use shadcn-ui skill for components

## Git Workflow
Use feature branches with feat/*, fix/*, docs/* prefixes
```

Target: Skill usage patterns, naming conventions, workflow standards (only if non-obvious).

## Entry Format

Keep entries concise and scannable:

```markdown
## [Topic]
[Single-line description with key detail]
[Optional second line for critical context only]
```

**Token target:** < 25 tokens per entry (roughly < 100 characters)

### Verbose Example (❌ ~60 tokens)

```markdown
## API Timeout Issues
**Problem:** When making requests to the authentication API, we discovered 
through testing that after approximately 100 requests, the API begins timing 
out and returning 503 errors.
**Solution:** We need to implement request batching.
```

### Concise Example (✓ ~15 tokens)

```markdown
## API Rate Limit
Auth API: 100 req/min limit → 503 errors. Batch or cache requests.
```

## What NOT to Capture

**✗ Generic best practices** (Claude already knows):

- "Use TypeScript for type safety"
- "Write unit tests"
- "Handle errors properly"

**✓ Project-specific deviations**:

- "TypeScript strict mode breaks legacy auth module - use loose"
- "E2E tests timeout in CI at 10s - set to 30s"
- "Auth errors must be sanitized - never expose internals"

## Inbox Workflow

The inbox is a **staging area for uncertainties** - items that need investigation or confirmation before becoming memory.

### Create Inbox Item

Natural language trigger:

```
"Something feels off about the auth logic. Remind me to review it."
```

Claude creates a separate `.md` file in `inbox/` with:
- Your note and context
- Space for investigation notes
- Metadata (priority, type, date)

### Review Inbox

```
"What's in the inbox?"
```

Claude lists all items with priority and type. Select items to load:

```
"Show inbox item 1"
```

Only that item loads into context - efficient selective loading.

### Promote to Memory

Once investigation is complete:

```
"The auth thing - it's a race condition in token refresh. Save it."
```

Claude:
1. Reads the full inbox item context
2. Formulates a concise memory entry
3. Adds to appropriate memory file
4. Archives the inbox file

## Audit Memory

Periodically check memory health:

```
"Audit the memory"
```

Claude reports:
- **Token efficiency** - Average tokens per entry
- **Generic knowledge** - Entries that seem like defaults
- **Conflicts** - Contradictory entries
- **Staleness** - Entries older than 6 months
- **Redundancy** - Duplicate information

## Writing Guidelines

Refer to `references/writing_guidelines.md` for detailed patterns and examples.

Key principles:

1. **Concise first** - Target < 25 tokens per entry
2. **Project-specific only** - No generic best practices
3. **Clear topic** - Use consistent naming
4. **One concern** - One entry, one idea

## Success Metrics

A healthy memory system has:

- **< 50 entries per file** initially
- **< 25 tokens per entry** average
- **< 10% generic knowledge** entries
- **All entries < 6 months old**

## Quick Reference

For common workflows and memory types, see `references/quick_reference.md`.

## Scripts Available

Claude invokes these helper scripts (no manual setup needed):

- `init_memory.py` - Create directory structure
- `add_entry.py` - Add memory entry
- `inbox_add.py` - Create inbox item
- `inbox_list.py` - List inbox items
- `inbox_show.py` - Display inbox item
- `inbox_promote.py` - Move item to memory
- `audit_memory.py` - Analyze memory quality

All scripts output JSON for Claude to parse and present naturally.

## Running Scripts in Claude Code

To execute scripts, use:

```bash
python scripts/init_memory.py .
python scripts/add_entry.py <type> <entry_text>
python scripts/inbox_add.py <title> <note>
python scripts/inbox_list.py
python scripts/inbox_show.py <item_id>
python scripts/inbox_promote.py <item_id> <type> <entry_text>
python scripts/audit_memory.py
```

**Key workflows:**

**Initialize memory:**
```bash
python scripts/init_memory.py .
```

**Add entry (constraint/quirk/decision/convention):**
```bash
python scripts/add_entry.py constraints "API: 100 req/min limit"
```

**Create inbox item:**
```bash
python scripts/inbox_add.py "Review auth" "Something feels off"
```

**List inbox:**
```bash
python scripts/inbox_list.py
```

**Show inbox item:**
```bash
python scripts/inbox_show.py review-auth
```

**Promote from inbox to memory:**
```bash
python scripts/inbox_promote.py review-auth quirks "Auth: Race condition in token refresh"
```

**Audit memory:**
```bash
python scripts/audit_memory.py
```
