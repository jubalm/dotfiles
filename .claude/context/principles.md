# Principles

Project philosophy & design rationale

---

## Portability First

**Goal:** Easy migration across machines

**How:**
- 1:1 XDG mirroring (repo structure = home structure)
- Single install.py → full env setup
- No hidden deps or implicit config
- Backup existing files → safe rollback

**Why 1:1 over custom locations:**
- ✓ Clear mental model (no translation layer)
- ✓ Easy to audit (see exactly what goes where)
- ✓ Simple to maintain (change repo = change home)
- ✗ Custom paths require documentation, error-prone

---

## Modularity

**Goal:** Maintainable, understandable structure

**Pattern:** Separate by concern, clear boundaries

**Examples:**
- nvim init.lua: 3 requires only (editor, plugins, keymap)
- ZSH: 4 layers w/ dependency flow (platform→runtime→interface→workflow)
- plugin_setup/: categorized by function (editing, insight, nav, ui)

**Why modular:**
- ✓ Edit one concern without breaking others
- ✓ Easy to locate code ("where are LSP settings?" → insight.lua)
- ✓ Clear mental model of system
- ✗ Monolithic configs → hard to debug, tangled deps

---

## Consistency

**Goal:** Cohesive experience, predictable patterns

**Axes:**
- **Visual:** Nord theme (nvim, tmux, lazygit, iTerm2)
- **Standards:** XDG Base Directory spec
- **Conventions:** Tabs 4-wide, lua/ structure, zsh/ layers

**Why consistency:**
- ✓ Muscle memory across tools
- ✓ Aesthetic coherence
- ✓ Reduced cognitive load
- ✓ Easy onboarding (one pattern to learn)

---

## Minimal Dependencies

**Goal:** Reduce external coupling, native > plugins

**Examples:**
- Tmux: Native `display-menu` (no external which-key plugin)
- Nvim: Custom nord-macos colorscheme (colors/, not external)
- install.py: Python stdlib only (no pip deps)

**Why minimal:**
- ✓ Fewer breakage points
- ✓ Faster setup (no external fetches beyond Brewfile)
- ✓ Better control (own code > 3rd party)

---

## Explicit Over Implicit

**Goal:** No magic, clear behavior

**Examples:**
- Symlinks visible in install.py (not hidden script logic)
- Keymaps centralized in keymap.lua (not scattered)
- ZSH layers explicit order (.zshrc sources in sequence)

**Why explicit:**
- ✓ Easy to debug (follow the trail)
- ✓ Newcomer-friendly (see what happens)
- ✓ Predictable behavior (no surprises)
