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
export PATH="$HOME/.config/folio/bin:$PATH"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# >>> headroom persistent env >>>
export HEADROOM_PORT="8787"
export HEADROOM_HOST="127.0.0.1"
export HEADROOM_MODE="cache"
export HEADROOM_BACKEND="anthropic"
export HEADROOM_TELEMETRY="off"
# <<< headroom persistent env <<<
