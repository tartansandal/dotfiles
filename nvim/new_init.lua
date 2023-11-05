-- [[ Options ]]

local set = vim.opt

--
-- Limit line length to 80-88 chars.
-- Black has some rationale for extending beyond 80
--
set.textwidth = 88     -- Wrap at this column
set.colorcolumn = "+1" -- Number of columns to highligh after textwidth

--
-- Indent 4 spaces - a consistent and common convention
--
set.tabstop = 4       -- Indentation levels every four columns
set.shiftwidth = 4    -- Indent/outdent by four columns
set.shiftround = true -- Convert all tabs typed to spaces
set.linebreak = true  -- Wrap long lines at word boundaries

-- > same as sensible
set.autoindent = true              -- Preserve current indent on new lines
set.backspace = "indent,eol,start" -- Make backspaces delete sensibly
set.smarttab = true

--
-- Relative line numbers to encourage me to use line oriented motions more.
-- e.g., if my target line is has relative number 16, I can go there with 16j
-- The sneak plugin makes this redundant
-- set relativenumber       " Display relative line numbers
set.number = true -- Display current linenumber

--
-- Automatic formating. The default is tcq. See 'help fo-table'
--
set.formatoptions:append("t") -- Auto-wrap text using textwidth
set.formatoptions:append("c") -- Auto-wrap comment text using comment leader
set.formatoptions:append("q") -- Allow formatting of comments with "gq"
set.formatoptions:append("o") -- Insert the current comment leader after hitting 'o'
set.formatoptions:append("n") -- Recognize numbered lists
set.formatoptions:append("l") -- Long lines are not broken in insert mode
set.formatoptions:append("1") -- Don't break a line after a one-letter word.
set.formatoptions:append("j") -- Remove stray comment leaders when reformating
set.formatoptions:append("p") -- Don't break lines at single spaces that follow periods.


-- Allow virtual editing in visual block mode so we can form rectangles
set.virtualedit = "block"

set.spelllang = "en_au"

-- (sensible)
set.autoread = true       -- re-read open files when changed outside Vim
set.autowrite = true      -- write file whenever buffer becomes hidden
set.browsedir = "current" -- which directory to use for the file browser

-- keep backups under ~/tmp  (this avoids the ususal problems with Coc)
set.backup = true      -- keep a backup file
set.backupcopy = "yes" -- copy the original even if a link
set.backupdir = "~/tmp/backup,~/,/tmp"

-- set.markdown_fenced_languages = {"python", "javascript"}
-- set.markdown_folding = 1

