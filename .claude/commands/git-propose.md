---
allowed-tools: Bash(git:*), Bash(gh:*)
argument-hint: [target] [mode]
description: Propose changes to target branch. Modes: --validate (check readiness), --draft (preview PR), or create PR. Use for submitting work to team.
---

# Git Propose

Propose changes to target branch via pull request. Create, validate, or draft.

## Parameters

- **TARGET**: `$ARGUMENTS[0]` or "main" (default)
  - Target branch for PR (usually: main, develop)

- **MODE**: `$ARGUMENTS[1]` or "" (default = create)
  - `--validate` - Check readiness without creating PR
  - `--draft` - Show draft PR content without creating
  - (empty) - Create actual PR

## Workflow

### Validation Phase (all modes)

1. **Gather context**:
   - Current branch: `git branch --show-current`
   - Alignment: Compare with target
   - Commits: List all commits not in target
   - Files: List all changed files

2. **Check readiness**:
   - ✗ On main/protected branch → Refuse
   - ✗ Uncommitted changes → Warn, require commitment
   - ✗ Behind target → Warn, require alignment first
   - ✓ Conflicts detected → Warn but allow (user fixes)
   - ✓ Sensitive files → Refuse (never push)
   - ✓ Conventional commits → Validate format

3. **Analyze commits for PR content**:
   - Commit types (feat, fix, chore, etc.)
   - Scopes (nvim, zsh, etc.)
   - Generate PR title from commits
   - Generate PR summary from commit messages
   - Generate test plan recommendations

### Mode-Specific Behavior

**`--validate` mode**

Output readiness report only, don't create PR.

```
<!-- VALIDATE -->
Target: [target]
Current: [branch]

Status: [Ready ✓ | Not Ready ✗]

Checks:
  ✓ Aligned with target (3 ahead, 0 behind)
  ✓ All commits conventional format
  ✓ No sensitive files detected
  ✗ [any issues listed with symbols]

PR Preview:
  Title: [generated title]
  Commits: [count]

Next: /git-propose [target] (to create)
       /git-propose [target] --draft (to preview)
<!-- /VALIDATE -->
```

**`--draft` mode**

Show draft PR content without creating.

```
<!-- PROPOSE-DRAFT -->
Target: [target] ← [current-branch]
Title: [title]

Summary:
[generated summary from commits]

Test plan:
[generated test plan recommendations]

Files changed: [count]
  [file1] (+lines, -lines)
  [file2] (+lines, -lines)

Commits: [count]
  [hash]  [message]
  [hash]  [message]

Next: /git-propose [target] (to create)
<!-- /PROPOSE-DRAFT -->
```

**Default mode (create)**

Create actual PR and output confirmation.

```
<!-- PROPOSE -->
PR Created: #[number]
URL: [pr-url]

Title: [title]
Target: [target] ← [current-branch]

Commits: [count]
Status: Open
Checks: Pending

Next steps:
  → Await review
  → Address feedback
  → Push updates to same branch
<!-- /PROPOSE -->
```

## PR Content Generation

**Title** (first line of first commit, or synthesized):
- Single commit: Use commit message
- Multiple commits: Synthesize from commit types/scopes

**Summary** (from commit messages):
- List bullet points from commit messages
- Omit trivial commits (chore, refactor if minor)

**Test Plan**:
- Generate from commit scopes (nvim → test nvim config, etc.)
- Include file change summary
- Provide common test scenarios

## Validation Rules

**REFUSE on:**
- On protected/main branch (can't propose from main)
- Uncommitted changes (everything must be committed)
- Sensitive files detected (.env, *.key, credentials, etc.)
- Invalid conventional commits (wrong format)
- Private/draft branch without force flag

**WARN on:**
- Behind target (will need rebase)
- Conflicts likely (file overlap detected)
- Large PR (>500 lines changed)
- Missing conventional commit format (some commits invalid)

**ALLOW with caution:**
- Diverged branches (ahead and behind)
- Multiple concerns in single PR (bad practice, but not forbidden)

## Implementation Notes

- Use `gh pr create` for actual PR creation
- Never create draft PRs automatically (user must choose)
- Generate all content from commit history (no manual editing)
- Keep PR description under 2000 characters (GitHub limit)
- Include link to alignment check if not aligned
- All output from git/gh commands (structured data only)
