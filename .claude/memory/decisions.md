# Decisions

## ZSH over Bash
Chosen for vi mode stability, better completion system, and async prompt capabilities.

## 4-Layer Shell Architecture
Explicit dependency flow prevents initialization chaos. Each layer has clear responsibility: Platform (env), Runtime (shell behavior), Interface (UX), Workflow (productivity).

## XDG Base Directory Compliance
Keeps home directory clean. Symlinks allow entire env to be backed up from ~/.config/.

## Lua for Neovim Configuration
Modern alternative to Vimscript. Enables complex plugin configs, better performance. Lazy.nvim chosen for plugin management (async, efficient caching).

## Nord Theme Across All Tools
Cohesive visual environment. Single palette consistent in terminal, editor, git UI, multiplexer.

## Installer as Python Script
Non-destructive approach with timestamped backups. Single file, easy to audit, no external dependencies. Chosen over Bash to handle complex logic (spinners, colored output, error recovery).

## Skills as Archived Format
Allows versioning and modular distribution (.zip/.tar.gz). Supports future tool ecosystem expansion.

## Minimal Shell Framework
No oh-my-zsh or custom prompt frameworks. Manual 4-layer system is faster, more transparent, easier to debug.

## Tmux Which-Key Menus
Replaces traditional key binding memorization with visual discovery. Hierarchical menus prevent overwhelming single-level reference.
