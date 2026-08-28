---
name: git-inspect
description: Git maintenance workflow — inspects repo state, proposes commit/sync/cleanup actions, executes only the approved ones, and verifies the result. Use when the user asks to check git changes, propose a commit, see if a branch is merged, clean up merged branches and go back to main, or check if the repo/workspace is synced with origin.
---

# Git Inspect

## Workflow

1. Inspect
2. Propose
3. Confirm
4. Execute
5. Verify

## Inspecting Git

Run the bundled script from the project's working directory (read-only, a few seconds; it fetches first — add `--no-fetch` when offline):

```bash
bash "<SKILLS_DIR>/scripts/inspect.sh"
```

- It prints a labeled digest. Do not run your own git commands unless a label below says you must.
- Ask for a repository path if the current directory produces `error: not a git repository`.

## Reading the digest

| Label | Use for |
|---|---|
| `error: not a git repository` | Report and stop — offer `git init` only if the user asks |
| `branch:` / `default-branch:` | Which branch you're on; where cleanup returns to |
| `changes:` counts + change lines | **Commit plan** — group the listed paths into logical commits |
| `secret-suspects:` | Never propose committing these; call them out |
| `vs upstream:` (`+N/-M`) | **Sync plan** — behind: `pull --ff-only`; ahead: `push`; both: `pull --rebase` then `push`; missing upstream: `push -u origin <branch>` |
| `recent-commits:` | Match the repo's commit-message style for proposals |
| `branches:` + `track:` | Per-branch sync state (`[gone]` = upstream deleted) |
| `cleanup-candidates:` | **Cleanup plan** — `git branch -d` each after switching to the default branch; pre-filtered against worktrees/current/default |
| `gone-upstream:` | Remote deleted — may hold unmerged work; ask the user before `-D` |
| `worktrees:` | Never propose touching branches listed here |
| `stash:` | Mention count only; dropping stashes needs explicit confirmation |

Commit plan / Sync plan / Cleanup plan read directly from the digest labels above — no cross-referencing needed.

## Propose → Confirm → Execute → Verify

After the inspection completes, summarize the repository state and present only non-empty plans as a numbered menu. Do not ask an open-ended "what should I do?" before presenting the inspection results:

**Wait for confirmation before any mutation.**

1. **Commit plan** — grouped files + a style-matched message per group
2. **Sync plan** — pull/push/rebase steps for the current branch
3. **Cleanup plan** — `git branch -d <name>` per candidate, then switch to the default branch if not already there

Execute only chosen items, one at a time, checking output.

**Verify (mandatory last step):** re-run `inspect.sh --no-fetch` and present the resulting clean state. No execution without a verification after it.

## Never

- `push --force` — only `--force-with-lease`, only on explicit request
- `reset --hard`, `checkout -- .`, dropping stashes — only on explicit confirmation
- Committing `secret-suspects:` paths; deleting remote, worktree, current, or default branches
- Improvising around conflict markers, in-progress merges/rebases, or detached HEAD — report state, propose recovery, wait
