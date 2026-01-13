#!/bin/bash

# Read input from stdin
input=$(cat)

# Extract values from JSON input
current_dir="$(echo "$input" | jq -r '.workspace.current_dir')"
model_name="$(echo "$input" | jq -r '.model.display_name')"

# Extract context window information
used_percentage="$(echo "$input" | jq -r '.context_window.used_percentage // empty')"
total_input="$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')"
total_output="$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')"

# Change to current directory for git operations
cd "$current_dir" 2>/dev/null

# Get git information (matches zsh git_prompt.zsh logic)
git_info=""
if git rev-parse --git-dir >/dev/null 2>&1; then
    # Single git command to get all needed info
    git_output=$(git status --porcelain=v1 -b --ignore-submodules=dirty 2>/dev/null)

    if [[ -n "$git_output" ]]; then
        # Extract branch from first line (## branch_name...)
        branch_line="${git_output%%$'\n'*}"
        branch="${branch_line#\#\# }"

        # Handle detached HEAD
        if [[ "$branch" == *"HEAD (no branch)"* ]]; then
            branch="($(git rev-parse --short HEAD 2>/dev/null)...)"
            branch_color="$(printf '\033[31m')"  # red
        else
            # Remove upstream tracking info
            branch="${branch%% \[*}"
            branch="${branch%%...*}"
            branch_color="$(printf '\033[32m')"  # green
        fi

        # Parse file status
        status_flags=""
        has_staged=false
        has_unstaged=false
        has_untracked=false

        # Simple line-by-line parsing
        while IFS= read -r line; do
            [[ "$line" =~ ^## ]] && continue
            [[ -z "$line" ]] && continue

            xy="${line:0:2}"
            case "$xy" in
                "??") has_untracked=true ;;
                ?[!\ ]) has_unstaged=true ;;
                [!\ ]?) has_staged=true ;;
            esac
        done <<< "$git_output"

        # Build status indicators
        [[ "$has_unstaged" == true ]] && status_flags+=" $(printf '\033[31m*\033[0m')"
        [[ "$has_staged" == true ]] && status_flags+="$(printf '\033[32m+\033[0m')"
        [[ "$has_untracked" == true ]] && status_flags+="$(printf '\033[31m%%\033[0m')"

        # Upstream check from branch line
        if [[ "$branch_line" == *"[ahead "* ]]; then
            status_flags+="$(printf '\033[34m>\033[0m')"
        elif [[ "$branch_line" == *"[behind "* ]]; then
            status_flags+="$(printf '\033[34m<\033[0m')"
        elif [[ "$branch_line" == *"..."* ]]; then
            # Has upstream tracking but no ahead/behind = up to date
            status_flags+="$(printf '\033[34m=\033[0m')"
        fi

        # Format git info
        git_info=" ${branch_color}${branch}$(printf '\033[0m')${status_flags}"
    fi
fi

# Function to shorten path
shorten_path() {
    local path="$1"
    local max_length="${2:-50}"  # Default max length of 50 characters

    # Replace home directory with ~
    path="${path/#$HOME/~}"

    # If path is short enough, return as-is
    if [[ ${#path} -le $max_length ]]; then
        echo "$path"
        return
    fi

    # Split path into components
    IFS='/' read -ra components <<< "$path"
    local result=""
    local last_index=$((${#components[@]} - 1))

    # Always keep the first component (~ or /)
    if [[ ${components[0]} == "~" ]] || [[ ${components[0]} == "" ]]; then
        result="${components[0]}"
        local start_index=1
    else
        result="${components[0]}"
        local start_index=1
    fi

    # Process middle components - shorten if needed
    for ((i=start_index; i<last_index; i++)); do
        local component="${components[i]}"
        if [[ -n "$component" ]]; then
            # If adding this component would make path too long, abbreviate it
            local test_path="$result/$component"
            # Add remaining components to test total length
            for ((j=i+1; j<=last_index; j++)); do
                test_path="$test_path/${components[j]}"
            done

            if [[ ${#test_path} -gt $max_length && ${#component} -gt 1 ]]; then
                # For dot folders, show dot + first letter (2 chars)
                # For regular folders, show just first letter (1 char)
                if [[ "$component" == .* && ${#component} -gt 1 ]]; then
                    result="$result/${component:0:2}"
                else
                    result="$result/${component:0:1}"
                fi
            else
                result="$result/$component"
            fi
        fi
    done

    # Always keep the last component (current directory) full
    if [[ $last_index -ge 0 ]] && [[ -n "${components[last_index]}" ]]; then
        result="$result/${components[last_index]}"
    fi

    echo "$result"
}

# Shorten the display directory
display_dir=$(shorten_path "$current_dir" 50)

# Build token usage info
token_info=""
if [[ -n "$used_percentage" ]]; then
    # Calculate total tokens used
    total_tokens=$((total_input + total_output))

    # Color code based on usage percentage
    if (( $(echo "$used_percentage < 50" | bc -l) )); then
        token_color="$(printf '\033[32m')"  # green - plenty of space
    elif (( $(echo "$used_percentage < 75" | bc -l) )); then
        token_color="$(printf '\033[33m')"  # yellow - moderate usage
    else
        token_color="$(printf '\033[31m')"  # red - high usage
    fi

    # Format: "12.5% (25k tokens)"
    token_info=" ${token_color}${used_percentage}%$(printf '\033[0m') $(printf '\033[90m')(${total_tokens})$(printf '\033[0m')"
fi

# Print the status line (matches zsh prompt format)
printf '\033[36m%s\033[0m%s\n\033[90m→\033[0m %s%s\n' "$display_dir" "$git_info" "$model_name" "$token_info"