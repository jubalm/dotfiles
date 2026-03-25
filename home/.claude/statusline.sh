#!/bin/bash

declare -r RED=$'\033[31m' GREEN=$'\033[32m' BLUE=$'\033[34m' YELLOW=$'\033[33m' CYAN=$'\033[36m' GREY=$'\033[90m' RESET=$'\033[0m'

# Extract all JSON values in a single jq call
eval "$(jq -r '@json "current_dir=\(.workspace.current_dir) model_name=\(.model.display_name) used_percentage=\(.context_window.used_percentage // empty) total_input=\(.context_window.total_input_tokens // 0) total_output=\(.context_window.total_output_tokens // 0)"')"

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
            branch_color="$RED"
        else
            branch="${branch%% \[*}"
            branch="${branch%%...*}"
            branch_color="$GREEN"
        fi

        # Parse file status
        status_flags=""
        has_staged=0 has_unstaged=0 has_untracked=0

        while IFS= read -r line; do
            [[ "$line" =~ ^## ]] && continue
            [[ -z "$line" ]] && continue

            xy="${line:0:2}"
            case "$xy" in
                "??") has_untracked=1 ;;
                ?[!\ ]) has_unstaged=1 ;;
                [!\ ]?) has_staged=1 ;;
            esac
        done <<< "$git_output"

        # Build status indicators
        (( has_unstaged )) && status_flags+=" ${RED}*${RESET}"
        (( has_staged )) && status_flags+="${GREEN}+${RESET}"
        (( has_untracked )) && status_flags+="${RED}%${RESET}"

        # Upstream check from branch line
        if [[ "$branch_line" == *"[ahead "* ]]; then
            status_flags+="${BLUE}>${RESET}"
        elif [[ "$branch_line" == *"[behind "* ]]; then
            status_flags+="${BLUE}<${RESET}"
        elif [[ "$branch_line" == *"..."* ]]; then
            status_flags+="${BLUE}=${RESET}"
        fi

        git_info=" ${branch_color}${branch}${RESET}${status_flags}"
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

    result="${components[0]}"
    local start_index=1

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

format_tokens() {
    awk -v num=$1 'BEGIN { if (num >= 1000) { k = num / 1000; if (k == int(k)) print int(k)"k"; else printf "%.1fk\n", k } else print num }'
}

# Build token usage info
token_info=""
if [[ -n "$used_percentage" ]]; then
    # Calculate total tokens used
    total_tokens=$((total_input + total_output))

    # Format token counts
    formatted_total=$(format_tokens $total_tokens)

    # Color code based on usage percentage (compare as integers to avoid bc)
    pct_int=${used_percentage%%.*}
    if (( pct_int < 50 )); then
        token_color="$GREEN"
    elif (( pct_int < 75 )); then
        token_color="$YELLOW"
    else
        token_color="$RED"
    fi

    token_info=" ${token_color}${used_percentage}%${RESET} ${GREY}(${formatted_total})${RESET}"
fi

printf '%s\n%s %s%s\n' "$CYAN$display_dir$RESET$git_info" "${GREY}→${RESET}" "$model_name" "$token_info"