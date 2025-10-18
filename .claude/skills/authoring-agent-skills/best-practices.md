# Agent Skills: Writing Principles

See [SKILL.md](SKILL.md) for the 5-step creation workflow.

---

## Rule 1: Concise

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
PDF files are documents. You need a library. We recommend pdfplumber
because it's easy to use and handles most cases well. First install it
using pip. Then you can use the following code...
```

**Questions:**
- Does Claude already know this?
- Can Claude infer this?
- Does this justify its token cost?

---

## Rule 2: Match Fragility to Specificity

**High freedom** (multiple approaches OK):
- Guidance: "Analyze code for bugs, style, and performance"
- Use when: Context determines best approach

**Medium freedom** (pattern with variation):
- Guidance: "Use this template, customize as needed"
- Use when: Preferred pattern exists

**Low freedom** (exact steps required):
- Guidance: "Run this script exactly: `python migrate.py --verify`"
- Use when: Operations are fragile or error-prone

---

## Rule 3: Test with All Models

- **Haiku** (fast): Enough guidance?
- **Sonnet** (balanced): Clear and efficient?
- **Opus** (powerful): Avoid over-explaining?

Write Skills that work across all three.

---

## Rule 4: Specific Description

Claude selects from 100+ Skills using your description.

**Good:**
```yaml
description: Extract text and tables from PDFs. Use when working with PDF files or mentioning text extraction, document parsing, or table extraction.
```

**Bad:**
```yaml
description: Helps with documents
```

**Ingredients:**
- Specific capabilities (not vague)
- When to use (triggers)
- Key terms (what users say)
- Third person (for system prompt)

---

## Verification Checklist

Before using:

- [ ] Description specific + includes key terms?
- [ ] SKILL.md under 500 lines?
- [ ] Step-by-step procedure (not theory)?
- [ ] Examples work end-to-end?
- [ ] Tested with Haiku + Sonnet?
- [ ] Vague name/description avoided?

---

See [reference.md](reference.md) for organization patterns.
