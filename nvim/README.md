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
- buffer switching

- `<space ,>` for buffer switching. Defaults to alternate buffer
- `<space backtick>` for switching to alternate buffer

- Snippets are controlled by LSP
- Deleting buffers

  - `<space bd>`
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

## TODO

- Telescope?
- Spelling for completions
- Python ruff?
- Cut/Copy in `NeoTree`
- Open URL in browser?
- Text objects, Indent Objects?
- `pyright`?
- Tweaking the color scheme
- Ariel for code outline
- Running tests in Docker?
- `EasyAlign?`
- `Spectre` instead of `enmasse`
- `Zeavim?`
- `localvimrc`
