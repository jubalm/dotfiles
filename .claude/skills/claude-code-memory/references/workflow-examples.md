# Memory Workflows - Detailed Examples

## Workflow: Initialize Memory for a New Project

**User triggers:** "Set up memory for this project", "Initialize project memory", "Let's start tracking project knowledge"

**Complete process:**

1. **Create directory structure:**
   ```
   .claude/
   ├── CLAUDE.md
   └── memory/
       ├── constraints.md
       ├── quirks.md
       ├── decisions.md
       ├── conventions.md
       └── inbox/
   ```

2. **Create CLAUDE.md** with memory imports (see memory-templates.md)

3. **Invoke Explore sub-agent** to analyze codebase
   - Identify configuration files, non-standard patterns
   - Find project structure and tech stack
   - Note any custom tooling or build processes

4. **Extract and populate memory files** with concise entries:
   - **constraints.md:** Rate limits, platform restrictions, budget constraints from docs/config
   - **quirks.md:** Custom build processes, unusual config patterns, workarounds
   - **decisions.md:** Technology choices and architectural rationale
   - **conventions.md:** Git workflows, testing patterns, deployment procedures

5. **Confirm with summary**

**Confirmation message:**
```
[OK] Memory system initialized at .claude/
[OK] Analyzed codebase with Explore sub-agent
[OK] Captured findings:
  - 3 constraints (Stripe API: 100 req/sec, budget $500/mo, no native fs in browser)
  - 5 quirks (config precedence, TS build cache, Prisma disconnect required, etc.)
  - 2 decisions (PostgreSQL for ACID, monorepo for atomic deploys)
  - 4 conventions (git workflow feature/* → tag v*, docx for reports, error sanitization)

Memory is ready. New entries captured naturally as we work. Use "audit the memory" periodically.
```

---

## Workflow: Capture Knowledge During Development

### Scenario 1: Constraint Discovery

**User:** "We can't use dynamic imports in the browser build because Webpack doesn't support them with our current config."

**Process:**
1. Detect intent: User sharing technical limitation
2. Classify: **constraint** (affects what we can do)
3. Write concise entry:
   ```markdown
   ## Browser Build Limitations
   No dynamic imports—Webpack config doesn't support them. Use static imports only.
   ```
4. Append to constraints.md
5. Confirm: "Added to constraints.md"

### Scenario 2: Quirk Discovery

**User:** "I had to add `.env.local.override` to the gitignore because the config loader checks it after `.env.local`, which was causing unexpected overrides in production."

**Process:**
1. Detect intent: User sharing unexpected behavior
2. Classify: **quirk** (non-standard, deviates from typical dotenv behavior)
3. Write concise entry:
   ```markdown
   ## Config Precedence Order
   Config loader: .env → .env.local → .env.local.override. Keep .env.local.override in gitignore.
   ```
4. Append to quirks.md
5. Confirm: "Added to quirks.md"

### Scenario 3: Decision Context

**User:** "We chose Next.js over Remix because we needed better SSR performance for initial page load and simpler deployment to Vercel."

**Process:**
1. Detect intent: User explaining architectural choice
2. Classify: **decision** (why we chose X)
3. Write concise entry:
   ```markdown
   ## Framework: Next.js
   Why: Better SSR perf for initial load, simpler Vercel deployment vs Remix complexity.
   ```
4. Append to decisions.md
5. Confirm: "Added to decisions.md"

### Scenario 4: Convention Establishment

**User:** "Always use the shadcn-ui skill for UI component creation. It handles Tailwind setup automatically."

**Process:**
1. Detect intent: User establishing team pattern
2. Classify: **convention** (how we do things here)
3. Write concise entry:
   ```markdown
   ## UI Components
   Always use shadcn-ui skill for component creation—auto-handles Tailwind setup.
   ```
4. Append to conventions.md
5. Confirm: "Added to conventions.md"

---

## Workflow: Capture Uncertainty in Inbox

### Scenario: Gut Feeling About Code

**User:** "Something feels off about the payment processing flow. All tests pass but I'm not confident we handle race conditions correctly."

**Process:**
1. Detect uncertainty indicator: "feels off", "not confident"
2. Classify as inbox item (not immediate memory)
3. Create `.claude/memory/inbox/payment-race-condition.md`:
   ```markdown
   ---
   id: payment-race-condition
   type: intuition
   title: Payment processing race condition concern
   priority: high
   status: pending
   added_by: user
   date: 2025-10-29
   ---

   # Payment Processing Race Condition

   **Type:** Intuition - User concern

   **Status:** Pending investigation

   **Context:** Recent refactor of payment processing. All tests pass, but user suspects race conditions 
   with concurrent requests.

   ## Discussion

   Concern: When multiple transactions attempt to process simultaneously, we may have:
   - Double-charging users
   - Missing transaction records
   - State inconsistency

   Current implementation uses optimistic locking, but may not be sufficient under high concurrency.

   Test cases might be missing edge cases with >5 concurrent requests.

   ## Next Steps

   1. Load test with 100+ concurrent payment requests
   2. Review idempotency tokens implementation
   3. Check database transaction isolation level
   ```

4. Confirm: "Added to inbox: payment-race-condition"

---

## Workflow: Review Inbox

**User:** "What's in the inbox?"

**Process:**
1. List `.claude/memory/inbox/`
2. Read frontmatter from each `.md` file
3. Display summary

**Output:**
```
Inbox (3 items):

1. [HIGH] Payment processing race condition - intuition
   File: payment-race-condition.md
   Added: 2025-10-29

2. [MEDIUM] Auth token refresh timing - deferred investigation
   File: auth-refresh-timing.md
   Added: 2025-10-28

3. [LOW] Database migration script edge case - observation
   File: migration-edge-case.md
   Added: 2025-10-27

Type: "tackle #1" or "show inbox item 1" to load full content
```

**User:** "Tackle #1"

**Process:**
1. Read full `/home/project/.claude/memory/inbox/payment-race-condition.md`
2. Load into context with all discussion and investigation notes
3. Offer to investigate

**Response:**
```
Loading inbox item: Payment processing race condition

[Full markdown content with discussion, concerns, next steps]

Ready to investigate. Should we:
1. Set up concurrent payment load test?
2. Review idempotency token implementation?
3. Check database isolation level?

Or would you like to approach this differently?
```

---

## Workflow: Promote Inbox Item to Memory

**User:** "The payment issue—we found it. Isolation level was READ_UNCOMMITTED. Changed to SERIALIZABLE. Problem solved."

**Process:**
1. Read full inbox item context
2. Extract key finding: Isolation level issue
3. Write concise memory entry
4. Add to decisions.md (architectural choice made)
5. Archive/remove inbox file

**Actions:**
1. Add to decisions.md:
   ```markdown
   ## Database Isolation Level
   Set to SERIALIZABLE for payment transactions. Prevents race conditions with concurrent operations.
   READ_UNCOMMITTED caused double-charges. Requires careful transaction scoping.
   ```

2. Remove `.claude/memory/inbox/payment-race-condition.md`

3. Confirm: "Promoted to decisions.md. Inbox item archived."

---

## Workflow: Memory Audit

**User:** "Audit the memory"

**Process:**
1. Read all active memory files:
   - constraints.md (N entries)
   - quirks.md (N entries)
   - decisions.md (N entries)
   - conventions.md (N entries)

2. Analyze each entry for:
   - Token count (target <25)
   - Generic vs project-specific knowledge
   - Staleness (>6 months old)
   - Conflicts between entries
   - Redundancy

3. Report findings

**Example output:**
```
Memory Audit Report
===================

File Statistics:
  - constraints.md: 8 entries, avg 18 tokens ✅
  - quirks.md: 12 entries, avg 22 tokens ✅
  - decisions.md: 5 entries, avg 24 tokens ✅
  - conventions.md: 6 entries, avg 20 tokens ✅

Overall: 31 entries, 21 tokens/entry avg (Target: <25) ✅

[OK] No staleness detected (all <3 months)
[OK] No conflicts found
[WARN] Generic knowledge detected: 3 entries flagged

Flagged entries for review:

1. constraints.md line 7: "Use npm for package management"
   → Generic best practice
   → Suggest: Remove (unless you have specific constraint like "must use npm v8.x")

2. conventions.md line 4: "Always write comments in code"
   → Universal practice
   → Suggest: Remove or specify (e.g., "Document complex algorithms—simple code is self-documenting")

3. quirks.md line 11: "Handle errors properly to avoid crashes"
   → Generic principle
   → Suggest: Replace with specific quirk (e.g., "Express route errors must be caught—unhandled errors cause silent failures")

Memory is in good shape. Recommend removing the 3 flagged entries.
```

---

## Workflow: Skill-as-Convention

**User:** "All report generation should use the docx skill. Let's lock that in."

**Process:**
1. Recognize skill usage pattern
2. Add to conventions.md:
   ```markdown
   ## Report Generation
   Always use docx skill for reports. Maintains template consistency and handles formatting automatically.
   ```
3. Confirm: "Added to conventions.md"

**Future usage:**
When Claude Code encounters a user request like "Generate a monthly report", it will:
- Read conventions.md
- See "Always use docx skill for reports"
- Use the docx skill automatically instead of building reports ad-hoc

---

## Tips for Effective Memory Management

1. **Natural capture over manual:** Wait for real moments when you discover constraints/quirks/decisions, don't pre-populate
2. **Inbox first for uncertainty:** If you're not 100% sure, put it in inbox—promotes naturally when confirmed
3. **Audit regularly:** Monthly audits catch bloat and generic knowledge before it accumulates
4. **One entry = one concept:** Don't combine multiple topics in a single entry
5. **Link related items:** If two entries relate, add a comment: "See also: quirks.md line X"
