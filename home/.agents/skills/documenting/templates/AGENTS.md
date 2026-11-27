# AGENTS.md

[One sentence: what this repo is and who uses it.]

## Commands

Scripts are in `package.json`; read it first. Only what it can't tell you is listed here.

- One test: `[command] path/to/file`
- Must pass before done: `[lint] && [typecheck] && [test]`
- [Command that isn't a script]

## Rules

- [Non-obvious convention, with its reason in one clause]
- Never edit `[generated dir]`; regenerate with `[command]`.
- Read the relevant ADR in `docs/decisions/` before changing architecture. Propose a new ADR instead of diverging.

## Gotchas

- [Thing that has cost time twice]

## Where to look

- `docs/README.md`: index of all docs
- `docs/how-to/setup.md`: accounts, where secrets are stored, local setup
- `docs/explanation/architecture.md`: how the parts fit
- `[path to config schema or wrangler config]`: config keys
- `STATUS.md`: current state

## Done means

1. Tests, lint and typecheck pass.
2. If you changed behavior, set something up or made a choice, read `docs/how-to/documenting.md` and follow it.
