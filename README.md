# Personal Dotfiles

**Clean, portable dotfiles for macOS development environment**

This repository contains my personal development environment setup, featuring a modular Neovim configuration, organized shell setup, and automated installation scripts. Designed to quickly bootstrap a complete development environment on any macOS machine.

## Features

- **Modern Neovim Setup**: Lua-based configuration with LSP, Treesitter, and fuzzy finding
- **Organized Shell Configuration**: Custom zsh setup with completions and git prompt
- **XDG Base Directory Compliant**: Clean organization following modern Unix standards
- **Automated Installation**: One-command setup with dependency management
- **Homebrew Integration**: Declarative package management with Brewfile
- **Nerd Font Support**: Hack Nerd Font for beautiful terminal icons
- **Custom Theme**: Nord-inspired colorscheme optimized for readability
- **Container Ready**: Docker and modern development tooling

## Dependencies

The following tools will be installed automatically via Homebrew:

**Essential Development Tools:**
- `git` - Version control system
- `lazygit` - Terminal UI for git commands
- `neovim` - Modern text editor (nvim)
- `ripgrep` - Fast text search tool (rg)
- `fd` - Fast file finder (alternative to find)
- `n` - Node.js version manager
- `docker` - Containerization platform

**Fonts:**
- `font-hack-nerd-font` - Programming font with icons

**Optional Tools:** (commented in Brewfile)
- `zsh-autosuggestions` - Command line auto-completion
- `python3` - Python programming language
- `lua` - Lua programming language

## Quick Install

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation script
./install.sh
```

## What the installer does

1. **Installs Homebrew** (if not already present)
2. **Installs all dependencies** from Brewfile
3. **Backs up existing configs** to `~/.config/backups/`
4. **Creates symlinks** mirroring the repo structure:
   - `.zshrc` → `~/.zshrc`
   - `.gitignore_global` → `~/.gitignore_global`
   - `.config/nvim/` → `~/.config/nvim/`
   - `.config/zsh/` → `~/.config/zsh/`
5. **Initializes Neovim plugins** automatically
6. **Sets up Node.js** via n package manager

## Neovim Features

### LSP & Development
- **Language Servers**: Auto-configured for JavaScript, TypeScript, Lua, and more
- **Code Completion**: Intelligent autocomplete with nvim-cmp
- **Syntax Highlighting**: Advanced Treesitter parsing
- **Code Formatting**: Built-in formatting with LSP

### Navigation & UI
- **Fuzzy Finding**: Telescope for files, grep, git, and more
- **File Explorer**: Integrated file navigation
- **Git Integration**: Gitsigns and Telescope git commands (uses lazygit for operations)
- **Status Line**: Beautiful lualine with git and LSP information

### Key Bindings
- **Leader Key**: `<space>`
- **File Navigation**: `<leader>p` (files), `<leader>sg` (grep)
- **LSP**: `gd` (definition), `gr` (references), `K` (hover)
- **Git**: `<leader>gf` (git files), `<leader>gp/gn` (hunk navigation)

## Manual Setup

If you prefer manual installation or want to customize:

```bash
# Install Homebrew (if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew bundle

# Create symlinks manually
ln -sf ~/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/dotfiles/.config/zsh ~/.config/zsh
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global

# Initialize Neovim plugins
nvim --headless -c "Lazy! sync" -c "qall"
```

## Terminal Setup

For the best experience:

1. **Font**: Set your terminal font to "Hack Nerd Font" (installed automatically)
2. **Color Scheme**: Use a dark theme that complements the Nord colorscheme  
3. **Shell**: Optimized for zsh with custom prompt and completions

## Updates

To update the configuration:

```bash
cd ~/dotfiles
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
│   │   ├── lua/jubal/        # Modular configuration
│   │   └── colors/           # Custom colorscheme
│   └── zsh/                  # Shell enhancements
│       ├── completions/      # Custom completions (AWS, kubectl, etc.)
│       ├── prompt/           # Git prompt configuration
│       └── functions/        # Custom shell functions
├── Brewfile                  # Homebrew dependencies  
├── install.sh                # Automated installer
├── CLAUDE.md                 # Development documentation
└── README.md                 # This file
```

## Shell Features

- **Custom Git Prompt**: Shows branch, status, and changes
- **Vi Mode**: Vim keybindings in the terminal
- **Smart Completions**: AWS CLI, kubectl, eksctl, and more
- **Clean Organization**: XDG-compliant structure in `~/.config/`

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt for your own use!

## License

MIT License - Feel free to use and modify as needed.