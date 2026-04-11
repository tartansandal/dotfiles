#!/usr/bin/env bash
# git-code-archaeology.sh — Run before reading any new codebase
# Source: https://piechowski.io/post/git-commands-before-reading-code/
#
# Usage: ./scripts/git-code-archaeology.sh [path-to-repo]

set -uo pipefail
export GIT_PAGER=cat

if [[ "${1:-}" ]]; then
    cd "$1" || exit 1
fi

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: not a git repository" >&2
    exit 1
fi

if git rev-parse --is-shallow-repository 2>/dev/null | grep -q true; then
    echo "Warning: shallow clone — history may be incomplete" >&2
fi

repo=$(basename "$(git rev-parse --show-toplevel)")
echo "=== Code Archaeology: $repo ==="
echo

# ---------------------------------------------------------------------------
# 1. What changes the most?
# ---------------------------------------------------------------------------
# High-churn files often indicate problematic code — patches accumulate,
# estimates get padded, and blast radius is unpredictable.

echo "--- 1. CHURN HOTSPOTS (most modified files, past year) ---"
echo
git log --format='' --name-only --since="1 year ago" \
    | sed '/^$/d' | sort | uniq -c | sort -nr | head -20
echo
echo

# ---------------------------------------------------------------------------
# 2. Who built this?
# ---------------------------------------------------------------------------
# Reveals bus factor risk. If one person represents 60%+ of commits,
# their departure creates a crisis. Also shows whether original builders
# still maintain the system or if it's changed hands.

echo "--- 2. TOP CONTRIBUTORS (all time) ---"
echo
git shortlog -sn --no-merges HEAD
echo

echo "--- 2b. RECENT CONTRIBUTORS (past 6 months) ---"
echo
git shortlog -sn --no-merges --since="6 months ago" HEAD
echo
echo

# ---------------------------------------------------------------------------
# 3. Where do bugs cluster?
# ---------------------------------------------------------------------------
# Cross-reference against churn hotspots to find the highest-risk code:
# files that keep breaking AND keep getting patched but never get properly
# fixed.

echo "--- 3. BUG HOTSPOTS (files in fix/bug commits, past year) ---"
echo
git log -i -P --grep='\b(fix|bug|broken)\b' --name-only --format='' --since="1 year ago" \
    | sed '/^$/d' | sort | uniq -c | sort -nr | head -20
echo
echo

# ---------------------------------------------------------------------------
# 4. Is this project accelerating or dying?
# ---------------------------------------------------------------------------
# Steady velocity = healthy. Declining curve = lost momentum.
# Spikes = batched releases rather than continuous shipping.

echo "--- 4. COMMIT VELOCITY (commits per month, all time) ---"
echo
git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c
echo
echo

# ---------------------------------------------------------------------------
# 5. How often is the team firefighting?
# ---------------------------------------------------------------------------
# Frequent reverts signal unreliable deploys, weak tests, or inadequate
# staging environments.

echo "--- 5. FIREFIGHTING (reverts/hotfixes/emergencies, past year) ---"
echo
git log --format='%ad %h %s' --date=short --since="1 year ago" \
    | grep -iP '\b(revert|hotfix|emergency|rollback)\b' || echo "(none found)"
echo
