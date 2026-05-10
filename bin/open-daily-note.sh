#!/bin/bash
# Open today's daily note (or an arbitrary file) in Neovim using Obsidian plugin
#
# Usage:
#   open-daily-note.sh            # open today's daily note
#   open-daily-note.sh <path>     # open a specific file
#
# IMPORTANT: This script is designed to be launched via the .desktop file
# (gtk-launch open-daily-note.desktop or GNOME launcher).
# GNOME will raise existing window based on StartupWMClass=DailyNotes.
#
# Running this script directly from command line will create duplicate windows
# because it bypasses GNOME's window management.
#
# Implementation notes:
# - Uses login shell (bash -lc) to ensure environment is properly set
# - Opens a trigger .md file as argument (not via -c edit) to ensure obsidian.nvim
#   lazy-loads correctly AND spell checking initializes properly
# - Saves trigger buffer number, then wipes it after delay to keep buffer list clean
# - The delay is needed because "Obsidian today" runs asynchronously
# - nvim listens on $NVIM_SOCKET so other tools (open-note.sh) can --remote into it

NOTES_DIR="$HOME/Notes/Personal"
TRIGGER_FILE="$NOTES_DIR/.obsidian-trigger.md"
KITTY_SOCKET="unix:@kitty-dailynotes"
NVIM_SOCKET="/tmp/nvim-daily.sock"
CLEANUP_DELAY_MS=5000

TARGET_FILE="${1:-}"

if [ -n "$TARGET_FILE" ]; then
    ESCAPED_TARGET=$(printf '%q' "$TARGET_FILE")
    NVIM_CMD="nvim --listen $NVIM_SOCKET $ESCAPED_TARGET"
    NVIM_CMD+=" -c 'set title titlestring=Daily\\ Notes'"
else
    NVIM_CMD="nvim --listen $NVIM_SOCKET $TRIGGER_FILE"
    NVIM_CMD+=" -c 'set title titlestring=Daily\\ Notes'"
    NVIM_CMD+=" -c 'let g:trigger_buf=bufnr()'"
    NVIM_CMD+=" -c 'Obsidian today'"
    NVIM_CMD+=" -c 'lua vim.defer_fn(function() vim.cmd(\"silent! bwipeout \" .. vim.g.trigger_buf) end, $CLEANUP_DELAY_MS)'"
fi

exec kitty --class DailyNotes \
    --listen-on "$KITTY_SOCKET" \
    --directory "$NOTES_DIR" \
    bash -lc "$NVIM_CMD"
