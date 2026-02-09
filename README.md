# Jubal's Personal Dotfiles

**Clean, portable dotfiles most development environment**

This repository contains my personal development environment setup, featuring a modular Neovim configuration, organized shell setup, and automated installation scripts. Designed to quickly bootstrap a complete development environment on any macOS machine.

## Features

- **One-command setup**: Complete development environment with automated Homebrew integration
- **Claude CLI wrapper (`cld`)**: Smart launcher with LSP, MCP servers, and provider switching
- **Minimal but functional zsh**: Stripped down configuration with essential completions and fast startup
- **Custom git-aware prompt**: Clean, minimal design showing branch status and changes
- **Modern Neovim with LSP**: Full development environment with code completion and formatting
- **Tmux with which-key**: Terminal multiplexer with visual key guide menus for easy learning
- **Portable organization**: XDG-compliant structure that's easy to understand and modify

## Install

```bash
# Clone and install everything
git clone git@github.com:jubalm/dotfiles.git
cd dotfiles
./install.py
```

The installer handles everything: Homebrew setup, tool installation, config symlinks, and Neovim plugin initialization. Your existing configs are safely backed up to `backups/`.

**Optional flags:**
```bash
./install.py --no-nvim          # Skip Neovim setup
./install.py --no-skills        # Skip Claude skills
./install.py --no-dependencies  # Skip Homebrew packages
```

## Claude CLI (`cld` Wrapper)

Enhanced Claude Code launcher with integrated development features:

**Core Features:**
- **LSP enabled by default**: IDE-level code intelligence for Python, TypeScript, Go, Rust, Java, and more
- **MCP Server Loading**: Load Playwright, Chrome DevTools, Context7, Figma, and custom servers
- **Provider Switching**: Switch between Anthropic, Z.ai, Ollama, or custom endpoints
- **Local Settings**: Machine-scoped settings overrides via `~/.claude/settings.local.json`

**Quick Examples:**
```bash
cld                                 # Run with LSP and local settings
cld -m p c                          # Add Playwright + Chrome DevTools
cld -p zai -m dev                   # Use Z.ai with dev MCP bundle
cld -m playwright -- --print "foo"  # Pass arguments to Claude
```

See `cld -h` for full documentation.

## Neovim Features

### LSP & Development
- **Language Servers**: Auto-configured for JavaScript, TypeScript, Lua, and more
- **Code Completion**: Intelligent autocomplete with nvim-cmp
- **Syntax Highlighting**: Advanced Treesitter parsing
- **Code Formatting**: Built-in formatting with LSP

### Navigation & UI
- **Fuzzy Finding**: Telescope for files, grep, git, and more
- **Git Integration**: Gitsigns and Telescope git commands (uses lazygit for operations)
- **Status Line**: Beautiful lualine with git and LSP information
- **Markdown Rendering**: Enhanced markdown display with render-markdown plugin

### Key Bindings
- **Leader Key**: `<space>`
- **File Navigation**: `<leader>p` (files), `<leader>sg` (grep)
- **LSP**: `gd` (definition), `gr` (references), `K` (hover)
- **Git**: `<leader>gf` (git files), `<leader>gp/gn` (hunk navigation)

## Tmux Features

### Session Management
- **Which-key Interface**: Press `Ctrl+b ?` for visual command menu
- **Vi-mode Navigation**: Use `hjkl` for pane navigation
- **Intuitive Splits**: `|` for vertical, `-` for horizontal splits
- **Mouse Support**: Click to select panes and scroll through history

### Key Bindings
- **Prefix**: `Ctrl+b` (default, two-handed but ergonomic)
- **Help Menu**: `Ctrl+b ?` - Visual which-key style menu
- **Quick Pane Menu**: `Ctrl+b P` - Fast pane operations
- **Split Panes**: `Ctrl+b |` (vertical), `Ctrl+b -` (horizontal)
- **Navigate Panes**: `Ctrl+b h/j/k/l` (vim-style)
- **Copy Mode**: `Ctrl+b v` (vi-style with system clipboard)
- **Reload Config**: `Ctrl+b r`

## Terminal Setup

Set your terminal font to **"Hack Nerd Font"** (installed automatically) for the best experience with icons and symbols.

## Updates

To update the configuration:

```bash
cd dotfiles
git pull origin main
nvim --headless -c "Lazy! sync" -c "qall"
```

To reinstall everything after pulling updates:

```bash
./install.py
```

## Repository Structure

```
dotfiles/
├── home/                      # Files symlinked to ~/
│   ├── .zshrc                # Shell configuration
│   ├── .gitignore_global     # Global git ignore patterns
│   ├── .claude/              # Claude CLI configuration
│   │   ├── settings.local.json # Local machine-scoped settings (not committed)
│   │   ├── servers/          # MCP server configurations
│   │   ├── memory/           # Project memory system
│   │   └── skills/           # Custom Claude skills
│   └── .config/              # XDG Base Directory structure (→ ~/.config/)
│       ├── nvim/             # Complete Neovim configuration
│       │   ├── init.lua      # Entry point
│       │   ├── lua/user/     # Modular configuration
│       │   │   ├── editor.lua    # Core editor settings
│       │   │   ├── keymap.lua    # Global keymaps
│       │   │   ├── plugins.lua   # Lazy.nvim setup
│       │   │   └── plugin_setup/ # Plugin configurations
│       │   │       ├── editing.lua    # Completion, snippets, commenting
│       │   │       ├── insight.lua    # LSP, Treesitter, diagnostics
│       │   │       ├── navigation.lua # Telescope fuzzy finder
│       │   │       └── ui.lua         # Status line, UI, markdown rendering
│       │   └── colors/       # Custom colorscheme
│       ├── lazygit/          # Lazygit configuration
│       │   └── config.yml    # Nord-themed color scheme
│       ├── tmux/             # Tmux configuration
│       │   └── tmux.conf     # Main tmux config with which-key menus
│       └── zsh/              # Shell enhancements (4-layer architecture)
│           ├── platform.zsh  # Foundation layer (Homebrew, PATH)
│           ├── runtime.zsh   # Shell behavior (vi mode, completions)
│           ├── interface.zsh # User interaction (prompt, suggestions)
│           ├── workflow.zsh  # Personal productivity (aliases, functions)
│           ├── completions/  # Custom completions (AWS, kubectl, etc.)
│           ├── prompt/       # Git prompt configuration
│           └── functions/    # Custom shell functions
├── misc/                      # Additional resources
│   └── theme.itermcolors    # iTerm2 Nord theme
├── bin/                       # Utility scripts
│   └── cld                    # Claude CLI wrapper with LSP and MCP support
├── backups/                  # Created during installation (your existing configs)
├── Brewfile                  # Homebrew dependencies
├── install.py                # Python-based automated installer
├── README.md                 # This file
└── .gitignore                # Git metadata
```

## Shell Philosophy

- **Minimal**: Essential tools and configs only - nothing extra
- **Functional**: Everything works out of the box with smart defaults
- **Fast**: Quick startup times and responsive performance
- **Clean**: Well-organized, easy to understand and modify

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt for your own use!

## License

MIT License - Feel free to use and modify as needed.
