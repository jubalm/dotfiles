# Git Conventions: Detailed Reference

Comprehensive scope definitions, commit patterns, and Git workflow for the dotfiles project.

---

## Commit Types & Meanings

### `feat` - New Feature

**Use when:** Adding new functionality, configuration, or capability

**Examples:**
- `feat(nvim): add lua LSP setup with global config`
- `feat(zsh): implement git prompt with branch indicators`
- `feat(claude): create authoring-memory skill`

**What to avoid:**
- Don't use feat for bug fixes (use `fix`)
- Don't use feat for refactoring (use `refactor`)

### `fix` - Bug Fix

**Use when:** Fixing broken functionality or incorrect behavior

**Examples:**
- `fix(zsh): correct git prompt indicator logic`
- `fix(tmux): fix keybind conflict in which-key menu`
- `fix(nvim): resolve LSP attach race condition`

### `chore` - Maintenance

**Use when:** Updates, deps, or housekeeping (no functionality change)

**Examples:**
- `chore: update lazy.nvim to latest version`
- `chore(install): add new Brewfile packages`
- `chore(claude): reorganize skill structure`

### `refactor` - Code Reorganization

**Use when:** Restructuring without changing functionality

**Examples:**
- `refactor(nvim): split plugin_setup into categorized files`
- `refactor(zsh): move workflow functions to dedicated file`
- `refactor(tmux): consolidate display-menu bindings`

### `docs` - Documentation

**Use when:** Adding or updating documentation

**Examples:**
- `docs(install): clarify Brewfile vs install.py usage`
- `docs(claude): add SKILL.md for authoring-memory`
- `docs: update README with setup instructions`

### `test` - Testing

**Use when:** Adding tests or test infrastructure

**Examples:**
- `test(install): add validation for symlink creation`
- `test(git): add commit scope validation`

### `perf` - Performance

**Use when:** Optimizing performance

**Examples:**
- `perf(zsh): reduce shell startup time by 50ms`
- `perf(nvim): optimize plugin load order`

---

## Scopes: Detailed Definitions

### `nvim` - Neovim Configuration

**Includes:**
- `init.lua` - Main entry point
- `lua/` - All Lua configuration modules
- `plugin_setup/` - Plugin configurations (editing, insight, navigation, ui)
- `colors/` - Custom colorschemes
- Keymaps and commands

**Examples:**
```
feat(nvim): add nvim-ufo plugin for code folding
fix(nvim): resolve LSP document highlighting delay
chore(nvim): update plugins via lazy.nvim
```

**Scope size:** ~20-30% of typical commits

### `zsh` - Zsh Shell Configuration

**Includes:**
- `.zshrc` - Main entry point
- `zsh/` directory and all layers:
  - `platform.zsh` - Environment and PATH setup
  - `runtime.zsh` - Shell behavior and completion
  - `interface.zsh` - Interactive features
  - `workflow.zsh` - Aliases and functions
- `completions/` - Custom completion scripts

**Examples:**
```
feat(zsh): add AWS CLI completion
fix(zsh): correct git status indicator logic
chore(zsh): add kubectl completion
```

**Scope size:** ~15-25% of typical commits

### `tmux` - Tmux Configuration

**Includes:**
- `tmux/` directory
- `tmux.conf` - Configuration file
- Display menus and keybindings

**Examples:**
```
feat(tmux): add new which-key menu option
fix(tmux): fix keybind conflict in window navigation
chore(tmux): update Nord theme colors
```

**Scope size:** ~5-10% of typical commits

### `git` - Git Global Configuration

**Includes:**
- `.gitignore_global` - Global ignore patterns
- Git hooks (if any)
- Global git configuration changes

**Examples:**
```
chore(git): update global gitignore for new tools
feat(git): add pre-commit hook for validation
```

**Scope size:** ~5% of typical commits

### `claude` - Claude Code Configuration

**Includes:**
- `.claude/` directory (project-level)
- `settings.json` - Claude Code settings
- `skills/` - Skill definitions
- `agents/` - Custom agent definitions
- `context/` - Memory/knowledge files (CLAUDE.md, principles.md, etc)
- Slash commands in `commands/`
- MCP configurations in `mcp/`

**Examples:**
```
feat(claude): create authoring-memory skill
fix(claude): update SKILL.md routing hints
chore(claude): reorganize context files
docs(claude): add principles.md with design rationale
```

**Scope size:** ~20-30% of typical commits

### `install` - Installation Script & Dependencies

**Includes:**
- `install.py` - Main installation script
- `Brewfile` - macOS package dependencies
- Any setup automation

**Examples:**
```
feat(install): add Docker Desktop to Brewfile
fix(install): correct symlink backup logic
chore(install): add new packages to Brewfile
```

**Scope size:** ~5-10% of typical commits

### `docker` - Docker Configuration

**Includes:**
- `Dockerfile` (if present)
- `docker-compose.yml` (if present)
- Docker-related configs

**Examples:**
```
feat(docker): add development container config
chore(docker): update base image version
```

**Scope size:** ~0-5% of typical commits (rare)

### No Scope (General/Multiple)

**Use when:** Commit affects multiple scopes or is general maintenance

**Examples:**
```
chore: update .gitignore for new tools
docs: update README
refactor: reorganize directory structure
```

**Pattern:** Only use when truly multi-scope. Prefer specific scope when possible.

---

## Commit Message Examples

### Good Examples

```
feat(nvim): add telescope keybind for project search

Adds Ctrl+P binding for fuzzy project-wide search.
Improves navigation for large projects.

Related: #42
```

```
fix(zsh): correct git prompt dirty state indicator

Was showing dirty when in submodule. Now correctly
detects only working directory changes.
```

```
chore(claude): reorganize skill structure into specializations

Splits monolithic claude-code skill into:
- authoring-agent-skills (Skill authoring)
- authoring-memory (Memory organization)
- authoring-subagents (Agent design)

Enables better discoverability and maintenance.
```

```
refactor(nvim): consolidate plugin configurations

Moves duplicated config into shared utilities.
No functional changes, cleaner maintainability.
```

### Bad Examples

```
❌ feat(misc): added some stuff
(Vague scope, unclear description)

❌ feat: updated everything
(No scope, unclear what changed)

❌ Fixed bug
(Wrong format, no scope or type)

❌ feat(nvim): the new feature I added was that we can now search
(Too long, not imperative)
```

---

## Decision Matrix: When to Use Each Scope

| Situation | Scope | Example |
|-----------|-------|---------|
| Adding Neovim plugin | `nvim` | `feat(nvim): add nvim-cmp completion` |
| Adding shell function | `zsh` | `feat(zsh): add project directory function` |
| Updating tmux menu | `tmux` | `feat(tmux): add new menu option` |
| Fixing git ignore | `git` | `chore(git): add Python build artifacts` |
| Adding Claude skill | `claude` | `feat(claude): create new skill` |
| Adding Homebrew package | `install` | `chore(install): add ripgrep to Brewfile` |
| Multiple or unclear | No scope | `chore: update dependencies` |

---

## Commit Patterns by Component

### Nvim Plugin Updates

```
feat(nvim): add telescope keymap for grep
chore(nvim): update lazy.nvim to v10.0
fix(nvim): resolve LSP attach race condition
```

**Pattern:** Usually feat (new plugin), chore (update), or fix (bug)

### Zsh Configuration

```
feat(zsh): add kubectl completion
chore(zsh): update PATH for new tool
fix(zsh): correct prompt color detection
```

**Pattern:** feat (new feature), chore (maintenance), fix (bug)

### Claude Skills

```
feat(claude): create authoring-memory skill
chore(claude): update routing hints in CLAUDE.md
docs(claude): add best-practices.md
```

**Pattern:** feat (new skill), chore (updates), docs (documentation)

### Installation Changes

```
chore(install): add new Brewfile packages
fix(install): correct symlink backup directory
feat(install): add post-install validation
```

**Pattern:** chore (deps), fix (bugs), feat (new features)

---

## Branch Naming Patterns

### Feature Branch

```
feature/short-description

Examples:
feature/nvim-telescope-keymaps
feature/zsh-git-completion
feature/claude-memory-skill
```

### Fix Branch

```
fix/issue-number-or-description

Examples:
fix/zsh-prompt-colors
fix/nvim-lsp-timeout
```

### Chore Branch

```
chore/maintenance-description

Examples:
chore/update-dependencies
chore/reorganize-skills
chore/cleanup-gitignore
```

### Docs Branch

```
docs/documentation-subject

Examples:
docs/install-instructions
docs/keyboard-shortcuts
```

---

## Multi-Commit Commits

When your change involves multiple commits, follow this pattern:

**Commit 1:** Core change
```
feat(nvim): add LSP keymaps for symbol navigation

Add keymaps for: gd (definition), gr (references), etc.
```

**Commit 2:** Documentation or tests
```
docs(nvim): add LSP keymaps to README
```

**Pattern:** Functional change first, then documentation

---

## When to Squash vs. Separate

### Separate Commits

```
✓ feat(nvim): add telescope plugin
✓ chore(nvim): update lazy.nvim dependencies
```

Different concerns, can be reviewed separately.

### Should Squash

```
❌ fix(nvim): attempt 1
    fix(nvim): attempt 2
    fix(nvim): attempt 3
```

Multiple attempts at the same fix → squash to one

---

## Commit Etiquette

### Good Practices

- ✓ One logical change per commit
- ✓ Commit message explains WHY, not WHAT
- ✓ Use imperative mood ("add", not "added")
- ✓ Reference related issues (#42)
- ✓ Keep commits focused and reviewable

### Anti-Patterns

- ✗ Multiple unrelated changes in one commit
- ✗ Commits with overly long, narrative messages
- ✗ Using wrong type or scope repeatedly
- ✗ Committing unrelated whitespace changes
- ✗ Refactoring and feature changes in same commit

---

## Reference: Quick Lookup

### Find a scope

- Editing `.nvim/` → Use `nvim`
- Editing `.config/zsh/` → Use `zsh`
- Editing `.config/tmux/` → Use `tmux`
- Editing `.claude/` → Use `claude`
- Editing `Brewfile` or `install.py` → Use `install`
- Other git settings → Use `git`

### Find a type

- Adding functionality → `feat`
- Fixing a bug → `fix`
- Refactoring code → `refactor`
- Documentation → `docs`
- Maintenance/updates → `chore`

### Commit message template

```
type(scope): lowercase imperative description (under 50 chars)

[Optional: Explain why this change, not how]

Related: #issue-number (if applicable)
```

---

## Slash Commands

Use these for automated validation:

- `/git-commit [extra-instructions]` - Create commit with validation
- `/git-pr [pr-instructions]` - Create PR with proper format
- `/git-analyze` - Check current branch status
- `/git-align [target-branch]` - Check alignment with main

Example:
```
/git-commit "This is important because we're refactoring auth"
```

---

## Next Steps

1. Review scopes for your next commit
2. Choose the right type (feat/fix/chore/etc)
3. Write concise, imperative description
4. Use `/git-commit` to validate format
5. Create PR with `/git-pr` when ready

See [SKILL.md](SKILL.md) for general Git workflow patterns in this project.
