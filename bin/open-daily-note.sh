#!/bin/bash
# Open today's daily note in Neovim using Obsidian plugin
#
# IMPORTANT: This script is designed to be launched via the .desktop file
# (gtk-launch open-daily-note.desktop or GNOME launcher).
# GNOME will raise existing window based on StartupWMClass=DailyNotes.
#
# Running this script directly from command line will create duplicate windows
# because it bypasses GNOME's window management.

exec kitty --class DailyNotes --title "Daily Notes" \
    --listen-on unix:/tmp/kitty-dailynotes \
    --directory ~/Notes nvim -c "edit ~/Notes/.obsidian-trigger.md" -c "Obsidian today"
