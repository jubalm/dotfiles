---
allowed-tools: Bash(git log:*), Bash(git diff:*), Bash(git status:*), Bash(gh pr:*), Bash(gh pr status:*), Bash(gh pr edit:*)
argument-hint: [pr-instructions]
description: Create conventional PR title and description with automated branch analysis
---

# Pull Request Creation and Analysis

Create conventional PR title and description using automated analysis of branch changes with intelligent workflow modification.

## Variables

- **PR_INSTRUCTIONS**: `$ARGUMENTS` or "create complete PR" (default)
  - Accepts natural language instructions for PR operations, content focus, and workflow behavior modification

## Instructions

- **PR State Detection**: Always check existing PR state first using `gh pr status` before determining operation
- **Intent Recognition**: Parse natural language in `PR_INSTRUCTIONS` for operation type, content focus, and workflow modification
- **Operation Types**: Create new PR, update existing PR, view current PR, close PR, convert draft status
- **Content Focus Patterns**: "security changes only", "focus on breaking changes", "highlight performance improvements"
- **Workflow Modification Intent**: "just show title", "create draft PR", "don't create yet", "analyze changes only", "update description"
- **Existing PR Handling**: When PR exists, default to update operations unless explicit create intent detected
- **Conflict Resolution**: If PR exists and create intent detected, inform user and suggest update instead
- **Title Standards**: Use conventional PR format `<type>: <brief description>` with types: feat, fix, refactor, perf, style, docs, test, chore
- **Title Length**: Keep under 50 characters using imperative mood
- **Description Quality**: Generate comprehensive descriptions with Summary, Test Plan, and Breaking Changes sections when appropriate
- **Issue Linking**: Include issue references ("Closes #123") when mentioned in instructions or detected in commit messages
- **Content Focus**: Emphasize motivation and reasoning, not just code changes

## Workflow

1. **PR State Detection**: Run `gh pr status` to check if PR already exists for current branch
2. **Change Analysis**: Run `git log --oneline origin/main..HEAD` and `git diff origin/main..HEAD` to analyze branch changes
3. **Intent Analysis**: Parse `PR_INSTRUCTIONS` for operation type, content focus, and workflow modification intent
4. **Operation Branching**: Determine execution path based on PR state and user intent:
   - **No Existing PR Path**: Generate title/description, then create new PR
   - **Existing PR Path**: Retrieve current PR details, then update based on intent
   - **View-Only Path**: Display requested information without modifications
5. **Content Generation**:
   - For new PRs: Generate conventional title and comprehensive description
   - For existing PRs: Generate updates based on new changes and user intent
6. **Conditional Execution**: Execute appropriate operation based on intent:
   - View operations: Display current/generated PR information and stop
   - Update operations: Use `gh pr edit` to modify existing PR
   - Create operations: Use `gh pr create` for new PR (with conflict handling)
   - Preview operations: Show generated content without executing changes
7. **Result Verification**: Confirm operation success and provide relevant URLs/status

## Reporting

1. **PR State**: Communicate whether working with existing PR or creating new PR, including current PR URL if applicable
2. **Operation Result**: Confirm successful execution of intended operation (created, updated, viewed, etc.)
3. **Generated Content**: Display the PR title and description that were created or updated
4. **Change Analysis**: Summarize the key changes that drove the PR content decisions
5. **Conflict Handling**: If conflicts occurred (e.g., create intent with existing PR), explain resolution taken
6. **Next Steps**: Suggest relevant follow-up actions based on operation type (request reviewers, merge when ready, continue development)
