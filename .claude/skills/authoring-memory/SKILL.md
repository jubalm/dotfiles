---
name: Authoring Memory
description: Organize project-specific knowledge for Claude Code - facts, decisions, constraints, product logic. Use when building Memory systems, determining what to document, or promoting discoveries to permanent knowledge.
---

# Authoring Memory

**Core idea:** Memory stores WHAT is true (decisions, constraints, patterns). Claude retrieves it when needed.

---

## Quick Decision Tree

**You want to...** → **Go here**

**Start new Memory system?** → See [Bootstrap workflow](workflows.md#bootstrap)

**Found something to document?** → [Score it](reference.md#decision-matrix) (3+ yes? Add to inbox)

**Move inbox items to permanent?** → See [Promote workflow](workflows.md#promote)

**Quarterly review?** → See [Audit workflow](workflows.md#audit)

**Need examples or templates?** → See [reference.md](reference.md) or [examples.md](examples.md)

**Stuck or unsure?** → See [Troubleshooting](workflows.md#troubleshooting)

---

## When Claude Should Offer This Proactively

Observe → Suggest:
- New project → "Create Memory system?"
- Pattern discovery (code review) → "Capture this?"
- Hard-earned constraint → "Worth documenting?"
- "Why did you do it this way?" → "This is Memory material"
- Team onboarding → "Document for new members?"
- Architecture decision → "Capture the WHY?"
- "Should we use X or Y?" → "Document this decision"

**Prompt:** "This would make great Memory. Want to capture it?"

---

## Core Concepts (Concise)

### Decision Matrix: Score Items 1-5 on Each

```
✓ Would Claude miss?      (not in training, not discoverable)
✓ Project-specific?       (not framework/library basics)
✓ Prevent bugs if unknown? (high stakes: security, data loss)
✓ Save time?              (vs rediscovering through experimentation)
✓ Stable?                 (durable knowledge, not changing soon)
```

**Result:** 3+ yes → Document. 5 yes → Essential. 0-2 → Skip.

---

### Delta Principle: Only Document Non-Inferrable Knowledge

**Don't document (Claude already knows):**
- Framework patterns (React hooks, Django models)
- Library capabilities (Stripe API, Firebase features)
- File structure (ls/grep shows this)
- Tech stack (visible in package.json)
- Language syntax (standard libraries)

**Do document (High-value deltas):**
- **Decisions** - Why X over Y (tradeoffs, constraints)
- **Product logic** - Unique business rules, custom patterns
- **Hard constraints** - "NEVER" rules that prevent bugs

[See diverse examples](reference.md#delta-principle-by-domain)

---

### Density: Fragments > Sentences

```
❌ "The reason we chose Next.js is because it enables..."
✓ "Next.js: ✓ SSR/CSR unified, ✓ simpler mental model"
```

Use symbols: `✓` / `✗` instead of yes/no, `→` instead of leads to, `:` instead of is.

[See density examples](reference.md#density-guide)

---

### Code in Memory: Constraints Over Implementation

Static code drifts after refactors. Document constraints (stay true) not implementation (changes).

```
❌ Copy-paste exact code
✓ Document the NEVER rule
✓ Use pseudocode + constraint
✓ Link to actual code
```

**Why:** Constraint "NEVER bypass auth" survives refactoring. Copy-paste code becomes stale.

[See guidance](reference.md#code-in-memory-the-drift-problem)

---

## File Organization

### Starter (Simple Projects)

```
.claude/
├── CLAUDE.md          # Routing hints
└── context/
    ├── conventions.md # All decisions + patterns + constraints
    └── inbox.md       # Staging area
```

### Growing (Multiple Concerns)

```
.claude/
├── CLAUDE.md
└── context/
    ├── principles.md   # WHY decisions
    ├── architecture.md # HOW organized + constraints
    ├── patterns.md     # Non-obvious implementations
    └── inbox.md
```

### Complex (Multi-Domain)

```
.claude/
├── CLAUDE.md
└── context/
    ├── principles.md
    ├── architecture.md
    ├── [feature].md    # Feature-specific
    ├── [concern].md    # Cross-cutting (security, testing)
    └── inbox.md
```

**CLAUDE.md:**
```markdown
# Project Name

**When:** [Query] → @context/[file.md]
(Routing hints: one query → one file)

[Brief description]
```

---

## Workflow Overview

| Workflow | Purpose | Time | See |
|----------|---------|------|-----|
| **Bootstrap** | Create Memory system from scratch | 2-4 hours | [workflows.md](workflows.md#bootstrap) |
| **Capture** | Find and add new discoveries | Ongoing | [workflows.md](workflows.md#capture) |
| **Promote** | Move inbox items to permanent | 15-30 min per item | [workflows.md](workflows.md#promote) |
| **Audit** | Quarterly freshness check | 1-2 hours | [workflows.md](workflows.md#audit) |

---

## File Size Guidelines

| File | Ideal | Too small | Too large |
|------|-------|-----------|-----------|
| principles.md | 80-150 | <50 | >200 |
| architecture.md | 100-200 | <50 | >250 |
| patterns.md | 100-200 | <50 | >250 |
| [feature].md | 50-150 | <30 | >200 |
| inbox.md | Unlimited | - | - |

Too small → merge into parent. Too large → split by domain.

---

## Quality Checklist

✓ Routing hints in CLAUDE.md?
✓ Files 50-200 lines?
✓ No framework/library basics?
✓ Decision matrix applied (3+ yes)?
✓ Dense writing (fragments > sentences)?
✓ Constraint-focused (NEVER rules)?
✓ Code examples use constraints, not copy-paste? (or linked to real code)

---

## Next Steps

1. Choose structure (starter/growing/complex)
2. Run [Bootstrap workflow](workflows.md#bootstrap)
3. Build CLAUDE.md with routing hints
4. Create starter files (principles, architecture, patterns)
5. Use [Promote workflow](workflows.md#promote) for ongoing discoveries
6. [Audit quarterly](workflows.md#audit)

**More info:** [reference.md](reference.md) (templates, examples), [examples.md](examples.md) (real-world by domain), [workflows.md](workflows.md) (procedures)
