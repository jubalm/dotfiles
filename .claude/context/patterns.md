# Patterns

Non-obvious implementation details, "how X works"

---

## Nvim: LSP Setup

### Modern API

**Use:** `vim.lsp.config()` (Neovim 0.10+)

**Don't use:** Old `lspconfig.*.setup()` pattern

**Location:** `insight.lua`

**Pattern:**
```lua
vim.lsp.config('*', {
  -- Global config for all servers
})

vim.lsp.config('lua_ls', {
  -- Specific overrides
})
```

**Why modern API:**
- Built-in (no lspconfig plugin dependency)
- Cleaner syntax
- Better integration

---

### LSP Keymaps

**Location:** `on_attach` function in `insight.lua`

**Why on_attach:**
- Context-specific (only when LSP active in buffer)
- Avoid global namespace pollution
- Per-buffer keymaps (buffer-local)

**Pattern:**
```lua
on_attach = function(client, bufnr)
  -- Set buffer-local keymaps here
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
end
```

**Document highlighting:** 1.5s delay on CursorHold

---

## Nvim: Custom Theme

**Location:** `.config/nvim/colors/nord-macos.vim`

**Type:** Custom colorscheme (not external plugin)

**Lualine theme:** Modified iceberg_dark w/ custom background

**Why custom:**
- Full control over colors
- No plugin dep
- Matches Nord aesthetic

---

## Nvim: Plugin Setup Pattern

**Format:** Lazy.nvim table structure

**Pattern:**
```lua
return {
  'plugin/name',
  dependencies = { ... },
  config = function()
    -- Plugin setup
  end
}
```

**File structure:** Each plugin_setup/*.lua returns array of plugin tables

**Example:**
```lua
-- editing.lua
return {
  { 'plugin1', config = ... },
  { 'plugin2', config = ... },
}
```

---

## Nvim: Autocmds

**Yank highlighting:**
```lua
vim.api.nvim_create_autocmd('TextYankPost', {
  -- Briefly highlight yanked text
})
```

**LSP document highlighting:**
```lua
vim.api.nvim_create_autocmd('CursorHold', {
  -- Highlight symbol under cursor (1.5s delay)
})
```

**Location:** keymap.lua (global autocmds)

---

## Nvim: Treesitter

**Languages:** CSS, JavaScript, TypeScript, TSX, JSON, HTML, Bash, Lua

**Auto-install:** On file open

**Features:** Syntax highlighting, indentation, folding (via nvim-ufo)

---

## Nvim: Telescope

**Config:** navigation.lua (setup only)

**Keymaps:** keymap.lua (centralized)

**Why split:**
- Config rarely changes (plugin options)
- Keymaps frequently adjusted (user preference)

---

## Tmux: Native Which-Key

**Implementation:** Built-in `display-menu` command

**No plugins:** Tmux has native menu system

**Pattern:**
```tmux
bind-key ? display-menu \
  "Menu Title" "" \
  "Option 1" "1" "command1" \
  "Option 2" "2" "command2"
```

**Why native:**
- No external dep
- Faster (no plugin overhead)
- Built-in feature (stable API)

---

## ZSH: Claude CLI Aliases

**Location:** workflow.zsh

**Aliases:**
- `cld` - Bypass permissions
- `cldd` - Development mode w/ MCP config

**Pattern:**
```zsh
alias cld='claude-code --bypass-permissions'
alias cldd='claude-code --dev --mcp-config ...'
```

---

## ZSH: Completions

**Location:** `.config/zsh/completions/`

**Tools:** AWS CLI, kubectl, eksctl, deno

**Loading:** Sourced in interface.zsh

**Pattern:**
```zsh
# Add completion dir to fpath
fpath=(~/.config/zsh/completions $fpath)
```

---

## ZSH: Git Prompt

**Location:** `.config/zsh/prompt/`

**Features:**
- Branch name
- Dirty state indicator
- Untracked files indicator

**Integration:** Sourced in interface.zsh

---

## Install: Symlink Mechanism

**Script:** install.py

**Pattern:**
- Scan repo for files/dirs
- Mirror structure to home (1:1)
- Backup existing → backups/ (timestamped)
- Create symlinks (repo → home)

**Safety:**
- Check existing files → backup before overwrite
- Continue on error (don't abort entire install)
- Skip sudo-required packages → manual install guidance

**Brewfile handling:**
- Install Homebrew if missing
- Install deps via `brew bundle`
- Skip packages requiring sudo (Docker Desktop)

---

## Nvim: Auto-Indentation

**Plugins:**
- vim-sleuth (detect indent from file)
- .editorconfig support

**Default:** Tabs, 4-wide

**Override:** Project .editorconfig → takes precedence

**Why both:**
- sleuth: Auto-detect existing files
- editorconfig: Explicit project standards

---

## Git Integration

**Visual indicators:** gitsigns (in-editor)

**Operations:** lazygit (terminal UI)

**Why split:**
- gitsigns: Passive (show status)
- lazygit: Active (perform operations)

**Config:** lazygit/config.yml (Nord theme, better readability)

---

## Code Folding

**Plugin:** nvim-ufo

**Integration:** Treesitter-based folds

**Why ufo:**
- Better fold visualization
- Treesitter integration
- More intuitive behavior
