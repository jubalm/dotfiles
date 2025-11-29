#!/bin/bash

# Read input from stdin
input=$(cat)

# Extract values from JSON input
current_dir="$(echo "$input" | jq -r '.workspace.current_dir')"
model_name="$(echo "$input" | jq -r '.model.display_name')"

# Change to current directory for git operations
cd "$current_dir" 2>/dev/null

# Get git information
git_info=""
if git rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ "$branch" == "HEAD" ]] && branch="$(git rev-parse --short HEAD)..."
    
    git_status=$(git status --porcelain 2>/dev/null)
    [[ -n "$git_status" ]] && status_indicator=" *" || status_indicator=""
    
    git_info=" $(printf '\033[32m%s\033[0m\033[31m%s\033[0m' "$branch" "$status_indicator")"
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

# Print the status line
printf '\033[36m%s\033[0m%s\n\033[90m→\033[0m %s\n' "$display_dir" "$git_info" "$model_name"