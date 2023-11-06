# Notes on Neovim configuration

This is in a markdown file.

API so its picking up my spelling files

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

- Most unimpaired things work

  - `q`: quickfix
  - `d`: diagnostics
  - `e`: errors
  - `w`: warnings

- Code
  - Go to ..
    - `gd` definition
    - `gr` references
    - `K` hover doc
    - `gK` signature help
    - ...
  - `<space>cf`: code format
  - `<space>cr`: code rename
  - `<space>ca`: code action
  - `<space>cA`: source action

## TODO

- Formatters
- Python
  - ruff
  - black
- Telescope?
- Spelling for completions
- Cut/Copy in `NeoTree`
- Open URL in browser?
- Text objects, Indent Objects?
- Tweaking the color scheme
- Ariel for code outline
- Running tests in Docker?
- `EasyAlign?`
- `Spectre` instead of `enmasse`
- `Zeavim?`
- `localvimrc`
