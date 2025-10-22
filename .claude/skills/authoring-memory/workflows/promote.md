# Promote: Move Inbox Items to Permanent Memory

## Promotion Checklist

```
- [ ] Step 1: Find - Locate in inbox.md
- [ ] Step 2: Re-score - Verify still 3+ yes
- [ ] Step 3: Rewrite - Apply delta & density
- [ ] Step 4: Place - Determine destination file
- [ ] Step 5: Integrate - Add to target file
- [ ] Step 6: Mark - Update inbox with date
```

---

## Step 1: Find

Locate the discovery in `inbox.md`:

```markdown
## 2025-10-18: Session token invalidation

When user logs out, session tokens expire immediately
but refresh tokens should be invalidated after 24 hours...
```

---

## Step 2: Re-Score

Apply decision matrix again to verify it's still 3+ yes (see @reference/decision-matrix):

| Criterion | Assessment | Score |
|-----------|-----------|-------|
| Would Claude miss? | Yes, subtle timing detail | 1 |
| Project-specific? | Yes, our security architecture | 1 |
| Prevent bugs? | **YES** - stale tokens = security holes | 1 |
| Save time? | Yes, avoids debugging | 1 |
| Stable? | Yes, core security decision | 1 |

**Total: 5 yes → Promote immediately**

---

## Step 3: Rewrite for Efficiency

Remove narrative, focus on constraints (see @reference/delta-principle):

**Before (verbose):**
```markdown
When user logs out, session tokens expire immediately but
refresh tokens should be invalidated after 24 hours to catch
stale refresh attempts. This prevents security issues where
refresh tokens linger.
```

**After (dense):**
```markdown
Session invalidation: Tokens expire immediately on logout
Refresh tokens: Revoked after 24h (catches stale attempts)
✗ Never keep refresh tokens >24h
```

### ⚠️ Code Drift Problem

**Watch out:** Don't copy exact implementation code into Memory.

**Problem:** Code changes after refactors, but Memory stays static. Claude suggests outdated patterns.

**Solution - Document Constraints, Not Code:**
```
❌ Don't: Copy-paste exact code
✓ Do: Document the NEVER rule
✓ Do: Use pseudocode + constraint
✓ Do: Link to actual code location (src/config/loader.ts:45-70)
```

**Why:** Constraint "NEVER bypass auth" survives refactoring. Copy-paste code becomes stale.

See full guidance at @reference/code-in-memory

---

## Step 4: Determine Destination

Ask: Which file does this belong in?

- **principles.md** → WHY decision (architecture choice)
- **architecture.md** → Structural rule or hard constraint
- **patterns.md** → Implementation pattern
- **[feature].md** → Feature-specific
- **[concern].md** → Cross-cutting (security, testing, perf)

For session token example → `security.md` (constraint)

---

## Step 5: Integrate Semantically

Add to target file in appropriate section.

If `security.md` has "Authentication" section:
```markdown
## Authentication

### Session Management

Session tokens: Expire immediately on logout
Refresh tokens: Revoked after 24h (catches stale attempts)
✗ Never keep refresh tokens >24h
```

---

## Step 6: Mark Promoted

Update `inbox.md`:

**Before:**
```markdown
## 2025-10-18: Session token invalidation

When user logs out, session tokens expire immediately...
```

**After:**
```markdown
## 2025-10-18: Session token invalidation

~~When user logs out, session tokens expire immediately...~~
(Promoted: 2025-10-18 → security.md)
```

---

## Edge Cases in Promotion

### Case 1: Discovery Invalidated

**Problem:** Re-scoring shows only 2 yes (not high enough)

**Solution:**
1. Mark in inbox: "Not high-value enough" with date
2. Leave (don't delete) for future reference
3. Move on

### Case 2: Destination Unclear

**Problem:** Could fit multiple files

**Solution:**
1. Choose based on primary use case
2. Ask: "What query would find this?"
3. If answer is "security", put in security.md
4. Add cross-reference in other file if helpful

### Case 3: Conflicts with Existing Content

**Problem:** New discovery contradicts existing Memory

**Solution:**
1. Don't overwrite - investigate why conflict exists
2. Update old content with date change: "Changed: YYYY-MM-DD"
3. Document both if both are valid (different contexts)
