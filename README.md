# Jubal's macOS Development Environment

## Installation

```bash
git clone git@github.com:jubalm/dotfiles.git
cd dotfiles
./install.py
```

The installer backs up existing files before creating symlinks, and symlinks
`~/.agents/AGENTS.md` and `~/.claude/CLAUDE.md` to the shared agent rules in
`home/.agents/AGENTS.md`.

## Selective Installs

```bash
./install.py --help
```

Each `--no-*` flag skips that section without removing or changing its existing
configuration. These flags do not uninstall software. Shared agent rules at
`~/.agents/AGENTS.md` are still installed on every run.

Enabled Claude/Pi sections prune only dangling symlinks that match this repo's
per-entry source paths. Unrelated links, files, and directories are left alone.
The installer also removes the dangling repo-owned `~/.config/tmux` link left by
the retired tmux configuration.

## What's Included

### Configuration

- Zsh shell and Git global ignore
- Ghostty, Herdr, Handy, Neovim, and lazygit
- Claude configuration and MCP servers
- Shared agent rules and skills
- Pi coding agent, with shared skills linked into its skill path

### Tools

- Homebrew packages and applications from `Brewfile`
- Node.js tooling, via `n`
- Claude CLI, installed with `curl -fsSL https://claude.ai/install.sh | bash` when missing

## Project Workflow Skills

Shared sources live in `home/.agents/skills`; the installer links the directory
into `~/.agents/skills` and `~/.claude/skills`, and links each skill
individually into `~/.pi/agent/skills`.

Maintained here:

| Skill | Purpose |
| --- | --- |
| [adaptive-communication](home/.agents/skills/adaptive-communication/SKILL.md) | Match explanations and decision support to the recipient's actual question |
| [git-inspect](home/.agents/skills/git-inspect/SKILL.md) | Inspect repo state and propose commit, sync, and cleanup actions |
| [handoff-work](home/.agents/skills/handoff-work/SKILL.md) | Prepare compact, executable assignments and continuation handoffs |
| [project-context](home/.agents/skills/project-context/SKILL.md) | Bootstrap and repair durable repository context |
| [review-change](home/.agents/skills/review-change/SKILL.md) | Review changes for supported findings and verification limits |

### Default communication instruction

Skills are invoked when relevant; merely installing one does not make it an always-on behavior. To apply adaptive communication in another agent, add this short instruction to its persistent agent guidance:

> Infer the actual uncertainty or decision behind a question. Ground claims in evidence and distinguish facts from inference. Use the simplest effective representation—prose by default, or an example, diagram, timeline, comparison, or interactive model when it materially improves understanding. Carry context forward; reframe rather than merely expand an explanation that did not land. Do not introduce ritual or visuals for their own sake.

The [adaptive-communication skill](home/.agents/skills/adaptive-communication/SKILL.md) contains the detailed practice and examples. Keep this line in the agent's normal instruction layer; do not rely on skill discovery for always-on behavior.

Also synced, but vendored from upstream:

| Skill | Purpose |
| --- | --- |
| [find-skills](home/.agents/skills/find-skills/SKILL.md) | Discover and install agent skills |
| [herdr](home/.agents/skills/herdr/SKILL.md) | Inspect and control Herdr panes, tabs, and agents |

## Testing

Run the installer regression suite from the repository root:

```sh
python3 -B -m unittest discover -s tests -v
```

Tests use temporary home directories and do not install packages or modify your
active home directory.

## Repository Layout

```text
.
├── Brewfile       # Homebrew dependencies
├── home/          # Files symlinked into $HOME
├── tests/         # Installer regression tests
└── install.py     # Installer
```

## Disclaimer

This is a personal repo, so defaults may be opinionated and machine-specific. The code and config files are the source of truth for exact behavior.
