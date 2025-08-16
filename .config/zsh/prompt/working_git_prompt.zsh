# Working git prompt that handles colors correctly
# Ensures PROMPT_SUBST is enabled and uses proper zsh color expansion

working_git_prompt() {
    # Enable prompt substitution for this function
    setopt PROMPT_SUBST
    
    # Quick git repo check
    git rev-parse --git-dir >/dev/null 2>&1 || return
    
    # Get git status efficiently  
    local git_status=$(git status --porcelain=v1 -b 2>/dev/null) || return
    
    # Extract branch from first line
    local branch_line="${git_status%%$'\n'*}"
    local branch="${branch_line#\#\# }"
    
    # Handle different branch states
    if [[ "$branch" =~ "HEAD \(no branch\)" ]]; then
        local short_sha=$(git rev-parse --short HEAD 2>/dev/null)
        branch="($short_sha...)"
        local branch_color="red"
    elif [[ "$branch" =~ "No commits yet on " ]]; then
        branch="${branch#No commits yet on }"
        local branch_color="green"
    else
        # Remove tracking info, keep just branch name
        branch="${branch%%...*}"
        branch="${branch%% \[*}"
        local branch_color="green"
    fi
    
    # Check for file changes
    local status_indicators=""
    local has_unstaged=false
    local has_staged=false
    local has_untracked=false
    
    while IFS= read -r line; do
        [[ "$line" =~ "^##" ]] && continue
        [[ -z "$line" ]] && continue
        
        local index_status="${line:0:1}"
        local worktree_status="${line:1:1}"
        
        [[ "$index_status" != " " && "$index_status" != "?" ]] && has_staged=true
        [[ "$worktree_status" != " " && "$worktree_status" != "?" ]] && has_unstaged=true
        [[ "$index_status" == "?" ]] && has_untracked=true
    done <<< "$git_status"
    
    # Build status indicators using zsh color syntax
    [[ "$has_unstaged" == true ]] && status_indicators+=" %F{red}*%f"
    [[ "$has_staged" == true ]] && status_indicators+="%F{green}+%f"
    [[ "$has_untracked" == true ]] && status_indicators+="%F{red}%%%f"
    
    # Check for stash
    if git rev-parse --verify refs/stash >/dev/null 2>&1; then
        status_indicators+="%F{blue}\$%f"
    fi
    
    # Check upstream status
    if git rev-parse --verify @{upstream} >/dev/null 2>&1; then
        local ahead_behind=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
        if [[ -n "$ahead_behind" ]]; then
            local behind="${ahead_behind%	*}"
            local ahead="${ahead_behind#*	}"
            
            if (( behind > 0 && ahead > 0 )); then
                status_indicators+="%F{blue}<>%f"
            elif (( ahead > 0 )); then
                status_indicators+="%F{blue}>%f"
            elif (( behind > 0 )); then
                status_indicators+="%F{blue}<%f"
            else
                status_indicators+="%F{blue}=%f"
            fi
        fi
    fi
    
    # Return the git segment with proper zsh color codes
    local git_segment="%F{${branch_color}}${branch}%f${status_indicators}"
    echo " ${git_segment}"
}