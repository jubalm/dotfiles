# Authoring Agent Skills: Complete Workflows

Step-by-step walkthroughs of creating skills from discovery through iteration.

---

## Workflow 1: Create a Simple Skill (Git Commit Helper)

### Context
You notice you're often helping users write conventional commit messages. This feels repetitive - it's a perfect skill candidate.

### Phase 1: Decide If It's a Skill

Question: Is this a procedure or fact?
- **It's HOW**: Step-by-step process for writing commits
- **It's reusable**: Applies to any git project
- **It's procedural**: Not a fact to remember

→ **Decision: YES, create a skill**

---

### Phase 2: Choose Scope

Question: User-level or project-level?
- **Works everywhere**: Any project uses git commits
- **Best practice**: Not project-specific
- **Shareable**: Should be available across projects

→ **Decision: User-level skill** at `~/.claude/skills/git-commit-helper/`

---

### Phase 3: Write for Discovery

**What triggers when users need this?**
- Making a commit
- Need semantic format
- Writing conventional commits
- Confused about commit message

**Description draft:**

```
description: Write conventional commit messages from git diffs.
Use when making commits, need semantic format, or following
type(scope): description pattern.
```

**Check:**
- ✓ Starts with verb (Write)
- ✓ Specific capability (conventional commits)
- ✓ When to use (making commits, semantic format)
- ✓ Key trigger words (conventional commits, type(scope))

---

### Phase 4: Write the Skill

**File: `~/.claude/skills/git-commit-helper/SKILL.md`**

```markdown
---
name: Git Commit Helper
description: Write conventional commit messages from git diffs. Use when making commits, need semantic format, or following type(scope): description pattern.
---

# Git Commit Helper

## What It Does
Analyzes staged git changes and generates semantic commit messages following the conventional commits format: `type(scope): description`.

## When to Use
- You've staged changes with `git add`
- Need a descriptive, semantic commit message
- Want to follow conventional commits standard
- Unsure what message format to use

## Commit Types

| Type | Purpose | Example |
|------|---------|---------|
| `feat` | New feature | `feat(auth): add oauth login` |
| `fix` | Bug fix | `fix(navbar): nav links not clickable` |
| `docs` | Documentation | `docs: update api reference` |
| `refactor` | Code reorganization | `refactor(api): simplify endpoint logic` |
| `test` | Test changes | `test(auth): add login tests` |
| `chore` | Maintenance | `chore: update dependencies` |

## Minimal Example

**Scenario:** You've edited files for a new authentication feature.

```
You: "I've staged my changes. What should the commit message be?"

Skill analyzes staged changes...

Skill: "Based on your changes (added OAuth login, updated docs):

feat(auth): implement OAuth login flow

- Adds OAuth2 provider integration
- Stores access tokens securely
- Updates authentication documentation"

You: "That works, commit it"
```

## More Details

For detailed patterns, scopes, and advanced usage: See [reference.md](reference.md)
```

---

### Phase 5: Test Discoverability

**Explicit test:**
```
User: "I need to write a conventional commit message. Can you use the Git Commit Helper skill?"

Expected: Skill loads and helps
Result: ✓ Works
```

**Implicit test 1 (simple):**
```
User: "I have staged changes. What should the commit message be?"

Expected: Claude might use skill, or help directly
Result: ✓ Claude uses skill or provides good answer
```

**Implicit test 2 (with keywords):**
```
User: "How do I write semantic commits with type(scope)?"

Expected: Skill discovered
Result: ✓ Skill loads, explains pattern
```

**Phrasing variation:**
```
1. "conventional commit message" → ✓ Found
2. "semantic commit" → ✓ Found
3. "git commit format" → ⚠️ Might not match
4. "commit message help" → ⚠️ Generic
```

**Observation:** Variations 3-4 don't match well.

→ **Refinement: Update description to include "git commit format"**

---

### Phase 6: Iterate Based on Usage

**Week 1 observation:**
- Users requesting by name: Yes
- Claude discovering proactively: Sometimes
- When asked directly: Works well
- Generic "commit help" phrasing: Doesn't trigger

**Update needed:** Expand description

**New description:**
```
description: Write semantic git commit messages following conventional commits format (type(scope): description). Use when making commits, need commit message format, or writing type(scope) style commits.
```

**Deploy and monitor for another week...**

---

## Workflow 2: Create a Complex Skill (SQL Query Analyzer)

### Context
You're analyzing complex SQL queries frequently. Each time you explain how to optimize them, improve readability, identify issues. This is a perfect skill - but more complex.

### Phase 1: Decide If It's a Skill

- **Is it HOW?** Yes - step-by-step analysis procedure
- **Is it reusable?** Yes - applies to any SQL
- **Is it procedural?** Yes - analyze → identify → suggest

→ **Decision: YES, create a skill**

---

### Phase 2: Choose Scope

- **Works everywhere?** Yes - SQL is universal
- **Best practice?** Yes
- **Shareable?** Yes

→ **Decision: User-level skill** at `~/.claude/skills/sql-query-analyzer/`

---

### Phase 3: Write for Discovery

**What are all the situations when users need this?**
- Debugging slow queries
- Understanding complex SQL
- Optimizing performance
- Finding SQL errors
- Query review/refactoring

**Description draft:**

```
description: Analyze SQL queries for performance, correctness, and readability. Use when debugging slow queries, reviewing complex SQL, or optimizing database performance. Identifies N+1 issues, missing indexes, and improvement opportunities.
```

**Ingredients:**
- ✓ Verb (Analyze)
- ✓ Specific (performance, correctness, readability)
- ✓ When to use (debugging, reviewing, optimizing)
- ✓ Key issues (N+1, missing indexes)

---

### Phase 4: Write the Skill

**File: `~/.claude/skills/sql-query-analyzer/SKILL.md`**

Structure:
- What it does
- When to use
- Analysis checklist (quick reference)
- Minimal example
- Link to reference files

```markdown
---
name: SQL Query Analyzer
description: Analyze SQL queries for performance, correctness, and readability. Use when debugging slow queries, reviewing complex SQL, or optimizing database performance. Identifies N+1 issues, missing indexes, and improvement opportunities.
---

# SQL Query Analyzer

## What It Does
Systematically reviews SQL queries for:
- Performance bottlenecks
- Missing indexes
- N+1 query patterns
- Unnecessary complexity
- Readability improvements

## When to Use
- Query is running slowly
- Need to review someone else's SQL
- Want to optimize database performance
- Debugging "why is this slow?"
- Learning SQL best practices

## Analysis Checklist

When analyzing, check for:

- [ ] **Indexes**: Are WHERE/JOIN columns indexed?
- [ ] **N+1**: Is query fetching many rows then running per-row queries?
- [ ] **JOINs**: Are all necessary? Any unnecessary joins?
- [ ] **Subqueries**: Could this be a window function?
- [ ] **DISTINCT/GROUP BY**: Is it hiding performance issues?
- [ ] **SELECT ***: Could be narrowed to specific columns?

## Minimal Example

```sql
-- SLOW: This is inefficient
SELECT * FROM users u
WHERE u.created_at > '2024-01-01'
```

Analysis:
- ✗ `SELECT *` loads all columns
- ✗ No index on created_at
- ✗ Missing LIMIT

Suggested improvement:
```sql
-- FAST: Better
SELECT u.id, u.email, u.name FROM users u
WHERE u.created_at > '2024-01-01'
AND u.status = 'active'
ORDER BY u.created_at DESC
LIMIT 100
```

Reasons:
- Specific columns (not *)
- Added index hint
- Added LIMIT
- Added status filter

## More

See [reference.md](reference.md) for complete optimization patterns.
See [common-patterns.md](common-patterns.md) for real-world examples.
```

---

### Phase 5: Test Discoverability

**Explicit tests:**
```
1. "Use SQL Query Analyzer to review this" → ✓
2. "Analyze this SQL query" → ✓
3. "Why is this query slow?" → ⚠️ (might need skill)
4. "N+1 problem" → ✓
```

**Implicit tests:**
```
1. "This query runs slow, help me fix it" → ✓ Used
2. "Show me how to write better SQL" → Might not trigger
3. "Query optimization?" → ⚠️ Generic
```

**Result:** Description is good. Covers main scenarios.

---

### Phase 6: Iterate

**Week 1-2 observation:**
- "Slow query" phrasing: Works
- "Query optimization": Works sometimes
- "SQL debugging": Works sometimes
- Direct request: Always works
- Proactive use: Works when SQL is provided

**Good signs:**
- ✓ Users requesting by name
- ✓ Claude using proactively with SQL
- ✓ Helping improve queries

**Opportunities:**
- Generic "SQL help" doesn't always trigger
- Could add more specific trigger words

**Update description:**
```
description: Analyze and optimize SQL queries for performance, correctness, and readability. Identifies N+1 queries, missing indexes, slow subqueries, and suggests improvements. Use when debugging slow SQL, reviewing queries, optimizing database performance, or learning SQL best practices.
```

**Deploy updated version...**

---

## Workflow 3: Project-Level Skill (Dotfiles Installer)

### Context
You have a complex install.py script for your dotfiles. Every time someone wants to contribute or extend it, you explain the structure. This is project-specific - not for other projects.

### Phase 1: Decide If It's a Skill

- **Is it HOW?** Yes - procedure for installing
- **Is it reusable?** No - only for this project
- **Is it procedural?** Yes

→ **Decision: YES, but project-level** at `.claude/skills/dotfiles-installer/`

---

### Phase 2: Choose Scope

- **Works everywhere?** No - only dotfiles project
- **Project-specific?** Yes
- **Should be user-level?** No

→ **Decision: Project-level skill** in `.claude/skills/`

---

### Phase 3: Write for Discovery

**Who uses this skill?**
- You (maintaining it)
- Future contributors
- Anyone extending dotfiles

**Description:**

```
description: Install and manage dotfiles symlinks. Use when running the installer, debugging symlink issues, or extending the dotfiles setup process.
```

---

### Phase 4: Write the Skill

Similar structure to above, but scoped to this project.

---

## Key Patterns Across Workflows

### Pattern: Discovery First

1. **Write description before content**
   - Ensures discoverability is prioritized
   - Content flows from description

2. **Test explicitly before implicit**
   - Does it load when requested directly?
   - Only then check proactive discovery

3. **Iterate based on observation**
   - Not just: "Does it work?"
   - But: "When does Claude use it? When should it?"

### Pattern: Content Structure

1. **What It Does** - 1-2 lines
2. **When to Use** - Situations/triggers
3. **Quick Reference** - Table or checklist
4. **Minimal Example** - Concrete, real scenario
5. **More** - Links to reference files

### Pattern: Testing

1. **Explicit invocation** - Does it load?
2. **Implied invocation** - Does it trigger?
3. **Phrasing variation** - Consistent discovery?
4. **Usage observation** - How is it actually used?
5. **Refinement** - Based on patterns

---

## Summary Checklist

For each new skill:

- [ ] **Phase 1**: Skill or Memory or Command?
- [ ] **Phase 2**: User-level or Project-level?
- [ ] **Phase 3**: Description with verb + specifics + triggers
- [ ] **Phase 4**: SKILL.md with What/When/Quick Reference/Example
- [ ] **Phase 5**: Test discovery (explicit → implicit → variations)
- [ ] **Phase 6**: Observe and iterate

See [SKILL.md](SKILL.md) for the complete 6-phase workflow.
