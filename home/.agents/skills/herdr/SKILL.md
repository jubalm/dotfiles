---
name: herdr
description: "Use when the user asks to inspect or control Herdr panes, tabs, workspaces, terminals, commands, or agents, or when Herdr is the selected local adapter for an execution task. Requires a Herdr-managed environment."
---

# Herdr

Herdr is a terminal multiplexer and runtime for coding agents. The installed binary is the sole authority for its mechanics; this skill is only a gate and a handoff to that guidance, never a hand-maintained copy.

## Scope

The binary's guidance covers availability, panes, launch, lifecycle, evidence retrieval, continuation, and cleanup. Whether delegation is worthwhile, topology, models, and review/completion are `execute` decisions; for delegated work run that skill first and this one only after Herdr is selected. Direct inspection or control needs no execution qualification unless it introduces delegated work.

Do not use Herdr merely because a task could benefit from a background terminal or parallel work.

## Handoff

Before any Herdr command, verify this agent runs inside a Herdr-managed pane:

```bash
test "${HERDR_ENV:-}" = 1
```

On failure, say you are not running inside Herdr and stop; never control the session from outside. On success, print and follow the version-matched manual:

```bash
herdr --skill
```

That output wins over anything remembered about Herdr; follow it now, do not save it as a file. If `--skill` is unrecognized, fall back to `herdr --help` and printing the needed command group without a subcommand — never bare `herdr`, which launches or attaches the TUI.
