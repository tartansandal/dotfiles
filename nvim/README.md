# Notes on Neovim configuration

Need to make this a similar to my Vim setup

## Differences

- `NeoTree` for file explorer

  - `<space e>` to toggle
  - `>` to change between source: files, git, buffers
  - `?` to see many commands

- Telescope for file/search/lookup

  - `<leader ss>` for symbol search

- Markdown

  - Nice conceal support for markdown

- Buffer switching

  - `<space><backtick>` for switching to alternate buffer
  - `<space>,` for buffer switching. Defaults to alternate buffer

- Snippets are controlled by LSP

- Deleting buffers

  - `<space>bd`
  - `<bd>` inside `NeoTree` buffer source

- Deleting surrounding marks

  - Got to be fast to avoid `flash` and `which`
  - Different mnemonics
    - add: `gsa`
    - delete: `gsd`
    - replace: `gsr`

- Flash for quick motions

  - `s`: start flash jump
  - `S`: start tree-sitter jump

- UI tricks

  - `<esc>`: escape and clear search highlighting
  - `<space>ur`: redraw, clear search highlighting
  - `<space>un`: dismiss notifications
  - `<space>uC`: choose colorscheme
  - Toggles
    - `<space>uf`: toggle autoformat
    - `<space>us`: toggle spelling
    - `<space>us`: toggle diagnostics
    - `<space>uc`: toggle conceal

- Windows: `<space>w`...

  - ...`w`: other window
  - ...`d`: delete window
  - ...`-`: split below
  - ...`|`: split right
  - `<space>-`: split below
  - `<space>|`: split right

- Most unimpaired things work: `[,]`..

  - `q`: quickfix
  - `d`: diagnostics
  - `e`: errors
  - `w`: warnings
  - `<space>`: empty lines

- Source Code

  - Go to `g` ..
    - `gd` definition
    - `gr` references
    - ..
  - Docs
    - `K` hover doc
    - `gK` signature help
  - Code: `<space>c`...
  - ...`f`: code format
  - ...`r`: code rename
  - ...`a`: code action
  - ...`d`: code line diagnostics

* Use `gw` for formatting comments in code, skipping the format expression.

- git: `<space>g`

  - ...`g`: `lazygit`
  - ...`s`: git status (Telescope)
  - ...`c`: git commits (Telescope)
  - ...`c`: git explorer (NeoTree)
  - git-signs: ...`h`...
    - ...`b`: blame

- Use flash for most motions
- Telescope starts in insert mode. Enter `<esc>`once to enter normal mode.

* Completion via

  - vim-cmp
  - cmp-lsp

* tree-sitter
  - `C-space` to increase TS selection

## TODO

- Obsidian mode?
  <https://github.com/epwalsh/obsidian.nvim>

- Running tests in Docker?
- `EasyAlign?`
- `Spectre` instead of `onmasse`
- `Zeavim?`
- `localvimrc`
- [DevDocs](https://neovimcraft.com/plugin/luckasRanarison/nvim-devdocs)
