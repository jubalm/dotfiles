# Memory Workflows: Bootstrap, Maintain, Promote

Practical procedures for managing Memory throughout its lifecycle.

---

## Bootstrap: Starting a Memory System from Scratch

Create a complete Memory system for a new project in one session.

### Bootstrap Checklist

```
Project Memory Bootstrap:
- [ ] Step 1: Discover - Scan codebase and structure
- [ ] Step 2: Interview - Ask about decisions
- [ ] Step 3: Score - Apply decision matrix
- [ ] Step 4: Structure - Organize by retrieval
- [ ] Step 5: Create - Write CLAUDE.md + context files
- [ ] Step 6: Validate - Test with sample queries
- [ ] Step 7: Report - Summary for team
```

### Step 1: Discover

**Goal:** Understand the codebase and current state

**Actions:**
- Read package.json → tech stack
- List directory structure → organization
- Read main entry files → architecture
- Check git history → recent decisions
- Identify key files/modules → mental model

**Output:** List of 5-10 key architectural/strategic decisions

**Example discoveries:**
- Technology choices (React vs Vue, Postgres vs MongoDB)
- Folder structure and module boundaries
- Custom patterns (data flow, state management)
- Constraints (performance, security, scaling)
- Team workflows (deployment, testing, code review)

### Step 2: Interview

**Goal:** Extract knowledge that isn't in code

Ask the team:

1. **Technology:** "Why did you choose X over Y?"
2. **Architecture:** "How are concerns separated?"
3. **Patterns:** "What's the standard pattern for...?"
4. **Constraints:** "What rules prevent bugs?"
5. **Product:** "What's unique about our domain?"
6. **Gotchas:** "What trips up new developers?"

**Output:** 20-30 decisions and constraints

### Step 3: Score

**Goal:** Determine what's worth documenting

For each discovery, score on decision matrix (1-5 on each criterion):

```
✓ Would Claude miss?
✓ Project-specific?
✓ Prevent bugs?
✓ Save time?
✓ Stable?
```

**Keep items scoring 3+ yes**

**Output:** Prioritized list of 10-20 high-value items

### Step 4: Structure

**Goal:** Organize discoveries into files

**Organize by:**
1. **Principles** - Philosophy, WHY decisions
2. **Architecture** - Structure, HOW organized
3. **Patterns** - Non-obvious implementations
4. **[Feature/Concern]** - Domain-specific or cross-cutting

**Group discoveries:**
- Principles: Design philosophy, technology rationale
- Architecture: Folder structure, module boundaries, relationships
- Patterns: Custom implementations, key workflows
- Feature files: Feature-specific knowledge
- Concern files: Security, performance, testing, etc.

**Output:** File organization plan

### Step 5: Create

**Goal:** Write files with high-value delta content

**Create in order:**
1. **CLAUDE.md** - Routing hints ("When X → @context/Y")
2. **principles.md** - Why decisions, design rationale
3. **architecture.md** - How organized, folder structure
4. **patterns.md** - Non-obvious implementations
5. **[Additional files]** - Feature/concern-specific
6. **inbox.md** - Empty, ready for discoveries

**For each file:**
- Use discovery content
- Apply delta principle (remove inferrable knowledge)
- Write concisely (fragments, symbols)
- Include constraints (NEVER rules, not suggestions)

### Step 6: Validate

**Goal:** Test that routing works

For each routing hint in CLAUDE.md, ask a test query:

```
**Test 1:** "Why did you choose React?"
→ Should find relevant section in principles.md ✓

**Test 2:** "How is authentication implemented?"
→ Should find auth pattern in patterns.md ✓

**Test 3:** "What are security constraints?"
→ Should find security rules in architecture.md or separate security.md ✓
```

If Claude doesn't find expected files, refine routing hints or file organization.

### Step 7: Report

Share results:

```
Memory System Created

Files:
- CLAUDE.md (5 routing hints)
- principles.md (3 key decisions: auth, deployment, db)
- architecture.md (folder structure, module boundaries)
- patterns.md (3 custom patterns)
- inbox.md (ready for ongoing discoveries)

Test Queries Passed:
✓ "Why use Next.js?"
✓ "How is data fetched?"
✓ "What security constraints apply?"

Estimated Coverage: 80% of high-value project knowledge
Next: Promotion workflow for inbox items
```

---

## Promote: Moving Discoveries to Permanent Memory

When you discover something worth documenting, move it from inbox to permanent files.

### Promotion Checklist

```
Inbox Item Promotion:
- [ ] Step 1: Find - Locate in inbox.md
- [ ] Step 2: Re-score - Verify still 3+ yes
- [ ] Step 3: Rewrite - Apply delta & density principles
- [ ] Step 4: Place - Determine destination file
- [ ] Step 5: Integrate - Add to target file semantically
- [ ] Step 6: Update - Mark in inbox with promotion date
```

### Step 1: Find

Locate the discovery in `inbox.md`

Example inbox entry:
```markdown
## 2025-10-18: Session state invalidation timing

When user logs out, session tokens expire immediately but refresh tokens
should be invalidated after 24 hours to catch stale refresh attempts.
This prevents security issues where refresh tokens linger.
```

### Step 2: Re-Score

Apply decision matrix again:

| Criterion | Assessment | Score |
|-----------|-----------|-------|
| Would Claude miss? | Yes, subtle timing detail | 1 |
| Project-specific? | Yes, our security architecture | 1 |
| Prevent bugs? | YES - stale tokens = security holes | 1 |
| Save time? | Yes, avoids trial-and-error debugging | 1 |
| Stable? | Yes, core security decision | 1 |

**Total: 5 yes → Promote immediately**

### Step 3: Rewrite for Efficiency

Remove narrative, add constraint focus:

**Before (verbose):**
```markdown
When user logs out, session tokens expire immediately but refresh tokens
should be invalidated after 24 hours to catch stale refresh attempts.
This prevents security issues where refresh tokens linger.
```

**After (dense):**
```markdown
Session invalidation: Tokens expire immediately on logout
Refresh tokens: Revoked after 24h (catches stale refresh attempts)
✗ Never keep refresh tokens >24h
```

### Step 4: Determine Destination

Ask: Which file does this belong in?

- **principles.md?** - If it's a WHY decision
- **architecture.md?** - If it's structural or a hard rule
- **patterns.md?** - If it's an implementation pattern
- **[feature].md?** - If it's feature-specific
- **[concern].md?** - If it's cross-cutting (security, performance)

For the session token example → `security.md` (constraint-focused)

### Step 5: Integrate Semantically

Add to the target file in the right section:

If `security.md` has section "Authentication":
```markdown
## Authentication

### Session Management

Session tokens: Expire immediately on logout
Refresh tokens: Revoked after 24h (catches stale attempts)
✗ Never keep refresh tokens >24h
```

### Step 6: Update Inbox

Mark as promoted with date:

**Before:**
```markdown
## 2025-10-18: Session state invalidation timing

When user logs out, session tokens expire immediately...
```

**After:**
```markdown
## 2025-10-18: Session state invalidation timing

~~When user logs out, session tokens expire immediately...~~ (Promoted: 2025-10-18 → security.md)
```

---

## Capture: Ongoing Discovery

Continuously find and document new knowledge.

### Proactive Discovery

**Watch for:**
- New patterns that emerge during implementation
- Decisions during code review (why didn't they use X?)
- Gotchas when debugging (hard-earned knowledge)
- Constraints discovered through failures
- Refactoring that reveals architecture lessons

**Action:**
1. Note in inbox.md immediately (don't forget!)
2. Score silently (1-5 criteria)
3. If 3+ yes, suggest promotion
4. If 2 yes, note for re-evaluation later

### Explicit Capture

**When user/team says:** "Add this to context"

**Process:**
1. Add to inbox.md with date
2. Score against decision matrix
3. If 3+ yes: Promote immediately
4. If <3 yes: Ask if they still want it documented

**Report:**
```
Added to inbox.md:
- [Discovery name]

Score: 4/5 yes → Will promote this week
```

---

## Audit: Quarterly Quality Check

Maintain Memory health through regular audits.

### Audit Checklist

```
Quarterly Memory Audit:
- [ ] Step 1: Freshness - Check for stale content
- [ ] Step 2: Accuracy - Verify decisions still hold
- [ ] Step 3: Completeness - Missing high-value deltas?
- [ ] Step 4: Clarity - Routing hints still accurate?
- [ ] Step 5: Cleanup - Archive obsolete items
```

### Step 1: Freshness

Read through each file. Ask:

- Is this still accurate?
- Has this changed?
- Is this still a high-value decision?

**Mark as:**
- ✓ Fresh (no action)
- ⚠ Stale (needs update)
- ✗ Obsolete (remove/archive)

### Step 2: Accuracy

For each decision, verify:

**Example:**
```markdown
## Database Choice: PostgreSQL

Current state: Using PostgreSQL 14 with RLS
Decision still valid? ✓ Yes (no migration planned)
Rationale still accurate? ✓ Yes (RLS still best for multi-tenancy)
```

### Step 3: Completeness

Are there gaps in Memory?

**Ask:** "What would trip up a new developer?"

**Common gaps:**
- Deployment process (not documented)
- Common debugging patterns (not shared)
- Performance gotchas (learned the hard way)
- Security best practices (scattered across code)

Add missing high-value deltas to inbox for promotion.

### Step 4: Clarity

Test routing hints:

```
**Query:** "How is data cached?"
→ Should find strategy in architecture.md ✓

**Query:** "What's our testing approach?"
→ Should find patterns in patterns.md ✓ (or create testing.md)
```

If queries don't resolve, refine routing hints or reorganize files.

### Step 5: Cleanup

**Archive obsolete items:**

When a decision changes (e.g., "We switched from MongoDB to PostgreSQL"):

Old:
```markdown
## Database: MongoDB

Chosen for schema flexibility...
```

New:
```markdown
## Database: PostgreSQL (2025-10-01)

Migrated from MongoDB (2025-09-15) due to:
- Need for transactions across documents
- RLS for multi-tenancy
- Better performance at scale

[MongoDB history archived]
```

---

## Lifecycle Summary

```
Bootstrap
    ↓
Discover + Interview + Score (first week)
    ↓
Structure + Create files (first week)
    ↓
ONGOING:
├─ Capture: Add discoveries to inbox
├─ Promote: Move inbox items to permanent memory
└─ Audit: Quarterly review

Result: Living Knowledge System
```

---

## Template: Quick Bootstrap

Use this to bootstrap Memory in <2 hours:

### CLAUDE.md

```markdown
# [Project Name]

**When:** How is [system] organized? → @context/architecture.md
**When:** What are the key decisions? → @context/principles.md
**When:** How do I implement [pattern]? → @context/patterns.md

[1-2 sentence project description]
```

### principles.md

```markdown
# Principles & Decisions

## Technology Choices

**Choice 1:** [Tech chosen over alternative]
**Why:** [Reason 1, Reason 2]

**Choice 2:** [Tech chosen over alternative]
**Why:** [Reason 1, Reason 2]

## Design Philosophy

**Philosophy 1:** [High-level idea]
**Benefit:** [What it enables]
```

### architecture.md

```markdown
# Architecture & Structure

## Folder Organization

[Brief description of structure]

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

---

**Next:** Use promote workflow when inbox items reach score of 3+.
