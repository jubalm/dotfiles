# ============================================================
#                    PLATFORM LAYER (1/4)
# ============================================================
# Foundation layer that establishes the basic environment.
#
# What goes here:
# - Core shell options (unsetopt, setopt)
# - Environment variables (EDITOR, HOMEBREW_PREFIX)
# - PATH modifications (Homebrew, Node.js tools)
# - System integration setup
#
# Must load first - other layers depend on environment variables set here.

# ===[ Core Shell Options ]===
unsetopt nomatch
setopt NO_BEEP

# ===[ Editor ]===
export EDITOR='nvim'

# ===[ XDG Base Directory ]===
export XDG_CONFIG_HOME="$HOME/.config"

# ===[ Homebrew Environment ]===
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ===[ Node.js Package Managers ]===

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# npm global packages
export PATH=~/.npm-global/bin:$PATH

# local binaries
export PATH=$HOME/.local/bin:$PATH

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# ===[ Docker Desktop CLI ]===
# Add Docker Desktop CLI tools to PATH if available
if [[ -d "/Applications/Docker.app/Contents/Resources/bin" ]]; then
  export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
fi
