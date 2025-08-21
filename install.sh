#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}❌${NC} $1"
}

# Get script directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info "Starting dotfiles installation..."
log_info "Dotfiles directory: $DOTFILES_DIR"

# Check and install Homebrew
if ! command -v brew >/dev/null 2>&1; then
    log_warning "Homebrew not found. Installing Homebrew..."
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
log_info "Installing dependencies from Brewfile..."
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    cd "$DOTFILES_DIR"
    brew bundle --quiet
    log_success "Dependencies installed successfully"
else
    log_error "Brewfile not found!"
    exit 1
fi

# Function to backup existing config
backup_config() {
    local config_path="$1"
    local backup_name="$2"
    
    if [[ -e "$config_path" ]]; then
        local backup_dir="$HOME/.config/backups"
        local backup_path="$backup_dir/${backup_name}.backup.$(date +%Y%m%d_%H%M%S)"
        
        mkdir -p "$backup_dir"
        mv "$config_path" "$backup_path"
        log_success "Backed up existing config to $backup_path"
    fi
}

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"
    
    if [[ -e "$target" || -L "$target" ]]; then
        backup_config "$target" "$name"
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Create symlink
    ln -sf "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

# Install shell configuration
log_info "Installing shell configuration..."
if [[ -f "$DOTFILES_DIR/.zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc" ".zshrc"
fi

if [[ -f "$DOTFILES_DIR/.gitignore_global" ]]; then
    create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global" ".gitignore_global"
fi

if [[ -d "$DOTFILES_DIR/.claude" ]]; then
    # Create .claude directory if it doesn't exist
    mkdir -p "$HOME/.claude"
    
    # Symlink each file in .claude (not the directory itself)
    for claude_file in "$DOTFILES_DIR/.claude"/*; do
        if [[ -f "$claude_file" ]]; then
            file_name=$(basename "$claude_file")
            create_symlink "$claude_file" "$HOME/.claude/$file_name" ".claude/$file_name"
        fi
    done
fi

# Install .config directory structure (mirrors repo structure)
log_info "Installing .config directory structure..."
if [[ -d "$DOTFILES_DIR/.config" ]]; then
    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Symlink each subdirectory in .config
    for config_dir in "$DOTFILES_DIR/.config"/*; do
        if [[ -d "$config_dir" ]]; then
            dir_name=$(basename "$config_dir")
            create_symlink "$config_dir" "$HOME/.config/$dir_name" "$dir_name"
        fi
    done
    
    log_success ".config structure installed"
else
    log_error ".config directory not found in $DOTFILES_DIR"
    exit 1
fi

# Initialize Neovim plugins
if [[ -d "$HOME/.config/nvim" ]]; then
    log_info "Installing Neovim plugins..."
    nvim --headless -c "Lazy! sync" -c "qall" 2>/dev/null || {
        log_warning "Plugin installation failed, but continuing..."
    }
    log_success "Neovim plugins installed"
fi

# Set up Node.js using n
log_info "Setting up Node.js..."
if command -v n >/dev/null 2>&1; then
    # Install latest LTS Node.js if not already installed
    if ! command -v node >/dev/null 2>&1; then
        n lts
        log_success "Node.js LTS installed"
    else
        log_success "Node.js already installed ($(node --version))"
    fi
fi

log_success "✨ Dotfiles installation complete!"
log_info "💡 Configure your terminal to use 'Hack Nerd Font' for best experience"
log_info "🚀 Restart your terminal or run 'source ~/.zshrc' to apply changes"