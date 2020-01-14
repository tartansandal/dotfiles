#!/bin/bash

gsettings set org.gnome.desktop.interface monospace-font-name 'DejaVu Sans Mono Book 13'
gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
gsettings set org.gnome.desktop.interface document-font-name 'Sans 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11'

if xrandr -q | grep -q 'connected 3840x2160'
then
    gsettings set org.gnome.desktop.interface text-scaling-factor 0.75
    message='Re-setting fonts for\n"connected monitor"'
else
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
    message='Re-setting fonts for\n"laptop only"'
fi

zenity --info --text "$message" --no-wrap --height 100
