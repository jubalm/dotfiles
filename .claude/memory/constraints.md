# Constraints

## Platform
macOS-only design: Homebrew detection (Intel/ARM), Docker Desktop path, iTerm2 theme. Linux support requires platform detection.

## Installation
Single Python 3 script with no external dependencies. Requires shell access for pre/post-install hooks.

## Neovim Requirements
Requires Neovim 0.8+. Full LSP feature set depends on external language servers (biome, tsserver, etc.).

## Single-User Scope
Home directory assumptions ($HOME). No multi-user configurations. Designed for one developer.

## Optional Dependencies
Node.js setup skipped if `n` not installed. Some completions require specific tools (AWS CLI, kubectl, eksctl, deno).

## Manual Steps
Terminal font change (requires GUI). Shell restart needed or manual `source ~/.zshrc`. MCP server setup is separate from core installation.

## Storage Limits
ZSH history: 10,000 lines. Completion cache rebuilt daily. Undo history limited by disk.
