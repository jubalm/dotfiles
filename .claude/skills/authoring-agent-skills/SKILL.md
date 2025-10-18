---
name: Authoring Agent Skills
description: Create a Skill that Claude discovers and uses automatically. Use when building custom Skills, packaging domain expertise, or creating reusable procedures.
---

# Authoring Agent Skills

Create Skills that Claude discovers and uses when relevant.

---

## What Is a Skill?

Modular capability: procedure + metadata + optional resources.

Claude loads in 3 levels:
- **Metadata** (always): name + description
- **Instructions** (when triggered): SKILL.md body
- **Resources** (on-demand): files + scripts

---

## Create Your Skill: 5 Steps

### Step 1: Decide the Capability

What do you explain repeatedly? That's your Skill.

- NOT: "Helps with documents" ✗
- YES: "Extract text from PDFs" ✓

### Step 2: Create Directory

```bash
mkdir ~/.claude/skills/my-skill
```

### Step 3: Write SKILL.md Frontmatter

```yaml
---
name: PDF Text Extraction
description: Extract text and tables from PDF files. Use when working with PDF files or when the user mentions PDFs, text extraction, or document parsing.
---
```

**Description rules:**
- Specific capabilities + when to use
- Third person ("Extracts...", not "I can extract")
- Include words users actually say

### Step 4: Write the Procedure

Keep body under 500 lines. Structure:

```markdown
# PDF Text Extraction

## What it does
Extracts text from PDFs using pdfplumber.

## How to use

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    # Extract text from first page
    text = pdf.pages[0].extract_text()

    # Extract all text
    full_text = ""
    for page in pdf.pages:
        full_text += page.extract_text()
```

## Extract tables

```python
with pdfplumber.open("file.pdf") as pdf:
    tables = pdf.pages[0].extract_tables()
```

## Advanced

For complex workflows: See [ADVANCED.md](ADVANCED.md)
```

### Step 5: Test Discovery

Does Claude load it?

```
"Extract text from this PDF"
→ Claude loads your Skill ✓
```

---

## File Organization

**Minimal (start here):**
```
my-skill/
└── SKILL.md
```

**With details (SKILL.md > 400 lines):**
```
my-skill/
├── SKILL.md (overview + quick examples)
├── ADVANCED.md (complex workflows)
└── REFERENCE.md (complete patterns)
```

**With scripts (error-prone operations):**
```
my-skill/
├── SKILL.md
└── scripts/
    └── validate.py
```

Claude reads referenced files only when needed. Unused files = 0 tokens.

---

## Writing Rules

### Concise

Assume Claude is smart. Only add what Claude doesn't know.

**Good (50 tokens):**
```markdown
Use pdfplumber:

```python
import pdfplumber
pdf = pdfplumber.open("file.pdf")
text = pdf.pages[0].extract_text()
```
```

**Bad (150+ tokens):**
```markdown
PDF files are documents. You need a library to read them.
Many libraries exist. We recommend pdfplumber because it's easy
to use and handles most cases well...
```

### Degrees of Freedom

Match specificity to fragility:

**High freedom** (multiple approaches OK)
- "Analyze code for bugs, style, and performance"

**Low freedom** (exact steps required)
- "Run this script: `python migrate.py --verify --backup`"

### Test with All Models

- **Haiku**: Enough guidance?
- **Sonnet**: Clear and efficient?
- **Opus**: Avoid over-explaining?

---

## Examples

### Simple Skill

```yaml
---
name: Git Commit Messages
description: Generate semantic commit messages from git diffs. Use when making commits or writing conventional commit messages.
---

# Git Commit Messages

## Structure
- `feat(scope): description` - New feature
- `fix(scope): description` - Bug fix
- `docs: description` - Documentation

## Example

Analyze staged changes:
```bash
git diff --staged
```

Suggest: `feat(auth): add oauth login`

## Details

See [COMMITS.md](COMMITS.md) for complex commits.
```

### Multi-Domain Skill

```
analytics-skill/
├── SKILL.md (navigation)
└── domains/
    ├── sales.md (pipeline, revenue)
    ├── finance.md (billing, ARR)
    └── product.md (usage, features)
```

SKILL.md:
```markdown
---
name: Analytics Data Query
description: Query analytics data for sales, finance, or product metrics. Use when asking about pipeline, revenue, billing, API usage, or feature adoption.
---

# Analytics Data Query

## Available domains

**Sales**: Pipeline and revenue → See [domains/sales.md](domains/sales.md)
**Finance**: Billing and ARR → See [domains/finance.md](domains/finance.md)
**Product**: Usage and features → See [domains/product.md](domains/product.md)

## Search

```bash
grep -r "revenue" domains/finance.md
grep -r "pipeline" domains/sales.md
```
```

---

## What NOT to Do

❌ Explain how Skills work (that's documentation)
❌ Include framework tutorials or library docs
❌ Make it longer than 500 lines for SKILL.md
❌ Nest references: SKILL.md → advanced.md → details.md
❌ Use vague descriptions: "Helps with documents"
❌ Use first person: "I can extract PDFs"

---

## Verify Before Using

- [ ] Description specific + includes key terms?
- [ ] SKILL.md under 500 lines?
- [ ] Procedure is step-by-step, not theory?
- [ ] Quick example works end-to-end?
- [ ] Claude discovers it with your description?
- [ ] Tested with Haiku + Sonnet?

---

## Next Steps

1. Create directory: `~/.claude/skills/your-skill/`
2. Write SKILL.md with procedure (not explanation)
3. Include 1-2 concrete examples
4. Test discovery: does Claude find it?
5. Add ADVANCED.md only if > 400 lines needed

See [reference.md](reference.md) for patterns and organization details.
