# ============================================================
#                   INTERFACE LAYER (3/4)
# ============================================================
# User interaction layer that enhances the command-line experience.
#
# What goes here:
# - Auto-suggestions and input enhancements
# - Tool-specific completions (AWS, kubectl, etc.)
# - Prompt configuration and git integration
# - Visual styling and user feedback
#
# Depends on runtime layer for completion system and platform layer for HOMEBREW_PREFIX.

# ===[ Auto-suggestions ]===
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=95"
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ===[ Tool Completions ]===
# Explicit sourcing of completion files for readability
source ~/.config/zsh/completions/aws.zsh
source ~/.config/zsh/completions/kubectl.zsh
source ~/.config/zsh/completions/eksctl.zsh
source ~/.config/zsh/completions/deno.zsh

# ionos CLI completions
fpath+=(~/.config/ionosctl/completion/zsh)

# ===[ Git Prompt Setup ]===
source ~/.config/zsh/prompt/simple_git_prompt.zsh

# ===[ Custom Prompt ]===
NL=$'\n'
PROMPT_DIR='%F{cyan}%~%f' 
PROMPT_SYMBOL='%(?.%F{gray}.%F{red})%(!.#.→)%f '

precmd () { 
    local git_info=$(simple_git_prompt)
    PS1="$NL$PROMPT_DIR$git_info$NL$PROMPT_SYMBOL"
}