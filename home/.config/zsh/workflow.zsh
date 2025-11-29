# ============================================================
#                   WORKFLOW LAYER (4/4)
# ============================================================
# Personal productivity layer for user-specific customizations.
#
# What goes here:
# - Personal aliases and shortcuts
# - Custom functions and utilities
# - Project-specific helpers
# - Workflow automation and conveniences
#
# Depends on all previous layers for full shell functionality.

# ===[ Custom Functions ]===

# Claude CLI launcher with MCP config support
# Usage: cld [flags] [-- claude args]
# Flags: -d (dev), -p (playwright), -c (devtools), -da (docs), -a (astro), -h (help)
cld() {
    "${HOME}/.config/dotfiles/bin/cld" "$@"
}
