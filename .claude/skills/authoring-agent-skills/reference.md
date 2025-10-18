# Authoring Agent Skills: Complete Reference

Advanced patterns, structures, and decision-making for building effective Skills.

---

## Skill Structure & Organization

### Directory Layout Patterns

**Pattern 1: Simple (single capability, minimal content)**
```
git-commit-helper/
└── SKILL.md
```

**Pattern 2: Modular (related capabilities, progressive disclosure)**
```
pdf-processing/
├── SKILL.md (overview, quick start)
├── forms.md (form-filling guide)
├── reference.md (API reference)
├── examples.md (usage examples)
└── scripts/
    ├── analyze_form.py
    └── fill_form.py
```

**Pattern 3: Domain-organized (large Skills with multiple domains)**
```
bigquery-analysis/
├── SKILL.md (navigation)
└── reference/
    ├── finance.md (revenue, billing)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage)
    └── marketing.md (campaigns)
```

### File Naming Conventions

| File | Purpose |
|------|---------|
| `SKILL.md` | Required. Overview, quick examples, navigation. |
| `reference.md` | Detailed guide, API reference, complete patterns. |
| `best-practices.md` | Authoring principles, guidelines. |
| `examples.md` | Input/output examples, usage patterns. |
| `workflows.md` | Multi-step procedures with checklists. |
| `scripts/` | Executable utilities (Python, bash, etc.) |

---

## Writing SKILL.md

### Frontmatter Requirements

```yaml
---
name: Skill Name                    # 64 chars max
description: What it does + when    # 1024 chars max
---
```

**Name best practices:**
- Gerund form: "Authoring Skills", "Processing PDFs", "Analyzing Data"
- Noun phrase: "Skill Author", "PDF Processor"
- Action-oriented: "Author Skills", "Process PDFs"
- Avoid: "Helper", "Utils", "Tools"

**Description critical.** Must include:
- What the Skill does (specific capabilities)
- When to use it (triggers, contexts)
- Key terms users would mention

**Bad description (vague):**
```yaml
description: Helps with data
```

**Good description (specific):**
```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when working with Excel files, spreadsheets, or analyzing tabular data in .xlsx format.
```

### SKILL.md Body Structure

Keep SKILL.md under 500 lines. Structure:

1. **When to use** - Context where this Skill applies
2. **Core principle** - Main idea (one sentence)
3. **Quick reference** - Decision matrices or key concepts
4. **Examples** - 1-3 concrete examples
5. **References** - Links to detailed files

**Example structure:**

```markdown
---
name: PDF Processing
description: Extract text and tables from PDF files, fill forms, merge documents
---

# PDF Processing

## When to use
- Extracting text from PDFs
- Filling form fields
- Merging multiple documents

## Core principle
Use pdfplumber for text, pypdf for modifications.

## Quick reference

| Task | File |
|------|------|
| Extract text | [reference.md](reference.md#extract-text) |
| Fill forms | [forms.md](forms.md) |
| Merge docs | [reference.md](reference.md#merge) |

## Example

Extract text from first page:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For advanced usage, see [reference.md](reference.md).
```

---

## Progressive Disclosure Patterns

### Pattern 1: High-level guide with references

**SKILL.md** points to detailed materials:

```markdown
## Features

**Extract text**: See [reference.md](reference.md) for methods
**Fill forms**: See [forms.md](forms.md) for workflow
**Merge documents**: See [reference.md](reference.md)
```

Claude reads reference files only when needed.

### Pattern 2: Domain-specific organization

Keep token usage low by organizing by domain:

```
SKILL.md (overview, navigation)
└── reference/
    ├── finance.md (metrics: revenue, ARR)
    ├── sales.md (metrics: pipeline, opportunities)
    └── product.md (metrics: API usage, features)
```

When user asks about sales, Claude only loads `sales.md`, not finance or product data.

### Pattern 3: Conditional details

Show basic, link to advanced:

```markdown
## Creating documents

Use docx-js library. Basic usage:
[Example in SKILL.md]

## Advanced features

**Tracked changes**: See [redlining.md](redlining.md)
**Complex formatting**: See [ooxml.md](ooxml.md)
```

---

## Token Efficiency for Skills

### Delta Principle: Only Document Non-Inferrable Knowledge

**Don't document (Claude already knows):**
- Framework patterns (React hooks, Django models)
- Library behavior (Stripe API, Firebase)
- Standard architectures (REST, MVC)
- File organization (visible via ls)
- Language syntax and standard libraries

**Do document (high-value delta):**
- Custom patterns (unique to this Skill)
- Non-obvious decisions (why X over Y?)
- Hard constraints (performance limits, security rules)
- Gotchas and edge cases
- Project-specific configurations

**Examples:**

```
❌ "Use pdfplumber" (library capability, obvious from import)
✓ "Use pdfplumber for text extraction (handles most layouts well), pypdf for form filling (better form field support)"

❌ "Excel files use .xlsx format" (standard)
✓ "Always validate headers in first row, skip rows 2-5 (company metadata), treat empty cells as NULL"
```

### Density Principles

**Structure preferences:**
- Code > prose (show pattern, don't explain)
- Bullets > paragraphs (one idea per line)
- Fragments > sentences (remove: the, a, an, is, are)

**Use symbols:**
- `✓` / `✗` instead of yes/no
- `→` instead of "leads to"
- `:` instead of "is"

**Example density:**

Before (27 words):
> The reason we use the modular approach is because it makes maintenance easier, and it allows developers to understand one concern at a time without getting confused by the entire system.

After (8 words):
> Modular: ✓ easier maintenance, ✓ isolated concerns

---

## Descriptions: Key to Discovery

Claude uses descriptions to decide when to invoke your Skill. Make it specific.

### Specific Description Checklist

- [ ] What does it do? (specific capabilities)
- [ ] When to use? (triggers, contexts)
- [ ] Key terms? (what would user mention?)
- [ ] Third person? ("Processes" not "I can process")
- [ ] Under 1024 chars?

### Examples

**Too vague:**
```yaml
description: Helps with documents
```

**Specific:**
```yaml
description: Extract text and tables from PDF files, fill form fields, merge multiple PDFs. Use when working with PDF files, forms, or document extraction.
```

---

## Executable Scripts in Skills

### When to Bundle Scripts

Provide pre-made scripts for:
- Deterministic operations (validation, transformation)
- Error-prone tasks (database migrations)
- Consistency (same behavior every time)
- Efficiency (no code generation needed)

### Error Handling Pattern

**Good: Handles errors explicitly**
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
    return open(path).read()  # Will fail
```

### Script Documentation

Clearly state:
- **Execute the script:** "Run `analyze_form.py` to extract fields"
- **Read as reference:** "See `analyze_form.py` for extraction algorithm"

Most utility scripts should be executed, not read.

---

## Verification Checklist

Before sharing a Skill:

### Core Quality
- [ ] Name follows conventions (gerund or noun phrase)?
- [ ] Description specific and includes key terms?
- [ ] Description includes both WHAT and WHEN?
- [ ] SKILL.md under 500 lines?
- [ ] Additional content in separate files?
- [ ] No time-sensitive information?
- [ ] Consistent terminology?
- [ ] Examples concrete, not abstract?
- [ ] File references one level deep?

### Testing
- [ ] Tested with real usage scenarios?
- [ ] Claude discovers it when expected?
- [ ] Works well with all target models (Haiku, Sonnet, Opus)?
- [ ] Team feedback incorporated (if applicable)?

### Content
- [ ] No framework basics or library docs?
- [ ] Every line adds unique value?
- [ ] Delta principle applied (non-inferrable only)?
- [ ] Progressive disclosure used effectively?

---

## Iteration Pattern: Develop Skills with Claude

1. **Complete a task** without a Skill
2. **Identify reusable patterns** from the work
3. **Ask Claude to create a Skill** capturing those patterns
4. **Review for conciseness** - remove explanations Claude knows
5. **Improve information architecture** - split into reference files
6. **Test on similar tasks** - observe if Claude finds right info
7. **Iterate based on observation** - if Claude struggles, refine

**Why this works:** Claude understands both writing Skills and what agents need. You provide domain expertise, Claude refines the form.

---

## Common Pitfalls to Avoid

### Over-Documentation
- ✗ Framework tutorials
- ✗ Library API docs (reference official instead)
- ✗ Standard patterns (REST, CRUD, MVC)
- ✗ Language features (loops, types)

### Wrong Granularity
- **Too vague:** "Auth happens" (not actionable)
- **Too specific:** Every implementation detail (dead weight)
- **Right:** High-level constraints + key patterns (survives refactors)

### Nested References
- ✗ Bad: SKILL.md → advanced.md → details.md
- ✓ Good: SKILL.md → advanced.md (direct)

Keep reference files one level deep from SKILL.md.

### Tool References
Always use fully qualified MCP tool names:
- ✓ `BigQuery:bigquery_schema`
- ✓ `GitHub:create_issue`
- ✗ `bigquery_schema` (ambiguous, may fail)

---

## File Size Guidelines

| Scope | Ideal | Too Small | Too Large |
|-------|-------|-----------|-----------|
| SKILL.md | Under 500 | Not applicable | Split into reference files |
| reference.md | 100-300 | <50 | Split by domain or feature |
| Other files | 100-200 | <30 merge | >250 split |

---

## Next Steps

1. Review [best-practices.md](best-practices.md) for authoring principles
2. Check [SKILL.md](SKILL.md) for quick reference matrices
3. Create your first Skill using these patterns
4. Test and iterate based on real usage
