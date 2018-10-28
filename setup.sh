#!/bin/bash

base_dir=$(dirname $(readlink -f $0))

cd  $base_dir

# The following only needed if you did not use --recurse-submodules used in
# clone. Initialize submodules
#   git submodule init
# 	git submodule update --recursive --remote

# You may need to do the following for python-mode and YouCompleteMe
#
# 	cd vim/bundle/python-mode
# 	git checkout develop
# 	git submodule update --init --recursive

# Create destinations for backups and undo files
mkdir -p ~/tmp/undo ~/tmp/backup

# Create symlinks:

ln -sf  $base_dir/direnvrc             ~/.direnvrc
ln -sf  $base_dir/style.yapf           ~/.style.yapf
ln -sf  $base_dir/bash/bashrc          ~/.bashrc
ln -sf  $base_dir/bash/profile         ~/.bash_profile
ln -sf  $base_dir/ctags                ~/.ctags
ln -sf  $base_dir/dircolors.ansi-light ~/.dircolors
ln -sf  $base_dir/gitconfig            ~/.gitconfig
ln -sf  $base_dir/gitignore            ~/.gitignore
ln -sf  $base_dir/inputrc              ~/.inputrc
ln -sf  $base_dir/jsbeautifyrc         ~/.jsbeautifyrc
ln -sf  $base_dir/perltidyrc           ~/.perltidyrc
ln -sf  $base_dir/proverc              ~/.proverc
ln -sf  $base_dir/vim/gvimrc           ~/.gvimrc
ln -sf  $base_dir/vim/vimrc            ~/.vimrc
ln -snf $base_dir/vim                  ~/.vim

if [[ `tmux -V | cut -f2 -d' '` > 2 ]]
then
	ln -sf  $base_dir/tmux2.conf            ~/.tmux.conf
else
	ln -sf  $base_dir/tmux.conf            ~/.tmux.conf
fi
