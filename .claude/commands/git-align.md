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

**Pre-processing (static):**

!`git fetch origin 2>/dev/null || true`

!`git branch --show-current`

**Workflow execution:**

```bash
#!/bin/bash
TARGET=${1:-main}
MODE=${2:-full}
CURRENT=$(git branch --show-current)

# Collect data once
COUNTS=$(git rev-list --left-right --count origin/$TARGET...HEAD 2>/dev/null || git rev-list --left-right --count $TARGET...HEAD)
read BEHIND AHEAD <<< "$COUNTS"
STATS=$(git diff --stat $TARGET...HEAD 2>/dev/null | tail -1)

# Recommendation logic (DRY)
rec() {
  [ $1 -eq 0 -a $2 -eq 0 ] && echo "aligned" && return
  [ $1 -gt 0 -a $2 -eq 0 ] && echo "ready-to-propose" && return
  [ $1 -eq 0 -a $2 -gt 0 ] && echo "needs-update" && return
  echo "needs-rebase"
}

case "$MODE" in
  summary)
    cat <<-EOF
	<!-- ALIGN-SUMMARY -->
	Current: $CURRENT | Target: $TARGET
	Status: Ahead $AHEAD | Behind $BEHIND
	Recommendation: $(rec $AHEAD $BEHIND)
	<!-- /ALIGN-SUMMARY -->
	EOF
    ;;

  conflicts)
    MERGE_BASE=$(git merge-base $TARGET HEAD)
    FOUND=$(git merge-tree $MERGE_BASE $TARGET HEAD 2>/dev/null | grep -q "^@@" && echo "Possible conflicts" || echo "None")
    STRATEGY=$([ "$FOUND" = "None" ] && echo "safe-to-rebase" || echo "needs-manual-resolution")

    cat <<-EOF
	<!-- CONFLICTS -->
	Current: $CURRENT | Target: $TARGET

	Conflict detection:
	  Conflicts found: $FOUND
	  Rebase strategy: $STRATEGY
	<!-- /CONFLICTS -->
	EOF
    ;;

  *)
    # full mode (default)
    cat <<-EOF
	<!-- ALIGN -->
	Current: $CURRENT | Target: $TARGET
	Status: Ahead $AHEAD | Behind $BEHIND

	$( [ $AHEAD -gt 0 ] && printf 'Your commits (%d):\n%s\n' $AHEAD "$(git log --format='  %h %s' --max-count=20 $TARGET...HEAD 2>/dev/null)" )
	$( [ $BEHIND -gt 0 ] && printf 'Their commits (%d):\n%s\n' $BEHIND "$(git log --format='  %h %s' --max-count=20 HEAD...$TARGET 2>/dev/null)" )
	Changes: $STATS
	Recommendation: $(rec $AHEAD $BEHIND)
	<!-- /ALIGN -->
	EOF
    ;;
esac
```

## Output Reference

**Recommendations** (from `rec()` function):
- `aligned` → 0 ahead, 0 behind (in sync)
- `ready-to-propose` → N ahead, 0 behind (ready to PR)
- `needs-update` → 0 ahead, M behind (pull target)
- `needs-rebase` → N ahead, M behind (rebase before proposing)

**Modes:**
- `summary` → Compact status with recommendation
- `conflicts` → Conflict detection + rebase strategy
- `full` → Complete report with commit lists

## Implementation Details

- Single `rec()` function encodes all recommendation logic (DRY)
- Heredocs (`<<-EOF`) for clean, template-based output
- `git --format` for efficient log formatting
- Conditional blocks in templates (no duplicated code)
- Lazy conflict detection (only in conflicts mode)
