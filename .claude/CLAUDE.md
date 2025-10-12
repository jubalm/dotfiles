# Dotfiles

Personal dev env config: XDG 1:1 symlink mirroring, modular structure

## Structure

**Root:**
- .zshrc → ~/.zshrc
- .gitignore_global → ~/.gitignore_global
- Brewfile (macOS deps)
- install.py (symlink installer w/ backups)
- .claude/ → ~/.claude/ (settings, MCP configs)
- misc/theme.itermcolors (Nord iTerm2)

**XDG (mirrors ~/.config/):**
- nvim/ → ~/.config/nvim/ (Lua, lazy.nvim, modular plugin_setup/)
- tmux/ → ~/.config/tmux/ (native which-key menus)
- lazygit/ → ~/.config/lazygit/ (Nord theme)
- zsh/ → ~/.config/zsh/ (4-layer arch: platform→runtime→interface→workflow)
  - completions/ (AWS, kubectl, eksctl, deno)
  - prompt/ (git status indicators)

## Knowledge

**When:** Design questions, project philosophy, "why this way?"
→ @context/principles.md

**When:** Structure decisions, organization patterns, constraints
→ @context/architecture.md

**When:** Non-obvious implementation, "how does X work?"
→ @context/patterns.md

**Staging:** Discoveries pending curation (load only when managing knowledge)
→ @context/inbox.md

**Meta:** Style rules for context files
→ @context/context-guidelines.md

## Quick Start

Install:
```bash
./install.py
```

Nvim plugins:
```vim
:Lazy sync
```

Tmux menu:
```
Ctrl+b ?
```

## Git Workflow

**Claude delegation:**
- Natural language git requests ("commit this", "am I aligned?", "push") → git-specialist agent handles
- Explicit commands (`/git-analyze`, `/git-align`, `/git-setup`) → Run directly only when user invokes
- Why: Agent has separate context, provides concise summaries, applies workflow rules automatically

**Main branch:** `main`

**Branch naming:**
- `feature/description` (e.g., feature/vim-mode, feature/123-lazy-loading)
- `bugfix/description`
- `hotfix/description`

**Merge strategy:**
- Direct commit to `main` for solo dev (current pattern)
- Squash feature branches if experimenting
- Why: Linear history → clean, easy review/rollback for personal dotfiles

**Commit format (Conventional Commits):**
```
type(scope): description
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Scopes:** claude, nvim, zsh, tmux, git, docker, config

**Examples:**
```
feat(claude): transform context-bootstrap into full lifecycle context-manager agent
fix(docker): correct Docker Desktop installation in Brewfile
refactor(claude): restructure knowledge into modular context system
```

**Alignment:**
- Solo work on main: Pull before push (avoid conflicts)
- Feature branches: Align w/ main before PR (`/git-align main`)
- Force push: Personal feature branches only, NEVER `main`

**Never commit:**
- .env*, *.key, *.pem, *.p12, *.crt
- credentials/, secrets/, private/
- SSH keys, API tokens, passwords

**GitHub:**
- Link issues: `Closes #123`, `Fixes #456`
- PRs optional for solo work (direct to main is fine)
- Branches for experiments you might discard
