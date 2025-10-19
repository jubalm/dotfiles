---
name: Working with Git (Dotfiles)
description: Intelligent git workflow orchestration. Recognizes intent ("save progress", "create PR", "check sync"), executes command sequences, parses structured output for decisions. Use when user mentions git workflows OR proactively after file edits.
---

# Working with Git (Dotfiles)

**Project-level orchestration skill:** Intelligent workflows that map natural language intent → command sequences, gather context only when needed, auto-execute read-only ops, ask before writes, and parse structured output to guide next actions.

---

## Intent Recognition (Natural Language → Workflows)

This section maps common user requests to appropriate workflows. The skill uses these patterns to orchestrate command sequences automatically.

### Intent Patterns

| User Says | Intent | Workflow | Execution |
|-----------|--------|----------|-----------|
| "save my progress" | Checkpoint current work | Quick Checkpoint | Auto-execute, ask before commit |
| "checkpoint this" | Same as above | Quick Checkpoint | Auto-execute, ask before commit |
| "what changed?" | Observe current state | Status snapshot | Auto-execute, no approval needed |
| "show me current state" | Same as above | Full snapshot | Auto-execute, no approval needed |
| "am I ready to push?" | Check PR readiness | Prepare for PR | Auto-snapshot, auto-align, propose for review |
| "can I create a PR?" | Same as above | Prepare for PR | Auto-snapshot, auto-align, propose for review |
| "create a PR" | Initiate PR creation | Safe Commit & PR | Auto-execute readiness checks, ask before each write |
| "open pull request" | Same as above | Safe Commit & PR | Auto-execute readiness checks, ask before each write |
| "I got feedback" | Update PR with fixes | Fix and Update PR | Auto-execute, ask before new commits |
| "check if I'm synced" | Alignment verification | Alignment only | Auto-execute, data only |
| "I need to rebase" | Divergence recovery | Context gathering first | Snapshot full, then recommend action |

---

## Orchestration Logic

The skill makes decisions in this order:

### 1. Parse User Intent
Use natural language patterns from the Intent Patterns table above.
- Match keywords: "save", "progress", "checkpoint" → Quick Checkpoint
- Match keywords: "ready", "PR", "push" → Prepare for PR
- Match keywords: "what", "changed", "show" → Snapshot workflows
- Match keywords: "create", "open", "PR" → Safe Commit & PR
- Match keywords: "feedback", "review", "update" → Fix and Update PR

### 2. Determine Context Need
**Gather context if:**
- Intent is ambiguous or could match multiple workflows
- Workflow depends on git state (branch ahead/behind, conflicts)
- User made changes but state is unknown

**Don't gather context if:**
- Intent is explicit and clear (e.g., "checkpoint this")
- Workflow is read-only observation (snapshot, align)
- User is just asking "what is my state?"

### 3. Select Workflow
Use Intent Patterns table → match to workflow.
If multiple workflows match:
- **Auto-selecting heuristic:** Choose based on git state
  - If uncommitted changes → Quick Checkpoint
  - If ahead of main & no conflicts → Prepare for PR
  - If diverged or behind → Alignment check first

### 4. Execute Command Sequence
**Auto-execute (no approval needed):**
- `/git-snapshot [scope]` - Read-only, safe to auto-execute
- `/git-align [target] [mode]` - Read-only, safe to auto-execute

**Ask before execute (write operations):**
- `/git-checkpoint [filter]` - Creates commit, ask for approval
- `/git-propose [target] [mode]` - Creates PR, ask for approval

**Hybrid execution example:**
```
User: "create a PR"
→ Step 1 (auto): /git-snapshot status (understand current state)
→ Step 2 (auto): /git-align main (check if aligned)
→ Step 3 (ask): "Found 3 changes, aligned with main. Create checkpoint commit?"
→ Step 4 (ask): "Ready to propose PR to main?"
```

### 5. Parse Structured Output
All slash commands return structured data wrapped in HTML comments:
```html
<!-- SNAPSHOT -->
...data...
<!-- /SNAPSHOT -->
```

After each command:
- Extract key data (file counts, ahead/behind, conflicts)
- Use data to inform next step or decision
- Example: If `/git-align` shows conflicts, don't suggest `/git-propose`

### 6. Provide Intelligent Guidance
Show:
- What data was gathered and why
- What workflow is being executed
- What the next step will be (with approval prompt if needed)
- Alternative workflows if user input is ambiguous

---

## Context-Aware Decisions

The skill gathers context only when needed, not preemptively.

### When to Gather Context

**Decision point: Is context needed?**

| Scenario | Context Scope | Why |
|----------|---------------|-----|
| Intent is explicit ("checkpoint") | None | User is clear about action |
| Intent is ambiguous ("help with git") | status | Quick assessment to choose workflow |
| Checking if ready for PR | staged + diff | Need to know what's ready to propose |
| Deciding between commits | full | Need branch, status, history context |
| User says "I need to rebase" | full | Need comprehensive state to diagnose |
| Workflow requires state knowledge | targeted | Only load what workflow needs |

### Context Gathering Sequence

```
1. Recognize intent from user request
2. Check: Is intent explicit enough to skip context?
   - YES → Execute workflow immediately
   - NO → Ask: "Checking git state..."
3. Execute: /git-snapshot [targeted-scope]
4. Parse output: Extract key facts
5. Make workflow decision based on facts
6. Execute workflow
```

### Example: Ambiguous Intent

User: "help with git"

```
Orchestration logic:
1. Intent unclear (matches multiple workflows)
2. Gather context: /git-snapshot status (fast, lightweight)
3. Parse output:
   - "Modified: 3 files"
   - "Ahead: 1 commit"
4. Choose workflow: Quick Checkpoint (changes exist, ready to save)
5. Recommend: "I see 3 modified files. Save as checkpoint commit?"
```

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

Use these workflows for common tasks by calling slash commands in sequence. The orchestration skill uses these patterns to guide decisions.

### Workflow: Quick Checkpoint

**Intent:** Save current progress with one command

**Trigger patterns:** "save my progress", "checkpoint this", "save these changes"

**Command sequence:**
```
→ /git-checkpoint
```

**Implementation (Orchestration Logic):**
```
1. Recognize intent: User wants to save work
2. Context check: No context needed (checkpoint handles discovery)
3. Execute: /git-checkpoint (WRITE - ask for approval)
   - "I'll create a checkpoint commit. Analyzing changes..."
4. Parse output: Extract commit hash, files changed count
5. Result: Report "✓ Checkpoint created: [hash] ([N] files)"
6. Next action: "Ready to push? Use: git push origin [branch]"
```

**Skill decision:** Auto-ask, no context gathering needed.

---

### Workflow: Check Status Before Committing

**Intent:** Verify what you're about to commit before checkpoint

**Trigger patterns:** "what changed?", "show me current state", "let me review first"

**Command sequence:**
```
→ /git-snapshot status
→ /git-snapshot diff
→ /git-checkpoint
```

**Implementation (Orchestration Logic):**
```
1. Recognize intent: User wants to review before commit
2. Context check: Not needed (snapshot auto-discovers)
3. Execute:
   - /git-snapshot status (READ - auto-execute)
     Parse: Modified count, staged count
   - /git-snapshot diff (READ - auto-execute)
     Parse: File-by-file changes
4. Show user: "Found N modified files with X changed lines"
5. Ask: "Create checkpoint commit?"
   - If yes → /git-checkpoint (WRITE - ask)
   - If no → Stop
```

**Skill decision:** Auto-execute reads, ask before write.

---

### Workflow: Prepare for PR

**Intent:** Verify readiness before creating PR

**Trigger patterns:** "am I ready to push?", "can I create a PR?", "check if I'm synced"

**Command sequence:**
```
→ /git-snapshot full
→ /git-align main
→ /git-propose main --validate
```

**Implementation (Orchestration Logic):**
```
1. Recognize intent: User wants PR readiness check
2. Context check: NEEDED (must know ahead/behind, conflicts)
3. Execute:
   - /git-snapshot full (READ - auto-execute)
     Parse: Branch, commits, file changes, stashes
   - /git-align main (READ - auto-execute)
     Parse: Ahead, behind, conflicts (if any)
4. Decision logic:
   - If conflicts → Show warning, suggest resolve first
   - If behind main → Show warning, suggest rebase
   - If ahead & clean → Proceed
5. Execute: /git-propose main --validate (READ - auto-execute)
   Parse: Validation result (passed/failed)
6. Result:
   - If passed → "✓ Ready for PR! Use: /git-propose main --draft"
   - If failed → Show issues and recovery steps
```

**Skill decision:** Auto-execute all (they're read-only), show results and next action.

**If validation passes:**
```
→ /git-propose main --draft
→ /git-propose main
```

---

### Workflow: Safe Commit & PR

**Intent:** Complete flow from changes to PR (safest option)

**Trigger patterns:** "create a PR", "open pull request", "submit changes for review"

**Command sequence:**
```
→ /git-snapshot status
→ /git-checkpoint
→ /git-align main
→ /git-propose main --validate
→ /git-propose main
```

**Implementation (Orchestration Logic):**
```
1. Recognize intent: User wants to create PR with safety checks
2. Context check: Not needed (flow gathers data as it goes)
3. Execute step-by-step:

   Step 1: /git-snapshot status (READ - auto-execute)
   - Show: Current changes summary

   Step 2: /git-checkpoint (WRITE - ask for approval)
   - "Create checkpoint commit for these changes?"
   - If approved: Execute, parse commit hash
   - If declined: Offer alternative (review first?)

   Step 3: /git-align main (READ - auto-execute)
   - Check: Ahead/behind/conflicts
   - If conflicts: Stop, suggest recovery

   Step 4: /git-propose main --validate (READ - auto-execute)
   - Check: Branch protection, PR readiness
   - If unready: Show issues

   Step 5: /git-propose main --draft (READ - auto-execute)
   - Show: PR preview (title, description, commits)

   Step 6: /git-propose main (WRITE - ask for approval)
   - "Create PR with this content?"
   - If approved: Execute, return PR URL
   - If declined: Offer edit options
```

**Skill decision:** Multi-step with asks at write points, auto-execute reads, parse between each step.

---

### Workflow: Fix and Update PR

**Intent:** When review feedback requires changes

**Trigger patterns:** "I got feedback", "update the PR", "fix the review comments"

**Command sequence:**
```
→ /git-checkpoint
→ /git-align main summary
→ /git-propose main --draft
```

**Implementation (Orchestration Logic):**
```
1. Recognize intent: User has fixes for existing PR
2. Context check: Not needed (all commands are lightweight)
3. Execute:
   - /git-checkpoint (WRITE - ask)
     "Create commit with your fixes?"
   - /git-align main summary (READ - auto-execute)
     Parse: Ahead count (number of commits on this PR now)
   - /git-propose main --draft (READ - auto-execute)
     Parse & show: Updated PR preview (all commits now visible)
4. Result:
   - Show: "PR updated! Now has N commits. Changes pushed automatically"
   - Next: "Wait for review or make more changes"
```

**Skill decision:** Ask only on write operations, auto-execute reads, show cumulative state.

---

## Decision Tree: Skill Orchestration

This tree shows how the **skill recognizes your intent and orchestrates workflows automatically**.

### User Intent: "What changed?"
**Skill recognizes:** Observation request (read-only)
**Orchestration:**
→ Auto-execute: `/git-snapshot status` (understand scope)
→ Parse output: File counts, modified/staged/untracked
→ Show: Summary of changes
→ Auto-execute: `/git-snapshot diff` (if user wants details)

**You can also directly use:**
- Full view: `/git-snapshot` or `/git-snapshot full`
- Status only: `/git-snapshot status`
- Diffs only: `/git-snapshot diff`
- History only: `/git-snapshot history`

---

### User Intent: "Save my progress"
**Skill recognizes:** Write operation (requires approval)
**Orchestration:**
→ Context check: Not needed
→ Ask: "Create checkpoint commit?"
→ If yes: Execute `/git-checkpoint`
→ Parse output: Commit hash, files changed
→ Result: "✓ Checkpoint created"

**You can also directly use:**
- Save everything: `/git-checkpoint`
- Save specific area: `/git-checkpoint nvim only`
- Preview first: Use `/git-snapshot` then ask for `/git-checkpoint`

---

### User Intent: "Am I ready for a PR?"
**Skill recognizes:** Readiness check (read-only, needs context)
**Orchestration:**
→ Auto-gather context: `/git-snapshot full`
→ Parse: Branch, commits, staged changes
→ Auto-execute: `/git-align main`
→ Parse: Ahead/behind/conflicts
→ Decision logic:
   - If conflicts or behind → Show issues, suggest recovery
   - If clean & ahead → Continue to validation
→ Auto-execute: `/git-propose main --validate`
→ Result: "✓ Ready for PR" or show issues

**You can also directly use:**
- Full report: `/git-align main` (or `/git-align main full`)
- Quick summary: `/git-align main summary`
- Conflict check: `/git-align main conflicts`

---

### User Intent: "Create a PR"
**Skill recognizes:** Multi-step write workflow
**Orchestration:**
→ Workflow selected: "Safe Commit & PR"
→ Step 1 (auto): Snapshot current state
→ Step 2 (ask): "Create checkpoint commit?"
→ Step 3 (auto): Check alignment with main
→ Step 4 (auto): Validate PR readiness
→ Step 5 (auto): Show PR preview
→ Step 6 (ask): "Create PR?"
→ Result: PR created with URL

**You can also directly use:**
- Check readiness first: `/git-propose main --validate`
- Preview PR: `/git-propose main --draft`
- Create PR: `/git-propose main`

---

### User Intent: "I got review feedback"
**Skill recognizes:** PR update workflow
**Orchestration:**
→ Workflow selected: "Fix and Update PR"
→ Step 1 (ask): "Create commit with fixes?"
→ Step 2 (auto): Check new ahead count
→ Step 3 (auto): Show updated PR preview
→ Result: "PR updated with N commits"

**You can also directly use:**
- Same workflow: `/git-checkpoint` → `/git-align main summary` → `/git-propose main --draft`

---

## Skill Orchestration: How It Works

When you mention a git workflow or ask a git question, the skill:

### 1. Recognizes Intent (Natural Language Parsing)
Uses keyword patterns to understand what you want:
- Keywords: "save", "progress", "checkpoint" → Quick Checkpoint workflow
- Keywords: "ready", "PR", "push" → Prepare for PR workflow
- Keywords: "what", "changed", "show" → Snapshot workflow
- Keywords: "create", "PR", "open" → Safe Commit & PR workflow
- Keywords: "feedback", "update", "review" → Fix and Update PR workflow

### 2. Determines Context Need (Token Efficiency)
Only gathers git state if needed:
- Explicit intent ("save my progress") → No context needed
- Ambiguous intent ("help with git") → Quick status snapshot
- Readiness checks → Full context gathering
- Single-command requests → No preemptive gathering

### 3. Executes Command Sequence
**Read-only commands:** Auto-execute (safe, no side effects)
- `/git-snapshot [scope]` - Point-in-time state observation
- `/git-align [target] [mode]` - Alignment verification

**Write commands:** Ask for approval (ask-before-write pattern)
- `/git-checkpoint [filter]` - Creates commit
- `/git-propose [target] [mode]` - Creates or updates PR

### 4. Parses Structured Output
All commands return data wrapped in HTML comments (`<!-- COMMAND -->...<!-- /COMMAND -->`).

Skill extracts:
- File counts, change sizes
- Ahead/behind counts
- Conflict detection
- Commit hash for confirmation
- Validation results

### 5. Makes Smart Decisions
Uses parsed output to decide next steps:
- If conflicts detected → Suggest resolution before proceeding
- If behind main → Suggest rebase
- If validation passed → Offer next action
- If ambiguous → Ask user for clarification

### 6. Provides Intelligent Guidance
Explains:
- What data was gathered and why
- What workflow was selected and why
- What the next step is
- What alternatives exist

---

## Real-World Orchestration Examples

These examples show how the skill orchestrates workflows in practice.

### Example 1: User says "save my progress"

```
User input: "save my progress"

SKILL ORCHESTRATION:
1. Parse intent: Matches "save", "progress" → Quick Checkpoint workflow
2. Context needed? No (checkpoint auto-discovers changes)
3. Execute immediately: Ask "Create checkpoint commit?"
   (No context gathering needed - checkpoint will analyze)
4. If approved:
   - Execute: /git-checkpoint (WRITE)
   - Parse output: Extract commit hash, files changed count
5. Result: "✓ Checkpoint created: a7f2d1e9 (3 files: nvim, zsh, git)"
6. Next action: "Ready to push? Use: git push origin feature/my-work"
```

### Example 2: User says "am I ready for a PR?"

```
User input: "am I ready for a PR?"

SKILL ORCHESTRATION:
1. Parse intent: Matches "ready", "PR" → Prepare for PR workflow
2. Context needed? YES (must know ahead/behind, conflicts)
3. Gather context:
   - Execute: /git-snapshot full (READ)
   - Parse: Branch=feature/my-work, Ahead=2, Staged=0, Modified=5
4. Continue:
   - Execute: /git-align main (READ)
   - Parse: Ahead=2, Behind=0, Conflicts=0
5. Decision: Clean & ahead → Proceed to validation
   - Execute: /git-propose main --validate (READ)
   - Parse: Status=ready
6. Result:
   ✓ Ready for PR!
   - Branch: feature/my-work
   - 2 commits ahead of main
   - 5 modified files staged
   - No conflicts
7. Next action: "Preview PR? Use: /git-propose main --draft"
   Or directly: "Use: /git-propose main"
```

### Example 3: User says "create a PR"

```
User input: "create a PR"

SKILL ORCHESTRATION:
1. Parse intent: Matches "create", "PR" → Safe Commit & PR workflow
2. Context needed? No (flow gathers data step-by-step)
3. Step 1 (auto): /git-snapshot status (READ)
   - Show: "Modified: 3 files (nvim, zsh, claude)"
4. Step 2 (ask): "Create checkpoint commit with these changes?"
   - If yes:
     - Execute: /git-checkpoint (WRITE)
     - Parse: Commit hash, files changed
     - Show: "✓ Checkpoint created: a7f2d1e"
   - If no: Offer alternative ("View details first? Review changes?")
5. Step 3 (auto): /git-align main (READ)
   - Parse: Ahead=1, Behind=0, Conflicts=0
   - Decision: Green light
6. Step 4 (auto): /git-propose main --validate (READ)
   - Parse: Status=ready
7. Step 5 (auto): /git-propose main --draft (READ)
   - Show PR preview:
     ```
     Title: feat(claude): add git orchestration skill
     Description:
       ## Summary
       - Added intelligent workflow orchestration
       - Recognizes intent from natural language
       - Auto-executes safe operations

     Commits: 1 commit (a7f2d1e)
     ```
8. Step 6 (ask): "Create PR with this content?"
   - If yes:
     - Execute: /git-propose main (WRITE)
     - Parse: PR URL
     - Show: "✓ PR created: https://github.com/user/repo/pull/123"
   - If no: Offer edits or alternatives
9. Next action: "Watch for review feedback or make changes"
```

### Example 4: User says "I got review feedback to fix the tests"

```
User input: "I got review feedback to fix the tests"

SKILL ORCHESTRATION:
1. Parse intent: Matches "feedback", "got" → Fix and Update PR workflow
2. Context needed? No (all commands are lightweight)
3. Step 1 (ask): "Create commit with your test fixes?"
   - If yes:
     - Execute: /git-checkpoint (WRITE)
     - Parse: Commit hash, files changed
     - Show: "✓ Fixes committed: b2e3f4c (1 file: test/git-snapshot.test.js)"
4. Step 2 (auto): /git-align main summary (READ)
   - Parse: Ahead=2 (your original commit + new fix)
5. Step 3 (auto): /git-propose main --draft (READ)
   - Show updated PR preview:
     ```
     Title: feat(claude): add git orchestration skill

     Commits: 2 commits
     - a7f2d1e (original)
     - b2e3f4c (test fixes)
     ```
6. Result: "✓ PR updated with your fixes!"
7. Next action: "Changes pushed automatically. Wait for re-review or make more changes."
```

---

## Slash Commands (Atomic Operations)

All slash commands work standalone:
- Return **structured data** (minimal prose, easy to parse)
- Support **parameters** for efficiency (scopes, modes, filters)
- Provide **next actions** in output
- Work **standalone** (useful directly) and **composable** (orchestrated by skill)
