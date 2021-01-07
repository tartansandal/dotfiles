#!/bin/bash

gsettings set org.gnome.desktop.interface monospace-font-name 'DejaVu Sans Mono Book 13'
gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'
gsettings set org.gnome.desktop.interface document-font-name 'Sans 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 10'

if [[ $(xrandr -q | grep -c 'connected') -gt 1 ]]
then
    gsettings set org.gnome.desktop.interface text-scaling-factor 0.85
    message='Re-setting fonts for "connected monitor"'
else
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.0
    message='Re-setting fonts for "laptop only"'
fi

zenity --info --text "$message" --no-wrap 
