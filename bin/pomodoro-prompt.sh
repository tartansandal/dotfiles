#!/usr/bin/env bash

set -e

PLATFORM="$(uname -s)"
KITTY_SOCKET_PATH="/tmp/kitty-dailynotes"

# On macOS, launchd fires every hour; guard for weekday work hours
if [[ "$PLATFORM" == "Darwin" ]]; then
    hour=$((10#$(date +%H)))
    dow=$(date +%u)
    if (( dow > 5 || hour < 9 || hour > 17 )); then
        exit 0
    fi
fi

# Launch daily notes or raise existing window
if [ -S "$KITTY_SOCKET_PATH" ]; then
    kitty @ --to "unix:$KITTY_SOCKET_PATH" focus-window
    [[ "$PLATFORM" == "Darwin" ]] && osascript -e 'tell application "kitty" to activate'
else
    case "$PLATFORM" in
        Linux)  systemd-run --user gtk-launch open-daily-note.desktop ;;
        Darwin) "$HOME/bin/open-daily-note.sh" & ;;
    esac
fi

# Show pomodoro break prompt
case "$PLATFORM" in
    Linux)
        # Using pango markup to format the text: https://docs.gtk.org/Pango/pango_markup.html
        zenity \
            --title "Pomodoro" \
            --no-wrap \
            --timeout=300 \
            --info \
            --text="""
<span color='red' font='20' weight='bold'>Pomodoros are mandatory!</span>

Open your <b>Daily Notes</b> to record:

    1. What you did during the last pomodoro
    2. What you want to do during the next pomodoro

Take 5 deep breaths and focus on your body:

... feel the rising sensation as you breath in ...
... feel the falling sensation as you breath out.

<a href='https://www.youtube.com/shorts/CLhpgblsFhs'>Breathing Ballon</a>.
"""
        ;;
    Darwin)
        osascript <<'APPLESCRIPT'
display dialog ¬
    "Pomodoros are mandatory!" & return & return & ¬
    "Open your Daily Notes to record:" & return & return & ¬
    "    1. What you did during the last pomodoro" & return & ¬
    "    2. What you want to do during the next pomodoro" & return & return & ¬
    "Take 5 deep breaths and focus on your body:" & return & return & ¬
    "... feel the rising sensation as you breath in ..." & return & ¬
    "... feel the falling sensation as you breath out." & return & return & ¬
    "Breathing Balloon: https://www.youtube.com/shorts/CLhpgblsFhs" ¬
    with title "Pomodoro" ¬
    buttons {"OK"} default button "OK" ¬
    giving up after 300
APPLESCRIPT
        ;;
esac

exit 0
