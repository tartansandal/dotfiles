-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

--
-- Limit line length to 80-88 chars.
-- Black has some rationale for extending beyond 80
--
opt.textwidth = 88 -- Wrap at this column
opt.colorcolumn = "+1" -- Number of columns to highligh after textwidth
-- opt.wrap = false  -  Disable line wrapping

--
-- Indent 4 spaces - a consistent and common convention
--
opt.tabstop = 4 -- Indentation levels every four columns
opt.shiftwidth = 4 -- Indent/outdent by four columns
opt.shiftround = true -- Convert all tabs typed to spaces
opt.linebreak = true -- Wrap long lines at word boundaries

-- > same as sensible
opt.autoindent = true -- Preserve current indent on new lines
opt.backspace = "indent,eol,start" -- Make backspaces delete sensibly
opt.smarttab = true

--
-- Relative line numbers to encourage me to use line oriented motions more.
-- e.g., if my target line is has relative number 16, I can go there with 16j
-- The sneak plugin makes this redundant
-- set relativenumber       " Display relative line numbers
opt.number = true -- Display current linenumber

--
-- Automatic formating. The default is tcq. See 'help fo-table'
--
opt.formatoptions:append("j") -- Remove stray comment leaders when reformating
opt.formatoptions:append("c") -- Auto-wrap comment text using comment leader
opt.formatoptions:append("r") -- Auto insert the comment leader on Enter
opt.formatoptions:append("o") -- Insert the current comment leader after hitting 'o'
opt.formatoptions:append("q") -- Allow formatting of comments with "gq"
opt.formatoptions:append("l") -- Long lines are not broken in insert mode
opt.formatoptions:append("n") -- Recognize numbered lists
opt.formatoptions:append("t") -- Auto-wrap text using textwidth
opt.formatoptions:append("1") -- Don't break a line after a one-letter word.
opt.formatoptions:append("p") -- Don't break lines at single spaces that follow periods.

-- Allow virtual editing in visual block mode so we can form rectangles
opt.virtualedit = "block"

opt.spelllang = { "en_au" }

-- (sensible)
opt.autoread = true -- re-read open files when changed outside Vim
opt.autowrite = true -- write file whenever buffer becomes hidden
opt.browsedir = "current" -- which directory to use for the file browser

-- keep backups under ~/tmp  (this avoids the ususal problems with Coc)
opt.backup = true -- keep a backup file
opt.backupcopy = "yes" -- copy the original even if a link
opt.backupdir = "~/tmp/backup,~/,/tmp"

-- Markdown settings
vim.g.markdown_fenced_languages = { "python", "javascript" }
vim.g.markdown_folding = 1

-- set True color support for highlight groups
opt.termguicolors = true
