#!/usr/bin/env python3
"""
Dotfiles Installation Script (Python Version)

A modern alternative to the bash install script with enhanced error handling,
better cross-platform support, and cleaner code organization.
"""

import os
import sys
import subprocess
import shutil
import pathlib
import threading
import time
from datetime import datetime
from typing import Optional, Tuple
from contextlib import contextmanager


class Colors:
    """ANSI color codes for terminal output"""
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    DARKGRAY = '\033[0;90m'
    BRIGHTWHITE = '\033[1;37m'
    NC = '\033[0m'  # No Color


class Spinner:
    """Simple spinner for long-running operations"""
    
    def __init__(self, message: str):
        self.message = message
        self.running = False
        self.thread = None
    
    def _spin(self):
        """Internal spinner animation"""
        chars = '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        idx = 0
        while self.running:
            sys.stdout.write(f'\r{Colors.BRIGHTWHITE}{chars[idx]}{Colors.NC} {Colors.DARKGRAY}{self.message}{Colors.NC}')
            sys.stdout.flush()
            idx = (idx + 1) % len(chars)
            time.sleep(0.08)  # Slightly faster for smoother animation
        # Completely clear the line
        sys.stdout.write('\r' + ' ' * (len(self.message) + 3) + '\r')
        sys.stdout.flush()
    
    def start(self):
        """Start the spinner"""
        self.running = True
        self.thread = threading.Thread(target=self._spin)
        self.thread.start()
    
    def stop(self):
        """Stop the spinner"""
        self.running = False
        if self.thread:
            self.thread.join()


@contextmanager
def spinner_context(message: str):
    """Context manager for spinner operations"""
    spinner = Spinner(message)
    spinner.start()
    try:
        yield
    finally:
        spinner.stop()


class Logger:
    """Enhanced logging with colors and formatting"""
    
    @staticmethod
    def log(message: str) -> None:
        print(message)
    
    @staticmethod
    def info(message: str) -> None:
        print(f"{Colors.DARKGRAY}*{Colors.NC} {message}")
    
    @staticmethod
    def success(message: str) -> None:
        print(f"{Colors.GREEN}✓{Colors.NC} {message}")
    
    @staticmethod
    def warning(message: str) -> None:
        print(f"{Colors.YELLOW}⚠{Colors.NC} {message}")
    
    @staticmethod
    def error(message: str) -> None:
        print(f"{Colors.RED}✗{Colors.NC} {message}")
    
    @staticmethod
    def busy(message: str):
        """Return a context manager for busy/spinner operations"""
        return spinner_context(message)


class DotfilesInstaller:
    """Main installer class for managing dotfiles setup"""
    
    def __init__(self):
        self.dotfiles_dir = pathlib.Path(__file__).parent.absolute()
        self.home_dir = pathlib.Path.home()
        self.backup_dir = self.dotfiles_dir / "backups"
        self.logger = Logger()
    
    def run(self) -> None:
        """Execute the complete installation process"""
        try:
            self.logger.info("Starting dotfiles installation…")
            self.logger.info(f"Dotfiles directory: {self.dotfiles_dir}")
            
            self._install_homebrew()
            self._install_dependencies()
            self._install_zsh()
            self._install_git()
            self._install_nodejs()
            self._install_claude()
            self._install_neovim()
            self._install_tmux()
            self._install_lazygit()
            
            self.logger.log("\n🚀 Dotfiles installation complete!")
            self.logger.log("   Configure your terminal to use 'Hack Nerd Font' for best experience")
            self.logger.log("   Restart your terminal or run 'source ~/.zshrc' to apply changes")
            
        except KeyboardInterrupt:
            self.logger.error("Installation interrupted by user")
            sys.exit(1)
        except Exception as e:
            self.logger.error(f"Installation failed: {e}")
            sys.exit(1)
    
    def _run_command(self, cmd: list, capture_output: bool = False, check: bool = True, quiet: bool = False) -> Optional[str]:
        """Execute a shell command with proper error handling"""
        try:
            # If quiet is True, redirect stdout/stderr to devnull to avoid interference with spinner
            stdout = subprocess.DEVNULL if quiet and not capture_output else None
            stderr = subprocess.DEVNULL if quiet else None
            
            result = subprocess.run(
                cmd, 
                capture_output=capture_output, 
                text=True, 
                check=check,
                stdout=stdout,
                stderr=stderr
            )
            return result.stdout.strip() if capture_output else None
        except subprocess.CalledProcessError as e:
            if check:
                raise RuntimeError(f"Command failed: {' '.join(cmd)} - {e}")
            return None
    
    def _command_exists(self, command: str) -> bool:
        """Check if a command exists in PATH"""
        return shutil.which(command) is not None
    
    def _backup_if_needed(self, target_path: pathlib.Path, backup_name: str) -> None:
        """Backup existing file/directory if it exists and isn't already our symlink"""
        if not target_path.exists() and not target_path.is_symlink():
            return
        
        # Create backup directory
        self.backup_dir.mkdir(exist_ok=True)
        
        # Generate safe backup name (replace / with _)
        safe_backup_name = backup_name.replace('/', '_')
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = self.backup_dir / f"{safe_backup_name}.backup.{timestamp}"
        
        if target_path.is_symlink():
            # Handle symlinks - backup target if it points outside dotfiles
            try:
                link_target = target_path.resolve()
                if link_target.exists() and not str(link_target).startswith(str(self.dotfiles_dir)):
                    shutil.copy2(link_target, backup_path)
                    self.logger.success(f"Backed up symlink target to {backup_path}")
                else:
                    self.logger.info("Symlink already points to dotfiles - no backup needed")
                return
            except (OSError, RuntimeError):
                self.logger.info("Broken symlink removed - no backup needed")
                return
        
        # Backup regular files/directories
        if target_path.is_file():
            shutil.copy2(target_path, backup_path)
            self.logger.success(f"Backed up file to {backup_path}")
        elif target_path.is_dir():
            shutil.copytree(target_path, backup_path)
            self.logger.success(f"Backed up directory to {backup_path}")
    
    def _install_symlink(self, source: pathlib.Path, target: pathlib.Path, backup_name: str) -> None:
        """Create or update a symlink with backup handling"""
        # Backup existing file/directory
        self._backup_if_needed(target, backup_name)
        
        # Create parent directory if needed
        target.parent.mkdir(parents=True, exist_ok=True)
        
        # Remove existing file/symlink
        if target.exists() or target.is_symlink():
            if target.is_dir() and not target.is_symlink():
                shutil.rmtree(target)
            else:
                target.unlink()
        
        # Create symlink
        target.symlink_to(source)
        self.logger.success(f"Installed symlink: {target} -> {source}")
    
    def _install_homebrew(self) -> None:
        """Install Homebrew if not present"""
        if self._command_exists('brew'):
            self.logger.success("Homebrew already installed")
            return
        
        self.logger.warning("Homebrew not found. Installing Homebrew…")
        install_script = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
        
        with self.logger.busy("Installing Homebrew…"):
            self._run_command(['/bin/bash', '-c', f'$(curl -fsSL {install_script})'], quiet=True)
        
        # Add Homebrew to PATH for this session
        brew_paths = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew"]
        for brew_path in brew_paths:
            if pathlib.Path(brew_path).exists():
                # Update PATH for current process
                brew_bin = str(pathlib.Path(brew_path).parent)
                if brew_bin not in os.environ.get('PATH', ''):
                    os.environ['PATH'] = f"{brew_bin}:{os.environ.get('PATH', '')}"
                break
        
        self.logger.success("Homebrew installed successfully")
    
    def _install_dependencies(self) -> None:
        """Install dependencies from Brewfile"""
        self.logger.info("Installing dependencies from Brewfile…")
        brewfile = self.dotfiles_dir / "Brewfile"
        
        if not brewfile.exists():
            raise FileNotFoundError("Brewfile not found!")
        
        # Change to dotfiles directory and run brew bundle
        original_cwd = os.getcwd()
        try:
            os.chdir(self.dotfiles_dir)
            try:
                with self.logger.busy("Installing dependencies…"):
                    self._run_command(['brew', 'bundle', '--quiet'], quiet=True)
                self.logger.success("Dependencies installed successfully")
            except RuntimeError:
                # Some packages may fail (like Docker needing sudo)
                # Continue with what we have
                self.logger.warning("Some packages require manual installation")
                self.logger.info("Run 'brew bundle' manually to see which packages need attention")
        finally:
            os.chdir(original_cwd)
    
    def _install_zsh(self) -> None:
        """Install ZSH configuration"""
        # Install .zshrc
        zshrc_source = self.dotfiles_dir / ".zshrc"
        if zshrc_source.exists():
            self._install_symlink(zshrc_source, self.home_dir / ".zshrc", ".zshrc")
        
        # Install .config/zsh
        zsh_config_source = self.dotfiles_dir / ".config" / "zsh"
        if zsh_config_source.exists():
            self._install_symlink(zsh_config_source, self.home_dir / ".config" / "zsh", "zsh")
        
        self.logger.success("ZSH configuration installed")
    
    def _install_git(self) -> None:
        """Install Git configuration"""
        gitignore_source = self.dotfiles_dir / ".gitignore_global"
        if gitignore_source.exists():
            self._install_symlink(
                gitignore_source, 
                self.home_dir / ".gitignore_global", 
                ".gitignore_global"
            )
        
        self.logger.success("Git configuration installed")
    
    def _install_nodejs(self) -> None:
        """Install Node.js using n"""
        if not self._command_exists('n'):
            self.logger.warning("Node version manager 'n' not found, skipping Node.js setup")
            return
        
        if not self._command_exists('node'):
            with self.logger.busy("Installing Node.js LTS…"):
                self._run_command(['n', 'lts'], quiet=True)
            self.logger.success("Node.js LTS installed")
        else:
            node_version = self._run_command(['node', '--version'], capture_output=True)
            self.logger.success(f"Node.js already installed ({node_version})")
        
        self.logger.success("Node.js configuration complete")
    
    def _install_claude(self) -> None:
        """Install Claude configuration and CLI"""
        # Install .claude directory files
        claude_dir = self.dotfiles_dir / ".claude"
        if claude_dir.exists():
            claude_home = self.home_dir / ".claude"
            claude_home.mkdir(exist_ok=True)
            
            for claude_file in claude_dir.glob("*"):
                if claude_file.is_file():
                    self._install_symlink(
                        claude_file,
                        claude_home / claude_file.name,
                        f".claude/{claude_file.name}"
                    )
            
            # Install .claude/mcp directory if it exists
            mcp_source = claude_dir / "mcp"
            if mcp_source.exists() and mcp_source.is_dir():
                self._install_symlink(mcp_source, claude_home / "mcp", ".claude/mcp")

            # Install .claude/commands directory if it exists
            commands_source = claude_dir / "commands"
            if commands_source.exists() and commands_source.is_dir():
                self._install_symlink(commands_source, claude_home / "commands", ".claude/commands")
        
        # Install Claude CLI
        if not self._command_exists('claude'):
            with self.logger.busy("Installing Claude CLI…"):
                install_script = "curl -fsSL https://claude.ai/install.sh | bash"
                self._run_command(['/bin/bash', '-c', install_script], quiet=True)
            self.logger.success("Claude CLI installed")
        else:
            self.logger.success("Claude CLI already installed")
        
        self.logger.success("Claude configuration installed")
    
    def _install_neovim(self) -> None:
        """Install Neovim configuration and plugins"""
        # Install Neovim configuration
        nvim_source = self.dotfiles_dir / ".config" / "nvim"
        if nvim_source.exists():
            self._install_symlink(nvim_source, self.home_dir / ".config" / "nvim", "nvim")
        
        # Install Neovim plugins
        nvim_config = self.home_dir / ".config" / "nvim"
        if nvim_config.exists() and self._command_exists('nvim'):
            try:
                with self.logger.busy("Installing Neovim plugins…"):
                    # Run in background and capture any errors
                    self._run_command([
                        'nvim', '--headless', 
                        '-c', 'Lazy! sync', 
                        '-c', 'qall'
                    ], check=False, quiet=True)
                self.logger.success("Neovim plugins installed")
            except Exception:
                self.logger.warning("Plugin installation failed, but continuing…")
        
        self.logger.success("Neovim configuration installed")
    
    def _install_tmux(self) -> None:
        """Install tmux configuration"""
        # Install tmux configuration
        tmux_source = self.dotfiles_dir / ".config" / "tmux"
        if tmux_source.exists():
            self._install_symlink(tmux_source, self.home_dir / ".config" / "tmux", "tmux")
        
        self.logger.success("Tmux configuration installed")
    
    def _install_lazygit(self) -> None:
        """Install lazygit configuration"""
        # Install lazygit configuration
        lazygit_source = self.dotfiles_dir / ".config" / "lazygit"
        if lazygit_source.exists():
            self._install_symlink(lazygit_source, self.home_dir / ".config" / "lazygit", "lazygit")
        
        self.logger.success("Lazygit configuration installed")


def main():
    """Main entry point"""
    if len(sys.argv) > 1 and sys.argv[1] in ['--help', '-h']:
        print(__doc__)
        print("\nUsage: python3 install.py")
        print("\nThis script will install dotfiles configuration for:")
        print("  • ZSH & Shell")
        print("  • Git")
        print("  • Node.js")
        print("  • Claude")
        print("  • Neovim")
        print("  • Tmux")
        print("  • Lazygit")
        return
    
    installer = DotfilesInstaller()
    installer.run()


if __name__ == "__main__":
    main()