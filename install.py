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
import argparse
from datetime import datetime
from typing import Optional
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

    def __init__(self, skip_sections: Optional[list] = None):
        self.dotfiles_dir = pathlib.Path(__file__).parent.absolute()
        self.home_dir = pathlib.Path.home()
        self.backup_dir = self.dotfiles_dir / "backups"
        self.logger = Logger()
        self.skip_sections = skip_sections or []

    def run(self) -> None:
        """Execute the complete installation process"""
        try:
            self.logger.info("Starting dotfiles installation…")
            self.logger.info(f"Dotfiles directory: {self.dotfiles_dir}")

            if self.skip_sections:
                self.logger.info(f"Skipping: {', '.join(self.skip_sections)}")

            if 'dependencies' not in self.skip_sections:
                self._install_homebrew()
                self._install_dependencies()
            else:
                self._remove_section('dependencies')

            if 'zsh' not in self.skip_sections:
                self._install_zsh()
            else:
                self._remove_section('zsh')

            if 'git' not in self.skip_sections:
                self._install_git()
            else:
                self._remove_section('git')

            if 'nodejs' not in self.skip_sections:
                self._install_nodejs()
            else:
                self._remove_section('nodejs')

            if 'claude' not in self.skip_sections:
                self._install_claude()
            else:
                self._remove_section('claude')

            if 'nvim' not in self.skip_sections:
                self._install_neovim()
            else:
                self._remove_section('nvim')

            if 'tmux' not in self.skip_sections:
                self._install_tmux()
            else:
                self._remove_section('tmux')

            if 'lazygit' not in self.skip_sections:
                self._install_lazygit()
            else:
                self._remove_section('lazygit')

            if 'bin' not in self.skip_sections:
                self._install_bin()
            else:
                self._remove_section('bin')

            self.logger.log("\n🚀 Dotfiles installation complete!")
            self.logger.log("   Configure your terminal to use 'Hack Nerd Font' for best experience")
            self.logger.log("   Restart your terminal or run 'source ~/.zshrc' to apply changes")

        except KeyboardInterrupt:
            self.logger.error("Installation interrupted by user")
            sys.exit(1)
        except Exception as e:
            self.logger.error(f"Installation failed: {e}")
            sys.exit(1)

    def _remove_section(self, section: str) -> None:
        """Remove symlinks for a skipped section"""
        symlink_map = {
            'zsh': [(self.home_dir / ".zshrc"), (self.home_dir / ".config" / "zsh")],
            'git': [(self.home_dir / ".gitignore_global")],
            'claude': [(self.home_dir / ".claude")],
            'skills': [(self.home_dir / ".claude" / "skills")],
            'nvim': [(self.home_dir / ".config" / "nvim")],
            'tmux': [(self.home_dir / ".config" / "tmux")],
            'lazygit': [(self.home_dir / ".config" / "lazygit")],
            'bin': [(self.home_dir / ".local" / "bin" / "cld")],
            'nodejs': [],  # No symlinks to remove
            'dependencies': [],  # No symlinks to remove
        }

        for symlink_path in symlink_map.get(section, []):
            if symlink_path.is_symlink() or symlink_path.exists():
                try:
                    if symlink_path.is_dir() and not symlink_path.is_symlink():
                        shutil.rmtree(symlink_path)
                    else:
                        symlink_path.unlink()
                    self.logger.success(f"Removed: {symlink_path}")
                except Exception as e:
                    self.logger.warning(f"Could not remove {symlink_path}: {e}")

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
                # Run brew bundle without quiet flag to show actual progress and errors
                self._run_command(['brew', 'bundle'], check=True)
                self.logger.success("Dependencies installed successfully")
            except RuntimeError:
                self.logger.error("Some packages failed to install")
                self.logger.info("Run 'brew bundle' manually to see detailed error messages")
                self.logger.info("You can also run 'brew bundle --verbose' for more information")
                # Don't re-raise - continue with other installation steps
        finally:
            os.chdir(original_cwd)

    def _install_zsh(self) -> None:
        """Install ZSH configuration"""
        # Install .zshrc
        zshrc_source = self.dotfiles_dir / "home" / ".zshrc"
        if zshrc_source.exists():
            self._install_symlink(zshrc_source, self.home_dir / ".zshrc", ".zshrc")

        # Install .config/zsh
        zsh_config_source = self.dotfiles_dir / "home" / ".config" / "zsh"
        if zsh_config_source.exists():
            self._install_symlink(zsh_config_source, self.home_dir / ".config" / "zsh", "zsh")

        self.logger.success("ZSH configuration installed")

    def _install_git(self) -> None:
        """Install Git configuration"""
        gitignore_source = self.dotfiles_dir / "home" / ".gitignore_global"
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
        claude_dir = self.dotfiles_dir / "home" / ".claude"
        if claude_dir.exists():
            claude_home = self.home_dir / ".claude"
            claude_home.mkdir(exist_ok=True)

            # Files to exclude from global symlink (keep project-specific)
            excluded_files = set()

            for claude_file in claude_dir.glob("*"):
                if claude_file.is_file() and claude_file.name not in excluded_files:
                    self._install_symlink(
                        claude_file,
                        claude_home / claude_file.name,
                        f".claude/{claude_file.name}"
                    )

            # Install .claude/servers directory if it exists
            servers_source = claude_dir / "servers"
            if servers_source.exists() and servers_source.is_dir():
                self._install_symlink(servers_source, claude_home / "servers", ".claude/servers")

            # Install .claude/commands directory if it exists
            commands_source = claude_dir / "commands"
            if commands_source.exists() and commands_source.is_dir():
                self._install_symlink(commands_source, claude_home / "commands", ".claude/commands")

            # Install .claude/agents directory if it exists
            agents_source = claude_dir / "agents"
            if agents_source.exists() and agents_source.is_dir():
                self._install_symlink(agents_source, claude_home / "agents", ".claude/agents")

            # Install .claude/skills directory - symlink each skill individually
            if 'skills' not in self.skip_sections:
                skills_source = claude_dir / "skills"
                skills_home = claude_home / "skills"

                # Create skills directory in home
                skills_home.mkdir(exist_ok=True)

                if skills_source.exists() and skills_source.is_dir():
                    # Get the set of skill directories that exist in the dotfiles repo
                    existing_skills = {skill_dir.name for skill_dir in skills_source.iterdir() if skill_dir.is_dir()}

                    # Clean up stale symlinks (symlinks whose source no longer exists)
                    if skills_home.exists():
                        for skill_link in skills_home.iterdir():
                            if skill_link.is_symlink():
                                try:
                                    # Check if the symlink target exists
                                    skill_link.resolve(strict=True)
                                except (OSError, RuntimeError):
                                    # Symlink is broken or target doesn't exist
                                    skill_link.unlink()
                                    self.logger.info(f"Removed stale skill symlink: {skill_link.name}")
                            elif skill_link.name not in existing_skills:
                                # Remove directories/files that aren't in our current skills set
                                if skill_link.is_dir():
                                    shutil.rmtree(skill_link)
                                    self.logger.info(f"Removed orphaned skill directory: {skill_link.name}")
                                else:
                                    skill_link.unlink()
                                    self.logger.info(f"Removed orphaned skill file: {skill_link.name}")

                    # Symlink each skill folder individually
                    for skill_dir in skills_source.iterdir():
                        if skill_dir.is_dir():
                            skill_target = skills_home / skill_dir.name
                            self._install_symlink(skill_dir, skill_target, f".claude/skills/{skill_dir.name}")
            else:
                # Clean up skills if they're being skipped
                self._remove_section('skills')

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
        nvim_source = self.dotfiles_dir / "home" / ".config" / "nvim"
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
        tmux_source = self.dotfiles_dir / "home" / ".config" / "tmux"
        if tmux_source.exists():
            self._install_symlink(tmux_source, self.home_dir / ".config" / "tmux", "tmux")

        self.logger.success("Tmux configuration installed")

    def _install_lazygit(self) -> None:
        """Install lazygit configuration"""
        # Install lazygit configuration
        lazygit_source = self.dotfiles_dir / "home" / ".config" / "lazygit"
        if lazygit_source.exists():
            self._install_symlink(lazygit_source, self.home_dir / ".config" / "lazygit", "lazygit")

        self.logger.success("Lazygit configuration installed")

    def _install_bin(self) -> None:
        """Install user executables to ~/.local/bin"""
        # Create ~/.local/bin if it doesn't exist
        local_bin = self.home_dir / ".local" / "bin"
        local_bin.mkdir(parents=True, exist_ok=True)

        # Symlink bin/cld to ~/.local/bin/cld
        cld_source = self.dotfiles_dir / "bin" / "cld"
        if cld_source.exists():
            self._install_symlink(cld_source, local_bin / "cld", ".local/bin/cld")

        self.logger.success("User executables installed")


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description="Install and configure dotfiles",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Available flags (use --no-* to skip a section):
  --no-dependencies   Skip Homebrew and package installation
  --no-zsh           Skip ZSH configuration
  --no-git           Skip Git configuration
  --no-nodejs        Skip Node.js setup
  --no-claude        Skip Claude CLI and configuration
  --no-skills        Skip Claude skills installation
  --no-nvim          Skip Neovim configuration
  --no-tmux          Skip Tmux configuration
  --no-lazygit       Skip Lazygit configuration
  --no-bin           Skip user executables installation

Examples:
  python3 install.py                    # Install everything
  python3 install.py --no-skills        # Install everything except skills
  python3 install.py --no-nvim          # Install everything except Neovim
  python3 install.py --no-zsh --no-git  # Skip ZSH and Git
  python3 install.py --no-claude        # Skip Claude CLI and config (keeps skills if already installed)
        """
    )

    parser.add_argument('--no-dependencies', action='store_true', help='Skip Homebrew and packages')
    parser.add_argument('--no-zsh', action='store_true', help='Skip ZSH configuration')
    parser.add_argument('--no-git', action='store_true', help='Skip Git configuration')
    parser.add_argument('--no-nodejs', action='store_true', help='Skip Node.js setup')
    parser.add_argument('--no-claude', action='store_true', help='Skip Claude CLI and configuration')
    parser.add_argument('--no-nvim', action='store_true', help='Skip Neovim configuration')
    parser.add_argument('--no-tmux', action='store_true', help='Skip Tmux configuration')
    parser.add_argument('--no-lazygit', action='store_true', help='Skip Lazygit configuration')
    parser.add_argument('--no-skills', action='store_true', help='Skip Claude skills installation')
    parser.add_argument('--no-bin', action='store_true', help='Skip user executables installation')

    args = parser.parse_args()

    # Build skip list from arguments
    skip_sections = []
    if args.no_dependencies:
        skip_sections.append('dependencies')
    if args.no_zsh:
        skip_sections.append('zsh')
    if args.no_git:
        skip_sections.append('git')
    if args.no_nodejs:
        skip_sections.append('nodejs')
    if args.no_claude:
        skip_sections.append('claude')
    if args.no_skills:
        skip_sections.append('skills')
    if args.no_nvim:
        skip_sections.append('nvim')
    if args.no_tmux:
        skip_sections.append('tmux')
    if args.no_lazygit:
        skip_sections.append('lazygit')
    if args.no_bin:
        skip_sections.append('bin')

    installer = DotfilesInstaller(skip_sections=skip_sections)
    installer.run()


if __name__ == "__main__":
    main()
