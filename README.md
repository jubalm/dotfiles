# Personal Dotfiles

**Clean, portable dotfiles for macOS development environment**

This repository contains my personal development environment setup, featuring a modular Neovim configuration and automated installation scripts. Designed to quickly bootstrap a complete development environment on any macOS machine.

## Features

- **Modern Neovim Setup**: Lua-based configuration with LSP, Treesitter, and fuzzy finding
- **Automated Installation**: One-command setup with dependency management
- **Homebrew Integration**: Declarative package management with Brewfile
- **Nerd Font Support**: Hack Nerd Font for beautiful terminal icons
- **Custom Theme**: Nord-inspired colorscheme optimized for readability
- **Web Development Ready**: Node.js, TypeScript, and modern tooling

## Dependencies

The following tools will be installed automatically via Homebrew:

**Core Tools:**
- `git` - Version control
- `neovim` - Modern text editor  
- `ripgrep` - Fast text search
- `fd` - Fast file finder
- `n` - Node.js version manager

**Enhancement Tools:**
- `fzf` - Fuzzy finder
- `bat` - Better cat with syntax highlighting
- `eza` - Modern ls replacement
- `font-hack-nerd-font` - Programming font with icons

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
4. **Creates symlinks**: `~/.config/nvim` → `~/dotfiles/nvim`  
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
- **Git Integration**: Fugitive, gitsigns, and Telescope git commands
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
ln -sf ~/dotfiles/nvim ~/.config/nvim

# Initialize Neovim plugins
nvim --headless -c "Lazy! sync" -c "qall"
```

## Terminal Setup

For the best experience:

1. **Font**: Set your terminal font to "Hack Nerd Font" (installed automatically)
2. **Color Scheme**: Use a dark theme that complements the Nord colorscheme
3. **Shell**: Works with zsh, bash, or fish

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
├── nvim/                 # Complete Neovim configuration
│   ├── init.lua         # Entry point
│   ├── lua/jubal/       # Modular configuration
│   └── colors/          # Custom colorscheme
├── Brewfile             # Homebrew dependencies  
├── install.sh           # Automated installer
├── CLAUDE.md            # Development documentation
└── README.md            # This file
```

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt for your own use!

## License

MIT License - Feel free to use and modify as needed.