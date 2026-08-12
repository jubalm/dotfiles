# Agent Brief

This repository reproduces a single macOS development environment. Favor clear, conservative changes over generalized tooling.

## Repository Map

- `Brewfile` — Homebrew packages and applications.
- `home/` — files mapped to equivalent paths under `$HOME`.
- `install.py` — installation, linking, and migration logic.

## Directives

- Follow existing patterns and limit changes to the requested scope.
- Manage software in `Brewfile`, mirror `$HOME` paths under `home/`, and use `install.py` only when symlinks are insufficient.
- Keep tracked configuration portable; exclude secrets, machine-specific values, generated state, caches, and history.
- Keep installation idempotent and non-destructive; preserve unmanaged local data.
- Preserve unrelated working-tree changes.
- Test the smallest affected surface. Never run the complete installer against the active home directory unless explicitly requested.
- Validate changed file formats and executable paths.
- Commit or push only when explicitly requested.
