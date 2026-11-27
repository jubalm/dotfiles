# Document changes in [project]

Write or update docs in the same PR as the change. This page says what to write and where.

## What to write

| You did | Write |
| --- | --- |
| Changed behavior a page describes | Update that page |
| Set up an account, service, secret or DNS record | A step in `docs/how-to/setup.md`: the exact command, and where the secret is stored |
| Changed how to deploy, release or recover | The matching page in `docs/how-to/` |
| Chose between real alternatives | A new ADR in `docs/decisions/` |
| Added or changed a config key | The schema only. Docs link to it |
| Hit an error and fixed it | A troubleshooting entry closing the how-to it belongs to, with the error message as the heading |
| Explained the same thing twice | A page in `docs/explanation/` or `docs/how-to/` |
| Changed what works or what's half-done | `STATUS.md` |
| Added a page | A line in `docs/README.md` |

Extend an existing page when the topic is already covered. Start a new page when the topic or the type differs.

Write nothing when the code already says it.

## Where things are

- Config schema: `[path]`
- Generated reference: `[command]` writes `[path]`. Never edit it by hand.
- [Other project-specific location]

## Project rules

- [Anything this repo does differently]
