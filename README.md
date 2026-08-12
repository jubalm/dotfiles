# Dotfiles

Personal macOS development-environment dotfiles.

This repo bootstraps my shell, editor, terminal, Git, and agent tooling on a new machine. It is designed for my own workflow, but you are welcome to fork and adapt it.

## Install

```bash
git clone git@github.com:jubalm/dotfiles.git
cd dotfiles
./install.py
```

The installer backs up existing files before creating symlinks.

For selective installs, see:

```bash
./install.py --help
```

## What It Configures

- Zsh shell setup
- Git global ignore
- Node.js tooling
- Claude CLI settings and `cld` wrapper
- Agent skills (shared by Claude, Pi, and other agents)
- Pi coding-agent extensions
- Ghostty
- Herdr
- Handy + shared settings
- Neovim
- tmux
- lazygit
- Homebrew dependencies
- User executables in `bin/`

## Repository Layout

```text
.
├── Brewfile       # Homebrew dependencies
├── bin/           # User executables
├── home/          # Files symlinked into $HOME
├── install.py     # Installer
└── misc/          # Additional resources
```

## Notes

This is a personal repo, so defaults may be opinionated and machine-specific. The code and config files are the source of truth for exact behavior.
