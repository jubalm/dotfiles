# Minimal, fast git prompt - single command, essential info only

git_prompt() {
    # Single git command to get all needed info
    local git_output=$(git status --porcelain=v1 -b 2>/dev/null) || return
    
    # Extract branch from first line (## branch_name...)
    local branch_line="${git_output%%$'\n'*}"
    local branch="${branch_line#\#\# }"
    
    # Handle detached HEAD
    if [[ "$branch" =~ "HEAD \(no branch\)" ]]; then
        branch="($(git rev-parse --short HEAD 2>/dev/null)...)"
        local branch_color="red"
    else
        # Remove upstream tracking info
        branch="${branch%% \[*}"
        branch="${branch%%...*}"
        local branch_color="green"
    fi
    
    # Parse file status from remaining lines  
    local status_flags=""
    local has_staged=false has_unstaged=false has_untracked=false
    
    # Simple line-by-line parsing
    while IFS= read -r line; do
        [[ "$line" =~ "^##" ]] && continue
        [[ -z "$line" ]] && continue
        
        case "${line:0:1}${line:1:1}" in
            "??") has_untracked=true ;;
            ?[!\ ]) has_unstaged=true ;;
            [!\ ]?) has_staged=true ;;
        esac
    done <<< "$git_output"
    
    # Build status indicators
    [[ "$has_unstaged" == true ]] && status_flags+=" %F{red}*%f"
    [[ "$has_staged" == true ]] && status_flags+="%F{green}+%f" 
    [[ "$has_untracked" == true ]] && status_flags+="%F{red}%%%f"
    
    # Simple upstream check from branch line
    if [[ "$branch_line" =~ "\[ahead " ]]; then
        status_flags+="%F{blue}>%f"
    elif [[ "$branch_line" =~ "\[behind " ]]; then
        status_flags+="%F{blue}<%f"
    elif [[ "$branch_line" =~ "\.\.\." ]]; then
        # Has upstream tracking but no ahead/behind = up to date
        status_flags+="%F{blue}=%f"
    fi
    
    # Return formatted result
    echo " %F{${branch_color}}${branch}%f${status_flags}"
}