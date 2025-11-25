#!/bin/bash

timer="pomodoro-sync.timer"

_zenity() { zenity --title 'Toggle pomodoro sync' --no-wrap "$@"; }

message() { _zenity --info --text="$1"; }

question() { _zenity --question --text="$1"; }

manager() { systemctl --user --quiet $1 $timer; }

trigger() { manager status | grep 'Trigger:' | cut -d\; -f 2; }

if manager is-enabled; then
    if manager is-active; then
        trigger=$(trigger)
        if question "Pomodoro sync is running with $trigger. \n\nStop timer?"; then
            manager stop
        fi
    else
        if question "Pomodoro sync is not running.\n\nStart Timer?"; then
            manager start
        fi
    fi
else
    message "$timer is not enabled"
fi
