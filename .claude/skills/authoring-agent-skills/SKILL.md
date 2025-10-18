---
name: Authoring Agent Skills
description: Write reusable procedures that Claude discovers and invokes automatically. Use when creating new skills, testing if skills are discoverable, iterating on underused skills, or improving skill descriptions for better Claude integration.
---

# Authoring Agent Skills

**Focused capability:** Write skills that Claude actually discovers and uses in real workflows.

A Skill is a reusable procedure that Claude discovers automatically based on description matching. Its success is measured by: **Does Claude find it? Does Claude use it? Does it solve the problem?**

---

## Core Principle: Discovery Before Structure

The best skill structure means nothing if Claude never discovers it.

**Priority order:**
1. **Is it discoverable?** (Will Claude find it?)
2. **Does it work?** (Does it solve the problem?)
3. **Is it efficient?** (Is it token-optimized?)
4. **Is it structured well?** (Are reference files organized?)

Structure follows discovery, not the other way around.

---

## The Workflow: Write a Discoverable Skill

### Phase 1: Decide If It's a Skill

Not everything should be a skill.

| Type | Example | Where |
|------|---------|-------|
| **Skill** (procedure/HOW) | "How to write conventional commits" | `~/.claude/skills/` |
| **Memory** (fact/WHAT) | "Valid commit scopes: nvim, zsh, git" | `.claude/context/` |
| **Slash Command** (explicit) | `/git-commit` | `.claude/commands/` |

**Decision questions:**
- Is it a reusable HOW (procedure)? → Skill
- Is it a project-specific WHAT (fact)? → Memory
- Does user need to invoke it explicitly? → Slash Command

### Phase 2: Choose Scope (User or Project)

**User-level skills** (`~/.claude/skills/`)
- Works across all projects
- Universal best practice
- Portable, reusable

**Project-level skills** (`.claude/skills/`)
- Only relevant to this project
- Project-specific workflow
- Use sparingly

Default to **user-level** (more discoverable globally).

### Phase 3: Write for Discovery

**The description determines if Claude finds your skill.**

Structure:
```
Description = What skill does + When to use it + Key trigger words
```

**Bad (vague):**
```
description: Helps with commit messages
```

**Good (specific, discoverable):**
```
description: Write conventional commit messages from git diffs. Use when making commits, need semantic message format, or following type(scope): description pattern.
```

**Ingredients:**
- Verb + action (Write, Generate, Create, Analyze)
- Specific capability (not just "helps with")
- When to use (triggers, contexts)
- Key terms users mention ("semantic commit", "type(scope)")

### Phase 4: Write the Skill

**Core content goes in SKILL.md (keep under 500 lines):**
1. What this skill does (1 paragraph)
2. Common scenarios (3-5 use cases)
3. Quick reference or decision table
4. 1-2 concrete minimal examples
5. Links to reference files for details

**Example structure:**

```markdown
---
name: Git Commit Helper
description: Write conventional commit messages from git diffs.
Use when making commits, creating semantic messages, or following
type(scope): description pattern.
---

# Git Commit Helper

## What It Does
Analyzes staged changes and suggests semantic commit messages.

## When to Use
- Making a commit with staged changes
- Unsure about commit message format
- Need type(scope): description pattern
- Want to enforce conventional commits

## Quick Reference

| Type | Usage | Example |
|------|-------|---------|
| feat | New feature | feat(auth): add login flow |
| fix | Bug fix | fix(button): hover state broken |
| docs | Documentation | docs: update README |
| refactor | Code refactor | refactor(api): simplify endpoints |
| test | Test changes | test(auth): add login tests |

## Minimal Example

```
$ git diff --staged
[shows 3 files changed]

You: "suggest commit message"

Skill: "Based on your changes:

feat(auth): implement user login with oauth

This adds OAuth-based login, storing tokens securely."

You: "commit that"
```

## More

See [reference.md](reference.md) for advanced patterns.
```

### Phase 5: Test Discoverability

**Your skill only exists if Claude finds it.**

- [ ] Does description match what users would ask for?
- [ ] Would Claude discover it explicitly? (Test with description words)
- [ ] Does it work when invoked?
- [ ] Try with different phrasing - does it still trigger?
- [ ] Check if Claude uses it proactively in related tasks

See [discovery-checklist.md](discovery-checklist.md) for detailed testing.

### Phase 6: Iterate Based on Usage

- Does Claude invoke it appropriately?
- Are users mentioning it explicitly?
- Could description be clearer?
- Does the skill need refinement?

Update description and content based on patterns you observe.

---

## Decision Matrix: Skill or Memory?

| Question | Skill | Memory |
|----------|-------|--------|
| Is it a procedure (HOW)? | ✓ YES | ✗ NO |
| Is it a fact (WHAT)? | ✗ NO | ✓ YES |
| Reusable across projects? | ✓ YES | ✗ NO |
| Project-specific constraint? | ✗ NO | ✓ YES |

**Majority left → Skill | Majority right → Memory**

---

## Detailed Guidance

For complete implementation details:
- See [reference.md](reference.md) for structure patterns and file organization
- See [best-practices.md](best-practices.md) for writing principles
- See [discovery-checklist.md](discovery-checklist.md) for testing your skill
- See [workflows.md](workflows.md) for complete step-by-step examples

---

## Quick Start

1. **Decide**: Is it a skill? (Phase 1)
2. **Choose scope**: User or project? (Phase 2)
3. **Write description**: Will Claude find it? (Phase 3)
4. **Write SKILL.md**: Procedure + examples (Phase 4)
5. **Test discovery**: Does it work? (Phase 5)
6. **Iterate**: Based on usage patterns (Phase 6)

See [workflows.md](workflows.md) for complete walkthroughs of creating new skills from start to finish.
