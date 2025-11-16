# Bash Configuration

This directory contains modular bash configuration files.

## Files

- **bashrc** - Interactive shell configuration (aliases, shell options, completions)
- **profile** - Environment variables and PATH setup (sourced by .bash_profile)
- **prompt** - PS1 prompt setup, uses promptline.sh
- **promptline.sh** - Git-aware prompt generator script
- **direnv** - direnv integration and virtual environment display
- **fzf** - FZF fuzzy finder integration
- **hosts** - Host-specific SSH/tunneling functions

## Installation

Symlink the main files to your home directory:
```bash
ln -s ~/dotfiles/bash/profile ~/.bash_profile
ln -s ~/dotfiles/bash/bashrc ~/.bashrc
```

## promptline.sh

The `promptline.sh` script generates git-aware status lines for bash prompts.

**Usage in bash:**
```bash
PS1='$(~/dotfiles/bash/promptline.sh "$PWD")\n\$ '
```

**Usage in Claude Code:**  
Update `~/.claude/.claude/settings.local.json` to reference:
```
/home/kal/dotfiles/bash/promptline.sh
```

See `promptline.sh --help` for more information.
