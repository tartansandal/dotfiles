# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration built on top of LazyVim, a pre-configured Neovim distribution. The configuration is located in a dotfiles repository and uses lazy.nvim as its plugin manager.

## Architecture

### Initialization Flow

1. `init.lua` - Entry point that bootstraps lazy.nvim and sets up debug utilities (_G.dd, _G.bt)
2. `lua/config/lazy.lua` - Configures lazy.nvim plugin manager and loads LazyVim base + custom plugins
3. `lua/config/options.lua` - Sets vim options (loaded before lazy.nvim startup)
4. `lua/config/keymaps.lua` - Defines custom keymaps (loaded on VeryLazy event)
5. `lua/config/autocmds.lua` - Defines autocmds (loaded on VeryLazy event)

### Plugin Structure

All custom plugins live in `lua/plugins/*.lua`. Each file returns a table of plugin specifications that lazy.nvim processes. The plugin system follows LazyVim's convention where:

- Each plugin file can return multiple plugin specs
- Plugin specs can override/extend LazyVim defaults using the same plugin name
- Plugins can be disabled by setting `enabled = false`

### Key Plugin Decisions

**Disabled plugins** (`lua/plugins/disabled.lua`):
- bufferline (tabline)
- mini.indentscope
- indent-blankline
- vim-illuminate (word highlighting)
- tokyonight (colorscheme)
- nvim-spectre (search/replace)

**Core customizations**:
- **Completion**: blink.cmp instead of nvim-cmp, with copilot integration
- **Colorscheme**: Catppuccin Mocha with custom "decaf" color overrides (darkened variants)
- **File picker**: Snacks picker (recently switched from Telescope per git history)
- **File explorer**: NeoTree (Snacks explorer disabled, mini.files removed)
- **Formatting**: conform.nvim with stylua, shfmt, ruff_format, sqlfmt
- **LSP**: Pyright with typeCheckingMode "on", rounded borders throughout
- **AI**: GitHub Copilot + Copilot Chat (sidekick)

## LazyVim Extras

The following LazyVim extras are enabled (see `lazyvim.json`):
- AI: copilot, sidekick
- Coding: mini-comment, mini-surround, yanky
- DAP: core debugging
- Editor: dial, inc-rename, outline, snacks explorer/picker
- Formatting: prettier
- Languages: cmake, docker, json, markdown, python, tex, toml, typescript
- Testing: core
- Utils: dot, mini-hipatterns

## Development Commands

### Formatting
```bash
# Format Lua files
stylua lua/
```

Configuration in `stylua.toml`:
- 2 spaces indentation
- 88 column width

### Plugin Management

```vim
:Lazy         " Open lazy.nvim UI
:Lazy sync    " Update plugins and run pending operations
:Lazy clean   " Remove unused plugins
:Lazy check   " Check for updates
```

### LSP/Mason

```vim
:Mason        " Open Mason UI to manage LSP servers/formatters
:LspInfo      " Show LSP client status
```

## Configuration Conventions

### Options (`lua/config/options.lua`)
- **Indentation**: 4 spaces (tabstop=4, shiftwidth=4)
- **Line width**: 88 chars (textwidth=88, colorcolumn="+1")
- **Line numbers**: Disabled (both absolute and relative)
- **Backups/undo**: Stored in ~/tmp/backup and ~/tmp/undo
- **Clipboard**: Uses xsel (not wl-clipboard due to yanky compatibility)
- **Concealment**: Level 2 (markdown compatibility)
- **Spell language**: en_au

### Keymaps (`lua/config/keymaps.lua`)

Custom keymaps beyond LazyVim defaults:
- `[<space>` / `]<space>` - Insert blank lines above/below (supports count)
- `<leader>wo` - Close other windows
- `<leader>bp` - Copy relative path of current buffer
- `<leader>bP` - Copy absolute path of current buffer
- `<leader>b/` - CD to current buffer's directory

### Plugin Configuration Patterns

When configuring plugins:

1. **Return a table** from each `lua/plugins/*.lua` file
2. **Use `opts` for simple config** - lazy.nvim calls plugin's setup() with these
3. **Use `opts` as a function** for extending LazyVim defaults:
   ```lua
   opts = function(_, opts)
     -- Modify opts table
     opts.foo = "bar"
   end
   ```
4. **UI borders**: This config prefers "rounded" borders throughout (see lsp.lua, blink.lua)

## Special Features

### Custom Debug Utilities

Global debug functions defined in `init.lua`:
- `dd(...)` - Pretty-print inspect values (overrides vim.print)
- `bt()` - Show backtrace

### Catppuccin Decaf Colors

The `lua/plugins/colorscheme.lua` file implements custom "decaf" variants of all Catppuccin flavors by darkening the palettes. It also includes a `make_term_palette()` utility to generate Ptyxis terminal palette definitions.

### Blink.cmp Customizations

- **Manual completion**: No preselection or auto-insert (requires explicit selection)
- **Case-preserving buffer completion**: Matches first character case of typed text
- **Source priority**: Copilot prioritized (score_offset 100), emoji in markdown only
- **Keymap preset**: "enter" (CR to accept, Tab/S-Tab for snippets and selection)
- **No auto-brackets**: Disabled experimental feature

## Filetype-Specific Configuration

The configuration uses two directories for filetype-specific settings:

### `ftplugin/` Directory
Contains legacy filetype settings (mostly from old Vim config):
- `python.vim` - textwidth=88, foldmethod=indent
- `json.vim`, `css.vim`, `javascript.vim`, `vue.vim`, `yaml.vim`, `sh.vim` - Various settings

### `after/ftplugin/` Directory
Contains Neovim-specific filetype overrides (loaded after plugins):
- `markdown.lua` - 2-space indent, soft-wrap, markdown-specific surround keymaps, spell fix shortcuts
- `lua.vim` - 2-space indent, textwidth=88
- `tex.vim` - vimtex okular integration

**Note**: Settings in `after/ftplugin/` take precedence over `ftplugin/` and plugin defaults.

## Important Notes

- LazyVim automatically lazy-loads its own plugins but custom plugins load at startup by default (see `defaults.lazy = false` in lazy.lua)
- The config uses Snacks.nvim for many UI components (picker, lazygit, indent, bigfile)
- **File explorer**: NeoTree with custom `<tab>` mapping to open and reveal
- Git operations use lazygit integration via Snacks
- No line numbers displayed (user preference to encourage motion-based navigation)
