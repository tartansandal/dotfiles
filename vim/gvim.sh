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

# special case for the one in the middle
if xrandr -q | grep -q 'Screen 0: minimum 320 x 200, current 5760 x 2160'
then
	# study desktop
    /usr/bin/gvim -U ~/.vim/gvimrc-big $*
elif xrandr -q | grep -q 'Screen 0: minimum 320 x 200, current 7680 x 2160'
then
	# office virtualised desktop
    /usr/bin/gvim -U ~/.vim/gvimrc-big $*
else
	# laptop
    /usr/bin/gvim $*
fi
