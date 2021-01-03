#!/bin/bash

dconf load /org/gnome/terminal/legacy/ <<EOF
[keybindings]
prev-tab='<Primary>Left'
move-tab-right='<Primary><Shift>Right'
next-tab='<Primary>Right'
move-tab-left='<Primary><Shift>Left'

[/]
menu-accelerator-enabled=false
schema-version=uint32 3
default-show-menubar=false

[profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
visible-name='DirtySea'
scrollbar-policy='never'
audible-bell=false
allow-bold=false
use-system-font=true
use-theme-colors=false
foreground-color='rgb(0,0,0)'
background-color='rgb(224,224,224)'
palette=[ 'rgb(0,0,0)', 'rgb(132,0,0)', 'rgb(0,115,0)', 'rgb(117,91,0)', 'rgb(0,0,132)', 'rgb(115,0,115)', 'rgb(0,101,101)', 'rgb(208,208,208)', 'rgb(34,34,34)', 'rgb(133,71,0)', 'rgb(68,68,68)', 'rgb(102,102,102)', 'rgb(94,99,171)', 'rgb(136,136,136)', 'rgb(132,0,0)', 'rgb(68,68,68)']
EOF

