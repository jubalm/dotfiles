# ===[ ZSH Environment ]===
# Read by every zsh, including non-interactive ones such as `ssh host cmd`,
# which skip .zprofile and .zshrc. Keep this to environment only.

# ===[ Homebrew Environment ]===
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
