# Authoring Agent Skills: Complete Reference

Supporting patterns and implementation details for building effective Skills.

**Primary reference:** See [SKILL.md](SKILL.md) for the 6-phase workflow.

---

## Skill Structure & Organization

### Directory Layout Patterns

**Pattern 1: Simple (single capability)**
```
git-commit-helper/
└── SKILL.md
```

Single SKILL.md file. Use for focused skills.

**Pattern 2: Modular (progressive disclosure)**
```
pdf-processing/
├── SKILL.md (overview, quick start)
├── reference.md (detailed guide)
├── examples.md (complete examples)
└── scripts/
    ├── extract.py
    └── merge.py
```

SKILL.md under 500 lines. Details in reference files.

**Pattern 3: Domain-organized (multiple domains)**
```
bigquery-analysis/
├── SKILL.md (navigation)
└── domains/
    ├── finance.md (revenue, billing)
    ├── sales.md (pipeline, opportunities)
    └── product.md (API usage)
```

When user asks about sales, only `sales.md` is loaded.

### File Naming Conventions

| File | Purpose |
|------|---------|
| `SKILL.md` | Required. Overview, quick start, navigation. |
| `reference.md` | Detailed guide, complete patterns, API reference. |
| `examples.md` | Input/output examples, usage walkthroughs. |
| `best-practices.md` | Authoring principles, guidelines. |
| `workflows.md` | Multi-step procedures with checklists. |
| `discovery-checklist.md` | Testing if skill is discoverable. |
| `scripts/` | Executable utilities (Python, bash, etc.) |

---

## Writing SKILL.md

### Frontmatter

```yaml
---
name: Skill Name (64 chars max)
description: What it does + when to use (1024 chars max)
---
```

### Name Best Practices

- Gerund form: "Authoring Skills", "Processing PDFs"
- Noun phrase: "Skill Author", "PDF Processor"
- Action-oriented: "Author Skills", "Process PDFs"
- Avoid: "Helper", "Utils", "Tools"

### SKILL.md Body Structure

Keep under 500 lines. Include:

1. **What It Does** - 1-2 sentences, clear capability
2. **When to Use** - Situations, triggers, contexts
3. **Quick Reference** - Decision table, checklist, or type reference
4. **Minimal Example** - Concrete, realistic scenario
5. **More** - Links to reference files

### Complete Example

```markdown
---
name: Git Commit Helper
description: Write semantic commits from git diffs. Use when making commits, need type(scope) format, or writing conventional commits.
---

# Git Commit Helper

## What It Does
Analyzes staged changes and suggests conventional semantic commit messages.

## When to Use
- You've staged changes with `git add`
- Need semantic commit format
- Following type(scope): description pattern

## Commit Types

| Type | Purpose | Example |
|------|---------|---------|
| feat | New feature | feat(auth): add oauth login |
| fix | Bug fix | fix(button): hover broken |
| docs | Documentation | docs: update readme |
| refactor | Code reorganization | refactor(api): simplify |

## Minimal Example

```
You: "Staged my changes, what's the commit?"

Skill: "Based on your changes:

feat(auth): implement oauth login
- Adds OAuth provider
- Stores tokens securely"

You: "commit that"
```

## More

See [reference.md](reference.md) for advanced patterns.
```

---

## Progressive Disclosure Patterns

### Pattern 1: Overview + References

SKILL.md provides overview, links to details:

```markdown
## Features

**Extract text:** [reference.md](reference.md#extract)
**Fill forms:** [forms.md](forms.md)
**Merge documents:** [reference.md](reference.md#merge)
```

Claude reads reference files only when needed.

### Pattern 2: Domain Organization

Structure large skills by domain:

```
SKILL.md (overview, navigation)
└── domains/
    ├── finance.md
    ├── sales.md
    └── product.md
```

When user asks about sales, only `sales.md` loads.

### Pattern 3: Basic + Advanced

Show basic in SKILL.md, advanced in reference:

```markdown
## Creating Documents

Use docx-js library:
[Basic example in SKILL.md]

## Advanced Features

**Tracked changes:** See [redlining.md](redlining.md)
**Complex formatting:** See [ooxml.md](ooxml.md)
```

---

## Token Efficiency: Delta Principle

### Only Document Non-Inferrable Knowledge

**Don't document (Claude already knows):**
- Framework patterns (React hooks, Django models)
- Library behavior (Stripe API, Firebase)
- Standard architectures (REST, MVC)
- Language features (loops, types)
- File organization visible via ls

**Do document (high-value delta):**
- Custom patterns unique to this skill
- Non-obvious decisions (why X over Y?)
- Hard constraints (performance limits, security rules)
- Gotchas and edge cases
- Project-specific configurations

### Density Principles

**Prefer:**
- Code > prose
- Bullets > paragraphs
- Fragments > sentences (omit: the, a, an, is, are)
- Symbols: `✓` / `✗`, `→`, `:`

**Example:**

Before (27 words):
> The modular approach makes maintenance easier and allows developers to understand one concern at a time without getting confused.

After (8 words):
> Modular: ✓ easier maintenance, ✓ isolated concerns

---

## Executable Scripts in Skills

### When to Bundle Scripts

Include pre-made scripts for:
- Deterministic operations (validation, transformation)
- Error-prone tasks (database migrations)
- Consistency requirements (same behavior every time)
- Efficiency needs (no code generation required)

### Error Handling

**Good: Explicit error handling**
```python
def process_file(path):
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        print(f"File not found, creating default")
        with open(path, 'w') as f:
            f.write('')
        return ''
```

**Bad: Punts to Claude**
```python
def process_file(path):
    return open(path).read()  # Will fail if missing
```

### Script Documentation

Clearly state whether to execute or read:

- **Execute:** "Run `analyze_form.py` to extract fields"
- **Reference:** "See `analyze_form.py` for extraction algorithm"

Most utility scripts should be executed, not read.

---

## Discovery Patterns

For detailed discovery testing, see [discovery-checklist.md](discovery-checklist.md).

### Description Structure

```
description = What skill does + When to use + Key trigger words
```

**Bad (vague):**
```
description: Helps with data
```

**Good (specific, discoverable):**
```
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when working with Excel files, spreadsheets, or .xlsx data analysis.
```

### Key Ingredients

- Verb + action (Write, Generate, Create, Analyze)
- Specific capability (not just "helps with")
- When to use (triggers, contexts)
- Key terms users mention (not generic words)

---

## Iteration Pattern

### Develop Skills Through Real Usage

1. **Complete a task** manually
2. **Identify reusable patterns** from the work
3. **Create a Skill** capturing those patterns
4. **Review for conciseness** - remove what Claude knows
5. **Organize information** - split into reference files
6. **Test on similar tasks** - observe if Claude finds needed info
7. **Iterate based on observation** - if Claude struggles, refine

### Refinement Triggers

Update skill if:

- **Underused:** Claude doesn't discover it when should
  - Action: Expand description with more trigger words
  - Action: Simplify content

- **Overused:** Claude invokes for unrelated tasks
  - Action: Narrow description
  - Action: Add "When NOT to use" section

- **Ineffective:** Users request it but doesn't help
  - Action: Improve examples
  - Action: Refine procedure steps

- **Conflicts:** Description too similar to other skills
  - Action: Add distinguishing keywords
  - Action: Clarify scope differences

---

## Verification Checklist

Before deploying a Skill:

### Content Quality
- [ ] Name follows conventions (gerund or noun)?
- [ ] Description specific and includes key terms?
- [ ] Description includes WHAT and WHEN?
- [ ] SKILL.md under 500 lines?
- [ ] Details in separate reference files?
- [ ] Examples concrete, not abstract?
- [ ] No framework basics or library docs?
- [ ] Delta principle applied?

### Structure
- [ ] Directory layout matches one of three patterns?
- [ ] File references one level deep?
- [ ] No nested chains of references?
- [ ] Consistent terminology?

### Testing
- [ ] Tested with real scenarios?
- [ ] Claude discovers it when expected?
- [ ] Works with Haiku, Sonnet, and Opus?
- [ ] Team feedback incorporated?

See [discovery-checklist.md](discovery-checklist.md) for comprehensive testing.

---

## File Size Guidelines

| File | Ideal | Too Small | Too Large |
|------|-------|-----------|-----------|
| SKILL.md | <500 | N/A | Split into references |
| reference.md | 100-300 | <50 | Split by domain |
| Other files | 100-200 | <30 | >250 split |

---

## Common Pitfalls

### Over-Documentation
- Framework tutorials
- Library API docs (link to official instead)
- Standard patterns (REST, CRUD, MVC)
- Language features (loops, types, syntax)

### Wrong Granularity
- **Too vague:** "Auth happens" (not actionable)
- **Too specific:** Every implementation detail
- **Right:** High-level constraints + key patterns

### Poor Organization
- Nested reference chains (SKILL → advanced → details)
- Keep reference files one level deep

### Tool References
Always use fully qualified names:
- ✓ `BigQuery:bigquery_schema`
- ✓ `GitHub:create_issue`
- ✗ `bigquery_schema` (ambiguous)

---

## Next Steps

1. Read [SKILL.md](SKILL.md) for the 6-phase workflow
2. Review [workflows.md](workflows.md) for complete examples
3. Check [discovery-checklist.md](discovery-checklist.md) before launch
4. See [best-practices.md](best-practices.md) for writing principles
5. Create your first Skill and test it with real scenarios
