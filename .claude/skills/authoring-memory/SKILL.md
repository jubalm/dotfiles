---
name: Authoring Memory
description: Organize project-specific knowledge for Claude Code - facts, decisions, constraints, product logic. Use when building Memory systems, determining what to document, or promoting discoveries to permanent knowledge.
---

# Authoring Memory

**Focused capability:** Organize project-specific facts and constraints so Claude discovers them when needed.

Memory stores WHAT is true about your project. This guide teaches how to structure, write, and maintain Memory that Claude can retrieve and apply.

---

## When to Use This Skill

- Starting a Memory system for a new project
- Deciding what project knowledge to document
- Organizing existing Memory files for discoverability
- Promoting discoveries from inbox to permanent Memory
- Maintaining and auditing Memory quality

---

## Core Principle: Retrieval-Based Organization

Organize Memory by **how Claude will be queried**, not by ideology:

**Query:** "How does auth work?" → Answer in `auth.md`
**Query:** "What are security constraints?" → Answer in `security.md`
**Query:** "Why this architecture?" → Answer in `architecture.md`

**Result:** Claude finds what it needs when it needs it.

---

## Quick Decision Matrix: What to Document?

Score items on 5 criteria (need **3+ yes**):

1. **Would Claude miss?** Not in training or discoverable by inspection
2. **Project-specific?** Not general knowledge or framework basics
3. **Prevent bugs if unknown?** High stakes (security, data loss, reliability)
4. **Save time?** Vs rediscovering through experimentation
5. **Stable?** Not changing soon

**Results:**
- **5 yes** → Essential, document now
- **4 yes** → High priority
- **3 yes** → Add to permanent Memory
- **2 yes** → Inbox (verify later)
- **0-1 yes** → Skip (Claude knows this)

---

## Delta Principle: Only Document Non-Inferrable Knowledge

### Don't Document (Claude Already Knows)
- Framework patterns (React hooks, Django models)
- Library behavior (Stripe, Firebase capabilities)
- Standard architectures (REST, GraphQL, MVC)
- Tech stack (visible in package.json)
- File organization (readable via ls/grep)
- Language syntax and standard libraries

### Do Document (High-Value Deltas)

**Decisions:** Why X over Y
- Technology choices and tradeoffs
- Architecture decisions and constraints
- Cost, performance, scalability implications

**Product Logic:** Unique to your application
- Business rules and access control
- Domain models and relationships
- Feature logic and state management
- Custom patterns

**Hard Constraints:** Rules that prevent bugs
- Security policies (`NEVER` bypass RLS)
- Compliance requirements (GDPR implications)
- Reliability rules (timeouts, retry logic)
- Performance limits (cache this, never load all)

### Delta Examples

```
❌ "We use React" (read package.json)
✓ "React: server components default, 'use client' only for interactivity"

❌ "PostgreSQL database" (see import)
✓ "Postgres: RLS policies enforce multi-tenant, NEVER bypass without audit"

❌ "Git for version control" (standard)
✓ "Git: force-push only feature branches, main always stable"
```

---

## File Organization

### Directory Structure

```
.claude/
├── CLAUDE.md              # Entry point, routing hints
├── context/
│   ├── principles.md      # Design philosophy, WHY decisions
│   ├── architecture.md    # Structure, organization, constraints
│   ├── patterns.md        # Non-obvious implementations, HOW things work
│   ├── [feature].md       # Feature-specific logic
│   ├── [concern].md       # Cross-cutting (security, performance)
│   └── inbox.md           # Staging area for discoveries
└── agents/                # Optional: custom agents
    └── [agent-name].md
```

### File Size Guidelines

- **Ideal:** 50-200 lines per file
- **Too small:** (<30 lines) → Merge into parent file
- **Too large:** (>250 lines) → Split by domain or feature
- **Exception:** Inbox has no size limit (staging area)

### Naming Conventions

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Entry point, routing hints ("When X → @context/Y") |
| `principles.md` | Philosophy, design rationale, WHY decisions |
| `architecture.md` | Structure, organization, HOW it's organized |
| `patterns.md` | Non-obvious implementations, HOW things work |
| `[feature].md` | Feature-specific (auth.md, billing.md) |
| `[concern].md` | Cross-cutting (security.md, testing.md) |
| `inbox.md` | Discoveries pending promotion |

---

## CLAUDE.md: Entry Point with Routing Hints

CLAUDE.md guides Claude to the right Memory files.

**Format:**
```markdown
# [Project Name]

When: [Query pattern] → @context/[file.md]
When: [Query pattern] → @context/[file.md]

[Brief project description]
```

**Example:**
```markdown
# Dotfiles Project

**When:** How does modularity work? → @context/architecture.md
**When:** Why use XDG Base Directory spec? → @context/principles.md
**When:** How does LSP setup work? → @context/patterns.md
**When:** What are valid git scopes? → @context/architecture.md
**When:** Are there brand/consistency guidelines? → @context/principles.md

This is a personal development environment configuration...
```

**Why routing hints matter:** Claude can find relevant Memory files immediately.

---

## Authoring Style: Maximum Density

### Structure Preferences

**Code > prose** - Show patterns in code, not narrative
**Bullets > paragraphs** - One idea per line
**Fragments > sentences** - Remove connecting words

### Use Symbols Over Words

- `✓` / `✗` instead of yes/no
- `→` instead of "leads to"
- `:` instead of "is"

### Density Example

Before (27 words):
> The reason we use the modular approach is because it makes maintenance easier, and it allows developers to understand one concern at a time.

After (8 words):
> Modular: ✓ easier maintenance, ✓ isolated concerns

---

## Memory Lifecycle

### Bootstrap: Starting Fresh

1. **Discover** - Scan codebase, package.json, structure
2. **Interview** - Ask about decisions, product logic, patterns
3. **Score** - Apply decision matrix (3+ yes?)
4. **Structure** - Organize by retrieval patterns
5. **Create** - CLAUDE.md + context files + inbox.md
6. **Report** - Summary with test queries

### Promote: Inbox → Permanent

1. Read inbox → find target item
2. Re-score (still 3+ yes?)
3. Determine destination file
4. Rewrite for efficiency
5. Edit destination file → add item
6. Update inbox: `~~strikethrough~~ (Promoted: YYYY-MM-DD)`

### Capture: Ongoing Discovery

**Proactive:** Monitor for patterns, score silently, suggest promotion

**Explicit:** User requests "add this", score with matrix, add to inbox or permanent file

---

## Quality Checklist

### Bootstrap Quality
- [ ] CLAUDE.md uses relative paths? (`@context/` not `@.claude/context/`)
- [ ] "When" hints clear and specific?
- [ ] No framework/library basics?
- [ ] Structure matches project complexity?
- [ ] File sizes 50-200 lines?

### Ongoing Maintenance
- [ ] Decision matrix applied? (3+ yes)
- [ ] Writing quality checked?
- [ ] Inbox reviewed monthly?
- [ ] Stale content archived?
- [ ] Routing hints updated?

### Promotion Quality
- [ ] Re-scored (still 3+ yes)?
- [ ] Destination file semantically correct?
- [ ] Writing quality applied?
- [ ] Inbox updated with date?

---

## Detailed Guidance

For comprehensive organization patterns:
- See [reference.md](reference.md) for file structures and templates
- See [workflows.md](workflows.md) for bootstrap and maintenance workflows

For framework context:
- Memory stores WHAT (facts, constraints, decisions)
- Skills provide HOW (procedures, workflows)
- Together they enable informed execution

---

## Quick Examples

### Simple Memory: Single conventions.md

Start minimal, grow as needed:

```markdown
# Project Conventions

## Technology Decisions

**Framework:** Next.js (fullstack, better DX than separate frontend)
**Database:** PostgreSQL (open source, battle-tested, RLS support)

## Hard Constraints

- ✗ Never bypass PostgreSQL RLS policies
- ✗ All sensitive data encrypted at rest
- ✓ Cache responses for 5+ minutes when possible
```

### Complex Memory: Multi-file with routing

```
CLAUDE.md (routing hints)
├── principles.md (philosophy)
├── architecture.md (structure, WHY)
├── patterns.md (implementations, HOW)
├── security.md (hard constraints)
├── auth.md (authentication specifics)
└── inbox.md (discoveries pending promotion)
```

---

## Next Steps

1. Create CLAUDE.md with routing hints
2. Score discoveries against decision matrix
3. Create starter files (principles, architecture, patterns)
4. Add high-value deltas (decisions, product logic, constraints)
5. Promote from inbox regularly
6. Audit quarterly for staleness

See [reference.md](reference.md) for complete organization patterns and [workflows.md](workflows.md) for bootstrap, promotion, and maintenance workflows.
