---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git commit:*), Bash(git log:*)
argument-hint: [filter]
description: Create intelligent checkpoint commit with validation. Stages changes, validates format, generates conventional message. Use for saving work progress.
---

# Git Checkpoint

Create a conventional commit checkpoint with smart staging and validation.

## Parameters

- **FILTER**: `$ARGUMENTS` or "all" (default)
  - Natural language filters: "nvim only", "docs and config", "bug fixes"
  - Or specific file patterns: "*.lua", "src/"
  - Default: includes all relevant changes

## Workflow

1. **Get current state**: `git status -s && git diff --stat`

2. **Analyze changes**:
   - Categorize by file type (nvim, zsh, tmux, claude, etc.)
   - Detect change types (feature, fix, refactor, docs)
   - Check for sensitive files (.env, *.key, credentials, etc.)

3. **Apply filter** (if provided):
   - Include/exclude based on FILTER parameter
   - Show user what will be staged

4. **Stage files**:
   ```bash
   git add [selected files]
   ```

5. **Validate**:
   - ✗ Refuse if sensitive files detected
   - ✗ Refuse if changes seem incomplete/confused
   - ✓ Proceed if valid

6. **Generate commit message**:
   - Determine type (feat, fix, chore, refactor, docs, etc.)
   - Determine scope (nvim, zsh, tmux, git, claude, install, docker)
   - Format: `type(scope): description`
   - Validate under 50 characters

7. **Create commit**:
   ```bash
   git commit -m "[message]"
   ```

8. **Verify and report**

## Output Format

```
<!-- CHECKPOINT -->
Commit: [hash]
Type: [type(scope)]
Message: [full message]

Files committed:
  [file1]
  [file2]
  [file3]

Changes: +[lines], -[lines]

Next actions:
  → /git-align main (check sync)
  → /git-propose main --validate (prepare for PR)
<!-- /CHECKPOINT -->
```

## Validation Rules

- **Refuse on:**
  - Sensitive files (.env, *.key, credentials, client_secret, etc.)
  - Commit message not conventional format
  - Scope invalid (not in: nvim, zsh, tmux, git, claude, install, docker)

- **Warn on:**
  - Very large diffs (>500 lines changed)
  - Multiple unrelated concerns mixed
  - Incomplete work (uncommitted setup files)

## Handling Filters

**Examples:**

```
/git-checkpoint                    # Stage all changes
/git-checkpoint nvim only          # Only nvim files
/git-checkpoint docs and config    # Docs + config files
/git-checkpoint bug fixes          # Only bug-related changes
/git-checkpoint zsh/**             # Only zsh directory
```

**Matching:**
- Natural language: Analyze file paths and diff content semantically
- Glob patterns: Direct file matching
- Type filters: Analyze change nature (feature vs fix vs refactor)

## Implementation Notes

- Use conventional commit format strictly
- Never use interactive git (no `git add -i`, `git commit --amend`)
- Always use HEREDOC for multi-line messages
- Validate against project scope list from memory (@context/architecture.md if available)
- Show clear staging summary before confirming
- If pre-commit hooks modify files, retry once to include changes
