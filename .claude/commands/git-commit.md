---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git commit:*), Bash(git log:*)
argument-hint: [extra-instructions]
description: Intelligent git commits with optional file selection guidance
---

# Git Commit Message Creation

Create conventional git commit using automated analysis of current changes.

## Variables

- **EXTRA_INSTRUCTIONS**: `$ARGUMENTS` or "include all relevant changes" (default)
   - Contains natural language instructions for both file selection and workflow behavior modification

## Instructions

- Parse natural language in `EXTRA_INSTRUCTIONS` for both file selection and workflow modification intent
- File selection patterns: exclusions ("do not include"), inclusions ("only"), semantic filters ("bug fixes only")
- Workflow modification intent: "just show message", "don't commit yet", "let me review", "what would be committed?"
- Identify file types from extensions and directories: tests (*.test.js, spec/, __tests__/), docs (*.md, docs/, README), config (*.json, *.yaml, config/)
- For semantic filtering, analyze git diff content to understand change nature (features, fixes, refactoring)
- Never commit sensitive files (.env, keys, credentials) regardless of instructions
- Use HEREDOC format for multi-line commit messages, never interactive git commands
- If pre-commit hooks modify files, retry commit once to include automated changes

## Workflow

1. Run `git status`, `git diff --staged`, `git diff`, and `git log --oneline -10` to gather repository state
2. Analyze `EXTRA_INSTRUCTIONS` for file selection strategy and workflow modification intent
3. Execute `git add` commands to stage selected files
4. Generate conventional commit message from staged changes
5. **Conditional execution based on workflow intent**:
   - If message-only intent ("just show message", "what would the message be?"): Display message and stop
   - If preview intent ("what would be committed?", "don't commit yet"): Show staged files and message, then stop
   - If review intent ("let me review first"): Show staged files and message, await confirmation
   - If normal operation: Continue to step 6
6. Execute `git commit` with HEREDOC-formatted message
7. If pre-commit hooks fail, retry commit once to include automated changes
8. Run final `git status` to verify commit success

## Reporting

1. **Completion Confirmation**: Report successful commit creation with commit hash
2. **File Summary**: List what files were staged and committed
3. **Strategy Used**: Briefly note whether autonomous or instruction-based staging was applied
4. **Next Steps**: Indicate if push to remote or additional review is recommended
