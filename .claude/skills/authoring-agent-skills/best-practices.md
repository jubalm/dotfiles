# Agent Skills: Best Practices

Principles for writing Skills that Claude discovers and uses effectively.

**Foundation:** See [SKILL.md](SKILL.md) for architecture and structure.

---

## Core Principles

### 1. Concise is Key

**Challenge every line:** Does Claude need this? Can Claude infer this?

**Default assumption:** Claude is already very smart.

The context window is shared. Only add what Claude doesn't already have.

**Good (concise):**
```markdown
## Extract PDF text

Use pdfplumber:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Bad (verbose):**
```markdown
## Extract PDF text

PDF files are a common format containing text and images. To extract text,
you need a library. Many libraries exist, but pdfplumber is recommended
because it's easy to use and handles most cases well. First, install it
using pip. Then you can use...
```

The concise version assumes Claude knows what PDFs are and how libraries work.

### 2. Set Appropriate Degrees of Freedom

Match specificity to the task's fragility and variability.

**High freedom** (multiple approaches valid)
- Use heuristics, text-based guidance
- Decisions depend on context
- Example: Code review process

**Medium freedom** (preferred pattern with variation)
- Use templates with parameters
- Some variation acceptable
- Configuration affects behavior
- Example: Report generation with options

**Low freedom** (specific sequence required)
- Operations are fragile or error-prone
- Consistency is critical
- Exact sequence must be followed
- Example: Database migration (run exact script)

**Analogy:**
- Narrow bridge with cliffs = low freedom (exact guardrails needed)
- Open field with no hazards = high freedom (general direction sufficient)

### 3. Test with All Models You Plan to Use

Skills effectiveness depends on the underlying model:

- **Claude Haiku** (fast, economical): Does the Skill provide enough guidance?
- **Claude Sonnet** (balanced): Is the Skill clear and efficient?
- **Claude Opus** (powerful): Does the Skill avoid over-explaining?

What works for Opus might need more detail for Haiku. Test with all.

---

## Writing Descriptions

The `description` field is **critical for discovery**. Claude uses it to select your Skill from 100+ potential Skills.

### Structure

```
description: [What it does] + [Specific capabilities]. Use when [triggers/contexts] or [user mentions].
```

### Key Ingredients

- **Action verb** - "Processes", "Analyzes", "Generates" (not "Helps with")
- **Specific capability** - "Excel spreadsheets" (not just "data")
- **When to use** - Triggers and contexts that users mention
- **Key terms** - Words users actually speak

### Examples

**Specific, discoverable:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

```yaml
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

**Vague, not discoverable:**
```yaml
description: Helps with documents
description: Processes data
description: Does stuff with files
```

### Write in Third Person

The description is injected into the system prompt. Keep consistent point-of-view.

- ✓ **Good:** "Processes Excel files and generates reports"
- ✗ **Avoid:** "I can help you process Excel files"
- ✗ **Avoid:** "You can use this to process Excel files"

---

## SKILL.md Structure

### Keep Under 500 Lines

Once Claude loads SKILL.md, every token competes with conversation history and other context.

**Guidelines:**
- SKILL.md body: Under 500 lines
- Approaching limit? Split into reference files
- Use progressive disclosure patterns (see reference.md)

### Recommended Structure

1. **What it does** (1-2 sentences)
   - Clear, specific capability
   - Not generic

2. **Quick start** (minimal example)
   - Most common use case
   - 20-50 lines maximum
   - Can understand in 30 seconds

3. **Core workflows** (1-3 main procedures)
   - Step-by-step instructions
   - Real examples
   - Common variations

4. **Advanced features** (links only)
   - "See [ADVANCED.md](ADVANCED.md) for..."
   - Don't include full content in SKILL.md

### Naming Conventions

**For Skill name:**
- Gerund form (preferred): "Processing PDFs", "Analyzing spreadsheets"
- Noun phrase: "PDF Processing", "Spreadsheet Analysis"
- Action form: "Process PDFs", "Analyze Spreadsheets"
- Avoid: "Helper", "Utils", "Tools", "Documents", "Data"

---

## Content Organization

### When to Use Progressive Disclosure Patterns

See [reference.md](reference.md) for complete pattern details.

**Pattern 1:** High-level guide with references
- Use when: Single domain with specialized topics
- Structure: SKILL.md → ADVANCED.md, REFERENCE.md

**Pattern 2:** Domain-specific organization
- Use when: Multiple unrelated domains (sales vs. finance)
- Structure: SKILL.md → domains/sales.md, domains/finance.md

**Pattern 3:** Conditional details
- Use when: Basic usage + advanced variations
- Structure: SKILL.md → ADVANCED.md, EDGE_CASES.md

### Bundling Scripts

Include in `scripts/` directory for error-prone, deterministic operations:

**Good use cases:**
- Complex transformations
- Operations requiring exact error handling
- Consistency-critical operations

**Why scripts work:**
- Scripts are **executed** (not loaded into context)
- Only output enters context
- No token penalty for script code
- Far more efficient than code generation

---

## Common Pitfalls

### Over-Documentation

Don't include content Claude already knows:
- Framework tutorials or API docs (link to official)
- Standard patterns (REST, CRUD, MVC)
- Language features (syntax, types)
- Basic library usage

**Focus on delta:** What's unique to this Skill?

### Too Many Options

**Bad:**
```markdown
You can use pypdf, pdfplumber, PyMuPDF, or pdf2image...
```

**Good:**
```markdown
Use pdfplumber for text extraction.

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

### Nested References

Don't nest references beyond one level:

✗ Bad:
```
SKILL.md → ADVANCED.md → DETAILS.md
```

✓ Good:
```
SKILL.md → ADVANCED.md
SKILL.md → REFERENCE.md
SKILL.md → EXAMPLES.md
```

### Assuming Tools Are Installed

**Bad:**
```markdown
Use the pdf library to process files
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

## Before Sharing

### Quality Checklist

**Naming & Description**
- [ ] Name follows conventions (gerund or noun)?
- [ ] Description specific and includes key terms?
- [ ] Description includes WHAT and WHEN?
- [ ] Third person throughout?

**Content**
- [ ] SKILL.md under 500 lines?
- [ ] Concise (no tutorial content)?
- [ ] Examples concrete, not abstract?
- [ ] Code examples complete and runnable?

**Structure**
- [ ] Progressive disclosure patterns used?
- [ ] References one level deep from SKILL.md?
- [ ] Large files have table of contents?
- [ ] Scripts have error handling?

**Testing**
- [ ] Tested with Haiku, Sonnet, Opus?
- [ ] Description matches what users would ask?
- [ ] Skill actually works end-to-end?

---

## Quick Summary

Great Skills share these qualities:

1. **Specific description** - Claude can discover it reliably
2. **Concise SKILL.md** - Under 500 lines, focused
3. **Progressive disclosure** - Advanced content in separate files
4. **Tested** - Works across models and with real requests
5. **Focused scope** - One capability, not everything

Write the minimum needed for Claude to succeed, then organize advanced content on-demand.

---

## Related Resources

- [SKILL.md](SKILL.md) - Core architecture and structure
- [reference.md](reference.md) - Pattern details and organization
- [official-agent-skills.md](official-agent-skills.md) - Complete official documentation
