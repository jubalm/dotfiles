---
allowed-tools: Bash(git:*), Read
description: Analyze local git repository state with memory-aware context
---

# Git State Analysis [ARCHIVED]

**Status:** Archived - Replaced by `/git-snapshot`

Local repository snapshot with project memory integration.

## Context Gathering

**Status:**
!`git status -s`

**Staged changes:**
!`git diff --staged --stat`

**Unstaged changes:**
!`git diff --stat`

**Recent commits:**
!`git log -10 --oneline --no-decorate`

**Current branch:**
!`git branch --show-current`

**Stashed work:**
!`git stash list | head -5`

## Memory Context

@.claude/CLAUDE.md

## Analysis

**Working tree state:**
- Modified files: [count and summarize]
- Staged files: [count and list if <5, else summarize]
- Unstaged files: [count and list if <5, else summarize]
- Untracked files: [count and list if <3, else summarize]

**Commit history:**
- Last 5 commits: [summarize pattern/theme]
- Commit frequency: [recent activity level]

**Branch status:**
- Current: [branch name]
- Type: [feature/bugfix/main/develop based on name]

**Memory rules (if present):**
- Git workflow preferences: [extract from CLAUDE.md]
- File exclusions: [extract never-commit rules]
- Commit format: [extract conventions]

**Recommendations:**
- Safe to commit: [yes/no based on sensitive files check]
- Suggested action: [commit/stage/review/cleanup]
- Next steps: [based on current state + memory rules]

**Notable:**
- ⚠️ Warn if .env, *.key, credentials, or sensitive patterns detected
- ⚠️ Note if working tree is very dirty (>20 modified files)
- ⚠️ Flag if stashes exist (might indicate incomplete work)
