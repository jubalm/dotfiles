#!/usr/bin/env bash
# git-inspect — read-only repo digest for the git-inspect skill.
# Prints labeled, machine-derived facts; the agent interprets and proposes.
# Usage: inspect.sh [--no-fetch]   (run from inside the target repo)
set -uo pipefail

NO_FETCH=0; [[ "${1:-}" == "--no-fetch" ]] && NO_FETCH=1

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "error: not a git repository ($(pwd))"
  exit 1
fi

ROOT=$(git rev-parse --show-toplevel)
echo "# git-inspect — $ROOT"

# --- fetch (refresh remote-tracking refs) ---
fetch_note="skipped (--no-fetch)"
if [[ $NO_FETCH -eq 0 ]]; then
  if git fetch --all --prune --quiet 2>/dev/null; then fetch_note="ok"; else fetch_note="failed (offline?) — sync info may be stale"; fi
fi

# --- default branch ---
DEFAULT=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/origin/||')
if [[ -z "$DEFAULT" ]]; then
  if git show-ref --verify -q refs/heads/main; then DEFAULT=main
  elif git show-ref --verify -q refs/heads/master; then DEFAULT=master
  else DEFAULT=""; fi
fi

# --- branches: name|upstream|track|HEAD-mark|last-commit-date|subject ---
BRANCHES=$(git for-each-ref refs/heads \
  --format='%(refname:short)|%(upstream:short)|%(upstream:track)|%(HEAD)|%(committerdate:short)|%(contents:subject)' 2>/dev/null)

CURRENT=$(git branch --show-current)
[[ -z "$CURRENT" ]] && CURRENT="detached"
HEAD_SHA=$(git rev-parse --short HEAD 2>/dev/null)

echo "branch: ${CURRENT}@${HEAD_SHA}"
echo "default-branch: ${DEFAULT:-none}"
echo "fetch: $fetch_note"
echo "worktrees:"
git worktree list --porcelain 2>/dev/null | awk '
  /^worktree /{w=substr($0,10)}
  /^HEAD /{h=substr($0,6)}
  /^branch /{print "  " substr($2,length("refs/heads/")+1) " @ " w}
  /^bare$/{print "  (bare) @ " w}
'
echo "branches:"
echo "$BRANCHES" | while IFS='|' read -r name up track mark date subj; do
  echo "  $name | upstream: ${up:--} | track: ${track:--} | $date $subj"
done

# --- cleanup candidates: merged into default, minus current/default/worktree branches ---
if [[ -n "$DEFAULT" ]]; then
  WT_BRANCHES=$(git worktree list --porcelain 2>/dev/null | sed -n 's/^branch refs\/heads\///p')
  CANDIDATES=$(comm -23 \
    <(git for-each-ref refs/heads --merged "refs/heads/$DEFAULT" --format='%(refname:short)' 2>/dev/null | sort) \
    <(printf '%s\n' "$WT_BRANCHES" "$DEFAULT" "$CURRENT" | sort -u))
  GONE=$(echo "$BRANCHES" | awk -F'|' '$3 ~ /\[gone\]/ {print $1}' | sort)
  GONE=$(comm -23 <(printf '%s\n' "$GONE") <(printf '%s\n' "$WT_BRANCHES" "$DEFAULT" "$CURRENT" | sort -u))
  echo "cleanup-candidates (merged into $DEFAULT, not worktree/current/default — safe to -d after switch):"
  [[ -n "$CANDIDATES" ]] && echo "$CANDIDATES" | sed 's/^/  /' || echo "  none"
  [[ -n "$GONE" ]] && { echo "gone-upstream (remote deleted; may hold unmerged work — ask before -D):"; echo "$GONE" | sed 's/^/  /'; }
fi

# --- status digest ---
STATUS=$(git status --porcelain=v2 --branch 2>/dev/null)
COUNTS=$(echo "$STATUS" | awk '
  $1=="1"{x=substr($2,1,1);y=substr($2,2,1); if(x!=".")s++; if(y!=".")m++; next}
  $1=="2"{s++; next}
  $1=="u"{um++; next}
  $1=="?"{n++; next}
  END{printf "%d staged, %d modified, %d unmerged, %d untracked", s+0, m+0, um+0, n+0}')
AB=$(echo "$STATUS" | sed -n 's/^# branch\.ab //p')
echo "changes: $COUNTS ${AB:+| vs upstream: $AB}"
echo "$STATUS" | grep -E '^[12u?]' || true

# --- possible secrets among changed paths (never commit these) ---
FLAGS=$(echo "$STATUS" | grep -E '^[12u?]' | awk '{print $NF}' |
  grep -iE '(^|/)\.env|\.env\.|\.pem$|\.p12$|\.key$|id_rsa|credential|secret|password|\.pfx$' | sort -u || true)
echo "secret-suspects: ${FLAGS:-none}"

# --- recent commits (style reference) ---
echo "recent-commits:"
git log --format='%h %s' -6 2>/dev/null || echo "  (no commits yet)"

# --- stash ---
STASHES=$(git stash list --format='%gd %gs' 2>/dev/null)
echo "stash: $(echo -n "$STASHES" | grep -c . )"
[[ -n "$STASHES" ]] && echo "$STASHES" | sed 's/^/  /'

exit 0