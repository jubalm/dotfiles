# Workflows: Bootstrap, Capture, Promote, Audit, Troubleshoot

---

## Bootstrap: Create Memory System from Scratch

### 5-Minute Quick-Start

For small projects, do this first:

1. **Discover** (2 min) - List 3-5 key decisions
2. **Score** - Do any hit 3+ yes? If yes, proceed.
3. **Structure** - Pick starter or growing pattern
4. **Create** - Build CLAUDE.md + conventions.md
5. **Add inbox** - Ready for future discoveries

**Result:** Minimal Memory, expandable.

### Full Bootstrap (2-4 hours)

Complete workflow for comprehensive Memory.

#### Step 1: Discover (30 min)

**Goal:** Understand codebase and current state

**Actions:**
- Read `package.json` → tech stack
- List directory structure → organization
- Read main entry files → architecture
- Check recent git commits → recent decisions
- Identify key modules → mental model

**Output:** List of 5-10 key decisions

#### Step 2: Interview (45 min)

**Goal:** Extract knowledge not visible in code

Ask your team:

1. **Technology:** "Why did you choose X over Y?"
2. **Architecture:** "How are concerns separated?"
3. **Patterns:** "What's the standard pattern for...?"
4. **Constraints:** "What rules prevent bugs?"
5. **Product:** "What's unique about our domain?"
6. **Gotchas:** "What trips up new developers?"

**Output:** 20-30 discoveries

#### Step 3: Score (30 min)

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

#### Step 4: Structure (15 min)

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

#### Step 5: Create (60 min)

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

#### Step 6: Validate (15 min)

**Goal:** Test that routing works

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

#### Step 7: Report

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

## Capture: Find and Add New Discoveries

### Proactive Discovery

**Watch for:**
- New patterns emerging during implementation
- Decisions during code review ("Why didn't they use...?")
- Gotchas when debugging (hard-earned knowledge)
- Constraints discovered through failures
- Refactoring that reveals architecture lessons

**Action:**
1. Note in `inbox.md` immediately (with date)
2. Score silently (1-5 criteria)
3. If 3+ yes → suggest promotion
4. If 2 yes → note for re-evaluation later

### Explicit Capture

**When user/team says:** "Add this to context"

**Process:**
1. Add to `inbox.md` with date
2. Score against decision matrix
3. If 3+ yes → Promote immediately
4. If <3 yes → Ask if they still want it

**Report:**
```
Added to inbox.md:
- [Discovery]

Score: 4/5 yes → Will promote this week
```

---

## Promote: Move Inbox Items to Permanent Memory

### Promotion Checklist

```
- [ ] Step 1: Find - Locate in inbox.md
- [ ] Step 2: Re-score - Verify still 3+ yes
- [ ] Step 3: Rewrite - Apply delta & density
- [ ] Step 4: Place - Determine destination file
- [ ] Step 5: Integrate - Add to target file
- [ ] Step 6: Mark - Update inbox with date
```

### Step 1: Find

Locate the discovery in `inbox.md`:

```markdown
## 2025-10-18: Session token invalidation

When user logs out, session tokens expire immediately
but refresh tokens should be invalidated after 24 hours...
```

### Step 2: Re-Score

Apply decision matrix again to verify it's still 3+ yes:

| Criterion | Assessment | Score |
|-----------|-----------|-------|
| Would Claude miss? | Yes, subtle timing detail | 1 |
| Project-specific? | Yes, our security architecture | 1 |
| Prevent bugs? | **YES** - stale tokens = security holes | 1 |
| Save time? | Yes, avoids debugging | 1 |
| Stable? | Yes, core security decision | 1 |

**Total: 5 yes → Promote immediately**

### Step 3: Rewrite for Efficiency

Remove narrative, focus on constraints:

**Before (verbose):**
```markdown
When user logs out, session tokens expire immediately but
refresh tokens should be invalidated after 24 hours to catch
stale refresh attempts. This prevents security issues where
refresh tokens linger.
```

**After (dense):**
```markdown
Session invalidation: Tokens expire immediately on logout
Refresh tokens: Revoked after 24h (catches stale attempts)
✗ Never keep refresh tokens >24h
```

### Step 4: Determine Destination

Ask: Which file does this belong in?

- **principles.md** → WHY decision (architecture choice)
- **architecture.md** → Structural rule or hard constraint
- **patterns.md** → Implementation pattern
- **[feature].md** → Feature-specific
- **[concern].md** → Cross-cutting (security, testing, perf)

For session token example → `security.md` (constraint)

### Step 5: Integrate Semantically

Add to target file in appropriate section.

If `security.md` has "Authentication" section:
```markdown
## Authentication

### Session Management

Session tokens: Expire immediately on logout
Refresh tokens: Revoked after 24h (catches stale attempts)
✗ Never keep refresh tokens >24h
```

### Step 6: Mark Promoted

Update `inbox.md`:

**Before:**
```markdown
## 2025-10-18: Session token invalidation

When user logs out, session tokens expire immediately...
```

**After:**
```markdown
## 2025-10-18: Session token invalidation

~~When user logs out, session tokens expire immediately...~~
(Promoted: 2025-10-18 → security.md)
```

---

## Edge Cases in Promotion

### Case 1: Discovery Invalidated

**Problem:** Re-scoring shows only 2 yes (not high enough)

**Solution:**
1. Mark in inbox: "Not high-value enough" with date
2. Leave (don't delete) for future reference
3. Move on

### Case 2: Destination Unclear

**Problem:** Could fit multiple files

**Solution:**
1. Choose based on primary use case
2. Ask: "What query would find this?"
3. If answer is "security", put in security.md
4. Add cross-reference in other file if helpful

### Case 3: Conflicts with Existing Content

**Problem:** New discovery contradicts existing Memory

**Solution:**
1. Don't overwrite - investigate why conflict exists
2. Update old content with date change: "Changed: YYYY-MM-DD"
3. Document both if both are valid (different contexts)

---

## Audit: Quarterly Quality Check

### Audit Checklist

```
Quarterly Audit:
- [ ] Step 1: Freshness - Check for stale content
- [ ] Step 2: Accuracy - Verify decisions still hold
- [ ] Step 3: Completeness - Missing high-value items?
- [ ] Step 4: Clarity - Routing hints accurate?
- [ ] Step 5: Cleanup - Archive obsolete items
```

### Step 1: Freshness (15 min)

Read through each file. Mark:

- ✓ Fresh (no action)
- ⚠ Stale (needs update)
- ✗ Obsolete (remove/archive)

**Ask:** Is this still accurate? Has this changed?

### Step 2: Accuracy (15 min)

For each decision, verify it still holds:

```markdown
## Database: PostgreSQL

Current: Using PostgreSQL 14 with RLS
Still valid? ✓ Yes (no migration planned)
Rationale accurate? ✓ Yes (RLS still best)
```

Mark status: ✓ Accurate or ⚠ Needs update

### Step 3: Completeness (15 min)

Ask: "What would trip up a new developer?"

Common gaps:
- Deployment process (not documented)
- Debugging patterns (not shared)
- Performance gotchas (learned hard way)
- Security best practices (scattered)

Add missing deltas to inbox for promotion.

### Step 4: Clarity (10 min)

Test routing hints:

```
Query: "How is [system] organized?"
Result: Finds architecture.md ✓

Query: "What's our testing approach?"
Result: Finds patterns.md ✓
```

If queries don't resolve → refine routing or reorganize.

### Step 5: Cleanup (10 min)

Archive obsolete items.

**When decision changes:**

Old:
```markdown
## Database: MongoDB

Chosen for schema flexibility...
```

New:
```markdown
## Database: PostgreSQL (2025-10-01)

Migrated from MongoDB (see HISTORY.md) due to:
- Transactional guarantees
- RLS for multi-tenancy
- Better performance

[MongoDB history archived]
```

---

## Troubleshooting

| Problem | Symptoms | Fix |
|---------|----------|-----|
| **Routing broken** | Claude can't find answers | Hints too vague? Make specific. Test against real queries. 1 level deep (CLAUDE.md → file only). |
| **Files too large** | >250 lines, hard to navigate | Split by domain (backend.md, frontend.md) or concern (security.md, perf.md) |
| **Files too small** | <30 lines, wasteful | Merge into parent (conventions.md, patterns.md) + add section heading |
| **Conflicting patterns** | Old & new code differ | Document both ("Old vs New"). Mark: "Refactor old to new" |
| **Stale content** | Decisions no longer accurate | Quarterly audit. Mark: "Changed: YYYY-MM-DD". Archive old. |
| **Over-documentation** | Bloated, low-value content | Re-score: <3 yes → remove. Keep constraints only. |
| **Too specific** | Implementation details not patterns | Refactor → change? If yes → too specific. Use constraints ("NEVER X") not HOW. |

### Problem: Code Examples Become Outdated (Code-Memory Drift)

**Symptoms:** Claude suggests stale patterns → rejected in code review | Team refactors, Memory unchanged

**Root cause:** Copy-paste code (HOW) instead of constraints (WHY)

**Solutions:**

1. **Constraints over code:** `Email: Use library (never regex)` not `function validate() { regex... }`

2. **Pseudocode + constraint:**
   ```
   Email → validate + lowercase → check uniqueness
   ✗ Never store plaintext passwords
   ```

3. **Link to real code:** `See: src/config/loader.ts:45-70` (source of truth, not Memory)

4. **Mark timestamps:** `Auth Flow (Updated 2025-10)`

5. **Quarterly audit:** Review code examples. Update or archive stale.

[See guidance](reference.md#code-in-memory-the-drift-problem)

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

---

## Lifecycle Summary

```
Bootstrap (first week)
    ↓
Discover + Interview + Score + Structure + Create
    ↓
ONGOING:
├─ Capture: Discoveries → inbox.md
├─ Promote: Inbox items → permanent Memory
└─ Audit: Quarterly freshness check

Result: Living knowledge system
```
