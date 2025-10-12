---
allowed-tools: Bash(git:*), Read
description: Audit git workflow setup and recommend improvements for memory integration
---

# Git Workflow Audit

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

Without documented delegation pattern, Claude will invoke git commands directly in main conversation instead of using git-specialist agent. This wastes context and bypasses workflow intelligence.

[If Git Workflow exists - check content for delegation pattern:]

[If delegation pattern missing from existing workflow:]
⚠️ **CRITICAL: Delegation pattern missing from workflow**

Git Workflow exists but doesn't explain Claude's operating pattern. Main conversation will invoke `/git-analyze`, `/git-align` directly instead of delegating to git-specialist agent.

[If delegation pattern exists:]
✅ Delegation pattern documented - git operations will use agent properly

### Workflow Elements Review

[If Git Workflow exists, review what's covered:]

**Currently documented:**
[List sections: commit format, merge strategy, branch naming, alignment rules, etc.]

**Potential additions:**
[Only suggest if missing:]
- Commit format guidelines
- Merge strategy preference (rebase/merge/squash)
- Branch naming conventions
- Alignment rules (when to sync before push/PR)
- Never-commit patterns (sensitive files)
- PR workflow (issue linking, reviews)

[If no workflow exists:]

**Recommended workflow elements based on repository:**

Generate suggestions based on detected patterns:
- Branch strategy for [solo/team] workflow
- Merge strategy: [suggest based on history - squash for clean history, rebase for feature branches, etc.]
- Commit format: [conventional if detected, descriptive otherwise]
- Alignment: Always check before push/PR
- Never commit: .env*, *.key, credentials/
- [GitHub-specific if detected]: Issue linking, PR reviews

## Delegation Pattern (Mandatory)

**This MUST be in Git Workflow section:**

```markdown
**Claude delegation:**
- Natural language git requests ("commit this", "am I aligned?", "push") → git-specialist agent handles
- Explicit commands (`/git-analyze`, `/git-align`, `/git-setup`) → Run directly only when user invokes
- Why: Agent has separate context, provides concise summaries, applies workflow rules automatically
```

**Critical:** Without this pattern, the git framework doesn't work. Main Claude will bypass agent and waste context.

## Integration Recommendation

**Context analysis:**

Your project [has/does not have] context memory at [memory location]. [If exists: Git Workflow section [exists/missing]. Delegation pattern [documented/missing].]

**Recommended action:**

[If no context:]
Bootstrap `.claude/CLAUDE.md` with Git Workflow section including delegation pattern and repository-based workflow recommendations above.

[If context exists but no Git Workflow:]
Add Git Workflow section to existing context. **Delegation pattern is mandatory** - include first, then workflow elements based on repository patterns.

[If context exists with Git Workflow but no delegation pattern:]
**CRITICAL UPDATE NEEDED:** Add delegation pattern to existing Git Workflow section. This is non-negotiable for framework to function.

[If everything exists:]
Review workflow elements above for potential additions based on current repository patterns.

**Integration method:**

[If context-manager agent available:]
Recommend using [agent name] to update Git Workflow section. Context-manager understands delta documentation and can integrate properly.

Use language that triggers context-manager: "This delegation pattern and workflow captures repository-specific git operation strategy that Claude needs to function correctly with git-specialist agent."

[If no context-manager:]
Manual integration: Copy delegation pattern (mandatory) and relevant workflow elements into [memory location].

## Summary

**Must have:** Delegation pattern in CLAUDE.md Git Workflow
**Nice to have:** Repository-specific workflow elements
**Integration:** Context-manager preferred, manual fallback

Start using git-specialist for all natural language git operations once delegation pattern is documented.
