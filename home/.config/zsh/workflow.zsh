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

# OpenViking CLI wrapper - auto-activates venv and passes all args to openviking
ov() {
  source ~/.venv/openviking/bin/activate
  openviking "$@"
}
