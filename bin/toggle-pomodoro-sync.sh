#!/usr/bin/env bash

case "$(uname -s)" in
    Linux)
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
        ;;

    Darwin)
        label="com.kal.pomodoro-prompt"
        plist="$HOME/Library/LaunchAgents/${label}.plist"

        ask() {
            osascript -e "button returned of (display dialog \"$1\" with title \"Toggle Pomodoro\" buttons {\"No\", \"Yes\"} default button \"Yes\")" 2>/dev/null
        }

        if [ ! -f "$plist" ]; then
            osascript -e 'display dialog "Pomodoro plist not installed." with title "Toggle Pomodoro" buttons {"OK"} default button "OK"'
            exit 1
        fi

        if launchctl list "$label" &>/dev/null; then
            if [ "$(ask "Pomodoro timer is running. Stop timer?")" = "Yes" ]; then
                launchctl unload "$plist"
            fi
        else
            if [ "$(ask "Pomodoro timer is not running. Start timer?")" = "Yes" ]; then
                launchctl load "$plist"
            fi
        fi
        ;;
esac
