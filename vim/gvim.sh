#!/bin/bash

set -e

if [[ -e /usr/bin/gvim ]]
then
	GVIM=/usr/bin/gvim
elif [[ -e /usr/local/bin/mvim ]]
then
	GVIM=/usr/local/bin/mvim
else
	echo Could not find a graphical Vim
	exit 1
fi

if xrandr -q | grep -q 'connected 3840x2160'
then
	# connected monitor
    /usr/bin/gvim -U ~/.vim/gvimrc-big "$@"
else
	# laptop only
    /usr/bin/gvim "$@"
fi
