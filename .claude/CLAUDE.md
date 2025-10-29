# Dotfiles

Personal dev env config: XDG 1:1 symlink mirroring, modular structure

## Memory Imports

@memory/constraints.md
@memory/quirks.md
@memory/decisions.md
@memory/conventions.md

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
