# Quick Reference

## Memory Types

| Type | Use For | Example |
|------|---------|---------|
| **constraints.md** | Business/technical limits | "Auth API: 100 req/min limit" |
| **quirks.md** | Non-standard behaviors | "Use .env.production (not .env.local)" |
| **decisions.md** | Architectural choices | "Chose PostgreSQL for scalability" |
| **conventions.md** | Team standards | "Always use shadcn-ui skill for UI" |

## Inbox Types

| Type | Use For |
|------|---------|
| **observation** | Noticed something during work |
| **intuition** | Gut feeling something needs review |
| **deferred** | Works but needs investigation later |

## Common Workflows

### Starting a New Project

```
"Set up memory for this project"
→ Claude initializes structure
→ Explores codebase
→ Auto-captures constraints, quirks, decisions, conventions
```

### During Development

```
"Remember: We use .env.production for all environments"
→ Claude adds to quirks.md
→ Automatic token efficiency check
```

### Uncertain Finding

```
"Something feels off about the auth logic"
→ Claude creates inbox item
→ Later: "That auth thing - it's a race condition. Save it."
→ Claude promotes to quirks.md
```

### Reviewing Memory

```
"What's in the inbox?"
→ Claude lists all items

"Show inbox item 1"
→ Claude loads full content
→ Selective context loading
```

## Token Targets

- **Per entry**: < 25 tokens
- **Per file**: < 500 entries initially
- **Memory ratio**: Generic knowledge < 10%

## When to Promote from Inbox

- Investigation complete and issue confirmed
- Decision made and rationale clear
- Pattern identified and tested
- Risk assessed and acceptable
