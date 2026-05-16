# Dotfiles

Personal configuration files for customizing my development environment.

## Overview

This repository contains configuration files (dotfiles) supporting two platforms:

- **Linux (Fedora)**: `bash` shell
- **macOS (Mac Air)**: `zsh` shell

Configurations include:

- **Shell**: `bash` and `zsh` with shared aliases, `starship` prompt
- **Editor**: `neovim` (`LazyVim`-based configuration)
- **Git**: Configuration and global ignore patterns
- **Terminal**: `kitty` (terminal emulator), `tmux` (multiplexer)
- **Tools**: `direnv`, `readline`, `local-bin-install`, and various CLI utilities

## Installation

Clone the repository:

```bash
git clone https://github.com/tartansandal/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Run the setup script to create symlinks:

```bash
./setup.sh
```

The setup script will:

- Create necessary directories (`~/tmp/undo`, `~/tmp/backup`)
- Symlink configuration files from `~/dotfiles` to your home directory
- Symlink `neovim` configuration to `~/.config/nvim`

## What's Included

### Shell

Both shells share common aliases and helpers via `shell/aliases` (`eza`-based `ls`, `lazygit`, `nvim`, `direnv`, `kitty` SSH).

**Bash** (Linux):
- `starship` prompt, `fzf` keybindings, vi mode
- `podman` aliased as `docker`
- **Files**: `bash/bashrc`, `bash/profile`

**Zsh** (macOS):
- `starship` prompt, `fzf` integration, vi mode
- PATH deduplication via `typeset -U`
- **Files**: `zsh/zshrc`, `zsh/zprofile`

### Neovim

`LazyVim`-based configuration with:

- `Blink.cmp` for completion
- GitHub Copilot integration
- Language support: Python, TypeScript, Markdown, LaTeX
- `Obsidian.nvim` for note-taking
- Custom colorscheme (Catppuccin with "decaf" variants)

**Location**: `nvim/` (symlinked to `~/.config/nvim`)

### Git

- `delta` for enhanced diffs (side-by-side, syntax highlighting)
- Global `gitignore` patterns
- Custom git configuration

**Files**: `gitconfig`, `gitignore`

### Kitty

Terminal emulator configuration with custom Catppuccin themes:

- Catppuccin Mocha Decaf (darkened variant matching `neovim` theme)
- Catppuccin Mocha (standard variant)
- Custom font settings

**Location**: `kitty/` (symlinked to `~/.config/kitty`)

### Portable Tool Installer

`bin/local-bin-install` fetches prebuilt CLI tools into `~/.local/bin` for unprivileged Linux hosts (no root needed). Supports: `nvim`, `node`, `rg`, `fd`, `eza`, `fzf`, `lazygit`, `delta`, `tree-sitter`, `starship`, `uv`.

### Other Tools

- **`tmux`**: Terminal multiplexer configuration (`tmux.conf`)
- **`direnv`**: Environment switcher (`direnvrc`)
- **`readline`**: Input configuration (`inputrc`)
- **`dircolors`**: Custom `ls` colours (`dircolors`)

## Requirements

Core tools used by these configurations:

- **`bash`** / **`zsh`** - Shell (platform-dependent)
- **`neovim`** - Text editor (>= 0.9.0)
- **`git`** - Version control
- **`kitty`** - Terminal emulator
- **`tmux`** - Terminal multiplexer
- **`starship`** - Cross-shell prompt
- **`delta`** - Git `diff` viewer
- **`direnv`** - Environment management
- **`fzf`** - Fuzzy finder
- **`fd`** - Fast file finder
- **`rg`** (`ripgrep`) - Fast text search
- **`eza`** - Modern `ls` replacement

Optional but recommended:

- **`lazygit`** - Git TUI
- **`podman`** - Container management (Linux)
- **`uv`** - Python package manager
- **`stylua`** - Lua formatter
- **`ruff`** - Python linter/formatter

## Directory Structure

```
dotfiles/
├── bash/           Bash configuration (Linux)
├── zsh/            Zsh configuration (macOS)
├── shell/          Shared aliases and helpers
├── bin/            Personal scripts and local-bin-install
├── nvim/           Neovim configuration (LazyVim)
├── kitty/          Kitty terminal emulator configuration
├── applications/   .desktop files (Linux)
├── laptop/         Fedora package lists
├── mac-air/        macOS Homebrew package lists
├── MOK/            Secure Boot module signing scripts
├── terminal/       Legacy terminal emulator configs
├── gitconfig       Git configuration
├── gitignore       Global gitignore
├── tmux.conf       Tmux configuration
├── dircolors       LS_COLORS configuration
├── direnvrc        direnv configuration
├── inputrc         Readline configuration
├── setup.sh        Installation script
└── CLAUDE.md       Claude Code guidance
```

## Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull
```

If new files were added, run `./setup.sh` again to create new symlinks.

## Customization

Feel free to fork and customize for your own use. Key files to modify:

- `shell/aliases` - Shared shell aliases and helpers
- `bash/bashrc` / `zsh/zshrc` - Platform-specific shell configuration
- `nvim/lua/config/` - Neovim options and keymaps
- `nvim/lua/plugins/` - Neovim plugin configurations
- `gitconfig` - Git settings

## License

These are personal configuration files. Use at your own risk.

## Notes

- Linux configurations target Fedora; macOS configurations target a Mac Air with Homebrew
- `neovim` configuration requires `neovim` >= 0.9.0
- On unprivileged Linux hosts, `bin/local-bin-install` can bootstrap most tools without root
- Old `vim` configuration has been removed (`neovim` only)
