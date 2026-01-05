#!/bin/bash
# Open today's daily note in Neovim using Obsidian plugin
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
# - Saves trigger buffer number, then wipes it after 2s delay to keep buffer list clean
# - The delay is needed because "Obsidian today" runs asynchronously

exec kitty --class DailyNotes \
    --listen-on unix:/tmp/kitty-dailynotes \
    --directory ~/Notes \
    bash -lc 'nvim ~/Notes/.obsidian-trigger.md -c "set title titlestring=Daily\\ Notes" -c "let g:trigger_buf=bufnr()" -c "Obsidian today" -c "lua vim.defer_fn(function() vim.cmd(\"silent! bwipeout \" .. vim.g.trigger_buf) end, 2000)"'
