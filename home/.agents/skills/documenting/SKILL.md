---
name: documenting
description: Personal baseline for repository docs. Use when asked to audit a repo's docs against the baseline or migrate a repo to it, and when creating or editing a README, AGENTS.md, STATUS.md, ADR or page under docs/.
---

# Documenting

## First, decide which rules apply

Check the repo before writing anything.

1. `docs/how-to/documenting.md` exists: the repo has adopted the baseline. Follow that file, then the rules below.
2. No such file, and the remote is under `jubalm/` or `bytebroshq/`: follow the conventions the repo already has. Do not restructure it. Say once that it has not adopted the baseline, and offer an audit.
3. Any other remote: follow that project's conventions. Do not propose the baseline or a migration.

## Audit

Run when asked to audit, compare or check a repo. Read only; change nothing.

1. Read the README, `AGENTS.md` or `CLAUDE.md`, the docs tree, the package scripts, and the config schema or wrangler config.
2. Report one table with a row per baseline rule: rule, state (matches, missing or conflicts), what the repo has now, effort (S, M or L).
3. Under the table, list the S rows as the ones that are easy to migrate.
4. Wait to be told which rows to act on. On a case 3 repo, stop at the report.

## Migrate

Run only when asked, on its own branch, never alongside other work.

1. Keep text that is correct. Move it to the right folder instead of rewriting it.
2. Create missing files from `templates/`.
3. Add `docs/how-to/documenting.md` from the template and fill in the project's specifics. This file marks the repo as adopted.
4. Add the documenting line to "Done means" in `AGENTS.md` (see the template).
5. Delete pages that are wrong or duplicated. Git history keeps them.

## Baseline

### Layout

```text
repo/
├── README.md        # what, why, quickstart, links into docs/
├── AGENTS.md        # short router for agents
├── STATUS.md        # active repos only: what works, what's half-done
├── CHANGELOG.md     # only if the project has releases
├── .env.example     # sample values; not the source of truth
└── docs/
    ├── README.md    # index: every page and one line each
    ├── tutorials/   # learning by doing
    ├── how-to/      # steps for one task
    ├── reference/   # facts to look up; generate where possible
    ├── explanation/ # why and how the parts fit
    └── decisions/   # ADRs: NNNN-kebab-title.md
```

Minimum for a small repo: `README.md`, `AGENTS.md`, `docs/README.md`, `docs/how-to/setup.md`, `docs/explanation/architecture.md`, `docs/decisions/`. Leave out folders until they have a page.

### What goes where

| Content | Home |
| --- | --- |
| Why the system is shaped this way | `docs/explanation/` |
| Why one choice was made | ADR in `docs/decisions/` |
| Steps for a task (setup, deploy, restore) | `docs/how-to/` |
| What an agent can't learn from the repo | `AGENTS.md` |
| Config keys | The schema or wrangler config. Link to it; don't copy it |
| API signatures, CLI flags | Generated from code into `docs/reference/` |
| Why one line is odd | A comment beside it |
| What works and what's half-done | `STATUS.md` |
| Work others may pick up | Issues |
| Private to-dos | Outside the repo |
| Secrets | Secret manager. Docs say where, never the value |

Each fact has one home. Everything else links to it.

### Pages

- One type per page: tutorial, how-to, reference or explanation. The one exception is a troubleshooting section that may close a how-to; put the error message in its heading.
- One topic per file. Name the file for what it is (`how-to/rotate-gmail-oauth.md`).
- The first paragraph states the point and the scope.
- Headings say what the section is (`## Restore D1 from backup`, not `## Step 3`).
- No frontmatter. The folder gives the type and the H1 gives the title.
- Relative links. Code blocks carry a language tag and values that run.
- Describe what exists now. Plans go in issues.

### AGENTS.md

- Under 150 lines, written by hand.
- Point to the package scripts; don't list them. Add only what scripts can't say: how to run one test, which checks must pass, commands that aren't scripts.
- Include non-obvious rules with a one-clause reason, gotchas that have cost time twice, and a "Where to look" list.
- Leave out anything the README, the scripts or a linter already covers, and any tour of the architecture.
- Rules that apply in every repo (branch naming, commit rules) live in the user-level `AGENTS.md`, not here. On a shared repo, that project's convention wins and is written in its own file.
- A rule that must hold every time goes in tooling: CI, or hooks and deny rules in `.claude/settings.json`. `AGENTS.md` is advice.
- Claude Code reads `AGENTS.md` when the repo has no `CLAUDE.md`. If Claude-only notes are needed, create `CLAUDE.md` with `@AGENTS.md` as its first line. Don't symlink.

### ADRs

- One per decision that would make someone ask why it is like this.
- `docs/decisions/NNNN-kebab-title.md`. Sections: status, context, options, decision, consequences. Half a page.
- Don't edit an accepted decision. Write a new ADR that supersedes it and link both ways.
- `docs/decisions/README.md` explains the filename and where status sits. It is not a list of ADRs.

### STATUS.md

- State only: works, in progress, open questions. No task list.
- Update it when what works or what's half-done has changed, not in every PR.

### Writing

- Lead with the answer. Second person, present tense, active voice.
- Short sentences. One action per numbered step, with the expected result when it matters.
- Real commands and values. Fake secrets that look fake (`sk_test_xxx`).
- One term per concept, used everywhere.
- Skip anything a reader can see in the code.
