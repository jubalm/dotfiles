---
allowed-tools: Bash(git:*)
argument-hint: [scope]
description: Repository state snapshot with structured data output. Scopes: full (default), status, diff, staged, history. Use for understanding current state or giving skills context.
---

# Git Repository Snapshot

Structured point-in-time view of repository state. Data-like output for scanning and parsing.

## Parameters

- **SCOPE**: `$ARGUMENTS` or "full" (default)
  - `full` - Complete snapshot (status, diffs, history, branch, stashes)
  - `status` - Just file changes summary
  - `diff` - Just diff stats
  - `staged` - Just staged changes
  - `history` - Just recent commits

## Data Collection

Branch: !`git branch --show-current`

Status: !`git status -s`

Diff stats: !`git diff --stat`

Staged stats: !`git diff --staged --stat`

Recent commits: !`git log -10 --oneline --no-decorate`

Ahead/behind: !`git fetch origin 2>/dev/null; git rev-list --left-right --count HEAD...@{u} 2>/dev/null || echo "0 0"`

Stashes: !`git stash list | wc -l`

## Output Format

Based on SCOPE parameter:

### full scope

```
<!-- SNAPSHOT -->
Branch: [current-branch]
Ahead: [count] | Behind: [count]

Modified: [count] file(s)
[list of modified files, indented]

Staged: [count] file(s)
[list with stats, indented]

Untracked: [count] file(s)
[list if <5, else summarize]

Recent commits (10):
[5 most recent with hashes]

Stashes: [count]
[list if any]
<!-- /SNAPSHOT -->
```

### status scope

```
<!-- STATUS -->
Branch: [branch]
Modified: [count]
Staged: [count]
Untracked: [count]
<!-- /STATUS -->
```

### diff scope

```
<!-- DIFF -->
Diff stats:
[git diff --stat output]

Staged stats:
[git diff --staged --stat output]
<!-- /DIFF -->
```

### staged scope

```
<!-- STAGED -->
Staged: [count] file(s)
[files with line changes]

Total: [+lines], [-lines]
<!-- /STAGED -->
```

### history scope

```
<!-- HISTORY -->
Recent commits (10):
[full list with hashes and messages]
<!-- /HISTORY -->
```

## Implementation Notes

- Use HTML comment markers for parseability
- Minimal prose; use data-like presentation
- Symbols for scanning: file counts, +/- changes
- Filter output based on SCOPE to reduce token cost
- All data comes from inline git commands (no manual formatting)
