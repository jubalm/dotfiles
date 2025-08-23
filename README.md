# Jubal's Personal Dotfiles

**Clean, portable dotfiles most development environment**

This repository contains my personal development environment setup, featuring a modular Neovim configuration, organized shell setup, and automated installation scripts. Designed to quickly bootstrap a complete development environment on any macOS machine.

## Features

- **One-command setup**: Complete development environment with automated Homebrew integration
- **Minimal but functional zsh**: Stripped down configuration with essential completions and fast startup
- **Custom git-aware prompt**: Clean, minimal design showing branch status and changes
- **Modern Neovim with LSP**: Full development environment with code completion and formatting
- **Tmux with which-key**: Terminal multiplexer with visual key guide menus for easy learning
- **Portable organization**: XDG-compliant structure that's easy to understand and modify

## Install

```bash
# Clone and install everything
git clone git@github.com:jubalm/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
./install.py
```

The installer handles everything: Homebrew setup, tool installation, config symlinks, and Neovim plugin initialization. Your existing configs are safely backed up to `dotfiles/backups/`.

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
cd ~/.config/dotfiles
git pull origin main
nvim --headless -c "Lazy! sync" -c "qall"
```

## Repository Structure

```
dotfiles/
├── .zshrc                      # Shell configuration
├── .gitignore_global          # Global git ignore patterns
├── .config/                   # XDG Base Directory structure
│   ├── nvim/                  # Complete Neovim configuration
│   │   ├── init.lua          # Entry point
│   │   ├── lua/user/         # Modular configuration
│   │   │   ├── editor.lua    # Core editor settings
│   │   │   ├── keymap.lua    # Global keymaps
│   │   │   ├── plugins.lua   # Lazy.nvim setup
│   │   │   └── plugin_setup/ # Plugin configurations
│   │   │       ├── editing.lua    # Completion, snippets, commenting
│   │   │       ├── insight.lua    # LSP, Treesitter, diagnostics
│   │   │       ├── navigation.lua # Telescope fuzzy finder
│   │   │       └── ui.lua         # Status line, UI elements
│   │   └── colors/           # Custom colorscheme
│   ├── tmux/                  # Tmux configuration
│   │   └── tmux.conf         # Main tmux config with which-key menus
│   └── zsh/                  # Shell enhancements
│       ├── completions/      # Custom completions (AWS, kubectl, etc.)
│       ├── prompt/           # Git prompt configuration
│       └── functions/        # Custom shell functions
├── Brewfile                  # Homebrew dependencies
├── install.py                # Automated installer
├── CLAUDE.md                 # Development documentation
└── README.md                 # This file
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
