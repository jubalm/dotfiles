---
name: Authoring Agent Skills
description: Create and refine Agent Skills for Claude Code - structured procedures with progressive disclosure. Use when writing reusable Skills, organizing skill content, or improving existing Skills.
---

# Authoring Agent Skills

**Focused capability:** Write Skills that Claude discovers and uses effectively in real workflows.

A Skill is a reusable procedure packaged into discoverable capabilities. This guide teaches how to structure, write, and iterate on Skills for maximum effectiveness.

---

## When to Use This Skill

- Writing a new Skill from scratch
- Refining an existing Skill that isn't being discovered or used
- Organizing Skill content with progressive disclosure
- Deciding between user-level (universal) and project-level (project-specific) Skills
- Applying token efficiency to Skill design

---

## Core Principle: Concise Instructions with Progressive Disclosure

**SKILL.md** is a table of contents:
- Overview + quick examples (keep under 500 lines)
- Links to reference files for deeper content
- Claude reads reference files only when needed

**Result:** Token-efficient, focused, discoverable.

---

## Quick Decision Matrices

### 1. Skill or Memory?

| Question | Skill | Memory |
|----------|-------|--------|
| Procedure (HOW)? | ✓ YES | ✗ NO |
| Fact (WHAT)? | ✗ NO | ✓ YES |
| Reusable workflow? | ✓ YES | ✗ NO |
| Project constraint? | ✗ NO | ✓ YES |

**If majority left → Skill | If majority right → Memory**

### 2. Skill Location: User-Level or Project-Level?

*Only applies if Step 1 = Skill*

| Question | User-Level | Project-Level |
|----------|------------|---------------|
| Works for any project? | ✓ YES | ✗ NO |
| Universal best practice? | ✓ YES | ✗ NO |
| Shareable across projects? | ✓ YES | ✗ NO |
| Only for this project? | ✗ NO | ✓ YES |

**Default: User-level (preferred).** Only use project-level when truly necessary.

---

## Essential Structure

### SKILL.md Frontmatter

```yaml
---
name: Skill Name (64 chars max)
description: What it does + when to use (1024 chars max)
---
```

**Description is critical.** Include both what the Skill does and specific triggers/contexts for when to use it.

### Directory Structure

```
my-skill/
├── SKILL.md              # Required: overview + quick examples
├── reference.md          # Optional: detailed guide
├── best-practices.md     # Optional: authoring principles
└── scripts/              # Optional: utility scripts
    └── helper.py
```

---

## Key Principles

1. **One capability per Skill** - Focused, discoverable
2. **Concise SKILL.md** - Under 500 lines
3. **Progressive disclosure** - Details in reference files
4. **Clear descriptions** - Both WHAT and WHEN
5. **Token efficiency** - Only non-inferrable knowledge
6. **User-level default** - Portable, reusable

---

## Detailed Guidance

For comprehensive authoring patterns:
- See [reference.md](reference.md) for detailed structure and patterns
- See [best-practices.md](best-practices.md) for iterative refinement

For framework context:
- Skills are procedures (HOW to do things)
- Memory stores facts (WHAT is true about things)
- Skills can reference Memory for project-specific constraints

---

## Quick Examples

### Simple Skill: Single SKILL.md File

Focus on one capability, quick startup:

```markdown
---
name: Git Commit Helper
description: Generate semantic commit messages from git diffs
---

# Git Commit Helper

## Quick start

1. Run: `git diff --staged`
2. I'll suggest a commit message with type(scope): description
3. Explain the change and impact

## Format

Follow these examples:
- feat(scope): new feature
- fix(scope): bug fix
- chore: maintenance
```

### Complex Skill: SKILL.md + References

Multi-faceted capability, progressive content:

```markdown
---
name: PDF Processing
description: Extract text/tables, fill forms, merge PDFs
---

# PDF Processing

## Quick start

**Extract text:** See [reference.md](reference.md)
**Fill forms:** See [reference.md](reference.md)
**Merge documents:** See [reference.md](reference.md)

## When to use

- Text extraction from PDFs
- Form filling workflows
- Document merging
```

---

## Next Steps

1. Determine: Skill or Memory? User-level or project-level?
2. Create directory: `~/.claude/skills/skill-name/` (user) or `.claude/skills/skill-name/` (project)
3. Write SKILL.md with frontmatter + overview
4. Add reference files for detailed content
5. Test with real prompts to verify discovery
6. Iterate based on usage patterns

See [reference.md](reference.md) for complete authoring patterns and [best-practices.md](best-practices.md) for refinement strategies.
