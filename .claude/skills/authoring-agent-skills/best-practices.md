# Skill Authoring Best Practices

Principles for writing Skills that Claude discovers and uses effectively in real workflows.

---

## Core Principles

### 1. Concise is Key

**Challenge each line:** Does Claude need this? Can Claude infer this?

**Default assumption:** Claude is already very smart.

**Good example (concise, 50 tokens):**
```markdown
## Extract PDF text

Use pdfplumber:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Bad example (verbose, 150+ tokens):**
```markdown
## Extract PDF text

PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available, but pdfplumber is recommended
because it's easy to use and handles most cases well. First, you'll need to
install it using pip. Then you can use...
```

The concise version assumes Claude knows PDFs and libraries already.

### 2. Set Appropriate Degrees of Freedom

Match specificity to task fragility and variability.

**High freedom (text instructions):**
- Multiple approaches are valid
- Decisions depend on context
- Use heuristics, not rules

Example:
```markdown
## Code review process

1. Analyze code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability and maintainability
4. Verify adherence to project conventions
```

**Medium freedom (templates with parameters):**
- Preferred pattern exists
- Some variation is acceptable
- Configuration affects behavior

Example:
```markdown
## Generate report

Use this template and customize as needed:
```python
def generate_report(data, format="markdown", include_charts=True):
    # Process data
    # Generate output in specified format
```
```

**Low freedom (specific scripts):**
- Operations are fragile and error-prone
- Consistency is critical
- Specific sequence must be followed

Example:
```markdown
## Database migration

Run exactly this script:
```bash
python scripts/migrate.py --verify --backup
```

Do not modify the command or add additional flags.
```

**Analogy:**
- Narrow bridge with cliffs on both sides = Low freedom, exact guardrails needed
- Open field with no hazards = High freedom, general direction sufficient

### 3. Test with All Models

Skills effectiveness depends on the underlying model. Test with:
- **Claude Haiku** - Fast, economical. Needs enough guidance?
- **Claude Sonnet** - Balanced. Clear and efficient?
- **Claude Opus** - Powerful reasoning. Avoid over-explaining?

What works for Opus might need more detail for Haiku. Aim for instructions that work across all.

---

## Writing Effective Descriptions

The `description` field is **critical for discovery.** Claude uses it to choose your Skill from potentially 100+ available Skills.

### Required Elements

1. **What it does** - Specific capabilities
2. **When to use** - Triggers and contexts
3. **Key terms** - Words user might mention

### Examples

**PDF Processing:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Excel Analysis:**
```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

**Git Commit Helper:**
```yaml
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

**Avoid vague descriptions:**
```yaml
description: Helps with documents      # Too generic
description: Processes data             # Too generic
description: Does stuff with files     # Too vague
```

### Write in Third Person

The description is injected into the system prompt. Keep consistent point-of-view.

- ✓ **Good:** "Processes Excel files and generates reports"
- ✗ **Avoid:** "I can help you process Excel files"
- ✗ **Avoid:** "You can use this to process Excel files"

---

## Content Quality Guidelines

### Delta Principle: Only Document Non-Inferrable Knowledge

**Ask:** Would Claude miss this by inspection or training?

If no → Don't document it.
If yes → Include it.

### Density Principles

**Prefer:**
- Code over prose (show, don't explain)
- Bullets over paragraphs (one idea per line)
- Fragments over sentences (remove the, a, an, is, are)
- Symbols over words (✓, ✗, →, :)

**Example:**

Before: "The reason we use the modular approach is because it makes maintenance easier, and it allows developers to understand one concern at a time without getting confused by the entire system." (27 words)

After: "Modular: ✓ easier maintenance, ✓ isolated concerns" (8 words)

### Terminal Values

- **Every line must justify its token cost**
- **No framework basics or library docs** (Claude knows these)
- **No standard patterns** (REST, CRUD, MVC)
- **Focus on deltas** (unique to this Skill)

---

## Progressive Disclosure Strategy

### Why It Works

1. **Metadata pre-loaded** - Name and description always available
2. **Files read on-demand** - Claude accesses content only when needed
3. **No context penalty** - Large files don't consume tokens until read
4. **Focused reading** - Claude loads exactly what each task requires

### Structure for Progressive Disclosure

```
my-skill/
├── SKILL.md (100-200 lines)
│   ├── Quick reference
│   ├── Examples
│   └── Links to reference files
│
├── reference.md (detailed guide)
├── examples.md (usage patterns)
├── workflows.md (multi-step procedures)
└── scripts/ (utilities)
```

**Claude loads files on-demand** - reference.md only when user asks about advanced features.

---

## Testing and Iteration

### Build Evaluations First

Create test scenarios BEFORE extensive documentation:

1. **Identify gaps** - Where does Claude fail without the Skill?
2. **Create evaluations** - 3 representative scenarios
3. **Establish baseline** - Measure without Skill
4. **Write minimal instructions** - Just enough to pass evaluations
5. **Iterate** - Execute evaluations, compare, refine

### Develop Skills Iteratively with Claude

**Process:**
1. Complete a task without a Skill (note context you provide)
2. Identify reusable patterns from that work
3. Ask Claude to create a Skill capturing those patterns
4. Review for conciseness (remove known knowledge)
5. Test on similar tasks (observe Claude's behavior)
6. Iterate based on observations

**Why this works:** Claude understands both Skill format and what agents need.

### Observe How Claude Uses Your Skill

Pay attention to:
- **Unexpected exploration paths** - Does Claude read files in order you predicted?
- **Missed connections** - Does Claude follow references?
- **Overreliance** - Does Claude read same file repeatedly?
- **Ignored content** - Do bundled files go unread?

Iterate based on **observations, not assumptions.**

---

## Organization Patterns

### One Capability per Skill

**Focused:**
- "PDF form filling"
- "Excel data analysis"
- "Git commit messages"

**Too broad:**
- "Document processing" (split into Skills)
- "Data tools" (split by type or operation)

### File Reference Depth

**Keep one level deep from SKILL.md:**

✗ Bad (too nested):
```
SKILL.md → advanced.md → details.md
```

✓ Good (direct):
```
SKILL.md → advanced.md
           → reference.md
           → examples.md
```

When Claude encounters nested references, it might use `head -100` to preview instead of reading complete files.

### Large Reference Files

For files >100 lines, include table of contents:

```markdown
# API Reference

## Contents
- Authentication and setup
- Core methods (create, read, update)
- Advanced features (batch, webhooks)
- Error handling patterns

## Authentication and setup
...

## Core methods
...
```

Claude can then read complete file or jump to sections as needed.

---

## Anti-Patterns to Avoid

### Windows-Style Paths

Always use forward slashes:
- ✓ `scripts/helper.py`
- ✗ `scripts\helper.py`

Unix-style paths work on all platforms. Windows-style breaks on Unix.

### Too Many Options

Don't present multiple approaches unless necessary:

✗ "You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image..."

✓ "Use pdfplumber for text extraction:
```python
import pdfplumber
```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead."

### Assuming Tools Are Installed

Don't assume packages are available:

✗ "Use the pdf library to process the file."

✓ "Install required package: `pip install pypdf`

Then use it:
```python
from pypdf import PdfReader
```"

### MCP Tool Names

Always use fully qualified names:
- ✓ `BigQuery:bigquery_schema`
- ✓ `GitHub:create_issue`
- ✗ `bigquery_schema` (ambiguous)

---

## Reflection Checklist

Before sharing a Skill, ask:

**Discovery & Clarity**
- [ ] Would Claude discover this Skill for the right requests?
- [ ] Is the description specific and actionable?
- [ ] Does description include both WHAT and WHEN?

**Content Quality**
- [ ] Is every line necessary? (Token efficiency)
- [ ] No framework basics or library docs?
- [ ] Delta principle applied? (Non-inferrable only)
- [ ] Consistent terminology throughout?

**Structure**
- [ ] SKILL.md under 500 lines?
- [ ] Reference files separate and focused?
- [ ] File references one level deep?
- [ ] Table of contents in long reference files?

**Accessibility**
- [ ] Examples concrete, not abstract?
- [ ] Code examples complete and runnable?
- [ ] Workflows have clear steps?
- [ ] Scripts have error handling?

**Testing**
- [ ] Tested with real scenarios?
- [ ] Tested with Haiku, Sonnet, Opus?
- [ ] Team feedback incorporated (if applicable)?

---

## Key Takeaway

**Great Skills are concise, focused, and observable.**

Write minimal SKILL.md that Claude can discover. Bundle detailed references on-demand. Test with real usage and iterate based on how Claude actually uses your Skill.
