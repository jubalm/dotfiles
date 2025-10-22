# Audit: Quarterly Quality Check

## Audit Checklist

```
Quarterly Audit:
- [ ] Step 1: Freshness - Check for stale content
- [ ] Step 2: Accuracy - Verify decisions still hold
- [ ] Step 3: Completeness - Missing high-value items?
- [ ] Step 4: Clarity - Routing hints accurate?
- [ ] Step 5: Cleanup - Archive obsolete items
```

---

## Step 1: Freshness (15 min)

Read through each file. Mark:

- ✓ Fresh (no action)
- ⚠ Stale (needs update)
- ✗ Obsolete (remove/archive)

**Ask:** Is this still accurate? Has this changed?

---

## Step 2: Accuracy (15 min)

For each decision, verify it still holds:

```markdown
## Database: PostgreSQL

Current: Using PostgreSQL 14 with RLS
Still valid? ✓ Yes (no migration planned)
Rationale accurate? ✓ Yes (RLS still best)
```

Mark status: ✓ Accurate or ⚠ Needs update

---

## Step 3: Completeness (15 min)

Ask: "What would trip up a new developer?"

Common gaps:
- Deployment process (not documented)
- Debugging patterns (not shared)
- Performance gotchas (learned hard way)
- Security best practices (scattered)

Add missing deltas to inbox for promotion (see @workflows/capture.md).

---

## Step 4: Clarity (10 min)

Test routing hints to ensure Memory is discoverable.

**Validation checks:**

| Issue | Symptom | Fix |
|-------|---------|-----|
| **Routing broken** | Claude can't find answers | Hints too vague? Make specific. Test real queries. No chains (CLAUDE.md → file only). |
| **Files too large** | >250 lines, hard to navigate | Split by domain (backend.md, frontend.md) or concern (security.md, perf.md) |
| **Files too small** | <30 lines, wasteful | Merge into parent (conventions.md, patterns.md) + add section heading |
| **Conflicting patterns** | Old & new code differ | Document both ("Old vs New"). Mark: "Refactor old to new" |
| **Over-documentation** | Bloated, low-value content | Re-score: <3 yes → remove. Keep constraints only. |
| **Too specific** | Implementation details not patterns | Refactor → change? If yes → too specific. Use constraints ("NEVER X") not HOW. |

**Test queries:**

```
Query: "How is [system] organized?"
Result: Finds architecture.md ✓

Query: "What's our testing approach?"
Result: Finds patterns.md ✓
```

If queries don't resolve → refine routing or reorganize.

---

## Step 5: Cleanup (10 min)

Archive obsolete items.

**When decision changes:**

Old:
```markdown
## Database: MongoDB

Chosen for schema flexibility...
```

New:
```markdown
## Database: PostgreSQL (2025-10-01)

Migrated from MongoDB (see HISTORY.md) due to:
- Transactional guarantees
- RLS for multi-tenancy
- Better performance

[MongoDB history archived]
```

---

## Post-Audit Actions

After audit completion:

1. **Update stale content** - Mark with "Changed: YYYY-MM-DD"
2. **Fix file sizes** - Split large files, merge small ones
3. **Add missing discoveries** to inbox
4. **Test routing** - Verify CLAUDE.md hints work
5. **Report** - Share changes with team

**Mark next audit date:** Typically 3 months out
