# Memory Templates

These are templates for initializing and managing project memory.

## CLAUDE.md Template

Place this file at `.claude/CLAUDE.md` in your project:

```markdown
# Project Memory

@memory/constraints.md
@memory/quirks.md
@memory/decisions.md
@memory/conventions.md

**Note:** Use "show inbox" or "inbox" command to load on-demand items from .claude/memory/inbox/
```

## Memory File Templates

### constraints.md

```markdown
# Project Constraints

Business, technical, and platform limitations that affect development.

## API Rate Limits
Stripe API: 100 req/sec per API key. 429 errors if exceeded.

## Platform Restrictions
Cannot use native Node.js `fs` in browser bundle. Use isomorphic-git for file ops.

## Budget Constraints
Cloud storage: $500/mo budget. Currently using 450GB / 500GB.

---
```

### quirks.md

```markdown
# Project Quirks

Non-standard behaviors, workarounds, and deviations from framework defaults.

## Config File Selection
Use .env.production for all environments (not .env.local). Local overrides via .env.local.override ignored.

## Build Cache Issue
TypeScript incremental build breaks if tsconfig changes. Clear `dist/` manually before rebuild.

## Database Connection
Prisma client requires explicit .disconnect() even with NODE_ENV=production. Otherwise memory leak.

---
```

### decisions.md

```markdown
# Architectural Decisions

Significant choices with rationale and trade-offs.

## PostgreSQL over MongoDB
**Why:** Strong schema requirements, complex queries, ACID transactions needed for financial records.
**Trade-off:** More setup overhead, less horizontal scaling.

## Monorepo Structure
**Why:** Shared utilities, atomic deploys, easier refactoring.
**Trade-off:** Slower git operations, complex CI/CD config.

---
```

### conventions.md

```markdown
# Project Conventions

Team standards and non-obvious project-specific practices.

## Git Workflow
Feature branches: `feature/TICKET-123-short-desc`. Deploy via `git tag v1.2.3`. CI runs on all pushes.

## Report Generation
Always use docx skill for report generation. Maintain .docx template in /assets/templates/.

## Error Handling
Auth errors must be sanitized—never expose internal token details or database info in API responses.

---
```

## Inbox Entry Template

Create individual files in `.claude/memory/inbox/` with this format:

```markdown
---
id: slugified-title
type: intuition|observation|deferred|investigation
title: Short descriptive title
priority: high|medium|low
status: pending
added_by: user
date: 2025-10-29
---

# Title

**Type:** [intuition/observation/deferred/investigation]

**Status:** [pending/in-review/waiting-clarification]

**Context:** [Brief background on why this was added]

## Discussion

[Detailed notes, code snippets, investigation results, questions to resolve]

## Next Steps

[What should happen next to resolve this]
```

## Example Entries

### Good: Concise

```markdown
## Auth Token Refresh
Token refresh needs mutex lock—race condition when called concurrently
```
~10 tokens ✅

### Bad: Verbose

```markdown
## Authentication Token Refresh Race Condition
When multiple requests attempt to refresh the authentication token simultaneously, a race condition 
occurs because the refresh logic is not atomic. We have observed that this happens especially under 
high load. The solution is to implement a mutex lock around the token refresh operation.
```
~45 tokens ❌

### Good: Project-Specific

```markdown
## Build Output Directory
Output to dist/build/ (not dist/). CI expects this location for S3 upload.
```
✅ Project-specific

### Bad: Generic

```markdown
## Use TypeScript for Type Safety
TypeScript provides compile-time type checking which prevents runtime errors.
```
❌ Generic knowledge
