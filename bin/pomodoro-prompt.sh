#!/usr/bin/bash

set -e

# Launch daily notes or raise existing window
if [ -S /tmp/kitty-dailynotes ]; then
    # Raise existing window via kitty remote control
    kitty @ --to unix:/tmp/kitty-dailynotes focus-window
else
    gtk-launch open-daily-note.desktop &
fi

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

exit 0
