---
allowed-tools: Bash(git:*)
argument-hint: [target] [mode]
description: Check branch alignment with target (default: main). Modes: full (default), summary, conflicts. Reports ahead/behind, commits, conflicts, and recommendations.
---

# Git Align

Check synchronization between current branch and target branch.

## Parameters

- **TARGET**: `$ARGUMENTS[0]` or "main" (default)
  - Branch name to align with (usually: main, develop, production)

- **MODE**: `$ARGUMENTS[1]` or "full" (default)
  - `full` - Complete alignment report
  - `summary` - Just ahead/behind counts and recommendation
  - `conflicts` - Conflict detection and resolution guidance

## Data Collection

Target branch: `${TARGET:-main}` (default: main)

!`git fetch origin 2>/dev/null || true`

Current branch: !`git branch --show-current`

Ahead/behind counts: !`git rev-list --left-right --count ${TARGET:-main}...HEAD`

Your commits: !`git log ${TARGET:-main}..HEAD --oneline`

Their commits: !`git log HEAD..${TARGET:-main} --oneline`

Diff: !`git diff --stat ${TARGET:-main}...HEAD`

Merge-base: !`git merge-base HEAD ${TARGET:-main}`

## Output Format

### full mode

```
<!-- ALIGN -->
Current: [branch-name]
Target: [target-branch]

Status: Ahead [n] | Behind [m]

Your commits ([n]):
  [hash]  [message]
  [hash]  [message]
  ...

Their commits ([m]):
  [hash]  [message]
  ...

Changes: [files-changed] file(s), +[lines], -[lines]

Conflicts: None detected | [conflict-summary]

Recommendation: [aligned/needs-rebase/needs-merge/needs-review]
<!-- /ALIGN -->
```

### summary mode

```
<!-- ALIGN-SUMMARY -->
Target: [target-branch]
Status: Ahead [n] | Behind [m]
Conflicts: None | [detected]
Recommendation: [action]
<!-- /ALIGN-SUMMARY -->
```

### conflicts mode

```
<!-- CONFLICTS -->
Target: [target-branch]

Conflict detection:
  Attempting merge: git merge --no-commit --no-ff [target]

Conflicts found: [list or "None"]
  [file1]
  [file2]

Resolution guidance:
  [recommendations based on conflicts]

Rebase strategy:
  [safe-to-rebase / risky / needs-manual-resolution]
<!-- /CONFLICTS -->
```

## Analysis & Recommendations

**Aligned**
- 0 ahead, 0 behind
- No new commits on either side
- → "Branch is in sync with target"

**Ahead only (typical)**
- N ahead, 0 behind
- You have commits not in target
- → "Ready to propose to target"

**Behind only (out of date)**
- 0 ahead, M behind
- Target has moved ahead
- → "Update with git pull origin [target]"

**Both diverged (risky)**
- N ahead, M behind
- Both have new commits
- → "Rebase recommended before proposing"

**Conflicts possible**
- Both diverged + overlapping files
- → "Merge-conflict likely; test first"

## Implementation Notes

- Fetch from origin to ensure current data
- Use `--left-right --count` for efficient ahead/behind
- Detect conflicts by attempting dry-run merge
- Never automatically rebase (only recommend)
- Provide specific guidance based on mode
- All output from git commands (no manual formatting)
