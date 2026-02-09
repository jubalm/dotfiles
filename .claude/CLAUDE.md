# Dotfiles

Personal dev env config: XDG 1:1 symlink mirroring, modular structure

## Memory Imports

@memory/constraints.md
@memory/quirks.md
@memory/decisions.md
@memory/conventions.md

## Structure

**Root:**
- home/ (all files symlinked to ~/)
- Brewfile (macOS deps)
- install.py (symlink installer w/ backups)
- misc/theme.itermcolors (Nord iTerm2)

**Home (home/ → ~/):**
- .zshrc → ~/.zshrc
- .gitignore_global → ~/.gitignore_global
- .claude/ → ~/.claude/ (settings, MCP configs, memory, skills)
  - settings.local.json (local overrides, not committed)
- .config/ → ~/.config/ (XDG Base Directory)
  - nvim/ (Lua, lazy.nvim, modular plugin_setup/)
  - tmux/ (native which-key menus)
  - lazygit/ (Nord theme)
  - zsh/ (4-layer arch: platform→runtime→interface→workflow)
    - completions/ (AWS, kubectl, eksctl, deno)
    - prompt/ (git status indicators)

## Claude CLI (`cld` Wrapper)

Smart launcher with LSP enabled, MCP server management, and provider switching:

**Features:**
- LSP enabled by default (IDE-level code intelligence)
- MCP server loading: `cld -m playwright context7`
- Provider switching: `cld -p zai` (Z.ai, Ollama, custom endpoints)
- Local settings overrides via `~/.claude/settings.local.json`

**Settings Management:**
- `~/.claude/settings.local.json` - Machine-scoped settings (not committed)
- Provider config merges with local settings (local takes precedence)
- Supports deep merging of nested JSON objects

**Examples:**
```bash
cld                                    # Run with local settings
cld -m p c                             # Playwright + Chrome DevTools
cld -p zai -m dev                      # Z.ai provider + dev MCP bundle
cld -m playwright -- --print "test"    # Pass args to Claude
```

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
