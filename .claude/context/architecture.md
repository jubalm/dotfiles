# Architecture

Structural decisions, organization patterns, constraints

---

## Nvim Structure

### Init.lua Minimalism

**Rule:** MUST contain exactly 3 requires only

```lua
require('user.editor')   -- Core settings
require('user.plugins')  -- Lazy.nvim bootstrap
require('user.keymap')   -- Global keymaps/autocmds
```

**Why:**
- Single source of truth for entry points
- Easy to audit (no hidden init logic)
- Forces modularization (can't dump code here)

**Constraint:** Never add requires or logic to init.lua

---

### Keymap Centralization

**Rule:** All global keymaps in `keymap.lua`

**Plugin configs:** Setup only, no keymaps (unless plugin-internal)

**Why centralize:**
- Easy to audit all keybindings (one file vs scattered)
- Avoid duplication (see conflicts immediately)
- Single source of truth

**Examples:**
- ✓ Telescope keymaps → keymap.lua
- ✓ LSP keymaps → on_attach in insight.lua (context-specific)
- ✗ Plugin keymaps in plugin_setup/*.lua (unless required by plugin API)

---

### Plugin Organization

**Location:** `plugin_setup/` categorized by function

**Categories:**
- `editing.lua` - Text manipulation (nvim-cmp, snippets, commenting, auto-tags, indentation)
- `insight.lua` - Code understanding (Treesitter, LSP, diagnostics, folding, gitsigns)
- `navigation.lua` - File/content discovery (Telescope config only, keymaps in keymap.lua)
- `ui.lua` - Visual elements (lualine, which-key, render-markdown)

**Why categorize:**
- Mental model (know where to find X)
- Avoid "junk drawer" effect
- Related concerns grouped

**Pattern:** Each file returns array of plugin tables (lazy.nvim format)

---

## ZSH 4-Layer Architecture

**Layers:** platform → runtime → interface → workflow

**Dependency flow (strict order):**
```
.zshrc
  ├─> platform.zsh  (env, Homebrew, PATH)
  ├─> runtime.zsh   (vi mode, completion system)
  ├─> interface.zsh (auto-suggestions, tool completions, prompt)
  └─> workflow.zsh  (aliases, functions, customizations)
```

**Why 4 layers (not 3 or 5):**
- **Platform:** Foundation (must run first, sets env)
- **Runtime:** Shell behavior (needs env, before interactive)
- **Interface:** User-facing (needs completion system from runtime)
- **Workflow:** Personal (top layer, depends on all below)

**Why not merged:**
- ✗ 3 layers: Platform+runtime merged → unclear what initializes when
- ✗ 5 layers: Over-engineered, no clear 5th concern

**Constraint:** MUST source in order, no circular deps

---

## Tmux Structure

**Constraint:** Native functionality only, no external plugins

**Why:**
- Fewer deps (no plugin manager needed)
- Faster startup
- Better control (own config vs plugin defaults)

**Pattern:** Use native `display-menu` for which-key style menus

**Config:** Single tmux.conf in .config/tmux/ (XDG compliant)

---

## File Conventions

### Indentation

**Default:** Tabs, 4-char width

**Override:** vim-sleuth + .editorconfig (project-specific)

**Why tabs:**
- Personal preference
- Visual width adjustable per user

### Locations

**Constraint:** Follow XDG Base Directory spec

**Examples:**
- ✓ ~/.config/nvim/ (not ~/.vim/)
- ✓ ~/.config/tmux/tmux.conf (not ~/.tmux.conf)
- ✓ ~/.config/zsh/ (sourced from .zshrc)

**Why XDG:**
- Standard (predictable locations)
- Clean home dir (no dotfile clutter)
- Better organization

---

## Separation of Concerns

### Nvim: Config vs Keymaps

**Config:** `plugin_setup/*.lua` (how plugin works)
**Keymaps:** `keymap.lua` (how to invoke)

**Why separate:**
- Config changes ≠ keymap changes
- Easier to swap keybindings without touching plugin logic

### ZSH: Behavior vs Customization

**Behavior:** platform/runtime/interface (shared, stable)
**Customization:** workflow (personal, frequently changed)

**Why separate:**
- Share layers 1-3 across machines
- Layer 4 per-machine customizations

---

## LSP Configuration

**API:** Modern `vim.lsp.config()` (Neovim 0.10+)

**Pattern:** Global config for all servers, specific overrides

**Keymaps:** In `on_attach` function (context: LSP active in buffer)

**Why global config:**
- DRY (don't repeat for each server)
- Consistent behavior
- Easy to update (one place)
