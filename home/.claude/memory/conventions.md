# Conventions

## Commit Messages
Descriptive prefix format: `refactor:`, `fix:`, `chore:`, `test:` (recent pattern: archive consolidation, skill organization).

## File Organization
Modular structure enforced. Never monolithic files. Clear separation: concerns in different files/directories.

## Comments & Documentation
Section headers with decorative borders. Layer dependencies explicitly noted in shell files. Inline comments for non-obvious logic.

## Logging Output
Consistent ANSI color codes + emoji symbols: `✓` (success), `✗` (error), `⚠` (warning). Progress feedback via animated Unicode spinners.

## Neovim LSP Configuration
Auto-configured for: JavaScript, TypeScript, Lua, Biome. LSP keymaps: `gd` (definition), `gr` (references), `K` (hover), `<leader>rn` (rename), `<leader>ca` (code action).

## Keybindings Namespace
Leader: `<space>`. File navigation: `<leader>p` (files), `<leader>gf` (git files). Search: `<leader>sg` (grep), `<leader>sw` (word), `<leader>sd` (diagnostics).

## Tmux Bindings
Vi-mode by default: `hjkl` for navigation, `H/J/K/L` for resizing. `Ctrl+b` as prefix. Split: `|` (vertical), `-` (horizontal). Copy mode: `Ctrl+b v` with system clipboard.

## Naming Conventions
Descriptive, lowercase with underscores: `setup_reference_highlight()`, `git_prompt.zsh`, `plugin_setup/`. Avoid abbreviations except common ones (LSP, MCP, etc.).

## Shell Function Exports
Functions in workflow.zsh are exported and documented. Platform/runtime/interface layers minimal (setup only, no user functions).

## Memory System Usage
Constraints, quirks, decisions, conventions in active memory. Inbox for uncertainties. Entries target <30 tokens, max 50. Audit memory quarterly.
