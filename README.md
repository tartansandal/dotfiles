# Dotfiles

Personal configuration files for customizing my development environment.

## Overview

This repository contains configuration files (dotfiles) for:

- **Shell**: `bash` configuration with custom aliases and prompt
- **Editor**: `neovim` (`LazyVim`-based configuration)
- **Git**: Configuration and global ignore patterns
- **Terminal**: `tmux`, terminal emulator settings
- **Tools**: `direnv`, `readline`, and various CLI utilities

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

### Shell (Bash)

- Custom prompt and aliases
- Environment variables configuration
- Tool integrations (`git`, `lazygit`, `nvim`, `direnv`)
- `podman` aliased as `docker`

**Files**: `bash/bashrc`, `bash/profile`

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

### Other Tools

- **`tmux`**: Terminal multiplexer configuration (`tmux.conf`)
- **`direnv`**: Environment switcher (`direnvrc`)
- **`readline`**: Input configuration (`inputrc`)
- **`dircolors`**: Custom `ls` colours (`dircolors`)

## Requirements

Core tools used by these configurations:

- **`bash`** - Shell
- **`neovim`** - Text editor (>= 0.9.0)
- **`git`** - Version control
- **`tmux`** - Terminal multiplexer
- **`delta`** - Git `diff` viewer
- **`direnv`** - Environment management

Optional but recommended:

- **`lazygit`** - Git TUI
- **`gitui`** - Alternative Git TUI
- **`podman`** - Container management
- **`uv`** - Python package manager
- **`stylua`** - Lua formatter
- **`ruff`** - Python linter/formatter

## Directory Structure

```
dotfiles/
├── bash/           Shell configuration
├── bin/            Personal scripts
├── nvim/           Neovim configuration
├── terminal/       Terminal emulator configs
├── gitconfig       Git configuration
├── gitignore       Global gitignore
├── tmux.conf       Tmux configuration
├── dircolors       LS_COLORS configuration
├── direnvrc        direnv configuration
├── inputrc         Readline configuration
├── setup.sh        Installation script
├── CLAUDE.md       Claude Code guidance
└── README.md       This file
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

- `bash/bashrc` - Shell aliases and functions
- `bash/profile` - Environment variables
- `nvim/lua/config/` - Neovim options and keymaps
- `nvim/lua/plugins/` - Neovim plugin configurations
- `gitconfig` - Git settings

## License

These are personal configuration files. Use at your own risk.

## Notes

- These dotfiles assume a Linux environment (Fedora/RHEL-based)
- `neovim` configuration requires `neovim` >= 0.9.0
- Some features may require additional tool installation
- Old `vim` configuration has been removed (`neovim` only)
