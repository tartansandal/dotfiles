#!/bin/bash
#
# statusline-command.sh - Git-aware statusline generator for Claude Code and Bash
# Version: 1.1.0
#
# INTENTIONAL: No strict mode (set -euo pipefail) for this statusline script
# Reasoning:
#   - Designed for graceful degradation, not fail-fast behavior
#   - Git failures should return empty string, not crash the user's prompt
#   - All variables use safe expansion patterns: ${VAR:-default}
#   - Explicit error handling is more appropriate for user-facing UI scripts

# Bash version check: Requires 3.0+ for here-strings (<<<)
# EPOCHREALTIME timing feature requires 5.0+ but has fallback to date command
if ((BASH_VERSINFO[0] < 3)); then
    echo "Error: Bash 3.0 or newer required (found: $BASH_VERSION)" >&2
    exit 1
fi

readonly SCRIPT_VERSION="1.1.0"

# Handle --version and --help flags (must be done before reading stdin)
if [[ "${1:-}" == "--version" ]] || [[ "${1:-}" == "-v" ]]; then
    echo "statusline-command.sh version $SCRIPT_VERSION"
    exit 0
fi

if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
    cat << 'EOF'
statusline-command.sh - Git-aware statusline generator

USAGE:
    # Explicit directory path (bash prompt mode - no jq needed)
    statusline-command.sh /path/to/directory
    statusline-command.sh "$PWD"

    # JSON input via stdin (Claude Code mode - requires jq)
    echo '{"workspace":{"current_dir":"/path"}}' | statusline-command.sh

    # Auto-detect: Uses $PWD if no arguments and stdin is a terminal
    statusline-command.sh

MODES:
    1. Directory argument mode: Pass directory path as first argument
       - Fastest mode, no JSON parsing overhead
       - Perfect for bash PS1/PROMPT_COMMAND
       - Does not require jq

    2. JSON mode: Pipe JSON to stdin (for Claude Code integration)
       - Expects: {"workspace":{"current_dir":"/path"}}
       - Requires jq for parsing

    3. Auto-detect mode: No args, will use $PWD if stdin is terminal
       - Convenient for interactive testing

ENVIRONMENT VARIABLES:
    STATUSLINE_GIT_TIMEOUT    Timeout for git commands in seconds (default: 2, max: 10)
    STATUSLINE_DEBUG          Enable debug output (1=on, 0=off, default: 0)
    STATUSLINE_USE_ASCII      Use ASCII symbols instead of Unicode (1=on, 0=off, default: 0)
    NO_COLOR                  Disable color output (set to any value)

EXAMPLES:
    # Bash prompt usage (recommended)
    PS1="\$(statusline-command.sh \"\$PWD\")\n\$ "

    # Claude Code usage
    echo '{"workspace":{"current_dir":"'$PWD'"}}' | statusline-command.sh

    # With debug mode
    STATUSLINE_DEBUG=1 statusline-command.sh "$PWD"

    # Increase timeout for slow filesystems
    STATUSLINE_GIT_TIMEOUT=5 statusline-command.sh "$PWD"

OUTPUT:
    Formatted statusline with current directory and git information (if in git repo)
    Format: "in <directory> on <branch><status> [operation]"

    Git Status Symbols:
        (clean)      - No symbol, repository is clean and synced
        *            - Uncommitted changes
        △ (or ^)     - Unpushed commits
        ▲ (or *^)    - Uncommitted changes + unpushed commits
        ▽ (or v)     - Unpulled commits
        ▼ (or *v)    - Uncommitted changes + unpulled commits
        ⬡ (or <>)    - Both unpushed and unpulled commits
        ⬢ (or *<>)   - Uncommitted changes + unpushed + unpulled commits
EOF
    exit 0
fi

# Check for required dependencies
# Note: Requires git 2.11+ for --porcelain=v2 (Nov 2016)
#       and git 2.16+ for core.useBuiltinFSMonitor (Jan 2018)
# Note: jq is only required for JSON input mode (Claude Code)
for cmd in git timeout stat realpath; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: Required command '$cmd' not found" >&2
        exit 1
    fi
done

# Constants
readonly DEFAULT_GIT_TIMEOUT=2              # Default timeout for git commands in seconds
readonly MAX_GIT_TIMEOUT=10                 # Maximum allowed timeout (for slow/network filesystems)
readonly GIT_SHORT_SHA_LENGTH=7             # Short SHA length (git default is 7)
readonly TIMEOUT_EXIT_CODE=124              # Exit code returned by timeout command
readonly NS_TO_MS_DIVISOR=1000000           # Nanoseconds to milliseconds conversion

# Configuration: Git command timeout in seconds (default: 2)
# Can be overridden via STATUSLINE_GIT_TIMEOUT environment variable
# Lower values provide faster UI response but may timeout on slow/network filesystems
# Example: export STATUSLINE_GIT_TIMEOUT=5  # for slower/network filesystems
GIT_TIMEOUT="${STATUSLINE_GIT_TIMEOUT:-$DEFAULT_GIT_TIMEOUT}"

# Validate timeout is a positive integer within reasonable bounds
# Invalid values (non-numeric, zero, negative, too large) fall back to default
if ! [[ "$GIT_TIMEOUT" =~ ^[0-9]+$ ]] || [[ "$GIT_TIMEOUT" -eq 0 ]] || [[ "$GIT_TIMEOUT" -gt "$MAX_GIT_TIMEOUT" ]]; then
    echo "Warning: Invalid STATUSLINE_GIT_TIMEOUT='$GIT_TIMEOUT' (must be 1-$MAX_GIT_TIMEOUT), using default $DEFAULT_GIT_TIMEOUT seconds" >&2
    GIT_TIMEOUT=$DEFAULT_GIT_TIMEOUT
fi
readonly GIT_TIMEOUT

# Debug mode: Set STATUSLINE_DEBUG=1 to enable diagnostic output to stderr
# Useful for troubleshooting git status parsing, timeouts, or state calculation
DEBUG_MODE="${STATUSLINE_DEBUG:-0}"

# =============================================================================
# FUNCTION RETURN VALUE CONVENTIONS
# =============================================================================
#
# This script uses two different patterns for returning values from functions:
#
# 1. STDOUT RETURN (capture with command substitution):
#    - get_git_branch()      - Returns branch name or SHA
#    - get_git_status()      - Returns status symbol
#    - get_git_progress()    - Returns operation string like " [merge]"
#    - get_git_info()        - Returns formatted branch + status
#    - parse_git_ahead()     - Returns "1" or "0"
#    - parse_git_behind()    - Returns "1" or "0"
#    - parse_git_dirty()     - Returns "1" or "0"
#    Usage: result=$(function_name)
#
# 2. EXIT CODE RETURN (check with if/&&/||):
#    - is_on_git()           - Returns 0 (true) if in git repo, 1 (false) otherwise
#    - cache_git_status()    - Returns 0 on success, 1 on git failure
#    - _git()                - Returns git command exit code (timeout normalized to 1)
#    Usage: if function_name; then ...
#
# 3. SIDE EFFECTS ONLY (no return value):
#    - debug_log()           - Logs to stderr in debug mode
#    - log_git_timing()      - Logs timing to stderr in debug mode
#
# IMPORTANT: Functions using STDOUT should NOT write anything else to stdout
#            Functions using EXIT CODE may write to stderr for errors/warnings
# =============================================================================

# Debug logging function - outputs to stderr only when DEBUG_MODE=1
# Usage: debug_log "message"
debug_log() {
    [[ "$DEBUG_MODE" == "1" ]] && echo "[DEBUG] $*" >&2
}

# Log git command timing and exit code (debug mode only)
# Args: $1=start_time (EPOCHREALTIME or nanoseconds), $2=exit_code
# Returns: void (logs to stderr via debug_log)
log_git_timing() {
    local start_time="$1"
    local exit_code="$2"
    local end_time duration_ms

    [[ "$DEBUG_MODE" != "1" || -z "$start_time" ]] && return

    if [[ -n "${EPOCHREALTIME}" ]]; then
        # Bash 5.0+: Calculate duration using builtin (microsecond precision)
        end_time="$EPOCHREALTIME"
        # Pure bash arithmetic: convert EPOCHREALTIME (seconds.microseconds) to milliseconds
        # Split into seconds and microseconds parts using parameter expansion
        local start_sec="${start_time%.*}" start_usec="${start_time#*.}"
        local end_sec="${end_time%.*}" end_usec="${end_time#*.}"
        # Calculate milliseconds: (delta_seconds * 1000) + (delta_microseconds / 1000)
        # Use 10# prefix to force base-10 interpretation and prevent octal interpretation of leading zeros
        duration_ms=$(( (10#$end_sec - 10#$start_sec) * 1000 + (10#$end_usec - 10#$start_usec) / 1000 ))
        debug_log "Git command completed in ${duration_ms}ms with exit code: $exit_code"
    else
        # Fallback: date command (nanosecond precision)
        end_time=$(date +%s%N 2>/dev/null) || end_time=""
        if [[ -n "$end_time" ]]; then
            duration_ms=$(( (end_time - start_time) / NS_TO_MS_DIVISOR ))
            debug_log "Git command completed in ${duration_ms}ms with exit code: $exit_code"
        else
            debug_log "Git command exit code: $exit_code (timing unavailable)"
        fi
    fi
}

# Colors from sexy-bash-prompt (using ANSI codes that will be dimmed in status line)
# Respects NO_COLOR environment variable (https://no-color.org/)
# When NO_COLOR is set (to any value), colors are disabled
# IMPORTANT: Must use ANSI-C quoting ($'...') not regular quotes ("...")
# Regular quotes would create literal backslash characters, not escape sequences
if [[ -z "${NO_COLOR:-}" ]]; then
    readonly PREPOSITION_COLOR=$'\033[0;36m'  # cyan
    readonly DIR_COLOR=$'\033[0;33m'          # yellow
    readonly GIT_STATUS_COLOR=$'\033[0;34m'   # blue
    readonly GIT_PROGRESS_COLOR=$'\033[0;35m' # magenta
    readonly RESET=$'\033[m'
else
    # NO_COLOR is set - disable all colors
    readonly PREPOSITION_COLOR=""
    readonly DIR_COLOR=""
    readonly GIT_STATUS_COLOR=""
    readonly GIT_PROGRESS_COLOR=""
    readonly RESET=""
fi

# Git symbols - Unicode or ASCII based on environment
# Set STATUSLINE_USE_ASCII=1 to use ASCII symbols for non-UTF-8 terminals
if [[ "${STATUSLINE_USE_ASCII:-0}" == "1" ]]; then
    # ASCII-only symbols for maximum compatibility
    readonly SYNCED_SYMBOL=""
    readonly DIRTY_SYNCED_SYMBOL="*"
    readonly UNPUSHED_SYMBOL="^"           # Up arrow alternative
    readonly DIRTY_UNPUSHED_SYMBOL="*^"
    readonly UNPULLED_SYMBOL="v"           # Down arrow alternative
    readonly DIRTY_UNPULLED_SYMBOL="*v"
    readonly UNPUSHED_UNPULLED_SYMBOL="<>"  # Diverged indicator
    readonly DIRTY_UNPUSHED_UNPULLED_SYMBOL="*<>"
else
    # Unicode symbols for modern terminals
    readonly SYNCED_SYMBOL=""
    readonly DIRTY_SYNCED_SYMBOL="*"
    readonly UNPUSHED_SYMBOL="△"
    readonly DIRTY_UNPUSHED_SYMBOL="▲"
    readonly UNPULLED_SYMBOL="▽"
    readonly DIRTY_UNPULLED_SYMBOL="▼"
    readonly UNPUSHED_UNPULLED_SYMBOL="⬡"
    readonly DIRTY_UNPUSHED_UNPULLED_SYMBOL="⬢"
fi

# =============================================================================
# GIT HELPER FUNCTIONS
# =============================================================================

# Wrapper function for git commands to disable FSMonitor consistently
# Includes timeout protection to prevent hanging on slow/network filesystems
# Returns: Exit code from git command (124 timeout is normalized to 1)
_git() {
    local start_time=""
    local exit_code

    # Capture start time for timing in debug mode
    # Prefer bash 5.0+ builtin EPOCHREALTIME (microsecond precision) over external date command
    if [[ "$DEBUG_MODE" == "1" ]]; then
        debug_log "Running: git $*"
        if [[ -n "${EPOCHREALTIME}" ]]; then
            # Bash 5.0+: Use builtin EPOCHREALTIME (format: seconds.microseconds)
            start_time="$EPOCHREALTIME"
        else
            # Fallback to external date command for bash < 5.0
            start_time=$(date +%s%N 2>/dev/null) || start_time=""
        fi
    fi

    timeout "$GIT_TIMEOUT" git -c core.useBuiltinFSMonitor=false "$@"
    exit_code=$?

    # Log timing information in debug mode
    log_git_timing "$start_time" "$exit_code"

    # Normalize timeout exit code to standard failure (1)
    # This prevents callers from needing to handle timeout specially
    if [[ $exit_code -eq $TIMEOUT_EXIT_CODE ]]; then
        debug_log "Git command timed out after ${GIT_TIMEOUT}s: git $*"
        return 1
    fi

    return $exit_code
}

# Returns the current git branch name or short SHA for detached HEAD
# Output: Branch name, short SHA, or "(no branch)" via stdout
# Usage: branch=$(get_git_branch)
get_git_branch() {
    local branch

    # Get branch name from cache or direct git call
    if [[ -n "$GIT_BRANCH_CACHE" ]]; then
        branch="$GIT_BRANCH_CACHE"
    else
        # Fallback to direct git call (strip refs/heads/ prefix using parameter expansion)
        local ref
        ref="$(_git symbolic-ref HEAD 2>/dev/null)" || branch=""
        branch="${ref#refs/heads/}"
    fi

    # Handle detached HEAD state (cache returns "(detached)" or direct call returns empty)
    if [[ -z "$branch" || "$branch" == "(detached)" ]]; then
        # Use cached SHA if available, otherwise fall back to git call
        if [[ -n "$GIT_SHA_CACHE" ]]; then
            echo "$GIT_SHA_CACHE"
        else
            local sha
            sha="$(_git rev-parse --short HEAD 2>/dev/null)" || sha=""
            # Use parameter expansion fallback for edge cases:
            # - Empty repository (no commits yet)
            # - Corrupted repository
            # - git rev-parse timeout or failure
            # If sha is empty, display "(no branch)" instead of blank
            echo "${sha:-(no branch)}"
        fi
    else
        echo "$branch"
    fi
}

# Returns the current git operation in progress (merge, rebase, etc.)
# Output: Operation name like " [merge]", " [rebase]", or empty string via stdout
# Usage: progress=$(get_git_progress)
# Note: Requires cache_git_status() to be called first to populate GIT_DIR_CACHE
get_git_progress() {
    local git_dir="$GIT_DIR_CACHE"
    [[ -z "$git_dir" ]] && return

    # Verify git directory exists and is actually a directory before accessing
    # This adds defense-in-depth even though git rev-parse should return valid paths
    if [[ ! -d "$git_dir" ]]; then
        debug_log "git_dir is not a directory: $git_dir"
        return
    fi

    # Verify git directory is accessible with timeout protection (prevents hanging on network filesystems)
    # Using stat instead of shell built-ins because only external commands can be wrapped with timeout
    if ! timeout "$GIT_TIMEOUT" stat "$git_dir" >/dev/null 2>&1; then
        return  # Directory not accessible or timeout - skip progress check
    fi

    # Check for various git operations by examining git directory state
    if [[ -f "$git_dir/MERGE_HEAD" ]]; then
        echo " [merge]"
    elif [[ -d "$git_dir/rebase-apply" ]]; then
        if [[ -f "$git_dir/rebase-apply/applying" ]]; then
            echo " [am]"
        else
            echo " [rebase]"
        fi
    elif [[ -d "$git_dir/rebase-merge" ]]; then
        echo " [rebase]"
    elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
        echo " [cherry-pick]"
    elif [[ -f "$git_dir/BISECT_LOG" ]]; then
        echo " [bisect]"
    elif [[ -f "$git_dir/REVERT_HEAD" ]]; then
        echo " [revert]"
    fi
}

# =============================================================================
# GIT STATUS CACHE
# =============================================================================

# Cache for git status info
# All cache variables populated by cache_git_status() to avoid multiple git calls
GIT_BRANCH_CACHE=""
GIT_SHA_CACHE=""  # Populated from branch.oid to avoid extra git rev-parse in detached HEAD
GIT_AHEAD_CACHE=""
GIT_BEHIND_CACHE=""
GIT_DIRTY_CACHE=""
GIT_DIR_CACHE=""  # Git directory path, populated to avoid extra git rev-parse in get_git_progress

# Populate git status cache using porcelain v2 format
# Side effects: Populates GIT_BRANCH_CACHE, GIT_SHA_CACHE, GIT_AHEAD_CACHE, GIT_BEHIND_CACHE, GIT_DIRTY_CACHE, GIT_DIR_CACHE
# Returns: Exit code 0 on success, 1 if git status fails (timeout, permissions, corrupted repo, etc.)
# Usage: if cache_git_status; then ... (call before using parse_* or get_git_* functions)
# Porcelain v2 format reference:
# - Lines starting with '# branch.head' contain the branch name
# - Lines starting with '# branch.oid' contain the commit SHA
# - Lines starting with '# branch.ab' contain +ahead -behind counts
# - Lines starting with '1', '2', or '?' indicate changes (modified, renamed, untracked)
cache_git_status() {
    # Reset all cache variables to ensure clean state
    GIT_BRANCH_CACHE=""
    GIT_SHA_CACHE=""
    GIT_AHEAD_CACHE=""
    GIT_BEHIND_CACHE=""
    GIT_DIRTY_CACHE="0"
    GIT_DIR_CACHE=""

    # Populate git directory cache first (needed for get_git_progress)
    # Do this before git status to avoid extra git call if status fails
    GIT_DIR_CACHE="$(_git rev-parse --git-dir 2>/dev/null)" || GIT_DIR_CACHE=""

    local git_status
    # Explicitly check if git status succeeds (could fail due to timeout, permissions, etc.)
    if ! git_status="$(_git status --porcelain=v2 --branch 2>/dev/null)"; then
        debug_log "cache_git_status: git status command failed"
        # Clear GIT_DIR_CACHE to prevent get_git_progress() from using stale data
        GIT_DIR_CACHE=""
        return 1  # Signal failure to caller
    fi

    # Parse status in a single pass to avoid multiple subprocesses
    # Using here-string (bash 3.0+) for efficiency - avoids subprocess overhead
    while IFS= read -r line; do
        # Extract branch name (format: # branch.head <branch>)
        if [[ "$line" =~ ^#\ branch\.head\ (.+)$ ]]; then
            GIT_BRANCH_CACHE="${BASH_REMATCH[1]}"
        # Extract commit SHA (format: # branch.oid <sha>)
        # Accept both uppercase and lowercase hex digits for maximum compatibility
        elif [[ "$line" =~ ^#\ branch\.oid\ ([0-9a-fA-F]+)$ ]]; then
            # Store short SHA (truncate to GIT_SHORT_SHA_LENGTH characters)
            GIT_SHA_CACHE="${BASH_REMATCH[1]:0:$GIT_SHORT_SHA_LENGTH}"
        # Extract ahead/behind counts (format: # branch.ab +<ahead> -<behind>)
        elif [[ "$line" =~ ^#\ branch\.ab\ \+([0-9]+)\ -([0-9]+)$ ]]; then
            GIT_AHEAD_CACHE="${BASH_REMATCH[1]}"
            GIT_BEHIND_CACHE="${BASH_REMATCH[2]}"
        # Check for any changes (modified, renamed, or untracked files)
        elif [[ "$line" =~ ^[12?] ]]; then
            GIT_DIRTY_CACHE="1"
        fi
    done <<< "$git_status"

    debug_log "Cache populated: branch='$GIT_BRANCH_CACHE' sha='$GIT_SHA_CACHE' ahead='$GIT_AHEAD_CACHE' behind='$GIT_BEHIND_CACHE' dirty='$GIT_DIRTY_CACHE' git_dir='$GIT_DIR_CACHE'"
    return 0
}

# =============================================================================
# GIT STATUS PARSERS AND FORMATTERS
# =============================================================================

# Returns "1" if there are unpushed commits, "0" otherwise
# Output: "1" or "0" via stdout (NEVER empty string - required for state_key concatenation)
# Usage: ahead=$(parse_git_ahead)
parse_git_ahead() {
    if [[ -n "$GIT_AHEAD_CACHE" && "$GIT_AHEAD_CACHE" != "0" ]]; then
        echo 1
    else
        echo 0
    fi
}

# Returns "1" if there are unpulled commits, "0" otherwise
# Output: "1" or "0" via stdout (NEVER empty string - required for state_key concatenation)
# Usage: behind=$(parse_git_behind)
parse_git_behind() {
    if [[ -n "$GIT_BEHIND_CACHE" && "$GIT_BEHIND_CACHE" != "0" ]]; then
        echo 1
    else
        echo 0
    fi
}

# Returns "1" if there are uncommitted changes, "0" otherwise
# Output: "1" or "0" via stdout (NEVER empty string - required for state_key concatenation)
# Usage: dirty=$(parse_git_dirty)
parse_git_dirty() {
    if [[ "$GIT_DIRTY_CACHE" == "1" ]]; then
        echo 1
    else
        echo 0
    fi
}

# Returns true if current directory is inside a git repository
# Returns: Exit code 0 (true) if in git repo, 1 (false) otherwise
# Usage: if is_on_git; then ...
is_on_git() {
    _git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# Returns the appropriate git status symbol based on dirty/ahead/behind state
# Output: Unicode symbol (△, ▽, ⬡, *, etc.) via stdout
# Usage: symbol=$(get_git_status)
get_git_status() {
    # Build state key from three boolean flags (each MUST be "1" or "0", never empty)
    # Pattern: <dirty><ahead><behind> (e.g., "110" = dirty + ahead, no behind)
    # CRITICAL: parse_* functions must return "0" or "1" to ensure exactly 3-digit keys
    # Empty strings would create wrong keys: ""+"1"+"" = "1" instead of "010"
    #
    # Optimization: Direct concatenation avoids intermediate variables and subshell overhead
    # This is more efficient than: dirty=$(parse_git_dirty); ahead=$(parse_git_ahead); etc.
    #
    # State key truth table (concatenated flags: dirty+ahead+behind):
    # dirty ahead behind → symbol
    #   0     0     0   → "" (synced, clean)
    #   1     0     0   → "*" (dirty, synced)
    #   0     1     0   → "△" (unpushed, clean)
    #   1     1     0   → "▲" (dirty, unpushed)
    #   0     0     1   → "▽" (unpulled, clean)
    #   1     0     1   → "▼" (dirty, unpulled)
    #   0     1     1   → "⬡" (unpushed + unpulled, clean)
    #   1     1     1   → "⬢" (dirty, unpushed + unpulled)
    local state_key
    state_key="$(parse_git_dirty)$(parse_git_ahead)$(parse_git_behind)"

    if [[ "$DEBUG_MODE" == "1" ]]; then
        # Extract components for debug logging (only when needed)
        local dirty="${state_key:0:1}" ahead="${state_key:1:1}" behind="${state_key:2:1}"
        debug_log "State calculation: dirty=$dirty ahead=$ahead behind=$behind → state_key='$state_key'"
    fi

    local symbol
    case "$state_key" in
        111) symbol="$DIRTY_UNPUSHED_UNPULLED_SYMBOL" ;;  # dirty + unpushed + unpulled
        011) symbol="$UNPUSHED_UNPULLED_SYMBOL" ;;        # unpushed + unpulled (diverged)
        110) symbol="$DIRTY_UNPUSHED_SYMBOL" ;;           # dirty + unpushed
        010) symbol="$UNPUSHED_SYMBOL" ;;                 # unpushed only
        101) symbol="$DIRTY_UNPULLED_SYMBOL" ;;           # dirty + unpulled
        001) symbol="$UNPULLED_SYMBOL" ;;                 # unpulled only
        100) symbol="$DIRTY_SYNCED_SYMBOL" ;;             # dirty only (uncommitted changes)
        *)   symbol="$SYNCED_SYMBOL" ;;                   # 000 or any unexpected state (clean)
    esac

    debug_log "Selected symbol: '$symbol'"
    echo "$symbol"
}

# Returns formatted git branch name with status symbol
# Side effects: Calls cache_git_status() to populate cache variables
# Output: Branch name + status symbol (e.g., "main△", "develop*") via stdout
#         Returns empty string on git failure (timeout, permissions, corrupted repo)
# Failure behavior: Silent/graceful degradation - status line simply omits git info
#                   This prevents error messages in the prompt when git is unavailable
# Usage: info=$(get_git_info)
get_git_info() {
    # Populate cache first - if git fails (timeout, permissions, etc.), return nothing
    if ! cache_git_status; then
        # Gracefully degrade: return empty string instead of showing error in status line
        # This is intentional - users prefer a clean prompt over error messages
        return 0
    fi

    local branch
    branch="$(get_git_branch)"

    if [[ -n "$branch" ]]; then
        echo "${branch}$(get_git_status)"
    fi
}

# =============================================================================
# MAIN ENTRY POINT
# =============================================================================

# Main execution function
main() {
    local cwd

    # MODE 1: Explicit directory path provided as argument
    # Usage: statusline-command.sh /path/to/dir
    # Usage: statusline-command.sh "$PWD"
    if [[ -n "${1:-}" && "$1" != "--"* ]]; then
        cwd="$1"
        debug_log "Mode: Explicit directory argument"

    # MODE 2: JSON input via stdin (Claude Code mode)
    # Usage: echo '{"workspace":{"current_dir":"/path"}}' | statusline-command.sh
    elif [[ ! -t 0 ]]; then
        # Check if jq is available for JSON parsing
        if ! command -v jq &>/dev/null; then
            echo "Error: 'jq' is required for JSON input mode" >&2
            echo "Install jq or use: $0 /path/to/directory" >&2
            exit 1
        fi

        debug_log "Mode: JSON input via stdin"

        # Extract current directory from JSON input
        if ! cwd=$(jq -r '.workspace.current_dir' 2>/dev/null); then
            echo "Error: Failed to parse JSON input" >&2
            exit 1
        fi

        # Normalize jq's null output to empty string
        # jq -r returns literal "null" string when field is null/missing, not empty string
        [[ "$cwd" == "null" ]] && cwd=""

        if [[ -z "$cwd" ]]; then
            echo "Error: No working directory provided in JSON" >&2
            exit 1
        fi

    # MODE 3: Auto-detect mode - use $PWD
    # Usage: statusline-command.sh (when stdin is a terminal)
    else
        cwd="$PWD"
        debug_log "Mode: Auto-detect using \$PWD"
    fi

    # Validate the working directory (common for all modes)

    if [[ ! -d "$cwd" ]]; then
        echo "Error: Directory does not exist: $cwd" >&2
        exit 1
    fi

    # Canonicalize path for security validation (resolves symlinks, prevents traversal)
    # We validate but still cd to the user-provided path to preserve symlink context
    if ! realpath -e "$cwd" >/dev/null 2>&1; then
        echo "Error: Cannot resolve directory path: $cwd" >&2
        exit 1
    fi

    # Change to the working directory
    # Use -- to ensure $cwd is treated as path, not an option
    if ! cd -- "$cwd" 2>/dev/null; then
        echo "Error: Cannot access directory: $cwd" >&2
        exit 1
    fi

    # Verify we successfully changed to a valid directory
    # This catches edge cases like the directory being deleted between checks
    # or permission changes that allow cd but not access
    if ! pwd >/dev/null 2>&1; then
        echo "Error: Current directory is not accessible after cd" >&2
        exit 1
    fi

    # Abbreviate home directory with ~ for display (mimics bash \w behavior)
    # Use parameter expansion for safe string replacement
    local display_path="$cwd"
    if [[ -n "$HOME" && "$cwd" == "$HOME" ]]; then
        # Exact match: /home/user → ~
        display_path="~"
    elif [[ -n "$HOME" && "$cwd" == "$HOME/"* ]]; then
        # Prefix match: /home/user/foo → ~/foo
        display_path="~${cwd#$HOME}"
    fi

    # Build the prompt (similar to PS1 but without trailing $ symbol)
    local fmt="${RESET}${PREPOSITION_COLOR}in ${RESET}${DIR_COLOR}%s${RESET}"
    # shellcheck disable=SC2059  # Format string is constructed from trusted constants
    # SECURITY: User data ($display_path) is passed as printf ARGUMENT, not part of format string
    # Printf does NOT interpret format specifiers in arguments, only in the format string
    # This is safe even if $display_path contains % characters
    printf "$fmt" "$display_path"

    # Add git info if in a git repo
    if is_on_git; then
        local git_info git_progress
        git_info=$(get_git_info)
        git_progress=$(get_git_progress)
        fmt=" ${PREPOSITION_COLOR}on${RESET} ${GIT_STATUS_COLOR}%s${GIT_PROGRESS_COLOR}%s${RESET}"
        # shellcheck disable=SC2059  # Format string is constructed from trusted constants
        printf "$fmt" "$git_info" "$git_progress"
    fi

    printf '%s' "${RESET}"
}

# Run main function with all arguments
main "$@"
