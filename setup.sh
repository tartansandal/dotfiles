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
# ln -snf won't replace a real directory, so remove first
rm -rf ~/.config/nvim ~/.config/kitty
ln -snf "$base_dir"/nvim ~/.config/nvim
ln -snf "$base_dir"/kitty ~/.config/kitty

# Install default local overrides if not already present
[ -f ~/.gitconfig-local ] || cp "$base_dir"/gitconfig-local.default ~/.gitconfig-local
[ -f "$base_dir"/kitty/local.conf ] || cp "$base_dir"/kitty/local.conf.default "$base_dir"/kitty/local.conf
[ -f ~/.zshrc.local ] || cp "$base_dir"/zsh/zshrc.local.default ~/.zshrc.local
[ -f ~/.zprofile.local ] || cp "$base_dir"/zsh/zprofile.local.default ~/.zprofile.local

mkdir -p ~/.local/share/applications
for desktop_file in "$base_dir"/applications/*.desktop; do
    ln -sf "$desktop_file" ~/.local/share/applications/"$(basename "$desktop_file")"
done
