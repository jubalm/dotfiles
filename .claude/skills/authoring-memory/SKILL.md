---
name: Authoring Memory
description: Organize project-specific knowledge for Claude Code - facts, decisions, constraints, product logic. Use when building Memory systems, determining what to document, or promoting discoveries to permanent knowledge.
---

# Authoring Memory

Memory stores WHAT is true (decisions, constraints, patterns) so Claude can retrieve it when needed.

---

## Task Router

**I want to...** → **Use this workflow**

| Task | Action |
|------|--------|
| **Create new Memory system** | @workflows/bootstrap.md |
| **Find something to document** | Score it: @reference.md#decision-matrix (3+ yes? Add to inbox) |
| **Move inbox items to permanent** | @workflows/promote.md |
| **Audit Memory quality** | @workflows/audit.md |
| **Capture new discovery** | @workflows/capture.md |

**Need foundational concepts?** → @reference.md (Decision Matrix, Delta Principle, Density, Code in Memory)

**Need domain examples?** → @examples.md

---

## When to Offer Proactively

Trigger → Suggested action:
- New project → "Create Memory system?"
- Pattern discovered (code review) → "Capture this?"
- Hard-earned constraint → "Worth documenting?"
- "Why did you do it this way?" → "This is Memory material"
- Team onboarding → "Document for new members?"
- Architecture decision → "Capture the WHY?"
- "Should we use X or Y?" → "Document this decision"

**Prompt:** "This would make great Memory. Want to capture it?"

---

## File Organization Patterns

| Pattern | Use When | Structure |
|---------|----------|-----------|
| **Starter** | Small team, 1-2 domains | CLAUDE.md + context/conventions.md + inbox.md |
| **Growing** | Multiple domains, evolving | CLAUDE.md + context/{principles, architecture, patterns, inbox}.md |
| **Complex** | Multiple teams/domains | Growing + context/{feature, concern}.md files |

See @reference.md#file-organization-patterns for full templates.

---

## CLAUDE.md Format

```markdown
# [Project Name]

**When:** [Query pattern] → @context/[file.md]
**When:** [Query pattern] → @context/[file.md]

[Brief description]
```

Keep routing hints semantic (one query → one file, no chains).

---

## Next Steps

1. **Bootstrap:** Choose structure (starter/growing/complex)
2. **Bootstrap:** Run @workflows/bootstrap.md (2-4 hours)
3. **Capture:** Watch for new discoveries during work
4. **Promote:** Move inbox items using @workflows/promote.md
5. **Audit:** Review Memory quality via @workflows/audit.md

---

## Reference Materials

| Resource | Contains |
|----------|----------|
| @reference.md | Decision Matrix, Delta Principle, Density, Code in Memory, Templates, Quality Checklist |
| @examples.md | Real-world patterns by domain (Frontend, Backend, DevOps, Testing, Monorepo, Library) |
| @workflows/bootstrap.md | Step-by-step system creation (7 steps + validation + templates) |
| @workflows/capture.md | Find and capture discoveries (proactive + explicit) |
| @workflows/promote.md | Inbox → permanent (6 steps + edge cases + code drift guidance) |
| @workflows/audit.md | Audit Memory quality (5 steps + validation checks) |
