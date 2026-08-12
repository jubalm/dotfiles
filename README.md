# Jubal's macOS Development Environment

## Installation

```bash
git clone git@github.com:jubalm/dotfiles.git
cd dotfiles
./install.py
```

The installer backs up existing files before creating symlinks.

See `./install.py --help` for selective installs.

## What's Included

### Configuration

- Zsh shell and Git global ignore
- Ghostty, Herdr, Handy, Neovim, and lazygit
- Claude and Pi agent configuration and extensions
- Shared agent skills

### Tools

- Homebrew packages and applications, including Pi
- Node.js tooling
- Claude CLI

## Repository Layout

```text
.
├── Brewfile       # Homebrew dependencies
├── home/          # Files symlinked into $HOME
└── install.py     # Installer
```

## Disclaimer

This is a personal repo, so defaults may be opinionated and machine-specific. The code and config files are the source of truth for exact behavior.
