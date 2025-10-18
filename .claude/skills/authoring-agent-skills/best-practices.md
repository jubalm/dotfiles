# Skill Authoring Best Practices

Principles for writing Skills that Claude discovers and uses effectively in real workflows.

---

## #1 Priority: Discoverability

A Skill only exists if Claude finds it. Everything else is secondary.

### The Discovery Challenge

Claude selects from 50+ built-in agents, 20+ user skills, and 10+ project skills. Your skill competes for attention based on a single field: **description**.

**Description determines if your skill is discovered.**

### Writing Discoverable Descriptions

Structure: `What skill does + When to use + Key trigger words`

**Bad (too generic):**
```yaml
description: Helps with data
```

**Good (specific, discoverable):**
```yaml
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when working with Excel files, spreadsheets, or analyzing tabular data in .xlsx format.
```

**Ingredients:**
- **Action verb** - Write, Generate, Create, Analyze (not "Helps with")
- **Specific capability** - "Excel spreadsheets" not just "data"
- **When to use** - Triggers and contexts that prompt user requests
- **Key terms** - Words users actually mention

### Test Discoverability

Before publishing, manually test:
```
1. Invoke with description keywords → Works?
2. Invoke with related phrasing → Works?
3. Without invoking, does Claude use it? → Proactively invoked?
```

See [discovery-checklist.md](discovery-checklist.md) for complete testing guide.

---

## #2 Priority: Content Quality

### Conciseness is Key

**Default assumption:** Claude is already very smart.

**Challenge every line:** Does Claude need this? Can Claude infer this?

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

PDF (Portable Document Format) files are a common file format containing text, images, and other content. To extract text, you'll need a library. Many libraries are available, but pdfplumber is recommended because it's easy to use and handles most cases well. First, install it...
```

The concise version assumes Claude knows PDFs and libraries.

### Delta Principle: Only Non-Inferrable Knowledge

**Ask:** Would Claude miss this by inspection or training?

**Don't document:**
- Framework patterns (React hooks, Django models)
- Library behavior (Stripe API, Firebase)
- Standard architectures (REST, MVC, CRUD)
- Language features (loops, types, syntax)

**Do document:**
- Custom patterns unique to this skill
- Non-obvious decisions (why X over Y?)
- Hard constraints (performance limits, security rules)
- Gotchas and edge cases
- Project-specific configurations

### Density Principles

Maximize value per token:

- **Code over prose** - Show the pattern, don't explain
- **Bullets over paragraphs** - One idea per line
- **Fragments over sentences** - Omit: the, a, an, is, are
- **Symbols over words** - Use `✓` / `✗`, `→`, `:`

**Example:**

Before (27 words):
> The reason we use the modular approach is because it makes maintenance easier and allows developers to understand one concern at a time.

After (8 words):
> Modular: ✓ easier maintenance, ✓ isolated concerns

---

## #3 Priority: Appropriate Structure

### SKILL.md is the Discovery Interface

Keep it under 500 lines. Include:

1. **What It Does** - 1-2 sentences
2. **When to Use** - Specific triggers
3. **Quick Reference** - Table, checklist, or type guide
4. **Minimal Example** - Concrete, realistic scenario (30 seconds to understand)
5. **Links** - To reference files for deeper content

### Progressive Disclosure

Structure for discovery + efficiency:

```
my-skill/
├── SKILL.md (overview, quick reference)
├── reference.md (detailed patterns)
├── examples.md (complete workflows)
└── scripts/ (utilities)
```

**Result:** Claude loads SKILL.md for discovery. Loads reference files only when needed.

### One Level Deep References

**Keep it simple:**
```
SKILL.md → reference.md
        → examples.md
        → workflows.md
```

**Never nest:**
```
SKILL.md → advanced.md → details.md  ✗
```

When Claude encounters nested references, it skips or reads incomplete content.

---

## Principles by Task

### Set Appropriate Freedom Levels

Match specificity to task fragility:

**High freedom (heuristic instructions):**
- Multiple approaches valid
- Decisions depend on context
- Example: Code review process

```markdown
1. Analyze code structure
2. Check for edge cases
3. Suggest improvements
```

**Medium freedom (template + customization):**
- Preferred pattern exists
- Some variation acceptable
- Example: Report generation

```python
def generate_report(data, format="markdown"):
    # Process data
    # Generate output
```

**Low freedom (strict procedures):**
- Operations fragile/error-prone
- Consistency critical
- Example: Database migration

```bash
# Run exactly this:
python scripts/migrate.py --verify --backup
# Do not modify
```

**Analogy:** Narrow bridge with cliffs = low freedom. Open field = high freedom.

### Test with All Models

Skills effectiveness varies by model:

- **Haiku** - Needs clear, concise guidance?
- **Sonnet** - Works well with moderate detail?
- **Opus** - Avoid over-explaining; needs challenge?

Aim for instructions effective across all three.

---

## Testing & Iteration

### Build Evaluations First

Test BEFORE extensive documentation:

1. Identify gaps (where does Claude fail without the skill?)
2. Create 3 representative test scenarios
3. Measure baseline (without skill)
4. Write minimal instructions (just enough to pass)
5. Iterate based on results

### Develop Iteratively with Claude

1. **Complete task manually** - Note context you provide
2. **Identify patterns** - What repeats?
3. **Ask Claude to create Skill** - Capturing those patterns
4. **Review for conciseness** - Remove known knowledge
5. **Test on similar tasks** - Observe Claude's behavior
6. **Iterate** - Based on observations, not assumptions

**Why this works:** Claude understands both skill format and what agents need.

### Observe Real Usage

Pay attention to:
- **Unexpected paths** - Does Claude read files in predicted order?
- **Missed connections** - Does Claude follow references?
- **Overreliance** - Does Claude re-read same file?
- **Ignored content** - Do bundled files go unread?

**Iterate based on observations.**

---

## Anti-Patterns to Avoid

### Over-Documentation
- Framework tutorials
- Library API docs (link to official instead)
- Standard patterns (REST, CRUD, MVC)
- Language features (syntax, types)

### Too Many Options
**Bad:**
```
You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image...
```

**Good:**
```
Use pdfplumber for text extraction.

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

### Nested References
**Bad:**
```
SKILL.md → advanced.md → details.md
```

**Good:**
```
SKILL.md → advanced.md
```

### Wrong Tool Names
Always use fully qualified MCP tool names:
- ✓ `BigQuery:bigquery_schema`
- ✓ `GitHub:create_issue`
- ✗ `bigquery_schema` (ambiguous)

### Assuming Tools Are Installed
**Bad:**
```
Use the pdf library.
```

**Good:**
```
Install: `pip install pypdf`

Then:
```python
from pypdf import PdfReader
```
```

### Windows-Style Paths
Always use forward slashes:
- ✓ `scripts/helper.py`
- ✗ `scripts\helper.py`

---

## Verification Checklist

### Before Publishing

**Discovery**
- [ ] Description includes verb + specifics + trigger words?
- [ ] Would Claude discover with these keywords?
- [ ] Description includes both WHAT and WHEN?

**Content**
- [ ] SKILL.md under 500 lines?
- [ ] Every line justifies its token cost?
- [ ] No framework basics or library docs?
- [ ] Delta principle applied?

**Structure**
- [ ] References one level deep from SKILL.md?
- [ ] Examples concrete, not abstract?
- [ ] Code complete and runnable?
- [ ] Large files have table of contents?

**Testing**
- [ ] Tested with real scenarios?
- [ ] Tested with Haiku, Sonnet, Opus?
- [ ] Manual discovery test passed?

See [discovery-checklist.md](discovery-checklist.md) for comprehensive pre-launch testing.

---

## Workflows & Examples

- See [workflows.md](workflows.md) for 3 complete skill creation walkthroughs
- See [reference.md](reference.md) for structure patterns and organization
- See [SKILL.md](SKILL.md) for the 6-phase workflow

---

## Key Takeaway

**Discoverable + Concise + Tested = Great Skills**

1. Write a description that Claude will find
2. Make SKILL.md minimal (under 500 lines)
3. Put detailed content in reference files (on-demand loading)
4. Test with real scenarios across all models
5. Iterate based on how Claude actually uses it

Focus on discovery first. Everything else follows.
