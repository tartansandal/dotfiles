# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository supporting two platforms:
- **Linux (Fedora)**: Bash shell, managed via `laptop/packages-install`
- **macOS (Mac Air)**: Zsh shell, managed via Homebrew (`mac-air/`)

`setup.sh` creates symlinks from `~/.config` and `~/` into this repository. Always update `setup.sh` when adding or removing configuration files.

## Architecture

The repo is organized by tool, with platform-specific directories for package management:

- `bash/`, `zsh/` — Shell configurations (both are symlinked by `setup.sh`)
- `nvim/` — Neovim (LazyVim-based), has its own `nvim/CLAUDE.md` with detailed guidance
- `kitty/` — Terminal emulator config with Catppuccin Mocha Decaf theme
- `laptop/` — Fedora package lists
- `mac-air/` — macOS Homebrew package lists and setup notes
- `bin/` — Personal scripts (symlinked as `~/bin`)
- `applications/` — `.desktop` files (symlinked to `~/.local/share/applications/`)
- `MOK/` — Machine Owner Key scripts for Secure Boot module signing
- `vim/` — Legacy Vim config (not symlinked, kept for reference)

**When working on Neovim configuration, always refer to `nvim/CLAUDE.md`** for architecture, plugin structure, and conventions.

## Commit Conventions

- **Scope prefixes**: `nvim:`, `bash:`, `zsh:`, `kitty:`, `laptop:`, `mac-air:`, `gitconfig:`, etc.
- **Imperative mood**, concise messages
- Group related changes into separate atomic commits

Examples from recent history:
- `zsh: add eza-based ls aliases`
- `laptop: add eza to packages-install`
- `nvim: add spell dictionary entries`
- `Remove unused configuration files`

## Key Relationships

- Catppuccin Mocha Decaf theme is shared across `kitty/` and `nvim/` — color changes should be coordinated
- `setup.sh` is the source of truth for what gets symlinked — if a file isn't in `setup.sh`, it won't be deployed
- Spell dictionary changes require both `nvim/spell/en.utf-8.add` (text) and the compiled `.spl` file
- `bash/` and `zsh/` share similar aliases but are maintained independently for each platform
