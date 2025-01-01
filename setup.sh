#!/bin/bash

base_dir=$(dirname "$(readlink -f $0)")

cd "$base_dir" || exit

# Create destinations for backups and undo files
mkdir -p ~/tmp/undo ~/tmp/backup

# Create symlinks:

ln -sf "$base_dir"/bash/bashrc ~/.bashrc
ln -sf "$base_dir"/bash/profile ~/.bash_profile
ln -sf "$base_dir"/ctags ~/.ctags
ln -sf "$base_dir"/condarc ~/.condarc
ln -sf "$base_dir"/dircolors ~/.dircolors
ln -sf "$base_dir"/direnvrc ~/.direnvrc
ln -sf "$base_dir"/eslintrc ~/.eslintrc
ln -sf "$base_dir"/gitconfig ~/.gitconfig
ln -sf "$base_dir"/gitignore ~/.gitignore
ln -sf "$base_dir"/inputrc ~/.inputrc
ln -sf "$base_dir"/jsbeautifyrc ~/.jsbeautifyrc
ln -sf "$base_dir"/perltidyrc ~/.perltidyrc
ln -sf "$base_dir"/proverc ~/.proverc
ln -sf "$base_dir"/remarkrc.yml ~/.remarkrc.yml
ln -sf "$base_dir"/gitalias ~/.gitalias
ln -sf "$base_dir"/tmux.conf ~/.tmux.conf

ln -snf "$base_dir"/vim ~/.vim
ln -snf "$base_dir"/nvim ~/.config/nvim
ln -sf "$base_dir"/vim/vimrc ~/.vimrc
