---
allowed-tools: Bash(git:*), Read
argument-hint: [target-branch]
description: Check alignment with team's remote state (push or PR readiness)
---

# Git Alignment Check

Am I aligned with the team?

## Variables

TARGET: `$1` (optional - if provided, checks PR alignment; if empty, checks push alignment)

## Base Context Gathering

!`git fetch --quiet 2>&1`

**Local position:**
!`git branch --show-current`

**Tracking branch:**
!`git rev-parse --abbrev-ref @{upstream} 2>/dev/null || echo "no-tracking"`

**Commit comparison (if tracking exists):**
!`git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0"`
!`git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0"`

## Memory Context

@.claude/CLAUDE.md

## Alignment Analysis

### Scenario Detection

**If no TARGET provided (push alignment):**
- Checking alignment with tracking branch
- Context: Push readiness

**If TARGET provided (PR alignment):**
- Checking alignment with target branch: $TARGET
- Context: PR readiness for merging into $TARGET

### Alignment Report

**Your position:**
- Branch: [current branch name]
- Local commits: [ahead count]

**Team's position:**
[If push context:]
- Remote tracking: [tracking branch]
- Remote ahead by: [behind count]

[If PR context - use Bash tool conditionally:]
- Target branch: $TARGET
- Target ahead by: [calculate with git rev-list]
- Commits in PR: [calculate with git log]

**Alignment status:**
- ✅ Aligned: Ready to push/PR
- ⚠️ Behind: Team ahead, need to pull
- ⚠️ Ahead: Local commits not pushed
- ⚠️ Diverged: Both have unique commits
- ⚠️ No tracking: Need to set upstream

**Conflict risk:**
[If PR context:]
- Check conflicts: Use `git merge-tree` to detect
- Show conflicting files if any

**To align:**
[Provide specific commands based on status:]
- If behind only: `git pull` or `git pull --rebase`
- If ahead only: `git push` or `git push -u origin [branch]`
- If diverged: `git pull --rebase` then `git push`
- If no tracking: `git push -u origin [branch]`

[If PR context with conflicts:]
- Sync with target first: `git fetch origin $TARGET && git rebase origin/$TARGET`
- Or merge strategy: `git merge origin/$TARGET`

**Memory rules applied:**
- Merge strategy: [extract from CLAUDE.md - rebase/merge preference]
- Protected branches: [check if target is protected]
- Alignment workflow: [any project-specific rules]

**Why alignment matters:**
[Explain specific situation - team pushed X commits, or target branch advanced, etc.]

**Next steps:**
- [Specific recommendation based on context and memory]
