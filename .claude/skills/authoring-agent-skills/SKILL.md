---
name: Authoring Agent Skills
description: Create Agent Skills that package domain expertise into reusable capabilities Claude can discover and use automatically. Use when building custom Skills, organizing domain knowledge, or structuring specialized procedures for Claude.
---

# Authoring Agent Skills

**Focused capability:** Write Skills that Claude discovers and uses when relevant to requests.

Agent Skills are modular capabilities that extend Claude's functionality. Each Skill packages instructions, metadata, and optional resources (scripts, templates) that Claude uses automatically when relevant. Unlike prompts (conversation-level instructions), Skills load on-demand and eliminate repetition across conversations.

---

## How Agent Skills Work

### Three-Level Progressive Disclosure

Skills use a filesystem-based architecture with three loading levels:

**Level 1: Metadata (Always loaded at startup)**
- YAML frontmatter: `name` and `description`
- Loaded automatically with system prompt
- ~100 tokens per Skill
- Enables Claude to know what Skills exist and when to use them

**Level 2: Instructions (Loaded when Skill is triggered)**
- Main body of SKILL.md
- Loaded when user request matches Skill's description
- Contains procedural knowledge, workflows, best practices, guidance
- Claude reads via bash: `bash: read skill-name/SKILL.md`
- Keep under 500 lines for optimal performance

**Level 3: Resources (Loaded as needed)**
- Additional files (reference.md, examples.md, templates)
- Executable scripts in `scripts/` directory
- Loaded only when referenced in instructions
- Scripts are executed (output enters context, code does not)
- No practical limit on bundled content since unused files don't consume tokens

**Example**: User asks "Extract text from this PDF."
1. Claude reads metadata: "PDF Processing - Extract text and tables from PDF files..."
2. Matches user request, loads SKILL.md
3. Sees reference to `ADVANCED.md` but doesn't need it
4. Executes instructions from SKILL.md

---

## Skill Structure

### Required File: SKILL.md

Every Skill requires a `SKILL.md` file with YAML frontmatter and markdown body:

```yaml
---
name: Skill Name (64 chars max)
description: What it does + when to use (1024 chars max)
---

# Skill Name

[Markdown body with instructions]
```

### YAML Frontmatter

**`name`** (64 chars max)
- Human-readable name for reference
- Use gerund form: "Processing PDFs", "Analyzing spreadsheets"
- Or noun phrase: "PDF Processing", "Spreadsheet Analysis"
- Avoid: "Helper", "Utils", "Tools"

**`description`** (1024 chars max, CRITICAL for discovery)
- What the Skill does (specific capabilities, not vague)
- When to use it (triggers, contexts, key terms)
- Written in third person (for system prompt injection)
- Claude uses this to select from 100+ potential Skills

**Good descriptions:**
```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

**Bad descriptions:**
```yaml
description: Helps with documents
description: Processes data
description: Does stuff with files
```

### SKILL.md Body

Keep under 500 lines. Structure:

1. **What it does** - Specific capability (1-2 sentences)
2. **Quick start** - Minimal working example
3. **Core workflows** - 1-3 main procedures
4. **Advanced features** - Links to additional files if needed

**Minimal example:**

```markdown
# PDF Processing

## What it does
Extracts text and tables from PDFs using pdfplumber.

## Quick start

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Extracting tables
[Instructions...]

## Advanced features
- Form filling: See [FORMS.md](FORMS.md)
- API reference: See [REFERENCE.md](REFERENCE.md)
```

---

## Progressive Disclosure Patterns

Structure Skills using one of three patterns:

### Pattern 1: High-level guide with references

```
skill-name/
├── SKILL.md (overview + quick start)
├── ADVANCED.md (detailed workflows)
└── REFERENCE.md (API documentation)
```

SKILL.md contains high-level guidance. References to other files load only when needed.

### Pattern 2: Domain-specific organization

For multi-domain Skills, organize by domain to keep context focused:

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── domains/
    ├── finance.md (revenue, billing)
    ├── sales.md (opportunities, pipeline)
    └── product.md (API usage)
```

When user asks about sales, Claude loads only `sales.md`, not finance or product data.

### Pattern 3: Conditional details

Show basic content, link to advanced:

```markdown
# Word Processing

## Creating documents

Use docx-js. Basic usage:
[Example]

## Tracked changes

See [TRACKED-CHANGES.md](TRACKED-CHANGES.md)
```

---

## Core Principles

### Concise is key

The context window is shared. Only add what Claude doesn't already know.

**Good (50 tokens):**
```markdown
## Extract text

Use pdfplumber:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
```

**Bad (150+ tokens):**
```markdown
## Extract text

PDF files are a common format. To extract text, you need a library.
Many libraries exist, but pdfplumber is recommended because...
First, install it using pip. Then you can use...
```

Default assumption: Claude is already very smart.

### Set appropriate degrees of freedom

Match specificity to task fragility:

**High freedom** (multiple valid approaches)
- Use heuristics, text-based guidance
- Example: "1. Analyze code structure 2. Check for bugs 3. Suggest improvements"

**Medium freedom** (preferred pattern with variation)
- Use templates with parameters
- Example: Code template that Claude can customize

**Low freedom** (specific sequence required)
- Fragile or error-prone operations
- Example: "Run exactly this script: `python migrate.py --verify --backup`"

### Test with all models

Skills effectiveness depends on the underlying model:

- **Claude Haiku** (fast): Does the Skill provide enough guidance?
- **Claude Sonnet** (balanced): Is it clear and efficient?
- **Claude Opus** (powerful): Does it avoid over-explaining?

Test with all models you plan to use.

---

## Skill Resources

### Optional: Bundled scripts

Include pre-made scripts for deterministic operations:

```
skill-name/
└── scripts/
    ├── validate.py
    ├── extract.py
    └── process.sh
```

Scripts are **executed** (not loaded into context). Only output enters context, making scripts efficient for error-prone or complex operations.

### Optional: Additional files

Organize detailed content in separate files:

- `REFERENCE.md` - API documentation, complete patterns
- `EXAMPLES.md` - Usage examples, templates
- `ADVANCED.md` - Complex workflows, edge cases

Claude loads these only when referenced. No token penalty for unused files.

---

## Quick Start: Create Your First Skill

1. **Choose a capability** - Something you explain repeatedly
2. **Create directory**: `my-skill/`
3. **Write SKILL.md** with:
   - YAML frontmatter (name + specific description)
   - What it does (1-2 sentences)
   - Quick start (minimal working example)
   - Link to advanced files if needed
4. **Test discovery**:
   - Does your description match what users would ask?
   - Does Claude load it when relevant?
5. **Add advanced files** only if SKILL.md approaches 500 lines

---

## Next Steps

For detailed patterns and principles:
- See [reference.md](reference.md) for structure patterns and organization
- See [best-practices.md](best-practices.md) for writing principles
- See [official-agent-skills.md](official-agent-skills.md) for complete official architecture

For examples and getting started:
- See [Agent Skills Cookbook](https://github.com/anthropics/claude-cookbooks/tree/main/skills) for community examples
- See [official Anthropic documentation](https://docs.anthropic.com) for API integration
