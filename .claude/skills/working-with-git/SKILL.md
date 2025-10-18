---
name: Working with Git (Dotfiles)
description: Git workflow for this project - conventional commits, valid scopes, branch naming, alignment patterns. Use when making commits, creating branches, opening PRs, or checking git alignment.
---

# Working with Git (Dotfiles)

**Project-level skill:** Git conventions and workflows specific to the dotfiles project.

This guide teaches how to work with Git in this project using Conventional Commits, proper scope usage, and alignment checks.

---

## When to Use This Skill

- Making a commit
- Creating a new branch
- Opening a pull request
- Checking branch alignment with main
- Understanding project commit history

---

## Core: Conventional Commits with Project Scopes

### Commit Format

```
type(scope): description

[Optional detailed explanation]
```

**Types:** `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`

**Scopes:** Project-specific areas (see scopes list below)

**Description:** Lowercase, imperative, under 50 characters

### Valid Project Scopes

| Scope | Area |
|-------|------|
| `nvim` | Neovim config (init.lua, plugins, keymaps) |
| `zsh` | Zsh shell config (functions, aliases, completions) |
| `tmux` | Tmux configuration |
| `git` | Git global config, hooks |
| `claude` | Claude Code setup (skills, agents, context) |
| `install` | Installation script, Brewfile |
| `docker` | Docker configs (if present) |

### Examples

```
feat(nvim): add telescope keymap for grep
fix(zsh): correct git prompt indicator logic
chore(claude): update SKILL.md documentation
refactor(tmux): consolidate display-menu bindings
docs(install): clarify Brewfile usage
test(git): add validation for commit scopes
```

---

## Branch Naming

**Convention:** `type/short-description`

**Types:** `feature`, `fix`, `chore`, `docs`

**Examples:**
```
feature/nvim-lsp-keymaps
fix/zsh-prompt-colors
chore/update-dependencies
docs/readme-improvements
```

---

## Pull Request Workflow

### 1. Create Branch

```bash
git checkout -b feature/descriptive-name
```

### 2. Make Commits

Use Conventional Commits format (see above)

### 3. Create PR

**Title:** `type(scope): description` (same as commit)

**Description template:**
```markdown
## Summary
- [What changed and why]
- [Key decisions or implementation approach]

## Test Plan
- [How to test these changes]
- [What shouldn't break]
```

### 4. Alignment Check

Before pushing, check alignment with main:

```bash
git diff main...HEAD
# Should show only your changes
```

### 5. Merge

Merge into main after approval. Branch is automatically deleted.

---

## Understanding Your Project

**Dotfiles structure:**
- `nvim/` → Neovim configuration
- `zsh/` → Zsh shell configuration
- `tmux/` → Tmux configuration
- `.claude/` → Claude Code settings and skills
- `misc/` → Miscellaneous configs (themes, etc.)

**Key files:**
- `install.py` → Main installation script
- `Brewfile` → macOS package dependencies
- `.zshrc` → Zsh entry point

---

## Helpful Commands

### Check Status

```bash
git status
```

Shows current branch and changes.

### View Recent Commits

```bash
git log --oneline -10
```

Shows recent commit history with messages.

### Align with Main

```bash
git fetch origin
git log main..HEAD
```

Shows commits in your branch not in main.

### Check Diff

```bash
git diff main...HEAD
```

Shows all changes in your branch.

---

## Detailed Guidance

For comprehensive Git workflow patterns:
- See [conventions.md](conventions.md) for detailed scope definitions
- Use `/git-commit`, `/git-pr`, `/git-align` slash commands for automated workflow

For framework context:
- This is a **project-level skill** (specific to dotfiles)
- See `authoring-agent-skills` skill for universal Git patterns
- See Memory (@context/architecture.md) for project architecture

---

## Quick Reference

**Quick commit checklist:**
- [ ] Scope is valid (see list above)
- [ ] Type is correct (feat/fix/chore/etc)
- [ ] Description under 50 chars
- [ ] Lowercase and imperative
- [ ] Only one concern per commit

**Quick PR checklist:**
- [ ] Branch name follows convention
- [ ] All commits follow format
- [ ] Description explains why, not what
- [ ] Aligned with main (no conflicts)

---

## Next Steps

1. Review [conventions.md](conventions.md) for detailed scope definitions
2. Use `/git-analyze` to check current branch status
3. Use `/git-commit` to create a commit with validation
4. Use `/git-pr` to create a pull request

For universal Git patterns (applicable to any project), see the `authoring-agent-skills` skill.
