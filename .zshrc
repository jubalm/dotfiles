# ===[ ZSH Configuration ]===

# General settings
unsetopt nomatch
setopt NO_BEEP

# ===[ Editor ]===
export EDITOR='nvim'

# ===[ Completions ]===

# Add custom completions to search path
if [[ ":$FPATH:" != *":$HOME/.config/zsh/completions:"* ]]; then 
  export FPATH="$HOME/.config/zsh/completions:$FPATH"
fi

# zsh-autosuggestions via Homebrew
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=95"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Cloud & Container completions
source ~/.config/zsh/completions/aws.zsh
source ~/.config/zsh/completions/kubectl.zsh
source ~/.config/zsh/completions/eksctl.zsh

# ===[ Prompt ]===

# Git prompt setup
source ~/.config/zsh/prompt/git_prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_HIDE_IF_PWD_IGNORED=true
GIT_PS1_COMPRESSSPARSESTATE=true
GIT_PS1_SHOWCOLORHINTS=true

# Custom prompt
NL=$'\n'
PROMPT_DIR='%F{cyan}%~%f' 
PROMPT_SYMBOL='%(?.%F{gray}.%F{red})%(!.#.→)%f '
PROMPT_FORMAT=' %s' 
precmd () { __git_ps1 $NL$PROMPT_DIR $NL$PROMPT_SYMBOL $PROMPT_FORMAT }

# ===[ Vi Mode ]===
bindkey -v
KEYTIMEOUT=5

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

# ===[ Paths & Tools ]===

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

# ionos CLI completions
fpath+=(~/.config/ionosctl/completion/zsh)

# ===[ Completion System ]===
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ===[ Aliases ]===
alias claude="$HOME/.claude/local/claude"