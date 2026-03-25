# ===[ ZSH Configuration ]===
# Minimal loader for architectural layers
# Each layer builds on the previous one with clear dependency flow

# ==================================================
#  ⚠️  CRITICAL: DO NOT CHANGE THE LOADING ORDER ⚠️
# ==================================================
# 1. platform.zsh  - Foundation: environment variables, Homebrew, PATH setup
# 2. runtime.zsh   - Shell behavior: vi mode, completion system initialization
# 3. interface.zsh - User interaction: auto-suggestions, completions, prompt
# 4. workflow.zsh  - Personal productivity: aliases, functions, customizations

source ~/.config/zsh/platform.zsh
source ~/.config/zsh/runtime.zsh
source ~/.config/zsh/interface.zsh
source ~/.config/zsh/workflow.zsh
