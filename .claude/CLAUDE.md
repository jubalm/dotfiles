# Dotfiles

Personal development environment setup for macOS.

## Purpose

One-command development environment setup. Modular, XDG-compliant structure that's fast, transparent, and easy to modify.

## How It Works

- `install.py` symlinks `home/` → `~/` with timestamped backups to `backups/`
- Homebrew dependencies installed via `Brewfile`
- 4-layer ZSH architecture with explicit load order
- Neovim with lazy.nvim (async plugin loading)
- Tmux with which-key menus (visual key discovery)

## On-Demand Context

- [memory/decisions.md](memory/decisions.md) - Historical "why" behind choices
- [memory/cld.md](memory/cld.md) - Claude CLI wrapper design

## Structure

**Root:**
- `home/` (all files symlinked to `~/`)
- `Brewfile` (macOS deps)
- `install.py` (symlink installer w/ backups)
- `misc/theme.itermcolors` (Nord iTerm2)

**Home (`home/` → `~/`):**
- `.zshrc` → `~/.zshrc`
- `.gitignore_global` → `~/.gitignore_global`
- `.claude/` → `~/.claude/` (settings, MCP configs)
  - `settings.local.json` (local overrides, not committed)
- `.config/` → `~/.config/` (XDG Base Directory)
  - `nvim/` (Lua, lazy.nvim, modular plugin_setup/)
  - `tmux/` (native which-key menus)
  - `lazygit/` (Nord theme)
  - `zsh/` (4-layer arch: platform→runtime→interface→workflow)
    - `completions/` (AWS, kubectl, eksctl, deno)
    - `prompt/` (git status indicators)

## Critical: Shell Load Order

```
platform.zsh → runtime.zsh → interface.zsh → workflow.zsh
```

**⚠️ Changing this order breaks dependencies**

## Conventions

- **Editor:** `.editorconfig` (tabs, spacing, line endings)
- **Leader:** `<space>`
- **LSP:** `gd` (definition), `gr` (references), `K` (hover), `<leader>rn` (rename), `<leader>ca` (code action)
- **Telescope:** `<leader>p` (files), `<leader>sg` (grep), `<leader>sw` (word), `<leader>sd` (diagnostics)
- **Tmux:** `Ctrl+b ?` (menu), `hjkl` (panes), `HJKL` (resize), `|` (vsplit), `-` (hsplit)

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
