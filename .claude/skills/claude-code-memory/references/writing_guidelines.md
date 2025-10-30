# Writing Guidelines

## Token Efficiency

**Every token in memory is auto-loaded into context.** Minimize waste.

### Bad (Verbose)

```markdown
## API Timeout Issues

**Problem:** When making requests to the authentication API, we discovered 
through testing that after approximately 100 requests, the API begins timing 
out and returning 503 errors.

**Solution:** We need to implement request batching or caching to stay under 
the limit.

**Context:** This is due to our infrastructure rate limiting configuration.
```

**Token cost:** ~60 tokens

### Good (Concise)

```markdown
## API Rate Limit

Auth API: 100 req/min limit → 503 errors. Batch or cache requests.
```

**Token cost:** ~15 tokens

## Entry Format

```markdown
## [Topic]
[Single-line description with key constraint/quirk/decision]
[Optional second line for critical context only]
```

## What NOT to Capture

### ✗ Generic Best Practices

Claude already knows these:

- "Use TypeScript for type safety"
- "Write unit tests"
- "Use git for version control"
- "Handle errors properly"
- "Add logging"
- "Validate input"

### ✓ Project-Specific Only

Capture deviations from defaults:

- "TypeScript strict mode breaks legacy auth module - use loose"
- "E2E tests timeout in CI at 10s - set to 30s in jest.config"
- "Use feature branches, deploy via tag push to v/* pattern"
- "Auth errors must be sanitized - never expose internal details"

## Pattern Examples

### Constraint Pattern

```markdown
## [Resource Type]: [Limit/Requirement]
[Impact and workaround]

# Example:
## Database: Connection Pool
Max 50 concurrent - use HikariCP with queueTimeout=30s
```

### Quirk Pattern

```markdown
## [Feature]: [Non-standard Behavior]
[What works, what doesn't, why]

# Example:
## Async in Legacy Builds
Breaks IE11 - use promises instead of async/await
```

### Decision Pattern

```markdown
## [Component]: [Choice] over [Alternative]
[Key trade-off rationale]

# Example:
## Architecture: Monorepo vs Polyrepo
Chose monorepo - faster local development despite slower CI
```

### Convention Pattern

```markdown
## [Area]: [Practice]
[When/why applied, any exceptions]

# Example:
## Git: Feature Branch Naming
Use feat/*, fix/*, docs/* prefixes. Deploy via tag push to v/*
```

## Promotion Checklist

Before promoting from inbox to memory:

- [ ] Issue fully investigated or decision finalized
- [ ] Rationale is clear and concise
- [ ] Entry is project-specific (not generic)
- [ ] Token estimate is < 30
- [ ] No duplicate information exists
- [ ] Correct memory file selected
