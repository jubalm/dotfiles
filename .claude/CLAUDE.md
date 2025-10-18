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

## Knowledge (Context)

**When:** Design questions, project philosophy, "why this way?"
→ @context/principles.md

**When:** Structure decisions, organization patterns, constraints
→ @context/architecture.md

**When:** Non-obvious implementation, "how does X work?"
→ @context/patterns.md

**When:** Managing discoveries, promoting to permanent files
→ @context/inbox.md

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
