---
allowed-tools: Bash(git:*), Read
description: Audit git workflow setup and recommend improvements for memory integration [ARCHIVED]
---

# Git Workflow Audit [ARCHIVED]

**Status:** Archived - Redundant with skill-based workflow

Review repository patterns and context memory setup.

## Repository Analysis

**Remote configuration:**
!`git remote -v`

**Branch patterns:**
!`git branch -a --format="%(refname:short)" | head -20`

**Recent commit history:**
!`git log --format="%s" -30 --all`

**Default branch:**
!`git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"`

**Commit authors:**
!`git log --format="%an" -50 | sort | uniq -c | sort -rn`

## Context Memory Check

**Current memory:**
@.claude/CLAUDE.md

## Audit Report

### Repository Profile

Based on analysis above:

**Detected patterns:**
- Main branch: [name from analysis]
- Branch naming: [analyze from branch list - feature/*, bugfix/*, or ad-hoc]
- Commit style: [conventional/descriptive/mixed from commit messages]
- Remote: [GitHub/GitLab/Bitbucket/Other from URL]
- Collaboration: [solo/small team/active team from author count and branch activity]

### Context Status

**Memory location:** [detected - .claude/CLAUDE.md, CLAUDE.md, or missing]

**Git Workflow section:** [exists/missing]

### Critical Check: Delegation Pattern

[If Git Workflow section missing:]
⚠️ **CRITICAL: No Git Workflow documented**

[Documentation continues...]

## Summary

See active skill working-with-git for current workflow guidance.
