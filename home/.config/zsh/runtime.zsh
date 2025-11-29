# ============================================================
#                    RUNTIME LAYER (2/4)
# ============================================================
# Shell behavior layer that configures core zsh functionality.
#
# What goes here:
# - Vi mode configuration and keybindings
# - Cursor styling and visual feedback
# - Completion system initialization (compinit)
# - Core shell runtime behavior
#
# Depends on platform layer for PATH and environment setup.

# ===[ Vi Mode ]===
bindkey -v
KEYTIMEOUT=5

# Vi mode cursor styling
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' }

# ===[ Shell Options ]===
setopt PROMPT_SUBST  # Enable parameter expansion in prompts

# ===[ Completion System ]===
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi