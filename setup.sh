#!/bin/bash

base_dir=$(cd "$(dirname "$0")" && pwd -P)

cd "$base_dir" || exit

# Create destinations for backups and undo files
mkdir -p ~/tmp/undo ~/tmp/backup

# Create symlinks:

ln -sf "$base_dir"/bash/bashrc ~/.bashrc
ln -sf "$base_dir"/bash/profile ~/.bash_profile

ln -sf "$base_dir"/zsh/zshrc ~/.zshrc
ln -sf "$base_dir"/zsh/zprofile ~/.zprofile

ln -sf "$base_dir"/dircolors ~/.dircolors
ln -sf "$base_dir"/direnvrc ~/.direnvrc
ln -sf "$base_dir"/gitconfig ~/.gitconfig
ln -sf "$base_dir"/gitignore ~/.gitignore
ln -sf "$base_dir"/inputrc ~/.inputrc
ln -sf "$base_dir"/tmux.conf ~/.tmux.conf

ln -snf "$base_dir"/bin ~/bin
mkdir -p ~/.config
rm -rf ~/.config/nvim ~/.config/kitty
ln -sf "$base_dir"/shell/starship.toml ~/.config/starship.toml
ln -snf "$base_dir"/nvim ~/.config/nvim
ln -snf "$base_dir"/kitty ~/.config/kitty

mkdir -p ~/.local/share/applications
for desktop_file in "$base_dir"/applications/*.desktop; do
    ln -sf "$desktop_file" ~/.local/share/applications/"$(basename "$desktop_file")"
done
