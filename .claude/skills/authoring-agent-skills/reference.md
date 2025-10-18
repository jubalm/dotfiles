# Agent Skills: Reference Patterns

Optional supporting patterns. See [SKILL.md](SKILL.md) for the main procedure.

---

## Progressive Disclosure Patterns

### Pattern 1: High-Level + References

For single-domain Skills with advanced content:

```
skill/
├── SKILL.md (overview + quick examples)
├── ADVANCED.md (detailed workflows)
└── REFERENCE.md (API documentation)
```

Use Pattern 1 when SKILL.md approaches 400+ lines.

### Pattern 2: Domain-Specific Organization

For multi-domain Skills (organize by domain to minimize context load):

```
analytics-skill/
├── SKILL.md (overview only)
└── domains/
    ├── sales.md (only loads when user asks about sales)
    ├── finance.md (only loads when user asks about finance)
    └── product.md (only loads when user asks about product)
```

Use Pattern 2 when you have unrelated domains (sales vs finance are different).

### Pattern 3: Conditional Details

For Skills with basic + advanced variations:

```
docx-skill/
├── SKILL.md (basic usage)
├── TRACKED_CHANGES.md (advanced: tracked changes)
└── OOXML.md (advanced: OOXML details)
```

Link advanced files only when needed from SKILL.md.

---

## File Organization Rules

### One Level Deep

✓ Good:
```
SKILL.md → ADVANCED.md
SKILL.md → REFERENCE.md
```

✗ Bad (don't nest):
```
SKILL.md → ADVANCED.md → DETAILS.md
```

### Bundle Scripts

Include in `scripts/` directory for deterministic operations:

```
skill/
├── SKILL.md
└── scripts/
    ├── validate.py
    ├── extract.py
    └── migrate.sh
```

Scripts are **executed** (not loaded). Only output enters context.

### Size Guidelines

- SKILL.md: Under 500 lines
- Reference files: 100-300 lines each
- If > 500 lines: Split into reference files

---

## Description Field

Critical for discovery. Claude uses this to select your Skill.

**Structure:**
```
[What] + [When]. Use when [triggers] or [user mentions].
```

**Examples:**

```yaml
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

```yaml
description: Query analytics data for sales, finance, or product metrics. Use when asking about pipeline, revenue, billing, API usage, or feature adoption.
```

**Rules:**
- Specific capabilities (not "Helps with documents")
- When to use (triggers, contexts)
- Key terms users actually say
- Third person (not "I can...", not "You can...")
- Under 1024 characters

---

## Anti-Patterns

❌ Explain how Skills work (that's documentation)
❌ Include framework tutorials or library API docs
❌ Nest references beyond one level
❌ Use vague names: "Helper", "Utils", "Tools"
❌ Use vague descriptions: "Processes data"
❌ Assume tools are installed (mention pip/npm first)
❌ Make SKILL.md > 500 lines

---

## Next Steps

See [SKILL.md](SKILL.md) for the 5-step creation workflow.
