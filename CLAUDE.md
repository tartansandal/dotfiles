# CLAUDE.md

This file provides guidance to Claude Code when working with this dotfiles repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various development tools and shell environments. The repository is managed with Git and uses a `setup.sh` script to create symlinks from the home directory to the dotfiles.

## Repository Structure

```
dotfiles/
├── bash/           # Bash configuration (bashrc, profile)
├── bin/            # Personal scripts and utilities
├── nvim/           # Neovim configuration (LazyVim-based)
├── terminal/       # Terminal emulator configurations
├── gitconfig       # Git configuration
├── gitignore       # Global gitignore patterns
├── tmux.conf       # Tmux configuration
├── dircolors       # Directory colors for ls
├── direnvrc        # direnv configuration
├── inputrc         # Readline configuration
├── setup.sh        # Installation script that creates symlinks
└── README.md       # User-facing documentation
```

## Key Components

### Bash Configuration (`bash/`)

- **bashrc**: Interactive shell configuration with aliases, prompt customization, and tool integrations
- **profile**: Login shell configuration for environment variables (EDITOR, VISUAL, PATH, etc.)

Key features:
- Prefers `nvim` as EDITOR/VISUAL (falls back to vimx, then vim)
- Aliases for common tools (lg=lazygit, gg=gitui, docker=podman)
- Claude Code monitor aliases with `--plan max5` flag

### Neovim Configuration (`nvim/`)

The Neovim configuration is based on LazyVim and is extensively documented in its own `nvim/CLAUDE.md` file.

**IMPORTANT**: When working with Neovim configuration files, refer to `nvim/CLAUDE.md` for detailed architecture, plugin structure, conventions, and development guidance.

Quick summary:
- Built on LazyVim with custom plugin overrides
- Uses blink.cmp for completion with Copilot integration
- Catppuccin Mocha colorscheme with custom "decaf" variants
- Configured for Python, TypeScript, Markdown, and LaTeX development
- Obsidian.nvim integration for note-taking

### Git Configuration (`gitconfig`)

- Delta configured for side-by-side diffs with syntax highlighting
- Commented-out gitalias include (not currently used)
- Custom git settings (configuration details in the file itself)

### Installation (`setup.sh`)

The `setup.sh` script creates symlinks from `~/.config` and `~/` to files in this repository. It:
1. Creates necessary directories (`~/tmp/undo`, `~/tmp/backup`)
2. Symlinks shell configurations (bashrc, profile, etc.)
3. Symlinks tool configurations (gitconfig, tmux.conf, etc.)
4. Symlinks nvim configuration to `~/.config/nvim`

**Note**: Always update `setup.sh` when adding or removing configuration files to keep symlinks in sync.

## Development Guidelines

### Making Changes

1. **Configuration Files**: Edit files directly in the dotfiles repository (not the symlinked versions in `~/`)
2. **Shell Configurations**: Changes to bash files take effect after sourcing or starting a new shell
3. **Neovim**: Refer to `nvim/CLAUDE.md` for nvim-specific development guidelines
4. **Git**: Always test changes before committing, especially to `setup.sh`

### Commit Conventions

Based on recent commit history, this repository follows these patterns:
- Scope prefixes for categorized changes: `nvim:`, `bash:`, `gitconfig:`, etc.
- Concise, imperative commit messages
- Logical grouping of related changes into separate commits
- No Claude attribution in commit messages (per user preference)

Examples:
- `nvim: Add sidekick.nvim plugin configuration`
- `bash: Add aliases for claude-code-monitor commands with max5 plan`
- `Remove unused configuration files`

### File Management

- **Unused configs**: Remove from both repository and `setup.sh`, check for dangling symlinks
- **Legacy tools**: This repository has been cleaned of Perl, Ruby, and old Vim configurations
- **New configs**: Add to repository, update `setup.sh`, test symlink creation

## Tool Preferences

Current tool stack based on repository contents:
- **Shell**: Bash (no zsh configuration present)
- **Editor**: Neovim (vim configuration removed)
- **Git UI**: lazygit, gitui
- **Containers**: podman (aliased as docker)
- **Terminal**: Configuration in `terminal/` directory
- **Python**: Using `uv` as package manager (per user's global instructions)
- **Version Control**: Git with delta for diffs

## Important Notes

- **No pre-commit hooks currently configured** - but run any existing pre-commit checks if they exist
- **Python projects**: Use `uv` for package management (pyproject.toml, uv sync, uv run)
- **Neovim**: See `nvim/CLAUDE.md` for extensive nvim-specific guidance
- **Symlinks**: Always verify symlink integrity after removing configuration files

## Related Documentation

- `nvim/CLAUDE.md` - Comprehensive Neovim configuration documentation
- `README.md` - User-facing installation and overview documentation
