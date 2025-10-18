# Agent Skills: Reference

Supporting details and patterns for Skill authoring.

**Primary guide:** See [SKILL.md](SKILL.md) for the core concepts and quick start.

---

## Filesystem-Based Architecture

### How Claude Accesses Skills

Skills exist as directories on a virtual machine. Claude navigates using bash commands:

1. **Startup**: System prompt includes metadata for all available Skills
2. **User request**: Claude matches against Skill descriptions
3. **Triggering**: Claude reads SKILL.md via bash: `bash: read skill-name/SKILL.md`
4. **On-demand**: Claude reads additional files only when referenced
5. **Execution**: Scripts in `scripts/` are executed via bash (output only)

### Directory Structure Example

```
pdf-skill/
├── SKILL.md (metadata + instructions)
├── FORMS.md (form-filling guide)
├── REFERENCE.md (API documentation)
├── EXAMPLES.md (usage patterns)
└── scripts/
    ├── extract.py (extraction script)
    ├── validate.py (validation script)
    └── fill_form.py (form filling script)
```

**Loading behavior:**
- Metadata: Always pre-loaded
- SKILL.md: Loaded when user request matches
- FORMS.md, REFERENCE.md, EXAMPLES.md: Loaded only if referenced
- Scripts: Executed via bash; output enters context, code does not

---

## Progressive Disclosure Patterns

### Complete Pattern Reference

**Pattern 1: High-level guide with references**

```
skill-name/
├── SKILL.md (overview, quick start)
├── ADVANCED.md (detailed workflows)
└── REFERENCE.md (complete API)
```

SKILL.md structure:
```markdown
# PDF Processing

## Quick start
[Minimal example]

## Advanced features

**Form filling**: See [FORMS.md](FORMS.md)
**API reference**: See [REFERENCE.md](REFERENCE.md)
**Examples**: See [EXAMPLES.md](EXAMPLES.md)
```

**Pattern 2: Domain-specific organization**

Use for Skills with multiple, unrelated domains:

```
analytics-skill/
├── SKILL.md (overview, navigation)
└── domains/
    ├── finance.md (revenue, billing)
    ├── sales.md (opportunities)
    └── product.md (API usage)
```

SKILL.md structure:
```markdown
# Analytics Data

## Available domains

**Finance**: Revenue, ARR, billing → See [domains/finance.md](domains/finance.md)
**Sales**: Pipeline, opportunities → See [domains/sales.md](domains/sales.md)
**Product**: API usage, features → See [domains/product.md](domains/product.md)

## Quick search

```bash
grep -i "revenue" domains/finance.md
grep -i "pipeline" domains/sales.md
```
```

**Pattern 3: Conditional details**

Use for Skills with basic + advanced variations:

```
docx-skill/
├── SKILL.md (basic usage)
├── REDLINING.md (tracked changes)
└── OOXML.md (advanced formatting)
```

SKILL.md structure:
```markdown
# Word Processing

## Creating documents

Use docx-js:
[Basic example]

## Advanced features

**Tracked changes**: See [REDLINING.md](REDLINING.md)
**Complex formatting**: See [OOXML.md](OOXML.md)
```

---

## Skill Metadata Fields

### `name` Field

- Maximum 64 characters
- Human-readable identifier
- Use gerund form: "Processing PDFs", "Analyzing spreadsheets"
- Alternatives: noun phrase ("PDF Processing") or action ("Process PDFs")
- Avoid: "Helper", "Utils", "Tools" (too vague)

### `description` Field

**CRITICAL for discovery** - Claude uses this to select from 100+ Skills.

- Maximum 1024 characters
- Must include: WHAT (specific capabilities) + WHEN (triggers, contexts)
- Write in third person (injected into system prompt)
- Include specific terms users mention
- Avoid vague language

**Structure:**
```
description: [Action verb] [specific capability], [more capabilities]. Use when [trigger 1], [trigger 2], or [user mention words].
```

**Examples:**

PDF Processing:
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

Excel Analysis:
```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

Git Commit Helper:
```yaml
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

---

## Writing SKILL.md Body

### Structure Guidelines

Keep SKILL.md under 500 lines total. Organize as:

1. **What it does** (1-2 sentences)
   - Specific, clear capability
   - Not vague or generic

2. **Quick start** (minimal working example)
   - Most common use case
   - 20-50 lines maximum
   - Users can understand in 30 seconds

3. **Core workflows** (1-3 main procedures)
   - Step-by-step instructions
   - Real examples
   - Common variations

4. **Advanced features** (links to additional files)
   - Don't include in SKILL.md body
   - Reference external files: "See [ADVANCED.md](ADVANCED.md)"

### Conciseness Principles

**Default assumption**: Claude is already very smart.

Only include knowledge Claude wouldn't have:

**Too verbose (150+ tokens):**
```markdown
## Extract text

PDF (Portable Document Format) files are a common format containing text
and images. To extract text, you need a library. Many libraries exist for
PDF processing. We recommend pdfplumber because it's easy to use and handles
most cases well. First, install it using pip. Then you can use the code below...
```

**Concise (50 tokens):**
```markdown
## Extract text

Use pdfplumber:
```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Questions to ask:**
- Does Claude really need this explanation?
- Can I assume Claude knows this?
- Does this paragraph justify its token cost?

---

## Setting Degrees of Freedom

### High Freedom

Use when multiple valid approaches exist and context determines best choice:

- Guidance is text-based heuristics
- Claude makes context-dependent decisions
- Example: Code review process

```markdown
## Code review process

1. Analyze code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability
4. Verify adherence to project conventions
```

### Medium Freedom

Use when preferred pattern exists with acceptable variation:

- Templates with customization points
- Configuration affects behavior
- Example: Report generation

```python
def generate_report(data, format="markdown", include_charts=True):
    # Process data
    # Generate output in specified format
    # Optionally include visualizations
```

### Low Freedom

Use when operations are fragile or sequence is critical:

- Error-prone or deterministic operations
- Consistency is critical
- Exact steps must be followed
- Example: Database migration

```bash
# Run exactly this script:
python scripts/migrate.py --verify --backup

# Do not modify or add flags
```

---

## Bundled Resources

### Executable Scripts

Include in `scripts/` directory for:

- Deterministic, error-prone operations
- Complex transformations without code generation
- Consistency requirements
- Operations where output > code

Scripts are **executed**, not loaded. Only output enters context.

**Good script:**
```python
def validate_form(pdf_path):
    try:
        # Validate form structure
        return "Validation passed"
    except Exception as e:
        return f"Validation failed: {e}"
```

**Reference in SKILL.md:**
```markdown
## Validate forms

Run validation:
```bash
python scripts/validate.py form.pdf
```
```

### Additional Markdown Files

Use for content too large or specialized for SKILL.md:

- `REFERENCE.md` - Complete API documentation
- `EXAMPLES.md` - Usage patterns and templates
- `ADVANCED.md` - Complex workflows, edge cases
- `TROUBLESHOOTING.md` - Error handling, FAQ

**Reference from SKILL.md:**
```markdown
## Advanced usage

See [ADVANCED.md](ADVANCED.md) for complex workflows and edge cases.
```

---

## Testing Skills

### Test with all models

Skills effectiveness depends on underlying model:

| Model | Guidance Needs |
|-------|---|
| **Claude Haiku** | More explicit, clear guidance |
| **Claude Sonnet** | Moderate detail, balanced |
| **Claude Opus** | Avoid over-explaining, challenge enough |

Write Skills that work well with all models you intend to use.

### Verify discovery

Before using a Skill widely:

1. Test with description keywords
   - "Use [skill name]" - does it load?
2. Test with related phrasing
   - Different ways users might describe need
3. Verify execution
   - Does the Skill actually work?
   - Are examples correct?

---

## Anti-Patterns to Avoid

### Over-Documentation

Don't include:
- Framework tutorials (React, Django, etc.)
- Library API docs (link to official instead)
- Standard patterns (REST, CRUD, MVC)
- Language basics (syntax, types, loops)

**Only document delta** - what's unique to this Skill.

### Nested References

Bad (don't do this):
```
SKILL.md → ADVANCED.md → DETAILS.md
```

Good (one level):
```
SKILL.md → ADVANCED.md
SKILL.md → REFERENCE.md
SKILL.md → EXAMPLES.md
```

Nested references cause Claude to skip or read incomplete content.

### Vague Names

Bad Skill names:
- "Helper"
- "Utils"
- "Tools"
- "Documents"
- "Data"

Good Skill names:
- "Processing PDFs"
- "Analyzing spreadsheets"
- "Testing code"
- "Writing documentation"

### Assuming Tools are Installed

**Bad:**
```markdown
Use the pdf library
```

**Good:**
```markdown
Install: `pip install pypdf`

Then:
```python
from pypdf import PdfReader
```
```

---

## Related Resources

- [SKILL.md](SKILL.md) - Core concepts and quick start
- [best-practices.md](best-practices.md) - Writing principles
- [official-agent-skills.md](official-agent-skills.md) - Complete official documentation
- [Agent Skills Cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills) - Community examples
