# Quirks

## ZSH Layer Dependencies
Shell loads in strict order: platform → runtime → interface → workflow. Adding code to wrong layer breaks subsequent layers.

## Neovim Editor Config
Uses tabs as tabs (not spaces), 2-space width. Completion: `menuone,noselect` required for vim-cmp.

## Claude CLI Aliases
Custom aliases bypass normal CLI: `cld` (no permissions), `cldp` (Playwright MCP), `cldd` (DevTools MCP). Used for testing/shortcuts.

## Installer Symlink Logic
Detects existing symlinks, only backs up if already pointing elsewhere. Re-running is safe and idempotent.

## Tmux Which-Key Pattern
Hierarchical menus via nested `display-menu` commands, not standard binding conventions. `Ctrl+b ?` opens top-level menu.

## Neovim Plugin Folder Structure
Plugins organized by category: editing, insight, navigation, ui (not alphabetical). `plugin_setup/` directory handles per-plugin configuration.

## Custom Markdown Folding
Lua function in Neovim for heading-based folding (not default markdown behavior).

## Status Line Command
Not static text but runs `bash ~/.claude/statusline.sh` dynamically (custom indicators).

## Git Prompt Symbols
Exit code changes prompt arrow: `→` on success, `→` on error (minimal vs oh-my-zsh patterns).
