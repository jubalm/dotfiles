# Jubal's macOS Development Environment

## Installation

```bash
git clone git@github.com:jubalm/dotfiles.git
cd dotfiles
./install.py
```

The installer backs up existing files before creating symlinks.

See `./install.py --help` for selective installs.

## What's Included

### Configuration

- Zsh shell and Git global ignore
- Ghostty, Herdr, Handy, Neovim, and lazygit
- Claude and Pi agent configuration and extensions
- Shared agent skills

### Tools

- Homebrew packages and applications, including Pi
- Node.js tooling
- Claude CLI

## Project Workflow Skills

Shared sources live in `home/.agents/skills`; the installer links them into the shared skills directory and Claude/Pi skill paths.

| Skill | Purpose |
| --- | --- |
| [project-context](home/.agents/skills/project-context/SKILL.md) | Bootstrap and repair durable repository context |
| [handoff-work](home/.agents/skills/handoff-work/SKILL.md) | Prepare compact, executable assignments and continuation handoffs |
| [review-change](home/.agents/skills/review-change/SKILL.md) | Review current changes for supported findings and verification limits |
| [adaptive-communication](home/.agents/skills/adaptive-communication/SKILL.md) | Match explanations and decision support to the recipient's actual question |

### Default communication instruction

Skills are invoked when relevant; merely installing one does not make it an always-on behavior. To apply adaptive communication in another agent, add this short instruction to its persistent agent guidance:

> Infer the actual uncertainty or decision behind a question. Ground claims in evidence and distinguish facts from inference. Use the simplest effective representation—prose by default, or an example, diagram, timeline, comparison, or interactive model when it materially improves understanding. Carry context forward; reframe rather than merely expand an explanation that did not land. Do not introduce ritual or visuals for their own sake.

The [adaptive-communication skill](home/.agents/skills/adaptive-communication/SKILL.md) contains the detailed practice and examples. Keep this line in the agent's normal instruction layer; do not rely on skill discovery for always-on behavior.

## Repository Layout

```text
.
├── Brewfile       # Homebrew dependencies
├── home/          # Files symlinked into $HOME
└── install.py     # Installer
```

## Disclaimer

This is a personal repo, so defaults may be opinionated and machine-specific. The code and config files are the source of truth for exact behavior.
