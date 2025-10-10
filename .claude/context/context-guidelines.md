# Context Guidelines

**Purpose:** HOW/WHAT to write `.claude/context/*` files
**When editing context:** Follow these rules strictly

**Update when:** Patterns clarified, promotion process refined

---

## Content Rules

- **AVOID** Claude Code default knowledge
- Include non-obvious knowledge

---

## Skip (Claude Default Knowledge)

- Laravel basics (routes, controllers, models)
- React fundamentals (components, hooks, state)
- Docker syntax (FROM, RUN, COPY)
- Standard REST conventions
- Git workflow basics
- Common npm/composer commands

---

## Style Rules

Sacrifice grammar for concision

**Abbrevs:**
- Common: API, DB, fn, req, res, val, auth, org, rel(s), vol
- Domain: BE (backend), FE (frontend), L12 (Laravel 12), E2E (tests)

**Structure:**
- Code > prose
- Nested bullets > paragraphs
- Fragments, not sentences

**Symbols vs words:**
- ✓/✗ instead of yes/no, complete/incomplete
- → instead of "leads to", "results in"
- ± instead of "approximately", "roughly"

**Max density:** Remove connecting words (the, a, an, is, are, etc.)

---

## Files

**Entry:**
- ../CLAUDE.md → Quick start, git structure, command ref

**Meta:**
- context-guidelines.md → HOW/WHAT (this file)
- inbox.md → Temp discoveries (staging area)

---

## Promotion Flow

**inbox → Permanent:**
1. Add discovery w/ date
2. Verify across codebase
3. Destination: principles/architecture/patterns.md
4. Rewrite in compact style
5. Move, archive in inbox (~~strikethrough~~ + "Promoted: YYYY-MM-DD")

---

## Decision Matrix

**When to add:**
- Would Claude miss? (not in training)
- Project-specific? (not general)
- Causes bugs if unknown? (high stakes)
- Saves time? (vs re-discover)
- Stable? (not changing soon)

**3+ yes** → context file
**2 yes** → inbox
**≤1 yes** → skip

---

## Maintain

**Update when:**
- New patterns emerge
- API contracts change
- Conventions evolve
- Inbox items verified

**Avoid:**
- Duplicate code comments
- Obvious structure
- Over-documenting impl details
- Stale/deprecated info

---

*Optimize Claude effectiveness, not document everything*
