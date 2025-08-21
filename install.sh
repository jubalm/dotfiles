#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
DARKGRAY='\033[0;90m'
NC='\033[0m' # No Color

# Helper functions
log() {
    echo -e "$1"
}

log_info() {
    echo -e "${DARKGRAY}*${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Get script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info "Starting dotfiles installation…"
log_info "Dotfiles directory: $DOTFILES_DIR"

# Check and install Homebrew
if ! command -v brew >/dev/null 2>&1; then
    log_warning "Homebrew not found. Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    log_success "Homebrew installed successfully"
else
    log_success "Homebrew already installed"
fi

# Install dependencies using Brewfile
log_info "Installing dependencies from Brewfile…"
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    cd "$DOTFILES_DIR"
    brew bundle --quiet
    log_success "Dependencies installed successfully"
else
    log_error "Brewfile not found!"
    exit 1
fi

# Backup whatever exists at the target location (file, dir, or symlink target)
backup_if_needed() {
    local target="$1"
    local backup_name="$2"

    # Nothing to backup if path doesn't exist
    [[ ! -e "$target" && ! -L "$target" ]] && return 0

    local backup_dir="$DOTFILES_DIR/backups"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local safe_backup_name="${backup_name//\//_}"  # Replace / with _
    local backup_path="$backup_dir/${safe_backup_name}.backup.${timestamp}"

    mkdir -p "$backup_dir"

    # Determine what to backup
    local source_to_backup="$target"
    local backup_type="file/directory"

    if [[ -L "$target" ]]; then
        # For symlinks, backup the target if it exists and isn't our dotfile
        local link_target=$(readlink -f "$target" 2>/dev/null)
        if [[ -n "$link_target" && -e "$link_target" && "$link_target" != "$DOTFILES_DIR"/* ]]; then
            source_to_backup="$link_target"
            backup_type="symlink target"
        else
            # Symlink points to dotfiles or nowhere, no backup needed
            log_info "Skipping backup of symlink (points to dotfiles or broken)"
            return 0
        fi
    fi

    # Perform the backup
    cp -a "$source_to_backup" "$backup_path"
    log_success "Backed up $backup_type to $backup_path"
}

# Create or update symlink (handles all cases)
install_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"

    # Backup if needed
    backup_if_needed "$target" "$name"

    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"

    # Create/update symlink (ln -sf handles everything!)
    ln -sfn "$source" "$target"
    log_success "Installed symlink: $target -> $source"
}

# ============================================================================
# ZSH & SHELL
# ============================================================================
log_info "Installing ZSH configuration…"
if [[ -f "$DOTFILES_DIR/.zshrc" ]]; then
    install_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc" ".zshrc"
fi

if [[ -d "$DOTFILES_DIR/.config/zsh" ]]; then
    mkdir -p "$HOME/.config"
    install_symlink "$DOTFILES_DIR/.config/zsh" "$HOME/.config/zsh" "zsh"
fi
log_success "ZSH configuration installed"

# ============================================================================
# GIT
# ============================================================================
log_info "Installing Git configuration…"
if [[ -f "$DOTFILES_DIR/.gitignore_global" ]]; then
    install_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global" ".gitignore_global"
fi
log_success "Git configuration installed"

# ============================================================================
# NODE.JS
# ============================================================================
log_info "Setting up Node.js…"
if command -v n >/dev/null 2>&1; then
    # Install latest LTS Node.js if not already installed
    if ! command -v node >/dev/null 2>&1; then
        n lts
        log_success "Node.js LTS installed"
    else
        log_success "Node.js already installed ($(node --version))"
    fi
fi
log_success "Node.js configuration complete"

# ============================================================================
# CLAUDE
# ============================================================================
log_info "Installing Claude configuration…"
if [[ -d "$DOTFILES_DIR/.claude" ]]; then
    # Create .claude directory if it doesn't exist
    mkdir -p "$HOME/.claude"

    # Symlink each file in .claude (not the directory itself)
    for claude_file in "$DOTFILES_DIR/.claude"/*; do
        if [[ -f "$claude_file" ]]; then
            file_name=$(basename "$claude_file")
            install_symlink "$claude_file" "$HOME/.claude/$file_name" ".claude/$file_name"
        fi
    done
fi

# Install Claude CLI
if ! command -v claude >/dev/null 2>&1; then
    curl -fsSL https://claude.ai/install.sh | bash
    log_success "Claude CLI installed"
else
    log_success "Claude CLI already installed"
fi
log_success "Claude configuration installed"

# ============================================================================
# NEOVIM
# ============================================================================
log_info "Installing Neovim configuration…"

# Install Neovim configuration
if [[ -d "$DOTFILES_DIR/.config/nvim" ]]; then
    mkdir -p "$HOME/.config"
    install_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim" "nvim"
fi

# Initialize Neovim plugins
if [[ -d "$HOME/.config/nvim" ]]; then
    log_info "Installing Neovim plugins…"
    nvim --headless -c "Lazy! sync" -c "qall" 2>/dev/null || {
        log_warning "Plugin installation failed, but continuing…"
    }
    log_success "Neovim plugins installed"
fi
log_success "Neovim configuration installed"

log "\n🚀 Dotfiles installation complete!"
log "   Configure your terminal to use 'Hack Nerd Font' for best experience"
log "   Restart your terminal or run 'source ~/.zshrc' to apply changes"
