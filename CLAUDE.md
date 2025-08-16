# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Dotfiles Architecture

This is a personal dotfiles repository containing a clean Neovim configuration, organized shell setup, and installation scripts for setting up a development environment across machines. The repository follows XDG Base Directory specification with 1:1 file structure mirroring.

## Repository Structure

**Root Files:**
- `.zshrc` → `~/.zshrc` - Shell configuration with custom prompt and vi mode
- `.gitignore_global` → `~/.gitignore_global` - Global git ignore patterns
- `Brewfile` - Homebrew dependencies for macOS setup
- `install.sh` - Automated installation script with 1:1 structure mirroring
- `README.md` - Setup and usage documentation

**XDG Structure (mirrors `~/.config/`):**
- `.config/nvim/` → `~/.config/nvim/` - Complete Neovim configuration
- `.config/zsh/` → `~/.config/zsh/` - Organized shell enhancements
  - `platform.zsh` - Foundation layer (environment, Homebrew, PATH)
  - `runtime.zsh` - Shell behavior layer (vi mode, completion system)
  - `interface.zsh` - User interaction layer (auto-suggestions, completions, prompt)
  - `workflow.zsh` - Personal productivity layer (aliases, functions)
  - `completions/` - Custom completions (AWS, kubectl, eksctl, deno)
  - `prompt/` - Git prompt configuration
  - `functions/` - Custom shell functions (empty, for future use)

## Installation

Run the installation script to set up the development environment:
```bash
./install.sh
```

This will:
- Install Homebrew (if not present)
- Install all dependencies via Brewfile
- Create 1:1 symlinks mirroring repo structure to home directory
- Set up Neovim plugins automatically

## Neovim Configuration Architecture

The Neovim configuration in `nvim/` is built with Lua using a modular structure:

- **Entry Point**: `init.lua` contains only 3 essential require statements: `user.editor`, `user.plugins`, `user.keymap`
- **Plugin Manager**: Uses Lazy.nvim for plugin management with automatic installation
- **Module Structure**: All configuration lives under `lua/user/` directory
- **Plugin Setup**: Individual plugin configurations are organized in `lua/jubal/plugin_setup/` by category

### Key Directories
- `lua/user/editor.lua` - Core editor settings, UI options, leader key configuration
- `lua/user/plugins.lua` - Lazy.nvim bootstrap and setup
- `lua/user/keymap.lua` - Global keymaps and autocommands
- `lua/user/plugin_setup/` - Modular plugin configurations by function:
  - `editing.lua` - nvim-cmp, snippets, commenting, auto-tags, indentation
  - `insight.lua` - Treesitter, LSP, diagnostics, folding, visual aids, gitsigns
  - `navigation.lua` - Telescope configuration (keymaps in keymap.lua)
  - `ui.lua` - Lualine status line and which-key hints

## Shell Configuration

### ZSH Architecture (4-Layer Structure)
- **Platform Layer** (`platform.zsh`): Foundation environment, Homebrew setup, PATH configuration
- **Runtime Layer** (`runtime.zsh`): Vi mode, completion system initialization, core shell behavior
- **Interface Layer** (`interface.zsh`): Auto-suggestions, tool completions, git prompt integration
- **Workflow Layer** (`workflow.zsh`): Personal aliases, functions, productivity customizations

### ZSH Features
- **Custom Git Prompt**: Shows branch status, dirty state, untracked files
- **Vi Mode**: Vim keybindings in terminal with visual cursor indicators
- **Smart Completions**: AWS CLI, kubectl, eksctl, deno completions
- **Auto-suggestions**: Via Homebrew zsh-autosuggestions package
- **Modular Organization**: Clear architectural layers with dependency flow

### Essential Tools  
- **git** + **lazygit**: Version control with terminal UI
- **neovim**: Modern text editor with LSP integration
- **ripgrep** + **fd**: Fast search tools
- **docker**: Containerization platform
- **n**: Node.js version manager

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
- Git hunks: `<leader>gp/gn` (navigate), `<leader>h` (preview)

### Development Patterns
- Use tabs (not spaces) with 4-character width by default
- Global keymaps centralized in `keymap.lua`, plugin configs focus on setup
- LSP servers auto-configure based on project files (package.json, .git)
- Treesitter languages: CSS, JavaScript, TypeScript, TSX, JSON, HTML, Bash, Lua

## Important Technical Notes

- Configuration uses the new Neovim 0.10+ `vim.lsp.config()` API
- Telescope keymaps centralized in `keymap.lua`, config in `navigation.lua`
- Custom autocmds for yank highlighting and LSP document highlighting
- Git integration with gitsigns for visual indicators, lazygit for operations
- Code folding enabled with nvim-ufo plugin
- Auto-indentation detection with vim-sleuth and .editorconfig support
- Shell completions organized in `~/.config/zsh/completions/` for cloud tools