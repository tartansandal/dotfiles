#!/usr/bin/env bash
#
# stay-awake — prevent this Linux machine from sleeping while you're away.
#
# Holds a systemd-logind inhibitor lock that blocks:
#   - idle           : automatic suspend after inactivity
#   - sleep          : explicit suspend/hibernate requests
#   - handle-lid-switch : suspend-on-lid-close
#
# The lock is held for as long as this script runs. Ctrl-C (or letting the
# duration elapse) releases it cleanly and normal power management resumes.
# Locking the screen does NOT release the lock — the session keeps running.
#
# Usage:
#   stay-awake          # stay awake indefinitely; Ctrl-C to stop
#   stay-awake 2h       # stay awake for 2 hours, then auto-release
#   stay-awake 30m      # 30 minutes
#   stay-awake 8h       # 8 hours, etc. (any sleep(1) duration syntax)
#
# Verify it's active from another terminal:
#   systemd-inhibit --list
#
set -euo pipefail

duration="${1:-infinity}"
echo "stay-awake: blocking idle/sleep/lid for ${duration}. Ctrl-C to release."

# exec replaces this shell with systemd-inhibit, so Ctrl-C goes straight to
# the inhibitor and the lock is released cleanly (no orphaned process).
exec systemd-inhibit \
    --what=idle:sleep:handle-lid-switch \
    --who="stay-awake" \
    --why="remote access" \
    --mode=block \
    sleep "$duration"
