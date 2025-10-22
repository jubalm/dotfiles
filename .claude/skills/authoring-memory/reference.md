# Reference: Templates, Examples, Patterns

---

## Decision Matrix: Detailed Scoring

Score each discovery on 5 criteria:

| Criterion | Question | Score if YES |
|-----------|----------|--------------|
| **Would Claude miss?** | Not in training or discoverable via inspection? | 1 |
| **Project-specific?** | Not general knowledge or framework basics? | 1 |
| **Prevent bugs?** | High stakes if unknown (security, data loss, reliability)? | 1 |
| **Save time?** | Rediscovery via experimentation is wasteful? | 1 |
| **Stable?** | Durable knowledge, not changing soon? | 1 |

**Scoring:**
- 5 yes → Essential, add immediately
- 4 yes → High priority
- 3 yes → Add to permanent or inbox
- 2 yes → Inbox (verify later)
- 0-1 yes → Skip (Claude already knows)

### Example: RLS Policy Constraint

| Criterion | Assessment | Score |
|-----------|-----------|-------|
| Would Claude miss? | Yes, not obvious from code | 1 |
| Project-specific? | Yes, unique to our architecture | 1 |
| Prevent bugs? | **YES** - bypassing causes data leaks | 1 |
| Save time? | Yes, avoids trial-and-error | 1 |
| Stable? | Yes, core architectural choice | 1 |

**Total: 5 yes → Essential, document now**

### Example: "We use React"

| Criterion | Assessment | Score |
|-----------|-----------|-------|
| Would Claude miss? | No, visible in package.json | 0 |
| Project-specific? | No, general knowledge | 0 |
| Prevent bugs? | No, standard framework | 0 |
| Save time? | No, discoverable | 0 |
| Stable? | Irrelevant | 0 |

**Total: 0 yes → Skip**

---

## File Organization Patterns

### Pattern 1: Starter (Simple Projects)

```
.claude/
├── CLAUDE.md
└── context/
    ├── conventions.md    # Single file: all decisions + patterns + constraints
    └── inbox.md
```

**When:** Small team, 1-2 domains, straightforward logic

**conventions.md structure:**
```markdown
# Project Conventions

## Technology Decisions
- Framework: [choice + why]
- Database: [choice + why]

## Custom Patterns
- Pattern 1: [description + when to use]
- Pattern 2: [description + when to use]

## Hard Constraints
- ✗ Never [rule 1] (consequences)
- ✗ Never [rule 2] (consequences)
```

### Pattern 2: Growing Projects

```
.claude/
├── CLAUDE.md
└── context/
    ├── principles.md    # WHY decisions, philosophy
    ├── architecture.md  # HOW organized, structure
    ├── patterns.md      # Implementation patterns
    └── inbox.md
```

**When:** Multiple domains, evolving architecture, team growing

**principles.md:** Technology choices, design philosophy, tradeoffs
**architecture.md:** Folder structure, module boundaries, constraints
**patterns.md:** Custom implementations, workflows

### Pattern 3: Complex Projects

```
.claude/
├── CLAUDE.md
└── context/
    ├── principles.md
    ├── architecture.md
    ├── backend.md       # Domain-specific knowledge
    ├── frontend.md      # Domain-specific knowledge
    ├── security.md      # Cross-cutting concern
    ├── testing.md       # Cross-cutting concern
    └── inbox.md
```

**When:** Multiple teams, multiple domains, complex constraints

---

## Delta Principle by Domain

**Core idea:** Document what Claude CANNOT infer.

### Authentication

❌ Don't: "We use JWT"
✓ Do: "JWT: 1h access, 7d refresh. Refresh stored in httpOnly cookie, never localStorage. Admin override: email + SMS confirmation."

### Caching

❌ Don't: "We cache frequently accessed data"
✓ Do: "Cache: 5min for user data, 1h for config. Invalidate on update OR max-age, whichever first. Never cache PII >5min."

### File Organization

❌ Don't: "We organize by feature"
✓ Do: "Feature structure: components/, hooks/, utils/, types/. Never import across features (use shared/ bridge). Feature coupling detected = refactor."

### API Design

❌ Don't: "We use REST APIs"
✓ Do: "Endpoints: GET /items (list), POST /items (create), PATCH /items/:id (update). Always paginate lists (default 50, max 500). Errors: standard HTTP codes + JSON {error, details}."

### State Management

❌ Don't: "We manage state with Redux"
✓ Do: "Redux: Single source of truth. Selectors for computed state (no recompute). Async: redux-thunk. Never mutate state directly."

### Database

❌ Don't: "We use PostgreSQL"
✓ Do: "Postgres with RLS for multi-tenancy. NEVER bypass RLS. Migrations: immutable, only add. Indexes on foreign keys. Connections pooled: 10 per instance."

---

## Writing Templates

### Decision Section

```markdown
## [Decision Name]

**Context:** [Situation that prompted decision]

**Decision:** [X chosen over Y]

**Why:**
- [Reason 1 - avoids what problem?]
- [Reason 2 - enables what benefit?]
- Tradeoff: [if applicable]

**Constraint:** [Hard rule to follow this decision]
```

**Example:**
```markdown
## PostgreSQL for Relational Data

**Context:** Needed database supporting multi-tenancy with strong consistency

**Decision:** PostgreSQL with RLS policies, not MongoDB

**Why:**
- RLS native (vs application-level auth, error-prone)
- Strong consistency (vs eventual consistency issues)
- Transactional guarantees (vs document-level isolation)

**Constraint:** ✗ NEVER bypass RLS policies without audit trail
```

### Pattern Section

```markdown
## [Pattern Name]

**When:** [Situation where pattern applies]

**Pattern:**
[Code example - minimal and concrete]

**Why differ from default:**
[How this differs from framework/library standard]

**Important:**
- [Gotcha 1]
- [Performance implication]
- [Common mistake]
```

**Example:**
```markdown
## Server Components by Default

**When:** Building Next.js app components

**Pattern:**
```typescript
// Default: Server component
export default function Page() { ... }

// Explicit client: only for interactivity
'use client'
export default function Button() { ... }
```

**Why differ:** Next.js 13+ prefers server components

**Important:**
- ✓ Server components reduce bundle size
- ✗ Don't add 'use client' unnecessarily
- Watch for hidden client-side state in parent components
```

---

## Code in Memory: The Drift Problem

Static code becomes stale. Constraints survive refactors.

**Drift triggers:**
- Implementation details change (refactoring)
- Library APIs update
- Team preferences shift (old → new)
- Code review catches abandoned patterns

**Strategy: Constraints > Code**

| ❌ Don't | ✓ Do |
|---------|------|
| Copy-paste exact code | Document the NEVER rule |
| Implementation-level details | Link to real code location |
| Line-by-line code examples | Use pseudocode + constraint |
| Field names, class structure | Business logic flows |

**Why:** "Use a validator" stays true after refactor. Copy-paste regex becomes stale.

**Decision matrix - Include code only if:**
- Documents a constraint (NEVER rule)? → YES
- Code will survive refactor? → Link to actual code
- Common mistake to show? → Show wrong + right
- Explains WHY? → Include with commentary
- Exact syntax is the value? → NO (usually just principle)

**See also:** [Code guidance](workflows.md#problem-code-examples-become-outdated-code-memory-drift)

### Constraint Section

```markdown
## [Constraint Name]

**Rule:** [What to do/not do in plain language]

✓ Do this
✗ Never do this

**Impact:** [Concrete consequences if violated]
```

**Example:**
```markdown
## Row-Level Security (RLS)

**Rule:** All database queries must respect PostgreSQL RLS policies

✓ Rely on RLS for access control
✓ Use authenticated roles for all connections
✗ Never bypass with SUPERUSER connections
✗ Never write application-level row filtering

**Impact:** Bypassing RLS = data leaks across tenants (critical security)
```

---

## Density Guide

### Principle 1: Fragments > Sentences

**Before (narrative, ~40 tokens):**
```
The reason we chose Next.js is because it provides both server-side
and client-side rendering capabilities in a single framework, which
reduces the complexity of managing multiple systems.
```

**After (fragments, ~12 tokens):**
```
Next.js: ✓ SSR/CSR unified, ✓ simpler mental model
```

### Principle 2: Use Symbols

Replace common phrases:
- `✓` / `✗` instead of yes/no, do/don't
- `→` instead of leads to, results in
- `:` instead of is, means
- `±` for approximately, variance

**Before:**
```
If the user is an admin and they have permission to delete the resource,
then they can delete it.
```

**After:**
```
Admin + permission → can delete
```

### Principle 3: Code > Prose

**Before (explanation):**
```
When a user creates an account, they provide an email and password.
The email is validated. The password is hashed with bcrypt (salt 10).
Both are stored in the database.
```

**After (code pattern):**
```
Account creation:
email → validate format → stored
password → bcrypt (salt: 10) → stored
↓
User can login for 24h or account expires
```

---

## Anti-Patterns: What NOT to Document

| ❌ Skip | Why | ✓ Document Instead |
|--------|-----|------------------|
| "We use React hooks" | Framework basics | Your custom hooks/patterns |
| "MVC architecture" | Standard pattern | Your implementation differences |
| "src/ contains code" | Discoverable via ls | Non-obvious structure rules |
| "Firebase features" | Library docs | Your usage patterns + constraints |
| "Spread operator" | Language fundamentals | Custom syntax/patterns |
| "Line-by-line code" | Implementation noise | High-level constraints |

### ⚠️ Borderline Cases

✓ Custom validation rules | YES (project-specific)
✓ Performance tuning applied | YES (non-obvious)
✓ Error handling strategy | YES (project-specific)
✗ Standard validation | NO (framework handles)
✗ Performance concepts | NO (general knowledge)
✗ Try/catch syntax | NO (language feature)

---

## Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| **Over-documentation** | Bloated with noise | Every line → "Why X over Y?" (else remove) |
| **Wrong granularity** | Too vague OR too specific | Would refactor change it? If yes → too specific |
| **Stale content** | Outdated decisions remain | Quarterly review. Mark: "Changed: YYYY-MM-DD" |
| **Poor routing** | Claude can't find answers | CLAUDE.md → file (1 level, not chains) |
| **Code drift** | Copy-paste code becomes obsolete | Use constraints + link to real code |

---

## File Size Guidelines

| File | Ideal | Too small | Too large |
|------|-------|-----------|-----------|
| CLAUDE.md | 20-50 lines | - | >100 lines |
| principles.md | 80-150 | <50 | >200 |
| architecture.md | 100-200 | <50 | >250 |
| patterns.md | 100-200 | <50 | >250 |
| [feature].md | 50-150 | <30 | >200 |
| inbox.md | Unlimited | - | - |

**Why:**
- Too small = overhead, harder to find patterns
- Too large = context bloat, hard to navigate
- Inbox = no size limit (staging area)

---

## Quality Checklist

Before finalizing Memory:

**Content:**
- [ ] Decision matrix applied? (3+ yes)
- [ ] No framework/library basics?
- [ ] No standard patterns (REST, CRUD)?
- [ ] Delta principle followed?
- [ ] Every line adds unique value?

**Organization:**
- [ ] File sizes in range?
- [ ] Semantic clustering (related ideas together)?
- [ ] Clear naming (filename describes content)?
- [ ] Routing hints in CLAUDE.md?
- [ ] No chains (CLAUDE.md → file → file → file)?

**Writing:**
- [ ] Dense, not verbose?
- [ ] Uses symbols (✓/✗/→)?
- [ ] Code examples where helpful?
- [ ] Constraint-focused ("NEVER" vs "nice-to-have")?
- [ ] Consistent terminology?
