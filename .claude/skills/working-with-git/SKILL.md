---
name: Working with Git (Dotfiles)
description: How to make commits, create branches, open PRs, and check alignment. Use when working with git—committing changes, creating branches, opening pull requests, or verifying branch status.
---

# Working with Git (Dotfiles)

**Project-level procedural skill:** Step-by-step workflows for conventional commits, branch management, and PR creation in the dotfiles project.

---

## Procedure: Make a Commit

**When:** You have staged changes ready to commit.

### Steps

1. **Identify the scope** of your change:
   - Look at which files you modified (see scope table below)
   - Use the scope that best describes the area

2. **Stage your changes:**
   ```bash
   git add <files>
   # or: git add -A (all changes)
   ```

3. **Write your commit message** in this format:
   ```
   type(scope): description
   ```
   - **type:** `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `perf`
   - **scope:** One of the valid scopes (see below)
   - **description:** Lowercase, imperative mood, under 50 characters

   Examples:
   - `feat(nvim): add telescope keymap for grep`
   - `fix(zsh): correct git prompt indicator logic`
   - `refactor(tmux): consolidate display-menu bindings`

4. **Create the commit:**
   ```bash
   git commit -m "type(scope): description"
   ```

5. **Verify** the commit appears in history:
   ```bash
   git log --oneline -3
   ```

**Automated alternative:** Use the `/git-checkpoint` slash command for validation.

---

## Procedure: Create a Branch

**When:** Starting work on a new feature, fix, or change.

### Steps

1. **Ensure you're on main:**
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Name your branch** using this format:
   ```
   type/short-description
   ```
   - **type:** `feature`, `fix`, `chore`, `docs`
   - **description:** Kebab-case, descriptive but concise

   Examples:
   - `feature/nvim-lsp-keymaps`
   - `fix/zsh-prompt-colors`
   - `chore/update-dependencies`

3. **Create and switch to the branch:**
   ```bash
   git checkout -b feature/your-description
   ```

4. **Verify you're on the new branch:**
   ```bash
   git branch
   # Should show * next to your branch name
   ```

---

## Procedure: Open a Pull Request

**When:** Your commits are ready for review.

### Steps

1. **Check alignment with main** (see Procedure: Check Alignment below)

2. **Push your branch to remote:**
   ```bash
   git push origin <branch-name> -u
   ```

3. **Create the PR:**

   **Automated (recommended):** Use the `/git-propose` slash command.

   **Manual:** Go to GitHub and create a PR with:
   - **Title:** `type(scope): description` (match your commit format)
   - **Description:** Include summary and test plan (see template below)

4. **PR description template:**
   ```markdown
   ## Summary
   - What changed and why
   - Key decisions or approach

   ## Test Plan
   - How to test these changes
   - What shouldn't break
   ```

5. **Wait for review** and make any requested changes by committing to the same branch.

---

## Procedure: Check Alignment with Main

**When:** Before pushing, to ensure no conflicts or unexpected divergence.

### Steps

1. **Fetch latest changes from remote:**
   ```bash
   git fetch origin
   ```

2. **View commits unique to your branch:**
   ```bash
   git log main..HEAD --oneline
   ```
   Should show only YOUR commits, not other people's.

3. **Check for conflicts:**
   ```bash
   git diff main...HEAD
   ```
   Review the output. If there are conflicts, resolve them before pushing.

4. **Verify branch is ahead of main (not behind):**
   ```bash
   git status
   ```
   Should show "Your branch is ahead of 'origin/main' by X commits"

**Automated alternative:** Use the `/git-align` slash command for a full alignment report. Add modes:
   - `/git-align main` – Full report
   - `/git-align main summary` – Just ahead/behind counts
   - `/git-align main conflicts` – Conflict detection only

---

## Procedure: Review Changes Before Committing

**When:** You want to verify what you're about to commit.

### Steps

1. **See all changes (staged and unstaged):**
   ```bash
   git status
   ```

2. **View detailed changes for a specific file:**
   ```bash
   git diff <filename>
   # or: git diff --staged <filename> (for staged changes)
   ```

3. **Stage selectively** (if you want to commit only some changes):
   ```bash
   git add -p
   # Prompts for each hunk: y/n to stage individually
   ```

4. **Preview what will be committed:**
   ```bash
   git diff --staged
   ```

---

## Quick Reference

### Valid Project Scopes

| Scope | Area |
|-------|------|
| `nvim` | Neovim config (init.lua, plugins, keymaps) |
| `zsh` | Zsh shell config (functions, aliases, completions) |
| `tmux` | Tmux configuration |
| `git` | Git global config, hooks |
| `claude` | Claude Code setup (skills, agents, context) |
| `install` | Installation script, Brewfile |
| `docker` | Docker configs |

### Commit Types

- `feat` – New feature
- `fix` – Bug fix
- `chore` – Maintenance (deps, config, etc.)
- `refactor` – Code reorganization (no logic change)
- `docs` – Documentation
- `test` – Test additions/changes
- `perf` – Performance improvement

### Commit Checklist

- [ ] Scope is valid
- [ ] Type is correct
- [ ] Description under 50 chars
- [ ] Lowercase and imperative
- [ ] Only one concern per commit

---

## Slash Commands (Atomic Operations)

These commands provide instant context and structured output for composing workflows:

### Core Commands

| Command | Intent | Output |
|---------|--------|--------|
| `/git-snapshot [scope]` | Get current state | Branch, status, diffs, commits, stashes |
| `/git-checkpoint [filter]` | Save progress | Commit hash, files changed, next actions |
| `/git-align [target] [mode]` | Check sync | Ahead/behind counts, commits, conflicts |
| `/git-propose [target] [mode]` | Share work | PR readiness, draft, or creation confirmation |

### Snapshot Scopes

- `full` (default) – Complete state
- `status` – Just file changes
- `diff` – Just diff stats
- `staged` – Just staged changes
- `history` – Just recent commits

### Propose Modes

- `--validate` – Check readiness (no PR created)
- `--draft` – Show PR preview (no PR created)
- (empty) – Create actual PR

---

## Workflows (Composed Slash Commands)

Use these workflows for common tasks by calling slash commands in sequence.

### Workflow: Quick Checkpoint

**Intent:** Save current progress with one command

```
→ /git-checkpoint
```

**What happens:**
1. Analyzes current changes
2. Stages intelligently
3. Generates commit message
4. Creates commit

---

### Workflow: Check Status Before Committing

**Intent:** Verify what you're about to commit

```
→ /git-snapshot status
→ /git-snapshot diff
→ /git-checkpoint
```

**What happens:**
1. Shows file changes summary
2. Shows detailed diffs
3. Commits with validation

---

### Workflow: Prepare for PR

**Intent:** Verify readiness before creating PR

```
→ /git-snapshot full
→ /git-align main
→ /git-propose main --validate
```

**What happens:**
1. Current state snapshot
2. Alignment check with main
3. Validation report (no PR created yet)

**If validate passes:**
```
→ /git-propose main --draft
→ /git-propose main
```

---

### Workflow: Safe Commit & PR

**Intent:** Complete flow from changes to PR

```
→ /git-snapshot status
→ /git-checkpoint
→ /git-align main
→ /git-propose main --validate
→ /git-propose main
```

**What happens:**
1. Check current state
2. Create checkpoint commit
3. Verify alignment with main
4. Validate PR readiness
5. Create PR

---

### Workflow: Fix and Update PR

**Intent:** When review feedback requires changes

```
→ /git-checkpoint
→ /git-align main summary
→ /git-propose main --draft
```

**What happens:**
1. Create new commit with fixes
2. Quick check if still aligned
3. Preview updated PR (shows all commits)

---

## Decision Tree: When to Use What

### I want to understand current state
→ Use `/git-snapshot [scope]`
- Full view: `/git-snapshot`
- Status only: `/git-snapshot status`
- Diffs only: `/git-snapshot diff`

### I have changes to save
→ Use `/git-checkpoint [filter]`
- Save everything: `/git-checkpoint`
- Save specific area: `/git-checkpoint nvim only`
- Preview first: use `/git-snapshot` then `/git-checkpoint`

### I want to check sync with team
→ Use `/git-align [target] [mode]`
- Full report: `/git-align main`
- Quick summary: `/git-align main summary`
- Conflict check: `/git-align main conflicts`

### I'm ready to share work
→ Use `/git-propose [target] [mode]`
- Check readiness: `/git-propose main --validate`
- Preview PR: `/git-propose main --draft`
- Create PR: `/git-propose main`

---

## Automation & Slash Commands

All slash commands:
- Return **structured data** (minimal prose, easy to parse)
- Support **parameters** for efficiency (scopes, modes, filters)
- Provide **next actions** in output
- Work **standalone** (useful directly) and **composable** (skills use them)
