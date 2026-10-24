# Agent Brief

This repository reproduces a single macOS development environment. Favor clear, conservative changes over generalized tooling.

Global agent rules in `home/.agents/AGENTS.md` also apply here. Layout is in `README.md`.

## Directives

- Limit changes to the requested scope and follow existing patterns.
- Place changes by kind: software in `Brewfile`, `$HOME` files under `home/`, and `install.py` only when symlinks are insufficient.
- Keep tracked configuration portable; exclude secrets, machine-specific values, generated state, caches, and history.
- Keep installation idempotent and non-destructive; preserve unmanaged local data. Never run the complete installer against the active home directory unless explicitly requested.
- Preserve unrelated working-tree changes.
- Test the smallest affected surface, and validate changed file formats and executable paths.
- Commit or push only when explicitly requested.
