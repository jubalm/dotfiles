# Memory Organization: Complete Reference

Detailed patterns, templates, and organization strategies for Memory systems.

---

## File Organization Patterns

### Starter Structure (Simple Projects)

```
.claude/
├── CLAUDE.md
└── context/
    ├── conventions.md (decisions, patterns, constraints)
    └── inbox.md (discoveries pending promotion)
```

**When to use:** Small projects, few custom patterns, straightforward domain

**Example:**
```markdown
# CLAUDE.md

**When:** What are the project constraints? → @context/conventions.md
**When:** What should I learn about this project? → @context/conventions.md

This is a personal todo application...
```

### Moderate Structure (Growing Projects)

```
.claude/
├── CLAUDE.md (routing)
├── context/
│   ├── principles.md (WHY decisions)
│   ├── architecture.md (HOW organized)
│   ├── conventions.md (WHAT rules)
│   └── inbox.md (staging)
```

**When to use:** Multiple concerns, significant custom patterns, evolving domain

**Example routing:**
```markdown
**When:** Why use this technology? → @context/principles.md
**When:** How is the system organized? → @context/architecture.md
**When:** What constraints apply? → @context/conventions.md
```

### Complex Structure (Multi-Domain Projects)

```
.claude/
├── CLAUDE.md (navigation)
└── context/
    ├── principles.md
    ├── architecture.md
    ├── backend.md (domain 1)
    ├── frontend.md (domain 2)
    ├── security.md (cross-cutting)
    ├── performance.md (cross-cutting)
    └── inbox.md
```

**When to use:** Large teams, multiple domains, complex constraints

**Example:**
```
When: Backend structure? → @context/backend.md
When: Frontend architecture? → @context/frontend.md
When: Security constraints? → @context/security.md
```

---

## Decision Matrix Detailed

### Complete Scoring Method

Score each discovery on 5 criteria:

| Criterion | Question | Score |
|-----------|----------|-------|
| **Would Claude miss?** | Not in training or discoverable by inspection? | YES = 1 |
| **Project-specific?** | Not general knowledge or framework basics? | YES = 1 |
| **Prevent bugs?** | High stakes if unknown (security, data loss)? | YES = 1 |
| **Save time?** | Rediscovery via experimentation is wasteful? | YES = 1 |
| **Stable?** | Not changing soon, durable knowledge? | YES = 1 |

**Scoring results:**
- **5 yes** → Essential, add immediately
- **4 yes** → High priority, add this week
- **3 yes** → Add to permanent docs or inbox
- **2 yes** → Inbox (verify later)
- **0-1 yes** → Skip (Claude already knows)

### Example: Scoring a Discovery

**Discovery:** "We use PostgreSQL RLS policies to enforce multi-tenancy"

| Criterion | Assessment | Score |
|-----------|-----------|-------|
| Would Claude miss? | Yes, not obvious from code | 1 |
| Project-specific? | Yes, unique to our architecture | 1 |
| Prevent bugs? | **YES** - bypassing causes data leaks | 1 |
| Save time? | Yes, avoids trial-and-error | 1 |
| Stable? | Yes, core architectural choice | 1 |

**Total: 5 yes → Essential, document immediately**

**Another example:** "We use React for the frontend"

| Criterion | Assessment | Score |
|-----------|-----------|-------|
| Would Claude miss? | No, visible in package.json | 0 |
| Project-specific? | No, general knowledge | 0 |
| Prevent bugs? | No, standard framework | 0 |
| Save time? | No, discoverable by inspection | 0 |
| Stable? | Maybe, but doesn't matter | 0 |

**Total: 0 yes → Skip, Claude already knows**

---

## Writing Templates

### Decision Section

```markdown
## [Decision Name]

**Context:** [Brief situation that prompted decision]

**Decision:** [X chosen over Y]

**Why:**
- [Reason 1 - avoids what problem?]
- [Reason 2 - enables what benefit?]
- [Tradeoff if applicable]

**Constraint:** [Hard rule to follow this decision]
```

**Example:**
```markdown
## PostgreSQL for Relational Data

**Context:** Needed database supporting multi-tenancy with strong consistency guarantees

**Decision:** PostgreSQL with RLS policies, not MongoDB

**Why:**
- ✓ RLS native (vs application-level auth, error-prone)
- ✓ Strong consistency (vs eventual consistency issues)
- ✗ Tradeoff: Less flexible schema (better for contracts)

**Constraint:** ✗ NEVER bypass RLS policies without audit trail
```

### Pattern Section

```markdown
## [Pattern Name]

**When:** [Situation where this applies]

**Pattern:**
[Code example - minimal and concrete]

**Why differ from default:**
[How this differs from framework standard]

**Important:**
- [Gotchas or limits]
- [Performance implications]
```

**Example:**
```markdown
## LSP Configuration

**When:** Setting up language server protocols for editors

**Pattern:**
```lua
vim.lsp.config('*', {
  -- Global config for all servers
})

vim.lsp.config('lua_ls', {
  -- Specific overrides
})
```

**Why differ:** Modern `vim.lsp.config()` API (Neovim 0.10+)

**Important:**
- ✓ Global config prevents repetition
- ✗ Don't scatter overrides across files
```

### Rule Section

```markdown
## [Security/Performance/Reliability Rule]

**Rule:** [Constraint in plain language]

✓ Do this
✗ Never do this

**Impact:** [Concrete consequences if violated]
```

**Example:**
```markdown
## RLS Policy Enforcement

**Rule:** All database queries must respect PostgreSQL RLS policies

✓ Rely on RLS for row-level access control
✓ Use authenticated roles for all connections
✗ Never bypass RLS with SUPERUSER connections
✗ Never write application-level row filtering

**Impact:** Bypassing RLS causes data leaks across tenants
```

---

## Delta Principle Examples

### Authentication

**Don't document:**
```
❌ "We use JWT for authentication"
(Visible in imports, standard approach)
```

**Do document:**
```
✓ "JWT tokens: 1-hour access, 7-day refresh"
✓ "Refresh tokens stored in httpOnly cookies, ✗ never in localStorage"
✓ "Admin override: requires email + SMS confirmation"
(Project-specific, prevents bugs if wrong)
```

### Caching

**Don't document:**
```
❌ "We cache frequently accessed data"
(Standard practice, obvious from code)
```

**Do document:**
```
✓ "Cache expiration: 5min for user data, 1hour for config"
✓ "Cache invalidation: on update OR 1hour max-age, whichever first"
✓ "✗ Never cache PII longer than 5min"
(Specific constraints, prevents stale security issues)
```

### File Organization

**Don't document:**
```
❌ "We organize code by feature"
(Visible from file structure)
```

**Do document:**
```
✓ "Feature folder structure: components/, hooks/, utils/, types/"
✓ "✗ Never import across features (use shared/ for bridges)"
✓ "Feature coupling detected: feature-A imports feature-B/components"
(Project-specific pattern that prevents spaghetti)
```

---

## Density Principles: Maximum Signal per Token

### Write in Fragments, Not Sentences

**Before (narrative, 40 tokens):**
> The reason we chose Next.js is because it provides both server-side and client-side rendering capabilities in a single framework, which reduces the complexity of managing multiple systems and allows developers to reason about the entire application more easily.

**After (fragments, 12 tokens):**
> Next.js: ✓ SSR/CSR unified, ✓ simpler mental model

### Use Symbols

Replace common phrases:
- `✓` / `✗` instead of yes/no, do/don't
- `→` instead of leads to, results in
- `:` instead of is, means
- `±` instead of approximately

### Structure Code Over Prose

**Before (prose explanation):**
```markdown
When a user creates a new account, they provide an email and password.
The email is validated to ensure it follows standard format rules.
The password is hashed using bcrypt with a salt of 10 rounds.
The hashed password is stored in the database...
```

**After (code pattern):**
```javascript
// Account creation
email → validate format → stored
password → bcrypt (salt: 10) → stored
↓
User can login within 24 hours or account expires
```

---

## Routing Hints in CLAUDE.md

Good routing helps Claude find Memory immediately.

### Explicit Query-to-File Mapping

**Format:**
```markdown
**When:** [Query pattern] → @context/[file.md]
```

**Examples:**
```markdown
**When:** What's the project philosophy? → @context/principles.md
**When:** How is the system organized? → @context/architecture.md
**When:** How do I implement [feature]? → @context/patterns.md
**When:** What are security constraints? → @context/security.md
```

### Organizing Routing Hints

Group by concern:

```markdown
# Architecture Questions
**When:** How is [system/component] organized? → @context/architecture.md
**When:** What's the folder structure? → @context/architecture.md

# Constraint Questions
**When:** What security rules apply? → @context/security.md
**When:** What performance limits exist? → @context/performance.md

# Implementation Questions
**When:** How do I implement [pattern]? → @context/patterns.md
```

---

## File Size Guidelines

| Scope | Ideal Range | Too Small | Too Large |
|-------|-----------|-----------|-----------|
| CLAUDE.md | 20-50 lines | - | >100 lines, split routing |
| principles.md | 80-150 | <50 | >200, split by domain |
| architecture.md | 100-200 | <50 | >250, split by concern |
| patterns.md | 100-200 | <50 | >250, split by pattern |
| [feature].md | 50-150 | <30 (merge) | >200 (split) |
| inbox.md | Unlimited | - | - |

**Why these ranges:**
- Too small = overhead of separate file, harder to find patterns
- Too large = context bloat, hard to navigate
- Inbox exception = staging area, no need to split

---

## Quality Audit Checklist

### Before Finalizing Memory

Content Quality:
- [ ] Decision matrix applied? (3+ yes)
- [ ] No framework/library basics?
- [ ] No standard patterns (REST, CRUD)?
- [ ] Delta principle followed?
- [ ] Every line adds unique value?

Organization:
- [ ] File sizes 50-200 lines?
- [ ] Semantic clustering (related ideas together)?
- [ ] Clear naming (filename describes content)?
- [ ] Routing hints in CLAUDE.md?
- [ ] One level of reference depth?

Writing:
- [ ] Dense, not verbose? (fragments > sentences)
- [ ] Uses symbols (✓/✗/→)?
- [ ] Code examples where helpful?
- [ ] Constraint-focused (NEVER vs. nice-to-have)?
- [ ] Consistent terminology?

---

## Common Pitfalls

### Over-Documentation

Don't include:
- ✗ Framework tutorials
- ✗ Library API docs (link to official instead)
- ✗ Standard patterns (REST, MVC, CRUD)
- ✗ Language features
- ✗ File listings (ls output)

### Wrong Granularity

- **Too vague:** "Auth happens" (not actionable)
- **Too specific:** Every implementation detail (becomes dead weight)
- **Right:** High-level constraints + key patterns (survives refactors)

### Stale Content

- [ ] Review quarterly for outdated patterns
- [ ] Archive decisions that changed
- [ ] Update when refactors shift architecture
- [ ] Mark explicitly: "Changed: YYYY-MM-DD"

---

## Next Steps

1. Create CLAUDE.md with routing hints
2. Score discoveries against decision matrix
3. Create starter files
4. Add high-value deltas from your project
5. Use [workflows.md](workflows.md) for bootstrap and promotion

Start small (conventions.md only), grow as you discover patterns.
