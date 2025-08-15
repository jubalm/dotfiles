# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Dotfiles Architecture

This is a personal dotfiles repository containing a clean Neovim configuration and installation scripts for setting up a development environment across machines.

## Repository Structure

- `nvim/` - Complete Neovim configuration 
- `Brewfile` - Homebrew dependencies for macOS setup
- `install.sh` - Automated installation script
- `README.md` - Setup and usage documentation

## Installation

Run the installation script to set up the development environment:
```bash
./install.sh
```

This will:
- Install Homebrew (if not present)
- Install all dependencies via Brewfile
- Create symlinks for configurations
- Set up Neovim plugins

## Neovim Configuration Architecture

The Neovim configuration in `nvim/` is built with Lua using a modular structure:

- **Entry Point**: `init.lua` contains only 3 essential require statements: `jubal.editor`, `jubal.plugins`, `jubal.keymap`
- **Plugin Manager**: Uses Lazy.nvim for plugin management with automatic installation
- **Module Structure**: All configuration lives under `lua/jubal/` directory
- **Plugin Setup**: Individual plugin configurations are organized in `lua/jubal/plugin_setup/` by category

### Key Directories
- `lua/jubal/editor.lua` - Core editor settings, UI options, leader key configuration
- `lua/jubal/plugins.lua` - Lazy.nvim bootstrap and setup
- `lua/jubal/keymap.lua` - Global keymaps and autocommands
- `lua/jubal/plugin_setup/` - Modular plugin configurations:
  - `code-hints.lua` - nvim-cmp and snippet configuration
  - `code-analysis.lua` - LSP, Mason, formatting, and development tools
  - `file-navigation.lua` - Telescope configuration and keymaps
  - `syntax-highlight.lua` - Treesitter configuration
  - `user-interface.lua` - Lualine, themes, Git signs, visual enhancements

## Development Commands

### Plugin Management
- `:Lazy` - Open Lazy.nvim plugin manager interface
- `:Lazy sync` - Update and install plugins
- `:Lazy clean` - Remove unused plugins

### LSP Management
- `:Mason` - Open Mason LSP installer interface
- `:LspInfo` - Show LSP server status for current buffer
- `:Format` - Format current buffer (available in LSP-enabled buffers)

## Key Features and Patterns

### LSP Configuration
- Uses the modern `vim.lsp.config()` API for server setup
- Global LSP configuration applied to all servers with fallback to specific overrides
- LSP keymaps are configured in the `on_attach` function in `code-analysis.lua`
- Document highlighting with 1.5s delay on cursor hold

### Plugin Setup Pattern
Each plugin in `plugin_setup/` follows this structure:
```lua
return {
    'plugin/name',
    dependencies = { ... },
    config = function()
        -- Plugin configuration and keymaps
    end
}
```

### Custom Theme
- Uses custom `nord-macos` colorscheme located in `colors/nord-macos.vim`
- Lualine uses modified iceberg_dark theme with custom background

### Keymap Conventions
- Leader key: `<space>`
- File navigation: `<leader>p` (files), `<leader>sg` (grep), `<leader>gf` (git files)
- LSP: `gd` (definition), `gr` (references), `K` (hover), `<leader>ca` (code actions)
- Diagnostics: `[d`/`]d` (navigate), `<leader>e` (float), `<leader>q` (quickfix)

### Development Patterns
- Use tabs (not spaces) with 4-character width by default
- Plugin configurations are self-contained with their keymaps
- LSP servers auto-configure based on project files (package.json, .git)
- Treesitter languages: CSS, JavaScript, TypeScript, TSX, JSON, HTML, Bash, Lua

## Important Technical Notes

- Configuration uses the new Neovim 0.10+ `vim.lsp.config()` API
- Telescope integrations are configured within individual plugin files
- Custom autocmds for yank highlighting and LSP document highlighting
- Git integration with fugitive, gitsigns, and Telescope git commands
- Code folding enabled with nvim-ufo plugin
- Auto-indentation detection with vim-sleuth and .editorconfig support