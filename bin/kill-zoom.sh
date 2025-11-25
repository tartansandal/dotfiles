#!/bin/bash

message() {
    zenity --info --no-wrap --text="$1"
}

if pgrep -x zoom >/dev/null
then
    if pkill -x zoom >/dev/null
    then
        message '😸 Killed all running Zoom processes'
    else
        message '🤯 Could not kill all running Zoom processes'
    fi
else
    message '🤫 No Zoom processes to kill'
fi
