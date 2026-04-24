#!/bin/bash
# URL handler for notes://<vault-relative-path> links.
#
# Registered via ~/.local/share/applications/open-note.desktop
# with MimeType=x-scheme-handler/notes;
#
# Markdown files: remote-open into the running nvim instance started by
# open-daily-note.sh (listening on $NVIM_SOCKET). If that session isn't
# alive, cold-start via open-daily-note.sh.
#
# Non-markdown files: delegate to xdg-open.

set -euo pipefail

NOTES_DIR="$HOME/Notes"
NVIM_SOCKET="/tmp/nvim-daily.sock"
KITTY_SOCKET="unix:@kitty-dailynotes"

url="${1:-}"
if [ -z "$url" ]; then
    echo "usage: $0 notes://<vault-relative-path>" >&2
    exit 2
fi

path="${url#notes://}"
# Decode %NN escape sequences
path="$(printf '%b' "${path//%/\\x}")"

if [[ "$path" != /* ]]; then
    path="$NOTES_DIR/$path"
fi

if [ ! -e "$path" ]; then
    notify-send "Notes link" "File not found: $path" || true
    exit 1
fi

case "${path,,}" in
*.md)
    if nvim --server "$NVIM_SOCKET" --remote-expr '1' >/dev/null 2>&1; then
        nvim --server "$NVIM_SOCKET" --remote "$path"
        kitty @ --to "$KITTY_SOCKET" focus-window >/dev/null 2>&1 || true
    else
        exec "$HOME/bin/open-daily-note.sh" "$path"
    fi
    ;;
*)
    exec xdg-open "$path"
    ;;
esac
